# Third-party reuse notes

## wechat.zip.temp (user attachment)

- SHA-256 (rechecked 2026-09-14): `51664D8F5A1D8DDF45D41DB66227280E89CA2C95AEB4DFB862B4CABD72D2E479`
- Size: 8,804,523 bytes, matches `evidence/archive-audit.md`
- The archive has **no project LICENSE** for its own Python sources. This PoC **reimplements** UTF-8/Zstandard decoding, `Msg_<md5>` table candidates, multi-shard discovery, SQLCipher-4 page decrypt (all pages must succeed), and a gated read-only CipherConfig scan. It does not copy attachment files, `.venv`, databases, or run `main.py`.
- Page decryption is implemented only behind G-OPEN and writes to a gitignored run directory that is deleted after the query.
- `@openim` exclusion, first-shard `break`, and `storages[0]` account selection are regression tests, not behaviour.

## Chat-Lab

- Reference commit `67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2` is documented in round 2. This repository does not vendor or modify that checkout.
- Tracked Chat-Lab files did not declare a project license. This PoC implements the spec interfaces (`read_new_messages`, `decide_reply`, `send_text`) instead of copying Chat-Lab modules.
- Optional HTTP model client uses a JSON chat-completions POST with no tools.

## Dependencies

- `zstandard` is declared in `pyproject.toml` and locked by `uv lock`.
- `sqlcipher3` is an extra, not installed by default, and live SQLCipher open is still blocked without an authorized key reference.
