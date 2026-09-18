"""Bounded metadata-only pywinauto probe. No pyweixin import, input, or send.

Run only in an unlocked interactive desktop; requires pywinauto/psutil/pywin32.
Never infers current account or group from a window title.
"""
import argparse
import json
import re
import subprocess
import sys
import tempfile
import uuid
import tomllib
from datetime import datetime, timezone
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from wechat_agent_poc.pyweixin_admission import assess


def strict_children(item):
    """Avoid pywinauto 0.6.9 _get_elements converting COM errors to []."""
    from pywinauto.uia_defines import IUIA
    from pywinauto.uia_element_info import UIAElementInfo
    from pywinauto.controls.uiawrapper import UIAWrapper
    api = IUIA()
    array = item.element_info.element.FindAll(api.tree_scope['children'], api.true_condition)
    count = array.Length
    return ([UIAWrapper(UIAElementInfo(array.GetElement(i))) for i in range(min(count, 129))],
            count > 129)


def collect(exe, *, max_depth=6, max_nodes=128, expected_title=None):
    if not 1 <= max_depth <= 32 or not 16 <= max_nodes <= 1024:
        raise ValueError('invalid_structure_budget')
    import psutil
    import win32api
    import win32gui
    import win32process
    from pywinauto import Desktop
    expected = Path(exe).resolve()
    candidates = []
    for proc in psutil.process_iter(['name']):
        if (proc.info['name'] or '').lower() != expected.name.lower():
            continue
        if Path(proc.exe()).resolve() == expected:
            candidates.append(proc)
    if not candidates:
        return {'complete': False, 'reason': 'process_absent', 'process_count': 0}
    processes = {proc.pid: proc for proc in candidates}
    windows = []
    def visit(handle, _):
        if (win32process.GetWindowThreadProcessId(handle)[1] in processes
                and win32gui.IsWindowVisible(handle)
                and win32gui.GetClassName(handle) == 'Qt51514QWindowIcon'
                and win32gui.GetWindowText(handle) in ('微信', 'Weixin', 'WeChat')):
            windows.append(handle)
        return True
    win32gui.EnumWindows(visit, None)
    if len(windows) != 1:
        return {'complete': False, 'reason': 'window_absent_or_ambiguous',
                'process_count': len(candidates), 'window_count': len(windows)}
    handle = windows[0]
    proc = processes[win32process.GetWindowThreadProcessId(handle)[1]]
    generation = proc.create_time()
    version = win32api.GetFileVersionInfo(str(expected), '\\')
    hi, lo = version['FileVersionMS'], version['FileVersionLS']
    version = '.'.join(str(v) for v in (hi >> 16, hi & 65535, lo >> 16, lo & 65535))
    desktop = Desktop(backend='uia')
    root = desktop.window(handle=handle).wrapper_object()
    observation = dict(version=version, root_class=root.class_name(), complete=True,
                       sessions=False, messages=False, input=False,
                       process_count=len(candidates), window_count=1,
                       max_depth=max_depth, max_nodes=max_nodes, structure=[],
                       truncation_reasons=[], content_containers_pruned=0,
                       input_suffix_candidate=False,
                       scope='structural_containers_excluding_chat_and_session_items')
    title_matches = []
    # Minimized snapshots are not evidence that semantic controls are absent.
    if win32gui.IsIconic(handle):
        return dict(observation, complete=False, reason='window_minimized')
    queue = [(root, 0, None)]
    count = 0
    while queue:
        if count >= max_nodes:
            observation['truncation_reasons'].append('node_limit')
            break
        item, depth, parent = queue.pop(0)
        index = count
        count += 1
        kind = item.element_info.control_type
        class_name = item.class_name()
        safe_class = class_name if re.fullmatch(r'mmui::[A-Za-z0-9_]{1,90}|Qt[0-9]+QWindowIcon|MMUIRenderSubWindowHW', class_name) else 'other'
        anchors = []
        if expected_title and kind == 'Text' and item.element_info.automation_id == (
                'content_view.top_content_view.title_h_view.left_v_view.'
                'left_content_v_view.left_ui_.big_title_line_h_view.current_chat_name_label'):
            # Compare only the exact upstream title control, never arbitrary text nodes.
            title_matches.append(item.window_text() == expected_title)
        if kind == 'Edit':
            aid = item.element_info.automation_id
            if aid == 'chat_input_field':
                observation['input'] = True
                anchors.append('input_exact')
            elif aid.endswith('.chat_input_field'):
                observation['input_suffix_candidate'] = True
                anchors.append('input_suffix_candidate')
        # Only compare structural list labels; never read message item text.
        if kind == 'List':
            label = item.window_text()
            if label in ('会话', 'Chats', '對話'):
                observation['sessions'] = True
                anchors.append('sessions_label')
            if label in ('消息', 'Messages', '訊息'):
                observation['messages'] = True
                anchors.append('messages_label')
        observation['structure'].append(dict(index=index, parent=parent, depth=depth,
            role=kind, class_name=safe_class, anchors=anchors))
        if 'sessions_label' in anchors or 'messages_label' in anchors:
            observation['content_containers_pruned'] += 1
            continue
        children, truncated = strict_children(item)
        if truncated:
            observation['truncation_reasons'].append('children_limit')
        if children and depth >= max_depth:
            observation['truncation_reasons'].append('depth_limit')
        elif children:
            queue.extend((child, depth+1, index) for child in children[:129])
    observation['truncation_reasons'] = sorted(set(observation['truncation_reasons']))
    observation['complete'] = not observation['truncation_reasons']
    current = psutil.Process(proc.pid)
    observation['binding_stable'] = (current.create_time() == generation
        and win32gui.IsWindow(handle)
        and win32process.GetWindowThreadProcessId(handle)[1] == proc.pid
        and Path(current.exe()).resolve() == expected
        and root.class_name() == observation['root_class'] and not win32gui.IsIconic(handle))
    observation['node_count'] = count
    if expected_title:
        observation['target_binding'] = dict(
            title_control_count=len(title_matches),
            title_matches=title_matches == [True],
            account_verified=False, group_verified=False,
            reason='title_is_not_stable_identity', read_enabled=False, send_enabled=False)
    return observation


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--exe', required=True)
    parser.add_argument('--output', required=True)
    parser.add_argument('--max-depth', type=int, default=6)
    parser.add_argument('--max-nodes', type=int, default=128)
    parser.add_argument('--worker', action='store_true', help=argparse.SUPPRESS)
    parser.add_argument('--binding-config', help='Local TOML; only group.display_name is used')
    args = parser.parse_args()
    output = Path(args.output)
    if output.exists():
        parser.error('output exists; choose a new evidence filename')
    if args.worker:
        try:
            expected_title = None
            if args.binding_config:
                with open(args.binding_config, 'rb') as stream:
                    expected_title = tomllib.load(stream).get('group', {}).get('display_name')
                if not isinstance(expected_title, str) or not expected_title.strip():
                    raise ValueError('missing_expected_title')
            result = collect(args.exe, max_depth=args.max_depth, max_nodes=args.max_nodes,
                             expected_title=expected_title)
        except Exception as exc:
            result = {'complete': False, 'error_type': type(exc).__name__}
        output.write_text(json.dumps(result), encoding='utf-8')
        return 0
    with tempfile.TemporaryDirectory(prefix='pyweixin-structure-') as temp:
        worker_output = Path(temp) / 'result.json'
        try:
            child = subprocess.run([sys.executable, str(Path(__file__).resolve()),
                '--worker', '--exe', args.exe, '--max-depth', str(args.max_depth),
                '--max-nodes', str(args.max_nodes), '--output', str(worker_output)] +
                (['--binding-config', args.binding_config] if args.binding_config else []),
                timeout=15, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            if child.returncode != 0 or not worker_output.exists():
                observed = {'complete': False, 'reason': 'worker_failed'}
            else:
                observed = json.loads(worker_output.read_text(encoding='utf-8'))
        except subprocess.TimeoutExpired:
            observed = {'complete': False, 'reason': 'timeout'}
    report = dict(run_id=str(uuid.uuid4()), observed_at=datetime.now(timezone.utc).isoformat(),
                  mechanism='pywinauto_metadata_only', observation=observed, admission=assess(observed))
    output.write_text(json.dumps(report, indent=2)+'\n', encoding='utf-8')
    print(json.dumps(report['admission']))
    return 0 if report['admission']['status'] == 'structure_candidate_only' else 2


if __name__ == '__main__':
    raise SystemExit(main())
