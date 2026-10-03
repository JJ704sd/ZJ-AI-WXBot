"""Final submission authorization using invented Hook responses and real SQLite."""
from contextlib import closing
import sqlite3
import unittest
from unittest.mock import patch

import test_windows_hook_sender as fixtures
from windows_hook_sender import HookSendError


class HookSubmissionGateTests(unittest.TestCase):
    def setUp(self):
        self.f = fixtures.HookTests()
        self.f.setUp()
        self.addCleanup(self.f.doCleanups)
        self.sender = self.f.sender
        self.binding = self.sender.automation_binding(self.f.source)

    def send(self, callback, **options):
        return self.sender.send_automatic(self.f.data, expected_binding=self.binding,
            baseline_messages=[], before_submit=callback, **options)

    def test_business_rejection_is_blocked_before_attempted_or_post(self):
        seen = []
        def reject(draft_id):
            with closing(sqlite3.connect(self.sender.path)) as db:
                seen.append(db.execute('SELECT status FROM hook_drafts WHERE id=?', (draft_id,)).fetchone()[0])
            raise ValueError('待办已被领取，本次不通知。')
        result = self.send(reject)
        self.assertEqual(seen, ['prepared'])
        self.assertEqual((result['status'],result['issueCode']), ('blocked','submission_not_authorized'))
        self.assertEqual(result['issue'], '待办已被领取，本次不通知。')
        self.assertFalse(any(method=='POST' for method,_,_ in self.f.calls))

    def test_typed_business_rejection_keeps_its_issue_and_is_not_retried(self):
        def reject(draft_id):
            raise HookSendError('notification_cancelled', '通知策略已暂停。')
        result = self.send(reject)
        self.assertEqual((result['status'], result['issueCode'], result['issue']),
            ('blocked', 'notification_cancelled', '通知策略已暂停。'))
        self.assertEqual(self.send(lambda draft_id: self.fail('不能重新授权已阻止的请求')), result)
        self.assertFalse(any(method=='POST' for method,_,_ in self.f.calls))

    def test_authorization_follows_probes_and_precedes_durable_attempt_and_post(self):
        authorized, after = [], []
        def authorize(draft_id):
            authorized.append(draft_id)
            with closing(sqlite3.connect(self.sender.path)) as db:
                self.assertEqual(db.execute('SELECT status FROM hook_drafts WHERE id=?',
                    (draft_id,)).fetchone()[0], 'prepared')
        def transport(method, path, payload=None):
            if authorized:
                after.append(method)
                with closing(sqlite3.connect(self.sender.path)) as db:
                    self.assertEqual(db.execute('SELECT status FROM hook_drafts WHERE id=?',
                        (authorized[0],)).fetchone()[0], 'attempted')
                self.assertNotIn('before_submit', payload)
            return self.f.transport(method, path, payload)
        with patch.object(self.sender, 'transport', side_effect=transport):
            result = self.send(authorize)
        self.assertEqual(result['status'], 'server_accepted')
        self.assertEqual(authorized, [result['draftId']])
        self.assertEqual(after, ['POST'])

    def test_programming_error_propagates_without_attempt_or_post(self):
        def broken(draft_id):
            raise RuntimeError('synthetic authorization bug')
        with self.assertRaisesRegex(RuntimeError, 'synthetic authorization bug'):
            self.send(broken)
        with closing(sqlite3.connect(self.sender.path)) as db:
            self.assertEqual(db.execute('SELECT status FROM hook_drafts').fetchone()[0], 'prepared')
        self.assertFalse(any(method=='POST' for method,_,_ in self.f.calls))

    def test_window_consumed_by_final_probe_does_not_claim_authorization(self):
        seen = 0
        def transport(method, path, payload=None):
            nonlocal seen
            result = self.f.transport(method, path, payload)
            if method=='GET':
                seen += 1
                if seen==3: self.f.now = 1061
            return result
        with patch.object(self.sender, 'transport', side_effect=transport):
            result = self.send(lambda draft_id: self.fail('过期请求不能领取通知'), deadline=1060)
        self.assertEqual((result['status'], result['issueCode']), ('expired', 'schedule_window_expired'))
        self.assertFalse(any(method=='POST' for method,_,_ in self.f.calls))

    def test_unknown_result_does_not_reauthorize_or_retry(self):
        self.f.outcome = TimeoutError('synthetic unknown')
        seen = []
        result = self.send(seen.append)
        self.assertEqual(result['status'], 'unknown')
        self.assertEqual(self.send(lambda draft_id: self.fail('未知结果不能重新领取通知')), result)
        self.assertEqual(seen, [result['draftId']])
        self.assertEqual(sum(method=='POST' for method,_,_ in self.f.calls), 1)


if __name__ == '__main__':
    unittest.main()
