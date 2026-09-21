import pytest
from wechat_agent_poc.controlled_trigger import ControlledTrigger
from wechat_agent_poc.hybrid_observer import ObservationBlocked

TEXT = 'UIA-READ-SYNTH000 测试自动草稿'

def snap(n, rows=(), binding='one', kind='live_window', matched=True):
    return {'snapshot_id': str(n), 'capture_kind': kind,
            'window_observation': {'binding': binding},
            'header': [{'text': 'synthetic group'}],
            'target_label_match': matched, 'review_required': not matched,
            'messages': [{'text': x} for x in rows]}

def test_two_distinct_observations_emit_only_once():
    detector = ControlledTrigger(TEXT)
    assert detector.consume(snap(0)) == 'BASELINE_READY'
    assert detector.consume(snap(1, [TEXT])) == 'WAITING'
    assert detector.consume(snap(1, [TEXT])) == 'REPLAY_IGNORED'
    assert detector.consume(snap(2, [TEXT])) == 'CANDIDATE_ONCE'
    assert detector.consume(snap(3, [TEXT])) == 'ALREADY_EMITTED'

def test_ambiguous_or_missing_line_resets_stability():
    detector = ControlledTrigger(TEXT)
    detector.consume(snap(0))
    detector.consume(snap(1, [TEXT]))
    assert detector.consume(snap(2, [TEXT, TEXT])) == 'WAITING'
    assert detector.consume(snap(3, [TEXT])) == 'WAITING'
    assert detector.consume(snap(4, [TEXT])) == 'CANDIDATE_ONCE'

def test_historical_or_offline_input_cannot_trigger():
    with pytest.raises(ObservationBlocked, match='baseline'):
        ControlledTrigger(TEXT).consume(snap(0, [TEXT]))
    with pytest.raises(ObservationBlocked, match='live_snapshot'):
        ControlledTrigger(TEXT).consume(snap(0, kind='offline_image'))

def test_window_change_pauses_even_if_text_matches():
    detector = ControlledTrigger(TEXT)
    detector.consume(snap(0))
    with pytest.raises(ObservationBlocked, match='window_or_header_changed'):
        detector.consume(snap(1, [TEXT], binding='other'))
    with pytest.raises(ObservationBlocked, match='trigger_paused'):
        detector.consume(snap(2, [TEXT]))

def test_unconfirmed_title_pauses_before_baseline_or_trigger():
    detector = ControlledTrigger(TEXT)
    with pytest.raises(ObservationBlocked, match='target_label_unconfirmed'):
        detector.consume(snap(0, matched=False))
    with pytest.raises(ObservationBlocked, match='trigger_paused'):
        detector.consume(snap(1))

def test_translation_allowed_but_resize_rejected_for_marker_only():
    detector = ControlledTrigger('UIA-READ-SYNTH000')
    first = snap(0)
    first['window_observation'].update(rect=[0, 0, 800, 600], size=[800, 600], dpi=96)
    assert detector.consume(first) == 'BASELINE_READY'
    moved = snap(1, ['UIA-READ-SYNTH000'])
    moved['window_observation'].update(rect=[10, 20, 810, 620], size=[800, 600], dpi=96)
    assert detector.consume(moved) == 'WAITING'
    resized = snap(2, ['UIA-READ-SYNTH000'])
    resized['window_observation'].update(rect=[10, 20, 910, 620], size=[900, 600], dpi=96)
    with pytest.raises(ObservationBlocked, match='window_or_header_changed'):
        detector.consume(resized)
