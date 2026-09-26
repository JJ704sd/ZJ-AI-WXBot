#!/usr/bin/env python3
"""Attach briefly to the isolated test client and inspect its loaded module.

No hooks, native calls, memory writes, message reads, or sends. Python 3.10
needs the typing-only NotRequired backport for the preinstalled Frida binding.
"""
import json
import pathlib
import re
import subprocess
import typing
import typing_extensions

if not hasattr(typing, 'NotRequired'):
    typing.NotRequired = typing_extensions.NotRequired
import frida

EXPECTED_BUILD = '9a3558be209dfcf1b85d6ec18bf029c7f97ccb61'


def main():
    binary = '/opt/wechat/wechat'
    notes = subprocess.run(['readelf', '-n', binary], capture_output=True, text=True, check=True).stdout
    actual = re.search(r'Build ID:\s*(\w+)', notes).group(1)
    if actual != EXPECTED_BUILD:
        raise SystemExit('Unsupported build; no attachment attempted')
    pids = subprocess.run(['pgrep', '-x', 'wechat'], capture_output=True, text=True, check=True).stdout.split()
    matches = [int(p) for p in pids if pathlib.Path(f'/proc/{p}/exe').resolve() == pathlib.Path(binary)]
    if len(matches) != 1:
        raise SystemExit('Expected exactly one isolated WeChat process')
    session = frida.attach(matches[0])
    try:
        script = session.create_script("""
            rpc.exports.inspect = function () {
                const m = Process.getModuleByName('wechat');
                return {arch: Process.arch, pointerSize: Process.pointerSize,
                        module: m.name, base: m.base.toString(), size: m.size,
                        exports: m.enumerateExports().length};
            };
        """)
        script.load()
        print(json.dumps({'buildId': actual, 'frida': frida.__version__, 'loaded': script.exports_sync.inspect()}))
        script.unload()
    finally:
        session.detach()


if __name__ == '__main__':
    main()
