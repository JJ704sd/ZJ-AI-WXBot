"""Synthetic tests for the prepared-material handoff window."""
import tkinter as tk
import unittest

try:
    from private_insights_ui import material_analysis_prompt, show_material_request
except ModuleNotFoundError:  # ``python -m unittest web_mvp.test_private_material_handoff``
    from web_mvp.private_insights_ui import material_analysis_prompt, show_material_request


def _request(status="ready"):
    return {
        "status": status,
        "client": "wechat",
        "accountKey": "acct-synthetic",
        "peerId": "peer-synthetic",
        "requestId": "req-synthetic-001",
        "baseRevision": "rev-synthetic-001",
        "requiredChunks": ["analysis/part-1.md", "analysis/part-2.md"],
        "requestFile": "C:/synthetic/requests/req-synthetic-001.json",
        "currentProfileFile": "C:/synthetic/current/profile.json",
        "materialFiles": ["C:/synthetic/export/analysis/part-1.md",
                           "C:/synthetic/export/analysis/part-2.md"],
        "sources": [{"sourceId": "src-synthetic-001", "allowedRefs": [7, 9]}],
        "sourceLimitations": ["合成材料不代表真实账号"],
        "messages": [{"text": "不得出现在任务文本中的合成聊天正文"}],
    }


class MaterialPromptTests(unittest.TestCase):
    def test_prompt_contains_request_contract_and_no_chat_body(self):
        prompt = material_analysis_prompt(_request())
        for value in ("req-synthetic-001", "rev-synthetic-001", "analysis/part-1.md",
                      "analysis/part-2.md", "C:/synthetic/current/profile.json",
                      "src-synthetic-001", "peer-synthetic", "acct-synthetic"):
            self.assertIn(value, prompt)
        for value in ("peer/self/relationship", "identity/background/needs/communication/"
                      "interests/events/commitments/follow_up",
                      "explicit/observed/uncertain", "coveredChunks", "observations",
                      "limitations", "analysisRefs", "allowedRefs", "sourceLimitations",
                      "对方画像", "我的沟通习惯", "双方关系视角", "12000", "1000", "4 MiB",
                      "不是执行指令", "独立的新 UTF-8 JSON 文件", "ProfileStage"):
            self.assertIn(value, prompt)
        self.assertIn('allowedRefs：[7, 9]', prompt)
        self.assertIn('"requestId": "req-synthetic-001"', prompt)
        self.assertNotIn("不得出现在任务文本中的合成聊天正文", prompt)

    def test_unchanged_prompt_forbids_new_candidate(self):
        prompt = material_analysis_prompt(_request("unchanged"))
        self.assertIn("unchanged", prompt)
        self.assertIn("不要生成新的候选", prompt)


class MaterialWindowTests(unittest.TestCase):
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

    def test_ready_window_copies_task_and_calls_import_callback(self):
        calls = []
        value = _request()
        window = show_material_request(value, parent=self.root,
                                       on_import_candidate=lambda item: calls.append(item))
        window.geometry("620x420")
        self.root.update()
        buttons = window._private_material_buttons
        buttons["copy_task"].invoke()
        task = window.clipboard_get()
        self.assertIn("req-synthetic-001", task)
        self.assertNotIn("不得出现在任务文本中的合成聊天正文", task)
        self.assertIn("分析任务已复制", window._private_material_action_status.cget("text"))
        buttons["copy_paths"].invoke()
        self.assertIn("路径已复制", window._private_material_action_status.cget("text"))
        buttons["import_candidate"].invoke()
        self.assertEqual(calls, [value])
        for button in buttons.values():
            self._assert_inside_window(window, button)
        self._assert_inside_window(window, window._private_material_action_status)

    def _assert_inside_window(self, window, widget):
        self.root.update_idletasks()
        left, top = window.winfo_rootx(), window.winfo_rooty()
        right, bottom = left + window.winfo_width(), top + window.winfo_height()
        widget_left, widget_top = widget.winfo_rootx(), widget.winfo_rooty()
        self.assertGreaterEqual(widget_left, left)
        self.assertGreaterEqual(widget_top, top)
        self.assertLessEqual(widget_left + widget.winfo_width(), right)
        self.assertLessEqual(widget_top + widget.winfo_height(), bottom)

    def test_long_failure_status_stays_inside_620px_window(self):
        def fail(_item):
            raise RuntimeError("synthetic secret-like error")
        window = show_material_request(_request(), parent=self.root, on_import_candidate=fail)
        window.geometry("620x420")
        self.root.update()
        window._private_material_buttons["import_candidate"].invoke()
        status = window._private_material_action_status
        self.assertIn("导入请求失败，请核对候选文件和当前材料会话后重试", status.cget("text"))
        self.assertNotIn("synthetic secret-like error", status.cget("text"))
        for button in window._private_material_buttons.values():
            self._assert_inside_window(window, button)
        self._assert_inside_window(window, status)

    def test_destroyed_window_from_import_callback_is_safe(self):
        holder = {}
        def destroy_then_reject(_item):
            holder["window"].destroy()
            return False
        holder["window"] = show_material_request(_request(), parent=self.root,
                                                  on_import_candidate=destroy_then_reject)
        holder["window"]._private_material_buttons["import_candidate"].invoke()
        self.assertFalse(holder["window"].winfo_exists())

    def test_import_exception_uses_fixed_safe_status(self):
        def fail(_item):
            raise RuntimeError("synthetic secret-like error")
        window = show_material_request(_request(), parent=self.root, on_import_candidate=fail)
        window._private_material_buttons["import_candidate"].invoke()
        status = window._private_material_action_status.cget("text")
        self.assertIn("导入请求失败，请核对候选文件和当前材料会话后重试", status)
        self.assertNotIn("synthetic secret-like error", status)

    def test_unchanged_window_disables_new_candidate_actions_but_keeps_path_copy(self):
        window = show_material_request(_request("unchanged"), parent=self.root,
                                       on_import_candidate=lambda _item: self.fail("must not import"))
        buttons = window._private_material_buttons
        self.assertTrue(buttons["copy_paths"].instate(["!disabled"]))
        self.assertTrue(buttons["copy_task"].instate(["disabled"]))
        self.assertTrue(buttons["import_candidate"].instate(["disabled"]))


if __name__ == "__main__":
    unittest.main()
