import importlib.util
import json
import subprocess
import sys
from pathlib import Path
from types import SimpleNamespace

import pytest


@pytest.fixture
def probe():
    path = Path(__file__).resolve().parents[1] / 'scripts/probe_pyweixin_structure.py'
    spec = importlib.util.spec_from_file_location('pyweixin_probe_test', path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


@pytest.mark.parametrize('behavior,reason', [('timeout', 'timeout'),
    ('no_report', 'worker_failed'), ('nonzero', 'worker_failed')])
def test_worker_failure_cannot_enable_reader(probe, monkeypatch, tmp_path, behavior, reason):
    output = tmp_path / 'receipt.json'
    monkeypatch.setattr(sys, 'argv', ['probe', '--exe', 'synthetic.exe', '--output', str(output)])

    def run(command, **kwargs):
        if behavior == 'timeout':
            raise subprocess.TimeoutExpired(command, kwargs['timeout'])
        if behavior == 'nonzero':
            Path(command[-1]).write_text(json.dumps(dict(complete=True, binding_stable=True,
                version='4.1.13.65', root_class='mmui::MainWindow', sessions=True,
                messages=True, input=True)), encoding='utf-8')
        return SimpleNamespace(returncode=1 if behavior == 'nonzero' else 0)

    monkeypatch.setattr(probe.subprocess, 'run', run)
    assert probe.main() == 2
    receipt = json.loads(output.read_text(encoding='utf-8'))
    assert receipt['observation']['reason'] == reason
    assert receipt['admission']['read_verified'] is False
    assert receipt['admission']['send_enabled'] is False


def test_evidence_is_not_overwritten(probe, monkeypatch, tmp_path):
    output = tmp_path / 'existing.json'
    output.write_text('original', encoding='utf-8')
    monkeypatch.setattr(sys, 'argv', ['probe', '--exe', 'synthetic.exe', '--output', str(output)])
    with pytest.raises(SystemExit):
        probe.main()
    assert output.read_text(encoding='utf-8') == 'original'


def install_synthetic_desktop(monkeypatch, extra_main=False):
    """Six same-executable processes, with GUI owned by a non-first process."""
    exe = str(Path('synthetic-Weixin.exe').resolve())
    processes = [SimpleNamespace(pid=i, info={'name': 'synthetic-Weixin.exe'},
                  exe=lambda: exe, create_time=lambda: 100.0) for i in range(1, 7)]
    handles = [101, 102] if extra_main else [101]
    def enum_windows(callback, context):
        for handle in handles:
            callback(handle, context)
    root = SimpleNamespace(handle=101, class_name=lambda: 'Qt51514QWindowIcon',
        is_minimized=lambda: False, children=lambda: [],
        element_info=SimpleNamespace(control_type='Window', automation_id=''))
    desktop = SimpleNamespace(window=lambda **kw: SimpleNamespace(wrapper_object=lambda: root))
    monkeypatch.setitem(sys.modules, 'psutil', SimpleNamespace(
        process_iter=lambda attrs: processes, Process=lambda pid: processes[pid-1]))
    monkeypatch.setitem(sys.modules, 'win32api', SimpleNamespace(
        GetFileVersionInfo=lambda *args: {'FileVersionMS': (4<<16)+1, 'FileVersionLS': (13<<16)+65}))
    monkeypatch.setitem(sys.modules, 'win32gui', SimpleNamespace(EnumWindows=enum_windows,
        IsWindow=lambda h: h in handles, IsWindowVisible=lambda h: True,
        IsIconic=lambda h: False, GetClassName=lambda h: 'Qt51514QWindowIcon',
        GetWindowText=lambda h: '微信'))
    monkeypatch.setitem(sys.modules, 'win32process', SimpleNamespace(
        GetWindowThreadProcessId=lambda h: (1, 2 if h == 101 else 3)))
    monkeypatch.setitem(sys.modules, 'pywinauto', SimpleNamespace(Desktop=lambda **kw: desktop))
    return exe


def test_multiple_processes_with_one_main_window_are_not_ambiguous(probe, monkeypatch):
    monkeypatch.setattr(probe, 'strict_children', lambda item: ([], False))
    result = probe.collect(install_synthetic_desktop(monkeypatch))
    assert result['complete'] is True
    assert result['binding_stable'] is True
    assert result['process_count'] == 6
    assert result['node_count'] == 1


def test_two_main_windows_still_block(probe, monkeypatch):
    result = probe.collect(install_synthetic_desktop(monkeypatch, extra_main=True))
    assert result['complete'] is False
    assert result['reason'] == 'window_absent_or_ambiguous'


def test_enumeration_error_is_not_a_complete_empty_tree(probe, monkeypatch):
    exe = install_synthetic_desktop(monkeypatch)
    def fail(item):
        raise RuntimeError('synthetic COM failure')
    monkeypatch.setattr(probe, 'strict_children', fail)
    with pytest.raises(RuntimeError):
        probe.collect(exe)


def synthetic_node(kind='Pane', aid='', label='', children=None):
    return SimpleNamespace(class_name=lambda: 'mmui::SyntheticView',
        element_info=SimpleNamespace(control_type=kind, automation_id=aid),
        window_text=lambda: label, children=lambda: children or [])


def deep_desktop(monkeypatch):
    exe = install_synthetic_desktop(monkeypatch)
    root = sys.modules['pywinauto'].Desktop().window().wrapper_object()
    # Sensitive-looking IDs/text must never reach metadata output.
    leaf = synthetic_node(children=[
        synthetic_node('Edit', 'chat_input_field', 'private_input'),
        synthetic_node('List', 'session_list', '会话', [synthetic_node('ListItem', 'private_sender')]),
        synthetic_node('List', 'message_list', '消息', [synthetic_node('CheckBox', label='private_body')])])
    for _ in range(10):
        leaf = synthetic_node(children=[leaf])
    root.children = lambda: [leaf]
    return exe


def test_depth_truncation_has_explicit_reason(probe, monkeypatch):
    exe = deep_desktop(monkeypatch)
    monkeypatch.setattr(probe, 'strict_children', lambda item: (item.children(), False))
    result = probe.collect(exe)
    assert result['complete'] is False
    assert 'depth_limit' in result['truncation_reasons']


def test_deep_scan_finds_containers_without_dumping_messages(probe, monkeypatch):
    exe = deep_desktop(monkeypatch)
    monkeypatch.setattr(probe, 'strict_children', lambda item: (item.children(), False))
    result = probe.collect(exe, max_depth=24, max_nodes=512)
    assert result['complete'] is True
    assert result['sessions'] and result['messages'] and result['input']
    assert result['content_containers_pruned'] == 2
    serialized = json.dumps(result)
    assert 'private_' not in serialized


@pytest.mark.parametrize('labels,match', [([], False), (['private_target'], True),
    (['other'], False), (['private_target', 'private_target'], False)])
def test_title_match_is_private_and_never_identity(probe, monkeypatch, labels, match):
    exe = install_synthetic_desktop(monkeypatch)
    root = sys.modules['pywinauto'].Desktop().window().wrapper_object()
    aid = ('content_view.top_content_view.title_h_view.left_v_view.'
           'left_content_v_view.left_ui_.big_title_line_h_view.current_chat_name_label')
    root.children = lambda: [synthetic_node('Text', aid, label) for label in labels]
    monkeypatch.setattr(probe, 'strict_children', lambda item: (item.children(), False))
    result = probe.collect(exe, expected_title='private_target')
    binding = result['target_binding']
    assert binding['title_matches'] is match
    assert not any(binding[key] for key in ('account_verified', 'group_verified',
                                            'read_enabled', 'send_enabled'))
    assert 'private_target' not in json.dumps(result)
