"""Outcome contract for an address-only observer, never a receive acceptance gate."""
import math


def finalize_probe_result(result: dict) -> dict:
    result = dict(result)
    reasons = []
    for field in ('attached', 'detached', 'breakpoint_table_empty'):
        if result.get(field) is not True:
            reasons.append(field + '_not_confirmed')
    if result.get('debugger_exit_code') != 0:
        reasons.append('debugger_exit_not_clean')
    if result.get('cleanup_error'):
        reasons.append('cleanup_error')
    elapsed, maximum = result.get('elapsed_seconds'), result.get('maximum_attach_seconds')
    if (not isinstance(elapsed,(int,float)) or isinstance(elapsed,bool) or not math.isfinite(elapsed)
            or not isinstance(maximum,(int,float)) or isinstance(maximum,bool) or not math.isfinite(maximum)
            or elapsed < 0 or maximum <= 0 or elapsed > maximum):
        reasons.append('time_bound_not_confirmed')
    reason = result.get('stop_reason')
    if reason not in ('marker_window_complete', 'hit_limit', 'time_budget'):
        reasons.append('unexpected_stop_reason')
    result['receive_entry_verified'] = False
    result['execution_errors'] = reasons
    if reasons:
        result.update(execution_status='failed', observation_status='inconclusive', exit_code=2)
    elif result.get('marker_window_start_seconds') is None:
        result.update(execution_status='completed', observation_status='marker_window_not_opened', exit_code=3)
    elif reason != 'marker_window_complete':
        result.update(execution_status='completed', observation_status='truncated', exit_code=3)
    else:
        result.update(execution_status='completed',
                      observation_status='hits_observed' if result.get('hits') else 'no_hits', exit_code=0)
    return result
