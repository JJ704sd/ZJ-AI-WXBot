"""Setup decisions over synthetic sources; process and cipher seams are substituted."""
import json
import os
from contextlib import contextmanager
from pathlib import Path
import tempfile
import unittest
from unittest.mock import Mock, patch

from database_snapshot import SnapshotError, prepare_snapshot
from offline_chat import ArchiveError, discover
from offline_desktop import DesktopSession
from test_database_adapter import create_metadata, create_shard


class AutomaticSetupTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix='automatic-setup-test-')
        self.addCleanup(self.temp.cleanup)
        self.base = Path(self.temp.name).resolve()
        self.source = self.base / 'xwechat_files/account-a/db_storage'
        self.source.mkdir(parents=True)
        create_metadata(self.source)
        create_shard(self.source, rows=[{'text': '自动配置合成业务记录'}])
        self.data = self.base / 'app'
        self.session = DesktopSession(self.data)

    def config(self):
        return {'sourceRoot': str(self.source), 'includeMedia': False}

    def accounts(self):
        return discover([self.source.parent.parent])

    def require_key_file(self, accepted):
        def prepare(source, target, key_file=None, **options):
            if str(key_file) != str(accepted):
                raise SnapshotError('需要匹配的授权密钥')
            return prepare_snapshot(source, target, **options)
        return patch('offline_desktop.prepare_snapshot', side_effect=prepare)

    def test_unique_discovered_plaintext_source_loads_without_process_access(self):
        with patch.object(self.session, 'scan', return_value=self.accounts()), patch('portable_key_recovery.recover_key_file') as recover:
            info = self.session.automatic_setup()
        self.assertEqual(info['status'], 'ready')
        self.assertIn('合成普通群', [group['name'] for group in info['groups']])
        recover.assert_not_called()
        self.assertEqual(self.session.settings['source']['sourceRoot'], str(self.source))

    def test_multiple_accounts_require_selection_before_any_key_access(self):
        with patch.object(self.session, 'scan', return_value={'accounts': [{}, {}]}), patch('portable_key_recovery.recover_key_file') as recover:
            info = self.session.automatic_setup(allow_process_read=True)
        self.assertEqual(info['status'], 'needs_source')
        self.assertIn('多个账号', info['message'])
        recover.assert_not_called()
        self.assertFalse(self.session.settings_path.exists())

    def test_missing_keys_never_trigger_process_access_without_explicit_action(self):
        with self.require_key_file(self.base / 'absent.json'), patch('portable_key_recovery.recover_key_file') as recover:
            info = self.session.automatic_setup(self.config())
        self.assertEqual(info['status'], 'needs_source')
        recover.assert_not_called()
        self.assertFalse(self.session.settings_path.exists())

    def test_successful_recovery_remembers_paths_and_combined_image_keys(self):
        accepted = self.data / 'keys/recovered.json'
        def recovery(source, directory, **options):
            self.assertEqual(Path(source), self.source)
            self.assertTrue(options['allow_process_read'])
            accepted.parent.mkdir(parents=True)
            accepted.write_text('{"synthetic":"secret-sentinel"}', encoding='utf-8')
            return {'keyFile': str(accepted), 'imageRecovery': 'verified_local_samples'}
        with self.require_key_file(accepted), patch('portable_key_recovery.recover_key_file', side_effect=recovery) as recover:
            info = self.session.automatic_setup(self.config(), allow_process_read=True)
        self.assertEqual(info['status'], 'ready')
        self.assertEqual(info['setupMode'], 'recovered_live')
        self.assertEqual(self.session.settings['source']['keyFile'], str(accepted))
        self.assertEqual(self.session.settings['source']['imageKeyFile'], '')
        self.assertNotIn('secret-sentinel', self.session.settings_path.read_text())
        self.assertEqual(recover.call_count, 1)

    def test_image_failure_still_loads_verified_database_with_explicit_notice(self):
        accepted = self.base / 'accepted.json'
        with self.require_key_file(accepted), patch('portable_key_recovery.recover_key_file',
                return_value={'keyFile': str(accepted), 'imageRecovery': 'not_recovered'}):
            info = self.session.automatic_setup(self.config(), allow_process_read=True)
        self.assertEqual(info['status'], 'ready')
        self.assertIn('图片密钥未恢复', info['notice'])

    def test_own_cached_key_is_reused_and_foreign_account_identity_is_not_inherited(self):
        accepted = self.data / 'keys/known.json'
        accepted.parent.mkdir(parents=True)
        accepted.write_text('{}')
        self.session._save({'sourceRoot': str(self.base / 'old-account/db_storage'), 'selfId': 'previous-user'})
        with self.require_key_file(accepted), patch('portable_key_recovery.recover_key_file') as recover:
            info = self.session.automatic_setup(self.config(), allow_process_read=True)
        self.assertEqual(info['status'], 'ready')
        self.assertEqual(self.session.settings['source']['selfId'], '')
        self.assertEqual(self.session.settings['source']['keyFile'], str(accepted))
        recover.assert_not_called()

    def test_recovery_failure_keeps_source_and_never_reports_ready_or_saves_settings(self):
        with self.require_key_file(self.base / 'absent'), patch('portable_key_recovery.recover_key_file',
                side_effect=ArchiveError('未检测到本机微信进程')):
            info = self.session.automatic_setup(self.config(), allow_process_read=True)
        self.assertEqual(info['status'], 'needs_source')
        self.assertIn('未检测到', info['message'])
        self.assertEqual(info['config']['sourceRoot'], str(self.source))
        self.assertIsNone(self.session.archive)
        self.assertFalse(self.session.settings_path.exists())

    def test_saved_source_failure_does_not_select_a_different_discovered_account(self):
        self.session._save({'sourceRoot': str(self.base / 'missing-selected-source')})
        with patch.object(self.session, 'scan') as scan, patch('portable_key_recovery.recover_key_file', side_effect=ArchiveError('未读取')):
            info = self.session.automatic_setup(allow_process_read=True)
        scan.assert_not_called()
        self.assertEqual(info['status'], 'needs_source')
        self.assertEqual(info['config']['sourceRoot'], str(self.base / 'missing-selected-source'))


class OwnerDiagnosticTests(unittest.TestCase):
    def test_no_holder_distinguishes_wechat_not_running_from_inactive_copy(self):
        from acquire_database_keys import WindowsDependencies, AcquireError
        for pids, code in (([], 'wechat_not_running'), ([12345], 'source_not_active')):
            dependencies = WindowsDependencies.__new__(WindowsDependencies)
            dependencies._file_owners = Mock(return_value=[])
            dependencies.ownership = Mock(weixin_pids=Mock(return_value=pids))
            dependencies._open = Mock()
            with self.assertRaises(AcquireError) as error:
                dependencies.owner([Path('selected.db')])
            self.assertEqual(error.exception.code, code)
            dependencies._open.assert_not_called()


@unittest.skipUnless(os.name == 'nt', 'Windows registry directory hints')
class DirectoryHintTests(unittest.TestCase):
    def test_redirected_documents_and_custom_base_are_found_without_disk_scan(self):
        import winreg
        from windows_data_paths import path_hints
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory).resolve()
            documents, custom = root / 'redirected-documents', root / 'custom-data'
            @contextmanager
            def open_key(_root, name):
                yield name
            def read_value(name, field):
                if name.endswith('User Shell Folders') and field == 'Personal':
                    return str(documents), 1
                if name.endswith('WeChat') and field == 'FileSavePath':
                    return str(custom), 1
                raise FileNotFoundError
            with patch.object(winreg, 'OpenKey', side_effect=open_key), patch.object(winreg, 'QueryValueEx', side_effect=read_value):
                roots = path_hints()
            self.assertIn(documents / 'xwechat_files', roots)
            self.assertIn(custom, roots)
            self.assertIn(custom / 'xwechat_files', roots)
            self.assertLessEqual(len(roots), 16)

    def test_unavailable_registry_keeps_standard_document_fallback(self):
        import winreg
        from windows_data_paths import path_hints
        with patch.object(winreg, 'OpenKey', side_effect=PermissionError):
            roots = path_hints()
        self.assertIn(Path.home() / 'Documents/xwechat_files', roots)


if __name__ == '__main__':
    unittest.main()
