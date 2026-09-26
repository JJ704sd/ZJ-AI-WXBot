#!/usr/bin/env python3
"""Attach for one calibration sample; no message sending in this process."""
import hashlib
import json
import os
from pathlib import Path
import subprocess
import time
import typing
import typing_extensions
if not hasattr(typing, 'NotRequired'):
    typing.NotRequired = typing_extensions.NotRequired
import frida

binary = Path('/opt/wechat/wechat')
if hashlib.sha256(binary.read_bytes()).hexdigest() != 'e40116597803a5e0d9fc4a2b727df4b8f7a3dd6de1c336140ea373be2b6626e9':
    raise SystemExit('Unexpected binary')
pids = subprocess.run(['pgrep','-x','wechat'],capture_output=True,text=True,check=True).stdout.split()
matches = [int(p) for p in pids if Path('/proc/'+p+'/exe').resolve()==binary]
if len(matches)!=1: raise SystemExit('Expected one test client')
session=frida.attach(matches[0])
try:
    script=session.create_script(Path('/tmp/native_calibrate.js').read_text())
    script.on('message',lambda message,data: print(json.dumps(message,ensure_ascii=False),flush=True))
    script.load()
    deadline=time.monotonic()+40
    result=None
    while time.monotonic()<deadline:
        time.sleep(.25)
        result=script.exports_sync.result()
        if result['captured'] or result['failure']: break
    script.unload()
    if not result or not result.get('captured'):
        raise SystemExit('No matching calibration sample; do not retry the message automatically')
    path=Path('/tmp/wechat-lab-native-calibration.json')
    fd=os.open(str(path),os.O_WRONLY|os.O_CREAT|os.O_TRUNC,0o600)
    with os.fdopen(fd,'w') as output: json.dump(result['captured'],output,ensure_ascii=False)
    print(json.dumps({'saved':str(path),'sentByObserver':False}),flush=True)
finally:
    session.detach()
