"""Attach ONLY to a child compiled/created here. No arbitrary PID option."""
import argparse
import hashlib
import json
from pathlib import Path
import queue
import re
import subprocess
import threading
import time


class MI:
    def __init__(self, executable):
        self.process = subprocess.Popen([str(executable), '-nx', '-q', '--interpreter=mi2',
                                         '-iex', 'set auto-load off'],
                                        stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                                        text=True, encoding='utf-8', errors='replace', bufsize=1,
                                        creationflags=subprocess.CREATE_NO_WINDOW)
        self.results, self.stops = queue.Queue(), queue.Queue()
        self.log, self.token = [], 0
        threading.Thread(target=self._read, daemon=True).start()

    def _read(self):
        for line in self.process.stdout:
            line = line.rstrip()
            self.log.append(line)
            if re.match(r'^\d+\^', line):
                self.results.put(line)
            elif line.startswith('*stopped'):
                self.stops.put(line)

    def command(self, command, timeout=5):
        self.token += 1
        self.process.stdin.write(f'{self.token}{command}\n')
        self.process.stdin.flush()
        deadline = time.monotonic() + timeout
        while time.monotonic() < deadline:
            line = self.results.get(timeout=max(.01, deadline-time.monotonic()))
            if line.startswith(f'{self.token}^'):
                if '^error' in line:
                    raise RuntimeError(line)
                return line
        raise TimeoutError(command)


def scenario(gdb, executable, folder, mode):
    folder.mkdir()
    target = subprocess.Popen([str(executable), str(folder)], stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                              text=True, creationflags=subprocess.CREATE_NO_WINDOW)
    debugger = None
    stopped, attached = False, False
    report = {'mode': mode, 'live_wechat_touched': False, 'hits': 0, 'passed': False}
    try:
        deadline = time.monotonic() + 5
        while not (folder/'ready').exists():
            if target.poll() is not None or time.monotonic() > deadline:
                raise RuntimeError('fixture did not become ready')
            time.sleep(.02)
        debugger = MI(gdb)
        for command in ('-gdb-set pagination off', '-gdb-set confirm off', '-gdb-set auto-load off',
                        '-gdb-set debuginfod enabled off', '-gdb-set print frame-arguments none',
                        '-gdb-set mi-async on'):
            debugger.command(command)
        debugger.command('-file-exec-and-symbols ' + json.dumps(executable.as_posix()))
        debugger.command(f'-target-attach {target.pid}')
        attached = True
        debugger.stops.get(timeout=5)
        stopped = True
        inserted = debugger.command('-break-insert -h fixture_marker')
        if 'type="hw breakpoint"' not in inserted:
            raise RuntimeError('not a hardware breakpoint')
        number = re.search(r'number="(\d+)"', inserted)[1]
        report['hardware_breakpoint_verified'] = True
        debugger.command('-exec-continue')
        stopped = False
        if mode == 'three_threads':
            (folder/'go').touch()
            thread_ids = set()
            for _ in range(3):
                event = debugger.stops.get(timeout=5)
                stopped = True
                if 'reason="breakpoint-hit"' not in event or f'bkptno="{number}"' not in event:
                    raise RuntimeError('unexpected stop: '+event)
                thread_ids.add(re.search(r'thread-id="(\d+)"', event)[1])
                report['hits'] += 1
                if report['hits'] < 3:
                    debugger.command('-exec-continue')
                    stopped = False
            report['distinct_hit_threads'] = len(thread_ids)
        else:
            # Deliberate no-message time budget expiry, not an injected debugger failure.
            try:
                debugger.stops.get(timeout=.3)
                stopped = True
                raise RuntimeError('unexpected stop during idle budget')
            except queue.Empty:
                report['idle_budget_expired'] = True
        if not stopped:
            debugger.command('-exec-interrupt --all')
            debugger.stops.get(timeout=5)
            stopped = True
        debugger.command('-break-delete '+number)
        listing = debugger.command('-break-list')
        report['breakpoint_table_empty'] = 'body=[]' in listing
        debugger.command('-target-detach')
        attached = False
        report['detached'] = True
        report['alive_after_detach'] = target.poll() is None
        debugger.command('-gdb-exit')
        debugger.process.wait(timeout=5)
        report['debugger_exit_code'] = debugger.process.returncode
        (folder/'go').touch()
        (folder/'post').touch()
        stdout, stderr = target.communicate(timeout=8)
        report['fixture_exit_code'] = target.returncode
        report['post_detach_calls_completed'] = 'FIXTURE_COMPLETED=6 CODE_UNCHANGED=1' in stdout
        report['passed'] = (report['breakpoint_table_empty'] and report['alive_after_detach']
                            and report['debugger_exit_code'] == 0 and target.returncode == 0
                            and report['post_detach_calls_completed']
                            and (mode != 'three_threads' or report['distinct_hit_threads'] == 3))
    except Exception as exc:
        report['error'] = str(exc)
    finally:
        if debugger and debugger.process.poll() is None:
            try:
                if attached:
                    if not stopped:
                        debugger.command('-exec-interrupt --all')
                        debugger.stops.get(timeout=3)
                    debugger.command('-break-delete')
                    debugger.command('-target-detach')
                debugger.command('-gdb-exit')
                debugger.process.wait(timeout=3)
            except Exception:
                debugger.process.kill()  # This harness owns both disposable processes.
                debugger.process.wait(timeout=3)
        if target.poll() is None:
            target.kill()  # NEVER used with a caller-supplied target PID.
            target.wait(timeout=3)
        if debugger:
            (folder/'debugger.private.txt').write_text('\n'.join(debugger.log), encoding='utf-8')
    return report


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    for name in ('gcc', 'gdb', 'output-dir'):
        parser.add_argument('--'+name, required=True, type=Path)
    args = parser.parse_args()
    folder = args.output_dir.resolve()
    folder.mkdir(parents=True, exist_ok=False)
    source = Path(__file__).resolve().parents[1]/'probes/hook_attach_fixture.c'
    executable = folder/'fixture.exe'
    subprocess.run([str(args.gcc), '-g', '-O0', str(source), '-o', str(executable)],
                   check=True, capture_output=True, text=True, timeout=30)
    report = {'schema_version': 'windows-hook-attach-fixture.v1',
              'source_sha256': hashlib.sha256(source.read_bytes()).hexdigest(),
              'live_wechat_touched': False,
              'scenarios': [scenario(args.gdb, executable, folder/mode, mode)
                            for mode in ('three_threads', 'idle_timeout')]}
    report['passed'] = all(x['passed'] for x in report['scenarios'])
    report['limitations'] = ['Controlled idle timeout only; debugger crash and OS termination not covered.',
                            'No evidence of Weixin receive semantics or object layout.']
    (folder/'result.json').write_text(json.dumps(report, indent=2)+'\n', encoding='utf-8')
    print(json.dumps(report, indent=2))
    return 0 if report['passed'] else 1


if __name__ == '__main__':
    raise SystemExit(main())
