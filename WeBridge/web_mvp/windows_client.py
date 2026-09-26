"""Explicit, read-only inspection of the local Windows WeChat UI.

No database/key extraction, input injection, clipboard access, or persistence.
UI text cannot establish a conversation's identity or full message coverage.
"""
import base64
import binascii
import json
import os
from pathlib import Path
import subprocess
import struct


PROBE = Path(__file__).resolve().parents[1] / 'scripts' / 'windows_probe.ps1'
IS_WINDOWS = os.name == 'nt'
LIMITATION = '仅能读取当前可见窗口向 Windows 辅助功能公开的文字；无法确认群 ID、发送者身份或消息完整性，不提供发送。'
MAX_CAPTURE_BYTES = 8 * 1024 * 1024
SOURCES = {'inspect': 'windows-uia-inspect', 'capture': 'windows-window-capture'}


def _failure(code, issue):
    return {'ok': False, 'supported': IS_WINDOWS, 'available': False,
            'source': 'windows-uia', 'identityVerified': False, 'canSend': False,
            'readOnly': True, 'issueCode': code, 'issue': issue,
            'windows': [], 'processes': [], 'processCount': 0, 'texts': []}


def _run(mode, *arguments):
    def failed(code, issue):
        data = _failure(code, issue)
        data['source'] = SOURCES.get(mode, 'windows-uia')
        return data

    if not IS_WINDOWS:
        return failed('unsupported', '此入口仅支持本台 Windows 微信。')
    system_root = os.environ.get('SystemRoot', r'C:\Windows')
    powershell = Path(system_root) / 'System32/WindowsPowerShell/v1.0/powershell.exe'
    command = [str(powershell), '-NoLogo', '-NoProfile', '-NonInteractive',
               '-ExecutionPolicy', 'Bypass', '-File', str(PROBE), '-Mode', mode, *arguments]
    try:
        result = subprocess.run(command, capture_output=True, text=True, encoding='utf-8',
                                errors='replace', timeout=12,
                                creationflags=getattr(subprocess, 'CREATE_NO_WINDOW', 0))
        if result.returncode:
            return failed('probe_failed', 'Windows 只读检测未完成；请检查当前用户是否可访问微信窗口后重试。')
        limit = ((MAX_CAPTURE_BYTES + 2) // 3 * 4 + 20_000) if mode == 'capture' else 200_000
        if len(result.stdout) > limit:
            return failed('invalid_result', 'Windows 检测返回过多内容，已停止展示。')
        data = json.loads(result.stdout.lstrip('\ufeff'))
        if not isinstance(data, dict):
            raise ValueError('invalid probe result')
        data.update(source=SOURCES.get(mode, 'windows-uia'), identityVerified=False, canSend=False, readOnly=True)
        if mode == 'inspect':
            allowed = {'ok', 'supported', 'available', 'source', 'identityVerified', 'canSend', 'readOnly',
                       'issueCode', 'nodeCount', 'controlTypes', 'truncated', 'pid', 'hwnd'}
            data = {key: value for key, value in data.items() if key in allowed}
        issue = data.get('issueCode', '')
        translated = {
            'not_running': '未发现本台微信进程。请手动打开 Windows 微信后重新检测。',
            'no_visible_window': '微信进程正在运行，但没有可读取的可见窗口。请手动打开微信主窗口并取消最小化。',
            'window_changed': '窗口已经关闭、隐藏、最小化或不再属于所选微信进程；请重新检测。',
            'no_accessible_text': '此窗口没有公开可读取的文字。当前微信版本可能不支持此辅助功能入口。',
            'uia_unavailable': '无法访问窗口的辅助功能树。请确认微信与工作台运行在同一用户桌面，并重试。',
            'window_occluded': '微信窗口被其他窗口遮挡。请将微信与工作台并排放置，移开遮挡后重试。',
            'window_outside_desktop': '微信窗口部分位于屏幕之外，请完整移到屏幕内后重试。',
            'input_desktop_unavailable': '当前用户桌面不可读取；请解锁电脑，并在微信所在的用户桌面运行工作台。',
            'capture_too_large': '微信窗口图像超过 8 MB 或 5000 像素边长限制，请缩小窗口后重试。',
            'capture_unavailable': '无法截取所选微信窗口。请确认窗口可见且无遮挡后重试。',
            'blank_capture': '没有取得有效窗口图像；请确认微信正常显示后重试。',
        }
        default = ('仅检查辅助功能控件类型与数量，未读取控件名称、值或聊天正文。' if mode == 'inspect'
                   else '仅在内存中截取所选窗口的可见区域供本地 OCR；无法验证会话身份或消息完整性。' if mode == 'capture'
                   else LIMITATION)
        data['issue'] = translated.get(issue, default)
        if mode == 'capture' and data.get('ok'):
            encoded = data.get('png_base64')
            if not isinstance(encoded, str) or len(encoded) > (MAX_CAPTURE_BYTES + 2) // 3 * 4:
                raise ValueError('invalid capture size')
            png = base64.b64decode(encoded, validate=True)
            if len(png) > MAX_CAPTURE_BYTES or len(png) < 33 or png[:8] != b'\x89PNG\r\n\x1a\n' or png[12:16] != b'IHDR':
                raise ValueError('invalid PNG capture')
            width, height = struct.unpack('>II', png[16:24])
            geometry = data.get('geometry', {})
            if not isinstance(geometry, dict) or not (0 < width <= 5000 and 0 < height <= 5000) or geometry.get('width') != width or geometry.get('height') != height:
                raise ValueError('invalid capture geometry')
        elif mode == 'capture':
            data.pop('png_base64', None)
        return data
    except subprocess.TimeoutExpired:
        return failed('timeout', '微信窗口检测超时；已停止检测进程。请打开微信主窗口后重试。')
    except (OSError, ValueError, TypeError, binascii.Error):
        return failed('probe_failed', '无法执行 Windows 只读检测，请检查系统 PowerShell 是否可用。')


def status():
    """Inspect process/window metadata only; never read chat contents."""
    return _run('status')


def _window_arguments(pid, hwnd):
    if isinstance(pid, bool) or isinstance(hwnd, bool):
        raise ValueError('无效的微信进程或窗口。')
    try:
        process_id = str(pid)
        window_handle = str(hwnd)
        if not process_id.isascii() or not process_id.isdecimal() or not window_handle.isascii() or not window_handle.isdecimal():
            raise ValueError
        process_id = int(process_id)
        window_handle = int(window_handle)
        if not (0 < process_id <= 2**31 - 1 and 0 < window_handle <= 2**63 - 1):
            raise ValueError
    except (ValueError, TypeError, OverflowError):
        raise ValueError('无效的微信进程或窗口。') from None
    return ['-ProcessId', str(process_id), '-WindowHandle', str(window_handle)]


def preview(pid, hwnd):
    """Read visible accessible text only after an explicit window selection."""
    return _run('preview', *_window_arguments(pid, hwnd))


def inspect(pid, hwnd):
    """Read only UIA structure metadata; never names, values, or chat contents."""
    return _run('inspect', *_window_arguments(pid, hwnd))


def capture(pid, hwnd):
    """Internal OCR input only: capture an explicitly selected unoccluded window.

    The caller must not send png_base64 to the browser or persist/log it.
    """
    return _run('capture', *_window_arguments(pid, hwnd))


class WindowsClient:
    status = staticmethod(status)
    preview = staticmethod(preview)
    inspect = staticmethod(inspect)
    capture = staticmethod(capture)
