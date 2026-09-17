"""Metadata-only wxauto4 compatibility probe; no message read or send."""
import argparse
import importlib.util
import importlib.metadata
import json
import os
import subprocess
import sys
import tempfile
from pathlib import Path
import traceback
import re


def redact_error(text):
    text = str(text)[:2000]
    text = re.sub(r'https?://\S+|[A-Za-z]:[\\/][^\s]+', '[location]', text)
    text = re.sub(r'wxid_[\w-]+|\b[\w.+-]+@[\w.-]+\b', '[identity]', text)
    text = re.sub(r'(?i)(bearer\s+|(?:token|key|password|secret)\s*[:=]\s*)\S+', '[credential]', text)
    text = re.sub(r'(?i)\b(?:secret|token|password|key)[_-][\w-]+', '[credential]', text)
    text = re.sub(r'[A-Za-z0-9_+/=-]{24,}', '[opaque]', text)
    text = re.sub(r'([\"\']).*?\1', '[quoted]', text)
    return text[:300]


def exception_signal(exc):
    text = str(exc).lower()
    categories = []
    for category, words in {
        'window_not_found': ('找不到微信', '未找到微信', '未找到已登录的客户端主窗口', '微信未启动', '微信未打开', 'window not found'),
        'login_required': ('未登录', 'not logged'),
        'access_denied': ('拒绝访问', 'access denied'),
        'control_unavailable': ('控件', 'control'),
        'unsupported_version': ('版本', 'version'),
        'timeout': ('timeout', '超时'),
    }.items():
        if any(word in text for word in words):
            categories.append(category)
    frames = []
    for frame in traceback.extract_tb(exc.__traceback__):
        # File basename and code position only; omit source lines and local values.
        frames.append({'file': Path(frame.filename).name, 'line': frame.lineno,
                       'function': frame.name})
    return {'error_type': type(exc).__name__, 'categories': categories or ['unclassified'],
            'message_redacted': redact_error(exc),
            'winerror': getattr(exc, 'winerror', None), 'frames': frames[-6:]}


def bounded_worker(result_path, *, run=subprocess.run):
    try:
        run([sys.executable, str(Path(__file__).resolve()), '--worker', str(result_path)],
            stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, timeout=30, check=False)
        if not result_path.is_file():
            return {'status': 'worker_failed_without_report'}
        return json.loads(result_path.read_text(encoding='utf-8'))
    except subprocess.TimeoutExpired:
        return {'status': 'probe_timeout', 'deadline_seconds': 30}


def worker(path):
    report = {'status': 'uia_probe_failed', 'constructor_entered': False,
              'chatinfo_called': False, 'message_read': False, 'sent': False}
    try:
        from diagnose_wxauto_window import worker as inspect_structure
        with tempfile.TemporaryDirectory(prefix='uia-preflight-') as folder:
            preflight = Path(folder) / 'structure.json'
            inspect_structure(preflight)
            observed = json.loads(preflight.read_text(encoding='utf-8'))
        report['compatibility'] = observed['compatibility']
        if observed['compatibility'] != 'constructor_candidate':
            report['status'] = 'compatibility_blocked'
            Path(path).write_text(json.dumps(report), encoding='utf-8')
            return
        from wxauto4 import WeChat, WxParam
        WxParam.ENABLE_FILE_LOGGER = False
        report['constructor_entered'] = True
        wx = WeChat(ads=False, resize=False, debug=False)
        report['chatinfo_called'] = True
        info = wx.ChatInfo()
        report['chat_title_available'] = isinstance(info, dict) and bool(info.get('chat_name'))
        report['status'] = 'metadata_available' if report['chat_title_available'] else 'uia_unavailable'
    except Exception as exc:
        report.update(exception_signal(exc))
    Path(path).write_text(json.dumps(report), encoding='utf-8')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--live', action='store_true', help='Attach to UI and inspect ChatInfo only')
    parser.add_argument('--worker', help=argparse.SUPPRESS)
    args = parser.parse_args()
    if args.worker:
        worker(args.worker)
        return 0
    available = importlib.util.find_spec('wxauto4') is not None
    report = {'wxauto4_installed': available, 'live_requested': args.live,
              'message_read': False, 'sent': False, 'binding_verified': False}
    if not available:
        report['status'] = 'dependency_missing'
    elif not args.live:
        report['status'] = 'not_executed'
    else:
        report['wxauto4_version'] = importlib.metadata.version('wxauto4')
        with tempfile.TemporaryDirectory(prefix='uia-metadata-') as folder:
            report.update(bounded_worker(Path(folder) / 'result.json'))
    print(json.dumps(report))
    return 0 if report['status'] in ('metadata_available', 'not_executed') else 2


if __name__ == '__main__':
    raise SystemExit(main())
