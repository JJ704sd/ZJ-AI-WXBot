"""One in-process send arbiter with real services and invented message/Hook data."""
import unittest
from unittest.mock import patch

import test_windows_scheduler as fixtures


class WindowsSendAdmissionTests(unittest.TestCase):
    def setUp(self):
        self.s = fixtures.SchedulerTests()
        self.s.setUp()
        self.addCleanup(self.s.doCleanups)
        self.f, self.scheduler = self.s.f, self.s.scheduler

    def test_busy_scheduler_keeps_due_occurrence_and_rule_enabled_until_next_tick(self):
        job = self.scheduler.create(self.s.data())
        self.f.now = job['nextRun']
        with self.f.engine.send_lock:
            self.scheduler.tick()
            self.assertEqual(self.s.job(), job)
            self.assertEqual(self.f.posts, [])
        self.scheduler.tick()
        result = self.s.job()
        self.assertEqual(len(self.f.posts), 1)
        self.assertEqual([run['status'] for run in result['runs']], ['submitted_unconfirmed'])
        self.assertEqual(result['state'], 'finished')
        self.assertTrue(self.f.engine.send_lock.acquire(blocking=False))
        self.f.engine.send_lock.release()

    def test_busy_reply_does_not_consume_event_or_pause_rule(self):
        enabled = self.f.enable()
        self.f.now += 1
        self.f.rows = [self.f.message()]
        with self.f.engine.send_lock:
            self.f.service.tick()
            self.assertEqual(self.f.service.get(self.f.account, self.f.group), enabled)
            self.assertEqual(self.f.posts, [])
        self.f.service.tick()
        result = self.f.service.get(self.f.account, self.f.group)
        self.assertTrue(result['enabled'])
        self.assertEqual([row['status'] for row in result['attempts']], ['submitted_unconfirmed'])
        self.assertEqual(len(self.f.posts), 1)

    def test_handoff_ingestion_continues_while_sender_is_busy(self):
        self.f.service.configure(self.f.account, self.f.group, True, '', 30, mode='handoff')
        self.f.now += 1
        self.f.rows = [self.f.message()]
        with self.f.engine.send_lock:
            self.f.service.tick()
        result = self.f.service.get(self.f.account, self.f.group)
        self.assertTrue(result['enabled'])
        self.assertEqual([row['status'] for row in result['attempts']], ['human_pending'])
        self.assertEqual(self.f.posts, [])

    def test_expired_occurrence_deferred_by_busy_is_missed_without_post(self):
        job = self.scheduler.create(self.s.data())
        self.f.now = job['nextRun']
        with self.f.engine.send_lock:
            self.scheduler.tick()
            self.f.now += 121
            self.scheduler.tick()
            self.assertEqual(self.s.job(), job)
        self.scheduler.tick()
        self.assertEqual(self.s.job()['runs'][0]['status'], 'missed')
        self.assertEqual(self.f.posts, [])

    def test_scheduler_releases_admission_after_unexpected_snapshot_error(self):
        job = self.scheduler.create(self.s.data())
        self.f.now = job['nextRun']
        with patch.object(self.f.engine.adapter, 'call', side_effect=RuntimeError('synthetic snapshot bug')):
            with self.assertRaisesRegex(RuntimeError, 'synthetic snapshot bug'):
                self.scheduler.tick()
        self.assertTrue(self.f.engine.send_lock.acquire(blocking=False))
        self.f.engine.send_lock.release()
        self.assertEqual(self.f.posts, [])

    def test_reply_releases_admission_after_unexpected_snapshot_error(self):
        self.f.enable()
        self.f.now += 1
        with patch.object(self.f.engine.adapter, 'call', side_effect=RuntimeError('synthetic snapshot bug')):
            with self.assertRaisesRegex(RuntimeError, 'synthetic snapshot bug'):
                self.f.service.tick()
        self.assertTrue(self.f.engine.send_lock.acquire(blocking=False))
        self.f.engine.send_lock.release()
        self.assertEqual(self.f.posts, [])


if __name__ == '__main__':
    unittest.main()
