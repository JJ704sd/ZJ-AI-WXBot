"""Bulk pause HTTP contracts; synthetic snapshots and recording transport only."""
from contextlib import closing
import json
import unittest
from unittest.mock import patch

from test_database_adapter import MIXED
import test_weekly_scheduler_http as fixtures


class SchedulePauseHttpTests(unittest.TestCase):
    def setUp(self):
        self.fixture = fixtures.WeeklyScheduleHttpTests()
        self.fixture.setUp()
        self.addCleanup(self.fixture.doCleanups)
        self.f = self.fixture.f
        self.scheduler = self.fixture.scheduler
        self.f.engine.set_watched(self.f.account, [self.f.group, MIXED])

    def create(self, key, group=None):
        code, job = self.fixture.request('POST', '/api/jobs', self.fixture.data(
            requestId='synthetic-pause-request-'+key, groupId=group or self.f.group))
        self.assertEqual(code, 201)
        return job

    def pause(self, **changes):
        return self.fixture.request('POST', '/api/jobs/pause-all', {'account': self.f.account, **changes})

    def test_group_then_account_pause_returns_committed_jobs_without_hook(self):
        first = self.create('first')
        prior = self.create('already-paused')
        other = self.create('other-group', MIXED)
        code, prior = self.fixture.request('POST', '/api/jobs/pause',
            {'account': self.f.account, 'id': prior['id']})
        self.assertEqual(code, 200)
        self.f.service.configure(self.f.account, self.f.group, True, '', 30, mode='handoff')
        with patch.object(self.scheduler, 'sender_factory', side_effect=AssertionError('Must not contact Hook')):
            code, result = self.pause(groupId=self.f.group)
            self.assertEqual(code, 200)
            self.assertEqual(result['pausedCount'], 1)
            jobs = {job['id']: job for job in result['jobs']}
            self.assertIs(jobs[first['id']]['enabled'], False)
            self.assertEqual(jobs[first['id']]['state'], 'paused')
            self.assertEqual(jobs[first['id']]['nextRun'], first['nextRun'])
            self.assertEqual(jobs[prior['id']], prior)
            self.assertEqual(jobs[other['id']], other)
            self.assertEqual(self.fixture.request('GET', '/api/state')[1]['jobs'], result['jobs'])
            self.assertEqual(self.pause(groupId=self.f.group)[1]['pausedCount'], 0)
            # Stopping existing tasks must remain possible during a source fault.
            self.f.source.busy = True
            self.f.source.error = 'synthetic unavailable source'
            self.f.engine.connection = {'status': 'snapshot_error'}
            self.f.ready = False
            code, result = self.pause()
            self.assertEqual((code, result['pausedCount']), (200, 1))
        self.assertTrue(all(job['state']=='paused' for job in result['jobs']))
        self.assertTrue(self.f.service.get(self.f.account, self.f.group)['enabled'])
        self.assertNotIn(str(self.f.root), json.dumps(result))
        self.assertEqual(self.f.posts, [])

    def test_scope_and_http_permissions_reject_ambiguous_bulk_requests(self):
        job = self.create('protected')
        with patch.object(self.scheduler, 'sender_factory', side_effect=AssertionError('Must not contact Hook')):
            for changes in ({'account': 'wrong'}, {'account': None}, {'groupId': None},
                            {'groupId': False}, {'groupId': []}, {'groupId': {}}, {'groupId': 'x'*257}):
                with self.subTest(changes=changes):
                    self.assertEqual(self.pause(**changes)[0], 400)
            for headers in ({'Origin': 'https://untrusted.invalid'}, {'X-CSRF-Token': ''},
                            {'Host': 'untrusted.invalid'}):
                with self.subTest(headers=headers):
                    code, _ = self.fixture.request('POST', '/api/jobs/pause-all',
                        {'account': self.f.account}, **headers)
                    self.assertEqual(code, 403)
            code, result = self.pause(groupId='nonexistent@chatroom')
            self.assertEqual((code, result['pausedCount']), (200, 0))
        self.assertEqual(self.scheduler.list(self.f.account), [job])
        self.assertEqual(self.f.posts, [])

    def test_database_failure_is_not_a_successful_pause_and_explicit_retry_works(self):
        self.create('one')
        second = self.create('two')
        before = self.scheduler.list(self.f.account)
        with closing(self.scheduler._db()) as db, db:
            db.execute(f"""CREATE TRIGGER fail_pause BEFORE UPDATE ON schedules
                WHEN NEW.id='{second['id']}'
                BEGIN SELECT RAISE(FAIL, 'PRIVATE_SYNTHETIC_PAUSE_FAILURE'); END""")
        code, result = self.pause()
        self.assertEqual(code, 500)
        self.assertNotIn('PRIVATE_SYNTHETIC_PAUSE_FAILURE', json.dumps(result))
        self.assertEqual(self.scheduler.list(self.f.account), before)
        with closing(self.scheduler._db()) as db, db:
            db.execute('DROP TRIGGER fail_pause')
        code, result = self.pause()
        self.assertEqual((code, result['pausedCount']), (200, 2))
        self.assertTrue(all(not job['enabled'] for job in result['jobs']))
        self.assertEqual(self.f.posts, [])


if __name__ == '__main__':
    unittest.main()
