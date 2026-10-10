"""Schedule windows with a synthetic clock, SQLite and recording Hook transport."""
from contextlib import closing
from datetime import datetime
import json
import sqlite3
import unittest
from unittest.mock import patch

from runtime_support import runtime_summary
import test_windows_scheduler as fixtures
from windows_scheduler import BEIJING


class ScheduleWindowTests(unittest.TestCase):
    def setUp(self):
        self.f = fixtures.SchedulerTests()
        self.f.setUp()
        self.addCleanup(self.f.doCleanups)
        self.scheduler, self.state = self.f.scheduler, self.f.f

    def create(self, **changes):
        return self.scheduler.create(self.f.data(**changes))

    def job(self):
        return self.scheduler.list(self.state.account)[0]

    def saved(self):
        with closing(sqlite3.connect(self.scheduler.path)) as db:
            return json.loads(db.execute('SELECT payload FROM schedules').fetchone()[0])

    def test_default_and_explicit_two_minutes_keep_legacy_idempotency_spec(self):
        created = self.create()
        self.assertEqual(created['windowMinutes'], 2)
        self.assertNotIn('windowMinutes', self.saved())
        self.assertNotIn('windowMinutes', self.saved()['spec'])
        self.assertEqual(self.create(windowMinutes=2), created)
        with self.assertRaisesRegex(ValueError, '其他任务'):
            self.create(windowMinutes=3)

    def test_nondefault_window_persists_in_job_and_request_contract(self):
        created = self.create(windowMinutes=1439)
        self.assertEqual(created['windowMinutes'], 1439)
        self.assertEqual(self.saved()['windowMinutes'], 1439)
        self.assertEqual(self.saved()['spec']['windowMinutes'], 1439)
        self.assertEqual(self.create(windowMinutes=1439), created)
        with self.assertRaisesRegex(ValueError, '其他任务'):
            self.create()

    def test_invalid_window_is_rejected_before_sender_probe(self):
        with patch.object(self.scheduler, 'sender_factory', side_effect=AssertionError('invalid input must not probe')):
            for value in (True, False, None, 0, -1, 1440, 2.0, '2', []):
                with self.subTest(value=value), self.assertRaisesRegex(ValueError, '1.*1439'):
                    self.create(windowMinutes=value)
        self.assertEqual(self.scheduler.list(self.state.account), [])

    def test_window_capability_requires_database_scheduler(self):
        self.state.engine.adapter.get_source_info = lambda: {'synthetic':True}
        self.assertFalse(runtime_summary(self.state.engine)['capabilities']['scheduleWindows'])
        self.state.engine.windows_scheduler = self.scheduler
        self.assertTrue(runtime_summary(self.state.engine)['capabilities']['scheduleWindows'])
        for mode in ('demo', 'live'):
            self.state.engine.adapter.mode = mode
            self.assertFalse(runtime_summary(self.state.engine)['capabilities']['scheduleWindows'])

    def test_window_boundaries_allow_exact_deadline_but_skip_after_it(self):
        start = self.state.now
        for minutes in (1, 5, 1439):
            for late in (0, 0.001):
                with self.subTest(minutes=minutes, late=late):
                    self.state.now = start
                    created = self.create(windowMinutes=minutes,
                        requestId=f'synthetic-window-boundary-{minutes}-{int(bool(late))}')
                    self.state.now = created['nextRun']+minutes*60+late
                    posts_before = len(self.state.posts)
                    self.scheduler.tick()
                    result = self.job()
                    self.assertEqual(result['runs'][0]['status'], 'missed' if late else 'submitted_unconfirmed')
                    self.assertEqual(result['state'], 'missed' if late else 'finished')
                    self.assertEqual(len(self.state.posts)-posts_before, 0 if late else 1)
                    self.assertFalse(result['enabled'])
                    if late: self.assertNotIn('2 分钟', result['runs'][0]['label'])

    def test_weekly_window_crosses_midnight_without_changing_occurrence_date(self):
        self.state.now = datetime(2026,9,30,23,58,tzinfo=BEIJING).timestamp()
        created = self.create(mode='weekly', weekdays=[3], clock='23:59', windowMinutes=5)
        self.state.now = datetime(2026,10,1,0,3,tzinfo=BEIJING).timestamp()
        self.scheduler.tick()
        result = self.job()
        self.assertEqual(result['runs'][0]['status'], 'submitted_unconfirmed')
        self.assertEqual(result['runs'][0]['due'], created['nextRun'])
        self.assertEqual(result['nextRun'], datetime(2026,10,7,23,59,tzinfo=BEIJING).timestamp())
        self.assertTrue(result['enabled'])

    def test_multiday_gap_records_old_runs_and_only_latest_open_window_sends(self):
        self.create(mode='daily', clock='10:01', windowMinutes=1439)
        self.state.now = datetime(2026,10,1,10,0,tzinfo=BEIJING).timestamp()
        self.scheduler.tick()
        result = self.job()
        self.assertEqual([run['status'] for run in result['runs']], ['submitted_unconfirmed','missed','missed'])
        self.assertEqual(result['runs'][0]['due'], datetime(2026,9,30,10,1,tzinfo=BEIJING).timestamp())
        self.assertEqual(result['nextRun'], datetime(2026,10,1,10,1,tzinfo=BEIJING).timestamp())
        self.assertEqual(len(self.state.posts), 1)
        self.scheduler.tick()
        self.assertEqual(len(self.state.posts), 1)

    def test_expiry_during_source_read_records_missed_and_keeps_recurring_job_enabled(self):
        created = self.create(mode='daily', clock='10:01', windowMinutes=1)
        self.state.now = created['nextRun']
        call = self.state.engine.adapter.call
        def delayed_read(action, **kwargs):
            result = call(action, **kwargs)
            if action=='messages':
                self.state.now += 61
                self.state.ready = False
            return result
        with patch.object(self.state.engine.adapter, 'call', side_effect=delayed_read):
            self.scheduler.tick()
        result = self.job()
        run = result['runs'][0]
        self.assertEqual((run['status'], run['issueCode']), ('missed','schedule_window_expired'))
        self.assertIn('发送窗口', run['issue'])
        self.assertNotIn('draftId', run)
        with closing(sqlite3.connect(self.state.sender.path)) as db:
            self.assertEqual(db.execute('SELECT count(*) FROM hook_drafts').fetchone()[0], 0)
        self.assertEqual(self.state.posts, [])
        self.assertTrue(result['enabled'])
        self.assertEqual(result['nextRun'], datetime(2026,9,29,10,1,tzinfo=BEIJING).timestamp())

    def test_processing_across_days_preserves_ledger_and_latest_open_window(self):
        created = self.create(mode='daily', clock='10:01', windowMinutes=5)
        self.state.now = created['nextRun']
        call = self.state.engine.adapter.call
        def delayed_read(action, **kwargs):
            result = call(action, **kwargs)
            if action=='messages': self.state.now = datetime(2026,9,30,10,2,tzinfo=BEIJING).timestamp()
            return result
        with patch.object(self.state.engine.adapter, 'call', side_effect=delayed_read):
            self.scheduler.tick()
        result = self.job()
        self.assertEqual(result['runs'][0]['status'], 'missed')
        self.assertEqual(result['runs'][0]['due'], created['nextRun'])
        self.assertEqual(result['nextRun'], datetime(2026,9,29,10,1,tzinfo=BEIJING).timestamp())
        self.assertEqual(self.state.posts, [])
        self.scheduler.tick()
        result = self.job()
        self.assertEqual([(run['due'],run['status']) for run in result['runs']], [
            (datetime(2026,9,30,10,1,tzinfo=BEIJING).timestamp(),'submitted_unconfirmed'),
            (datetime(2026,9,29,10,1,tzinfo=BEIJING).timestamp(),'missed'),
            (created['nextRun'],'missed')])
        self.assertEqual(result['nextRun'], datetime(2026,10,1,10,1,tzinfo=BEIJING).timestamp())
        self.assertEqual(len(self.state.posts), 1)

    def test_hook_deadline_expiry_maps_to_missed_with_draft_and_reason(self):
        start = self.state.now
        for mode in ('once', 'weekly'):
            with self.subTest(mode=mode):
                self.state.now = start
                spec = {'mode':'weekly','weekdays':[1],'clock':'10:01'} if mode=='weekly' else {}
                created = self.create(requestId=f'synthetic-hook-window-{mode}', windowMinutes=1, **spec)
                self.state.now = created['nextRun']
                seen = 0
                def delayed_probe(method, path, payload=None):
                    nonlocal seen
                    result = self.state.transport(method, path, payload)
                    if method=='GET':
                        seen += 1
                        if seen==4: self.state.now += 61
                    return result
                with patch.object(self.state.sender, 'transport', side_effect=delayed_probe):
                    self.scheduler.tick()
                result = self.job()
                run = result['runs'][0]
                self.assertEqual((run['status'], run['issueCode']), ('missed','schedule_window_expired'))
                self.assertIn('发送窗口', run['issue'])
                with closing(sqlite3.connect(self.state.sender.path)) as db:
                    self.assertEqual(db.execute('SELECT status FROM hook_drafts WHERE id=?',
                        (run['draftId'],)).fetchone()[0], 'expired')
                self.assertEqual(self.state.posts, [])
                self.assertEqual(result['state'], 'active' if mode=='weekly' else 'missed')
                self.assertEqual(result['enabled'], mode=='weekly')
                self.scheduler.tick()
                self.assertEqual(self.state.posts, [])

    def test_post_late_success_keeps_actual_outcome_and_later_occurrences(self):
        created = self.create(mode='daily', clock='10:01', windowMinutes=1)
        self.state.now = created['nextRun']
        def delayed_post(method, path, payload=None):
            if method=='POST': self.state.now = datetime(2026,9,30,10,2,tzinfo=BEIJING).timestamp()
            return self.state.transport(method, path, payload)
        with patch.object(self.state.sender, 'transport', side_effect=delayed_post):
            self.scheduler.tick()
        result = self.job()
        self.assertEqual(result['runs'][0]['status'], 'submitted_unconfirmed')
        self.assertEqual(result['runs'][0]['due'], created['nextRun'])
        self.assertEqual(result['nextRun'], datetime(2026,9,29,10,1,tzinfo=BEIJING).timestamp())
        self.assertTrue(result['enabled'])
        self.assertEqual(len(self.state.posts), 1)
        self.scheduler.tick()
        result = self.job()
        self.assertEqual([run['status'] for run in result['runs']], ['submitted_unconfirmed','missed','submitted_unconfirmed'])
        self.assertEqual(result['nextRun'], datetime(2026,10,1,10,1,tzinfo=BEIJING).timestamp())
        self.assertEqual(len(self.state.posts), 2)
        self.assertNotEqual(self.state.posts[0]['requestId'], self.state.posts[1]['requestId'])

    def test_post_late_timeout_stays_unknown_and_original_occurrence_is_never_retried(self):
        created = self.create(mode='daily', clock='10:01', windowMinutes=1)
        self.state.now, self.state.outcome = created['nextRun'], 'timeout'
        def delayed_post(method, path, payload=None):
            if method=='POST': self.state.now += 61
            return self.state.transport(method, path, payload)
        with patch.object(self.state.sender, 'transport', side_effect=delayed_post):
            self.scheduler.tick()
        result = self.job()
        self.assertEqual(result['runs'][0]['status'], 'unknown')
        self.assertEqual(result['state'], 'paused')
        self.assertFalse(result['enabled'])
        self.scheduler.tick()
        self.assertEqual(len(self.state.posts), 1)
        with self.assertRaises(ValueError):self.scheduler.action(self.state.account, created['id'], 'resume')
        self.state.acknowledge_account()
        self.scheduler.action(self.state.account, created['id'], 'resume')
        self.scheduler.tick()
        self.assertEqual(len(self.state.posts), 1)
        self.assertEqual(self.job()['runs'], result['runs'])


if __name__ == '__main__':
    unittest.main()
