import pytest
from wechat_agent_poc.pyweixin_admission import assess


def observation(**changes):
    return dict(dict(complete=True, binding_stable=True, version='4.1.13.65',
                     root_class='mmui::MainWindow', sessions=True, messages=True,
                     input=True), **changes)


@pytest.mark.parametrize('changes,status', [
    ({'complete': False}, 'incomplete_observation'),
    ({'binding_stable': False}, 'window_binding_changed'),
    ({'version': '4.1.99'}, 'unreviewed_client_version'),
    ({'root_class': 'mmui::LoginWindow'}, 'login_required'),
    ({'root_class': 'Qt51514QWindowIcon'}, 'upstream_entry_blocked'),
    ({'messages': False}, 'missing_semantic_controls'),
    ({'input': 'true'}, 'missing_semantic_controls'),
    ({}, 'structure_candidate_only'),
])
def test_structure_never_authorizes_agent(changes, status):
    result = assess(observation(**changes))
    assert result['status'] == status
    assert not any(result[k] for k in ('account_verified', 'group_verified',
                                      'read_verified', 'send_enabled', 'agent_enabled'))
    assert result['mention_status'] == 'unknown'


def test_empty_or_truncated_snapshot_cannot_pass():
    assert assess({})['status'] == 'incomplete_observation'
