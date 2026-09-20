"""Read-only overlapping-window metadata; no titles, content or images."""
import ctypes
from ctypes import wintypes
import json
import sys
import win32gui

hwnd = int(sys.argv[1])
rect = win32gui.GetWindowRect(hwnd)
windows = []
win32gui.EnumWindows(lambda h, _: windows.append(h), None)
rows = []
for other in windows[:windows.index(hwnd)]:
    if not win32gui.IsWindowVisible(other) or win32gui.IsIconic(other):
        continue
    box = win32gui.GetWindowRect(other)
    if max(box[0], rect[0]) >= min(box[2], rect[2]) or max(box[1], rect[1]) >= min(box[3], rect[3]):
        continue
    cloaked = wintypes.DWORD()
    api = ctypes.WinDLL('dwmapi').DwmGetWindowAttribute
    api.argtypes = [wintypes.HWND, wintypes.DWORD, ctypes.c_void_p, wintypes.DWORD]
    code = api(other, 14, ctypes.byref(cloaked), ctypes.sizeof(cloaked))
    rows.append({'hwnd': other, 'class': win32gui.GetClassName(other), 'rect': box,
                 'exstyle': win32gui.GetWindowLong(other, -20),
                 'cloaked': cloaked.value if code == 0 else None})
print(json.dumps(rows))
