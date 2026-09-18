import pytest
from wechat_agent_poc.qt_accessibility_trial import trial


class Port:
    def __init__(self, value=0):
        self.value = value
        self.writes = []
    def read(self):
        return self.value
    def write(self, value):
        self.writes.append(value)
        self.value = value
    def same_target(self):
        return True


def test_success_restores_original_byte_without_enabling_send():
    port = Port()
    result = trial(port, lambda: {'status': 'structure_candidate_only'})
    assert result['restored'] is True and port.value == 0
    assert result['send_enabled'] is False


def test_observer_failure_still_restores():
    port = Port()
    def fail():
        raise TimeoutError('synthetic')
    result = trial(port, fail)
    assert result['status'] == 'trial_failed'
    assert result['restored'] is True and port.value == 0


@pytest.mark.parametrize('value', [1, 2, None])
def test_unknown_initial_state_never_written(value):
    port = Port(value)
    result = trial(port, lambda: pytest.fail('must not observe'))
    assert result['write_attempted'] is False and port.writes == []


def test_changed_window_never_written():
    port = Port()
    port.same_target = lambda: False
    assert trial(port, lambda: {})['status'] == 'target_changed'
    assert port.writes == []


def test_partial_write_exception_attempts_restore():
    port = Port()
    def write(value):
        port.value = value
        if value == 1:
            raise OSError('partial write')
    port.write = write
    result = trial(port, lambda: {})
    assert result['status'] == 'trial_failed'
    assert result['restored'] is True and port.value == 0


def test_readback_failure_restores():
    port = Port()
    def write(value):
        port.value = 2 if value == 1 else value
    port.write = write
    result = trial(port, lambda: pytest.fail('no observation after failed readback'))
    assert result['status'] == 'trial_failed' and result['restored'] is True


def test_restore_failure_overrides_observation_success():
    port = Port()
    def write(value):
        if value == 0:
            raise OSError('restore failed')
        port.value = value
    port.write = write
    result = trial(port, lambda: {'status': 'structure_candidate_only'})
    assert result['status'] == 'restore_failed' and result['restored'] is False


def test_window_change_during_observation_invalidates_success_but_restores():
    port = Port()
    def changed():
        port.same_target = lambda: False
        return {'status': 'structure_candidate_only'}
    result = trial(port, changed)
    assert result['status'] == 'trial_failed'
    assert result['restored'] is True and port.value == 0


def test_interrupt_restores_and_is_not_reported_as_success():
    port = Port()
    def stop():
        raise KeyboardInterrupt()
    result = trial(port, stop)
    assert result['status'] == 'trial_failed'
    assert result['restored'] is True and port.value == 0
