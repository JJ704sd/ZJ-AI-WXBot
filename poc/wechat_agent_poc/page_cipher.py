"""SQLCipher-4-layout page decryptor for WeChat 4.x local databases.

Ported from attachment wx_csv/db_decrypt.py after review, with stricter
integrity: every 4096-byte page must decrypt. WAL frames are merged separately
as a read-only view and never written back to the source.
Does not walk sibling accounts or log key material.
"""

from __future__ import annotations

import hashlib
import hmac
from pathlib import Path

from wechat_agent_poc.live_guard import is_live_wechat_root
from wechat_agent_poc.models import Halt, HaltError

SQLITE_HEADER = b"SQLite format 3\x00"
PAGE_SIZE = 4096
IV_SIZE = 16
HMAC_SIZE = 64


def _reserve_size() -> int:
    reserve = IV_SIZE + HMAC_SIZE
    if reserve % 16 != 0:
        reserve = ((reserve // 16) + 1) * 16
    return reserve


def derive_mac_key(derived_key: bytes, salt: bytes) -> bytes:
    try:
        from cryptography.hazmat.primitives import hashes
        from cryptography.hazmat.primitives.kdf.pbkdf2 import PBKDF2HMAC
    except ImportError as exc:
        raise HaltError(
            Halt(
                "READ_FAILURE",
                "cryptography is not installed in the project environment",
                {"phase": "G-OPEN"},
            )
        ) from exc

    mac_salt = bytes(byte ^ 0x3A for byte in salt)
    return PBKDF2HMAC(algorithm=hashes.SHA512(), length=32, salt=mac_salt, iterations=2).derive(derived_key)


def decrypt_page(page: bytes, page_num: int, derived_key: bytes, mac_key: bytes, *, first: bool) -> bytes:
    from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes

    reserve = _reserve_size()
    offset = 16 if first else 0
    hmac_start = PAGE_SIZE - reserve + IV_SIZE
    stored_hmac = page[hmac_start : hmac_start + HMAC_SIZE]
    hmac_data = page[offset : PAGE_SIZE - reserve + IV_SIZE]
    mac = hmac.new(mac_key, digestmod=hashlib.sha512)
    mac.update(hmac_data)
    mac.update(page_num.to_bytes(4, "little"))
    if stored_hmac != mac.digest():
        raise HaltError(Halt("READ_FAILURE", "SQLCipher page HMAC mismatch", {"page_num": page_num}))
    iv = page[PAGE_SIZE - reserve : PAGE_SIZE - reserve + IV_SIZE]
    encrypted = page[offset : PAGE_SIZE - reserve]
    decryptor = Cipher(algorithms.AES(derived_key), modes.CBC(iv)).decryptor()
    decrypted = decryptor.update(encrypted) + decryptor.finalize()
    return decrypted + page[PAGE_SIZE - reserve :]


def file_salt_hex(path: Path) -> str:
    with path.open("rb") as handle:
        return handle.read(16).hex()


def decrypt_database(src: Path, dest: Path, derived_keys: list[bytes], *, allow_live: bool = False) -> dict[str, object]:
    if is_live_wechat_root(src) and not allow_live:
        raise HaltError(
            Halt(
                "READ_FAILURE",
                "refusing to decrypt a live WeChat path without G-OPEN",
                {"phase": "G-OPEN"},
            )
        )
    encrypted = src.read_bytes()
    plaintext, info, _key, _salt = decrypt_bytes(encrypted, derived_keys, source_name=src.name)
    dest.parent.mkdir(parents=True, exist_ok=True)
    dest.write_bytes(bytes(plaintext))
    return info


def decrypt_bytes(
    encrypted: bytes,
    derived_keys: list[bytes],
    *,
    source_name: str = "database",
) -> tuple[bytearray, dict[str, object], bytes | None, bytes]:
    if len(encrypted) < PAGE_SIZE:
        raise HaltError(Halt("READ_FAILURE", f"{source_name} is smaller than one SQLCipher page"))
    if encrypted.startswith(SQLITE_HEADER):
        return bytearray(encrypted), {"pages": 0, "already_plaintext": True, "adapter": "plaintext_copy"}, None, encrypted[:16]
    if len(encrypted) % PAGE_SIZE != 0:
        raise HaltError(
            Halt(
                "READ_FAILURE",
                f"{source_name} size is not a multiple of {PAGE_SIZE}; refusing partial decrypt",
                {"size": len(encrypted)},
            )
        )
    salt = encrypted[:16]
    last_error: HaltError | None = None
    for derived_key in derived_keys:
        try:
            mac_key = derive_mac_key(derived_key, salt)
            pages = len(encrypted) // PAGE_SIZE
            out = bytearray(SQLITE_HEADER)
            for index in range(pages):
                page = encrypted[index * PAGE_SIZE : (index + 1) * PAGE_SIZE]
                out.extend(decrypt_page(page, index + 1, derived_key, mac_key, first=index == 0))
            return (
                out,
                {
                    "pages": pages,
                    "already_plaintext": False,
                    "adapter": "page_cipher_sqlcipher4_layout",
                    "page_size": PAGE_SIZE,
                },
                derived_key,
                salt,
            )
        except HaltError as exc:
            last_error = exc
            continue
    if last_error is not None:
        raise HaltError(
            Halt(
                "READ_FAILURE",
                "no supplied key material decrypted every page",
                {"file": source_name, "cause": last_error.halt.message},
            )
        )
    raise HaltError(Halt("READ_FAILURE", "no key material was supplied"))


def encrypt_page_for_tests(plain_page: bytes, page_num: int, derived_key: bytes, salt: bytes, *, first: bool) -> bytes:
    """Test helper: inverse of decrypt_page. Not used on live data."""
    from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes

    reserve = _reserve_size()
    offset = 16 if first else 0
    iv = os_urandom(16)
    body = plain_page[offset : PAGE_SIZE - reserve]
    encryptor = Cipher(algorithms.AES(derived_key), modes.CBC(iv)).encryptor()
    encrypted_body = encryptor.update(body) + encryptor.finalize()
    page = bytearray(PAGE_SIZE)
    if first:
        page[0:16] = salt
    page[offset : PAGE_SIZE - reserve] = encrypted_body
    page[PAGE_SIZE - reserve : PAGE_SIZE - reserve + IV_SIZE] = iv
    mac_key = derive_mac_key(derived_key, salt)
    hmac_data = bytes(page[offset : PAGE_SIZE - reserve + IV_SIZE])
    digest = hmac.new(mac_key, digestmod=hashlib.sha512)
    digest.update(hmac_data)
    digest.update(page_num.to_bytes(4, "little"))
    hmac_start = PAGE_SIZE - reserve + IV_SIZE
    page[hmac_start : hmac_start + HMAC_SIZE] = digest.digest()
    return bytes(page)


def sqlite_page_from_encrypted(page: bytes, page_num: int, derived_key: bytes, mac_key: bytes) -> bytes:
    first = page_num == 1
    decrypted = decrypt_page(page, page_num, derived_key, mac_key, first=first)
    if first:
        return SQLITE_HEADER + decrypted
    return decrypted


def decrypt_wal_frames(wal_bytes: bytes, derived_key: bytes, salt: bytes, *, page_size: int = PAGE_SIZE) -> tuple[list[tuple[int, bytes, int]], object]:
    from wechat_agent_poc.wal_view import parse_wal

    parsed = parse_wal(wal_bytes, expected_page_size=page_size)
    mac_key = derive_mac_key(derived_key, salt)
    pages: list[tuple[int, bytes, int]] = []
    for frame in parsed.committed_frames:
        if len(frame.data) != page_size:
            raise HaltError(
                Halt(
                    "READ_FAILURE",
                    "encrypted WAL frame length does not match page size",
                    {"phase": "WAL", "page_no": frame.page_no},
                )
            )
        sqlite_page = sqlite_page_from_encrypted(frame.data, frame.page_no, derived_key, mac_key)
        pages.append((frame.page_no, sqlite_page, frame.db_size_pages))
    return pages, parsed


def apply_encrypted_wal(plaintext_db: bytearray, wal_bytes: bytes, derived_key: bytes, salt: bytes) -> dict[str, object]:
    from wechat_agent_poc.wal_view import overlay_sqlite_page

    pages, parsed = decrypt_wal_frames(wal_bytes, derived_key, salt, page_size=PAGE_SIZE)
    last_size = parsed.last_commit_page_count
    for page_no, sqlite_page, db_size in pages:
        overlay_sqlite_page(plaintext_db, page_no, sqlite_page, PAGE_SIZE)
        if db_size:
            last_size = db_size
    if last_size:
        size = last_size * PAGE_SIZE
        if len(plaintext_db) < size:
            plaintext_db.extend(b"\x00" * (size - len(plaintext_db)))
        else:
            del plaintext_db[size:]
    return {
        "committed_frames": len(parsed.committed_frames),
        "truncated_uncommitted": parsed.truncated_uncommitted,
        "truncated_invalid": parsed.truncated_invalid,
        "previous_generation_frames": parsed.previous_generation_frames,
        "last_commit_page_count": parsed.last_commit_page_count,
        "wal_checksum_ok": True,
    }


def os_urandom(n: int) -> bytes:
    return __import__("os").urandom(n)
