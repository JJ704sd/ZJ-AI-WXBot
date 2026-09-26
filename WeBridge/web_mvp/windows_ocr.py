"""Local Windows OCR for an explicitly captured PNG, without account inference.

The WinRT worker is adapted from the existing wechat_agent_poc WindowsOcr path.
This module does not capture a screen, read a database, call a cloud service, or
turn visible text into messages. The caller owns window/region confirmation.
"""
import json
import math
import os
from pathlib import Path
import re
import struct
import subprocess
import tempfile


SCRIPT = Path(__file__).resolve().parents[1] / 'scripts' / 'windows_ocr.ps1'
IS_WINDOWS = os.name == 'nt'
MAX_IMAGE_BYTES = 20 * 1024 * 1024


def _result(status, *, lines=None, language='zh-Hans', **extra):
    messages = {
        'ok': '已在本机识别选定区域；文字可能存在 OCR 误识别。',
        'unsupported': '此 OCR 入口仅支持 Windows。',
        'ocr_initialization_failed': '无法初始化 Windows OCR；请检查系统是否支持 Windows.Media.Ocr。',
        'ocr_language_unavailable': '系统没有所选 OCR 语言；请选择已安装语言，或在 Windows 设置中添加对应语言包。',
        'ocr_decode_failed': '无法解码图片；请重新截取选定的微信区域。',
        'ocr_image_too_large': '所选图片超过系统 OCR 尺寸限制；请缩小采集区域后重试。',
        'ocr_recognition_failed': '系统 OCR 识别失败；请确认图片清晰并重试。',
        'ocr_timeout': '本机 OCR 已超时停止；请缩小采集区域后重试。',
        'ocr_no_text': '所选区域没有识别到文字；请确认测试会话可见、区域包含清晰文字后重试。',
        'ocr_unavailable_or_failed': '本机 OCR 没有返回有效结果；请检查系统 PowerShell 和 OCR 语言包后重试。',
    }
    return {'ok': status == 'ok', 'status': status, 'source': 'windows-ocr',
            'engine': 'Windows.Media.Ocr', 'language': language, 'lines': lines or [],
            'texts': [{'text': line['text'], 'controlType': 'OCR'} for line in lines or []],
            'message': messages[status], 'issue': messages[status],
            'issueCode': '' if status == 'ok' else status, 'truncated': False,
            'availableLanguages': [],
            'identityVerified': False, 'newMessagesVerified': False,
            'nativeMentionsVerified': False, 'canSend': False, 'readOnly': True, **extra}


def _png_dimensions(data):
    if (not isinstance(data, bytes) or not 33 <= len(data) <= MAX_IMAGE_BYTES
            or data[:8] != b'\x89PNG\r\n\x1a\n' or data[8:16] != b'\x00\x00\x00\rIHDR'):
        raise ValueError('需要有效的 PNG 图片。')
    width, height = struct.unpack('>II', data[16:24])
    if not 1 <= width <= 10000 or not 1 <= height <= 10000 or width * height > 25_000_000:
        raise ValueError('图片尺寸超出 OCR 范围。')
    return width, height


def recognize_png(data, language='zh-Hans', timeout=15):
    """Recognize already selected pixels; temporary crops are always removed."""
    width, height = _png_dimensions(data)
    if not isinstance(language, str) or not re.fullmatch(r'[A-Za-z]{2,3}(?:-[A-Za-z0-9]{2,8}){0,2}', language):
        raise ValueError('OCR 语言标识无效。')
    if not IS_WINDOWS:
        return _result('unsupported', language=language)
    powershell = Path(os.environ.get('SystemRoot', r'C:\Windows')) / 'System32/WindowsPowerShell/v1.0/powershell.exe'
    with tempfile.TemporaryDirectory(prefix='webridge-ocr-') as directory:
        source = Path(directory) / 'crop.png'
        output = Path(directory) / 'result.json'
        source.write_bytes(data)
        try:
            run = subprocess.run(
                [str(powershell), '-NoLogo', '-NoProfile', '-NonInteractive',
                 '-ExecutionPolicy', 'Bypass', '-File', str(SCRIPT),
                 '-ImagePath', str(source), '-OutputPath', str(output), '-Language', language],
                stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, timeout=timeout,
                creationflags=getattr(subprocess, 'CREATE_NO_WINDOW', 0))
            if not output.is_file() or output.stat().st_size > 500_000:
                return _result('ocr_unavailable_or_failed', language=language)
            result = json.loads(output.read_text(encoding='utf-8-sig'))
            if not isinstance(result, dict):
                raise ValueError('Invalid OCR result')
            status = result.get('status')
            languages = result.get('availableLanguages', [])
            if not isinstance(languages, list) or any(not isinstance(value, str) or len(value) > 40 for value in languages):
                languages = []
            known_failures = {'ocr_initialization_failed', 'ocr_language_unavailable',
                              'ocr_decode_failed', 'ocr_image_too_large', 'ocr_recognition_failed'}
            if status in known_failures:
                return _result(status, language=language, availableLanguages=languages)
            if status != 'ok' or run.returncode != 0:
                return _result('ocr_unavailable_or_failed', language=language)
            rows = result.get('lines')
            if not isinstance(rows, list) or len(rows) > 500:
                raise ValueError('Invalid OCR lines')
            clean = []
            characters = 0
            for row in rows:
                text, box = row.get('text'), row.get('box')
                if (not isinstance(text, str) or len(text) > 10000
                        or not isinstance(box, list) or len(box) != 4
                        or any(type(v) not in (int, float) or not math.isfinite(v) for v in box)
                        or not 0 <= box[0] < box[2] <= width or not 0 <= box[1] < box[3] <= height):
                    raise ValueError('Invalid OCR line')
                characters += len(text)
                if characters > 40000:
                    raise ValueError('Too much OCR text')
                clean.append({'text': text, 'box': box, 'sender': None,
                              'messageId': None, 'mentionStatus': 'unknown'})
            if not any(line['text'].strip() for line in clean):
                return _result('ocr_no_text', language=language, availableLanguages=languages)
            return _result('ok', lines=clean, language=language, width=width, height=height,
                           availableLanguages=languages)
        except subprocess.TimeoutExpired:
            return _result('ocr_timeout', language=language)
        except (OSError, ValueError, TypeError, AttributeError):
            return _result('ocr_unavailable_or_failed', language=language)
