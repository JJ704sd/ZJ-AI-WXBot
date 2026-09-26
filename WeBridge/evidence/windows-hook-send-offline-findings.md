# Windows 4.1.15.13 send analysis (disk only)

This artifact records static findings, not a successful invocation or delivery.
No process was opened, hooked, or sent a message by the analysis scripts.

Reference: signed Weixin.dll 4.1.10.27, SHA256
`f487e4f56930456a25fb0d7b058c77e2dcd364e268d49bdfff4dc0e3be26ba36`.
Target: signed Weixin.dll 4.1.15.13, SHA256
`10f8e995453e2da46d4f2b5080cd6da1f13cc5147746adc119ceae38cb039de5`.
All addresses below are RVAs relative to the matching module base.

| Reference role | 4.1.10.27 | 4.1.15.13 candidate | Static evidence |
| --- | --- | --- | --- |
| options constructor | DF40 | F910 | Complete control-flow correspondence; same output fields |
| queued send entry | 1677A30 | 19D0BC0 | Same 777-byte function shape; exact opaque task RTTI |
| param1 vtable | 84EC9C8 | 9112308 | Unique opaque type identity and validated COL/self links |
| sequence counter | A0CE0B0 | B0BC2B0 | Read/increment/write in corresponding D5E0/F000 wrappers |
| legacy callback1 vtable | 8595F58 | unresolved | Type identity changed; do not reuse old address |
| legacy callback2 vtable | 8595E98 | unresolved | Type identity changed; do not reuse old address |
| legacy callback3 vtable | 8595DD8 | unresolved | Type identity changed; do not reuse old address |
| text constructor | 6B2C30 | 766680 | Full 195-byte control flow; explicit shifted text fields |
| text shared control vtable | 8279358 | 8E534F8 | Unique complete opaque type identity and COL/self links |

The inner text vtable maps from 82793E8 to 8E53588. The constructor initializes
the native string at inner+758 and the at-list string at inner+778; the old
values were +708 and +728. This is an actual ABI change, not just new RVAs.
The separate text-layout evidence directory records the native shared-pointer
factory 6F4C70 and further field setter evidence.

## Empty callbacks have a native construction and guarded send path

The three old application lambdas are unnecessary for the bounded case that
uses empty callbacks. This is supported by the following instruction evidence:

- Function 6BE4860 constructs three empty 64-byte function blocks: at 6BE4927,
  6BE492F, and 6BE4937 it writes zero to each block's +38 pointer. It clears a
  16-byte shared-pointer pair, passes the sixth argument as zero, and calls
  F910 at 6BE496D. This is a native call site, not a synthetic assumption.
- F910 accepts `(out, block1, block2, block3, sharedPair, sequenceId)` using the
  Windows x64 ABI. It allocates its own 24-byte shared cancellation flag and
  initializes a 0xE8 output object. An empty input block skips virtual copying.
  Callback pointers in the output are +48, +88, +C8; weak-pair fields are +D8
  and +E0, and the sequence value is +D0.
- Send entry 19D0BC0 copies options through 5F2B0. This copy function tests all
  three callback pointers before invoking their virtual copy functions.
- Its queued task vtable 91123E8 invokes 19D1380. That function calls the send
  service at 17A1DB0, creates completion 19D1700, and copies the options again.
- Success handler 57690 tests +48 at 576EA/576EE/576F1. Completion handler
  5F930 tests +C8 at 5F98E/5F995/5F998. Error handler 1CF940 tests +88 at
  1CF9A2/1CF9A9/1CF9AC. Empty callbacks enter fallbacks which also test +E0;
  an empty pair returns without calling an empty function.
- Completion cleanup 19D18B0 similarly tests callback pointers before cleanup.
  **It also destroys fields after the 0xE8 options object**, so it is not a
  standalone destructor for a bare options allocation.

F000 is **not** an options factory: it is the corresponding complex scheduling
wrapper, with service references and additional arguments. Do not invoke it as
a constructor. A successful return from queued send is not delivery proof.

For a one-shot harness, native references must remain alive through asynchronous
completion. Do not invent a destructor or free client-owned objects with a
different allocator. Runtime thread affinity, initialized services, and actual
filehelper delivery still require the parent task's bounded live validation.

## Protocol observation candidates

The exact newsendmsg path is referenced by current functions 39EDFD0 and
39F28C0. The latter copies a SendMsgRequestNew with 2E83DD0. Corresponding
protobuf boundaries are outer-copy 2E83DD0 (old 2C6D230), repeated-copy 2E89940
(old 2C72DE0), and element-copy 2E82C00 (old 2C6C060). MicroMsgRequestNew
vtable is 93D4E38; its flags +34 and target/text/source offsets +8/+10/+20
remain visible in the native clear/copy implementations. These lower protocol
objects must not be substituted for the higher-level text message object.

`analyze_windows_hook_send.py` confirms anchor references by disassembling from
the enclosing .pdata function start, including SIMD literal copies that a
LEA-only search misses. `analyze_windows_hook_mapping.py` reproduces function
comparisons and exact opaque RTTI/COL mappings. JSON outputs and bounded
function listings are saved alongside this note; they contain binary metadata
only and no account or chat data.
