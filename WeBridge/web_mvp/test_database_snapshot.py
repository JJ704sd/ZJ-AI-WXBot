"""Snapshot tests use temporary SQLite databases and generated cipher material."""
import hashlib
import hmac
import json
import os
from pathlib import Path
import sqlite3
import struct
import tempfile
import unittest
from unittest.mock import patch

import database_snapshot as snapshots


def make_database(path, value='synthetic'):
    path.parent.mkdir(parents=True, exist_ok=True)
    with sqlite3.connect(path) as connection:
        connection.execute('CREATE TABLE samples(value TEXT)')
        connection.execute('INSERT INTO samples VALUES (?)', (value,))
    connection.close()


def wal_checksum(data, a=0, b=0, little=True):
    for x, y in struct.iter_unpack('<II' if little else '>II', data):
        a = (a + x + b) & 0xffffffff
        b = (b + y + a) & 0xffffffff
    return a, b


class SnapshotTests(unittest.TestCase):
    def setUp(self):
        self.directory = tempfile.TemporaryDirectory(prefix='webridge-db-snapshot-')
        self.addCleanup(self.directory.cleanup)
        self.base = Path(self.directory.name)
        self.source = self.base / 'source'
        self.output = self.base / 'snapshots'
        self.source.mkdir()

    def read_values(self, root, relative='message/message_0.db'):
        with sqlite3.connect(Path(root) / relative) as connection:
            values = [row[0] for row in connection.execute('SELECT value FROM samples')]
        connection.close()
        return values

    def wal_database(self):
        path = self.source / 'message/message_0.db'
        make_database(path, 'base')
        connection = sqlite3.connect(path)
        connection.execute('PRAGMA journal_mode=WAL')
        connection.execute('PRAGMA wal_autocheckpoint=0')
        connection.execute("INSERT INTO samples VALUES ('committed-in-wal')")
        connection.commit()
        self.addCleanup(connection.close)
        return path, connection

    def test_plaintext_multishard_snapshot_is_independent_and_preserves_paths(self):
        make_database(self.source / 'message/message_0.db', 'shard-zero')
        make_database(self.source / 'message/message_1.db', 'shard-one')
        make_database(self.source / 'biz_message/biz_message_0.db', 'business-shard')
        make_database(self.source / 'contact/contact.db', 'contact-fixture')
        make_database(self.source / 'message/message_fts.db', 'not-business-input')
        before = {path: path.read_bytes() for path in self.source.rglob('*.db')}
        result = snapshots.prepare_snapshot(self.source, self.output)
        self.assertEqual(result['source']['dbCount'], 4)
        self.assertEqual(result['source']['encryptedCount'], 0)
        self.assertEqual(self.read_values(result['root']), ['shard-zero'])
        self.assertEqual(self.read_values(result['root'], 'message/message_1.db'), ['shard-one'])
        self.assertEqual(self.read_values(result['root'], 'biz_message/biz_message_0.db'), ['business-shard'])
        self.assertFalse((result['root'] / 'message/message_fts.db').exists())
        self.assertFalse(any(path.name.startswith('.raw') for path in result['root'].iterdir()))
        self.assertTrue(all(path.read_bytes() == data for path, data in before.items()))

    def test_committed_wal_is_visible_without_writing_source(self):
        path, connection = self.wal_database()
        wal = Path(str(path) + '-wal')
        before = (path.read_bytes(), wal.read_bytes())
        result = snapshots.prepare_snapshot(self.source, self.output)
        self.assertEqual(self.read_values(result['root']), ['base', 'committed-in-wal'])
        self.assertEqual(before, (path.read_bytes(), wal.read_bytes()))
        self.assertEqual(result['source']['databases'][0]['wal']['status'], 'merged')
        self.assertFalse(Path(str(result['root'] / 'message/message_0.db') + '-wal').exists())

    def test_zero_length_wal_is_valid_empty_state(self):
        path = self.source / 'message_0.db'
        make_database(path)
        Path(str(path) + '-wal').touch()
        result = snapshots.prepare_snapshot(self.source, self.output)
        self.assertEqual(result['source']['databases'][0]['wal']['status'], 'empty')

    def test_nonempty_rollback_journal_is_not_silently_omitted(self):
        path = self.source / 'message_0.db'
        make_database(path)
        journal = Path(str(path) + '-journal')
        journal.write_bytes(b'synthetic pending rollback state')
        original = path.read_bytes()
        with self.assertRaisesRegex(snapshots.SnapshotError, '回滚日志'):
            snapshots.prepare_snapshot(self.source, self.output)
        self.assertEqual(path.read_bytes(), original)
        self.assertEqual(journal.read_bytes(), b'synthetic pending rollback state')
        self.assertFalse(self.output.exists())

    def test_same_size_change_after_copy_retries_then_rejects(self):
        path = self.source / 'message_0.db'
        make_database(path)
        copy_file = snapshots._copy_file
        def mutate_after_copy(source, target):
            digest = copy_file(source, target)
            data = bytearray(source.read_bytes())
            data[-1] ^= 1
            source.write_bytes(data)
            return digest
        with patch.object(snapshots, '_copy_file', side_effect=mutate_after_copy):
            with self.assertRaisesRegex(snapshots.SnapshotError, '持续变化'):
                snapshots.prepare_snapshot(self.source, self.output)
        self.assertEqual(list(self.output.iterdir()), [])

    def test_second_hash_detects_change_when_metadata_is_unchanged(self):
        path = self.source / 'message_0.db'
        make_database(path)
        signature = snapshots._signature(path)
        copy_file = snapshots._copy_file
        def mutate_after_copy(source, target):
            digest = copy_file(source, target)
            data = bytearray(source.read_bytes()); data[-1] ^= 1
            source.write_bytes(data)
            return digest
        with patch.object(snapshots, '_signature', return_value=signature), patch.object(snapshots, '_copy_file', side_effect=mutate_after_copy):
            with self.assertRaisesRegex(snapshots.SnapshotError, '持续变化'):
                snapshots.prepare_snapshot(self.source, self.output)

    def test_failed_batch_keeps_previous_success_and_source(self):
        make_database(self.source / 'message_0.db')
        previous = snapshots.prepare_snapshot(self.source, self.output)
        previous_bytes = (previous['root'] / 'message_0.db').read_bytes()
        bad = self.source / 'session.db'; bad.write_bytes(b'not a database')
        with self.assertRaises(snapshots.SnapshotError):
            snapshots.prepare_snapshot(self.source, self.output)
        self.assertEqual(list(self.output.iterdir()), [previous['root']])
        self.assertEqual((previous['root'] / 'message_0.db').read_bytes(), previous_bytes)
        self.assertEqual(bad.read_bytes(), b'not a database')

    def test_output_inside_source_is_rejected_without_writing(self):
        make_database(self.source / 'message_0.db')
        destination = self.source / 'generated'
        with self.assertRaisesRegex(snapshots.SnapshotError, '不能位于源目录'):
            snapshots.prepare_snapshot(self.source, destination)
        self.assertFalse(destination.exists())

    def test_storage_failure_has_safe_public_diagnostic(self):
        make_database(self.source / 'message_0.db')
        private_error = 'private OS path or database content must not reach UI'
        with patch.object(snapshots, '_copy_file', side_effect=OSError(private_error)):
            with self.assertRaises(snapshots.SnapshotError) as caught:
                snapshots.prepare_snapshot(self.source, self.output)
        self.assertEqual(caught.exception.public_message, str(caught.exception))
        self.assertNotIn(private_error, caught.exception.public_message)
        self.assertIn('磁盘空间', caught.exception.public_message)
        self.assertEqual(list(self.output.iterdir()), [])

    @unittest.skipUnless(os.name == 'nt', 'Windows byte-range lock fault injection')
    def test_real_sqlite_reset_before_first_frame_preserves_checkpointed_database(self):
        import msvcrt
        path, connection = self.wal_database()
        wal = Path(str(path) + '-wal')
        checkpoint = connection.execute('PRAGMA wal_checkpoint(RESTART)').fetchone()
        self.assertEqual(checkpoint[0], 0)
        self.assertEqual(checkpoint[1], checkpoint[2])
        original = wal.read_bytes()
        checkpointed_database = path.read_bytes()
        # Fault only the first new frame write. SQLite itself writes and syncs
        # the new WAL header first, retaining the previous generation's frames.
        # No header or salt is fabricated by this regression.
        with wal.open('r+b', buffering=0) as locked:
            locked.seek(32); msvcrt.locking(locked.fileno(), msvcrt.LK_NBLCK, 24)
            try:
                with self.assertRaises(sqlite3.OperationalError) as caught:
                    connection.execute("INSERT INTO samples VALUES ('uncommitted-after-reset')")
                    connection.commit()
                self.assertEqual(caught.exception.sqlite_errorname, 'SQLITE_IOERR_WRITE')
                locked.seek(0); reset = locked.read()
            finally:
                locked.seek(32); msvcrt.locking(locked.fileno(), msvcrt.LK_UNLCK, 24)
        self.assertNotEqual(reset[:32], original[:32])
        self.assertEqual(reset[32:], original[32:])
        self.assertNotEqual(reset[16:24], reset[40:48])
        connection.close()
        path.write_bytes(checkpointed_database); wal.write_bytes(reset)
        # Independent SQLite recovery oracle on another private synthetic copy.
        oracle = self.base / 'oracle'; oracle.mkdir()
        (oracle / 'message_0.db').write_bytes(checkpointed_database)
        (oracle / 'message_0.db-wal').write_bytes(reset)
        expected = self.read_values(oracle, 'message_0.db')
        self.assertEqual(expected, ['base', 'committed-in-wal'])
        result = snapshots.prepare_snapshot(self.source, self.output)
        self.assertEqual(self.read_values(result['root']), expected)
        info = result['source']['databases'][0]['wal']
        self.assertEqual(info['committedFrames'], 0)
        self.assertEqual(info['tail'], 'previous_generation_tail')
        self.assertEqual(info['status'], 'no_committed_frames')
        self.assertEqual(path.read_bytes(), checkpointed_database)
        self.assertEqual(wal.read_bytes(), reset)

    def test_stale_first_frame_stops_before_later_matching_generation(self):
        path, connection = self.wal_database()
        checkpointed_database = path.read_bytes()
        original = Path(str(path) + '-wal').read_bytes()
        connection.close()
        # Keep the pre-transaction DB so accepting the later apparently valid
        # frame would visibly replay a row past the generation boundary.
        path.write_bytes(checkpointed_database)
        page_size = int.from_bytes(original[8:12], 'big')
        frame = bytearray(original[32:32 + 24 + page_size]); frame[8] ^= 1
        Path(str(path) + '-wal').write_bytes(original[:32] + frame + original[32:])
        result = snapshots.prepare_snapshot(self.source, self.output)
        self.assertEqual(self.read_values(result['root']), ['base'])
        self.assertEqual(result['source']['databases'][0]['wal']['committedFrames'], 0)

    def test_corrupt_wal_header_and_frame_are_rejected(self):
        path, connection = self.wal_database()
        original = Path(str(path) + '-wal').read_bytes()
        connection.close()
        for index in (24, 60):
            damaged = bytearray(original); damaged[index] ^= 1
            Path(str(path) + '-wal').write_bytes(damaged)
            with self.assertRaisesRegex(snapshots.SnapshotError, '校验失败'):
                snapshots.prepare_snapshot(self.source, self.output)
        self.assertEqual(list(self.output.iterdir()), [])

    def test_partial_frame_still_rejects_incomplete_snapshot(self):
        path, connection = self.wal_database()
        wal = Path(str(path) + '-wal'); original = wal.read_bytes()
        connection.close()
        for data in (original[:-1], original + b'partial-header'):
            with self.subTest(bytes=len(data)):
                wal.write_bytes(data)
                with self.assertRaisesRegex(snapshots.SnapshotError, '尾帧不完整'):
                    snapshots.prepare_snapshot(self.source, self.output)
        self.assertEqual(list(self.output.iterdir()), [])

    def test_current_uncommitted_prefix_before_old_generation_is_not_applied(self):
        path, connection = self.wal_database()
        database_before_commit = path.read_bytes()
        wal = Path(str(path) + '-wal'); original = wal.read_bytes()
        connection.close(); path.write_bytes(database_before_commit)
        page_size = int.from_bytes(original[8:12], 'big')
        current = bytearray(original[32:32 + 24 + page_size])
        current[4:8] = bytes(4)
        a, b = struct.unpack('>II', original[24:32])
        a, b = wal_checksum(current[:8] + current[24:], a, b, little=int.from_bytes(original[:4], 'big') == 0x377f0682)
        current[16:24] = struct.pack('>II', a, b)
        stale = bytearray(original[32:32 + 24 + page_size]); stale[8] ^= 1
        wal.write_bytes(original[:32] + current + stale)
        result = snapshots.prepare_snapshot(self.source, self.output)
        info = result['source']['databases'][0]['wal']
        self.assertEqual(info['committedFrames'], 0)
        self.assertEqual(info['uncommittedFrames'], 1)
        self.assertEqual(self.read_values(result['root']), ['base'])

    def test_wal_checksum_byte_order_comes_from_magic_not_host(self):
        path, connection = self.wal_database()
        original = bytearray(Path(str(path) + '-wal').read_bytes())
        connection.close()
        original[:4] = struct.pack('>I', 0x377f0683)
        a, b = wal_checksum(original[:24], little=False)
        original[24:32] = struct.pack('>II', a, b)
        page_size = int.from_bytes(original[8:12], 'big')
        for start in range(32, len(original), 24 + page_size):
            a, b = wal_checksum(original[start:start + 8] + original[start + 24:start + 24 + page_size], a, b, little=False)
            original[start + 16:start + 24] = struct.pack('>II', a, b)
        Path(str(path) + '-wal').write_bytes(original)
        result = snapshots.prepare_snapshot(self.source, self.output)
        self.assertEqual(self.read_values(result['root']), ['base', 'committed-in-wal'])

    def test_uncommitted_complete_tail_is_not_applied(self):
        path, connection = self.wal_database()
        wal = Path(str(path) + '-wal')
        original = bytearray(wal.read_bytes())
        connection.close()
        page_size = int.from_bytes(original[8:12], 'big')
        last = len(original) - 24 - page_size
        a, b = struct.unpack('>II', original[last + 16:last + 24])
        header = original[last:last + 24]
        header[4:8] = bytes(4)
        payload = bytes(page_size)
        a, b = wal_checksum(header[:8] + payload, a, b, little=int.from_bytes(original[:4], 'big') == 0x377f0682)
        header[16:24] = struct.pack('>II', a, b)
        wal.write_bytes(original + header + payload)
        result = snapshots.prepare_snapshot(self.source, self.output)
        self.assertEqual(result['source']['databases'][0]['wal']['uncommittedFrames'], 1)
        self.assertEqual(self.read_values(result['root']), ['base', 'committed-in-wal'])

    def test_encrypted_database_requires_key_and_never_publishes_partial_pages(self):
        try:
            from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
        except ImportError:
            self.skipTest('optional cryptography dependency')
        path = self.source / 'message_0.db'
        with sqlite3.connect(path) as connection:
            connection.execute('PRAGMA page_size=4096'); connection.execute('VACUUM')
        connection.close()
        plain = bytearray(path.read_bytes())
        plain[20] = 80  # SQLCipher page reserve, empty leaf has no affected cells.
        plain[105:107] = (4016).to_bytes(2, 'big')
        path.write_bytes(plain)
        with sqlite3.connect(path) as connection:
            self.assertEqual(connection.execute('PRAGMA quick_check').fetchone(), ('ok',))
        connection.close()
        key, salt, iv = b'K' * 32, b'S' * 16, b'I' * 16
        encryptor = Cipher(algorithms.AES(key), modes.CBC(iv)).encryptor()
        encrypted = bytearray(salt + encryptor.update(bytes(plain[16:4016])) + encryptor.finalize() + iv)
        mac_key = hashlib.pbkdf2_hmac('sha512', key, bytes(value ^ 0x3a for value in salt), 2, 32)
        encrypted.extend(hmac.new(mac_key, bytes(encrypted[16:]) + (1).to_bytes(4, 'little'), hashlib.sha512).digest())
        path.write_bytes(encrypted)
        with self.assertRaisesRegex(snapshots.SnapshotError, '授权密钥'):
            snapshots.prepare_snapshot(self.source, self.output)
        key_file = self.base / 'fixture-keys.json'
        key_file.write_text(json.dumps({'keys': [{'key_hex': key.hex(), 'salt_hex': salt.hex()}]}))
        result = snapshots.prepare_snapshot(self.source, self.output, key_file)
        self.assertEqual(result['source']['encryptedCount'], 1)
        self.assertNotIn(key.hex(), (result['root'] / 'manifest.json').read_text(encoding='utf-8'))
        # The same encrypted page can be a committed WAL frame. SQLite checksums
        # protect the encrypted bytes; the cipher must additionally authenticate it.
        header24 = struct.pack('>6I', 0x377f0682, 3007000, 4096, 0, 123, 456)
        a, b = wal_checksum(header24)
        frame8 = struct.pack('>2I', 1, 1)
        fa, fb = wal_checksum(frame8 + encrypted, a, b)
        wal = Path(str(path) + '-wal')
        wal.write_bytes(header24 + struct.pack('>2I', a, b) + frame8 + struct.pack('>4I', 123, 456, fa, fb) + encrypted)
        merged = snapshots.prepare_snapshot(self.source, self.output, key_file)
        self.assertEqual(merged['source']['databases'][0]['wal']['committedFrames'], 1)
        wal.unlink()
        # A later authenticated-layout page must not be skipped when its HMAC
        # fails. The original reference erroneously returned partial success.
        tail_encryptor = Cipher(algorithms.AES(key), modes.CBC(iv)).encryptor()
        tail = bytearray(tail_encryptor.update(bytes(4016)) + tail_encryptor.finalize() + iv)
        tail.extend(hmac.new(mac_key, bytes(tail) + (2).to_bytes(4, 'little'), hashlib.sha512).digest())
        tail[100] ^= 1
        path.write_bytes(encrypted + tail)
        with self.assertRaisesRegex(snapshots.SnapshotError, 'HMAC'):
            snapshots.prepare_snapshot(self.source, self.output, key_file)
        encrypted[-1] ^= 1; path.write_bytes(encrypted)
        with self.assertRaisesRegex(snapshots.SnapshotError, '首页校验'):
            snapshots.prepare_snapshot(self.source, self.output, key_file)
        self.assertEqual(set(self.output.iterdir()), {result['root'], merged['root']})


if __name__ == '__main__':
    unittest.main()
