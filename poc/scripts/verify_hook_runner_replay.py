"""Exercise a saved observer engine against ONLY a fixture created here."""
import argparse
import ast
import hashlib
import json
from pathlib import Path
import subprocess
import sys
import time


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    for name in ('runner','gcc','output-dir'):
        parser.add_argument('--'+name,type=Path,required=True)
    parser.add_argument('--inject-command-error',action='store_true')
    args=parser.parse_args()
    root=args.output_dir.resolve();root.mkdir(parents=True,exist_ok=False)
    source=Path(__file__).resolve().parents[1]/'probes/hook_attach_fixture.c'
    code=source.read_text()
    code=code.replace('fputs("ready", receipt);',
                      'fprintf(receipt,"0x%llx",(unsigned long long)(void *)&fixture_marker);')
    generated=root/'fixture.c';generated.write_text(code,encoding='utf-8')
    executable=root/'fixture.exe'
    subprocess.run([str(args.gcc),'-g','-O0',str(generated),'-o',str(executable)],check=True,
                   capture_output=True,timeout=30)
    target=subprocess.Popen([str(executable),str(root)],stdout=subprocess.PIPE,stderr=subprocess.PIPE,
                            text=True,creationflags=subprocess.CREATE_NO_WINDOW)
    report={'live_wechat_touched':False,'scenario':'command_error' if args.inject_command_error else 'known_hits',
            'runner_sha256':hashlib.sha256(args.runner.read_bytes()).hexdigest()}
    try:
        deadline=time.monotonic()+5
        while not (root/'ready').exists():
            if time.monotonic()>deadline:raise TimeoutError('fixture ready')
            time.sleep(.02)
        address=int((root/'ready').read_text(),16)
        saved=args.runner.read_text()
        # Replace only real-process preflight with an owned-child bootstrap.
        body=saved[saved.index('proc = subprocess.Popen'):]
        body=body.replace('baseline_end=time.monotonic()+5','baseline_end=time.monotonic()+.1')
        body=body.replace('now-marker_start>=25','now-marker_start>=1')
        if args.inject_command_error:
            body=body.replace("result['attached']=True", "result['attached']=True\n    cmd('-deliberately-invalid-fixture-command')",1)
        header=('import json,queue,re,subprocess,threading,time,sys\n'
                'from pathlib import Path\nfrom datetime import datetime,timezone\n'
                f'RUN=Path({str(root)!r})\nROOT=Path({str(args.runner.resolve().parent)!r})\npid={target.pid}\n'
                f'candidates={{"known_fixture":{address}}}\n')
        # Gate fixture activity at exactly the point the engine opens its marker window.
        body=body.replace('marker_start=time.monotonic()',
                          "marker_start=time.monotonic()\n            (RUN/'go').touch()")
        # The same go file is used to request the observation window; use a separate request.
        body=body.replace("(RUN/'go').exists()", "(RUN/'window_request').exists()")
        (root/'window_request').touch()
        replay=root/'replay.py';replay.write_text(header+body,encoding='utf-8');ast.parse(header+body)
        run=subprocess.run([sys.executable,'-X','utf8',str(replay)],capture_output=True,text=True,timeout=35)
        (root/'engine-output.private.txt').write_text(run.stdout+run.stderr,encoding='utf-8')
        result=json.loads((root/'result.private.json').read_text())
        report.update(engine_exit_code=run.returncode,stop_reason=result.get('stop_reason'),
                      detached=result.get('detached'),breakpoint_table_empty=result.get('breakpoint_table_empty'),
                      hit_count=len(result.get('hits',[])),engine_error_reported='command_failed' in result.get('stop_reason',''))
        (root/'go').touch();(root/'post').touch()
        stdout,_=target.communicate(timeout=8)
        report['fixture_survived_and_completed']=target.returncode==0 and 'FIXTURE_COMPLETED=6' in stdout
        report['passed']=(report['detached'] and report['breakpoint_table_empty'] and report['fixture_survived_and_completed']
                          and ((run.returncode!=0 and report['engine_error_reported']) if args.inject_command_error
                               else (run.returncode==0 and report['hit_count']==3)))
    finally:
        if target.poll() is None:target.kill();target.wait(timeout=3)
    (root/'replay-result.json').write_text(json.dumps(report,indent=2)+'\n',encoding='utf-8')
    print(json.dumps(report,indent=2))
    return 0 if report['passed'] else 1


if __name__=='__main__':
    raise SystemExit(main())
