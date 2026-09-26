#!/usr/bin/env python3
"""Bounded observation of this isolated client's test-message call path."""
import hashlib
import argparse
import json
from pathlib import Path
import subprocess
import time
import typing
import typing_extensions
if not hasattr(typing, 'NotRequired'):
    typing.NotRequired = typing_extensions.NotRequired
import frida

EXPECTED = 'e40116597803a5e0d9fc4a2b727df4b8f7a3dd6de1c336140ea373be2b6626e9'
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--seconds', type=int, default=15)
args = parser.parse_args()
if not 1 <= args.seconds <= 55:
    raise SystemExit('Observation duration must be 1..55 seconds')
binary = Path('/opt/wechat/wechat')
if hashlib.sha256(binary.read_bytes()).hexdigest() != EXPECTED:
    raise SystemExit('Unexpected binary; no attachment')
pids = subprocess.run(['pgrep','-x','wechat'],capture_output=True,text=True,check=True).stdout.split()
matches = [int(pid) for pid in pids if Path('/proc/'+pid+'/exe').resolve() == binary]
if len(matches)!=1:
    raise SystemExit('Expected one isolated client')
session=frida.attach(matches[0])
try:
    script=session.create_script(Path('/tmp/native_observe.js').read_text())
    script.on('message', lambda message,data: print(json.dumps(message,ensure_ascii=False),flush=True))
    script.load()
    time.sleep(args.seconds)
    try:
        print(json.dumps({'summary':script.exports_sync.summary()}),flush=True)
        script.unload()
    except frida.InvalidOperationError:
        print(json.dumps({'error':'observer_destroyed','stable':False}),flush=True)
        raise SystemExit(1)
finally:
    session.detach()
