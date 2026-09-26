"""One explicit window capture followed by local Windows OCR, without persistence."""
import base64
import binascii
from datetime import datetime, timezone
import struct
import threading

import windows_client
from windows_ocr import recognize_png


_reading = threading.Lock()
_MAX_PNG = 8 * 1024 * 1024
_LIMITATION = '本机屏幕文字识别可能出现错字或遗漏；不证明群身份、发送者、消息完整性或真实 @，不提供发送。'


def _result(**fields):
    return {**fields, 'source': 'windows-ocr', 'identityVerified': False,
            'newMessagesVerified': False, 'nativeMentionsVerified': False,
            'canSend': False, 'readOnly': True}


def preview_ocr(pid, hwnd):
    """Capture only the selected unobstructed window and return text, never pixels."""
    if not _reading.acquire(blocking=False):
        return _result(ok=False, texts=[], issueCode='busy', issue='正在进行一次本机识别，请等待完成后再试。')
    try:
        captured = windows_client.capture(pid, hwnd)
        if not captured.get('ok'):
            return _result(ok=False, texts=[], issueCode=captured.get('issueCode', 'capture_failed'),
                           issue=captured.get('issue') or '无法获取所选窗口，请重新检测并确保窗口可见且无遮挡。')
        try:
            encoded = captured.get('png_base64', '')
            if not isinstance(encoded, str) or len(encoded) > ((_MAX_PNG + 2) // 3) * 4:
                raise ValueError('image limit')
            png = base64.b64decode(encoded, validate=True)
            if len(png) < 33 or len(png) > _MAX_PNG or png[:8] != b'\x89PNG\r\n\x1a\n' or png[8:16] != b'\x00\x00\x00\rIHDR':
                raise ValueError('invalid image')
            width, height = struct.unpack('>II', png[16:24])
            if not (1 <= width <= 5000 and 1 <= height <= 5000):
                raise ValueError('image dimensions')
        except (ValueError, TypeError, binascii.Error, struct.error):
            return _result(ok=False, texts=[], issueCode='invalid_capture', issue='窗口截图无效或超过大小限制，请缩小微信窗口并重试。')
        # Do not retain a second base64 copy during the OCR process.
        captured.pop('png_base64', None)
        encoded = None
        captured_at = datetime.now(timezone.utc).isoformat(timespec='seconds')
        try:
            recognized = recognize_png(png)
        except ValueError:
            return _result(ok=False, texts=[], issueCode='invalid_capture', issue='窗口截图无法识别，请重新检测窗口后重试。')
        texts = recognized.get('texts', []) if recognized.get('ok') else []
        return _result(ok=bool(recognized.get('ok')), texts=texts,
                       pid=captured.get('pid'), hwnd=captured.get('hwnd'),
                       title=captured.get('title', ''), version=captured.get('version', ''),
                       capturedAt=captured_at, language=recognized.get('language', ''),
                       languages=recognized.get('availableLanguages', recognized.get('languages', [])),
                       truncated=bool(recognized.get('truncated')),
                       issueCode=recognized.get('issueCode', ''),
                       issue=recognized.get('issue') or _LIMITATION)
    finally:
        _reading.release()
