"""One-byte diagnostic transaction; native access lives in the explicit CLI.

Restoring the byte is not a guarantee of restoring Qt internal state.
"""


def trial(port, observe):
    result = dict(status='not_started', write_attempted=False, write_readback=False,
                  restored=None, observation=None, send_enabled=False)
    original = port.read()
    if original != 0:
        result['status'] = 'initial_byte_not_zero'
        return result
    if not port.same_target():
        result['status'] = 'target_changed'
        return result
    try:
        result['write_attempted'] = True
        port.write(1)
        if port.read() != 1:
            raise ValueError('write_readback_mismatch')
        result['write_readback'] = True
        result['observation'] = observe()
        if not port.same_target():
            raise ValueError('target_changed_during_observation')
        result['status'] = 'observed'
    except (Exception, KeyboardInterrupt) as exc:
        result['status'] = 'trial_failed'
        result['error_type'] = type(exc).__name__
    finally:
        if result['write_attempted']:
            try:
                # Native port holds the original process handle; never reopen by PID.
                port.write(original)
                result['restored'] = port.read() == original
            except Exception as exc:
                result['restored'] = False
                result['restore_error_type'] = type(exc).__name__
            if result['restored'] is not True:
                result['status'] = 'restore_failed'
    return result
