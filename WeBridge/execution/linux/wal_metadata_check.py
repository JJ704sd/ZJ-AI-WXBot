#!/usr/bin/env python3
"""Inspect only explicitly supplied offline WAL/SHM copies, without a key.

No database file is opened, no files are changed, and no recovery is attempted.
The predecessor-anchored and SHM suffix checks are diagnostics, not permission
to accept a broken WAL chain. Never point this tool at a live client directory.
"""
import argparse
import hashlib
import json
from pathlib import Path
import sqlite3
import struct
import tempfile


def checksum(data, order, state=(0, 0)):
    if len(data) % 8:
        raise ValueError('Checksum input length must be a multiple of eight')
    a, b = state
    for x, y in struct.iter_unpack(order + 'II', data):
        a = (a + x + b) & 0xffffffff
        b = (b + y + a) & 0xffffffff
    return a, b


def inspect(wal, shm=None):
    if len(wal) < 32:
        raise ValueError('WAL header is incomplete')
    h = struct.unpack('>8I', wal[:32])
    if h[0] not in (0x377f0682, 0x377f0683):
        raise ValueError('Not a supported SQLite WAL magic')
    size = h[2]
    if size < 512 or size > 65536 or size & (size - 1):
        raise ValueError('Invalid WAL page size')
    order = '<' if h[0] == 0x377f0682 else '>'
    stride = size + 24
    count, remainder = divmod(len(wal) - 32, stride)
    state = h[6:8]
    header_ok = checksum(wal[:24], order) == state
    predecessor = state
    strict_open = header_ok and h[1] == 3007000
    prefix_frames = prefix_commit = 0
    first_bad = None
    local_matches = chain_matches = 0
    rows = []
    records = []
    for i in range(count):
        offset = 32 + i * stride
        frame = wal[offset:offset + stride]
        page, commit, salt1, salt2, c1, c2 = struct.unpack('>6I', frame[:24])
        data = frame[:8] + frame[24:]
        salt_ok = (salt1, salt2) == h[4:6]
        state = checksum(data, order, state)
        expected = c1, c2
        chain_ok = state == expected
        local_ok = checksum(data, order, predecessor) == expected
        predecessor = expected
        good = salt_ok and page > 0 and chain_ok
        if strict_open and good:
            prefix_frames = i + 1
            if commit:
                prefix_commit = i + 1
        elif strict_open:
            strict_open = False
            first_bad = i + 1
        chain_matches += int(chain_ok)
        local_matches += int(local_ok)
        row = {'frame': i + 1, 'page': page, 'commit_pages': commit,
               'salt_matches': salt_ok, 'cumulative_matches': chain_ok,
               'from_previous_stored_matches': local_ok}
        records.append((data, expected, salt_ok, page))
        if i < 8 or (not good and len(rows) < 24):
            rows.append(row)
    result = {
        'diagnostic_only': True, 'wal_sha256': hashlib.sha256(wal).hexdigest(),
        'wal_bytes': len(wal), 'page_size': size, 'format_version': h[1],
        'checksum_byte_order': 'little' if order == '<' else 'big',
        'header_checksum_matches': header_ok, 'complete_frames': count,
        'trailing_partial_bytes': remainder, 'first_invalid_frame': first_bad,
        'strict_valid_prefix_frames': prefix_frames,
        'strict_valid_prefix_last_commit': prefix_commit,
        'cumulative_match_count': chain_matches,
        'previous_stored_match_count': local_matches,
        'frame_metadata_sample': rows,
    }
    if shm is not None:
        if len(shm) < 136:
            result['shm'] = {'error': 'SHM header shorter than 136 bytes'}
        else:
            # The target Linux ARM64 process uses little-endian SHM integers.
            head = shm[:48]
            mx = struct.unpack_from('<I', head, 16)[0]
            backfill = struct.unpack_from('<I', shm, 96)[0]
            attempted = struct.unpack_from('<I', shm, 128)[0]
            last_sum_ok = (mx <= count and struct.unpack_from('<II', head, 24)
                           == (h[6:8] if mx == 0 else records[mx - 1][1]))
            byte_order_ok = head[13] == (h[0] & 1)
            valid = (head == shm[48:96] and head[12] == 1
                     and struct.unpack_from('<I', head)[0] == 3007000
                     and checksum(head[:40], '<') == struct.unpack_from('<II', head, 40)
                     and head[32:40] == wal[16:24]
                     and 0 <= backfill <= attempted <= mx <= count
                     and last_sum_ok and byte_order_ok)
            meta = {'byte_order_assumption': 'Linux ARM64 little-endian',
                    'header_copies_match': head == shm[48:96],
                    'header_checksum_matches': checksum(head[:40], '<') == struct.unpack_from('<II', head, 40),
                    'salt_matches_wal': head[32:40] == wal[16:24],
                    'last_frame_checksum_matches': last_sum_ok,
                    'checksum_byte_order_matches': byte_order_ok,
                    'mx_frame': mx, 'n_backfill': backfill,
                    'n_backfill_attempted': attempted,
                    'header_metadata_consistent': valid}
            if valid:
                seed = h[6:8] if not backfill else records[backfill - 1][1]
                suffix_bad = None
                for i in range(backfill, mx):
                    data, expected, salt_ok, page = records[i]
                    seed = checksum(data, order, seed)
                    if not salt_ok or not page or seed != expected:
                        suffix_bad = i + 1
                        break
                meta.update({'suffix_anchor_not_independently_validated': backfill > 0,
                             'suffix_first_invalid_frame': suffix_bad,
                             'suffix_matches': suffix_bad is None})
            result['shm'] = meta
    return result


def read_offline(path):
    source = Path(path)
    resolved = source.resolve(strict=True)
    if source.is_symlink() or {'xwechat_files', 'db_storage'} & set(resolved.parts):
        raise ValueError('Refusing a symlink or client database directory; use an offline copy')
    if not resolved.is_file() or resolved.stat().st_size > 512 * 1024 * 1024:
        raise ValueError('Input must be a regular offline copy below 512 MiB')
    return resolved.read_bytes()


def self_test():
    # Independent producer: Python's real SQLite engine, not a fabricated WAL.
    with tempfile.TemporaryDirectory(prefix='wal-metadata-selftest-') as folder:
        db = Path(folder) / 'synthetic.db'
        conn = sqlite3.connect(db)
        conn.execute('PRAGMA page_size=4096')
        conn.execute('PRAGMA journal_mode=WAL')
        conn.execute('PRAGMA wal_autocheckpoint=0')
        conn.execute('CREATE TABLE sample(id INTEGER PRIMARY KEY, value TEXT)')
        conn.commit()
        for value in ('synthetic-one', 'synthetic-two'):
            conn.execute('INSERT INTO sample(value) VALUES(?)', (value,))
            conn.commit()
        wal = Path(str(db) + '-wal').read_bytes()
        shm = Path(str(db) + '-shm').read_bytes()
        good = inspect(wal, shm)
        assert good['header_checksum_matches']
        assert good['strict_valid_prefix_frames'] == good['complete_frames']
        assert good['shm']['header_metadata_consistent']
        assert good['shm']['suffix_matches']
        changed = bytearray(wal)
        changed[32 + (4096 + 24) + 24 + 64] ^= 1
        bad = inspect(changed)
        assert bad['first_invalid_frame'] == 2
        assert bad['previous_stored_match_count'] == bad['complete_frames'] - 1
        conn.close()
        return {'synthetic_only': True, 'sqlite_version': sqlite3.sqlite_version,
                'valid_wal': good, 'one_byte_corruption_in_frame_2': bad}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument('--offline-copy', help='Path to an already captured offline WAL copy')
    group.add_argument('--self-test', action='store_true')
    parser.add_argument('--shm-copy', help='Optional SHM from the same offline capture')
    args = parser.parse_args()
    if args.self_test:
        if args.shm_copy:
            parser.error('--shm-copy requires --offline-copy')
        result = self_test()
    else:
        result = inspect(read_offline(args.offline_copy),
                         read_offline(args.shm_copy) if args.shm_copy else None)
    print(json.dumps(result, ensure_ascii=False, indent=2))


if __name__ == '__main__':
    main()
