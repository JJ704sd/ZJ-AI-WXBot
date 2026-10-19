"""Replace only the live process reader; no real process access in this suite."""
import unittest
from unittest.mock import Mock
from unittest.mock import patch
from pathlib import Path
import tempfile

from live_account_profiles import complete_live_profiles, read_running_profile


class LiveProfileTests(unittest.TestCase):
    def account(self, label='running', state='active', status='needs_key'):
        return {'sourceRoot': label, 'processState': state, 'processIds': [81],
                'processIdentities': [{'pid': 81, 'created': 100}], 'profileStatus': status,
                'accountNickname': '', 'accountId': '', 'profileBasis': 'none'}

    def test_unconfigured_running_account_gets_its_own_name_without_selecting_or_saving(self):
        account = self.account()
        scan = {'accounts': [account], 'recommendedSourceRoot': 'running'}
        reader = Mock(return_value={'accountNickname': '当前运行账号', 'accountId': 'own-id', 'profileStatus': 'matched', 'profileBasis': 'live_owner:contact'})
        result = complete_live_profiles(scan, 'wechat', allow_process_read=True, reader=reader)
        self.assertEqual(result['accounts'][0]['accountNickname'], '当前运行账号')
        self.assertEqual(result['accounts'][0]['processIds'], [81])
        self.assertEqual(result['recommendedSourceRoot'], 'running')
        self.assertEqual(account['accountNickname'], '')

    def test_no_reader_call_without_explicit_permission(self):
        reader = Mock()
        with self.assertRaises(ValueError):
            complete_live_profiles({'accounts': [self.account()]}, 'wechat', reader=reader)
        reader.assert_not_called()
        with self.assertRaises(ValueError):
            read_running_profile(self.account(), 'wechat')

    def test_inactive_ambiguous_and_missing_creation_time_do_not_read_processes(self):
        rows = [self.account(state='inactive'), self.account(state='ambiguous'), self.account()]
        rows[-1].pop('processIdentities')
        reader = Mock()
        result = complete_live_profiles({'accounts': rows}, 'wecom', allow_process_read=True, reader=reader)
        reader.assert_not_called()
        self.assertFalse(any(row['accountNickname'] for row in result['accounts']))

    def test_failure_of_one_account_does_not_copy_another_account_name(self):
        reader = Mock(side_effect=[ValueError('private sentinel'), {'accountNickname': '第二个账号', 'accountId': 'second-id', 'profileStatus': 'matched', 'profileBasis': 'live_owner:user_table'}])
        result = complete_live_profiles({'accounts': [self.account('first'), self.account('second')]}, 'wecom', allow_process_read=True, reader=reader)
        self.assertFalse(result['accounts'][0]['accountNickname'])
        self.assertEqual(result['accounts'][1]['accountNickname'], '第二个账号')
        self.assertNotIn('private sentinel', str(result))

    def test_reader_cannot_override_process_or_source_evidence(self):
        reader = Mock(return_value={'accountNickname': '同名账号', 'accountId': 'own', 'profileStatus': 'matched',
                                    'profileBasis': 'live_owner:contact', 'processIds': [999], 'sourceRoot': 'other', 'keys': ['never forward']})
        result = complete_live_profiles({'accounts': [self.account()]}, 'wechat', allow_process_read=True, reader=reader)
        self.assertEqual(result['accounts'][0]['sourceRoot'], 'running')
        self.assertEqual(result['accounts'][0]['processIds'], [81])
        self.assertNotIn('keys', result['accounts'][0])

    def test_session_reuses_names_only_for_the_same_source_pid_and_creation_time(self):
        from offline_desktop import DesktopSession
        with tempfile.TemporaryDirectory(prefix='live-name-cache-synthetic-') as folder:
            base = Path(folder).resolve()
            root = base / 'unconfigured'
            root.mkdir()
            (root / 'session.db').write_bytes(b'fixture')
            session = DesktopSession(base / 'profile')
            session.scan = lambda: {'accounts': [{'sourceRoot': str(root), 'databases': [{'path': 'session.db'}]}]}
            reader = Mock(return_value={'accountNickname': '进程昵称', 'accountId': 'own-id', 'profileStatus': 'matched', 'profileBasis': 'live_owner:contact'})
            with patch('offline_accounts._windows_owners', return_value=[(81, 100)]), patch('live_account_profiles.read_running_profile', reader):
                first = session.scan_accounts(live_names=True)
                second = session.scan_accounts()
            self.assertEqual(first['accounts'][0]['accountNickname'], '进程昵称')
            self.assertEqual(second['accounts'][0]['accountNickname'], '进程昵称')
            self.assertEqual(reader.call_count, 1)
            with patch('offline_accounts._windows_owners', return_value=[(81, 200)]), patch('live_account_profiles.read_running_profile', reader):
                changed = session.scan_accounts()
            self.assertFalse(changed['accounts'][0]['accountNickname'])
            self.assertEqual(reader.call_count, 1)
            self.assertFalse(session.settings_path.exists())
            self.assertFalse((session.directory / 'keys').exists())

    def test_wecom_profile_reader_uses_only_user_database_and_rejects_stale_owner(self):
        import types
        from wecom_key_recovery import recover_profile_key
        from database_snapshot import SnapshotError
        with tempfile.TemporaryDirectory(prefix='live-wecom-scope-synthetic-') as folder:
            base = Path(folder).resolve()
            source = base / '22' / 'Data'
            source.mkdir(parents=True)
            # Valid wxSQLite3 header shape, synthetic ciphertext; no key available.
            payload = bytearray(4096)
            payload[16:18] = (4096).to_bytes(2, 'big')
            payload[21:24] = b'\x40\x20\x20'
            (source / 'user.db').write_bytes(payload)
            (source / 'message.db').write_bytes(b'not-a-readable-message-database')
            kernel = types.SimpleNamespace(OpenProcess=Mock())
            with patch('acquire_database_keys.declare_windows_apis', return_value=kernel), patch('acquire_database_keys.WindowsDependencies._file_owners', return_value=[(81, 200)]) as owners:
                with self.assertRaises(SnapshotError):
                    recover_profile_key(source, base / 'temporary', expected_owner=(81, 100), allow_process_read=True)
            self.assertEqual(owners.call_args.args[0], [source / 'user.db'])
            kernel.OpenProcess.assert_not_called()
            self.assertFalse((base / 'temporary').exists())
