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
        from wxauto4 import WeChat, WxParam
        WxParam.ENABLE_FILE_LOGGER = False
        report['constructor_entered'] = True
        wx = WeChat(ads=False, resize=False, debug=False)
        report['chatinfo_called'] = True
        info = wx.ChatInfo()
        report['chat_title_available'] = isinstance(info, dict) and bool(info.get('chat_name'))
        report['status'] = 'metadata_available' if report['chat_title_available'] else 'uia_unavailable'
    except Exception as exc:
        report['error_type'] = type(exc).__name__
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
