#!/usr/bin/env python3
"""Send exactly one authorized UI calibration message in the confirmed group.

Refuses existing drafts and writes a local attempt marker before clicking Send.
All locations come from fresh accessibility bounds, never saved coordinates.
"""
import json
from pathlib import Path
import select
import subprocess
import time
from linux_lab import request, ROOT

GROUP = '中技AI cosplay'
MARKER = ROOT / '.runtime/native-cal-004-attempt.json'


def nodes(node):
    if not isinstance(node, dict): return
    yield node
    for child in node.get('children', []): yield from nodes(child)


def tree():
    return list(nodes(request('/api/debug/a11y')['tree']))


def one(items, predicate):
    found=[n for n in items if predicate(n)]
    if len(found)!=1: raise RuntimeError('Expected exactly one matching authorized UI control')
    return found[0]


def click(node):
    b=node['bounds']
    subprocess.run(['docker','exec','wechat-lab-linux','/opt/tools/click',str(int(b['x']+b['width']/2)),str(int(b['y']+b['height']/2))],check=True,capture_output=True)


def confirmed_controls():
    items=tree()
    editor=one(items,lambda n:n.get('name')==GROUP and 'EDITABLE' in n.get('states',[]))
    button=one(items,lambda n:n.get('name')=='Send(S)' and n.get('role')=='push-button')
    return editor,button


def main():
    if MARKER.exists(): raise SystemExit('Calibration already attempted; will not send again')
    if request('/api/status/auth').get('status')!='logged_in': raise SystemExit('Not logged in')
    editor,button=confirmed_controls()
    if 'DISABLED' not in button.get('states',[]): raise SystemExit('Existing draft; do not overwrite')
    process=subprocess.Popen(['docker','exec','wechat-lab-linux','python3','/tmp/native_calibrate_runner.py'],stdout=subprocess.PIPE,stderr=subprocess.STDOUT,text=True)
    try:
        if not select.select([process.stdout],[],[],15)[0]: raise RuntimeError('Observer did not become ready')
        first=process.stdout.readline()
        if json.loads(first).get('payload',{}).get('event')!='ready': raise RuntimeError('Observer not ready')
        click(editor)
        subprocess.run(['docker','exec','wechat-lab-linux','/opt/tools/input','[接入测试] NATIVE-CAL-004 原生接口参数校准。 '],check=True,capture_output=True)
        subprocess.run(['docker','exec','wechat-lab-linux','xdotool','key','at'],check=True,capture_output=True)
        target=None
        for _ in range(15):
            found=[n for n in tree() if n.get('role')=='list-item' and n.get('name')=='陈佳豪']
            if len(found)==1: target=found[0]; break
            time.sleep(.15)
        if target is None: raise RuntimeError('Exact authorized mention target not found; do not send')
        click(target)
        _,button=confirmed_controls()
        if 'DISABLED' in button.get('states',[]): raise RuntimeError('Send remains disabled')
        MARKER.parent.mkdir(exist_ok=True)
        with MARKER.open('x') as output:
            json.dump({'group':GROUP,'member':'陈佳豪','marker':'NATIVE-CAL-004','attempted':True,'automaticRetry':False},output,ensure_ascii=False)
        MARKER.chmod(0o600)
        click(button)
        output,_=process.communicate(timeout=45)
        print(output,end='')
        if process.returncode: raise SystemExit(process.returncode)
    finally:
        if process.poll() is None:
            # The container observer is independently bounded to 40 seconds.
            process.terminate()


if __name__=='__main__': main()
