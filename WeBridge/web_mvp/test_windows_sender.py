"""Public send-state tests. No real windows, typing, clipboard or messages."""
import json
from contextlib import closing
from pathlib import Path
import sqlite3
import tempfile
import unittest

from windows_sender import WindowsSender, SendError


class SenderTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix='webridge-send-')
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.now = 1000
        self.calls = []
        self.result = {'ok': True, 'stage': 'submitted'}
        self.sender = WindowsSender(self.root, transport=self.transport, clock=lambda: self.now)
        self.data = {'pid': 123, 'hwnd': 456, 'sourceRoot': str(self.root / 'account'), 'account': 'synthetic',
                     'targetId': 'filehelper', 'text': 'synthetic 中文 🙂', 'idempotencyKey': 'one-reviewed-send-001'}

    def transport(self, mode, data):
        self.calls.append((mode, data))
        if mode == 'inspect':
            self.assertNotIn('text', data)
            return {'ok': True, 'binding': {**data, 'processStarted': '12345', 'targetName': '文件传输助手',
                    'targetRuntimeId': 'target', 'editorRuntimeId': 'edit', 'sendRuntimeId': 'send',
                    'ownerVerified': True, 'draftEmpty': True}}
        if isinstance(self.result, BaseException):
            raise self.result
        return self.result

    def confirm(self, draft, **extra):
        return self.sender.confirm({'draftId': draft['draftId'], 'textHash': draft['textHash'],
                                    'targetConfirmed': True, 'sourceRoot': self.data['sourceRoot'],
                                    'account': self.data['account'], **extra})

    def test_prepare_is_readonly_confirm_is_once_and_not_delivery(self):
        draft = self.sender.prepare(self.data)
        self.assertEqual([row[0] for row in self.calls], ['inspect'])
        self.assertEqual(self.sender.prepare(self.data), draft)
        result = self.confirm(draft)
        self.assertEqual(result['status'], 'submitted_unconfirmed')
        self.assertFalse(result['delivered'])
        self.assertEqual(self.confirm(draft), result)
        self.assertEqual([row[0] for row in self.calls], ['inspect', 'submit'])

    def test_changed_text_account_or_missing_confirmation_never_submits(self):
        draft = self.sender.prepare(self.data)
        for fields in ({'textHash': 'changed'}, {'account': 'other'}, {'targetConfirmed': False},
                       {'sourceRoot': str(self.root / 'different-account')}):
            with self.assertRaises(SendError):
                self.confirm(draft, **fields)
        self.assertEqual([row[0] for row in self.calls], ['inspect'])

    def test_expired_draft_and_key_reuse_are_rejected(self):
        draft = self.sender.prepare(self.data)
        with self.assertRaisesRegex(SendError, '标识'):
            self.sender.prepare({**self.data, 'text': 'different'})
        self.now += 121
        self.assertEqual(self.confirm(draft)['status'], 'expired')
        self.assertEqual(len(self.calls), 1)

    def test_native_timeout_is_uncertain_and_never_retried(self):
        draft = self.sender.prepare(self.data)
        self.result = TimeoutError('private diagnostic')
        result = self.confirm(draft)
        self.assertEqual(result['status'], 'unconfirmed')
        self.assertNotIn('private diagnostic', json.dumps(result))
        self.assertEqual(self.confirm(draft), result)
        self.assertEqual(len(self.calls), 2)

    def test_attempt_survives_interruption_and_restart(self):
        draft = self.sender.prepare(self.data)
        self.result = KeyboardInterrupt()
        with self.assertRaises(KeyboardInterrupt):
            self.confirm(draft)
        self.sender = WindowsSender(self.root, transport=self.transport, clock=lambda: self.now)
        self.assertEqual(self.confirm(draft)['status'], 'unconfirmed')
        self.assertEqual(len(self.calls), 2)

    def test_existing_draft_or_unverified_binding_cannot_prepare(self):
        def existing(mode, data):
            return {'ok': False, 'issueCode': 'draft_present', 'stage': 'before_input'}
        self.sender.transport = existing
        with self.assertRaisesRegex(SendError, '草稿'):
            self.sender.prepare(self.data)
        with closing(sqlite3.connect(self.sender.path)) as db:
            self.assertEqual(db.execute('SELECT count(*) FROM native_drafts').fetchone()[0], 0)

    def test_before_input_failure_is_blocked_and_consumed(self):
        draft = self.sender.prepare(self.data)
        self.result = {'ok': False, 'stage': 'before_input', 'issueCode': 'window_changed'}
        self.assertEqual(self.confirm(draft)['status'], 'blocked')
        self.assertEqual(self.confirm(draft)['status'], 'blocked')
        self.assertEqual(len(self.calls), 2)


if __name__ == '__main__':
    unittest.main()
