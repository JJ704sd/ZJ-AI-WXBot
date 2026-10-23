"""Chosen-directory publication and recovery using invented records only."""
import json
from pathlib import Path
import tempfile
import tkinter as tk
import time
import unittest
from unittest.mock import patch

from offline_chat import ArchiveError
from offline_desktop import DesktopSession
from offline_review import REVIEW_CHECKS, inventory
from test_offline_multiselect import multi_group_fixture
from test_windows_media import PNG


class ExportLocation45Tests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix='synthetic-export45-')
        self.addCleanup(self.temp.cleanup)
        self.base = Path(self.temp.name).resolve()

    def prepared(self, client):
        base = self.base / client
        base.mkdir()
        chats = multi_group_fixture(base / 'source', client)
        session = DesktopSession(base / 'profile', client=client)
        session.open_source({'sourceRoot': str(base / 'source')})
        for chat in chats:
            value = session.prepare_review(chat, copy_media=False)
            pending = session._reviews[chat]
            asset = pending['root'] / 'assets' / 'synthetic-original.png'
            asset.parent.mkdir(exist_ok=True)
            asset.write_bytes(PNG)
            pending['files'] = inventory(pending['root'])
            session.approve_review(value['review']['reviewId'], {k: True for k in REVIEW_CHECKS}, chat=chat)
        session.remember_selection(chats)
        folder = base / '自选导出 含空格'
        folder.mkdir()
        session.set_export_directory(folder)
        return session, chats, folder

    def test_both_clients_publish_remember_restore_repair_and_save_copy(self):
        for client in ('wechat', 'wecom'):
            with self.subTest(client=client):
                session, chats, folder = self.prepared(client)
                result = session.export_reviewed(chats)
                self.assertEqual(result['state'], 'completed')
                self.assertEqual(Path(result['output']).parent, folder)
                self.assertEqual(json.loads(session._progress.path.read_text(encoding='utf8'))['version'], 2)
                original = {}
                for item in result['exports']:
                    target = Path(item['output'])
                    self.assertEqual((target / 'assets/synthetic-original.png').read_bytes(), PNG)
                    self.assertEqual(json.loads((target / 'messages.json').read_text(encoding='utf8')),
                        [json.loads(line) for line in (target / 'messages.jsonl').read_text(encoding='utf8').splitlines()])
                    self.assertTrue((target / 'messages.md').is_file())
                    original[item['output']] = inventory(target)
                other = folder.parent / '第二个位置'
                other.mkdir()
                session.set_export_directory(other)
                resumed = DesktopSession(session.directory, client=client)
                self.assertEqual(resumed.export_directory, other)
                restored = resumed.bootstrap(resume=True)
                self.assertEqual(restored['restoredPublished'], 2)
                self.assertEqual(resumed.repair_export_metadata(result['output'])['state'], 'completed')
                checkpoint = resumed._progress.path.read_bytes()
                copied = resumed.save_export_copy(chats[0])
                self.assertEqual(Path(copied['output']).parent, other)
                self.assertEqual((Path(copied['output']) / 'assets/synthetic-original.png').read_bytes(), PNG)
                self.assertEqual(resumed._progress.path.read_bytes(), checkpoint)
                for path, before in original.items():
                    self.assertEqual(inventory(path), before)
                parsed = resumed.prepare_review(chats[0], copy_media=False)
                resumed.approve_review(parsed['review']['reviewId'], {k: True for k in REVIEW_CHECKS}, chat=chats[0])
                latest = resumed.export_reviewed([chats[0]])
                again = DesktopSession(session.directory, client=client)
                again.bootstrap(resume=True)
                self.assertEqual(again.last_batch_root, Path(latest['output']))

    def test_partial_external_export_restores_failed_review_and_completed_group(self):
        for client in ('wechat', 'wecom'):
            with self.subTest(client=client):
                session, chats, folder = self.prepared(client)
                from offline_review import publish_review
                calls = 0
                def publish(pending, output):
                    nonlocal calls
                    calls += 1
                    if calls == 2:
                        raise OSError('synthetic unavailable destination')
                    return publish_review(pending, output)
                with patch('offline_review.publish_review', side_effect=publish):
                    result = session.export_reviewed(chats)
                self.assertEqual((result['state'], len(result['exports']), len(result['failed'])), ('partial', 1, 1))
                resumed = DesktopSession(session.directory, client=client)
                ready = resumed.bootstrap(resume=True)
                self.assertEqual((ready['restoredPublished'], ready['restoredReviews']), (1, 1))
                self.assertEqual(resumed.repair_export_metadata(result['output'])['state'], 'partial')
                retried = resumed.export_reviewed(chats)
                self.assertEqual((retried['state'], len(retried['alreadyExported']), len(retried['exports'])), ('completed', 1, 1))
                self.assertEqual(Path(retried['output']).parent, folder)

    def test_source_and_unselected_destinations_are_rejected(self):
        session, chats, folder = self.prepared('wechat')
        saved = session.settings_path.read_bytes()
        with self.assertRaises(ArchiveError):
            session.set_export_directory(session.archive.media_config['sourceRoot'])
        self.assertEqual(session.settings_path.read_bytes(), saved)
        with self.assertRaises(ValueError):
            session._progress.export_path({'exportRoot': str(folder.parent), 'exportTarget': 'outside/group'})
        with self.assertRaises(ValueError):
            session._progress.export_path({'exportRoot': str(folder), 'exportTarget': '../outside/group'})


class ExportLocationUI45Tests(unittest.TestCase):
    def test_cancel_and_choose_folder_use_real_settings_without_exporting(self):
        from local_chat_app import ChatApp
        with tempfile.TemporaryDirectory(prefix='synthetic-export45-ui-') as temporary:
            base = Path(temporary).resolve()
            multi_group_fixture(base / 'source', 'wechat')
            session = DesktopSession(base / 'profile')
            session.open_source({'sourceRoot': str(base / 'source')})
            root = tk.Tk()
            root.withdraw()
            app = ChatApp(root, session)
            for token in root.tk.call('after', 'info'):
                root.after_cancel(token)
            app.ready(session.ready_info())
            root.after(1, app._drain)
            original = session.settings_path.read_bytes()
            folder = base / 'chosen'
            folder.mkdir()
            try:
                with patch('local_chat_app.filedialog.askdirectory', return_value=''):
                    app.choose_export_directory()
                self.assertEqual(session.settings_path.read_bytes(), original)
                with patch('local_chat_app.filedialog.askdirectory', return_value=str(folder)):
                    app.choose_export_directory()
                deadline = time.monotonic() + 8
                while app.busy:
                    self.assertLess(time.monotonic(), deadline)
                    root.update()
                    time.sleep(.005)
                self.assertEqual(app.export_directory_text.get(), str(folder))
                self.assertEqual(DesktopSession(session.directory).export_directory, folder)
                self.assertFalse(list(folder.iterdir()))
            finally:
                for token in root.tk.call('after', 'info'):
                    root.after_cancel(token)
                root.destroy()


if __name__ == '__main__':
    unittest.main()
