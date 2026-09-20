"""One pinned visible Weixin window. No input, activation, or memory access."""
import ctypes
from ctypes import wintypes
import json
from pathlib import Path
import sys
import tempfile
import time

from .hybrid_observer import ObservationBlocked


def window_pid(hwnd):
    """Do not consume the PID output when Win32 reports a stale/invalid HWND."""
    if type(hwnd) is not int or hwnd <= 0:
        raise ObservationBlocked('invalid_window_handle')
    api = ctypes.WinDLL('user32', use_last_error=True)
    query = api.GetWindowThreadProcessId
    query.argtypes = [wintypes.HWND, ctypes.POINTER(wintypes.DWORD)]
    query.restype = wintypes.DWORD
    pid = wintypes.DWORD(0)
    thread_id = query(hwnd, ctypes.byref(pid))
    if not thread_id or not pid.value:
        raise ObservationBlocked('window_identity_unavailable')
    return pid.value


def wait_for_window(hwnd, capture_method='window', seconds=0):
    if type(seconds) is not int or not 0 <= seconds <= 30:
        raise ValueError('invalid_foreground_wait')
    deadline = time.monotonic() + seconds
    while True:
        try:
            return WindowsBackend(hwnd, capture_method)
        except ObservationBlocked as exc:
            if str(exc) not in ('window_not_foreground', 'window_hidden_or_minimized') or time.monotonic() >= deadline:
                raise
            time.sleep(.25)


def bounded_worker(hwnd, binding, layout=None, *, mode='uia', timeout=10):
    """Isolate COM hangs; reap only the worker tree created by this call."""
    import psutil
    with tempfile.TemporaryDirectory(prefix='wechat-readonly-uia-') as directory:
        config, output = Path(directory) / 'layout.json', Path(directory) / 'result.json'
        config.write_text(json.dumps({'binding': binding,
                                     'layout': vars(layout) if layout else None}), encoding='utf-8')
        process = psutil.Popen([sys.executable, '-m', 'wechat_agent_poc.hybrid_windows',
                                str(hwnd), str(config), str(output), mode],
                               cwd=str(Path(__file__).resolve().parents[1]),
                               stdout=-3, stderr=-3,
                               creationflags=0x08000000)
        try:
            code = process.wait(timeout)
        except psutil.TimeoutExpired:
            owned = process.children(recursive=True) + [process]
            for child in reversed(owned):
                try:
                    child.kill()
                except psutil.NoSuchProcess:
                    pass
            _, alive = psutil.wait_procs(owned, timeout=3)
            if alive:
                raise ObservationBlocked('worker_timeout_cleanup_incomplete') from None
            raise ObservationBlocked('worker_timeout') from None
        if code != 0 or not output.exists():
            error_path = output.with_suffix('.error.json')
            if error_path.exists():
                error = json.loads(error_path.read_text(encoding='utf-8'))
                raise ObservationBlocked(error.get('reason') or ('native_worker_failed:' + error['type'] + ':' + str(error['line'])))
            raise ObservationBlocked('native_worker_failed')
        if mode.startswith('capture'):
            from PIL import Image
            with Image.open(output) as image:
                return image.convert('RGB')
        return json.loads(output.read_text(encoding='utf-8'))


class WindowsBackend:
    def __init__(self, hwnd, capture_method='window'):
        import win32gui
        import psutil
        # Worker process only: do not change the host application's DPI policy.
        ctypes.windll.user32.SetProcessDpiAwarenessContext(ctypes.c_void_p(-4))
        self.hwnd = hwnd
        if capture_method not in ('window', 'screen_region'):
            raise ValueError('invalid_capture_method')
        self.capture_method = capture_method
        self.pid = window_pid(hwnd)
        process = psutil.Process(self.pid)
        if (process.name().lower() != 'weixin.exe'
                or win32gui.GetAncestor(hwnd, 2) != hwnd):
            raise ObservationBlocked('not_weixin_top_level')
        self.created = process.create_time()
        self.initial = self.observe()

    def observe(self):
        import win32gui
        import psutil
        user32 = ctypes.windll.user32
        user32.OpenInputDesktop.restype = ctypes.c_void_p
        desktop = user32.OpenInputDesktop(0, False, 0x0100)
        unlocked = False
        if desktop:
            try:
                # Query visibility only: do NOT call SwitchDesktop (changes desktop).
                name = ctypes.create_unicode_buffer(256)
                needed = ctypes.c_ulong()
                user32.GetUserObjectInformationW.argtypes = [ctypes.c_void_p, ctypes.c_int,
                                                            ctypes.c_void_p, ctypes.c_ulong,
                                                            ctypes.POINTER(ctypes.c_ulong)]
                unlocked = bool(user32.GetUserObjectInformationW(
                    desktop, 2, name, ctypes.sizeof(name), ctypes.byref(needed))) and name.value.lower() == 'default'
            finally:
                user32.CloseDesktop.argtypes = [ctypes.c_void_p]
                user32.CloseDesktop(desktop)
        if not unlocked:
            raise ObservationBlocked('input_desktop_unavailable')
        if not win32gui.IsWindow(self.hwnd):
            raise ObservationBlocked('window_closed')
        if win32gui.IsIconic(self.hwnd) or not win32gui.IsWindowVisible(self.hwnd):
            raise ObservationBlocked('window_hidden_or_minimized')
        if self.capture_method == 'screen_region':
            require_unoccluded(self.hwnd)
        elif win32gui.GetForegroundWindow() != self.hwnd:
            raise ObservationBlocked('window_not_foreground')
        if (window_pid(self.hwnd) != self.pid
                or psutil.Process(self.pid).create_time() != self.created):
            raise ObservationBlocked('window_process_changed')
        rect = list(win32gui.GetWindowRect(self.hwnd))
        return {'kind': 'live_window', 'available': True, 'hwnd': self.hwnd,
                'capture_method': self.capture_method,
                'pid': self.pid, 'created': self.created, 'rect': rect,
                'size': [rect[2] - rect[0], rect[3] - rect[1]],
                'dpi': user32.GetDpiForWindow(self.hwnd)}

    def uia(self, layout):
        return bounded_worker(self.hwnd, self.observe(), layout)

    def capture(self):
        from PIL import ImageStat
        mode = 'capture' if self.capture_method == 'window' else 'capture_screen_region'
        image = bounded_worker(self.hwnd, self.observe(), mode=mode)
        if max(ImageStat.Stat(image).stddev) < 1:
            image.close()
            raise ObservationBlocked('blank_capture')
        return image


def require_unoccluded(hwnd):
    """Desktop pixels are usable only while no visible upper window overlaps."""
    import win32gui
    import win32api
    rect = win32gui.GetWindowRect(hwnd)
    x, y = win32api.GetSystemMetrics(76), win32api.GetSystemMetrics(77)
    width, height = win32api.GetSystemMetrics(78), win32api.GetSystemMetrics(79)
    if not (x <= rect[0] < rect[2] <= x + width and y <= rect[1] < rect[3] <= y + height):
        raise ObservationBlocked('window_outside_desktop')
    windows = []
    win32gui.EnumWindows(lambda h, _: windows.append(h), None)
    if hwnd not in windows:
        raise ObservationBlocked('window_closed')
    for other in windows[:windows.index(hwnd)]:
        if not win32gui.IsWindowVisible(other) or win32gui.IsIconic(other):
            continue
        cloaked = wintypes.DWORD()
        dwm_query = ctypes.WinDLL('dwmapi').DwmGetWindowAttribute
        dwm_query.argtypes = [wintypes.HWND, wintypes.DWORD, ctypes.c_void_p, wintypes.DWORD]
        if dwm_query(other, 14, ctypes.byref(cloaked), ctypes.sizeof(cloaked)) == 0 and cloaked.value:
            continue
        # Observed tooling cursor layers occupy the entire desktop rectangle.
        # They are not application content. Do not generalize to other overlays.
        exstyle = win32gui.GetWindowLong(other, -20)
        cursor_flags = 0x08000000 | 0x00080000 | 0x00000020
        if (win32gui.GetClassName(other) == 'CodexComputerUseCursorOverlay'
                and exstyle & cursor_flags == cursor_flags):
            continue
        box = win32gui.GetWindowRect(other)
        if max(box[0], rect[0]) < min(box[2], rect[2]) and max(box[1], rect[1]) < min(box[3], rect[3]):
            raise ObservationBlocked('window_occluded')
    return rect


def capture_screen_region(hwnd):
    """Copy only the target's on-screen rectangle, never a whole desktop image."""
    import win32gui
    import win32ui
    import win32con
    from PIL import Image
    rect = require_unoccluded(hwnd)
    width, height = rect[2] - rect[0], rect[3] - rect[1]
    desktop = win32gui.GetDC(0)
    source = target = bitmap = None
    try:
        source = win32ui.CreateDCFromHandle(desktop)
        target = source.CreateCompatibleDC()
        bitmap = win32ui.CreateBitmap()
        bitmap.CreateCompatibleBitmap(source, width, height)
        target.SelectObject(bitmap)
        target.BitBlt((0, 0), (width, height), source, (rect[0], rect[1]),
                      win32con.SRCCOPY | 0x40000000)  # CAPTUREBLT (not exported by every pywin32)
        data = bitmap.GetBitmapBits(True)
        if require_unoccluded(hwnd) != rect:
            raise ObservationBlocked('capture_binding_changed')
        return Image.frombytes('RGB', (width, height), data, 'raw', 'BGRX', 0, 1)
    finally:
        if target is not None:
            target.DeleteDC()
        if source is not None:
            source.DeleteDC()
        if bitmap is not None:
            win32gui.DeleteObject(bitmap.GetHandle())
        win32gui.ReleaseDC(0, desktop)


def read_uia(hwnd, layout):
    """Bounded raw traversal; names read only inside explicit header/message ROIs."""
    import comtypes.client
    import win32gui
    module = comtypes.client.GetModule('UIAutomationCore.dll')
    api = comtypes.client.CreateObject(module.CUIAutomation, interface=module.IUIAutomation)
    walker = api.RawViewWalker
    root = api.ElementFromHandle(hwnd)
    pid = window_pid(hwnd)
    origin = win32gui.GetWindowRect(hwnd)
    rows = {'header': [], 'messages': []}
    stack, count, message_list = [(root, 0)], 0, False
    while stack:
        node, depth = stack.pop()
        count += 1
        if count > 128:
            return {'status': 'truncated'}
        if node.CurrentProcessId != pid:
            raise ObservationBlocked('foreign_uia_element')
        rect = node.CurrentBoundingRectangle
        box = [rect.left - origin[0], rect.top - origin[1],
               rect.right - origin[0], rect.bottom - origin[1]]
        control_type = node.CurrentControlType
        if not node.CurrentIsOffscreen:
            for name in rows:
                region = getattr(layout, name)
                if (region[0] <= box[0] < box[2] <= region[2]
                        and region[1] <= box[1] < box[3] <= region[3]):
                    if name == 'messages' and control_type == 50008:
                        message_list = True
                    if control_type == 50020:
                        text = node.CurrentName
                        if text:
                            rows[name].append({'text': text, 'box': [
                                box[0] - region[0], box[1] - region[1],
                                box[2] - region[0], box[3] - region[1]]})
        child = walker.GetFirstChildElement(node)
        if child and depth >= 6:
            return {'status': 'truncated'}
        siblings = 0
        while child:
            siblings += 1
            if len(stack) + count >= 128 or siblings > 128:
                return {'status': 'truncated'}
            stack.append((child, depth + 1))
            child = walker.GetNextSiblingElement(child)
    if not message_list or not rows['header'] or not rows['messages']:
        return {'status': 'semantic_unavailable', 'node_count': count}
    for value in rows.values():
        value.sort(key=lambda row: (row['box'][1], row['box'][0]))
    return {'status': 'readable', 'node_count': count, **rows}


if __name__ == '__main__':
    from .hybrid_observer import Layout
    try:
        hwnd = int(sys.argv[1])
        ctypes.windll.user32.SetProcessDpiAwarenessContext(ctypes.c_void_p(-4))
        config = json.loads(Path(sys.argv[2]).read_text(encoding='utf-8'))
        bound = WindowsBackend(hwnd, config['binding'].get('capture_method', 'window'))
        actual = bound.observe()
        if actual != config['binding']:
            changed = sorted(key for key in actual if actual[key] != config['binding'].get(key))
            raise ObservationBlocked('worker_binding_changed:' + ','.join(changed))
        if sys.argv[4].startswith('capture'):
            from PIL import ImageGrab
            captured = (capture_screen_region(hwnd) if sys.argv[4] == 'capture_screen_region'
                        else ImageGrab.grab(window=hwnd))
            with captured as image:
                if bound.observe() != config['binding']:
                    raise ObservationBlocked('worker_binding_changed')
                image.save(sys.argv[3], format='PNG')
        else:
            layout = Layout.from_dict(config['layout'])
            value = read_uia(hwnd, layout)
            if bound.observe() != config['binding']:
                raise ObservationBlocked('worker_binding_changed')
            Path(sys.argv[3]).write_text(json.dumps(value, ensure_ascii=False), encoding='utf-8')
    except Exception as exc:
        import traceback
        error = {'type': type(exc).__name__, 'line': traceback.extract_tb(exc.__traceback__)[-1].lineno}
        if isinstance(exc, ObservationBlocked):
            error['reason'] = str(exc)
        Path(sys.argv[3]).with_suffix('.error.json').write_text(json.dumps(error), encoding='utf-8')
        sys.exit(2)
