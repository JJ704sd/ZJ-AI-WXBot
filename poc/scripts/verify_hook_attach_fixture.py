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
    def __init__(self, executable, readnever=False):
        self.process = subprocess.Popen([str(executable), '-nx', '-q', *(['--readnever'] if readnever else []), '--interpreter=mi2',
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


def scenario(gdb, executable, folder, mode, symbols=('fixture_marker',), raw_address=False):
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
        debugger = MI(gdb, readnever=raw_address)
        for command in ('-gdb-set pagination off', '-gdb-set confirm off', '-gdb-set auto-load off',
                        '-gdb-set debuginfod enabled off', '-gdb-set print frame-arguments none',
                        '-gdb-set mi-async on'):
            debugger.command(command)
        if raw_address:
            debugger.command('-gdb-set auto-solib-add off')
            addresses = (folder/'ready').read_text().split()
            if len(addresses) != len(symbols) or any(not re.fullmatch(r'0x[0-9a-fA-F]+',x) for x in addresses):
                raise ValueError('invalid fixture-owned addresses')
            locations = dict(zip(symbols,addresses))
        else:
            debugger.command('-file-exec-and-symbols ' + json.dumps(executable.as_posix()))
        debugger.command(f'-target-attach {target.pid}')
        attached = True
        debugger.stops.get(timeout=5)
        stopped = True
        numbers = {}
        for symbol in symbols:
            inserted = debugger.command('-break-insert -h '+('*'+locations[symbol] if raw_address else symbol))
            if 'type="hw breakpoint"' not in inserted:
                raise RuntimeError('not a hardware breakpoint')
            numbers[re.search(r'number="(\d+)"', inserted)[1]] = symbol
        report['hits_by_point'] = {symbol:0 for symbol in symbols}
        report['hardware_breakpoint_verified'] = True
        debugger.command('-exec-continue')
        stopped = False
        if mode == 'three_threads':
            (folder/'go').touch()
            thread_ids = set()
            for _ in range(3*len(symbols)):
                event = debugger.stops.get(timeout=5)
                stopped = True
                matched = re.search(r'bkptno="(\d+)"',event)
                if 'reason="breakpoint-hit"' not in event or not matched or matched[1] not in numbers:
                    raise RuntimeError('unexpected stop: '+event)
                report['hits_by_point'][numbers[matched[1]]] += 1
                thread_ids.add(re.search(r'thread-id="(\d+)"', event)[1])
                report['hits'] += 1
                if report['hits'] < 3*len(symbols):
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
        debugger.command('-break-delete '+' '.join(numbers))
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
                            and (mode != 'three_threads' or (report['distinct_hit_threads'] == 3
                                 and all(x == 3 for x in report['hits_by_point'].values()))))
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
    parser.add_argument('--three-points', action='store_true')
    parser.add_argument('--raw-address', action='store_true', help='Match live readnever/no-symbol absolute-address configuration')
    args = parser.parse_args()
    folder = args.output_dir.resolve()
    folder.mkdir(parents=True, exist_ok=False)
    source = Path(__file__).resolve().parents[1]/'probes/hook_attach_fixture.c'
    symbols = ('fixture_marker',)
    if args.three_points:
        original = source.read_text()
        declaration = '__attribute__((noinline)) void fixture_marker(void) { InterlockedIncrement(&hits); }'
        if original.count(declaration) != 1:
            raise ValueError('fixture source changed')
        replacement = ('static volatile LONG stage_hits = 0;\n'
            '__attribute__((noinline)) void fixture_stage_b(void) { InterlockedIncrement(&stage_hits); }\n'
            '__attribute__((noinline)) void fixture_stage_c(void) { InterlockedIncrement(&stage_hits); }\n'
            '__attribute__((noinline)) void fixture_marker(void) { InterlockedIncrement(&hits); '
            'fixture_stage_b(); fixture_stage_c(); }')
        source = folder/'three_point_fixture.c'
        source.write_text(original.replace(declaration,replacement),encoding='utf-8')
        symbols = ('fixture_marker','fixture_stage_b','fixture_stage_c')
    if args.raw_address:
        text = source.read_text()
        declaration = 'fputs("ready", receipt);'
        values = ','.join('(unsigned long long)(void *)&'+symbol for symbol in symbols)
        formatting = ' '.join(['0x%llx']*len(symbols))
        if text.count(declaration) != 1:
            raise ValueError('ready declaration changed')
        source = folder/'raw_address_fixture.c'
        source.write_text(text.replace(declaration,f'fprintf(receipt,"{formatting}",{values});'),encoding='utf-8')
    executable = folder/'fixture.exe'
    subprocess.run([str(args.gcc), '-g', '-O0', str(source), '-o', str(executable)],
                   check=True, capture_output=True, text=True, timeout=30)
    report = {'schema_version': 'windows-hook-attach-fixture.v1',
              'source_sha256': hashlib.sha256(source.read_bytes()).hexdigest(),
              'breakpoint_count':len(symbols),
              'raw_address_readnever':args.raw_address,
              'live_wechat_touched': False,
              'scenarios': [scenario(args.gdb, executable, folder/mode, mode,symbols,args.raw_address)
                            for mode in ('three_threads', 'idle_timeout')]}
    report['passed'] = all(x['passed'] for x in report['scenarios'])
    report['limitations'] = ['Controlled idle timeout only; debugger crash and OS termination not covered.',
                            'No evidence of Weixin receive semantics or object layout.']
    (folder/'result.json').write_text(json.dumps(report, indent=2)+'\n', encoding='utf-8')
    print(json.dumps(report, indent=2))
    return 0 if report['passed'] else 1


if __name__ == '__main__':
    raise SystemExit(main())
