from __future__ import annotations

import sqlite3
from pathlib import Path

import pytest

from wechat_agent_poc.models import HaltError
from wechat_agent_poc.snapshot import capture_consistent_snapshot
from wechat_agent_poc.wal_view import merge_wal_into_db, parse_wal


def _make_wal_db(path: Path) -> sqlite3.Connection:
    conn = sqlite3.connect(path)
    conn.execute("PRAGMA page_size=4096")
    conn.execute("PRAGMA journal_mode=WAL")
    conn.execute("CREATE TABLE t (id INTEGER PRIMARY KEY, v TEXT)")
    conn.execute("INSERT INTO t(v) VALUES ('main-only')")
    conn.commit()
    conn.execute("PRAGMA wal_checkpoint(TRUNCATE)")
    conn.execute("INSERT INTO t(v) VALUES ('wal-committed')")
    conn.commit()
    conn.execute("INSERT INTO t(v) VALUES ('second-commit')")
    conn.commit()
    return conn


def test_committed_wal_frame_is_visible_without_source_checkpoint(tmp_path: Path):
    src = tmp_path / "src.db"
    conn = _make_wal_db(src)
    wal = Path(str(src) + "-wal")
    assert wal.exists() and wal.stat().st_size > 32
    snap = capture_consistent_snapshot(src)
    merged, parsed = merge_wal_into_db(bytearray(snap.db.data), snap.wal.data)
    assert parsed.committed_frames
    dest = tmp_path / "merged.db"
    dest.write_bytes(bytes(merged))
    view = sqlite3.connect(dest)
    rows = [row[0] for row in view.execute("SELECT v FROM t ORDER BY id").fetchall()]
    view.close()
    conn.close()
    assert rows[0] == "main-only"
    assert "wal-committed" in rows
    assert "second-commit" in rows


def test_uncommitted_tail_is_excluded(tmp_path: Path):
    src = tmp_path / "src.db"
    conn = _make_wal_db(src)
    conn.execute("BEGIN")
    conn.execute("INSERT INTO t(v) VALUES ('uncommitted')")
    snap = capture_consistent_snapshot(src)
    merged, parsed = merge_wal_into_db(bytearray(snap.db.data), snap.wal.data)
    dest = tmp_path / "merged.db"
    dest.write_bytes(bytes(merged))
    view = sqlite3.connect(dest)
    rows = [row[0] for row in view.execute("SELECT v FROM t ORDER BY id").fetchall()]
    view.close()
    conn.rollback()
    conn.close()
    assert "uncommitted" not in rows
    assert "wal-committed" in rows
    assert parsed.truncated_uncommitted >= 0


def test_bad_frame_checksum_stops_before_corrupt_tail(tmp_path: Path):
    src = tmp_path / "src.db"
    conn = _make_wal_db(src)
    snap = capture_consistent_snapshot(src)
    conn.close()
    corrupt = bytearray(snap.wal.data)
    if len(corrupt) > 80:
        corrupt[-8] ^= 0xFF
    merged, parsed = merge_wal_into_db(bytearray(snap.db.data), bytes(corrupt))
    dest = tmp_path / "merged.db"
    dest.write_bytes(bytes(merged))
    view = sqlite3.connect(dest)
    rows = [row[0] for row in view.execute("SELECT v FROM t ORDER BY id").fetchall()]
    view.close()
    assert "wal-committed" in rows
    assert "second-commit" not in rows or parsed.truncated_invalid >= 1


def test_encrypted_wal_frame_decrypts_to_sqlite_page():
    pytest.importorskip("cryptography")
    from wechat_agent_poc.page_cipher import PAGE_SIZE, SQLITE_HEADER, encrypt_page_for_tests, sqlite_page_from_encrypted, derive_mac_key

    key = bytes.fromhex("11" * 32)
    salt = bytes.fromhex("22" * 16)
    plain = bytearray(PAGE_SIZE)
    plain[0:16] = SQLITE_HEADER
    plain[16:24] = b"wal-page"
    enc = encrypt_page_for_tests(bytes(plain), 1, key, salt, first=True)
    mac_key = derive_mac_key(key, salt)
    out = sqlite_page_from_encrypted(enc, 1, key, mac_key)
    assert out.startswith(SQLITE_HEADER)
    assert b"wal-page" in out


def test_unknown_wal_magic_halts():
    with pytest.raises(HaltError) as caught:
        parse_wal(b"\x00" * 64)
    assert caught.value.halt.details.get("phase") == "WAL"


def test_previous_generation_wal_frames_are_skipped(tmp_path: Path):
    src = tmp_path / "src.db"
    conn = _make_wal_db(src)
    snap = capture_consistent_snapshot(src)
    conn.close()
    wal = bytearray(snap.wal.data)
    page_size = 4096
    frame_size = 24 + page_size
    offset = 32
    while offset + frame_size <= len(wal):
        wal[offset + 8] ^= 0xFF
        offset += frame_size
    merged, parsed = merge_wal_into_db(bytearray(snap.db.data), bytes(wal))
    dest = tmp_path / "merged.db"
    dest.write_bytes(bytes(merged))
    view = sqlite3.connect(dest)
    rows = [row[0] for row in view.execute("SELECT v FROM t ORDER BY id").fetchall()]
    view.close()
    assert parsed.previous_generation_frames >= 1
    assert parsed.committed_frames == []
    assert "main-only" in rows


def test_snapshot_retries_when_source_changes(tmp_path: Path, monkeypatch):
    src = tmp_path / "src.db"
    src.write_bytes(b"SQLite format 3\x00" + b"\x00" * 100)
    calls = {"n": 0}
    real_read = Path.read_bytes

    def flaky(self):
        data = real_read(self)
        if self.resolve() == src.resolve() and calls["n"] == 0:
            calls["n"] = 1
            real_write = Path.write_bytes
            real_write(self, data + b"changed")
        return data

    monkeypatch.setattr(Path, "read_bytes", flaky)
    with pytest.raises(HaltError) as caught:
        capture_consistent_snapshot(src, attempts=1, sleep_s=0.0)
    assert caught.value.halt.details.get("phase") == "SNAPSHOT"
