import ctypes
import json
from pathlib import Path
import sys
from types import SimpleNamespace

import pytest

from wechat_agent_poc.hybrid_observer import ObservationBlocked
from wechat_agent_poc.hybrid_windows import bounded_worker, window_pid


@pytest.mark.parametrize('thread_id,pid,success', [(0, 1234, False), (1, 0, False), (1, 5304, True)])
def test_pid_requires_successful_native_call(monkeypatch, thread_id, pid, success):
    def query(hwnd, output):
        assert hwnd == 123
        output._obj.value = pid
        return thread_id
    monkeypatch.setattr(ctypes, 'WinDLL', lambda *a, **k: SimpleNamespace(GetWindowThreadProcessId=query))
    if success:
        assert window_pid(123) == 5304
    else:
        with pytest.raises(ObservationBlocked, match='window_identity_unavailable'):
            window_pid(123)


@pytest.mark.parametrize('hwnd', [0, -1, None, True])
def test_invalid_handle_rejected_before_native_call(hwnd):
    with pytest.raises(ObservationBlocked, match='invalid_window_handle'):
        window_pid(hwnd)


def test_worker_resolves_module_independently_of_launcher_directory(monkeypatch, tmp_path):
    def popen(command, **options):
        assert (Path(options['cwd']) / 'wechat_agent_poc/hybrid_windows.py').is_file()
        assert Path(options['cwd']).resolve() != tmp_path.resolve()
        Path(command[5]).write_text(json.dumps({'status': 'semantic_unavailable'}), encoding='utf-8')
        return SimpleNamespace(wait=lambda timeout: 0)
    monkeypatch.chdir(tmp_path)
    monkeypatch.setitem(sys.modules, 'psutil', SimpleNamespace(Popen=popen))
    assert bounded_worker(123, {'pid': 5304})['status'] == 'semantic_unavailable'
