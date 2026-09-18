"""Bounded original-group detail comparison. No message reads or sends.

Explicitly opens only the uniquely identified current chat info panel. Expected
values stay local; evidence contains counts/booleans only. This is not server-ID
or account verification. Parent always attempts the pinned byte restoration.
"""
import argparse
import json
import subprocess
import sys
import tempfile
import time
import re
import tomllib
from datetime import datetime, timezone
from pathlib import Path

from qt_accessibility_preflight import NativeByte, EXE, observe, trial
from probe_pyweixin_structure import strict_children

TITLE_ID = ('content_view.top_content_view.title_h_view.left_v_view.'
            'left_content_v_view.left_ui_.big_title_line_h_view.current_chat_name_label')


def find(root, **criteria):
    """Use the proven child walk; Qt descendant queries can omit controls."""
    queue, found, count = [(root, 0)], [], 0
    while queue:
        node, depth = queue.pop(0)
        count += 1
        if count > 512:
            raise ValueError('too_many_controls')
        kind = node.element_info.control_type
        if (kind == criteria.get('control_type', kind) and
                node.class_name() == criteria.get('class_name', node.class_name())):
            found.append(node)
        # Never traverse chat/session content or read their item labels.
        if kind == 'List':
            continue
        children, truncated = strict_children(node)
        if truncated or (children and depth >= 32):
            raise ValueError('incomplete_structure')
        queue.extend((child, depth + 1) for child in children)
    return found


def compare(labels, expected):
    if not isinstance(expected, list) or not expected or any(
            not isinstance(x, str) or not x.strip() for x in expected):
        raise ValueError('invalid_expected_features')
    # Literal equality/substrings only; no fuzzy matching or regex interpretation.
    return [any(token in label for label in labels) for token in expected]


def component_diagnostics(labels, expected):
    """Supplementary only: slash-separated config features in one UI item.

    Do not combine one member's name with another member's organization.
    Never change the strict match or grant identity from this diagnostic.
    """
    result = []
    for feature in expected:
        parts = feature.split('/')
        valid = len(parts) == 2 and all(part.strip() for part in parts)
        result.append(dict(two_components=bool(valid),
            first_component_present=bool(valid and any(parts[0] in label for label in labels)),
            same_item_components_present=bool(valid and any(
                all(part in label for part in parts) for label in labels))))
    return result


def worker(config):
    from pywinauto import Desktop
    with open(config, 'rb') as stream:
        group = tomllib.load(stream)['group']
    title = group['display_name']
    if not isinstance(title, str) or not title.strip():
        raise ValueError('missing_title')
    compare([], group['required_detail_tokens'])
    compare([], group['member_features'])
    port = NativeByte(writable=False)
    result = dict(account_verified=False, group_verified=False, send_enabled=False,
                  panel_open_attempted=False, panel_restored=False)
    opened = False
    try:
        root = Desktop(backend='uia').window(handle=port.hwnd).wrapper_object()
        def title_ok():
            items = [item for item in find(root, control_type='Text')
                     if item.element_info.automation_id == TITLE_ID]
            return len(items) == 1 and items[0].window_text() == title
        def panels():
            return [node for node in find(root, control_type='Group',
                class_name='mmui::ChatRoomMemberInfoView') if node.is_visible()]
        result['window_stable'] = port.same_target()
        titles = [item for item in find(root, control_type='Text')
                  if item.element_info.automation_id == TITLE_ID]
        result['title_control_count'] = len(titles)
        result['title_matches'] = len(titles) == 1 and titles[0].window_text() == title
        if not result['window_stable']:
            raise ValueError('target_changed')
        if not result['title_matches']:
            raise ValueError('title_missing_or_mismatch')
        buttons = [b for b in find(root, control_type='Button')
                   if b.window_text() in ('聊天信息', 'Chat Info', '聊天資訊')]
        if len(buttons) != 1:
            raise ValueError('info_button_not_unique')
        panel = panels()
        if not panel:
            result['panel_open_attempted'] = True
            # Set before invoking: a provider exception can follow a successful action.
            opened = True
            root.set_focus()
            if not port.same_target() or not title_ok() or not buttons[0].is_visible() or not buttons[0].is_enabled():
                raise ValueError('target_changed')
            buttons[0].click_input()
            panel = panels()
            deadline = time.monotonic() + 2
            while not panel and time.monotonic() < deadline:
                if not port.same_target() or not title_ok():
                    break
                time.sleep(0.1)
                panel = panels()
        result['panel_count'] = len(panel)
        if len(panel) != 1 or not title_ok():
            result['group_classes'] = sorted(set(node.class_name() for node in
                find(root, control_type='Group') if re.fullmatch(
                    r'mmui::[A-Za-z0-9_]{1,90}', node.class_name())))
            raise ValueError('group_panel_not_unique')
        # A panel node may precede its populated content. One bounded settle;
        # later evidence still cannot claim that every virtual item is loaded.
        time.sleep(0.5)
        if not port.same_target() or not title_ok():
            raise ValueError('target_changed')
        queue = [(panel[0], 0)]
        labels = []
        member_labels = []
        roles = {}
        visible_count = 0
        count = 0
        complete = True
        while queue:
            if count >= 256:
                complete = False
                break
            node, depth = queue.pop(0)
            count += 1
            role = node.element_info.control_type
            roles[role] = roles.get(role, 0) + 1
            visible = node.is_visible()
            visible_count += int(visible)
            if visible and role in ('Text', 'Button', 'ListItem', 'CheckBox', 'Group', 'Pane'):
                labels.append(node.window_text())
                if role == 'ListItem':
                    member_labels.append(labels[-1])
            children, truncated = strict_children(node)
            if truncated or (children and depth >= 16):
                complete = False
            elif children:
                queue.extend((child, depth+1) for child in children)
        result.update(status='observed', node_count=count, complete=complete,
                      visible_node_count=visible_count, role_counts=roles,
                      nonempty_label_count=sum(bool(label) for label in labels),
                      panel_visible=panel[0].is_visible(),
                      detail_matches=compare(labels, group['required_detail_tokens']),
                      member_matches=compare(labels, group['member_features']),
                      member_component_diagnostics=component_diagnostics(
                          member_labels, group['member_features']),
                      target_stable=port.same_target() and title_ok(),
                      scope='current_group_info_panel_only')
    except Exception as exc:
        result.update(status='blocked', error_type=type(exc).__name__)
        if str(exc) in ('target_changed', 'title_missing_or_mismatch',
                        'info_button_not_unique', 'group_panel_not_unique'):
            result['reason'] = str(exc)
    finally:
        try:
            if opened:
                if port.same_target() and title_ok() and len(panels()) == 1:
                    buttons[0].click_input()
                    deadline = time.monotonic() + 2
                    remaining = panels()
                    while remaining and time.monotonic() < deadline:
                        time.sleep(0.1)
                        remaining = panels()
                    result['panel_restored'] = not remaining
                elif port.same_target() and title_ok() and not panels():
                    # Absence of the expected selector cannot prove UI restoration.
                    result['panel_restored'] = False
            else:
                result['panel_restored'] = True
        except Exception:
            result['panel_restored'] = False
        port.close()
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--binding-config', required=True)
    parser.add_argument('--output', required=True)
    parser.add_argument('--worker', action='store_true')
    parser.add_argument('--allow-temporary-byte-write', action='store_true')
    args = parser.parse_args()
    output = Path(args.output)
    if output.exists():
        parser.error('output exists')
    if args.worker:
        try:
            result = worker(args.binding_config)
        except Exception as exc:
            result = dict(status='blocked', error_type=type(exc).__name__)
    else:
        if not args.allow_temporary_byte_write:
            parser.error('explicit temporary-write flag required')
        result = dict(observed_at=datetime.now(timezone.utc).isoformat(), send_enabled=False)
        port = None
        try:
            port = NativeByte(writable=True)
            baseline = observe(32, 512)
            if not (baseline.get('complete') is True and baseline.get('binding_stable') is True
                    and baseline.get('root_class') == 'Qt51514QWindowIcon'):
                raise ValueError('unexpected_baseline')
            def bounded():
                with tempfile.TemporaryDirectory(prefix='group-details-') as temp:
                    child_output = Path(temp) / 'result.json'
                    child = subprocess.run([sys.executable, str(Path(__file__).resolve()),
                        '--worker', '--binding-config', args.binding_config,
                        '--output', str(child_output)], timeout=15,
                        stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
                    if child.returncode or not child_output.exists():
                        raise RuntimeError('worker_failed')
                    return json.loads(child_output.read_text(encoding='utf-8'))
            result['trial'] = trial(port, bounded)
            if result['trial']['restored']:
                result['after_restore'] = observe()
        except Exception as exc:
            result.update(status='blocked', error_type=type(exc).__name__)
        finally:
            if port:
                port.close()
    output.write_text(json.dumps(result, indent=2)+'\n', encoding='utf-8')
    print(json.dumps(result))
    if args.worker:
        return 0
    transaction = result.get('trial', {})
    observation = transaction.get('observation', {})
    return 0 if (transaction.get('restored') is True
                 and observation.get('status') == 'observed'
                 and observation.get('target_stable') is True
                 and observation.get('complete') is True
                 and observation.get('panel_restored') is True) else 2


if __name__ == '__main__':
    raise SystemExit(main())
