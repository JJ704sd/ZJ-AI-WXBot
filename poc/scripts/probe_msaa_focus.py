"""Passive MSAA focus metadata only; no names, values or actions."""
import json
from pathlib import Path
import subprocess
import sys
import tempfile


def worker(path):
    result = {'status': 'failed', 'message_read': False, 'sent': False}
    try:
        import ctypes
        from ctypes import wintypes
        import comtypes
        import comtypes.client
        import win32gui
        import win32process
        import psutil
        interface = comtypes.client.GetModule('oleacc.dll').IAccessible
        method = ctypes.OleDLL('oleacc').AccessibleObjectFromWindow
        method.argtypes = [wintypes.HWND, wintypes.DWORD, ctypes.POINTER(comtypes.GUID),
                           ctypes.POINTER(ctypes.POINTER(interface))]
        method.restype = ctypes.HRESULT
        pids = {p.pid for p in psutil.process_iter(['name'])
                if (p.info['name'] or '').lower() == 'weixin.exe'}
        handles = []
        def collect(hwnd, _):
            if (win32process.GetWindowThreadProcessId(hwnd)[1] in pids
                    and win32gui.IsWindowVisible(hwnd)):
                handles.append(hwnd)
        win32gui.EnumWindows(collect, None)
        if len(handles) != 1:
            raise RuntimeError('ambiguous')
        root = handles[0]
        def child(hwnd, _):
            if len(handles) < 8:
                handles.append(hwnd)
        win32gui.EnumChildWindows(root, child, None)
        rows = []
        for hwnd in handles:
            row = {'class': win32gui.GetClassName(hwnd)}
            try:
                ptr = ctypes.POINTER(interface)()
                method(hwnd, 0xFFFFFFFC, ctypes.byref(interface._iid_), ctypes.byref(ptr))
                focus = ptr.accFocus
                if focus is None:
                    row['focus_kind'] = 'none'
                elif isinstance(focus, int):
                    row['focus_kind'] = 'self' if focus == 0 else 'child_id'
                else:
                    row['focus_kind'] = 'object'
                    focused = focus.QueryInterface(interface)
                    row['focused_child_count'] = int(focused.accChildCount)
            except Exception as exc:
                row['error_type'] = type(exc).__name__
            rows.append(row)
        result.update(status='observed', windows=rows)
    except Exception as exc:
        result['error_type'] = type(exc).__name__
    Path(path).write_text(json.dumps(result), encoding='utf-8')


if __name__ == '__main__':
    if len(sys.argv) == 3 and sys.argv[1] == '--worker':
        worker(sys.argv[2])
    else:
        with tempfile.TemporaryDirectory(prefix='msaa-focus-') as folder:
            path = Path(folder) / 'result.json'
            try:
                subprocess.run([sys.executable, __file__, '--worker', str(path)],
                               stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL,
                               timeout=20, check=False)
                print(path.read_text(encoding='utf-8') if path.exists() else '{"status":"worker_failed"}')
            except subprocess.TimeoutExpired:
                print('{"status":"timeout"}')
