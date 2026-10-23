"""Synthetic UI recovery checks for the private profile and insights views."""
from __future__ import annotations

import time
import tkinter as tk
import unittest
from unittest.mock import patch

try:
    import private_insights_ui as insights_ui
    from private_insights_ui import show_insights
except ModuleNotFoundError:  # ``python -m unittest web_mvp.test_private_ui_recovery``
    from web_mvp import private_insights_ui as insights_ui
    from web_mvp.private_insights_ui import show_insights


def source():
    return {
        "identity": {"client": "wechat", "accountKey": "synthetic", "peerId": "peer-1"},
        "chat": {"id": "peer-1", "name": "合成联系人"},
        "timeRange": {"start": "2026-10-01", "end": "2026-10-01"},
        "analysisRefs": {"m1": 7},
        # Deliberately stale raw row ref: the UI must use the verified analysisRefs value.
        "messages": [{"id": "m1", "ref": 999, "time": "2026-10-01T09:00:00+08:00",
                      "senderName": "合成联系人", "direction": "incoming", "kind": "text",
                      "text": "合成原文证据"}],
    }


class PrivateUIRecoveryTests(unittest.TestCase):
    def setUp(self):
        self.root = tk.Tk()
        self.addCleanup(self.close_root)

    def close_root(self):
        for token in self.root.tk.call('after', 'info'):
            try:
                self.root.after_cancel(token)
            except tk.TclError:
                pass
        for child in list(self.root.winfo_children()):
            try:
                child.destroy()
            except tk.TclError:
                pass
        self.root.destroy()

    def pump(self, predicate, timeout=4):
        deadline = time.monotonic() + timeout
        while time.monotonic() < deadline:
            self.root.update()
            if predicate():
                return
            time.sleep(.01)
        self.fail('synthetic UI operation timed out')

    def test_search_failure_reenables_controls_and_can_retry(self):
        calls = []

        def search(*args, **kwargs):
            calls.append(len(calls))
            if len(calls) == 1:
                raise ValueError('合成搜索失败')
            return {'query': '原文', 'offset': 0, 'limit': 50, 'total': 1,
                    'items': [{'messageId': 'm1', 'ref': 7, 'time': '2026-10-01T09:00:00+08:00',
                               'senderName': '合成联系人', 'direction': 'incoming',
                               'kind': 'text', 'text': '合成原文证据'}]}

        with patch.object(insights_ui, 'search_messages', side_effect=search):
            window = show_insights(source(), {'counts': {'total': 1}, 'byDay': {}, 'byHour': {}},
                                   parent=self.root, save_report=lambda _: None)
            controller = window._private_insights_controller
            controller.query_var.set('原文')
            controller.start_search()
            self.pump(lambda: controller.search_button.instate(['!disabled']) and
                      '合成搜索失败' in controller.search_status.cget('text'))
            controller.start_search()
            self.pump(lambda: controller.result_tree.get_children())
            controller.result_tree.selection_set('result-0')
            self.root.update()
            self.assertIn('合成原文证据', controller.evidence_text.get('1.0', 'end'))
            self.assertIn('引用序号：7', controller.evidence_text.get('1.0', 'end'))
            controller.close()

    def test_random_review_failure_is_visible_and_retryable(self):
        attempts = []

        def candidates(value):
            attempts.append(value)
            if len(attempts) == 1:
                raise ValueError('合成回顾准备失败')
            return [value['messages'][0]]

        with patch.object(insights_ui, '_review_candidates', side_effect=candidates):
            window = show_insights(source(), {'counts': {'total': 1}, 'byDay': {}, 'byHour': {}},
                                   parent=self.root, save_report=lambda _: None)
            controller = window._private_insights_controller
            self.pump(lambda: getattr(controller, '_review_error', None) is not None)
            self.assertIn('合成回顾准备失败', str(controller._review_error))
            controller._show_random_review()
            self.pump(lambda: controller._review_candidates is not None and
                      len(attempts) == 2)
            self.assertIn('合成原文证据', controller.random_review_text.get('1.0', 'end'))
            self.assertIn('引用序号：7', controller.random_review_text.get('1.0', 'end'))
            controller.close()

    def test_non_analysis_message_keeps_its_fallback_id_in_evidence(self):
        value = source()
        value['messages'][0].update(id=None, messageId='media-only')
        value['analysisRefs'] = {}
        window = show_insights(value, {'counts': {'total': 1}, 'byDay': {}, 'byHour': {}},
                               parent=self.root, save_report=lambda _: None)
        controller = window._private_insights_controller
        self.addCleanup(controller.close)
        controller.query_var.set('原文')
        controller.start_search()
        self.pump(lambda: controller.result_tree.get_children())
        controller.result_tree.selection_set('result-0')
        self.root.update()
        text = controller.evidence_text.get('1.0', 'end')
        self.assertIn('消息 ID：media-only', text)
        self.assertIn('引用序号：未提供', text)
        self.assertNotIn('999', text)


if __name__ == '__main__':
    unittest.main()
