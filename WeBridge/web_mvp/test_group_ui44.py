"""Large-group desktop flow, using only temporary synthetic account data."""
import json
from pathlib import Path
import tempfile
import threading
import time
import tkinter as tk
from types import SimpleNamespace
import unittest
from unittest.mock import Mock, patch

from offline_desktop import DesktopSession
from local_chat_app import ChatApp
from test_offline_multiselect import multi_group_fixture


class GroupWorkflow44Tests(unittest.TestCase):
    def setUp(self):
        temporary = tempfile.TemporaryDirectory(prefix='synthetic-group44-flow-')
        self.addCleanup(temporary.cleanup)
        self.base = Path(temporary.name).resolve()

    def session(self, client, suffix=''):
        source = self.base / (client + suffix)
        chats = multi_group_fixture(source, client)
        session = DesktopSession(self.base / ('profile-' + client + suffix), client=client)
        session.open_source({'sourceRoot': str(source)})
        return session, chats

    def test_restart_keeps_unfinished_selection_from_the_same_source(self):
        for client in ('wechat', 'wecom'):
            for completed in (0, 1):
                with self.subTest(client=client, completed=completed):
                    session, chats = self.session(client, str(completed))
                    session.remember_selection(chats, chats[0])
                    if completed:
                        session.prepare_review(chats[0], copy_media=False)
                    self.assertTrue(session._progress.path.is_file())
                    saved = json.loads(session._progress.path.read_text(encoding='utf8'))
                    saved['ui']['selected'].append('not-in-current-source')
                    session._progress.path.write_text(json.dumps(saved), encoding='utf8')
                    resumed = DesktopSession(session.directory, client=client)
                    ready = resumed.bootstrap(resume=True)
                    self.assertEqual(ready['resumeSelection'], chats)
                    self.assertEqual(resumed.review_status(chats[0]), '待复核' if completed else '未解析')
                    self.assertEqual(resumed.review_status(chats[1]), '未解析')

    def test_background_parse_defers_reading_and_opens_the_saved_result(self):
        for client in ('wechat', 'wecom'):
            with self.subTest(client=client):
                session, chats = self.session(client)
                background = session.prepare_review(chats[0], copy_media=False, load_view=False)
                self.assertNotIn('messages', background['view'])
                self.assertNotIn(chats[0], session.views)
                with patch.object(session.archive, 'export', side_effect=AssertionError('reading reparsed source')):
                    page = session.preview(chats[0])
                self.assertEqual(page['viewRoot'], background['view']['viewRoot'])
                self.assertEqual(page['sourceTotal'], background['report']['exportedRows'])
                self.assertTrue(page['messages'])
                default = session.prepare_review(chats[1], copy_media=False)
                self.assertTrue(default['view']['messages'])

    def test_first_selection_reuses_the_snapshot_inventory_from_loading(self):
        for client in ('wechat', 'wecom'):
            with self.subTest(client=client):
                session, chats = self.session(client)
                with patch('offline_progress.inventory', side_effect=AssertionError('selection hashed the snapshot')):
                    session.remember_selection(chats)
                saved = json.loads(session._progress.path.read_text(encoding='utf8'))
                self.assertEqual(saved['reviews'], [])
                self.assertEqual(saved['ui']['selected'], chats)
                resumed = DesktopSession(session.directory, client=client)
                resumed.bootstrap(resume=True)
                with patch('offline_progress.inventory', side_effect=AssertionError('resumed selection hashed the snapshot')):
                    resumed.remember_selection(chats[:1])

    def test_both_clients_report_source_rows_then_save_the_review(self):
        for client in ('wechat', 'wecom'):
            with self.subTest(client=client):
                session, chats = self.session(client)
                events = []
                parsed = session.prepare_review(chats[0], copy_media=False, load_view=False,
                                                progress=events.append)
                self.assertEqual((events[0]['stage'], events[0]['processed']), ('parsing', 0))
                self.assertEqual((events[-1]['stage'], events[-1]['processed']),
                                 ('saving', parsed['report']['exportedRows']))
                self.assertIn('finalizing', [event['stage'] for event in events])
                self.assertNotIn('indexing', [event['stage'] for event in events])
                self.assertEqual({event['chatId'] for event in events}, {chats[0]})

    def test_source_check_failure_keeps_files_without_a_success_receipt(self):
        for check_report in (False, True):
            with self.subTest(check_report=check_report):
                app = object.__new__(ChatApp)
                app.parse_states, app.parsed_results = {}, {}
                app.active_chat, app.receipt_chat = None, 'synthetic'
                app.check_report, app.batch_output = check_report, None
                app.session = SimpleNamespace(conversation_mode='group', last_export=None)
                app.status, app.result_text = Mock(), Mock()
                app.render_groups, app.sync_review_states, app.update_buttons = Mock(), Mock(), Mock()
                app.publish_open, app.finish_check = Mock(), Mock()
                report = {'chat': {'id': 'synthetic', 'name': 'Synthetic group'}, 'businessRows': 1,
                          'exportedRows': 1, 'mediaSummary': {}, 'mediaSummaryText': '',
                          'mediaStatuses': {}, 'decodeStatuses': {}, 'reporting': {}}
                exported = {'report': report, 'output': 'synthetic/output', 'exportFiles': {},
                            'reporting': {}, 'humanReview': {}}
                app.batch_export_ready({'state': 'partial', 'exports': [exported], 'failed': [],
                    'alreadyExported': [], 'output': 'synthetic/batch', 'metadataComplete': False,
                    'metadataErrors': [{'file': 'source_snapshot', 'error': 'synthetic source changed'}]})
                self.assertEqual(app.parse_states['synthetic'], '已导出')
                self.assertEqual(app.batch_output, Path('synthetic/batch'))
                self.assertNotIn('completed', [call.args[0] for call in app.publish_open.call_args_list])
                self.assertEqual(app.publish_open.call_args.args[0], 'needs_source')
                self.assertIn('重新加载', app.status.set.call_args.args[0])
                self.assertNotIn('修复导出清单', app.status.set.call_args.args[0])
                self.assertFalse(any(call.args[0].get('ok') for call in app.finish_check.call_args_list))
                app.busy = app.read_busy = app.batch_running = app.closing = False
                repaired = {'output': 'synthetic/batch', 'metadataComplete': False,
                            'metadataErrors': [{'file': 'source_snapshot', 'error': 'synthetic source changed'}]}
                app.session.repair_export_metadata = Mock(return_value=repaired)
                app.work = lambda label, function, callback: callback(function())
                app.repair_export_metadata()
                self.assertIn('重新加载', app.status.set.call_args.args[0])
                self.assertNotIn('文件权限后重试', app.status.set.call_args.args[0])


class GroupNativeUI44Tests(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory(prefix='synthetic-group44-native-')
        self.base = Path(self.temporary.name).resolve()
        self.root = tk.Tk()
        self.root.withdraw()
        self.scale = self.root.tk.call('tk', 'scaling')

    def tearDown(self):
        for token in self.root.tk.call('after', 'info'):
            self.root.after_cancel(token)
        self.root.tk.call('tk', 'scaling', self.scale)
        self.root.destroy()
        self.temporary.cleanup()

    def pump(self, predicate):
        deadline = time.monotonic() + 8
        while not predicate():
            self.assertLess(time.monotonic(), deadline, 'synthetic UI timed out')
            self.root.update()
            time.sleep(.005)

    def test_parse_progress_and_saved_reading_work_during_the_next_group(self):
        chats = multi_group_fixture(self.base / 'source', 'wechat')
        session = DesktopSession(self.base / 'profile')
        session.open_source({'sourceRoot': str(self.base / 'source')})
        session.prepare_review(chats[0], copy_media=False, load_view=False)
        session.remember_selection(chats)
        resumed = DesktopSession(session.directory)
        ready = resumed.bootstrap(resume=True)
        ready['resumeActiveChat'] = None
        app = ChatApp(self.root, resumed)
        for token in self.root.tk.call('after', 'info'):
            self.root.after_cancel(token)
        app.ready(ready)
        self.root.after(1, app._drain)
        held, release = threading.Event(), threading.Event()
        original = resumed.archive.export

        def export(*args, progress=None, **kwargs):
            def report(event):
                if progress:
                    progress(event)
                if event['stage'] == 'parsing' and event['processed'] == 0:
                    held.set()
                    if not release.wait(10):
                        raise AssertionError('synthetic parser release timed out')
            return original(*args, progress=report, **kwargs)

        try:
            with patch.object(resumed.archive, 'export', side_effect=export) as exporter:
                app.copy_media.set(False)
                app.start_batch([chats[1]])
                self.pump(held.is_set)
                app.drain_export_progress()
                self.assertIn('已处理 0 条', app.status.get())
                self.assertTrue(app.busy)
                app.focus_chat(chats[0])
                self.pump(lambda: bool(app.browser.rows) and not app.read_busy)
                self.assertTrue(app.busy, 'reading must not complete the running parser')
                self.assertEqual(app.active_chat, chats[0])
                release.set()
                self.pump(lambda: not app.batch_running and not app.busy)
                self.assertNotIn('messages', app.parsed_results[chats[1]]['view'])
                self.assertNotIn(chats[1], resumed.views)
                app.focus_chat(chats[1])
                self.pump(lambda: bool(app.browser.rows) and not app.read_busy)
                self.assertEqual(exporter.call_count, 1, 'opening saved reading must not reparse')
        finally:
            release.set()
            self.pump(lambda: not app.busy and not app.read_busy)


if __name__ == '__main__':
    unittest.main()
