"""Bounded passive capability query: no text, activation, or mutation."""
import json
from pathlib import Path
import subprocess
import sys
import tempfile

PROPERTIES = {'text': 30040, 'text2': 30119, 'value': 30043,
              'legacy': 30090, 'item_container': 30108}


def observe_patterns(control):
    result = {}
    for name, property_id in PROPERTIES.items():
        try:
            value = control.GetPropertyValue(property_id)
            result[name] = value if type(value) is bool else None
        except Exception:
            result[name] = None
    return result


def worker(path):
    report = {'status': 'failed', 'message_read': False, 'sent': False,
              'binding_verified': False, 'read_verified': False}
    try:
        import psutil
        import win32gui
        import win32process
        from wxauto4 import uia, WxParam
        WxParam.ENABLE_FILE_LOGGER = False
        pids = {p.pid for p in psutil.process_iter(['name'])
                if (p.info['name'] or '').lower() == 'weixin.exe'}
        roots = []
        def collect(hwnd, _):
            if (win32process.GetWindowThreadProcessId(hwnd)[1] in pids
                    and win32gui.IsWindowVisible(hwnd)
                    and win32gui.GetClassName(hwnd) == 'Qt51514QWindowIcon'):
                roots.append(hwnd)
        win32gui.EnumWindows(collect, None)
        report.update(weixin_process_count=len(pids), matching_window_count=len(roots))
        if len(roots) != 1:
            report['status'] = 'window_absent_or_ambiguous'
        else:
            root = roots[0]
            handles = [root]
            def child(hwnd, _):
                if len(handles) < 16:
                    handles.append(hwnd)
            win32gui.EnumChildWindows(root, child, None)
            rows = []
            for hwnd in handles:
                control = uia.ControlFromHandle(hwnd)
                rows.append({'class': win32gui.GetClassName(hwnd),
                             'patterns': observe_patterns(control)})
            report.update(status='observed', minimized=bool(win32gui.IsIconic(root)),
                          windows=rows, window_limit=16)
    except Exception as exc:
        report['error_type'] = type(exc).__name__
    Path(path).write_text(json.dumps(report), encoding='utf-8')


if __name__ == '__main__':
    if len(sys.argv) == 3 and sys.argv[1] == '--worker':
        worker(sys.argv[2])
    else:
        with tempfile.TemporaryDirectory(prefix='uia-patterns-') as folder:
            path = Path(folder) / 'result.json'
            try:
                subprocess.run([sys.executable, __file__, '--worker', str(path)],
                               stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL,
                               timeout=20, check=False)
                print(path.read_text(encoding='utf-8') if path.exists()
                      else '{"status":"worker_failed"}')
            except subprocess.TimeoutExpired:
                print('{"status":"timeout"}')
