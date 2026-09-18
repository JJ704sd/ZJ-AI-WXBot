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


def register_snapshot_matches(rows, expected):
    """Compare three fixture-owned thread snapshots, never infer other coverage."""
    if not isinstance(rows, list) or len(rows) != 3:
        return False
    for row in rows:
        if not isinstance(row, dict) or row.get('ok') is not True or row.get('resume_ok') is not True:
            return False
        registers, control = row.get('dr'), row.get('dr7')
        if (not isinstance(registers, list) or len(registers) != 4
                or any(type(x) is not int or not 0 <= x < 2**64 for x in registers)
                or type(control) is not int or not 0 <= control < 2**64):
            return False
        enabled = []
        for slot, address in enumerate(registers):
            if (control >> (2*slot)) & 3:
                if (control >> (16+4*slot)) & 15:  # Execute, length one only.
                    return False
                enabled.append(address)
        if len(enabled) != len(expected) or set(enabled) != set(expected):
            return False
    return True


def await_snapshot(path, target):
    deadline = time.monotonic() + 5
    while not path.exists():
        if target.poll() is not None or time.monotonic() > deadline:
            raise RuntimeError('fixture register snapshot unavailable')
        time.sleep(.02)
    return json.loads(path.read_text())


def scenario(gdb, executable, folder, mode, symbols=('fixture_marker',), raw_address=False,
             capture_registers=False):
    folder.mkdir()
    capture_registers = capture_registers and mode == 'three_threads'
    if capture_registers:
        (folder/'capture-registers').touch()
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
        numbers, expected_addresses = {}, {}
        for symbol in symbols:
            inserted = debugger.command('-break-insert -h '+('*'+locations[symbol] if raw_address else symbol))
            if 'type="hw breakpoint"' not in inserted:
                raise RuntimeError('not a hardware breakpoint')
            number = re.search(r'number="(\d+)"', inserted)[1]
            numbers[number] = symbol
            expected_addresses[number] = int(locations[symbol], 16) if raw_address else int(
                re.search(r'addr="(0x[0-9a-fA-F]+)"', inserted)[1], 16)
        listing = debugger.command('-break-list')
        listed = {}
        for body in re.findall(r'bkpt=\{([^{}]*)\}', listing):
            number = re.search(r'(?:^|,)number="(\d+)"', body)
            address = re.search(r'(?:^|,)addr="(0x[0-9a-fA-F]+)"', body)
            if number and address and 'type="hw breakpoint"' in body and 'enabled="y"' in body:
                listed[number[1]] = int(address[1], 16)
        report['breakpoint_address_readback_matches'] = listed == expected_addresses
        report['address_reference'] = 'fixture_ready_receipt' if raw_address else 'insertion_response'
        if not report['breakpoint_address_readback_matches']:
            raise RuntimeError('breakpoint address readback mismatch')
        initial_listing = debugger.command('-thread-info')
        initial_threads = set(re.findall(r'\{id="(\d+)"', initial_listing))
        if not initial_threads:
            raise RuntimeError('empty initial thread inventory')
        report['initial_thread_count'] = len(initial_threads)
        report['per_thread_debug_registers_verified'] = False
        report['target_process_coverage_verified'] = False
        lifecycle_start = len(debugger.log)
        report['hits_by_point'] = {symbol:0 for symbol in symbols}
        report['hardware_breakpoint_verified'] = True
        debugger.command('-exec-continue')
        stopped = False
        if mode == 'three_threads':
            (folder/'go').touch()
            if capture_registers:
                snapshot = await_snapshot(folder/'registers-before.json', target)
                report['fixture_debug_registers_before_match'] = register_snapshot_matches(
                    snapshot, set(expected_addresses.values()))
                if not report['fixture_debug_registers_before_match']:
                    raise RuntimeError('fixture hardware register mismatch before execution')
                (folder/'fire').touch()
            thread_ids = set()
            point_threads = {symbol:set() for symbol in symbols}
            for _ in range(12*len(symbols)):
                event = debugger.stops.get(timeout=5)
                stopped = True
                matched = re.search(r'bkptno="(\d+)"',event)
                if 'reason="breakpoint-hit"' not in event or not matched or matched[1] not in numbers:
                    raise RuntimeError('unexpected stop: '+event)
                report['hits_by_point'][numbers[matched[1]]] += 1
                thread_ids.add(re.search(r'thread-id="(\d+)"', event)[1])
                point_threads[numbers[matched[1]]].add(re.search(r'thread-id="(\d+)"', event)[1])
                report['hits'] += 1
                if all(len(ids) == 3 for ids in point_threads.values()):
                    break
                debugger.command('-exec-continue')
                stopped = False
            else:
                raise RuntimeError('fixture unique thread-point coverage not reached within event bound')
            report['unique_thread_point_hits'] = sum(len(ids) for ids in point_threads.values())
            report['repeated_thread_point_events'] = report['hits'] - report['unique_thread_point_hits']
            report['distinct_hit_threads'] = len(thread_ids)
            report['initial_threads_with_hits'] = len(thread_ids & initial_threads)
            report['new_threads_with_hits'] = len(thread_ids - initial_threads)
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
        final_listing = debugger.command('-thread-info')
        final_threads = set(re.findall(r'\{id="(\d+)"', final_listing))
        if not final_threads:
            raise RuntimeError('empty final thread inventory')
        report['final_thread_count'] = len(final_threads)
        report['new_threads_in_final_inventory'] = len(final_threads - initial_threads)
        lifecycle = '\n'.join(debugger.log[lifecycle_start:])
        report['mi_thread_created_notifications_in_window'] = len(re.findall(r'^=thread-created,', lifecycle, re.M))
        report['mi_thread_exited_notifications_in_window'] = len(re.findall(r'^=thread-exited,', lifecycle, re.M))
        if mode == 'three_threads':
            mapping = dict((mid, int(osid, 16) if osid.startswith('0x') else int(osid))
                           for mid, osid in re.findall(r'\{id="(\d+)",target-id="Thread \d+\.(0x[0-9a-fA-F]+|\d+)"',
                                                      initial_listing + final_listing))
            main_id, old_id, new_id = map(int, (folder/'thread-identities').read_text().split())
            report['fixture_thread_identity_matches'] = (
                {mapping.get(t) for t in thread_ids & initial_threads} == {main_id, old_id}
                and {mapping.get(t) for t in thread_ids - initial_threads} == {new_id}
                and all({mapping.get(t) for t in ids} == {main_id, old_id, new_id}
                        for ids in point_threads.values()))
        debugger.command('-break-delete '+' '.join(numbers))
        listing = debugger.command('-break-list')
        report['breakpoint_table_empty'] = 'body=[]' in listing
        debugger.command('-target-detach')
        attached = False
        report['detached'] = True
        report['alive_after_detach'] = target.poll() is None
        if capture_registers:
            (folder/'after-detach-capture').touch()
            snapshot = await_snapshot(folder/'registers-after.json', target)
            report['fixture_debug_registers_after_clear'] = register_snapshot_matches(snapshot, set())
            if not report['fixture_debug_registers_after_clear']:
                raise RuntimeError('fixture hardware registers not cleared after detach')
            report['per_thread_debug_registers_verified'] = True
            report['debug_register_scope'] = 'three fixture-owned threads at two snapshots only'
        debugger.command('-gdb-exit')
        debugger.process.wait(timeout=5)
        report['debugger_exit_code'] = debugger.process.returncode
        (folder/'go').touch()
        (folder/'post').touch()
        stdout, stderr = target.communicate(timeout=8)
        report['fixture_exit_code'] = target.returncode
        report['post_detach_calls_completed'] = 'FIXTURE_COMPLETED=6 CODE_UNCHANGED=1' in stdout
        if len(symbols) == 3:
            report['fixture_stage_calls_exact'] = 'STAGE_COMPLETED=12' in stdout
        report['passed'] = (report['breakpoint_address_readback_matches']
                            and report['breakpoint_table_empty'] and report['alive_after_detach']
                            and report['debugger_exit_code'] == 0 and target.returncode == 0
                            and report['post_detach_calls_completed']
                            and (len(symbols) != 3 or report['fixture_stage_calls_exact'])
                            and (mode != 'three_threads' or (report['distinct_hit_threads'] == 3
                                 and report['initial_threads_with_hits'] == 2
                                 and report['new_threads_with_hits'] == 1
                                 and report['fixture_thread_identity_matches']
                                 and report['unique_thread_point_hits'] == 3*len(symbols))))
    except Exception as exc:
        report['error'] = str(exc)
        report['fixture_exit_code_at_error'] = target.poll()
        if target.poll() is not None:
            stdout, stderr = target.communicate(timeout=1)
            (folder/'fixture-error-output.private.txt').write_text(stdout+stderr, encoding='utf-8')
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
    parser.add_argument('--capture-registers', action='store_true', help='Fixture samples only its own three threads before hits and after detach')
    args = parser.parse_args()
    if args.capture_registers and not args.raw_address:
        parser.error('--capture-registers requires --raw-address')
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
        generated = original.replace(declaration,replacement)
        generated = generated.replace('    printf("FIXTURE_COMPLETED=',
                                      '    printf("STAGE_COMPLETED=%ld\\n", stage_hits);\n    printf("FIXTURE_COMPLETED=')
        generated = generated.replace('return hits == 6 && unchanged ? 0 : 11;',
                                      'return hits == 6 && unchanged && stage_hits == 12 ? 0 : 11;')
        source = folder/'three_point_fixture.c'
        source.write_text(generated,encoding='utf-8')
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
    report = {'schema_version': 'windows-hook-attach-fixture.v3',
              'source_sha256': hashlib.sha256(source.read_bytes()).hexdigest(),
              'breakpoint_count':len(symbols),
              'raw_address_readnever':args.raw_address,
              'fixture_register_capture_requested':args.capture_registers,
              'live_wechat_touched': False,
              'scenarios': [scenario(args.gdb, executable, folder/mode, mode,symbols,args.raw_address,args.capture_registers)
                            for mode in ('three_threads', 'idle_timeout')]}
    report['passed'] = all(x['passed'] for x in report['scenarios'])
    report['limitations'] = ['Controlled idle timeout only; debugger crash and OS termination not covered.',
                            'Register snapshots, if requested, cover only three fixture-owned threads at sampled instants, not another process.',
                            'No evidence of Weixin receive semantics or object layout.']
    (folder/'result.json').write_text(json.dumps(report, indent=2)+'\n', encoding='utf-8')
    print(json.dumps(report, indent=2))
    return 0 if report['passed'] else 1


if __name__ == '__main__':
    raise SystemExit(main())
