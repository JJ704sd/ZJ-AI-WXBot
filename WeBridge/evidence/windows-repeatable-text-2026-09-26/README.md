# Repeatable text: native allocation and reference ownership

Disk-only inspection of `Weixin.dll` 4.1.15.13, SHA-256
`10f8e995453e2da46d4f2b5080cd6da1f13cc5147746adc119ceae38cb039de5`.
These static findings and the synthetic tests do not prove a live send.

Implementation: `execution/windows/native_send_text.js`. The previous fixed
one-message script is preserved. The repeatable bridge accepts the currently
selected conversation's internal ID (`[A-Za-z0-9_.@-]{1,256}`), including friend
and group conversations. The workbench server verifies the request target exists
in the current account's database snapshot and is included for reading and in
the bridge's supported scope, then freezes the target in a server-side draft.
Confirmation must match that draft; it does not depend on the shared browsing
selection of another tab. The authenticated bridge checks the exact
account/process binding. Plain Unicode
text is limited to 2,000 JavaScript UTF-16 code units and 8,000 UTF-8 bytes,
including newlines and supplementary characters. NUL and unpaired surrogate
input are rejected. Live acceptance remains limited to user-authorized
`filehelper` messages; real friend/group sending has not been accepted.

## UTF-8 string ownership

The real content setter in `58F67B0` calls `3E150` when the incoming byte count
exceeds the destination string capacity. The same helper is called for the
receiver string in `6F47A0`. Its fully inspected ABI is:

```
std::string* reallocate_assign(std::string* destination, uint64_t byte_count,
                              uint64_t unused, const char* utf8_source)
```

`3E150` rounds capacity, invokes the module's native allocator `74AB89C`, copies
the supplied bytes, writes the terminating NUL and updates length/capacity.
For capacities of 4,095 bytes or more, it uses the required aligned allocation
with its original allocation pointer stored before the aligned address. The
old heap buffer, if any, is released through `74AB8E0`. The new sender uses this
native helper for heap strings and writes only initially empty inline strings
directly. A Frida allocation is only an input byte buffer; it is never installed
as a native string's heap pointer.

The message-length field at inner+`1C8` holds **UTF-8 byte count** for this text
path. The existing listing for `5C9CFA0` calls `279B0`, then reads the returned
byte-array length at +4. `279B0` delegates to `2C4330`; its complete listing
shows UTF-16 input converted into 1-, 2-, 3- and 4-byte UTF-8 sequences.
Consequently the new implementation stores encoded byte length in both the
native string length and the message-length field. JavaScript `text.length`
remains only the user-input size limit/reporting value.

## Shared references after submit

`6F4C70` returns a native-owned `(inner, control)` pair, with strong count 1 and
weak count 2. The options constructor returns its own native cancellation-token
pair, with strong count 1 and weak count 1.

The previously inspected `19D0BC0` copies the vector into native storage and
increments payload strong references; its options copy through `5F2B0`
increments the cancellation-token reference. The sender therefore releases
exactly its original two references after the synchronous submit call returns.
It never releases the queued task's references.

The native helper at `53120` has one argument: the control-block pointer. Its
entire 51-byte function is recorded in `00053120.asm`: atomically decrement
strong at +8; at zero invoke control vtable slot 0 (destroy the inner object);
atomically decrement weak at +12; at zero invoke slot +8 (delete the control).
The script calls this helper separately for its payload control and token
control. It then drops its Frida wrapper roots, which the send entry copied.
This avoids accumulating a retained native payload for every normal send.

If native construction, submit, or cleanup raises an exception, the session
stops further construction and retains its uncertain inputs. A request marked
attempted is never resubmitted. Host persistence is still required across
process restarts; the native request map only prevents in-session duplicates.

## Native message identity

The factory calls `57FE90` / `580020` to generate a standard 36-character GUID.
The formatting literal at RVA `8E23CD8` is `%08x-%04x-%04x-%04x-%012llx`.
The base constructor copies it to the string at inner+`6F8`. The script returns
that string unchanged as `clientMessageId` from construct and submit.
It is **not a decimal server ID** and does not prove server acceptance. The
current database schema does not expose this GUID, so database observation
must use the host's independently documented correlation method.

## Bounded validation

All six entry prefixes were compared with the current DLL on disk. The new
entries are checked again by the script before construction and submit:

| Name | RVA | First 32 bytes |
| --- | --- | --- |
| stringAssign | 3E150 | `4157415641545657534883ec284885d20f88e50000004c89cb4889d74889ce4c` |
| releaseShared | 53120 | `564883ec204885c97423f0ff4908751d488b014889ceff10f0ff4e0c750f488b` |

`node execution/windows/native_send_text.test.cjs` passes six core synthetic
checks: configure does not construct/send; Chinese/newline/emoji assignment
and byte length; two independent requests with consumed-request suppression;
2,000 Chinese characters taking the native heap-string path; and an unknown
native outcome stopping later construction; and a long group receiver using the
native heap-string path with target changes rejected before submit. The mock also requires native
ownership of heap strings and verifies that cleanup releases only the caller's
reference while the simulated queued task owns another one.

No test in this file attaches to WeChat. Actual acceptance requires the parent
task's separately recorded live run, database observation and process-health
check. The host keeps the existing resident Frida lifecycle workaround.
