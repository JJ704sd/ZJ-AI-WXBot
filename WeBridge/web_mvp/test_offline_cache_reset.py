"""Cache deletion boundaries and first-use reset, using synthetic profiles only."""
import json
import os
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch

from offline_desktop import DesktopSession
from offline_chat import ArchiveError
from offline_profiles import CACHE_ENTRIES, RESET_MARKER


class CacheResetTests(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory(prefix='cache-reset-synthetic-')
        self.addCleanup(self.temporary.cleanup)
        self.base = Path(self.temporary.name).resolve()

    def session(self, client='wechat'):
        root = self.base / client / 'profile'
        source = self.base / client / 'original'
        source.mkdir(parents=True)
        (source / 'keep.txt').write_text('original')
        session = DesktopSession(root, client=client)
        session._save({'sourceRoot': str(source)})
        for name in CACHE_ENTRIES[1:]:
            (root / name).mkdir()
            (root / name / 'private.txt').write_text('synthetic cached content')
        (root / 'exports').mkdir()
        (root / 'exports/keep.json').write_text('exported')
        (root / 'unrelated.txt').write_text('preserve')
        return session, source

    def test_each_client_reset_preserves_originals_exports_and_other_client(self):
        for client in ('wechat', 'wecom'):
            with self.subTest(client=client):
                session, source = self.session(client)
                other = self.base / ('other-' + client)
                other.mkdir()
                (other / 'settings.local.json').write_text('other profile')
                session.groups = [{'id':'synthetic-group'}]
                session._live_account_names = {'synthetic':{'accountNickname':'cached name'}}
                result = session.clear_account_cache()
                self.assertTrue(result['ok'])
                self.assertFalse(any((session.directory / name).exists() for name in CACHE_ENTRIES))
                self.assertEqual((session.directory / 'exports/keep.json').read_text(), 'exported')
                self.assertEqual((session.directory / 'unrelated.txt').read_text(), 'preserve')
                self.assertEqual((source / 'keep.txt').read_text(), 'original')
                self.assertTrue((other / 'settings.local.json').exists())
                self.assertFalse(session.settings or session.groups or session._live_account_names)
                self.assertIsNone(session.archive)
                self.assertTrue((session.directory / RESET_MARKER).is_file())

    def test_reset_survives_restart_and_prevents_legacy_or_workbench_restore(self):
        session, _ = self.session()
        session.clear_account_cache()
        # Another old window writing its settings must not reselect an old account.
        session.settings_path.write_text(json.dumps({'version':1,'source':{'sourceRoot':'old'}}))
        workbench = self.base / 'workbench.json'
        workbench.write_text('{}')
        reloaded = DesktopSession(session.directory, workbench)
        with patch('offline_profiles.legacy_settings') as legacy, patch.object(reloaded, 'open_workbench') as old:
            result = reloaded.bootstrap()
        self.assertEqual(result['status'], 'needs_source')
        self.assertTrue(result['message'].startswith('首次使用'))
        self.assertFalse(reloaded.settings)
        legacy.assert_not_called()
        old.assert_not_called()

    def test_new_valid_configuration_replaces_reset_marker(self):
        from test_wecom_archive import fixture
        session, _ = self.session('wecom')
        session.clear_account_cache()
        source = self.base / 'new-account/Data'
        source.parent.mkdir()
        fixture(source)
        result = session.open_source({'sourceRoot':str(source),'selfId':'11'})
        self.assertEqual(result['status'], 'ready')
        self.assertFalse((session.directory / RESET_MARKER).exists())
        self.assertEqual(DesktopSession(session.directory, client='wecom').settings['source']['sourceRoot'], str(source))

    def test_cache_link_to_original_data_refuses_before_any_mutation(self):
        session, source = self.session()
        link = session.directory / 'views/external'
        if os.name == 'nt':
            import _winapi
            _winapi.CreateJunction(str(source), str(link))
        else:
            link.symlink_to(source, target_is_directory=True)
        self.addCleanup(lambda: link.rmdir() if os.name == 'nt' and link.exists() else link.unlink(missing_ok=True))
        before = session.settings_path.read_bytes()
        with self.assertRaises(ArchiveError):
            session.clear_account_cache()
        self.assertEqual(session.settings_path.read_bytes(), before)
        self.assertEqual((source / 'keep.txt').read_text(), 'original')
        self.assertFalse((session.directory / RESET_MARKER).exists())

    def test_source_overlapping_cache_is_never_deleted(self):
        session, _ = self.session()
        source = session.directory / 'views/source'
        source.mkdir()
        (source / 'keep.txt').write_text('original')
        session._save({'sourceRoot':str(source)})
        with self.assertRaises(ArchiveError):
            session.clear_account_cache()
        self.assertEqual((source / 'keep.txt').read_text(), 'original')
        self.assertTrue(session.settings_path.exists())

    def test_partial_failure_is_reported_and_can_be_retried(self):
        import shutil
        session, _ = self.session()
        remove = shutil.rmtree
        def locked(path):
            if path.name == 'keys':
                raise PermissionError('synthetic lock')
            remove(path)
        with patch('offline_profiles.shutil.rmtree', side_effect=locked):
            result = session.clear_account_cache()
        self.assertFalse(result['ok'])
        self.assertEqual(result['remaining'], ['keys'])
        self.assertFalse(session.settings)
        self.assertTrue((session.directory / 'exports/keep.json').exists())
        self.assertTrue(session.clear_account_cache()['ok'])

    def test_foreign_client_configuration_is_not_cleared(self):
        session, _ = self.session('wecom')
        session.settings['client'] = 'wechat'
        before = session.settings_path.read_bytes()
        with self.assertRaises(ArchiveError):
            session.clear_account_cache()
        self.assertEqual(session.settings_path.read_bytes(), before)


if __name__ == '__main__':
    unittest.main()
