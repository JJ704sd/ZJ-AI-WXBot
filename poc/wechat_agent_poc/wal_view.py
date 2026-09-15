"""Read-only SQLite WAL merge of the last valid committed transaction.

Does not checkpoint, delete, or write the source WAL. Invalid or uncommitted
tail frames are dropped. If the header or generation cannot be proven, halt.
"""

from __future__ import annotations

import struct
import sys
from dataclasses import dataclass, field
from pathlib import Path

from wechat_agent_poc.models import Halt, HaltError

WAL_MAGIC_BE = 0x377F0682
WAL_MAGIC_LE = 0x377F0683
WAL_VERSION = 3007000
WAL_HEADER_SIZE = 32
FRAME_HEADER_SIZE = 24


@dataclass(frozen=True)
class WalFrame:
    page_no: int
    db_size_pages: int
    data: bytes
    commit: bool


@dataclass
class WalParseResult:
    page_size: int
    checkpoint_seq: int
    salt1: int
    salt2: int
    frames: list[WalFrame] = field(default_factory=list)
    committed_frames: list[WalFrame] = field(default_factory=list)
    truncated_uncommitted: int = 0
    truncated_invalid: int = 0
    previous_generation_frames: int = 0
    last_commit_page_count: int | None = None
    native_le: bool = True


def parse_wal(data: bytes, *, expected_page_size: int | None = None) -> WalParseResult:
    if len(data) < WAL_HEADER_SIZE:
        raise HaltError(Halt("READ_FAILURE", "WAL is shorter than a header", {"phase": "WAL"}))
    magic = struct.unpack(">I", data[0:4])[0]
    if magic == WAL_MAGIC_BE:
        native_le = sys.byteorder == "little"
    elif magic == WAL_MAGIC_LE:
        native_le = sys.byteorder != "little"
    else:
        raise HaltError(
            Halt(
                "READ_FAILURE",
                "WAL magic is not a known SQLite WAL header; refusing to guess the layout",
                {"phase": "WAL", "magic": hex(magic)},
            )
        )
    version = struct.unpack(">I", data[4:8])[0]
    if version != WAL_VERSION:
        raise HaltError(Halt("READ_FAILURE", "unsupported WAL file format version", {"phase": "WAL", "version": version}))
    page_size = struct.unpack(">I", data[8:12])[0]
    if page_size == 1:
        page_size = 65536
    if page_size < 512 or page_size > 65536 or (page_size & (page_size - 1)) != 0:
        raise HaltError(Halt("READ_FAILURE", "WAL page size is not a valid SQLite page size", {"phase": "WAL", "page_size": page_size}))
    if expected_page_size is not None and page_size != expected_page_size:
        raise HaltError(
            Halt(
                "READ_FAILURE",
                "WAL page size does not match the database page size",
                {"phase": "WAL", "wal_page_size": page_size, "db_page_size": expected_page_size},
            )
        )
    checkpoint_seq = struct.unpack(">I", data[12:16])[0]
    salt1 = struct.unpack(">I", data[16:20])[0]
    salt2 = struct.unpack(">I", data[20:24])[0]
    hdr_s1, hdr_s2 = _checksum_pair(data[24:32], native_le=False)
    run_s1, run_s2 = _checksum_bytes(data[0:24], 0, 0, native_le=native_le)
    if (run_s1, run_s2) != (hdr_s1, hdr_s2):
        raise HaltError(Halt("READ_FAILURE", "WAL header checksum mismatch", {"phase": "WAL"}))
    result = WalParseResult(
        page_size=page_size,
        checkpoint_seq=checkpoint_seq,
        salt1=salt1,
        salt2=salt2,
        native_le=native_le,
    )
    offset = WAL_HEADER_SIZE
    frame_size = FRAME_HEADER_SIZE + page_size
    valid_prefix: list[WalFrame] = []
    seen_current = False
    while offset + frame_size <= len(data):
        header = data[offset : offset + FRAME_HEADER_SIZE]
        page_no = struct.unpack(">I", header[0:4])[0]
        db_size = struct.unpack(">I", header[4:8])[0]
        frame_salt1 = struct.unpack(">I", header[8:12])[0]
        frame_salt2 = struct.unpack(">I", header[12:16])[0]
        stored_s1, stored_s2 = _checksum_pair(header[16:24], native_le=False)
        payload = data[offset + FRAME_HEADER_SIZE : offset + frame_size]
        if frame_salt1 != salt1 or frame_salt2 != salt2:
            if seen_current:
                result.truncated_invalid += 1
                break
            result.previous_generation_frames += 1
            offset += frame_size
            continue
        seen_current = True
        if page_no == 0:
            result.truncated_invalid += 1
            break
        run_s1, run_s2 = _checksum_bytes(header[0:8] + payload, run_s1, run_s2, native_le=native_le)
        if (run_s1, run_s2) != (stored_s1, stored_s2):
            result.truncated_invalid += 1
            break
        frame = WalFrame(page_no=page_no, db_size_pages=db_size, data=payload, commit=db_size != 0)
        valid_prefix.append(frame)
        result.frames.append(frame)
        offset += frame_size
    leftover = len(data) - offset
    if leftover != 0 and leftover < frame_size:
        result.truncated_uncommitted += 1
    last_commit_index = -1
    for index, frame in enumerate(valid_prefix):
        if frame.commit:
            last_commit_index = index
    if last_commit_index >= 0:
        result.committed_frames = valid_prefix[: last_commit_index + 1]
        result.last_commit_page_count = valid_prefix[last_commit_index].db_size_pages
        result.truncated_uncommitted += len(valid_prefix) - last_commit_index - 1
    elif valid_prefix:
        result.truncated_uncommitted += len(valid_prefix)
        raise HaltError(
            Halt(
                "READ_FAILURE",
                "WAL has frames but no proven commit boundary",
                {"phase": "WAL", "frame_count": len(valid_prefix)},
            )
        )
    return result


def merge_wal_into_db(db: bytearray | bytes, wal: bytes, *, expected_page_size: int | None = None) -> tuple[bytearray, WalParseResult]:
    parsed = parse_wal(wal, expected_page_size=expected_page_size)
    out = bytearray(db)
    page_size = parsed.page_size
    for frame in parsed.committed_frames:
        start = (frame.page_no - 1) * page_size
        end = start + page_size
        if end > len(out):
            out.extend(b"\x00" * (end - len(out)))
        out[start:end] = frame.data
    if parsed.last_commit_page_count:
        size = parsed.last_commit_page_count * page_size
        if len(out) < size:
            out.extend(b"\x00" * (size - len(out)))
        else:
            del out[size:]
    return out, parsed


def overlay_sqlite_page(db: bytearray, page_no: int, sqlite_page: bytes, page_size: int) -> None:
    if len(sqlite_page) != page_size:
        raise HaltError(
            Halt(
                "READ_FAILURE",
                "overlay page length does not match page size",
                {"phase": "WAL", "page_no": page_no, "got": len(sqlite_page), "page_size": page_size},
            )
        )
    start = (page_no - 1) * page_size
    end = start + page_size
    if end > len(db):
        db.extend(b"\x00" * (end - len(db)))
    db[start:end] = sqlite_page


def write_merged_db(path: Path, data: bytes) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(data)


def _checksum_pair(raw: bytes, *, native_le: bool) -> tuple[int, int]:
    order = "little" if native_le else "big"
    return int.from_bytes(raw[0:4], order), int.from_bytes(raw[4:8], order)


def _checksum_bytes(data: bytes, s1: int, s2: int, *, native_le: bool) -> tuple[int, int]:
    if len(data) % 8 != 0:
        raise HaltError(Halt("READ_FAILURE", "WAL checksum span is not a multiple of 8", {"phase": "WAL"}))
    mask = 0xFFFFFFFF
    order = "little" if native_le else "big"
    for index in range(0, len(data), 8):
        x = int.from_bytes(data[index : index + 4], order)
        y = int.from_bytes(data[index + 4 : index + 8], order)
        s1 = (s1 + x + s2) & mask
        s2 = (s2 + y + s1) & mask
    return s1, s2
