"""Read-only CUIAutomation8 comparison, without importing wxauto4."""
import json
from pathlib import Path
import subprocess
import sys
import tempfile


def worker(path):
    result = {'status': 'failed', 'message_read': False, 'sent': False}
    try:
        import comtypes.client
        import psutil
        import win32gui
        import win32process
        pids = {p.pid for p in psutil.process_iter(['name'])
                if (p.info['name'] or '').lower() == 'weixin.exe'}
        handles = []
        def collect(hwnd, _):
            if (win32process.GetWindowThreadProcessId(hwnd)[1] in pids
                    and win32gui.IsWindowVisible(hwnd)
                    and win32gui.GetClassName(hwnd) == 'Qt51514QWindowIcon'):
                handles.append(hwnd)
        win32gui.EnumWindows(collect, None)
        result['window_count'] = len(handles)
        if len(handles) != 1:
            raise RuntimeError('ambiguous')
        module = comtypes.client.GetModule('UIAutomationCore.dll')
        api = comtypes.client.CreateObject('{e22ad333-b25f-460c-83d0-0581107395c9}',
                                          interface=module.IUIAutomation)
        root = api.ElementFromHandle(handles[0])
        children = root.FindAll(4, api.CreateTrueCondition())
        result.update(status='observed', root_class=root.CurrentClassName,
                      minimized=bool(win32gui.IsIconic(handles[0])),
                      descendant_count=children.Length, truncated=children.Length > 128,
                      classes=[children.GetElement(i).CurrentClassName
                               for i in range(min(children.Length, 128))])
    except Exception as exc:
        result['error_type'] = type(exc).__name__
    Path(path).write_text(json.dumps(result), encoding='utf-8')


if __name__ == '__main__':
    if len(sys.argv) == 3 and sys.argv[1] == '--worker':
        worker(sys.argv[2])
    else:
        with tempfile.TemporaryDirectory(prefix='uia8-') as folder:
            path = Path(folder) / 'result.json'
            try:
                subprocess.run([sys.executable, __file__, '--worker', str(path)],
                               stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL,
                               timeout=20, check=False)
                print(path.read_text(encoding='utf-8') if path.exists() else '{"status":"worker_failed"}')
            except subprocess.TimeoutExpired:
                print('{"status":"timeout"}')
