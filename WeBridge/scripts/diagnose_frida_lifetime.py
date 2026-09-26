"""Isolated hidden Python fixture; never discovers or attaches to WeChat.

Only the parent-created fixture PID is passed to a short-lived controller.
The controller exits after detach; the parent checks fixture liveness and then
requests its normal exit over its private stdin pipe. No message/client code.
"""
from __future__ import annotations
import argparse
import json
from pathlib import Path
import subprocess
import sys
import time

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / '.runtime/hook-tools'))
MODES = ('no_attach', 'plain_detach', 'native_detach', 'main_eternalize', 'keeper_eternalize', 'keeper_main_eternalize')


def worker(pid, mode):
    import frida
    if mode == 'no_attach':
        print(json.dumps({'mode': mode, 'fridaVersion': frida.__version__, 'attached': False}), flush=True)
        return
    session = frida.attach(pid)
    out = {'mode': mode, 'fridaVersion': frida.__version__, 'attached': True}
    if mode in ('keeper_eternalize', 'keeper_main_eternalize'):
        keeper = session.create_script('// Permanent inert fixture keeper; no timers/hooks/native calls.\n')
        keeper.load()
        keeper.eternalize()
        out['keeperEternalized'] = True
    script = session.create_script('''
rpc.exports.metadata = function () { return {pid:Process.id, runtime:Script.runtime}; };
rpc.exports.nativeping = function () {
  const call = new NativeFunction(Process.getModuleByName('kernel32.dll').getExportByName('GetCurrentProcessId'), 'uint32', [], 'win64');
  return call();
};
''')
    script.load()
    out['metadataBefore'] = script.exports_sync.metadata()
    if mode == 'main_eternalize':
        script.eternalize()
        out['mainEternalized'] = True
        try:
            script.exports_sync.metadata()
            out['rpcAfterEternalize'] = 'available'
        except Exception as exc:
            # Fixed exception type is enough; no host/client memory in this fixture.
            out['rpcAfterEternalize'] = type(exc).__name__
    elif mode != 'plain_detach':
        out['nativePingCorrect'] = script.exports_sync.nativeping() == pid
    if mode == 'keeper_main_eternalize':
        script.eternalize()
        out['mainEternalizedAtClose'] = True
    session.detach()
    out['detached'] = True
    print(json.dumps(out), flush=True)


def parent(output, repeats, observe):
    records = []
    fixture = "import ctypes,sys; ctypes.windll.kernel32.SetErrorMode(3); print('READY',flush=True); sys.stdin.buffer.read(1)"
    for repeat in range(repeats):
        for mode in MODES:
            child = subprocess.Popen([sys.executable, '-u', '-c', fixture], stdin=subprocess.PIPE,
                stdout=subprocess.PIPE, stderr=subprocess.PIPE, creationflags=subprocess.CREATE_NO_WINDOW)
            try:
                assert child.stdout.readline().strip() == b'READY'
                started = time.monotonic()
                result = subprocess.run([sys.executable, str(Path(__file__).resolve()), '--worker', str(child.pid),
                    '--mode', mode], capture_output=True, text=True, encoding='utf-8', timeout=20,
                    creationflags=subprocess.CREATE_NO_WINDOW)
                row = {'repeat': repeat + 1, 'mode': mode, 'controllerExit': result.returncode}
                try:
                    row.update(json.loads(result.stdout))
                except Exception:
                    row['controllerError'] = result.stderr[-1000:]
                time.sleep(observe)
                row['aliveAfterHostExit'] = child.poll() is None
                row['observedSecondsAfterHostExit'] = observe
                if child.poll() is None:
                    child.stdin.write(b'q'); child.stdin.flush()
                try:
                    row['normalFixtureExitCode'] = child.wait(timeout=5)
                except subprocess.TimeoutExpired:
                    row['normalFixtureExitCode'] = 'timeout'
                row['durationSeconds'] = round(time.monotonic() - started, 3)
                records.append(row)
                print(json.dumps(row), flush=True)
                output.write_text(json.dumps({'fixture': 'hidden disposable Python child only', 'records': records}, indent=2), encoding='utf-8')
            finally:
                if child.poll() is None:
                    child.terminate(); child.wait(timeout=5)
                for stream in (child.stdin, child.stdout, child.stderr):
                    stream.close()


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--worker', type=int)
    parser.add_argument('--mode', choices=MODES)
    parser.add_argument('--repeats', type=int, default=2)
    parser.add_argument('--observe', type=float, default=2)
    parser.add_argument('--output', type=Path, default=ROOT / '.runtime/frida-lifetime-fixture.json')
    args = parser.parse_args()
    if args.worker:
        worker(args.worker, args.mode)
    else:
        if not 1 <= args.repeats <= 5 or not 0 <= args.observe <= 20:
            parser.error('bounded fixture range exceeded')
        parent(args.output, args.repeats, args.observe)
