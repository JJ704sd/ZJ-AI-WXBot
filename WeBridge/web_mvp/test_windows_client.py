import base64
import json
import random
import struct
import subprocess
import unittest
import zlib
from unittest.mock import patch

import windows_client


class WindowsClientTests(unittest.TestCase):
    def setUp(self):
        mode = patch.object(windows_client, 'IS_WINDOWS', True)
        mode.start()
        self.addCleanup(mode.stop)

    @patch.object(windows_client, 'IS_WINDOWS', False)
    @patch.object(windows_client.subprocess, 'run')
    def test_non_windows_does_not_launch_process(self, run):
        self.assertEqual(windows_client.status()['issueCode'], 'unsupported')
        run.assert_not_called()

    @patch.object(windows_client.subprocess, 'run')
    def test_invalid_window_identifiers_cannot_reach_shell(self, run):
        for pid, hwnd in ((True, 1), (1, False), (0, 1), (-1, 1), (1, 0), ('1; calc', 1), (1, '1 & whoami'), (1.5, 1), (1, 2**64), ('１２', 1)):
            for operation in (windows_client.preview, windows_client.inspect, windows_client.capture):
                with self.subTest(pid=pid, hwnd=hwnd, operation=operation.__name__), self.assertRaises(ValueError):
                    operation(pid, hwnd)
        run.assert_not_called()

    @patch.object(windows_client.subprocess, 'run')
    def test_preview_uses_argument_array_and_never_claims_send_or_identity(self, run):
        run.return_value = subprocess.CompletedProcess([], 0, json.dumps({'ok': True, 'texts': [{'text': 'synthetic', 'controlType': 'Text'}], 'canSend': True, 'identityVerified': True}), '')
        result = windows_client.preview(123, '456')
        self.assertFalse(result['canSend'])
        self.assertFalse(result['identityVerified'])
        self.assertTrue(result['readOnly'])
        args, kwargs = run.call_args
        self.assertEqual(args[0][-6:], ['-Mode', 'preview', '-ProcessId', '123', '-WindowHandle', '456'])
        self.assertFalse(kwargs.get('shell', False))
        self.assertEqual(kwargs['timeout'], 12)

    @patch.object(windows_client.subprocess, 'run', side_effect=subprocess.TimeoutExpired('probe', 12))
    def test_timeout_returns_honest_failure(self, run):
        result = windows_client.status()
        self.assertFalse(result['ok'])
        self.assertEqual(result['issueCode'], 'timeout')
        self.assertEqual(result['texts'], [])

    @patch.object(windows_client.subprocess, 'run')
    def test_failed_process_and_invalid_json_do_not_leak_diagnostics(self, run):
        for output in (subprocess.CompletedProcess([], 1, 'private output', 'private error'), subprocess.CompletedProcess([], 0, 'not JSON', ''), subprocess.CompletedProcess([], 0, '[]', '')):
            run.return_value = output
            result = windows_client.status()
            self.assertFalse(result['ok'])
            self.assertNotIn('private', json.dumps(result))

    @patch.object(windows_client.subprocess, 'run')
    def test_inspect_only_returns_structure_and_never_text_fields(self, run):
        run.return_value = subprocess.CompletedProcess([], 0, json.dumps({'ok': True, 'nodeCount': 2,
            'controlTypes': {'Window': 1, 'Pane': 1}, 'texts': ['private content'], 'title': 'private title',
            'png_base64': 'private pixels'}), '')
        result = windows_client.inspect(123, 456)
        self.assertTrue(result['ok'])
        self.assertEqual(result['source'], 'windows-uia-inspect')
        self.assertEqual(result['controlTypes'], {'Window': 1, 'Pane': 1})
        self.assertNotIn('private', json.dumps(result))

    @staticmethod
    def _synthetic_png(width=300, height=300):
        def chunk(kind, data):
            return struct.pack('>I', len(data)) + kind + data + struct.pack('>I', zlib.crc32(kind + data))
        random_bytes = random.Random(42).randbytes(width * height * 3)
        rows = b''.join(b'\0' + random_bytes[y * width * 3:(y + 1) * width * 3] for y in range(height))
        return (b'\x89PNG\r\n\x1a\n' + chunk(b'IHDR', struct.pack('>IIBBBBB', width, height, 8, 2, 0, 0, 0))
                + chunk(b'IDAT', zlib.compress(rows)) + chunk(b'IEND', b''))

    @patch.object(windows_client.subprocess, 'run')
    def test_capture_accepts_bounded_png_larger_than_text_limit(self, run):
        encoded = base64.b64encode(self._synthetic_png()).decode('ascii')
        self.assertGreater(len(encoded), 200_000)
        run.return_value = subprocess.CompletedProcess([], 0, json.dumps({'ok': True, 'png_base64': encoded,
            'geometry': {'x': 0, 'y': 0, 'width': 300, 'height': 300}}), '')
        result = windows_client.capture(123, 456)
        self.assertTrue(result['ok'])
        self.assertEqual(result['png_base64'], encoded)
        self.assertEqual(result['source'], 'windows-window-capture')
        self.assertFalse(result['canSend'])

    @patch.object(windows_client.subprocess, 'run')
    def test_capture_failure_or_bad_geometry_never_returns_image(self, run):
        encoded = base64.b64encode(self._synthetic_png(2, 2)).decode('ascii')
        for data in ({'ok': False, 'issueCode': 'window_occluded', 'png_base64': encoded},
                     {'ok': True, 'png_base64': 'not valid base64', 'geometry': {}},
                     {'ok': True, 'png_base64': encoded, 'geometry': {'width': 1, 'height': 1}},
                     {'ok': True, 'png_base64': encoded, 'geometry': []}):
            run.return_value = subprocess.CompletedProcess([], 0, json.dumps(data), '')
            result = windows_client.capture(123, 456)
            self.assertFalse(result['ok'])
            self.assertNotIn('png_base64', result)

    @patch.object(windows_client.subprocess, 'run')
    def test_capture_rejects_oversized_png_dimensions(self, run):
        encoded = base64.b64encode(self._synthetic_png(5001, 1)).decode('ascii')
        run.return_value = subprocess.CompletedProcess([], 0, json.dumps({'ok': True, 'png_base64': encoded,
            'geometry': {'width': 5001, 'height': 1}}), '')
        self.assertFalse(windows_client.capture(123, 456)['ok'])


if __name__ == '__main__':
    unittest.main()
