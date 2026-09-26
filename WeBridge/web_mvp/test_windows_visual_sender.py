"""Only synthetic PNG metadata and fake native boundaries; never real input."""
import base64
from contextlib import closing
import json
from pathlib import Path
import struct
import tempfile
import unittest

from windows_sender import SendError, _input_guard
from windows_visual_sender import WindowsVisualSender


def image_fixture(width=400, height=300):
    # Tiny PNG header is enough for the transport envelope validation. No actual
    # image consumer or native capture is called by these state-machine tests.
    data = b'\x89PNG\r\n\x1a\n' + struct.pack('>I', 13) + b'IHDR' + struct.pack('>II', width, height) + bytes(9)
    return base64.b64encode(data).decode()


class VisualSenderTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix='webridge-visual-send-')
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.now = 1000
        self.calls = []
        self.faults = {}
        self.sender = WindowsVisualSender(self.root, transport=self.transport, clock=lambda: self.now)
        self.selection = {'pid': 123, 'hwnd': 456, 'sourceRoot': str(self.root / 'account'), 'account': 'synthetic'}

    def transport(self, mode, data):
        self.calls.append((mode, data))
        fault = self.faults.get(mode)
        if isinstance(fault, BaseException):
            raise fault
        if fault is not None:
            return fault
        if mode == 'preview':
            self.assertNotIn('text', data)
            binding = {**data, 'processStarted': '12345', 'ownerVerified': True, 'signature': 'verified-window',
                       'geometry': {'x': 10, 'y': 20, 'width': 400, 'height': 300, 'dpi': 96}}
            return {'ok': True, 'binding': binding, 'png_base64': image_fixture(), 'width': 400, 'height': 300}
        if mode == 'stage':
            with closing(self.sender._connect()) as db:
                self.assertEqual(db.execute('SELECT status FROM visual_drafts').fetchone()[0], 'staging')
            self.assertIn('reference_png_base64', data)
            return {'ok': True, 'stage': 'staged', 'binding': data['binding'], 'png_base64': image_fixture()}
        self.assertNotIn('text', data)
        with closing(self.sender._connect()) as db:
            self.assertEqual(db.execute('SELECT status FROM visual_drafts').fetchone()[0], 'attempted')
        return {'ok': True, 'stage': 'submitted'}

    def stage_request(self, preview, **extra):
        return {**self.selection, 'previewToken': preview['previewToken'], 'composePoint': [100, 180],
                'sendPoint': [330, 270], 'text': 'synthetic filehelper 中文 🙂',
                'idempotencyKey': 'one-visual-send-001', 'targetConfirmed': True, 'emptyDraftConfirmed': True, **extra}

    def staged(self):
        preview = self.sender.preview(self.selection)
        request = self.stage_request(preview)
        return self.sender.stage(request), request

    def confirm(self, staged, **extra):
        return self.sender.confirm({**self.selection, 'draftId': staged['draftId'], 'textHash': staged['textHash'],
                                    'targetConfirmed': True, 'textConfirmed': True, **extra})

    def test_reviewed_flow_types_once_clicks_once_and_never_claims_delivery(self):
        draft, request = self.staged()
        self.assertEqual(draft['status'], 'staged')
        self.assertTrue(draft['imageDataUrl'].startswith('data:image/png;base64,'))
        self.assertEqual(self.sender.stage(request), draft)
        sent = self.confirm(draft)
        self.assertEqual(sent['status'], 'submitted_unconfirmed')
        self.assertFalse(sent['delivered'])
        self.assertFalse(sent['retryAllowed'])
        self.assertEqual(self.confirm(draft), sent)
        self.assertEqual([call[0] for call in self.calls], ['preview', 'stage', 'submit'])
        with closing(self.sender._connect()) as db:
            saved = ''.join(str(tuple(row)) for row in db.execute('SELECT * FROM visual_drafts'))
        self.assertNotIn(image_fixture(), saved)

    def test_stage_requires_manual_empty_and_target_confirmation_and_valid_points(self):
        preview = self.sender.preview(self.selection)
        for fields in ({'targetConfirmed': False}, {'emptyDraftConfirmed': False},
                       {'composePoint': [-1, 20]}, {'sendPoint': [400, 20]},
                       {'composePoint': [True, 30]}, {'sendPoint': [100, 180]}):
            with self.assertRaises(SendError):
                self.sender.stage(self.stage_request(preview, **fields))
        self.assertEqual(len(self.calls), 1)

    def test_source_switch_blocks_stage_and_confirm_without_input(self):
        preview = self.sender.preview(self.selection)
        for fields in ({'account': 'different'}, {'sourceRoot': str(self.root / 'another-account')}):
            with self.assertRaisesRegex(SendError, '账号已变化'):
                self.sender.stage(self.stage_request(preview, **fields))
        draft = self.sender.stage(self.stage_request(preview))
        with self.assertRaisesRegex(SendError, '账号已变化'):
            self.confirm(draft, account='different')
        self.assertEqual([row[0] for row in self.calls], ['preview', 'stage'])

    def test_one_preview_cannot_fill_twice_using_another_key(self):
        draft, request = self.staged()
        with self.assertRaisesRegex(SendError, '预览已用于'):
            self.sender.stage({**request, 'idempotencyKey': 'another-visual-send-002'})
        with self.assertRaisesRegex(SendError, '标识'):
            self.sender.stage({**request, 'text': 'different text'})
        self.assertEqual(len(self.calls), 2)

    def test_expired_preview_and_filled_image_refuse_mutations(self):
        preview = self.sender.preview(self.selection)
        self.now += 121
        with self.assertRaises(SendError):
            self.sender.stage(self.stage_request(preview))
        draft, _ = self.staged()
        self.now += 121
        with self.assertRaisesRegex(SendError, '核对图片'):
            self.confirm(draft)
        self.assertNotIn('submit', [row[0] for row in self.calls])

    def test_stage_crash_is_durable_and_not_retyped_after_restart(self):
        preview = self.sender.preview(self.selection)
        request = self.stage_request(preview)
        self.faults['stage'] = KeyboardInterrupt()
        with self.assertRaises(KeyboardInterrupt):
            self.sender.stage(request)
        self.sender = WindowsVisualSender(self.root, transport=self.transport, clock=lambda: self.now)
        self.assertEqual(self.sender.stage(request)['status'], 'unconfirmed')
        self.assertEqual(len(self.calls), 2)

    def test_submit_crash_is_durable_and_not_clicked_after_restart(self):
        draft, _ = self.staged()
        self.faults['submit'] = KeyboardInterrupt()
        with self.assertRaises(KeyboardInterrupt):
            self.confirm(draft)
        self.sender = WindowsVisualSender(self.root, transport=self.transport, clock=lambda: self.now)
        self.assertEqual(self.confirm(draft)['status'], 'unconfirmed')
        self.assertEqual(len(self.calls), 3)

    def test_staged_preview_is_not_recoverable_without_in_memory_image(self):
        draft, _ = self.staged()
        self.sender = WindowsVisualSender(self.root, transport=self.transport, clock=lambda: self.now)
        self.assertEqual(self.sender.get(draft['draftId'])['status'], 'unconfirmed')
        with self.assertRaises(SendError):
            self.confirm(draft)
        self.assertEqual(len(self.calls), 2)

    def test_native_failure_result_is_sanitized_and_consumed(self):
        preview = self.sender.preview(self.selection)
        request = self.stage_request(preview)
        self.faults['stage'] = RuntimeError('private window text must not leak')
        draft = self.sender.stage(request)
        self.assertEqual(draft['status'], 'unconfirmed')
        self.assertNotIn('private window text', json.dumps(draft))
        self.assertEqual(self.sender.stage(request), draft)
        self.assertEqual(len(self.calls), 2)

    def test_changed_picture_before_input_is_blocked_and_consumed(self):
        preview = self.sender.preview(self.selection)
        self.faults['stage'] = {'ok': False, 'stage': 'before_input', 'issueCode': 'preview_changed'}
        request = self.stage_request(preview)
        self.assertEqual(self.sender.stage(request)['status'], 'blocked')
        self.assertEqual(self.sender.stage(request)['status'], 'blocked')
        self.assertEqual(len(self.calls), 2)

    def test_confirmation_hash_and_checkboxes_are_required(self):
        draft, _ = self.staged()
        for fields in ({'targetConfirmed': False}, {'textConfirmed': False}, {'textHash': 'changed'}):
            with self.assertRaises(SendError):
                self.confirm(draft, **fields)
        self.assertEqual(len(self.calls), 2)

    def test_inflight_other_sender_does_not_queue_or_touch_window(self):
        with _input_guard(self.root):
            with self.assertRaisesRegex(SendError, '另一个'):
                self.sender.preview(self.selection)
        self.assertEqual(self.calls, [])


if __name__ == '__main__':
    unittest.main()
