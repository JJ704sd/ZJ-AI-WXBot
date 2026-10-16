"""Only synthetic HMAC pages and a substituted process boundary."""
import json
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch

from offline_chat import ArchiveError
from portable_key_recovery import recover_key_file
from test_acquire_database_keys import encrypted_page


class PortableRecoveryTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix='portable-key-test-')
        self.addCleanup(self.temp.cleanup)
        self.base = Path(self.temp.name).resolve()
        self.source = self.base / 'selected/db_storage'
        self.source.mkdir(parents=True)
        self.data = self.base / 'app-data'
        self.first_key, self.first_salt = b'K' * 32, b'S' * 16
        self.second_key, self.second_salt = b'J' * 32, b'T' * 16
        (self.source / 'message_0.db').write_bytes(encrypted_page(self.first_key, self.first_salt))
        (self.source / 'contact.db').write_bytes(encrypted_page(self.second_key, self.second_salt))
        self.rows = [{'key_hex': self.first_key.hex(), 'salt_hex': self.first_salt.hex()},
                     {'key_hex': self.second_key.hex(), 'salt_hex': self.second_salt.hex()}]

    def test_only_authenticated_selected_account_keys_are_saved_and_not_returned(self):
        foreign = {'key_hex': (b'F' * 32).hex(), 'salt_hex': (b'G' * 16).hex()}
        result = {'keys': self.rows + [foreign], 'imageRecovery': 'not_recovered'}
        with patch('portable_key_recovery._collect', return_value=result):
            outcome = recover_key_file(self.source, self.data, allow_process_read=True)
        saved = json.loads(Path(outcome['keyFile']).read_text(encoding='utf-8'))
        self.assertCountEqual(saved['keys'], self.rows)
        self.assertEqual(outcome['matchedCount'], 2)
        self.assertNotIn(self.first_key.hex(), json.dumps(outcome))
        self.assertNotIn(foreign['key_hex'], json.dumps(saved))
        self.assertTrue(Path(outcome['keyFile']).is_relative_to(self.data))

    def test_partial_match_is_refused_before_creating_a_key_file(self):
        with patch('portable_key_recovery._collect', return_value={'keys': self.rows[:1]}):
            with self.assertRaises(ArchiveError):
                recover_key_file(self.source, self.data, allow_process_read=True)
        self.assertFalse(self.data.exists())

    def test_explicit_selection_budget_and_source_write_boundary_precede_process_access(self):
        with patch('portable_key_recovery._collect') as collect:
            for options in ({}, {'allow_process_read': True, 'timeout': 999},
                            {'allow_process_read': True, 'budget_mib': 1}):
                with self.assertRaises(ArchiveError):
                    recover_key_file(self.source, self.data, **options)
            with self.assertRaises(ArchiveError):
                recover_key_file(self.source, self.source.parent / 'app-data', allow_process_read=True)
            collect.assert_not_called()
        self.assertFalse(self.data.exists())


if __name__ == '__main__':
    unittest.main()
