"""Real Tk geometry and truthful export feedback using isolated synthetic state."""
import tempfile
import tkinter as tk
import unittest
from pathlib import Path
from unittest.mock import patch

from local_chat_app import ChatApp
from offline_desktop import DesktopSession


class PrivateMainDesign17Tests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix='private17-main-')
        self.root = tk.Tk()
        self.app = ChatApp(self.root, DesktopSession(self.temp.name, conversation_mode='direct'))
        for token in self.root.tk.call('after', 'info'):
            self.root.after_cancel(token)

    def tearDown(self):
        self.root.destroy()
        self.temp.cleanup()

    def inside(self, widget):
        self.assertTrue(widget.winfo_ismapped())
        self.assertGreaterEqual(widget.winfo_rootx(), self.root.winfo_rootx())
        self.assertGreaterEqual(widget.winfo_rooty(), self.root.winfo_rooty())
        self.assertLessEqual(widget.winfo_rootx() + widget.winfo_width(),
                             self.root.winfo_rootx() + self.root.winfo_width() + 1)
        self.assertLessEqual(widget.winfo_rooty() + widget.winfo_height(),
                             self.root.winfo_rooty() + self.root.winfo_height() + 1)

    def test_long_contact_and_saved_location_keep_actions_visible_at_small_size(self):
        self.root.geometry('1000x700')
        full_name = '合成设计测试联系人' * 12
        self.app.chat_title.set(full_name)
        self.app.session.last_export = Path(self.temp.name) / 'exports' / 'synthetic'
        self.app.batch_output = self.app.session.last_export.parent
        self.app.result_text.set('保存位置：' + str(self.app.session.last_export))
        self.app.update_buttons()
        self.root.update()
        self.assertEqual(self.app.chat_title.get(), full_name)
        self.assertTrue(self.app.private_chat_display.get().endswith('…'))
        for show_identity in (True, False):
            self.app.toggle_private_identity()
            for show_dates in (True, False):
                self.app.toggle_date_filters(show_dates)
                self.root.update()
                self.assertEqual(bool(self.app.private_identity_line.winfo_manager()), show_identity)
                for widget in (self.app.export_button, self.app.review_button, self.app.folder_button,
                               self.app.private_library_button, self.app.private_candidate_button,
                               self.app.file_row, self.app.repair_metadata_button, self.app.footer):
                    self.inside(widget)
                panel, browser = self.app.private_empty_panel, self.app.browser
                if browser.winfo_height() < 90:
                    self.assertFalse(panel.winfo_ismapped())
                else:
                    self.assertTrue(panel.winfo_ismapped())
                    self.assertGreaterEqual(panel.winfo_y(), 0)
                    self.assertLessEqual(panel.winfo_y() + panel.winfo_height(), browser.winfo_height())
        self.assertGreater(self.app.browser.winfo_height(), 100)

    def test_metadata_failure_keeps_success_distinct_and_offers_repair(self):
        output = Path(self.temp.name) / 'exports' / 'synthetic-batch'
        value = {'exports': [], 'failed': [], 'alreadyExported': [{'chatId': 'synthetic-peer'}],
                 'output': str(output), 'metadataComplete': False,
                 'metadataErrors': [{'file': 'batch.json', 'error': '合成磁盘写入失败'}]}
        with patch.object(self.app, 'sync_review_states'):
            self.app.batch_export_ready(value)
        self.root.update()
        self.assertIn('正文已保存', self.app.status.get())
        self.assertIn('修复导出清单', self.app.status.get())
        self.assertNotIn('复核记录与缺口说明已保存', self.app.status.get())
        self.assertTrue(self.app.repair_metadata_button.instate(['!disabled']))
        self.assertTrue(self.app.folder_button.instate(['!disabled']))
        with patch.object(self.app, 'work') as work:
            self.app.repair_metadata_button.invoke()
            callback = work.call_args.args[2]
            callback({'output': str(output), 'metadataComplete': True, 'metadataErrors': [],
                      'failed': [{'chatId': 'synthetic-unfinished'}]})
        self.assertIn('正文保持原样', self.app.status.get())
        self.assertIn('1 个会话未导出', self.app.status.get())

    def test_ready_restores_completed_exports_and_saved_location(self):
        from test_private_chat_integration import direct_source
        from offline_review import REVIEW_CHECKS
        source, chat, self_id = direct_source(Path(self.temp.name), 'wechat')
        profile = Path(self.temp.name) / 'profile'
        session = DesktopSession(profile, conversation_mode='direct')
        session.open_source({'sourceRoot': str(source), 'selfId': self_id})
        parsed = session.prepare_review(chat, copy_media=False)
        session.approve_review(parsed['review']['reviewId'],
                               {key: True for key in REVIEW_CHECKS}, chat=chat)
        result = session.export_reviewed([chat])
        self.app.session = DesktopSession(profile, conversation_mode='direct')
        info = self.app.session.bootstrap(resume=True)
        self.assertEqual(info['restoredReviews'], 0)
        self.assertEqual(info['restoredPublished'], 1)
        with patch.object(self.app, 'work',
                          side_effect=lambda label, load, done, **_: done(load())):
            self.app.ready(info)
        self.root.update()
        self.assertIn(chat, self.app.parsed_results)
        self.assertEqual(self.app.batch_output, Path(result['output']))
        self.assertIn(str(self.app.batch_output), self.app.result_text.get())
        self.assertTrue(self.app.folder_button.instate(['!disabled']))

    def test_desktop_reparse_failure_preserves_review_and_reading_result(self):
        from test_private_chat_integration import direct_source
        from offline_review import REVIEW_CHECKS
        source, chat, self_id = direct_source(Path(self.temp.name), 'wechat')
        session = self.app.session
        info = session.open_source({'sourceRoot': str(source), 'selfId': self_id})
        original = session.prepare_review(chat, copy_media=False)
        session.approve_review(original['review']['reviewId'],
                               {key: True for key in REVIEW_CHECKS}, chat=chat)
        self.app.groups = info['groups']
        self.app.parsed_results[chat] = original
        self.app.parse_states[chat] = '已复核'
        self.app.render_groups()
        self.app.show_chat(chat)
        def work(label, load, done, **options):
            try:
                done(load())
            except OSError:
                options['on_error']('合成解析失败')
        with patch.object(session, 'prepare_review', side_effect=OSError('synthetic failure')):
            with patch.object(self.app, 'work', side_effect=work):
                self.app.start_batch([chat])
                self.root.update()
        self.assertEqual(session.review_status(chat), '已复核')
        self.assertIs(self.app.parsed_results[chat], original)
        self.assertEqual(self.app.parse_states[chat], '已复核')
        self.assertIn('保留上次结果', self.app.parse_errors[chat])
        resumed = DesktopSession(self.temp.name, conversation_mode='direct')
        self.assertEqual(resumed.bootstrap(resume=True)['restoredReviews'], 1)
        self.assertEqual(resumed.review_status(chat), '已复核')


if __name__ == '__main__':
    unittest.main()
