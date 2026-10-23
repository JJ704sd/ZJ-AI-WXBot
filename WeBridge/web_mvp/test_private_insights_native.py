"""Native Tk behavior using only invented in-memory messages."""
import gc
import threading
import time
import tkinter as tk
import unittest
from unittest.mock import patch

from private_insights import summarize
from private_insights_ui import show_insights, show_material_request


def source_fixture():
    rows = [{'id': f'm{i}', 'time': f'2026-10-{1 + i % 20:02d}T09:00:00+08:00',
             'senderName': '合成联系人', 'direction': 'incoming', 'kind': 'text',
             'text': f'下周确认合成方案 {i} <原文>'} for i in range(121)]
    return {'identity': {'client': 'wechat', 'accountKey': 'synthetic', 'peerId': 'peer-1'},
            'chat': {'id': 'peer-1', 'name': '合成联系人'}, 'messages': rows,
            'analysisRefs': {row['id']: i + 1 for i, row in enumerate(rows)},
            'timeRange': {'start': '2026-10-01', 'end': '2026-10-31'}}


class NativeInsightsTests(unittest.TestCase):
    def setUp(self):
        self.root = tk.Tk()
        self.root.withdraw()
        self.source = source_fixture()
        self.saved = []
        self.window = show_insights(self.source, summarize(self.source), parent=self.root, save_report=self.saved.append)
        self.ui = self.window._private_insights_controller

    def tearDown(self):
        self.root.destroy()
        self.ui = self.window = self.root = None
        gc.collect()

    def pump(self, condition, timeout=4):
        deadline = time.monotonic() + timeout
        while not condition():
            self.root.update()
            if time.monotonic() > deadline:
                self.fail('synthetic native UI timeout')
            time.sleep(.01)

    def test_search_paging_original_text_memory_and_report_callback(self):
        self.root.update()
        self.ui.query_var.set('方案')
        self.ui.search_button.invoke()
        self.pump(lambda: bool(self.ui._result))
        self.assertEqual(len(self.ui.result_tree.get_children()), 50)
        self.ui.next_button.invoke()
        self.pump(lambda: self.ui._result['offset'] == 50)
        self.ui.result_tree.selection_set('result-0')
        self.ui.result_tree.event_generate('<<TreeviewSelect>>')
        self.root.update()
        self.assertIn('合成方案 50 <原文>', self.ui.evidence_text.get('1.0', 'end'))
        self.assertIn('引用序号：51', self.ui.evidence_text.get('1.0', 'end'))
        self.ui.query_var.set('不存在的新词')
        self.ui.next_button.invoke()
        self.pump(lambda: self.ui._result and self.ui._result['query'] == '不存在的新词')
        self.assertEqual(self.ui._result['offset'], 0)
        self.assertEqual(self.ui._result['total'], 0)
        self.pump(lambda: self.ui._review_candidates is not None)
        self.ui._show_random_review()
        self.assertIn('合成方案', self.ui.random_review_text.get('1.0', 'end'))
        self.ui._calendar_day(31, 0)
        self.assertIn('没有该日记录', self.ui.calendar_status.cget('text'))
        self.ui.save_button.invoke()
        self.assertEqual(len(self.saved), 1)
        material = show_material_request({'status': 'ready', 'client': 'wechat', 'peerId': 'peer-1',
                                         'materialFiles': ['C:/synthetic/part-1.md']}, parent=self.root)
        self.assertEqual(material._private_material_view_model['client'], 'wechat')
        material.destroy()

    def test_clear_running_search_then_search_again_and_close(self):
        from private_insights import search_messages
        gate = threading.Event()
        entered = threading.Event()
        def slow(*args, **kwargs):
            entered.set()
            gate.wait(3)
            return search_messages(*args, **kwargs)
        try:
            with patch('private_insights_ui.search_messages', side_effect=slow):
                self.ui.query_var.set('方案')
                self.ui.search_button.invoke()
                self.pump(entered.is_set)
                self.ui.clear_button.invoke()
                self.assertIsNone(self.ui._poll_after)
                self.assertTrue(self.ui.search_button.instate(['!disabled']))
                self.assertEqual(self.ui.result_tree.get_children(), ())
                gate.set()
            self.ui.query_var.set('下周')
            self.ui.search_button.invoke()
            self.pump(lambda: self.ui._result and self.ui._result['query'] == '下周')
            self.assertEqual(self.ui._result['total'], 121)
            self.ui.close()
            self.assertTrue(self.ui.closed)
            self.assertIsNone(self.ui._poll_after)
            self.assertIsNone(self.ui._review_poll_after)
        finally:
            gate.set()


if __name__ == '__main__':
    unittest.main()
