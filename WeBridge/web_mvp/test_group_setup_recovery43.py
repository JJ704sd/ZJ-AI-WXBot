"""Setup failures must not erase usable sessions; all sources are synthetic."""
import errno
import json
from pathlib import Path
import tempfile
import tkinter as tk
import unittest
from unittest.mock import patch

from database_snapshot import SnapshotError
from offline_chat import ArchiveError
from offline_desktop import DesktopSession
from offline_review import REVIEW_CHECKS
from test_offline_multiselect import multi_group_fixture


class GroupSetupRecovery43Tests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix='synthetic-group43-setup-')
        self.addCleanup(self.temp.cleanup)
        self.base = Path(self.temp.name)

    def prepared(self, client, suffix=''):
        base = self.base / (client + suffix)
        base.mkdir()
        chats = multi_group_fixture(base / 'source', client)
        session = DesktopSession(base / 'profile', client=client)
        session.open_source({'sourceRoot': str(base / 'source'), 'includeMedia': False})
        for chat in chats:
            parsed = session.prepare_review(chat, copy_media=False)
            session.approve_review(parsed['review']['reviewId'], {key: True for key in REVIEW_CHECKS}, chat=chat)
        session.export_reviewed([chats[0]])
        session.remember_selection(chats, chats[1])
        session.activate_review(chats[1])
        return session, chats

    def remembered(self, session):
        return (session.archive, dict(session.groups[0]), session.settings_path.read_bytes(),
                session._progress.path.read_bytes(), session.pending_review,
                dict(session.views), dict(session._exports), dict(session._reviews))

    def assert_preserved(self, session, chats, before):
        self.assertIs(session.archive, before[0])
        self.assertEqual(session.groups[0], before[1])
        self.assertEqual(session.settings_path.read_bytes(), before[2])
        self.assertEqual(session._progress.path.read_bytes(), before[3])
        self.assertIs(session.pending_review, before[4])
        self.assertEqual(session.views, before[5])
        self.assertEqual(session._exports, before[6])
        self.assertEqual(session._reviews, before[7])
        self.assertEqual([session.review_status(chat) for chat in chats], ['已导出', '已复核'])
        resumed = DesktopSession(session.directory, client=session.client)
        info = resumed.bootstrap(resume=True)
        self.assertEqual((info['restoredReviews'], info['restoredPublished']), (1, 1))
        result = session.export_reviewed([chats[1]])
        self.assertEqual(len(result['exports']), 1)

    def test_invalid_source_keeps_review_export_and_restart_checkpoint(self):
        for client in ('wechat', 'wecom'):
            with self.subTest(client=client):
                session, chats = self.prepared(client)
                before = self.remembered(session)
                with self.assertRaises((OSError, ValueError)):
                    session.open_source({'sourceRoot': str(self.base / 'missing-source')})
                self.assert_preserved(session, chats, before)

    def test_failed_settings_save_keeps_previous_source_and_all_results(self):
        for client in ('wechat', 'wecom'):
            with self.subTest(client=client):
                session, chats = self.prepared(client)
                next_source = self.base / client / 'other-source'
                multi_group_fixture(next_source, client)
                before = self.remembered(session)
                with patch.object(session, '_save', side_effect=PermissionError('synthetic settings failure')):
                    with self.assertRaises(PermissionError):
                        session.open_source({'sourceRoot': str(next_source)})
                self.assert_preserved(session, chats, before)

    def test_invalid_import_keeps_previous_source_and_all_results(self):
        for client in ('wechat', 'wecom'):
            with self.subTest(client=client):
                session, chats = self.prepared(client)
                before = self.remembered(session)
                with self.assertRaises((OSError, ValueError)):
                    session.import_settings(self.base / 'missing-settings.json')
                self.assert_preserved(session, chats, before)

    def test_import_probe_and_failed_publish_keep_existing_checkpoint(self):
        for client in ('wechat', 'wecom'):
            with self.subTest(client=client):
                session, chats = self.prepared(client)
                candidate = self.base / client / 'legacy' / 'settings.local.json'
                candidate.parent.mkdir()
                candidate.write_text(json.dumps(session.settings), encoding='utf8')
                before = self.remembered(session)
                with patch.object(DesktopSession, '_save', side_effect=PermissionError('synthetic publish failure')):
                    with self.assertRaises(PermissionError):
                        session.import_settings(candidate)
                self.assert_preserved(session, chats, before)

    def test_import_probe_failure_preserves_active_review_and_checkpoint(self):
        for client in ('wechat', 'wecom'):
            with self.subTest(client=client):
                session, chats = self.prepared(client)
                candidate = self.base / client / 'legacy' / 'settings.local.json'
                candidate.parent.mkdir()
                value = {**session.settings, 'source': {'sourceRoot': str(self.base / 'missing-source')}}
                candidate.write_text(json.dumps(value), encoding='utf8')
                before = self.remembered(session)
                with self.assertRaises((OSError, ValueError)):
                    session.import_settings(candidate)
                self.assert_preserved(session, chats, before)

    def test_checkpoint_clear_failure_restores_old_settings_for_load_and_import(self):
        for operation in ('load', 'import'):
            for client in ('wechat', 'wecom'):
                with self.subTest(operation=operation, client=client):
                    # Each attempt has an independent profile and frozen source.
                    original_base = self.base
                    self.base = original_base / operation
                    self.base.mkdir(exist_ok=True)
                    session, chats = self.prepared(client)
                    source = self.base / client / 'other-source'
                    multi_group_fixture(source, client)
                    candidate = self.base / client / 'legacy' / 'settings.local.json'
                    candidate.parent.mkdir()
                    candidate.write_text(json.dumps({'version': 1, 'client': client,
                        'source': {'sourceRoot': str(source)}}), encoding='utf8')
                    before = self.remembered(session)
                    with patch.object(session._progress, 'clear', side_effect=ArchiveError('synthetic clear failure')):
                        with self.assertRaises(ArchiveError):
                            session.open_source({'sourceRoot': str(source)}) if operation == 'load' else session.import_settings(candidate)
                    self.assert_preserved(session, chats, before)
                    self.base = original_base

    def test_failed_settings_rollback_is_reported_and_keeps_current_session_usable(self):
        import os
        session, chats = self.prepared('wechat')
        source = self.base / 'wechat' / 'other-source'
        multi_group_fixture(source, 'wechat')
        before = self.remembered(session)
        replace = os.replace
        def fail_rollback(source_path, target):
            if Path(source_path).name.startswith('.settings-restore-'):
                raise PermissionError('synthetic rollback failure')
            return replace(source_path, target)
        with patch.object(session._progress, 'clear', side_effect=ArchiveError('synthetic clear failure')):
            with patch('offline_desktop.os.replace', side_effect=fail_rollback):
                with self.assertRaisesRegex(ArchiveError, '设置未能恢复'):
                    session.open_source({'sourceRoot': str(source)})
        self.assertIs(session.archive, before[0])
        self.assertEqual(session._progress.path.read_bytes(), before[3])
        self.assertIs(session.pending_review, before[4])
        self.assertEqual(session._reviews, before[7])

    def test_successful_source_switch_invalidates_old_approvals(self):
        for client in ('wechat', 'wecom'):
            with self.subTest(client=client):
                session, chats = self.prepared(client)
                source = self.base / client / 'other-source'
                multi_group_fixture(source, client)
                info = session.open_source({'sourceRoot': str(source)})
                self.assertEqual(info['status'], 'ready')
                self.assertFalse(session._progress.path.exists())
                self.assertEqual(session._reviews, {})
                self.assertEqual(session._exports, {})
                self.assertEqual(session.views, {})
                self.assertEqual(session.settings['source']['sourceRoot'], str(source.resolve()))

    def test_plaintext_with_stale_key_reference_loads_without_process_access(self):
        for client, module in (('wechat', 'portable_key_recovery'), ('wecom', 'wecom_key_recovery')):
            with self.subTest(client=client):
                source = self.base / client
                multi_group_fixture(source, client)
                session = DesktopSession(self.base / (client + '-profile'), client=client)
                with patch(module + '.recover_key_file') as recover:
                    value = session.automatic_setup({'sourceRoot': str(source),
                                                     'keyFile': str(self.base / 'missing-key.json')},
                                                    allow_process_read=True)
                self.assertEqual(value['status'], 'ready')
                recover.assert_not_called()
                self.assertEqual(session.settings['source']['keyFile'], '')

    def test_output_io_errors_are_not_treated_as_missing_decryption_keys(self):
        for number, error in enumerate((PermissionError('synthetic denied'),
                                        OSError(errno.ENOSPC, 'synthetic disk full'))):
            with self.subTest(error=type(error).__name__):
                session = DesktopSession(self.base / ('profile-' + str(number)))
                with patch.object(session, 'open_source', side_effect=error):
                    with patch('portable_key_recovery.recover_key_file') as recover:
                        result = session.automatic_setup({'sourceRoot': str(self.base / 'source')},
                                                         allow_process_read=True)
                self.assertEqual(result['status'], 'needs_source')
                recover.assert_not_called()
                self.assertIn('空间' if error.errno == errno.ENOSPC else '访问', result['message'])

    def test_automatic_commit_failure_keeps_review_and_does_not_read_process(self):
        session, chats = self.prepared('wechat')
        before = self.remembered(session)
        with patch.object(session._progress, 'clear', side_effect=ArchiveError('synthetic checkpoint failure')):
            with patch('portable_key_recovery.recover_key_file') as recover:
                result = session.automatic_setup(session.settings['source'], allow_process_read=True)
        self.assertEqual(result['status'], 'needs_source')
        self.assertIn('checkpoint', result['message'])
        recover.assert_not_called()
        self.assert_preserved(session, chats, before)

    def test_real_snapshot_copy_io_failure_never_triggers_process_key_scan(self):
        for number, error in enumerate((PermissionError('synthetic denied'),
                                        OSError(errno.ENOSPC, 'synthetic disk full'))):
            with self.subTest(error=type(error).__name__):
                session, chats = self.prepared('wechat', str(number))
                before = self.remembered(session)
                with patch('database_snapshot._copy_file', side_effect=error):
                    with patch('portable_key_recovery.recover_key_file', side_effect=ArchiveError('synthetic process must not be read')) as recover:
                        result = session.automatic_setup(session.settings['source'], allow_process_read=True)
                self.assertEqual(result['status'], 'needs_source')
                self.assertIn('磁盘空间', result['message'])
                recover.assert_not_called()
                self.assert_preserved(session, chats, before)

    def workbench(self):
        root = self.base / 'workbench'
        snapshot = root / 'database-snapshots' / 'synthetic-snapshot'
        snapshot.parent.mkdir(parents=True)
        multi_group_fixture(snapshot, 'wechat')
        path = root / 'database-config.json'
        path.write_text(json.dumps({'snapshotRoot': str(snapshot),
            'config': {'sourceRoot': str(self.base / 'unavailable-live-source'), 'includeMedia': False}}), encoding='utf8')
        return path

    def test_workbench_fallback_success_replaces_old_review_scope(self):
        session, chats = self.prepared('wechat')
        exported = session._exports[chats[0]]
        result = session.open_workbench(self.workbench())
        self.assertEqual(result['status'], 'ready')
        self.assertIn('既有副本', result['message'])
        self.assertFalse(session._progress.path.exists())
        self.assertEqual(session._reviews, {})
        self.assertEqual(session._exports, {})
        self.assertEqual(session.views, {})
        self.assertTrue(exported.is_dir())

    def test_workbench_fallback_failure_keeps_previous_session_exportable(self):
        session, chats = self.prepared('wechat')
        before = self.remembered(session)
        with patch('database_snapshot._copy_file', side_effect=PermissionError('synthetic fallback failure')):
            with self.assertRaises(SnapshotError):
                session.open_workbench(self.workbench())
        self.assert_preserved(session, chats, before)

    def test_wechat_voice_selection_is_forwarded_to_recovery(self):
        session = DesktopSession(self.base / 'profile')
        with patch.object(session, 'open_source', side_effect=SnapshotError('synthetic missing keys')):
            with patch('portable_key_recovery.recover_key_file', side_effect=ArchiveError('synthetic recovery stop')) as recover:
                session.automatic_setup({'sourceRoot': str(self.base / 'source'), 'includeVoice': True},
                                        allow_process_read=True)
        self.assertTrue(recover.call_args.kwargs['include_voice'])


class GroupSetupUI43Tests(unittest.TestCase):
    def test_manual_recovery_forwards_explicit_voice_choice(self):
        from local_chat_app import ChatApp
        with tempfile.TemporaryDirectory(prefix='synthetic-group43-voice-ui-') as folder:
            root = tk.Tk()
            app = ChatApp(root, DesktopSession(folder))
            try:
                for token in root.tk.call('after', 'info'):
                    root.after_cancel(token)
                def walk(parent):
                    yield parent
                    for child in parent.winfo_children():
                        yield from walk(child)
                def run(label, function, callback):
                    with self.assertRaises(ArchiveError):
                        function()
                for voice in (False, True):
                    app.pending_config = {'sourceRoot': str(Path(folder) / 'source'),
                                          'includeVoice': voice, 'includeMedia': False}
                    app.source_settings(accounts=[], manual=True)
                    root.update()
                    button = next(w for w in walk(app.source_dialog) if w.winfo_class() == 'TButton'
                                  and str(w.cget('text')).startswith('没有密钥'))
                    with patch('portable_key_recovery.recover_key_file', side_effect=ArchiveError('synthetic stop')) as recover:
                        with patch.object(app, 'work', side_effect=run):
                            button.invoke()
                    self.assertEqual(recover.call_args.kwargs['include_voice'], voice)
                    app.close_source_settings()
            finally:
                app.close_source_settings()
                root.destroy()

    def test_manual_save_is_visible_and_receives_pointer_instead_of_import(self):
        from local_chat_app import ChatApp
        with tempfile.TemporaryDirectory(prefix='synthetic-group43-setup-ui-') as folder:
            root = tk.Tk()
            app = ChatApp(root, DesktopSession(folder))
            try:
                for token in root.tk.call('after', 'info'):
                    root.after_cancel(token)
                app.source_settings(accounts=[], manual=True)
                root.update()
                def walk(parent):
                    yield parent
                    for child in parent.winfo_children():
                        yield from walk(child)
                buttons = {str(w.cget('text')): w for w in walk(app.source_dialog)
                           if w.winfo_class() == 'TButton'}
                for label in ('保存并加载', '导入旧版配置…'):
                    widget = buttons[label]
                    self.assertTrue(widget.winfo_ismapped())
                    hit = root.winfo_containing(widget.winfo_rootx() + widget.winfo_width() // 2,
                                                widget.winfo_rooty() + widget.winfo_height() // 2)
                    self.assertIs(hit, widget, label)
            finally:
                app.close_source_settings()
                root.destroy()


if __name__ == '__main__':
    unittest.main()
