#!/usr/bin/env python3
"""No-send native protobuf ownership/serialization check in the isolated client.

Run inside wechat-lab-linux with the JS alongside this file. No session keys,
message history, service pointers, or UI state are read by this check.
"""
import hashlib
import json
from pathlib import Path
import subprocess
import typing
import typing_extensions

if not hasattr(typing, 'NotRequired'):
    typing.NotRequired = typing_extensions.NotRequired
import frida

EXPECTED = 'e40116597803a5e0d9fc4a2b727df4b8f7a3dd6de1c336140ea373be2b6626e9'


def varint(value):
    output = bytearray()
    while value >= 128:
        output.append((value & 127) | 128)
        value >>= 7
    output.append(value)
    return bytes(output)


def integer(field, value):
    return varint(field << 3) + varint(value)


def blob(field, value):
    if isinstance(value, str):
        value = value.encode('utf-8')
    return varint((field << 3) | 2) + varint(len(value)) + value


def payload():
    # These fields exist only in an owned object; this script has no send entry.
    child = blob(1, blob(1, '48437025209@chatroom'))
    child += blob(2, '[接入测试] NATIVE-OBJECT-ONLY 未发送的对象往返验证。')
    child += integer(3, 1) + integer(4, 1700000000) + integer(5, 1700000001)
    child += blob(6, '<msgsource><atuserlist>25984984017034815@openim</atuserlist></msgsource>')
    child += integer(7, 0)
    return integer(1, 1) + blob(2, child)


def main():
    binary = Path('/opt/wechat/wechat')
    if hashlib.sha256(binary.read_bytes()).hexdigest() != EXPECTED:
        raise SystemExit('Unsupported binary; no attachment')
    pids = subprocess.run(['pgrep', '-x', 'wechat'], capture_output=True, text=True, check=True).stdout.split()
    matches = [int(pid) for pid in pids if Path('/proc/' + pid + '/exe').resolve() == binary]
    if len(matches) != 1:
        raise SystemExit('Expected exactly one isolated WeChat client')
    session = frida.attach(matches[0])
    try:
        script = session.create_script(Path(__file__).with_suffix('.js').read_text())
        script.load()
        result = script.exports_sync.roundtrip(list(payload()))
        script.unload()
        print(json.dumps({'pid': matches[0], **result}, ensure_ascii=False), flush=True)
        if not result.get('passed'):
            raise SystemExit(1)
    finally:
        session.detach()


if __name__ == '__main__':
    main()
