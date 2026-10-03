"""Execution window HTTP contracts over synthetic databases and transport."""
from contextlib import closing
import json
import unittest
from unittest.mock import patch

import test_weekly_scheduler_http as fixtures


class ScheduleWindowHttpTests(unittest.TestCase):
    def setUp(self):
        self.fixture = fixtures.WeeklyScheduleHttpTests()
        self.fixture.setUp()
        self.addCleanup(self.fixture.doCleanups)
        self.f, self.scheduler = self.fixture.f, self.fixture.scheduler

    def create(self, **changes):
        return self.fixture.request('POST', '/api/jobs', self.fixture.data(**changes))

    def test_window_capability_persistence_and_request_identity(self):
        code, state = self.fixture.request('GET', '/api/state')
        self.assertEqual(code, 200)
        self.assertIs(state['runtime']['capabilities']['scheduleWindows'], True)
        code, job = self.create(windowMinutes=15)
        self.assertEqual((code, job['windowMinutes']), (201, 15))
        with closing(self.scheduler._db()) as db:
            saved = json.loads(db.execute('SELECT payload FROM schedules').fetchone()[0])
        self.assertEqual(saved['windowMinutes'], 15)
        self.assertEqual(saved['spec']['windowMinutes'], 15)
        self.assertEqual(self.fixture.request('GET', '/api/state')[1]['jobs'], [job])
        self.assertEqual(self.create(windowMinutes=15)[1]['id'], job['id'])
        self.assertEqual(self.create(windowMinutes=30)[0], 400)
        self.assertEqual(self.create()[0], 400)
        self.assertEqual(len(self.scheduler.list(self.f.account)), 1)
        self.f.engine.windows_scheduler = None
        self.assertIs(self.fixture.request('GET', '/api/state')[1]['runtime']['capabilities']['scheduleWindows'], False)
        self.assertEqual(self.f.posts, [])

    def test_legacy_default_and_custom_window_survive_restart_without_resuming(self):
        code, legacy = self.create()
        self.assertEqual((code, legacy['windowMinutes']), (201, 2))
        self.assertEqual(self.create(windowMinutes=2)[1]['id'], legacy['id'])
        with closing(self.scheduler._db()) as db:
            saved = json.loads(db.execute('SELECT payload FROM schedules').fetchone()[0])
        self.assertNotIn('windowMinutes', saved)
        self.assertNotIn('windowMinutes', saved['spec'])
        code, custom = self.create(requestId='synthetic-window-custom', windowMinutes=1439)
        self.assertEqual((code, custom['windowMinutes']), (201, 1439))
        self.scheduler = self.fixture.new_scheduler()
        self.f.engine.windows_scheduler = self.scheduler
        code, jobs = self.fixture.request('GET', '/api/state')
        self.assertEqual(code, 200)
        by_id = {job['id']: job for job in jobs['jobs']}
        self.assertEqual(by_id[legacy['id']]['windowMinutes'], 2)
        self.assertEqual(by_id[custom['id']]['windowMinutes'], 1439)
        self.assertTrue(all(job['state']=='paused' and not job['enabled'] for job in by_id.values()))
        self.assertEqual(self.create(windowMinutes=2)[1]['id'], legacy['id'])
        self.assertFalse(self.create(requestId='synthetic-window-custom', windowMinutes=1439)[1]['enabled'])
        self.assertEqual(self.f.posts, [])

    def test_window_validation_and_permissions_precede_any_hook_contact(self):
        with patch.object(self.scheduler, 'sender_factory', side_effect=AssertionError('Must not contact Hook')):
            for value in (None, True, False, 0, -1, 1440, 2.5, '2', [], {}):
                with self.subTest(windowMinutes=value):
                    self.assertEqual(self.create(windowMinutes=value)[0], 400)
            for headers in ({'Origin': 'https://untrusted.invalid'}, {'X-CSRF-Token': ''}, {'Host': 'untrusted.invalid'}):
                with self.subTest(headers=headers):
                    code, _ = self.fixture.request('POST', '/api/jobs', self.fixture.data(windowMinutes=15), **headers)
                    self.assertEqual(code, 403)
        self.assertEqual(self.scheduler.list(self.f.account), [])
        self.assertEqual(self.f.posts, [])

    def test_http_created_window_controls_actual_scheduler_submission(self):
        code, job = self.create(windowMinutes=5, deadline=10**20)
        self.assertEqual(code, 201)
        self.f.now = job['nextRun'] + 180
        self.scheduler.tick()
        code, snapshot = self.fixture.request('GET', '/api/state')
        self.assertEqual(code, 200)
        current = snapshot['jobs'][0]
        self.assertEqual(current['windowMinutes'], 5)
        self.assertEqual(current['runs'][0]['status'], 'submitted_unconfirmed')
        self.assertEqual(len(self.f.posts), 1)
        self.f.now = current['nextRun'] + 301
        self.scheduler.tick()
        missed = self.fixture.request('GET', '/api/state')[1]['jobs'][0]
        self.assertEqual(missed['runs'][0]['status'], 'missed')
        self.assertNotIn('2 分钟', missed['runs'][0]['label'])
        self.assertTrue(missed['enabled'])
        self.scheduler.tick()
        self.assertEqual(len(self.f.posts), 1)


if __name__ == '__main__':
    unittest.main()
