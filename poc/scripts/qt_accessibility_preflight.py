"""Pinned one-byte Qt diagnostic. Default read-only. No login, DB, input or send.

--allow-temporary-byte-write is an explicit manual trial gate, never automatic.
"""
import argparse
import ctypes
import hashlib
import json
import os
import subprocess
import sys
import tempfile
from datetime import datetime, timezone
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from wechat_agent_poc.qt_accessibility_trial import trial

# Target-specific values stay outside the public checkout. Set these variables
# only in a local, controlled environment before a diagnostic run.
EXE = Path(os.environ.get('PYWEIXIN_EXE', r'C:\path\to\Weixin\Weixin.exe'))
DLL = Path(os.environ.get('PYWEIXIN_DLL', str(EXE.parent / 'Weixin.dll')))
DLL_SHA = os.environ.get('PYWEIXIN_DLL_SHA256')
RVA_TEXT = os.environ.get('PYWEIXIN_GATE_RVA')
RVA = int(RVA_TEXT, 0) if RVA_TEXT else None
ERROR_CODES = {
    'unreviewed_dll', 'target_not_unique', 'target_minimized', 'open_process_failed',
    'pinned_module_not_loaded', 'target_changed', 'one_byte_read_failed',
    'write_not_permitted', 'original_module_unavailable', 'one_byte_write_failed',
    'structure_probe_failed', 'unexpected_baseline', 'local_target_config_required',
}


class NativeByte:
    def __init__(self, writable=False):
        import psutil
        import win32gui
        import win32process
        self.handle = None
        if not DLL_SHA or RVA is None:
            raise ValueError('local_target_config_required')
        if hashlib.sha256(DLL.read_bytes()).hexdigest() != DLL_SHA:
            raise ValueError('unreviewed_dll')
        windows = []
        def visit(hwnd, _):
            if (win32gui.IsWindowVisible(hwnd)
                    and win32gui.GetClassName(hwnd) == 'Qt51514QWindowIcon'
                    and win32gui.GetWindowText(hwnd) in ('微信', 'Weixin', 'WeChat')):
                pid = win32process.GetWindowThreadProcessId(hwnd)[1]
                if Path(psutil.Process(pid).exe()).resolve() == EXE.resolve():
                    windows.append((hwnd, pid))
            return True
        win32gui.EnumWindows(visit, None)
        if len(windows) != 1:
            raise ValueError('target_not_unique')
        self.hwnd, self.pid = windows[0]
        if win32gui.IsIconic(self.hwnd):
            raise ValueError('target_minimized')
        self.generation = psutil.Process(self.pid).create_time()
        self.writable = writable
        self.kernel = ctypes.WinDLL('kernel32', use_last_error=True)
        self.kernel.OpenProcess.argtypes = [ctypes.c_ulong, ctypes.c_int, ctypes.c_ulong]
        self.kernel.OpenProcess.restype = ctypes.c_void_p
        self.kernel.CloseHandle.argtypes = [ctypes.c_void_p]
        self.kernel.CloseHandle.restype = ctypes.c_int
        for name in ('ReadProcessMemory', 'WriteProcessMemory'):
            fn = getattr(self.kernel, name)
            fn.argtypes = [ctypes.c_void_p, ctypes.c_void_p, ctypes.c_void_p,
                           ctypes.c_size_t, ctypes.POINTER(ctypes.c_size_t)]
            fn.restype = ctypes.c_int
        access = 0x0400 | 0x0010
        if writable:
            access |= 0x0020 | 0x0008
        self.handle = self.kernel.OpenProcess(access, False, self.pid)
        if not self.handle:
            raise OSError('open_process_failed')
        try:
            modules = [base for base in win32process.EnumProcessModulesEx(self.handle, 3)
                       if Path(win32process.GetModuleFileNameEx(self.handle, base)).resolve() == DLL.resolve()]
            if len(modules) != 1:
                raise ValueError('pinned_module_not_loaded')
            self.base = int(modules[0])
            self.address = self.base + RVA
            if not self.same_target():
                raise ValueError('target_changed')
        except Exception:
            self.close()
            raise

    def same_target(self):
        import psutil
        import win32gui
        import win32process
        process = psutil.Process(self.pid)
        return (process.create_time() == self.generation
            and Path(process.exe()).resolve() == EXE.resolve()
            and win32gui.IsWindow(self.hwnd)
            and win32process.GetWindowThreadProcessId(self.hwnd)[1] == self.pid
            and not win32gui.IsIconic(self.hwnd)
            and self.module_matches())

    def module_matches(self):
        import win32process
        return (self.base in win32process.EnumProcessModulesEx(self.handle, 3)
            and Path(win32process.GetModuleFileNameEx(self.handle, self.base)).resolve() == DLL.resolve())

    def read(self):
        value, count = ctypes.c_ubyte(), ctypes.c_size_t()
        ok = self.kernel.ReadProcessMemory(self.handle, self.address,
            ctypes.byref(value), 1, ctypes.byref(count))
        if not ok or count.value != 1:
            raise OSError('one_byte_read_failed')
        return value.value

    def write(self, value):
        if not self.writable or value not in (0, 1):
            raise ValueError('write_not_permitted')
        if not self.module_matches():
            raise ValueError('original_module_unavailable')
        data, count = ctypes.c_ubyte(value), ctypes.c_size_t()
        ok = self.kernel.WriteProcessMemory(self.handle, self.address,
            ctypes.byref(data), 1, ctypes.byref(count))
        if not ok or count.value != 1:
            raise OSError('one_byte_write_failed')

    def close(self):
        if self.handle:
            self.kernel.CloseHandle(self.handle)
            self.handle = None


def observe(max_depth=6, max_nodes=128, binding_config=None):
    with tempfile.TemporaryDirectory(prefix='qt-uia-trial-') as temp:
        output = Path(temp) / 'structure.json'
        proc = subprocess.run([sys.executable, str(Path(__file__).with_name('probe_pyweixin_structure.py')),
            '--worker', '--exe', str(EXE), '--max-depth', str(max_depth),
            '--max-nodes', str(max_nodes), '--output', str(output)] +
            (['--binding-config', str(binding_config)] if binding_config else []),
            timeout=15, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        if proc.returncode or not output.exists():
            raise RuntimeError('structure_probe_failed')
        result = json.loads(output.read_text(encoding='utf-8'))
        # Retain bounded/truncated observations after activation; they are not
        # admission success but must not be lost behind a generic exception.
        return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', required=True)
    parser.add_argument('--allow-temporary-byte-write', action='store_true')
    parser.add_argument('--structure-depth', type=int, default=6)
    parser.add_argument('--structure-nodes', type=int, default=128)
    parser.add_argument('--binding-config')
    args = parser.parse_args()
    if not 1 <= args.structure_depth <= 32 or not 16 <= args.structure_nodes <= 1024:
        parser.error('structure budget outside supported bounds')
    output = Path(args.output)
    if output.exists():
        parser.error('choose a new evidence filename')
    report = dict(observed_at=datetime.now(timezone.utc).date().isoformat(),
        dll_sha256=None, rva=None,
        mode='trial' if args.allow_temporary_byte_write else 'read_only_preflight',
        write_authorized_flag=args.allow_temporary_byte_write, send_enabled=False)
    port = None
    try:
        port = NativeByte(writable=args.allow_temporary_byte_write)
        report['current_byte'] = port.read()
        report['same_target'] = port.same_target()
        report['status'] = 'preflight_only'
        if args.allow_temporary_byte_write:
            bounded_observe = lambda: observe(args.structure_depth, args.structure_nodes, args.binding_config)
            report['before'] = bounded_observe()
            if (report['before'].get('root_class') != 'Qt51514QWindowIcon'
                    or report['before'].get('version') != '4.1.13.65'
                    or report['before'].get('complete') is not True
                    or report['before'].get('binding_stable') is not True):
                raise ValueError('unexpected_baseline')
            report['trial'] = trial(port, bounded_observe)
            report['status'] = report['trial']['status']
            if report['trial']['restored'] is True:
                report['after_restore'] = bounded_observe()
    except (Exception, KeyboardInterrupt) as exc:
        report['status'] = 'error'
        report['error_type'] = type(exc).__name__
        # Only our own fixed reason codes; never serialize arbitrary exceptions.
        if str(exc) in ERROR_CODES:
            report['error_code'] = str(exc)
    finally:
        if port:
            port.close()
        output.write_text(json.dumps(report, indent=2)+'\n', encoding='utf-8')
    print(json.dumps({key: value for key, value in report.items()
                      if key not in ('before', 'trial', 'after_restore')}))
    if 'trial' in report:
        print(json.dumps({key: value for key, value in report['trial'].items()
                          if key != 'observation'}))
    return 0 if report['status'] in ('preflight_only', 'observed') else 2


if __name__ == '__main__':
    raise SystemExit(main())
