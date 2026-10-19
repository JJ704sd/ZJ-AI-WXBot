"""Account names use invented contact-only SQLite sources, never real profiles."""
from contextlib import closing
from pathlib import Path
import hashlib
import json
import sqlite3
import struct
import tempfile
import unittest

from offline_account_profiles import account_profiles


class AccountProfileTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix='account-names-synthetic-')
        self.addCleanup(self.temp.cleanup)
        self.base = Path(self.temp.name).resolve()

    def personal(self, folder='wxid_synthetic_self_1234', username='wxid_synthetic_self', nick='本机昵称'):
        root = self.base / folder / 'db_storage'
        (root / 'contact').mkdir(parents=True)
        db = root / 'contact/contact.db'
        with closing(sqlite3.connect(db)) as connection, connection:
            connection.execute('CREATE TABLE contact(username,remark,nick_name)')
            connection.executemany('INSERT INTO contact VALUES (?,?,?)', [(username, '不是昵称的备注', nick), ('wxid_other', '误导备注', '其他人')])
        return root, {'sourceRoot': str(root), 'directoryLabel': folder, 'processState': 'active', 'processIds': [81]}

    def test_personal_exact_id_nickname_and_process_evidence_are_preserved(self):
        root, item = self.personal()
        before = hashlib.sha256((root / 'contact/contact.db').read_bytes()).hexdigest()
        result = account_profiles({'accounts': [item]})['accounts'][0]
        self.assertEqual(result['accountNickname'], '本机昵称')
        self.assertEqual(result['accountId'], 'wxid_synthetic_self')
        self.assertEqual(result['processIds'], [81])
        self.assertEqual(result['processState'], 'active')
        self.assertTrue(result['profileBasis'].startswith('directory_id_exact_contact'))
        self.assertEqual(before, hashlib.sha256((root / 'contact/contact.db').read_bytes()).hexdigest())
        self.assertNotIn('accountNickname', item)

    def test_wecom_uses_the_exact_account_user_not_the_first_contact(self):
        root = self.base / '22' / 'Data'
        root.mkdir(parents=True)
        with closing(sqlite3.connect(root / 'user.db')) as db, db:
            db.execute('CREATE TABLE user_table(id integer,name,real_name)')
            db.executemany('INSERT INTO user_table VALUES (?,?,?)', [(11, '其他人', '其他实名'), (22, '本人昵称', '本人实名')])
        result = account_profiles({'accounts': [{'sourceRoot': str(root.parent)}]}, 'wecom')['accounts'][0]
        self.assertEqual(result['accountNickname'], '本人昵称')
        self.assertEqual(result['accountId'], '22')

    def test_configured_id_is_only_used_for_the_matching_source(self):
        first, a = self.personal('custom', 'custom-own', '指定本人')
        second, b = self.personal('wxid_synthetic_peer_5678', 'wxid_synthetic_peer', '另一个昵称')
        rows = account_profiles({'accounts': [a, b]}, configured_source=str(first), configured_self_id='custom-own')['accounts']
        self.assertEqual([r['accountNickname'] for r in rows], ['指定本人', '另一个昵称'])
        self.assertTrue(rows[0]['profileBasis'].startswith('configured_self_id'))

    def test_missing_nickname_never_falls_back_to_contact_remark_or_other_people(self):
        _, item = self.personal(nick='')
        result = account_profiles({'accounts': [item]})['accounts'][0]
        self.assertEqual(result['accountNickname'], '')
        self.assertEqual(result['profileStatus'], 'name_not_found')

    def test_unknown_source_id_is_not_guessed_from_contacts(self):
        _, item = self.personal('custom-directory')
        result = account_profiles({'accounts': [item]})['accounts'][0]
        self.assertEqual(result['profileStatus'], 'unknown_id')
        self.assertFalse(result['accountNickname'])

    def test_committed_contact_wal_is_read_without_touching_the_source(self):
        root, item = self.personal(nick='旧昵称')
        path = root / 'contact/contact.db'
        with closing(sqlite3.connect(path)) as db, db:
            db.execute('PRAGMA journal_mode=WAL')
            db.execute('PRAGMA wal_autocheckpoint=0')
            db.execute("UPDATE contact SET nick_name='更新后的昵称' WHERE username='wxid_synthetic_self'")
            db.commit()
            wal = Path(str(path) + '-wal')
            before = path.read_bytes(), wal.read_bytes()
            result = account_profiles({'accounts': [item]})['accounts'][0]
            self.assertEqual(result['accountNickname'], '更新后的昵称')
            self.assertEqual(before, (path.read_bytes(), wal.read_bytes()))

    def test_duplicate_identity_rows_do_not_choose_a_nickname(self):
        root, item = self.personal()
        with closing(sqlite3.connect(root / 'contact/contact.db')) as db, db:
            db.execute("INSERT INTO contact VALUES ('wxid_synthetic_self','','另一个名称')")
        result = account_profiles({'accounts': [item]})['accounts'][0]
        self.assertEqual(result['profileStatus'], 'ambiguous')
        self.assertFalse(result['accountNickname'])

    def test_encrypted_profile_without_a_local_key_keeps_process_evidence(self):
        root, item = self.personal()
        (root / 'contact/contact.db').write_bytes(b'X' * 4096)
        result = account_profiles({'accounts': [item]})['accounts'][0]
        self.assertEqual(result['profileStatus'], 'needs_key')
        self.assertEqual(result['processState'], 'active')
        self.assertEqual(result['processIds'], [81])
        self.assertFalse(result['accountNickname'])

    def test_existing_wecom_key_decrypts_only_the_matching_profile(self):
        from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
        from wecom_crypto import page_iv
        root = self.base / '22' / 'Data'
        root.mkdir(parents=True)
        path = root / 'user.db'
        with closing(sqlite3.connect(path)) as db, db:
            db.execute('CREATE TABLE user_table(id integer,name,real_name)')
            db.execute("INSERT INTO user_table VALUES (22,'密文资料昵称','本人实名')")
        key = bytes(range(16))
        plain = path.read_bytes()
        size = int.from_bytes(plain[16:18], 'big')
        encrypted = bytearray()
        for offset in range(0, len(plain), size):
            number = offset // size + 1
            page = plain[offset:offset + size]
            pagekey = hashlib.md5(key + struct.pack('<I', number) + b'sAlT').digest()
            encode = Cipher(algorithms.AES(pagekey), modes.CBC(page_iv(number))).encryptor()
            payload = encode.update(page[16:] if number == 1 else page) + encode.finalize()
            encrypted.extend(bytes(8) + payload[:8] + page[16:24] + payload[8:] if number == 1 else payload)
        path.write_bytes(encrypted)
        keys = self.base / 'provided.json'
        keys.write_text(json.dumps({'wecomKeys': [{'database': 'user.db', 'key_hex': key.hex()}]}))
        row = {'sourceRoot': str(root)}
        self.assertEqual(account_profiles({'accounts': [row]}, 'wecom')['accounts'][0]['profileStatus'], 'needs_key')
        result = account_profiles({'accounts': [row]}, 'wecom', key_files=[keys])['accounts'][0]
        self.assertEqual(result['accountNickname'], '密文资料昵称')
        self.assertEqual(result['profileStatus'], 'matched')
        self.assertEqual(path.read_bytes(), bytes(encrypted))


if __name__ == '__main__':
    unittest.main()
