from copy import deepcopy

import pytest

from wechat_agent_poc.hybrid_observer import (
    HybridSessionObserver, Layout, ObservationBlocked, checked_lines, label_key,
)


LAYOUT = Layout(800, 600, (300, 0, 800, 80), (300, 80, 800, 500), 'Target (7)')


def line(text):
    return {'text': text, 'box': [0, 0, 100, 20]}


class Image:
    size = (800, 600)
    def crop(self, box):
        return self
    def close(self):
        pass
    def __enter__(self):
        return self
    def __exit__(self, *args):
        pass


class Backend:
    def __init__(self, status='readable'):
        self.state = {'kind': 'live_window', 'available': True, 'size': [800, 600], 'pid': 1}
        self.result = {'status': status, 'header': [line('Target (7)')],
                       'messages': [line('@Alice hello world')]}
        self.captures = 0
    def observe(self):
        return deepcopy(self.state)
    def uia(self, layout):
        return deepcopy(self.result)
    def capture(self):
        self.captures += 1
        return Image()


class Ocr:
    def __init__(self):
        self.calls = 0
    def recognize(self, image):
        self.calls += 1
        return [line('Target (7)' if self.calls % 2 else '@Alice hello world')]


def test_uia_priority_and_no_promotion_to_events():
    backend, ocr = Backend(), Ocr()
    observer = HybridSessionObserver(backend, ocr, LAYOUT)
    result = observer.poll()
    assert result['source'] == 'uia' and ocr.calls == backend.captures == 0
    assert result['baseline'] and result['visible_text_changed'] is None
    assert not any(result[k] for k in ('account_verified', 'group_verified',
        'new_messages_verified', 'native_mentions_verified', 'agent_enabled', 'send_enabled'))
    assert result['messages'][0]['message_id'] is None
    assert result['messages'][0]['mention_status'] == 'unknown'
    assert observer.poll()['visible_text_changed'] is False
    backend.result['messages'].append(line('@Alice hello world'))
    changed = observer.poll()
    assert changed['visible_text_changed'] is True
    assert len(changed['messages']) == 2  # Equal text is not a duplicate identity.


def test_ocr_fallback_preserves_spaces_and_source_switch_resets_baseline():
    backend, ocr = Backend(), Ocr()
    observer = HybridSessionObserver(backend, ocr, LAYOUT)
    observer.poll()
    backend.result['status'] = 'semantic_unavailable'
    result = observer.poll()
    assert result['source'] == 'ocr' and result['baseline']
    assert result['messages'][0]['text'] == '@Alice hello world'
    assert result['messages'][0]['confidence'] is None
    assert ocr.calls == 2 and backend.captures == 1


@pytest.mark.parametrize('status', ['truncated', 'error', None])
def test_failure_is_not_fallback(status):
    backend, ocr = Backend(status), Ocr()
    observer = HybridSessionObserver(backend, ocr, LAYOUT)
    with pytest.raises(ObservationBlocked, match='uia_incomplete'):
        observer.poll()
    assert ocr.calls == 0
    with pytest.raises(ObservationBlocked, match='observer_paused'):
        observer.poll()


def test_empty_readable_uia_is_not_ocr_trigger():
    backend, ocr = Backend(), Ocr()
    backend.result['messages'] = []
    assert HybridSessionObserver(backend, ocr, LAYOUT).poll()['messages'] == []
    assert ocr.calls == 0


def test_binding_change_discards_all_text():
    backend, ocr = Backend('semantic_unavailable'), Ocr()
    original = ocr.recognize
    def recognize(image):
        backend.state['pid'] = 2
        return original(image)
    ocr.recognize = recognize
    with pytest.raises(ObservationBlocked, match='binding_changed'):
        HybridSessionObserver(backend, ocr, LAYOUT).poll()


def test_title_hint_is_not_identity_and_mismatch_blocks():
    backend = Backend()
    backend.result['header'] = [line('Other target')]
    with pytest.raises(ObservationBlocked, match='target_label_unconfirmed'):
        HybridSessionObserver(backend, Ocr(), LAYOUT).poll()


def test_exception_is_redacted_not_treated_as_empty():
    class BrokenOcr:
        def recognize(self, image):
            raise RuntimeError('private chat body')
    with pytest.raises(ObservationBlocked, match='^backend_error$'):
        HybridSessionObserver(Backend('semantic_unavailable'), BrokenOcr(), LAYOUT).poll()


@pytest.mark.parametrize('box', [[-1, 0, 2, 3], [0, 0, 900, 20], [0, 0, float('nan'), 20]])
def test_invalid_ocr_coordinates_rejected(box):
    with pytest.raises(ObservationBlocked):
        checked_lines([{'text': 'x', 'box': box}], 500, 420)


def test_layout_rejects_overlap():
    with pytest.raises(ValueError, match='overlapping'):
        Layout(100, 100, (0, 0, 60, 60), (50, 50, 100, 100), 'x')


def test_layout_size_mismatch_prevents_reads():
    backend, ocr = Backend(), Ocr()
    backend.state['size'] = [801, 600]
    with pytest.raises(ObservationBlocked, match='window_or_layout'):
        HybridSessionObserver(backend, ocr, LAYOUT).poll()
    assert ocr.calls == 0


def test_label_normalization_does_not_hide_english_errors_or_change_body():
    assert label_key('合成 AI target (7)') == label_key('合成AI target (7)')
    assert label_key('Hello wo rld') != label_key('Hello world')
    assert label_key('群 (7)') != label_key('群 (6)')
    assert checked_lines([line('中 文')], 500, 420)[0]['text'] == '中 文'


def test_review_preserves_mismatched_title_and_disabled_identity():
    backend = Backend()
    backend.result['header'] = [line('Different title')]
    result = HybridSessionObserver(backend, Ocr(), LAYOUT, review_unconfirmed_title=True).poll()
    assert result['header'][0]['text'] == 'Different title'
    assert result['review_required'] and not result['target_label_match']
    assert not result['group_verified'] and not result['agent_enabled']


def test_engine_score_is_preserved_without_identity_promotion():
    row = dict(line('text'), confidence=.98)
    result = checked_lines([row], 500, 420)[0]
    assert result['confidence'] == .98 and result['message_id'] is None
