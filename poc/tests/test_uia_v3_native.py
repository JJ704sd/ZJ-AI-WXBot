import sys
from pathlib import Path
sys.path.insert(0, str(Path(__file__).parents[1] / 'scripts'))
from probe_uia_v3_native import is_fixture_window, qualifies


def report():
    return {'mode': 'N1', 'execution_status': 'completed',
            'snapshot': {'truncated': False, 'binding_stable': True,
                         'providers': [{'server_side': {'state': 'observed', 'value': True}}]},
            'closed_target_status': 'invalidated',
            'value_interfaces': [{'property': {'state': 'observed', 'value': True},
                'interface_state': 'observed', 'readonly': True, 'synthetic_value_matched': True}]}


def test_provider_true_alone_cannot_pass():
    value = report()
    value['value_interfaces'] = []
    assert not qualifies(value)


def test_readonly_and_content_must_be_observed():
    value = report()
    value['value_interfaces'][0]['readonly'] = False
    assert not qualifies(value)


def test_incomplete_or_live_target_rejected():
    value = report()
    value['snapshot']['truncated'] = True
    assert not qualifies(value)
    value['snapshot']['truncated'] = False
    value['closed_target_status'] = 'valid'
    assert not qualifies(value)


def test_distinct_provider_branches():
    value = report()
    assert qualifies(value)
    value['mode'] = 'N0'
    assert not qualifies(value)
    value['snapshot']['providers'][0]['server_side']['value'] = False
    assert qualifies(value)


def test_native_probe_accepts_only_synthetic_windows():
    assert is_fixture_window('N0', 'CodexUiaSyntheticFixture', 'Synthetic UIA control')
    assert is_fixture_window('N1', 'HwndWrapper[synthetic]', 'Synthetic UIA native provider')
    assert not is_fixture_window('N1', 'Qt51514QWindowIcon', 'Weixin')
