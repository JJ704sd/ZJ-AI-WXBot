"""Internal schedule deadlines on the real Hook sender with synthetic transport."""
from contextlib import closing, contextmanager
import sqlite3
import unittest
from unittest.mock import patch

import test_windows_hook_sender as fixtures
import windows_hook_sender


class HookScheduleDeadlineTests(unittest.TestCase):
    def setUp(self):
        self.f = fixtures.HookTests()
        self.f.setUp()
        self.addCleanup(self.f.doCleanups)
        self.sender = self.f.sender
        self.binding = self.sender.automation_binding(self.f.source)

    def send(self, deadline, **changes):
        return self.sender.send_automatic({**self.f.data, **changes}, expected_binding=self.binding,
            baseline_messages=[], deadline=deadline)

    def posts(self):
        return [call for call in self.f.calls if call[0]=='POST']

    def assert_expired(self, result):
        self.assertEqual((result['status'], result['issueCode']), ('expired','schedule_window_expired'))
        self.assertEqual(self.posts(), [])
        self.assertEqual(self.sender.get(result['draftId'], self.f.source)['status'], 'expired')

    def test_expired_deadline_creates_durable_no_submission_result(self):
        result = self.send(999)
        self.assert_expired(result)
        self.assertEqual(self.send(2000), result)
        self.assertEqual(self.posts(), [])

    def test_expiry_during_each_native_probe_never_posts(self):
        for probe in (1, 2, 3):
            with self.subTest(probe=probe):
                self.f.now = 1000
                seen = 0
                def transport(method, path, payload=None):
                    nonlocal seen
                    response = self.f.transport(method, path, payload)
                    if method=='GET':
                        seen += 1
                        if seen==probe: self.f.now = 1061
                    return response
                with patch.object(self.sender, 'transport', side_effect=transport):
                    result = self.send(1060, idempotencyKey=f'synthetic-deadline-probe-{probe}')
                self.assert_expired(result)

    def test_expiry_after_acquiring_send_guard_never_posts(self):
        guard = windows_hook_sender._send_guard
        @contextmanager
        def delayed_guard(directory):
            with guard(directory):
                self.f.now = 1061
                yield
        with patch.object(windows_hook_sender, '_send_guard', delayed_guard):
            self.assert_expired(self.send(1060))

    def test_expiry_after_attempted_commit_is_still_known_not_submitted(self):
        state, path = self.f, self.sender.path
        committed = []
        class SlowCommit(sqlite3.Connection):
            def commit(connection):
                super().commit()
                with closing(sqlite3.connect(path)) as observed:
                    attempted = observed.execute("SELECT count(*) FROM hook_drafts WHERE status='attempted'").fetchone()[0]
                if attempted:
                    committed.append(attempted)
                    state.now = 1061
        def connect():
            connection = sqlite3.connect(path, factory=SlowCommit)
            connection.row_factory = sqlite3.Row
            connection.execute('PRAGMA synchronous=FULL')
            return connection
        with patch.object(self.sender, '_connect', side_effect=connect):
            result = self.send(1060)
        self.assertEqual(committed, [1])
        self.assert_expired(result)

    def test_exact_deadline_is_inclusive_and_never_enters_native_payload(self):
        result = self.send(1000)
        self.assertEqual(result['status'], 'server_accepted')
        self.assertEqual(len(self.posts()), 1)
        self.assertNotIn('deadline', self.posts()[0][2])
        self.assertNotIn('windowMinutes', self.posts()[0][2])
        with closing(sqlite3.connect(self.sender.path)) as db:
            request = db.execute('SELECT request FROM hook_drafts').fetchone()[0]
        self.assertNotIn('deadline', request)

    def test_post_late_outcome_is_never_reclassified_as_expired(self):
        for index,outcome in enumerate(('submitted', 'server_accepted', TimeoutError('synthetic late timeout'))):
            with self.subTest(outcome=outcome):
                self.f.now, self.f.outcome = 1000, outcome
                def transport(method, path, payload=None):
                    if method=='POST': self.f.now = 1200
                    return self.f.transport(method, path, payload)
                with patch.object(self.sender, 'transport', side_effect=transport):
                    result = self.send(1060, idempotencyKey=f'synthetic-late-response-{index}')
                self.assertEqual(result['status'], ('submitted_unconfirmed','server_accepted','unknown')[index])
        self.assertEqual(len(self.posts()), 3)

    def test_existing_unknown_is_not_expired_or_retried(self):
        self.f.outcome = TimeoutError('synthetic unknown')
        first = self.send(1060)
        self.f.now = 1100
        self.assertEqual(self.send(1060), first)
        self.assertEqual(first['status'], 'unknown')
        self.assertEqual(len(self.posts()), 1)

    def test_manual_confirmation_ignores_deadline_inside_request_data(self):
        draft = self.sender.prepare(self.f.data)
        result = self.sender.confirm({**self.f.confirm_data(draft), 'deadline':999})
        self.assertEqual(result['status'], 'server_accepted')
        self.assertEqual(len(self.posts()), 1)

    def test_schedule_deadline_precedes_old_prepared_draft_ttl(self):
        self.sender.prepare(self.f.data)
        self.f.now = 1200
        self.assert_expired(self.send(1060))


if __name__ == '__main__':
    unittest.main()
