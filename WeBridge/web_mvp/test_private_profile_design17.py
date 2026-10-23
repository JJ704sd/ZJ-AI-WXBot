"""Synthetic v1.7 profile layout checks; no real account reads."""
from __future__ import annotations

import time
import tkinter as tk
import unittest


def candidate():
    return {
        "candidateId": "design17-candidate",
        "status": "candidate",
        "identity": {
            "client": "wechat",
            "accountKey": "synthetic-account",
            "peerId": "peer-" + ("联系人名称" * 20),
        },
        "changes": [
            {
                "subject": "peer",
                "category": "needs",
                "basis": "explicit",
                "text": "希望书面沟通并在下周确认报价方案",
                "evidence": [{
                    "sourceId": "synthetic-source",
                    "ref": 17,
                    "messageId": "synthetic-message",
                    "time": "2026-01-01T09:00:00+08:00",
                    "senderName": "合成联系人",
                    "direction": "incoming",
                    "text": "请把方案发成文字，下周确认报价。",
                }],
            },
            {
                "subject": "self",
                "category": "communication",
                "basis": "observed",
                "text": "本人会把下一步写成清单",
                "evidence": [{
                    "sourceId": "synthetic-source",
                    "ref": 18,
                    "messageId": "synthetic-message-2",
                    "time": "2026-01-01T09:02:00+08:00",
                    "senderName": "本人",
                    "direction": "outgoing",
                    "text": "我整理成清单发你。",
                }],
            },
        ],
        "previous": [],
        "limitations": ["仅合成数据"],
    }


class PrivateProfileDesign17Tests(unittest.TestCase):
    def setUp(self):
        self.root = tk.Tk()
        self.addCleanup(self.root.destroy)

    def test_long_peer_and_evidence_tags_fit_small_review_window(self):
        from private_profile_ui import review_window

        self.root.geometry("900x620")
        measured = {}

        def inspect():
            windows = [item for item in self.root.winfo_children() if isinstance(item, tk.Toplevel)]
            self.assertEqual(len(windows), 1)
            window = windows[0]
            window.geometry("900x620")
            for _ in range(6):
                window.update_idletasks()
                window.update()
            panel = window.grid_slaves(row=0)[0]
            controls = window.grid_slaves(row=1)[0]
            panel.tree.selection_set(panel.tree.get_children()[0])
            panel.tree.event_generate("<<TreeviewSelect>>")
            window.update_idletasks()
            measured.update({
                "tree": panel.tree.winfo_height(),
                "detail": panel.detail.winfo_height(),
                "headingTags": len(panel.detail.tag_ranges("evidence_heading")),
                "sourceTags": len(panel.detail.tag_ranges("evidence_source")),
                "footerInside": all(
                    widget.winfo_rooty() + widget.winfo_height()
                    <= window.winfo_rooty() + window.winfo_height()
                    for widget in (*controls.check_widgets, controls.confirm_button)
                ),
                "status": panel.header_status.get(),
                "evidence": panel.detail.get("1.0", "end"),
            })
            window.destroy()

        self.root.after(100, inspect)
        review_window("合成画像复核", "", lambda _note: {"status": "confirmed"},
                      parent=self.root, candidate=candidate())
        self.assertGreaterEqual(measured["tree"], 140)
        self.assertGreaterEqual(measured["detail"], 140)
        self.assertGreater(measured["headingTags"], 0)
        self.assertGreater(measured["sourceTags"], 0)
        self.assertTrue(measured["footerInside"])
        self.assertIn("待人工复核", measured["status"])
        self.assertIn("请把方案发成文字", measured["evidence"])
        self.assertIn("来源：synthetic-source  #17", measured["evidence"])

    def test_empty_filter_explains_how_to_recover_and_confirmed_is_read_only(self):
        from private_profile_ui import CandidatePanel

        panel = CandidatePanel(self.root, candidate(), confirmed=True)
        panel.pack(fill="both", expand=True)
        self.root.update()
        panel.query.set("不存在的合成观察")
        self.root.update()
        self.assertEqual(panel.tree.get_children(), ())
        self.assertIn("清除搜索", panel.detail.get("1.0", "end"))
        self.assertEqual(panel.scope.get(), "已确认观察")
        self.assertEqual(panel.header_status.get(), "已确认资料 · 2 条观察 · 只读查看")

    def test_huge_evidence_is_bounded_before_later_rows_are_rendered(self):
        from private_profile_ui import CandidatePanel, MAX_EVIDENCE_CHARS

        value = candidate()
        value["changes"][0]["evidence"] = [
            {
                "sourceId": "synthetic-source",
                "ref": 17,
                "messageId": "huge-message",
                "time": "2026-01-01T09:00:00+08:00",
                "senderName": "合成联系人",
                "direction": "incoming",
                "text": "超长正文" + ("x" * 260000),
            },
            {
                "sourceId": "later-source",
                "ref": 99,
                "messageId": "later-message",
                "time": "2026-01-01T10:00:00+08:00",
                "senderName": "后续消息",
                "direction": "incoming",
                "text": "不应在预算耗尽后继续写入",
            },
        ]
        panel = CandidatePanel(self.root, value)
        panel.pack(fill="both", expand=True)
        self.root.update()
        panel.tree.selection_set(panel.tree.get_children()[0])
        panel.tree.event_generate("<<TreeviewSelect>>")
        self.root.update()
        rendered = panel.detail.get("1.0", "end-1c")
        self.assertLessEqual(len(rendered), MAX_EVIDENCE_CHARS)
        self.assertIn("显示长度已达上限", rendered)
        self.assertNotIn("later-message", rendered)
        self.assertGreater(len(panel.detail.tag_ranges("evidence_body")), 0)


if __name__ == "__main__":
    unittest.main()
