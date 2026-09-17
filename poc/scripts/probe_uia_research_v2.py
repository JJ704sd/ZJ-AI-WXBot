"""E0/E1 diagnostic only: synthetic positive control then bounded provider metadata."""
import argparse
import ctypes
import hashlib
import json
import re
import subprocess
import sys
import tempfile
import time
import uuid
from datetime import datetime, timezone
from pathlib import Path

PATTERNS = {'text': 30040, 'text2': 30119, 'value': 30043,
            'legacy': 30090, 'item_container': 30108}


def is_fixture_window(class_name, title):
    return class_name == 'CodexUiaSyntheticFixture' and title == 'Synthetic UIA control'


def provider_labels(value):
    lowered = value.lower()
    return [label for label in ('msaa', 'proxy', 'hwnd', 'qt', 'uiautomationcore', 'oleacc')
            if label in lowered]


def property_result(element, prop, unsupported, encode=lambda x: x):
    try:
        value = element.GetCurrentPropertyValueEx(prop, True)
        if unsupported(value):
            return {'state': 'not_supported', 'value': None}
        return {'state': 'observed', 'value': encode(value)}
    except Exception as exc:
        return {'state': 'error', 'value': None, 'error_type': type(exc).__name__,
                'hresult': getattr(exc, 'hresult', None)}


def strict_bool(value):
    if type(value) is not bool:
        raise TypeError('unexpected property type')
    return value


def class_label(value):
    return value if isinstance(value, str) and re.fullmatch(r'[A-Za-z0-9_:.$-]{0,120}', value) else 'withheld'


def fixture(path):
    import win32api
    import win32con
    import win32gui
    def proc(hwnd, message, wparam, lparam):
        if message == win32con.WM_DESTROY:
            win32gui.PostQuitMessage(0)
            return 0
        return win32gui.DefWindowProc(hwnd, message, wparam, lparam)
    wc = win32gui.WNDCLASS()
    wc.hInstance = win32api.GetModuleHandle(None)
    wc.lpszClassName = 'CodexUiaSyntheticFixture'
    wc.lpfnWndProc = proc
    atom = win32gui.RegisterClass(wc)
    root = win32gui.CreateWindow(atom, 'Synthetic UIA control', win32con.WS_OVERLAPPEDWINDOW,
                                40, 40, 400, 240, 0, 0, wc.hInstance, None)
    for index, name in enumerate(('EDIT', 'LISTBOX', 'BUTTON')):
        win32gui.CreateWindow(name, '', win32con.WS_CHILD | win32con.WS_VISIBLE | win32con.WS_BORDER,
                              20, 20 + 50 * index, 250, 40, root, 100 + index, wc.hInstance, None)
    win32gui.ShowWindow(root, win32con.SW_SHOWNOACTIVATE)
    Path(path).write_text(json.dumps({'hwnd': root}), encoding='utf-8')
    win32gui.PumpMessages()


def new_api():
    sys.coinit_flags = 0  # MTA before importing comtypes; this process owns no windows.
    import comtypes
    import comtypes.client
    module = comtypes.client.GetModule('UIAutomationCore.dll')
    api = comtypes.client.CreateObject('{e22ad333-b25f-460c-83d0-0581107395c9}', interface=module.IUIAutomation)
    sentinel = api.ReservedNotSupportedValue.QueryInterface(comtypes.IUnknown)
    address = ctypes.cast(sentinel, ctypes.c_void_p).value
    def unsupported(value):
        if not hasattr(value, 'QueryInterface'):
            return False
        return ctypes.cast(value.QueryInterface(comtypes.IUnknown), ctypes.c_void_p).value == address
    return api, unsupported


def binding(hwnd):
    import psutil
    import win32gui
    import win32process
    if not win32gui.IsWindow(hwnd):
        raise RuntimeError('invalid_window')
    _, pid = win32process.GetWindowThreadProcessId(hwnd)
    session = ctypes.c_ulong()
    if not ctypes.windll.kernel32.ProcessIdToSessionId(pid, ctypes.byref(session)):
        raise OSError('session_query_failed')
    return {'pid': pid, 'process_started': psutil.Process(pid).create_time(),
            'session_id': session.value, 'hwnd': hwnd, 'class': win32gui.GetClassName(hwnd)}


def snapshot(api, unsupported, hwnd):
    import win32gui
    import win32process
    before = binding(hwnd)
    root = api.ElementFromHandle(hwnd)
    queue = [(root, None, 0)]
    rows = []
    truncated = False
    walker = api.RawViewWalker
    while queue:
        element, parent, depth = queue.pop(0)
        if element.CurrentProcessId != before['pid']:
            raise RuntimeError('foreign_element')
        index = len(rows)
        rows.append({'index': index, 'parent': parent, 'depth': depth,
                     'control_type': element.CurrentControlType,
                     'class': class_label(element.CurrentClassName),
                     'patterns': {key: property_result(element, prop, unsupported, strict_bool)
                                  for key, prop in PATTERNS.items()}})
        child = walker.GetFirstChildElement(element)
        if depth >= 6:
            truncated |= bool(child)
            continue
        while child:
            if len(rows) + len(queue) >= 128:
                truncated = True
                break
            queue.append((child, index, depth + 1))
            child = walker.GetNextSiblingElement(child)
    targets = [hwnd]
    def collect(h, _):
        if (len(targets) < 8 and win32gui.GetClassName(h) == 'MMUIRenderSubWindowHW'
                and win32process.GetWindowThreadProcessId(h)[1] == before['pid']):
            targets.append(h)
    win32gui.EnumChildWindows(hwnd, collect, None)
    method = ctypes.WinDLL('UIAutomationCore').UiaHasServerSideProvider
    method.argtypes = [ctypes.c_void_p]
    method.restype = ctypes.c_int
    providers = []
    for handle in targets:
        element = api.ElementFromHandle(handle)
        providers.append({'hwnd': handle,
            'server_side': {'state': 'observed', 'value': bool(method(handle))},
            'source_labels': property_result(element, 30107, unsupported, provider_labels),
            'framework': property_result(element, 30024, unsupported,
                lambda x: x if x in ('Win32', 'Qt', 'WPF', 'XAML', '') else 'withheld')})
    after = binding(hwnd)
    return {'binding_before': before, 'binding_after': after, 'binding_stable': before == after,
            'minimized': bool(win32gui.IsIconic(hwnd)),
            'foreground': win32gui.GetForegroundWindow() == hwnd,
            'nodes': rows, 'truncated': truncated, 'providers': providers}


def collect(mode, fixture_hwnd=None):
    import psutil
    import win32gui
    import win32process
    result = {'schema': 'uia-research-v2/1', 'experiment': mode,
              'run_id': str(uuid.uuid4()), 'started_at': datetime.now(timezone.utc).isoformat(),
              'probe_sha256': hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
              'execution_status': 'error', 'observation_status': 'not_observed',
              'capability_status': 'unverified', 'message_read': False, 'sent': False,
              'account_verified': False, 'group_verified': False, 'native_at_verified': False,
              'apartment': 'MTA', 'budget': {'seconds': 15, 'nodes': 128, 'depth': 6}}
    try:
        api, unsupported = new_api()
        if mode == 'E0':
            hwnd = fixture_hwnd
            if not is_fixture_window(win32gui.GetClassName(hwnd), win32gui.GetWindowText(hwnd)):
                raise RuntimeError('fixture_not_owned')
        else:
            pids = {p.pid for p in psutil.process_iter(['name'])
                    if (p.info['name'] or '').lower() == 'weixin.exe'}
            handles = []
            def target(h, _):
                if (win32process.GetWindowThreadProcessId(h)[1] in pids and win32gui.IsWindowVisible(h)
                        and win32gui.GetClassName(h) == 'Qt51514QWindowIcon'):
                    handles.append(h)
            win32gui.EnumWindows(target, None)
            if len(handles) != 1:
                raise RuntimeError('ambiguous_window')
            hwnd = handles[0]
        data = snapshot(api, unsupported, hwnd)
        result['snapshot'] = data
        if not data['binding_stable']:
            result['execution_status'] = 'invalidated'
            return result
        result.update(execution_status='completed', observation_status='incomplete' if data['truncated'] else 'observed')
        if mode == 'E0':
            root = api.ElementFromHandle(hwnd)
            result['unsupported_probe'] = property_result(root, 30045, unsupported)
            result['invalid_property_probe'] = property_result(root, -1, unsupported)
            # Close only the synthetic fixture owned by the supplied PID/HWND.
            win32gui.PostMessage(hwnd, 0x0010, 0, 0)
            deadline = time.monotonic() + 2
            while win32gui.IsWindow(hwnd) and time.monotonic() < deadline:
                time.sleep(.02)
            result['closed_window_invalidated'] = not bool(win32gui.IsWindow(hwnd))
            result['stale_property'] = property_result(root, 30003, unsupported)
            # COM may return cached metadata after destruction. Target validity is separate.
            try:
                result['closed_target_status'] = 'valid' if binding(hwnd) == data['binding_before'] else 'invalidated'
            except RuntimeError:
                result['closed_target_status'] = 'invalidated'
            found = {row['control_type'] for row in data['nodes'] if row['parent'] == 0}
            result['positive_control_passed'] = (
                {50000, 50004, 50008}.issubset(found) and not data['truncated']
                and result['unsupported_probe']['state'] == 'not_supported'
                and result['closed_window_invalidated']
                and result['closed_target_status'] == 'invalidated'
                and result['invalid_property_probe']['state'] == 'error')
        else:
            import win32api
            executable = Path(psutil.Process(data['binding_before']['pid']).exe())
            version = win32api.GetFileVersionInfo(str(executable), '\\')
            ms, ls = version['FileVersionMS'], version['FileVersionLS']
            result['client_version'] = '.'.join(map(str, (ms >> 16, ms & 65535, ls >> 16, ls & 65535)))
            result['exe_sha256'] = hashlib.sha256(executable.read_bytes()).hexdigest()
            if binding(hwnd) != data['binding_before']:
                result['execution_status'] = 'invalidated'
            elif not data['truncated']:
                semantic = any(row['class'].startswith('mmui::') for row in data['nodes'])
                result['capability_status'] = 'candidate' if semantic else 'blocked'
    except Exception as exc:
        result.update(execution_status='error', error_type=type(exc).__name__, hresult=getattr(exc, 'hresult', None))
    return result


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('mode', choices=['E0', 'E1', 'fixture'])
    parser.add_argument('--worker', action='store_true')
    parser.add_argument('--hwnd', type=int)
    parser.add_argument('--output', required=True)
    args = parser.parse_args()
    if args.mode == 'fixture':
        fixture(args.output)
        return
    if args.worker:
        Path(args.output).write_text(json.dumps(collect(args.mode, args.hwnd), indent=2), encoding='utf-8')
        return
    with tempfile.TemporaryDirectory(prefix='uia-v2-') as tmp:
        process = None
        try:
            hwnd = None
            if args.mode == 'E0':
                ready = Path(tmp) / 'fixture.json'
                process = subprocess.Popen([sys.executable, __file__, 'fixture', '--output', str(ready)],
                                           stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL,
                                           creationflags=0x08000000)
                deadline = time.monotonic() + 5
                while not ready.exists() and process.poll() is None and time.monotonic() < deadline:
                    time.sleep(.03)
                hwnd = json.loads(ready.read_text())['hwnd']
            output = Path(tmp) / 'report.json'
            command = [sys.executable, __file__, args.mode, '--worker', '--output', str(output)]
            if hwnd:
                command += ['--hwnd', str(hwnd)]
            try:
                subprocess.run(command, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL,
                               timeout=15, check=False, creationflags=0x08000000)
                result = json.loads(output.read_text(encoding='utf-8'))
            except subprocess.TimeoutExpired:
                result = {'experiment': args.mode, 'execution_status': 'timed_out',
                          'observation_status': 'not_observed', 'capability_status': 'unverified'}
            Path(args.output).write_text(json.dumps(result, indent=2), encoding='utf-8')
            print(json.dumps(result))
        finally:
            if process and process.poll() is None:
                process.terminate()  # only the synthetic process created above
                process.wait(timeout=3)


if __name__ == '__main__':
    main()
