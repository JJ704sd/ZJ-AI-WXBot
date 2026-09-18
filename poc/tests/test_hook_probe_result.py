import pytest
from wechat_agent_poc.hook_probe_result import finalize_probe_result


def complete(**changes):
    row=dict(attached=True,detached=True,breakpoint_table_empty=True,debugger_exit_code=0,
             elapsed_seconds=40,maximum_attach_seconds=90,stop_reason='marker_window_complete',
             marker_window_start_seconds=10,hits=[])
    row.update(changes)
    return row


def test_command_error_cannot_exit_success_even_after_clean_detach():
    row=finalize_probe_result(complete(stop_reason='RuntimeError:command_failed:test'))
    assert row['exit_code']==2 and row['observation_status']=='inconclusive'


def test_zero_hits_is_completed_observation_but_never_receive_success():
    row=finalize_probe_result(complete())
    assert row['exit_code']==0 and row['observation_status']=='no_hits'
    assert not row['receive_entry_verified']


@pytest.mark.parametrize('change',[dict(detached=False),dict(breakpoint_table_empty=False),
    dict(debugger_exit_code=1),dict(cleanup_error='timeout'),dict(elapsed_seconds=91),
    dict(elapsed_seconds=float('nan')),dict(maximum_attach_seconds=None)])
def test_uncertain_cleanup_or_budget_is_failure(change):
    assert finalize_probe_result(complete(**change))['exit_code']==2


def test_baseline_cap_or_early_budget_is_not_a_full_marker_window():
    assert finalize_probe_result(complete(stop_reason='hit_limit',marker_window_start_seconds=None))['exit_code']==3
    assert finalize_probe_result(complete(stop_reason='time_budget'))['observation_status']=='truncated'


def test_hits_do_not_prove_message_semantics():
    row=finalize_probe_result(complete(hits=[{'point':'entry'}],receive_entry_verified=True))
    assert row['observation_status']=='hits_observed' and not row['receive_entry_verified']


def test_observation_evidence_error_cannot_report_clean_zero_hits():
    row=finalize_probe_result(complete(observation_evidence_error='final_thread_inventory_failed'))
    assert row['exit_code']==2
    assert row['observation_status']=='inconclusive'
    assert 'observation_evidence_error' in row['execution_errors']
