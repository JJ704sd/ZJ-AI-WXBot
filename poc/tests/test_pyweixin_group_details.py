import importlib.util
import sys
from pathlib import Path
from types import SimpleNamespace

import pytest


@pytest.fixture
def probe(monkeypatch):
    scripts = Path(__file__).resolve().parents[1] / 'scripts'
    monkeypatch.syspath_prepend(str(scripts))
    spec = importlib.util.spec_from_file_location('group_probe_test', scripts / 'probe_pyweixin_group_details.py')
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def test_literal_features_and_missing_values(probe):
    assert probe.compare(['synthetic member'], ['member', 'missing', 'm.mber']) == [True, False, False]
    for invalid in ([], [''], 'member', [1]):
        with pytest.raises(ValueError):
            probe.compare([], invalid)


def test_components_cannot_join_different_members(probe):
    result = probe.component_diagnostics(['Alice teamA', 'Bob teamB'],
        ['Alice/teamB', 'Alice/teamA', 'missing/teamA', 'plain'])
    assert [r['same_item_components_present'] for r in result] == [False, True, False, False]
    assert probe.compare(['Alice teamA'], ['Alice/teamA']) == [False]


def test_find_prunes_message_lists_and_propagates_errors(probe, monkeypatch):
    root = SimpleNamespace(element_info=SimpleNamespace(control_type='List'), class_name=lambda: 'list')
    def forbidden(node):
        raise AssertionError('must not enumerate message list')
    monkeypatch.setattr(probe, 'strict_children', forbidden)
    assert probe.find(root, control_type='Text') == []
    root.element_info.control_type = 'Group'
    with pytest.raises(AssertionError):
        probe.find(root, control_type='Text')


def test_missing_title_blocks_before_panel_action(probe, monkeypatch, tmp_path):
    config = tmp_path / 'binding.toml'
    config.write_text('[group]\ndisplay_name="synthetic"\nrequired_detail_tokens=["detail"]\nmember_features=["member"]\n')
    port = SimpleNamespace(hwnd=1, same_target=lambda: True, close=lambda: None)
    monkeypatch.setattr(probe, 'NativeByte', lambda **kw: port)
    root = object()
    desktop = SimpleNamespace(window=lambda **kw: SimpleNamespace(wrapper_object=lambda: root))
    monkeypatch.setitem(sys.modules, 'pywinauto', SimpleNamespace(Desktop=lambda **kw: desktop))
    def find(node, **criteria):
        assert criteria == {'control_type': 'Text'}
        return []
    monkeypatch.setattr(probe, 'find', find)
    result = probe.worker(config)
    assert result['reason'] == 'title_missing_or_mismatch'
    assert result['panel_open_attempted'] is False
    assert result['send_enabled'] is False
