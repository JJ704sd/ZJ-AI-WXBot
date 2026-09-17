import importlib.util
from pathlib import Path

spec = importlib.util.spec_from_file_location('patterns', Path(__file__).parents[1] / 'scripts/probe_uia_patterns.py')
patterns = importlib.util.module_from_spec(spec)
spec.loader.exec_module(patterns)


def test_unexpected_values_are_unknown_not_truthy():
    class Control:
        def GetPropertyValue(self, key):
            return 'private value must not be printed'
    assert set(patterns.observe_patterns(Control()).values()) == {None}


def test_com_failure_is_unknown_not_absent():
    class Control:
        def GetPropertyValue(self, key):
            raise RuntimeError('private exception must not be printed')
    assert set(patterns.observe_patterns(Control()).values()) == {None}


def test_capabilities_remain_separate():
    class Control:
        def GetPropertyValue(self, key):
            return key == 30090
    result = patterns.observe_patterns(Control())
    assert result['legacy'] is True
    assert result['text'] is False and result['text2'] is False
