"""Synthetic-only native-provider control. No Weixin discovery or access."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import time
import uuid
from datetime import datetime, timezone

import probe_uia_research_v2 as v2


def is_fixture_window(mode, class_name, title):
    if mode == 'N0':
        return v2.is_fixture_window(class_name, title)
    return class_name.startswith('HwndWrapper[') and title == 'Synthetic UIA native provider'


def run_collection(command, output, timeout=15):
    """Watch only the process tree created here; never kill by process name."""
    import psutil
    result = {'schema': 'uia-v3-native/1', 'run_id': str(uuid.uuid4()),
              'started_at': datetime.now(timezone.utc).isoformat(),
              'execution_status': 'error', 'wechat_access': False, 'passed': False,
              'watchdog_seconds': timeout}
    process = None
    descendants = []
    try:
        process = psutil.Popen(command, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL,
                               creationflags=0x08000000)
        try:
            code = process.wait(timeout=timeout)
        except psutil.TimeoutExpired:
            result['execution_status'] = 'timed_out'
            descendants = process.children(recursive=True)
            return result
        result['worker_exit_code'] = code
        if code != 0:
            result['error_type'] = 'WorkerExitError'
            return result
        observed = json.loads(Path(output).read_text(encoding='utf-8'))
        if not isinstance(observed, dict):
            raise ValueError('invalid_report')
        return observed
    except Exception as exc:
        result['error_type'] = type(exc).__name__
        return result
    finally:
        if process is not None:
            if process.is_running():
                descendants += process.children(recursive=True)
            owned = list({p.pid: p for p in descendants}.values()) + [process]
            cleanup_errors = []
            for target in owned:
                try:
                    if target.is_running():
                        target.kill()
                    target.wait(timeout=3)
                except psutil.NoSuchProcess:
                    pass
                except (psutil.Error, OSError) as exc:
                    cleanup_errors.append(type(exc).__name__)
            result['cleanup'] = {'tracked_processes': len(owned), 'errors': cleanup_errors,
                                 'remaining_pids': [p.pid for p in owned if p.is_running()]}


def qualifies(report):
    snap = report.get('snapshot', {})
    if (report.get('execution_status') != 'completed' or snap.get('truncated', True)
            or not snap.get('binding_stable') or report.get('closed_target_status') != 'invalidated'):
        return False
    provider = snap['providers'][0]['server_side']
    if report['mode'] == 'N0':
        return provider == {'state': 'observed', 'value': False}
    checks = report.get('value_interfaces', [])
    return (provider == {'state': 'observed', 'value': True} and any(
        item.get('property') == {'state': 'observed', 'value': True}
        and item.get('interface_state') == 'observed'
        and item.get('readonly') is True and item.get('synthetic_value_matched') is True
        for item in checks))


def worker(mode, hwnd, pid):
    report = {'schema': 'uia-v3-native/1', 'run_id': str(uuid.uuid4()), 'mode': mode,
              'started_at': datetime.now(timezone.utc).isoformat(),
              'execution_status': 'error', 'wechat_access': False,
              'budget': {'seconds': 15, 'nodes': 128, 'depth': 6},
              'probe_sha256': hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
              'shared_v2_sha256': hashlib.sha256(Path(v2.__file__).read_bytes()).hexdigest(),
              'fixture_sha256': hashlib.sha256(Path(__file__).with_name('uia_v3_wpf_fixture.ps1').read_bytes()).hexdigest() if mode == 'N1' else None}
    try:
        import win32gui
        if not is_fixture_window(mode, win32gui.GetClassName(hwnd), win32gui.GetWindowText(hwnd)):
            raise RuntimeError('fixture_not_owned')
        before = v2.binding(hwnd)
        if before['pid'] != pid:
            raise RuntimeError('not_owned_fixture')
        api, unsupported = v2.new_api()
        import comtypes.client
        module = comtypes.client.GetModule('UIAutomationCore.dll')
        snap = v2.snapshot(api, unsupported, hwnd)
        report['snapshot'] = snap
        if not snap['binding_stable']:
            report['execution_status'] = 'invalidated'
            return report
        root = api.ElementFromHandle(hwnd)
        # Bounded traversal already proved small; select only Edit controls of this fixture.
        edits = root.FindAll(4, api.CreatePropertyCondition(30003, 50004))
        samples = []
        for i in range(min(edits.Length, 16)):
            element = edits.GetElement(i)
            if element.CurrentProcessId != pid:
                raise RuntimeError('foreign_element')
            row = {'property_id': 30043, 'pattern_id': 10002,
                   'property': v2.property_result(element, 30043, unsupported, v2.strict_bool)}
            try:
                raw = element.GetCurrentPattern(10002)
                if not raw:
                    row['interface_state'] = 'not_supported'
                else:
                    value = raw.QueryInterface(module.IUIAutomationValuePattern)
                    row.update(interface_state='observed', readonly=bool(value.CurrentIsReadOnly))
                    if mode == 'N1':
                        row['synthetic_value_matched'] = value.CurrentValue == 'uia-v3-synthetic-value'
            except Exception as exc:
                row.update(interface_state='error', error_type=type(exc).__name__, hresult=getattr(exc, 'hresult', None))
            samples.append(row)
        report['value_interfaces'] = samples
        if v2.binding(hwnd) != before:
            report['execution_status'] = 'invalidated'
            return report
        win32gui.PostMessage(hwnd, 0x0010, 0, 0)  # only owned synthetic target
        deadline = time.monotonic() + 2
        while win32gui.IsWindow(hwnd) and time.monotonic() < deadline:
            time.sleep(.02)
        try:
            report['closed_target_status'] = 'valid' if v2.binding(hwnd) == before else 'invalidated'
        except RuntimeError:
            report['closed_target_status'] = 'invalidated'
        report['stale_property'] = v2.property_result(root, 30003, unsupported)
        report['execution_status'] = 'completed'
        report['passed'] = qualifies(report)
    except Exception as exc:
        report.update(error_type=type(exc).__name__, hresult=getattr(exc, 'hresult', None), passed=False)
    return report


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('mode', choices=['N0', 'N1'])
    parser.add_argument('--worker', action='store_true')
    parser.add_argument('--hwnd', type=int)
    parser.add_argument('--pid', type=int)
    parser.add_argument('--output', required=True)
    args = parser.parse_args()
    if args.worker:
        Path(args.output).write_text(json.dumps(worker(args.mode, args.hwnd, args.pid), indent=2), encoding='utf-8')
        return
    with tempfile.TemporaryDirectory(prefix='uia-v3-') as tmp:
        ready = Path(tmp) / 'ready.json'
        if args.mode == 'N0':
            command = [sys.executable, v2.__file__, 'fixture', '--output', str(ready)]
        else:
            shell = str(Path(os.environ['SystemRoot']) / 'System32/WindowsPowerShell/v1.0/powershell.exe')
            command = [shell, '-NoProfile', '-STA', '-File', str(Path(__file__).with_name('uia_v3_wpf_fixture.ps1')), '-ReadyPath', str(ready)]
        fixture = subprocess.Popen(command, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, creationflags=0x08000000)
        owned_children = []
        result = {'mode': args.mode, 'run_id': str(uuid.uuid4()),
                  'started_at': datetime.now(timezone.utc).isoformat(),
                  'execution_status': 'error', 'wechat_access': False, 'passed': False}
        try:
            deadline = time.monotonic() + 10
            while not ready.exists() and fixture.poll() is None and time.monotonic() < deadline:
                time.sleep(.05)
            hwnd = json.loads(ready.read_text(encoding='utf-8-sig'))['hwnd']
            import psutil
            actual_pid = v2.binding(hwnd)['pid']
            owned_children = psutil.Process(fixture.pid).children(recursive=True)
            owned_pids = {fixture.pid} | {p.pid for p in owned_children}
            if actual_pid not in owned_pids:
                raise RuntimeError('fixture_not_in_created_process_tree')
            output = Path(tmp) / 'report.json'
            result = run_collection([sys.executable, __file__, args.mode, '--worker', '--hwnd', str(hwnd),
                                     '--pid', str(actual_pid), '--output', str(output)], output)
            result.setdefault('mode', args.mode)
        except subprocess.TimeoutExpired:
            result['execution_status'] = 'timed_out'
        except Exception as exc:
            result['error_type'] = type(exc).__name__
        finally:
            import psutil
            if fixture.poll() is None:
                owned_children += psutil.Process(fixture.pid).children(recursive=True)
            for child in owned_children:
                try:
                    if child.is_running():
                        child.terminate()
                        child.wait(timeout=3)
                except psutil.NoSuchProcess:
                    pass
            if fixture.poll() is None:
                fixture.terminate()
            fixture.wait(timeout=3)
        Path(args.output).write_text(json.dumps(result, indent=2), encoding='utf-8')
        print(json.dumps({key: result.get(key) for key in ('mode', 'run_id', 'execution_status', 'passed', 'error_type', 'value_interfaces', 'closed_target_status')}))


if __name__ == '__main__':
    main()
