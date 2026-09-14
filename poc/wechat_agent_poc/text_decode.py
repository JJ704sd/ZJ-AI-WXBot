"""Restricted text decoding for WeChat message bytes.

Reimplemented from the documented attachment algorithm (UTF-8 / Zstandard),
with the silent-ignore behaviour removed. The original archive has no project
license, so this is not a source copy.
"""

from __future__ import annotations

from typing import Any

from wechat_agent_poc.clock import DecodeResult

ZSTD_MAGIC = b"\x28\xb5\x2f\xfd"


def decode_sqlite_text(value: Any, *, strict: bool = True) -> DecodeResult:
    if value is None:
        return DecodeResult("", "ok", "empty")
    if isinstance(value, memoryview):
        value = bytes(value)
    if isinstance(value, (bytes, bytearray)):
        raw = bytes(value)
        if raw.startswith(ZSTD_MAGIC):
            return _decode_zstd(raw)
        try:
            text = raw.decode("utf-8", errors="strict" if strict else "strict")
        except UnicodeDecodeError as exc:
            return DecodeResult(None, "decode_error", f"utf8:{exc.reason}")
        return DecodeResult(text, "ok", "utf8")
    text = str(value)
    return DecodeResult(text, "ok", "str")


def decode_message_text(message_value: Any, compress_value: Any = None) -> DecodeResult:
    if _looks_zstd(message_value):
        result = _decode_zstd(_as_bytes(message_value))
        if result.status != "ok":
            return result
        message_text = result
    else:
        message_text = decode_sqlite_text(message_value)
        if message_text.status != "ok":
            return message_text

    if compress_value is None:
        return message_text

    if isinstance(compress_value, str):
        if compress_value.strip():
            return DecodeResult(compress_value, "ok", "compress_str")
        return message_text

    if not _as_bytes(compress_value):
        return message_text

    raw = _as_bytes(compress_value)
    if raw.startswith(ZSTD_MAGIC) or _looks_zstd(compress_value):
        compressed = _decode_zstd(raw)
        if compressed.status != "ok":
            return compressed
        return compressed
    try:
        text = raw.decode("utf-8")
    except UnicodeDecodeError as exc:
        return DecodeResult(None, "decode_error", f"compress_utf8:{exc.reason}")
    return DecodeResult(text, "ok", "compress_utf8")


def _looks_zstd(value: Any) -> bool:
    try:
        raw = _as_bytes(value)
    except TypeError:
        return False
    return raw.startswith(ZSTD_MAGIC)


def _as_bytes(value: Any) -> bytes:
    if value is None:
        return b""
    if isinstance(value, memoryview):
        return bytes(value)
    if isinstance(value, (bytes, bytearray)):
        return bytes(value)
    raise TypeError("not bytes")


def _decode_zstd(raw: bytes) -> DecodeResult:
    try:
        import zstandard
    except ImportError:
        return DecodeResult(None, "missing_decoder", "zstandard_not_installed")
    try:
        text = zstandard.ZstdDecompressor().decompress(raw).decode("utf-8")
    except UnicodeDecodeError as exc:
        return DecodeResult(None, "decode_error", f"zstd_utf8:{exc.reason}")
    except Exception as exc:  # zstd.ZstdError and truncated frames
        return DecodeResult(None, "decode_error", f"zstd:{type(exc).__name__}")
    return DecodeResult(text, "ok", "zstd")
