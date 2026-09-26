# Text message object layout: disk evidence

This records static evidence for `Weixin.dll` 4.1.15.13, SHA-256
`10f8e995453e2da46d4f2b5080cd6da1f13cc5147746adc119ceae38cb039de5`.
These listings alone do not establish that a real message was sent.

The shared-pointer factory at RVA **6F4C70** corresponds to old **64A950**.
It accepts one 16-byte output pair and returns its address. It calls the native
allocator for **0x7A8 bytes**, initializes control block references to 1/1,
zeros **0x798 bytes** starting at control+0x10, and invokes text constructor
766680. It then builds the object's weak self-reference, leaving strong=1 and
weak=2. Its output pair is `(inner, control)` with inner=control+0x10. See
`new-006f4c70.asm` and `old-0064a950.asm`.

| Field relative to inner | Current offset | Evidence |
| --- | --- | --- |
| Inner vtable | 0 | Factory/constructor, expected module+8E53588 |
| Weak self pointer/control | +8 / +10 | 6F4C70 builds enable_shared_from_this |
| Receiver std::string | +B0 | Native copy/setters in 6F47A0 and 58F67B0 |
| Message type, DWORD | +118 | Explicit value 1 in 58F67B0 and 5C9CFA0 |
| Message length, QWORD | +1C8 | Explicit setters in 3995970 and 5C9CFA0 |
| Generated UUID string | +6F8 | Base constructor 766780, called by 766680 |
| Text std::string | +758 | Constructor and independent factory callers |
| At-list std::string | +778 | Constructor 766680 |

The low-level factory obtains the correct allocator, vtable, UUID, and reference
counts. The reference project's manual `HeapAlloc_mb<uint64_t>(count)` actually
allocates `count * 8`, sets artificial strong/weak counts, and does not free the
text-send object. Its long-string helper reports a rounded capacity while only
allocating length+1. Those allocation techniques were not copied into the new
bounded script.

For the initial one-message check, both `filehelper` (10 ASCII bytes) and
`WB-HOOK-0926` (12 ASCII bytes) fit the native string's 15-byte inline capacity.
Only an initially empty inline string is written. This avoids heap-string
allocation and the unresolved byte-count versus UTF-16-count distinction for
non-ASCII message length. General or long text is deliberately outside this
particular ABI probe.

Send entry 19D0BC0 copies the input vector into native allocations and increments
each shared control block's strong count. It copies options with 5F2B0, which
increments the native token reference. It constructs and queues its own task
before returning. The caller's temporary vector/options wrappers are not freed
by that entry. The original native payload/token references are intentionally
retained for the one-shot PoC; no unverified destructor is called.

The old source calls from HTTP and automatic-reply worker threads; current
thread compatibility still requires a real bounded test. Empty callbacks mean
the script receives no server ACK. Its successful return means only
`submitted_unconfirmed`. Database observations must be reported separately.

Implementation: `execution/windows/native_send_once.js`. Its accompanying five
synthetic tests validate RPC gates and one-attempt behavior only, without Frida
or a running WeChat process. The parent task records any later live evidence
separately; do not infer it from this static artifact.
