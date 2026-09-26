#!/usr/bin/env python3
"""Forensic probe for the two authorized test messages, not a live sync engine.

Run inside the test container beside db_probe.py. Never modifies source files.
This build's frame checksums differ from standard SQLite verification. The
temporary reconstruction therefore remains diagnostic even when SQLCipher
integrity_check passes; it is NOT a production-consistent backup guarantee.
"""
import ctypes
import ctypes.util
import json
from pathlib import Path
import struct
import tempfile

from db_probe import context, query, TABLE


def checksum(data, byte_order, state=(0, 0)):
    a, b = state
    words = struct.unpack(byte_order + str(len(data) // 4) + 'I', data)
    for i in range(0, len(words), 2):
        a = (a + words[i] + b) & 0xffffffff
        b = (b + words[i + 1] + a) & 0xffffffff
    return a, b


def decode(hex_value):
    value = bytes.fromhex(hex_value)
    if value.startswith(bytes.fromhex('28b52ffd')):
        lib = ctypes.CDLL(ctypes.util.find_library('zstd'))
        lib.ZSTD_getFrameContentSize.argtypes = [ctypes.c_void_p, ctypes.c_size_t]
        lib.ZSTD_getFrameContentSize.restype = ctypes.c_ulonglong
        lib.ZSTD_decompress.argtypes = [ctypes.c_void_p, ctypes.c_size_t, ctypes.c_void_p, ctypes.c_size_t]
        lib.ZSTD_decompress.restype = ctypes.c_size_t
        size = lib.ZSTD_getFrameContentSize(value, len(value))
        if size > 1024 * 1024:
            raise ValueError('Unsupported or excessive Zstandard frame size')
        output = ctypes.create_string_buffer(size)
        count = lib.ZSTD_decompress(output, size, value, len(value))
        if count > size:
            raise ValueError('Zstandard decompression failed')
        value = output.raw[:count]
    return value.decode('utf-8')


def main():
    root, keys = context()
    source = root / 'message/message_0.db'
    wal_path = Path(str(source) + '-wal')
    before = (source.stat().st_mtime_ns, wal_path.stat().st_mtime_ns)
    db, wal = source.read_bytes(), wal_path.read_bytes()
    if before != (source.stat().st_mtime_ns, wal_path.stat().st_mtime_ns) or wal != wal_path.read_bytes():
        raise RuntimeError('Source changed during capture; discard this attempt')
    header = struct.unpack('>8I', wal[:32])
    if header[0] not in (0x377f0682, 0x377f0683) or header[2] != 4096:
        raise ValueError('Unsupported WAL header')
    order = '<' if header[0] == 0x377f0682 else '>'
    if checksum(wal[:24], order) != header[6:8]:
        raise ValueError('Invalid WAL header checksum')
    page_size = header[2]
    frames, last_commit, commit_size = [], 0, 0
    state, checksum_matches = header[6:8], []
    for offset in range(32, len(wal) - page_size - 23, page_size + 24):
        page, size, salt_a, salt_b, sum_a, sum_b = struct.unpack('>6I', wal[offset:offset+24])
        if (salt_a, salt_b) != header[4:6]:
            break
        if not 0 < page <= 100000 or size > 100000:
            raise ValueError('WAL page bounds exceeded')
        data = wal[offset+24:offset+24+page_size]
        state = checksum(wal[offset:offset+8] + data, order, state)
        checksum_matches.append(state == (sum_a, sum_b))
        frames.append((page, data))
        if size:
            last_commit, commit_size = len(frames), size
    if not last_commit:
        raise ValueError('No commit boundary found')
    with tempfile.TemporaryDirectory(prefix='wechat-lab-forensic-') as folder:
        snapshot = Path(folder) / 'snapshot.db'
        snapshot.write_bytes(db)
        with snapshot.open('r+b') as output:
            for page, data in frames[:last_commit]:
                output.seek((page - 1) * page_size)
                output.write(data)
            output.truncate(commit_size * page_size)
        integrity = query(snapshot, keys[source.name], 'PRAGMA integrity_check;', immutable=True)
        if integrity != [{'integrity_check': 'ok'}]:
            raise ValueError('Diagnostic reconstruction failed integrity check')
        rows = query(snapshot, keys[source.name], f'SELECT local_id, server_id, hex(message_content) AS content_hex, hex(source) AS source_hex FROM "{TABLE}" ORDER BY local_id DESC LIMIT 20;', immutable=True)
        tests = []
        for row in rows:
            content = decode(row.pop('content_hex'))
            source_xml = decode(row.pop('source_hex'))
            if '[接入测试]' in content:
                tests.append({**row, 'content': content, 'source': source_xml})
        print(json.dumps({'diagnosticOnly': True, 'sourceUnmodified': True, 'standardFrameChecksumsMatch': all(checksum_matches[:last_commit]), 'committedFramesApplied': last_commit, 'integrityCheck': 'ok', 'testMessages': tests}, ensure_ascii=False, indent=2))


if __name__ == '__main__':
    main()
