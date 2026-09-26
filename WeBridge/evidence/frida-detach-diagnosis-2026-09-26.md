# Frida 17.19 Windows detach failure: isolated evidence

The local Frida unload path is reproducibly unsafe in this environment. A
hidden disposable Python process crashes with `0xC0000005` after ordinary
attach/script/detach, even when the script performs no `NativeFunction` calls.
Keeping an inert script resident prevents that symptom in the bounded fixture.
This isolates a lifecycle problem; it does not identify the exact faulty
Frida thread/instruction or establish general WeChat send compatibility.

## Reported incident, kept separate from earlier events

At 2026-09-26 16:16:28, Application Error reports Weixin PID `0x3DB0` (15792),
module `frida-agent.dll_unloaded`, offset `0x9c7e0`, exception `0xC0000005`.
The preceding native construction result had 12/12 readbacks true and
`sendCalled:false`. Its host then followed `finally -> session.detach()`.
There was no message-send call. An earlier 16:06 event mentioning a different
PID and `qingnse64.dll` is a separate incident, not folded into this finding.

## Repeatable fixture

Command, run from the repository root:

```powershell
python -X utf8 WeBridge/scripts/diagnose_frida_lifetime.py --repeats 3 --observe 2 --output WeBridge/.runtime/frida-lifetime-fixture-repeated.json
```

Environment: Windows 11 build 26100, Python 3.13.9 x64, Frida 17.19.0, QJS.
Each case uses a new hidden Python child, never WeChat. Its controller is a
separate short-lived process. After the controller fully exits, the parent
observes the fixture for two seconds, then asks it to exit normally through a
private stdin pipe. All remaining fixture handles/processes are cleaned up.

| Case | Runs | Alive after host exit | Fixture exit |
| --- | ---: | ---: | --- |
| No attach | 3 | 3 | 0, 0, 0 |
| Metadata-only script, ordinary detach | 3 | 0 | C0000005 in all 3 |
| GetCurrentProcessId NativeFunction, ordinary detach | 3 | 0 | C0000005 in all 3 |
| Main script eternalized, then detach | 3 | 3 | 0, 0, 0 |
| Separate inert keeper eternalized before working RPC | 3 | 3 | 0, 0, 0 |
| Keeper first; working RPC; eternalize main at close; detach | 3 | 3 | 0, 0, 0 |

Raw bounded records are in `frida-detach-fixture-2026-09-26.json`. An earlier
four-case exploratory run gave the same outcomes. Ordinary metadata-only
failure rules out WeChat constructors, object layout and message payload as
necessary causes of this reproduced unload fault. It does not prove all of
those independent native-call risks absent.

## Supported lifecycle and its limits

Use a separate script containing only a comment: create, load, eternalize.
Only after that succeeds should the normal working script perform native
calls. Keep the working script managed while RPC is needed. At final close,
eternalize that working script before detaching to preserve its roots as well.
No hook, timer, send or callback is needed in the keeper.

Do **not** eternalize the working RPC script before calling it. All three
fixture runs report `InvalidOperationError` on subsequent RPC. The pinned
official implementation removes an eternalized script from the managed
instance map, and subsequent posts require an instance in that map.
[Frida 17.19 script engine](https://github.com/frida/frida-core/blob/17.19.0/lib/payload/script-engine.vala#L166-L176)

The agent retains eternalized scripts and switches its unload policy to
`RESIDENT`; this explains why an inert keeper can protect the agent while a
second script remains callable. This intentionally retains instrumentation
until the target process exits; it is not normal reversible script unloading.
[Frida 17.19 agent lifecycle](https://github.com/frida/frida-core/blob/17.19.0/lib/agent/agent.vala#L182-L185)
[Eternalized-script retention](https://github.com/frida/frida-core/blob/17.19.0/lib/agent/agent.vala#L912-L915)

JavaScript `Script.pin()` is a different reference-counted temporary mechanism
requiring a corresponding unpin, not a replacement for this host-side
eternalization design. [Official Script API](https://frida.re/docs/javascript-api/#script)

This diagnosis did not attach to WeChat, load any WeChat library, read chats,
or make message calls. Production harness changes and any subsequent bounded
send validation belong to the parent task. The old metadata inspector's
unconditional detach should remain disabled or receive the same lifecycle
review before reuse. The upstream low-level cause and behavior on other
Frida/Windows versions remain unverified.
