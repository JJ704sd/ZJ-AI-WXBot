"""OCR boundary tests use generated pixels and fake capture/recognition adapters."""
import base64
import binascii
import struct
import unittest
from unittest.mock import patch
import zlib

import windows_reader


def fixture_png():
    def chunk(kind, data):
        return struct.pack('>I', len(data)) + kind + data + struct.pack('>I', binascii.crc32(kind + data) & 0xffffffff)
    return (b'\x89PNG\r\n\x1a\n' + chunk(b'IHDR', struct.pack('>IIBBBBB', 1, 1, 8, 2, 0, 0, 0))
            + chunk(b'IDAT', zlib.compress(b'\0\xff\xff\xff')) + chunk(b'IEND', b''))


class WindowsReaderTests(unittest.TestCase):
    def captured(self, png=None):
        return {'ok': True, 'pid': 123, 'hwnd': '456', 'title': 'Synthetic fixture',
                'png_base64': base64.b64encode(png if png is not None else fixture_png()).decode('ascii')}

    def test_failed_capture_never_runs_ocr_or_returns_pixels(self):
        with patch.object(windows_reader.windows_client, 'capture', return_value={'ok': False, 'issueCode': 'window_occluded', 'issue': '窗口被遮挡'}), patch.object(windows_reader, 'recognize_png') as recognize:
            result = windows_reader.preview_ocr(123, '456')
            self.assertFalse(result['ok'])
            self.assertEqual(result['issueCode'], 'window_occluded')
            self.assertEqual(result['texts'], [])
            recognize.assert_not_called()

    def test_success_returns_text_without_image_or_verified_identity(self):
        payload = self.captured()
        with patch.object(windows_reader.windows_client, 'capture', return_value=payload) as capture, patch.object(windows_reader, 'recognize_png', return_value={'ok': True, 'texts': [{'text': 'Synthetic', 'controlType': 'OCR'}], 'language': 'en-US', 'canSend': True, 'identityVerified': True}) as recognize:
            result = windows_reader.preview_ocr(123, '456')
            capture.assert_called_once_with(123, '456')
            recognize.assert_called_once_with(fixture_png())
            self.assertEqual(result['texts'][0]['text'], 'Synthetic')
            self.assertNotIn('png_base64', result)
            self.assertNotIn('png_base64', payload)
            for key in ('identityVerified', 'newMessagesVerified', 'nativeMentionsVerified', 'canSend'):
                self.assertFalse(result[key])

    def test_malformed_capture_does_not_reach_decoder(self):
        malformed_header = fixture_png()[:8] + b'\0\0\0\x0e' + fixture_png()[12:]
        for captured in (self.captured(b'not PNG'), self.captured(malformed_header), {**self.captured(), 'png_base64': '%%%'}):
            with patch.object(windows_reader.windows_client, 'capture', return_value=captured), patch.object(windows_reader, 'recognize_png') as recognize:
                result = windows_reader.preview_ocr(123, '456')
                self.assertEqual(result['issueCode'], 'invalid_capture')
                recognize.assert_not_called()

    def test_failed_recognition_does_not_return_partial_text(self):
        with patch.object(windows_reader.windows_client, 'capture', return_value=self.captured()), patch.object(windows_reader, 'recognize_png', return_value={'ok': False, 'texts': [{'text': 'partial'}], 'issueCode': 'language_missing', 'issue': '缺少语言', 'availableLanguages': ['en-US']}):
            result = windows_reader.preview_ocr(123, '456')
            self.assertFalse(result['ok'])
            self.assertEqual(result['texts'], [])
            self.assertEqual(result['languages'], ['en-US'])

    def test_concurrent_call_cannot_start_another_capture(self):
        with windows_reader._reading, patch.object(windows_reader.windows_client, 'capture') as capture:
            self.assertEqual(windows_reader.preview_ocr(123, '456')['issueCode'], 'busy')
            capture.assert_not_called()
        with patch.object(windows_reader.windows_client, 'capture', side_effect=ValueError('invalid window')):
            with self.assertRaises(ValueError):
                windows_reader.preview_ocr(123, '456')
        self.assertFalse(windows_reader._reading.locked())


if __name__ == '__main__':
    unittest.main()
