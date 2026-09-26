"""OCR worker contract tests. Real WinRT validation uses an explicit synthetic PNG."""
import json
from pathlib import Path
import struct
import subprocess
import unittest
from unittest.mock import patch

import windows_ocr


def png_header(width=640, height=480):
    # These bytes only test the Python boundary; native decoding is tested separately.
    return b'\x89PNG\r\n\x1a\n\x00\x00\x00\rIHDR' + struct.pack('>II', width, height) + b'\0' * 9


class WindowsOcrTests(unittest.TestCase):
    def setUp(self):
        mock = patch.object(windows_ocr, 'IS_WINDOWS', True)
        mock.start()
        self.addCleanup(mock.stop)

    def worker(self, result, exit_code=0):
        self.paths = []
        def run(command, **kwargs):
            source = Path(command[command.index('-ImagePath') + 1])
            output = Path(command[command.index('-OutputPath') + 1])
            self.assertTrue(source.is_file())
            self.paths.extend([source, output])
            self.assertEqual(kwargs['stdout'], subprocess.DEVNULL)
            self.assertEqual(kwargs['stderr'], subprocess.DEVNULL)
            self.assertFalse(kwargs.get('shell', False))
            output.write_text(json.dumps(result), encoding='utf-8')
            return subprocess.CompletedProcess(command, exit_code)
        return run

    @patch.object(windows_ocr.subprocess, 'run')
    def test_invalid_png_or_language_never_launches_worker(self, run):
        for image in (b'', b'not png', png_header(0, 10), png_header(10000, 10000)):
            with self.subTest(image=image[:24]), self.assertRaises(ValueError):
                windows_ocr.recognize_png(image)
        with self.assertRaises(ValueError):
            windows_ocr.recognize_png(png_header(), 'zh-Hans;calc')
        run.assert_not_called()

    def test_output_is_only_unverified_text_and_temporary_files_are_removed(self):
        worker = self.worker({'status': 'ok', 'availableLanguages': ['zh-Hans-CN'],
                              'lines': [{'text': 'synthetic OCR', 'box': [0, 0, 100, 30]}]})
        with patch.object(windows_ocr.subprocess, 'run', side_effect=worker):
            result = windows_ocr.recognize_png(png_header())
        self.assertTrue(result['ok'])
        self.assertEqual(result['texts'], [{'text': 'synthetic OCR', 'controlType': 'OCR'}])
        self.assertEqual(result['availableLanguages'], ['zh-Hans-CN'])
        self.assertFalse(result['identityVerified'])
        self.assertFalse(result['newMessagesVerified'])
        self.assertFalse(result['nativeMentionsVerified'])
        self.assertFalse(result['canSend'])
        self.assertTrue(all(not path.exists() for path in self.paths))

    def test_missing_language_returns_actionable_installed_language_list(self):
        worker = self.worker({'status': 'ocr_language_unavailable', 'availableLanguages': ['en-US']}, 2)
        with patch.object(windows_ocr.subprocess, 'run', side_effect=worker):
            result = windows_ocr.recognize_png(png_header())
        self.assertEqual(result['issueCode'], 'ocr_language_unavailable')
        self.assertEqual(result['availableLanguages'], ['en-US'])
        self.assertIn('语言包', result['issue'])
        self.assertEqual(result['texts'], [])

    def test_empty_or_blank_ocr_is_not_reported_as_success(self):
        for lines in ([], [{'text': '  ', 'box': [0, 0, 100, 30]}]):
            worker = self.worker({'status': 'ok', 'lines': lines, 'availableLanguages': ['zh-Hans-CN']})
            with patch.object(windows_ocr.subprocess, 'run', side_effect=worker):
                result = windows_ocr.recognize_png(png_header())
            self.assertFalse(result['ok'])
            self.assertEqual(result['issueCode'], 'ocr_no_text')
            self.assertEqual(result['texts'], [])
            self.assertEqual(result['availableLanguages'], ['zh-Hans-CN'])

    def test_timeout_cleans_temporary_files_and_does_not_leak_private_error(self):
        paths = []
        def timeout(command, **kwargs):
            paths.append(Path(command[command.index('-ImagePath') + 1]))
            raise subprocess.TimeoutExpired('private-screenshot-name', 15)
        with patch.object(windows_ocr.subprocess, 'run', side_effect=timeout):
            result = windows_ocr.recognize_png(png_header())
        self.assertEqual(result['issueCode'], 'ocr_timeout')
        self.assertNotIn('private', json.dumps(result))
        self.assertTrue(all(not path.exists() for path in paths))

    def test_oversized_or_out_of_bounds_results_are_rejected(self):
        for lines in ([{'text': 'synthetic', 'box': [0, 0, 900, 30]}],
                      [{'text': 'synthetic', 'box': [0, 0, float('nan'), 30]}],
                      [{'text': 'x' * 10001, 'box': [0, 0, 100, 30]}]):
            worker = self.worker({'status': 'ok', 'lines': lines})
            with patch.object(windows_ocr.subprocess, 'run', side_effect=worker):
                result = windows_ocr.recognize_png(png_header())
            self.assertFalse(result['ok'])
            self.assertEqual(result['texts'], [])

    @patch.object(windows_ocr, 'IS_WINDOWS', False)
    @patch.object(windows_ocr.subprocess, 'run')
    def test_non_windows_returns_unsupported_without_worker(self, run):
        self.assertEqual(windows_ocr.recognize_png(png_header())['issueCode'], 'unsupported')
        run.assert_not_called()


if __name__ == '__main__':
    unittest.main()
