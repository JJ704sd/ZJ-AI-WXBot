"""Small-window layout contracts for synthetic private-chat surfaces."""
import gc
import tempfile
import tkinter as tk
import unittest

from offline_desktop import DesktopSession
from private_insights import summarize
from private_insights_ui import show_insights
from test_private_insights_native import source_fixture


class PrivateLayoutTests(unittest.TestCase):
    def setUp(self):
        self.root = tk.Tk()

    def tearDown(self):
        self.root.destroy()
        self.root = None
        gc.collect()

    def assert_visible_inside(self, widget, window):
        self.assertTrue(widget.winfo_ismapped(), str(widget))
        x = widget.winfo_rootx() - window.winfo_rootx()
        y = widget.winfo_rooty() - window.winfo_rooty()
        self.assertGreaterEqual(x, 0)
        self.assertGreaterEqual(y, 0)
        self.assertLessEqual(x + widget.winfo_width(), window.winfo_width() + 1)
        self.assertLessEqual(y + widget.winfo_height(), window.winfo_height() + 1)

    def test_main_small_window_and_open_date_filters(self):
        from local_chat_app import ChatApp
        with tempfile.TemporaryDirectory() as folder:
            app = ChatApp(self.root, DesktopSession(folder, conversation_mode='direct'))
            for token in self.root.tk.call('after', 'info'):
                self.root.after_cancel(token)
            self.root.geometry('1000x700')
            self.root.update()
            self.assertGreaterEqual(app.browser.winfo_height(), 220)
            for show in (False, True, False):
                app.toggle_date_filters(show)
                self.root.update()
                for widget in (app.export_button, app.review_button, app.private_candidate_button,
                               app.message_search_entry, app.date_toggle_button, app.footer):
                    self.assert_visible_inside(widget, self.root)
                if show:
                    self.assert_visible_inside(app.apply_date_button, self.root)
                    self.assert_visible_inside(app.clear_date_button, self.root)
            self.assertIn('联系人', app.browser.detail.get('1.0', 'end'))

    def test_insights_small_window_keeps_search_and_evidence_usable(self):
        source = source_fixture()
        window = show_insights(source, summarize(source), parent=self.root, save_report=lambda _:None)
        window.geometry('900x620')
        ui = window._private_insights_controller
        self.root.update()
        self.assertGreaterEqual(ui.trend_canvas.winfo_height(), 80)
        for canvas in (ui.trend_canvas, ui.hour_canvas):
            bounds = canvas.bbox('all')
            self.assertIsNotNone(bounds)
            self.assertLessEqual(bounds[3], canvas.winfo_height())
            self.assert_visible_inside(canvas, window)
            ancestor = canvas.master
            while ancestor is not window:
                self.assertLessEqual(canvas.winfo_rooty() + bounds[3],
                                     ancestor.winfo_rooty() + ancestor.winfo_height())
                ancestor = ancestor.master
        ui.notebook.select(2)
        self.root.update()
        self.assertGreaterEqual(ui.result_tree.winfo_height(), 80)
        self.assertGreaterEqual(ui.evidence_text.winfo_height(), 70)
        for widget in (ui.search_button, ui.next_button, ui.evidence_text, ui.save_button):
            self.assert_visible_inside(widget, window)
        ui.close()

    def test_private_theme_does_not_change_archive_palette(self):
        import offline_theme
        import private_theme
        palette = (offline_theme.CANVAS, offline_theme.ACCENT, offline_theme.BODY,
                   dict(offline_theme.StatusPill.TONES))
        private_theme.apply_theme(self.root)
        pill = offline_theme.StatusPill(self.root)
        private_theme.retheme_widgets(pill)
        self.assertEqual(palette, (offline_theme.CANVAS, offline_theme.ACCENT,
                                  offline_theme.BODY, dict(offline_theme.StatusPill.TONES)))
        self.assertEqual(pill.TONES['accent'][0], private_theme.ACCENT_TEXT)


if __name__ == '__main__':
    unittest.main()
