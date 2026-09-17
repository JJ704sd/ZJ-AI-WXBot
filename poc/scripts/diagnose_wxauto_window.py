"""Bounded UIA structure comparison. No titles, message text, or constructor calls."""
import json
import subprocess
import sys
import tempfile
from pathlib import Path
sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from wechat_agent_poc.uia_profile import assess_structure


def bounded_classes(root, max_nodes=128, max_depth=6):
    queue = [(root, 0)]
    classes = []
    complete = True
    while queue and len(classes) < max_nodes:
        control, depth = queue.pop(0)
        classes.append(control.ClassName)
        if depth >= max_depth:
            complete = False
            continue
        children = control.GetChildren()
        room = max_nodes - len(classes) - len(queue)
        if len(children) > room:
            complete = False
        queue.extend((child, depth + 1) for child in children[:max(0, room)])
    return classes, complete and not queue


def compatibility_status(report):
    if report.get('status') != 'structure_observed':
        return 'structure_unknown'
    windows = report.get('windows', [])
    if len(windows) != 1:
        return 'window_ambiguous'
    window = windows[0]
    assessment = window.get('version_assessment')
    if assessment and assessment['status'] != 'structural_candidate':
        return assessment['status']
    if not window.get('expected_uia_class_match'):
        return 'native_adapter_required' if assessment else 'unsupported_uia_window_class'
    if not window.get('expected_name_match'):
        return 'window_name_mismatch'
    if not any(c.get('child_count', 0) > 0 for c in window.get('children', [])):
        return 'semantic_controls_unavailable'
    return 'constructor_candidate'


def worker(path):
    report = {'constructor_called': False, 'message_read': False, 'sent': False}
    try:
        import psutil
        import win32gui
        import win32process
        import win32api
        from wxauto4 import WxParam, uia
        from wxauto4.ui import WeChatMainWnd
        WxParam.ENABLE_FILE_LOGGER = False
        expected_class = getattr(WeChatMainWnd, '_ui_cls_name', None)
        expected_name = getattr(WeChatMainWnd, '_ui_name', None)
        report['expected_class'] = expected_class
        report['expected_name_present'] = bool(expected_name)
        pids = {p.pid for p in psutil.process_iter(['name'])
                if (p.info['name'] or '').lower() == 'weixin.exe'}
        handles = []
        def collect(hwnd, _):
            _, pid = win32process.GetWindowThreadProcessId(hwnd)
            if pid in pids and win32gui.IsWindowVisible(hwnd):
                handles.append(hwnd)
        win32gui.EnumWindows(collect, None)
        report['visible_window_count'] = len(handles)
        rows = []
        for hwnd in handles[:5]:
            cls = win32gui.GetClassName(hwnd)
            _, pid = win32process.GetWindowThreadProcessId(hwnd)
            version_info = win32api.GetFileVersionInfo(psutil.Process(pid).exe(), '\\')
            ms, ls = version_info['FileVersionMS'], version_info['FileVersionLS']
            version = '.'.join(str(x) for x in (ms >> 16, ms & 65535, ls >> 16, ls & 65535))
            control = uia.ControlFromHandle(hwnd)
            children = control.GetChildren()
            classes, complete = bounded_classes(control)
            # Only structural data, never Name / Value / Text contents.
            rows.append({'class': cls, 'expected_class_match': cls == expected_class,
                         'uia_class': control.ClassName,
                         'version_assessment': assess_structure(version, control.ClassName, classes, complete=complete),
                         'structural_node_count': len(classes),
                         'structural_scan_complete': complete,
                         'expected_uia_class_match': control.ClassName == expected_class,
                         'expected_name_match': win32gui.GetWindowText(hwnd) == expected_name,
                         'minimized': bool(win32gui.IsIconic(hwnd)),
                         'uia_type': control.ControlTypeName,
                         'child_count': len(children),
                         'children': [{'type': c.ControlTypeName, 'class': c.ClassName,
                                       'child_count': len(c.GetChildren())}
                                      for c in children[:12]]})
        report['windows'] = rows
        report['status'] = 'structure_observed'
    except Exception as exc:
        report['status'] = 'structure_failed'
        report['error_type'] = type(exc).__name__
    report['compatibility'] = compatibility_status(report)
    Path(path).write_text(json.dumps(report), encoding='utf-8')


if __name__ == '__main__':
    if len(sys.argv) == 3 and sys.argv[1] == '--worker':
        worker(sys.argv[2])
    else:
        with tempfile.TemporaryDirectory(prefix='uia-structure-') as folder:
            path = Path(folder) / 'result.json'
            try:
                subprocess.run([sys.executable, __file__, '--worker', str(path)],
                               stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL,
                               timeout=20, check=False)
                print(path.read_text(encoding='utf-8') if path.exists() else '{"status":"worker_failed"}')
            except subprocess.TimeoutExpired:
                print('{"status":"structure_timeout"}')
