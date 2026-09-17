import importlib.util
from pathlib import Path

spec = importlib.util.spec_from_file_location('v2', Path(__file__).parents[1] / 'scripts/probe_uia_research_v2.py')
v2 = importlib.util.module_from_spec(spec)
spec.loader.exec_module(v2)


class Element:
    def __init__(self, value):
        self.value = value

    def GetCurrentPropertyValueEx(self, prop, ignore):
        assert ignore is True
        if isinstance(self.value, Exception):
            raise self.value
        return self.value


def test_false_is_not_unsupported():
    result = v2.property_result(Element(False), 30040, lambda x: x is None, v2.strict_bool)
    assert result == {'state': 'observed', 'value': False}


def test_reserved_unsupported_is_not_false():
    result = v2.property_result(Element(None), 30040, lambda x: x is None, v2.strict_bool)
    assert result == {'state': 'not_supported', 'value': None}


def test_error_never_serializes_private_exception():
    result = v2.property_result(Element(RuntimeError('private account')), 30040, lambda x: False)
    assert result['state'] == 'error' and result['value'] is None
    assert 'private account' not in str(result)


def test_unexpected_type_is_error():
    assert v2.property_result(Element('false'), 30040, lambda x: False, v2.strict_bool)['state'] == 'error'


def test_provider_description_does_not_emit_path():
    labels = v2.provider_labels('MSAA Proxy C:/private/account/file.dll')
    assert labels == ['msaa', 'proxy']


def test_only_the_named_synthetic_fixture_is_accepted():
    assert v2.is_fixture_window('CodexUiaSyntheticFixture', 'Synthetic UIA control')
    assert not v2.is_fixture_window('Qt51514QWindowIcon', 'Weixin')
