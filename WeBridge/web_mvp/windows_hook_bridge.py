"""Start and gracefully stop the local text bridge from the workbench."""
from __future__ import annotations

import ctypes
import json
import os
from pathlib import Path
import secrets
import subprocess
import sys
import threading

from windows_hook_sender import LoopbackTransport

ROOT = Path(__file__).resolve().parents[1]
MESSAGES = {
    'stopped': '发送桥未启动。',
    'starting': '正在连接当前微信客户端…',
    'ready': '发送桥已启动，可向当前选择的会话发送文本。',
    'stopping': '正在停止发送桥，保留客户端中的必要运行资源。',
    'failed': '发送桥启动或连接失败，请检查微信是否正常运行。',
}


def process_matches(state):
    """Read process creation time only; never signal or terminate a process."""
    if os.name != 'nt':
        return False
    try:
        from ctypes import wintypes
        kernel = ctypes.WinDLL('kernel32', use_last_error=True)
        kernel.OpenProcess.argtypes = (wintypes.DWORD, wintypes.BOOL, wintypes.DWORD)
        kernel.OpenProcess.restype = wintypes.HANDLE
        kernel.GetProcessTimes.argtypes = (wintypes.HANDLE,) + (ctypes.POINTER(wintypes.FILETIME),) * 4
        kernel.GetProcessTimes.restype = wintypes.BOOL
        kernel.GetExitCodeProcess.argtypes = (wintypes.HANDLE, ctypes.POINTER(wintypes.DWORD))
        kernel.CloseHandle.argtypes = (wintypes.HANDLE,)
        handle = kernel.OpenProcess(0x1000, False, int(state['processId']))
        if not handle:
            return False
        try:
            created, exited, system, user = (wintypes.FILETIME() for _ in range(4))
            code = wintypes.DWORD()
            if not kernel.GetProcessTimes(handle, ctypes.byref(created), ctypes.byref(exited),
                                          ctypes.byref(system), ctypes.byref(user)):
                return False
            if not kernel.GetExitCodeProcess(handle, ctypes.byref(code)) or code.value != 259:
                return False
            started = ((created.dwHighDateTime << 32) | created.dwLowDateTime) / 10_000_000 - 11644473600
            return abs(float(state['startedAt']) - started) < 30
        finally:
            kernel.CloseHandle(handle)
    except (OSError, ValueError, TypeError, KeyError):
        return False


class WindowsHookBridgeManager:
    def __init__(self, runtime_dir):
        self.directory = Path(runtime_dir).resolve()
        self.directory.mkdir(parents=True, exist_ok=True)
        self.state_path = self.directory / 'hook-bridge-state.json'
        self.process = None
        self.instance_id = None
        self.stopping = False
        self.lock = threading.RLock()

    def _state(self):
        try:
            result = json.loads(self.state_path.read_text(encoding='utf-8'))
            return result if isinstance(result, dict) else {}
        except (OSError, ValueError):
            return {}

    def _probe(self, state):
        try:
            config = json.loads((self.directory / 'hook-config.json').read_text(encoding='utf-8'))
            if config['endpoint'] != state.get('endpoint'):
                return False
            token = (self.directory / config['tokenFile']).read_text(encoding='utf-8').strip()
            response = LoopbackTransport(config['endpoint'], token)('GET', '/v1/status')
            return (response.get('ready') is True and response.get('instanceId') == state.get('nativeInstanceId'))
        except Exception:
            return False

    def _result(self, name, state=None, issue_code=''):
        state = state or {}
        return {'state': name, 'available': name == 'ready', 'issueCode': issue_code,
            'issue': MESSAGES[name], **{key: state[key] for key in ('processId', 'instanceId', 'endpoint') if key in state}}

    def status(self):
        with self.lock:
            state = self._state()
            owned_alive = self.process is not None and self.process.poll() is None
            if owned_alive and state.get('instanceId') != self.instance_id:
                return self._result('stopping' if self.stopping else 'starting',
                                    {'processId': self.process.pid, 'instanceId': self.instance_id})
            live = owned_alive or process_matches(state)
            if self.stopping and live:
                return self._result('stopping', state)
            if state.get('state') == 'ready' and self._probe(state):
                return self._result('ready', state)
            if live and state.get('state') in ('starting', 'stopping'):
                return self._result(state['state'], state, state.get('issueCode', ''))
            if live:
                return self._result('failed', state, 'bridge_unavailable')
            if state.get('state') == 'failed' or (self.process is not None and self.process.poll() not in (None, 0)):
                return self._result('failed', state, state.get('issueCode') or 'bridge_start_failed')
            return self._result('stopped', state)

    def start(self):
        with self.lock:
            current = self.status()
            if (current['state'] in ('ready', 'starting', 'stopping') or
                    self.process is not None and self.process.poll() is None or process_matches(self._state())):
                return current
            self.instance_id = secrets.token_hex(16)
            self.stopping = False
            command = [sys.executable, str(ROOT / 'scripts/run_windows_hook_bridge.py'), '--serve',
                       '--runtime-dir', str(self.directory), '--instance-id', self.instance_id]
            try:
                self.process = subprocess.Popen(command, cwd=ROOT, stdin=subprocess.DEVNULL,
                    stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, close_fds=True,
                    creationflags=subprocess.CREATE_NO_WINDOW if os.name == 'nt' else 0)
            except OSError:
                self.process = None
                return self._result('failed', issue_code='bridge_start_failed')
            return self._result('starting', {'processId': self.process.pid, 'instanceId': self.instance_id})

    def stop(self):
        with self.lock:
            state = self._state()
            owned_alive = self.process is not None and self.process.poll() is None
            if owned_alive:
                instance_id = self.instance_id
            elif process_matches(state) or state.get('state') == 'ready' and self._probe(state):
                instance_id = state.get('instanceId')
            else:
                return self.status()
            temporary = self.directory / ('hook-bridge-stop.' + secrets.token_hex(8) + '.tmp')
            with temporary.open('x', encoding='utf-8') as stream:
                json.dump({'instanceId': instance_id}, stream)
                stream.flush()
                os.fsync(stream.fileno())
            os.replace(temporary, self.directory / 'hook-bridge-stop.json')
            self.stopping = True
            return self._result('stopping', {**state, 'instanceId': instance_id})
