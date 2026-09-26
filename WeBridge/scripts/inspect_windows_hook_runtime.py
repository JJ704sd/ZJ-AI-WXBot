"""Pinned target constants; the old standalone Frida attachment probe is disabled.

Plain Frida 17.19 detachment crashes an isolated fixture in this environment.
Use run_windows_hook_smoke.py, which owns the resident-agent lifecycle.
Importing this module never opens a process or calls a native function.
"""
from pathlib import Path

ROOT=Path(__file__).resolve().parents[1]
MODULE=Path(r'D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll')
HASH='10f8e995453e2da46d4f2b5080cd6da1f13cc5147746adc119ceae38cb039de5'
CODE_RVAS={'textFactory':0x6F4C70,'textConstructor':0x766680,'optionsConstructor':0xF910,'sendMessage':0x19D0BC0}


def inspect():
    raise RuntimeError('Standalone attachment is disabled; use the resident-agent smoke harness.')


if __name__ == '__main__':
    raise SystemExit('Direct detach disabled. Use scripts/run_windows_hook_smoke.py --help.')
