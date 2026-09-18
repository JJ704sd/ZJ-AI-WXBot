import importlib.util
import json
import sys
from pathlib import Path
from types import SimpleNamespace
import pytest


def test_truncated_tree_is_preserved_as_evidence(monkeypatch):
    script = Path(__file__).resolve().parents[1] / 'scripts/qt_accessibility_preflight.py'
    spec = importlib.util.spec_from_file_location('qt_preflight_test', script)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    observed = dict(complete=False, binding_stable=True,
                    root_class='mmui::MainWindow', node_count=128)
    def run(command, **kwargs):
        Path(command[-1]).write_text(json.dumps(observed), encoding='utf-8')
        return SimpleNamespace(returncode=0)
    monkeypatch.setattr(module.subprocess, 'run', run)
    assert module.observe() == observed


@pytest.mark.parametrize('message,expected', [('target_minimized', 'target_minimized'),
    ('synthetic private identifier', None)])
def test_safe_preflight_failure_reason(monkeypatch, tmp_path, message, expected):
    script = Path(__file__).resolve().parents[1] / 'scripts/qt_accessibility_preflight.py'
    spec = importlib.util.spec_from_file_location('qt_preflight_reason_test', script)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    def fail(**kwargs):
        raise ValueError(message)
    monkeypatch.setattr(module, 'NativeByte', fail)
    output = tmp_path / 'receipt.json'
    monkeypatch.setattr(sys, 'argv', ['preflight', '--output', str(output)])
    assert module.main() == 2
    result = json.loads(output.read_text(encoding='utf-8'))
    assert result.get('error_code') == expected
    assert result['write_authorized_flag'] is False
    if expected is None:
        assert message not in output.read_text(encoding='utf-8')
