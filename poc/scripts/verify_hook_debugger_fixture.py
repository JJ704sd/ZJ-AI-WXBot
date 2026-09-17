"""Compile and debug only a disposable fixture; cannot select a live process."""
import argparse
import hashlib
import json
from pathlib import Path
import subprocess


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--gcc', type=Path, required=True)
    parser.add_argument('--gdb', type=Path, required=True)
    parser.add_argument('--output-dir', type=Path, required=True)
    args = parser.parse_args()
    folder = args.output_dir.resolve()
    folder.mkdir(parents=True, exist_ok=False)
    source = Path(__file__).resolve().parents[1] / 'probes/hook_hardware_breakpoint_fixture.c'
    executable = folder / 'fixture.exe'
    subprocess.run([str(args.gcc), '-g', '-O0', str(source), '-o', str(executable)],
                   capture_output=True, text=True, check=True, timeout=30)
    commands = folder / 'commands.gdb'
    commands.write_text('set pagination off\nset confirm off\nset auto-load off\n'
                        'set debuginfod enabled off\nset print frame-arguments none\n'
                        'start\nhbreak fixture_marker\ncommands\nsilent\nprintf "FIXTURE_HW_HIT\\n"\n'
                        'continue\nend\ncontinue\n', encoding='ascii')
    run = subprocess.run([str(args.gdb), '-nx', '-q', '-batch', '-iex', 'set auto-load off',
                          '-x', str(commands), str(executable)],
                         capture_output=True, text=True, timeout=30,
                         creationflags=subprocess.CREATE_NO_WINDOW)
    output = run.stdout + run.stderr
    (folder / 'debugger-output.txt').write_text(output, encoding='utf-8')
    report = {'schema_version': 'windows-hook-debugger-fixture.v1',
              'target': 'self_compiled_disposable_fixture', 'live_wechat_touched': False,
              'mode': 'debugger_launch_not_attach', 'debugger_exit_code': run.returncode,
              'fixture_bootstrap': 'GDB start uses a temporary breakpoint in the disposable fixture only',
              'hardware_breakpoint_reported': 'Hardware assisted breakpoint' in output,
              'observed_hits': output.count('FIXTURE_HW_HIT'),
              'fixture_completed': 'FIXTURE_COMPLETED=3' in output,
              'inferior_exited_normally': 'exited normally' in output,
              'source_sha256': hashlib.sha256(source.read_bytes()).hexdigest(),
              'limitations': ['Does not verify live-process attach cleanup or multithread breakpoint propagation.',
                             'Does not verify Weixin candidate, object layout or message semantics.']}
    report['passed'] = (run.returncode == 0 and report['hardware_breakpoint_reported']
                        and report['observed_hits'] == 3 and report['fixture_completed']
                        and report['inferior_exited_normally'])
    (folder / 'result.json').write_text(json.dumps(report, indent=2)+'\n', encoding='utf-8')
    print(json.dumps(report, indent=2))
    return 0 if report['passed'] else 1


if __name__ == '__main__':
    raise SystemExit(main())
