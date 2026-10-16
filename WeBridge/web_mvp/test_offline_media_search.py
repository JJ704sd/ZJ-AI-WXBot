"""Content matching stays within synthetic account media stores."""
from contextlib import closing
from io import BytesIO
import hashlib
import json
from pathlib import Path
import sqlite3
import tempfile
import unittest
from unittest.mock import patch

from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
from cryptography.hazmat.primitives.padding import PKCS7
from offline_media_search import LocalMediaSearch
from test_database_adapter import GROUP, STAMP
from test_windows_media import PNG
from windows_media import resolve_local


class LocalMediaSearchTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.base = Path(self.temp.name).resolve()
        self.account = self.base / 'selected-account'
        self.source = self.account / 'db_storage'
        self.source.mkdir(parents=True)
        self.config = {'sourceRoot': str(self.source)}
        self.snapshot = self.base / 'snapshot'
        (self.snapshot / 'hardlink').mkdir(parents=True)
        with closing(sqlite3.connect(self.snapshot / 'hardlink/hardlink.db')) as db, db:
            db.execute('CREATE TABLE image_hardlink_info_v4(md5,file_name,dir1,dir2)')
        self.row = {'kind': 'image', '_raw': '<msg><img md5="' + hashlib.md5(PNG).hexdigest() + '"/></msg>',
                    'localId': 1, 'serverId': '10', 'timestamp': STAMP}

    def put(self, relative, data):
        path = self.account / relative
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_bytes(data)
        return path

    def test_complete_checksum_match_upgrades_existing_thumbnail(self):
        from PIL import Image
        buffer = BytesIO()
        Image.new('RGB', (4, 4), '#112233').save(buffer, 'PNG')
        thumbnail = self.put('cache/2023-11/Message/' + hashlib.md5(GROUP.encode()).hexdigest() + f'/Thumb/1_{STAMP}_thumb.jpg', buffer.getvalue())
        full = self.put('cache/2026-01/Emoticon/aa/opaque-cache', PNG)
        result, body = resolve_local(self.snapshot, self.config, GROUP, self.row, recovery=LocalMediaSearch(self.config))
        self.assertEqual(body, PNG)
        self.assertFalse(result['previewOnly'])
        self.assertTrue(result['recoveredLocally'])
        self.assertTrue(thumbnail.is_file() and full.is_file())

    def test_thumbnail_and_similar_name_do_not_pass_full_checksum(self):
        self.put('cache/2023-11/Message/' + hashlib.md5(GROUP.encode()).hexdigest() + f'/Thumb/1_{STAMP}_thumb.jpg', PNG)
        row = {**self.row, '_raw': '<msg><img md5="' + hashlib.md5(b'missing-original').hexdigest() + '"/></msg>'}
        self.put('business/emoticon/Persist/aa/' + hashlib.md5(b'missing-original').hexdigest(), b'wrong cipher bytes')
        result, body = resolve_local(self.snapshot, self.config, GROUP, row, recovery=LocalMediaSearch(self.config))
        self.assertEqual(body, PNG)
        self.assertTrue(result['previewOnly'])
        self.assertEqual(result['localCheck']['result'], 'local_candidate_not_verified')

    def test_search_rejects_other_accounts_config_databases_and_links(self):
        other = self.base / 'another-account/msg/attach/opaque'
        other.parent.mkdir(parents=True)
        other.write_bytes(PNG)
        self.put('config/secret', PNG)
        self.put('db_storage/emoticon/emoticon.db', PNG)
        search = LocalMediaSearch(self.config)
        self.assertEqual(search.paths_for(hashlib.md5(PNG).hexdigest()), [])
        self.assertEqual(search.report()['filesScanned'], 0)
        media = self.account / 'msg/attach'
        media.mkdir(parents=True)
        try:
            (media / 'external-link').symlink_to(other)
        except OSError:
            return  # Windows may disallow creating links; other boundaries still checked.
        again = LocalMediaSearch(self.config)
        self.assertEqual(again.paths_for(hashlib.md5(PNG).hexdigest()), [])
        self.assertEqual(again.report()['filesScanned'], 0)

    def test_scan_budget_is_reported_as_incomplete(self):
        self.put('resource/first', b'one')
        self.put('resource/second', PNG)
        search = LocalMediaSearch(self.config, max_files=1)
        self.assertEqual(search.paths_for(hashlib.md5(PNG).hexdigest()), [])
        self.assertTrue(search.report()['limitReached'])
        self.assertEqual(search.diagnosis(hashlib.md5(PNG).hexdigest())['result'], 'local_search_incomplete')

    def test_changed_match_is_not_returned_as_original(self):
        path = self.put('resource/cached-image', PNG)
        search = LocalMediaSearch(self.config)
        self.assertEqual(search.paths_for(hashlib.md5(PNG).hexdigest()), [path])
        path.write_bytes(b'changed content')
        result, body = resolve_local(self.snapshot, self.config, GROUP, self.row, recovery=search)
        self.assertIsNone(body)
        self.assertEqual(result['status'], 'pending')

    def test_v2_cache_is_decoded_using_only_existing_account_key(self):
        import struct
        key = b'0123456789abcdef'
        key_file = self.base / 'keys.json'
        key_file.write_text(json.dumps({'keys': [{'sourceRoot': str(self.source), 'aes_hex': key.hex()}]}))
        head, tail = PNG[:32], PNG[32:]
        padder = PKCS7(128).padder()
        padded = padder.update(head) + padder.finalize()
        cipher = Cipher(algorithms.AES(key), modes.ECB()).encryptor()
        encoded = b'\x07\x08V2\x08\x07' + struct.pack('<II', len(head), len(tail)) + b'\0' + cipher.update(padded) + cipher.finalize() + bytes(value ^ 73 for value in tail)
        path = self.put('msg/attach/another-bucket/2024-01/Img/cached.dat', encoded)
        config = {**self.config, 'imageKeyFile': str(key_file)}
        search = LocalMediaSearch(config)
        result, body = resolve_local(self.snapshot, config, GROUP, self.row, recovery=search)
        self.assertEqual(body, PNG)
        self.assertEqual(result['matchedBy'], 'full_content_md5')
        self.assertEqual(search.report()['decodedContainers'], 1)
        self.assertEqual(path.read_bytes(), encoded)

    def test_relocated_thumbnail_uses_bundle_and_remains_preview_only(self):
        import struct
        key = b'0123456789abcdef'
        key_file = self.base / 'selected-key-bundle.json'
        key_file.write_text(json.dumps({'keys': [{'salt_hex': '55' * 16, 'key_hex': '44' * 32}],
            'imageKeys': [{'sourceRoot': str(self.base / 'old-computer/db_storage'), 'aes_hex': key.hex()}]}))
        before = key_file.read_bytes()
        head, tail = PNG[:32], PNG[32:]
        padder = PKCS7(128).padder()
        padded = padder.update(head) + padder.finalize()
        cipher = Cipher(algorithms.AES(key), modes.ECB()).encryptor()
        encoded = (b'\x07\x08V2\x08\x07' + struct.pack('<II', len(head), len(tail)) + b'\0'
                   + cipher.update(padded) + cipher.finalize() + bytes(value ^ 73 for value in tail))
        self.put('cache/2023-11/Message/' + hashlib.md5(GROUP.encode()).hexdigest() + f'/Thumb/1_{STAMP}_thumb.jpg', encoded)
        missing = hashlib.md5(b'missing original').hexdigest()
        row = {**self.row, '_raw': '<msg><img md5="' + missing + '"/></msg>'}
        config = {**self.config, 'keyFile': str(key_file)}
        result, data = resolve_local(self.snapshot, config, GROUP, row, recovery=LocalMediaSearch(config))
        self.assertEqual(data, PNG)
        self.assertTrue(result['previewOnly'])
        self.assertEqual(key_file.read_bytes(), before)


if __name__ == '__main__':
    unittest.main()
