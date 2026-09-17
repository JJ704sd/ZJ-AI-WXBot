"""Three passive UIA routes; metadata only, no activation or text retrieval."""
import json
from pathlib import Path
import subprocess
import sys
import tempfile


def worker(path):
    report = {'status': 'failed', 'message_read': False, 'sent': False}
    try:
        import psutil
        import win32gui
        import win32process
        from wxauto4 import uia, WxParam
        from wxauto4.uia.uiautomation import _AutomationClient
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
        report['window_count'] = len(roots)
        if len(roots) != 1:
            raise RuntimeError('window_ambiguous')
        hwnd = roots[0]
        root = uia.ControlFromHandle(hwnd)
        report['minimized'] = bool(win32gui.IsIconic(hwnd))
        api = _AutomationClient.instance().IUIAutomation
        # FindAll uses a separate retrieval API from RawViewWalker.
        try:
            elements = root.Element.FindAll(4, api.CreateTrueCondition())
            count = elements.Length
            report['find_all'] = {'status': 'observed', 'count': count,
                'truncated': count > 128,
                'classes': [elements.GetElement(i).CurrentClassName for i in range(min(count, 128))]}
        except Exception as exc:
            report['find_all'] = {'status': 'error', 'error_type': type(exc).__name__}
        # Selected accessible children can be exposed even when generic traversal fails.
        try:
            pattern = root.GetLegacyIAccessiblePattern()
            selected = pattern.GetSelection() if pattern else []
            report['legacy_selection'] = {'status': 'observed' if pattern else 'unavailable',
                'count': len(selected), 'classes': [c.ClassName for c in selected[:16]]}
        except Exception as exc:
            report['legacy_selection'] = {'status': 'error', 'error_type': type(exc).__name__}
        # Hit-test only when the point belongs to this window; never inspect other apps.
        if report['minimized']:
            report['point'] = {'status': 'skipped_minimized'}
        else:
            left, top, right, bottom = win32gui.GetWindowRect(hwnd)
            point = ((left + right) // 2, (top + bottom) // 2)
            hit = win32gui.WindowFromPoint(point)
            if hit != hwnd and not win32gui.IsChild(hwnd, hit):
                report['point'] = {'status': 'skipped_occluded'}
            else:
                c = uia.ControlFromPoint(*point)
                report['point'] = {'status': 'observed', 'class': c.ClassName,
                                   'child_count': len(c.GetChildren())}
        report['status'] = 'observed'
    except Exception as exc:
        report['error_type'] = type(exc).__name__
    Path(path).write_text(json.dumps(report), encoding='utf-8')


if __name__ == '__main__':
    if len(sys.argv) == 3 and sys.argv[1] == '--worker':
        worker(sys.argv[2])
    else:
        with tempfile.TemporaryDirectory(prefix='uia-alternatives-') as folder:
            path = Path(folder) / 'result.json'
            try:
                subprocess.run([sys.executable, __file__, '--worker', str(path)],
                               stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL,
                               timeout=20, check=False)
                print(path.read_text(encoding='utf-8') if path.exists()
                      else '{"status":"worker_failed"}')
            except subprocess.TimeoutExpired:
                print('{"status":"timeout"}')
