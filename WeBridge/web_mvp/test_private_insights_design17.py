"""Synthetic UI design checks for the v1.7 private-chat surface."""
from __future__ import annotations

import tkinter as tk
import unittest

try:
    from private_insights import summarize
    from private_insights_ui import show_insights, show_material_request
except ModuleNotFoundError:
    from web_mvp.private_insights import summarize
    from web_mvp.private_insights_ui import show_insights, show_material_request


def _source():
    rows = [
        {"id": "m1", "time": "2026-10-01T09:00:00+08:00", "senderName": "合成联系人",
         "direction": "incoming", "kind": "text", "text": "合成方案"},
        {"id": "m2", "time": "2026-10-02T10:00:00+08:00", "senderName": "我",
         "direction": "outgoing", "kind": "text", "text": "确认"},
    ]
    return {
        "identity": {"client": "wechat", "accountKey": "synthetic", "peerId": "peer-1"},
        "chat": {"id": "peer-1", "name": "这是一个用于验证换行的合成联系人名称，不代表真实联系人"},
        "timeRange": {"start": "2026-10-01", "end": "2026-10-31"},
        "analysisRefs": {"m1": 1, "m2": 2},
        "messages": rows,
    }


def _request():
    return {
        "status": "ready", "client": "wechat", "peerId": "peer-synthetic",
        "requestId": "request-synthetic-17", "currentProfileFile": "C:/synthetic/profile.json",
        "requestFile": "C:/synthetic/request.json",
        "materialFiles": ["C:/synthetic/analysis/part-1.md"],
        "requiredChunks": ["analysis/part-1.md"],
        "sources": [{"sourceId": "src-17", "allowedRefs": [1, 2]}],
    }


class PrivateInsightsDesign17Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.root = tk.Tk()
        cls.root.withdraw()

    @classmethod
    def tearDownClass(cls):
        cls.root.destroy()

    def tearDown(self):
        for child in self.root.winfo_children():
            child.destroy()
        self.root.update()

    def test_distribution_is_one_selectable_table_and_keeps_compatibility_mapping(self):
        source = _source()
        window = show_insights(source, summarize(source), parent=self.root, save_report=lambda _: None)
        ui = window._private_insights_controller
        window.geometry("900x620")
        self.root.update()
        self.assertEqual(len(ui.overview_notebook.tabs()), 2)
        self.assertEqual(len(ui._distribution_trees), 4)
        self.assertEqual(len({str(tree) for tree in ui._distribution_trees.values()}), 1)
        self.assertEqual(tuple(ui.distribution_selector.cget("values")),
                         ("按日", "按月", "按小时", "消息类型"))
        ui.distribution_selector.set("按月")
        ui.distribution_selector.event_generate("<<ComboboxSelected>>")
        self.root.update()
        self.assertEqual(ui.distribution_tree.get_children() != (), True)
        details_page = ui.overview_notebook.nametowidget(ui.overview_notebook.tabs()[1])
        self.assertFalse(any(isinstance(child, ttk_notebook_type()) for child in details_page.winfo_children()))

    def test_long_identity_and_empty_search_have_readable_boundaries(self):
        source = _source()
        window = show_insights(source, summarize(source), parent=self.root, save_report=lambda _: None)
        ui = window._private_insights_controller
        window.geometry("900x620")
        self.root.update()
        self.assertGreater(ui.header_meta.cget("wraplength"), 0)
        self.assertGreater(ui.search_title.cget("wraplength"), 0)
        ui._apply_result({"query": "没有这个词", "total": 0, "offset": 0, "items": []})
        self.assertIn("没有匹配消息", ui.search_status.cget("text"))
        self.assertIn("关键词", ui.search_status.cget("text"))

    def test_material_window_puts_primary_actions_before_technical_details(self):
        window = show_material_request(_request(), parent=self.root)
        window.geometry("620x420")
        self.root.update()
        buttons = window._private_material_buttons
        self.assertTrue(buttons["copy_task"].cget("text").startswith("1 "))
        self.assertTrue(buttons["import_candidate"].cget("text").startswith("2 "))
        self.assertLess(buttons["copy_task"].winfo_rooty(), window._private_material_details_text.winfo_rooty())
        self.assertIn("request-synthetic-17", window._private_material_details_text.get("1.0", "end"))


def ttk_notebook_type():
    from tkinter import ttk
    return ttk.Notebook


if __name__ == "__main__":
    unittest.main()
