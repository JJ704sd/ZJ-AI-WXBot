"""Report cancellation and busy-state feedback through the real desktop callback."""
import tkinter as tk
import unittest
from unittest.mock import patch

import test_private_profiles as fixtures
from local_chat_app import ChatApp
from offline_desktop import DesktopSession
from private_insights import summarize
from private_insights_ui import show_insights


class ReportSubmissionTests(unittest.TestCase):
    setUp = fixtures.PrivateProfileFixture.setUp
    tearDown = fixtures.PrivateProfileFixture.tearDown

    def test_cancelled_or_busy_save_is_not_reported_as_submitted(self):
        root = tk.Tk()
        def cleanup():
            for token in root.tk.call('after', 'info'):
                root.after_cancel(token)
            root.destroy()
        self.addCleanup(cleanup)
        app = ChatApp(root, DesktopSession(self.base / 'desktop', conversation_mode='direct'))
        for token in root.tk.call('after', 'info'):
            root.after_cancel(token)
        source = self.store.inspect_export(self.export)
        window = show_insights(source, summarize(source), parent=root,
            save_report=lambda report: app.save_private_report(report, self.export))
        controller = window._private_insights_controller
        self.addCleanup(controller.close)
        with patch('local_chat_app.filedialog.askdirectory', return_value='') as picker:
            controller.save_button.invoke()
            picker.assert_called_once()
            self.assertNotIn('已提交', controller.search_status.cget('text'))
            self.assertIn('未提交', controller.search_status.cget('text'))
        app.busy = True
        with patch('local_chat_app.filedialog.askdirectory') as picker:
            controller.save_button.invoke()
            picker.assert_not_called()
            self.assertNotIn('已提交', controller.search_status.cget('text'))
            self.assertIn('等待', app.status.get())
        app.busy = False
        controller.close()


if __name__ == '__main__':
    unittest.main()
