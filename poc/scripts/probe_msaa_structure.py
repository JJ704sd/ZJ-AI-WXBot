"""One bounded MSAA OBJID_CLIENT query per target HWND; structural counts only."""
import json
import subprocess
import sys
import tempfile
from pathlib import Path


def worker(path):
    report = {'status': 'failed', 'message_read': False, 'sent': False}
    try:
        import ctypes
        from ctypes import wintypes
        import comtypes
        import comtypes.client
        import win32gui
        import win32process
        import psutil
        module = comtypes.client.GetModule('oleacc.dll')
        interface = module.IAccessible
        oleacc = ctypes.OleDLL('oleacc')
        method = oleacc.AccessibleObjectFromWindow
        method.argtypes = [wintypes.HWND, wintypes.DWORD, ctypes.POINTER(comtypes.GUID),
                           ctypes.POINTER(ctypes.POINTER(interface))]
        method.restype = ctypes.HRESULT
        pids = {p.pid for p in psutil.process_iter(['name'])
                if (p.info['name'] or '').lower() == 'weixin.exe'}
        handles = []
        def collect(hwnd, _):
            _, pid = win32process.GetWindowThreadProcessId(hwnd)
            if pid in pids and win32gui.IsWindowVisible(hwnd):
                handles.append(hwnd)
        win32gui.EnumWindows(collect, None)
        if len(handles) != 1:
            raise RuntimeError('ambiguous')
        root = handles[0]
        children = []
        win32gui.EnumChildWindows(root, lambda h, _: children.append(h), None)
        rows = []
        for hwnd in [root] + children[:4]:
            entry = {'class': win32gui.GetClassName(hwnd)}
            try:
                pointer = ctypes.POINTER(interface)()
                method(hwnd, 0xFFFFFFFC, ctypes.byref(interface._iid_), ctypes.byref(pointer))
                entry['accessible'] = bool(pointer)
                entry['child_count'] = int(pointer.accChildCount) if pointer else None
            except Exception as exc:
                entry['error_type'] = type(exc).__name__
                entry['hresult'] = getattr(exc, 'hresult', None)
            rows.append(entry)
        report.update(status='observed', windows=rows)
    except Exception as exc:
        report['error_type'] = type(exc).__name__
    Path(path).write_text(json.dumps(report), encoding='utf-8')


if __name__ == '__main__':
    if len(sys.argv) == 3:
        worker(sys.argv[2])
    else:
        with tempfile.TemporaryDirectory(prefix='msaa-structure-') as folder:
            path = Path(folder) / 'result.json'
            try:
                subprocess.run([sys.executable, __file__, '--worker', str(path)],
                               stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL,
                               timeout=20, check=False)
                print(path.read_text(encoding='utf-8') if path.exists() else '{"status":"worker_failed"}')
            except subprocess.TimeoutExpired:
                print('{"status":"timeout"}')
