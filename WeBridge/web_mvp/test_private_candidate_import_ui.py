"""Synthetic Tk coverage for importing a host profile candidate."""
from __future__ import annotations

import json
from pathlib import Path
import time
import tkinter as tk
import unittest
from unittest.mock import patch

import test_private_profiles as fixtures
from local_chat_app import ChatApp
from offline_desktop import DesktopSession


class CandidateImportUITests(unittest.TestCase):
    def setUp(self):
        self.fixture = fixtures.PrivateProfileFixture("runTest")
        self.fixture.setUp()
        self.base, self.export, self.store = self.fixture.base, self.fixture.export, self.fixture.store
        self.request = self.store.prepare(self.export)
        self.candidate_path = self.base / "host-candidate.json"
        self.candidate_path.write_text(
            json.dumps(self.fixture.candidate(self.request), ensure_ascii=False), encoding="utf-8")
        self.root = tk.Tk()
        self.app = ChatApp(self.root, DesktopSession(self.base / "desktop", conversation_mode="direct"))
        self.app.session.last_export = self.export
        for token in self.root.tk.call("after", "info"):
            try:
                self.root.after_cancel(token)
            except tk.TclError:
                pass
        self.addCleanup(self._close_root)
        self.addCleanup(self.fixture.tearDown)

    def _close_root(self):
        try:
            for token in self.root.tk.call("after", "info"):
                self.root.after_cancel(token)
            self.root.destroy()
        except tk.TclError:
            pass

    def _pump(self, predicate, timeout=4):
        deadline = time.monotonic() + timeout
        while time.monotonic() < deadline:
            self.root.update()
            self.app._drain()
            if predicate():
                return
            time.sleep(0.01)
        self.fail("synthetic import UI operation timed out")

    def test_import_stages_real_synthetic_candidate_then_opens_unconfirmed_review(self):
        import private_chat

        reviewed = []
        with patch.object(private_chat, "default_store", return_value=self.store.root), \
             patch.object(private_chat, "show_candidate", side_effect=lambda store, value, **kwargs: (
                 reviewed.append(value) or {"status": "awaiting_confirmation"})), \
             patch("local_chat_app.filedialog.askopenfilename", return_value=str(self.candidate_path)):
            self.assertTrue(self.app.import_profile_candidate(expected_request_id=self.request["requestId"]))
            self._pump(lambda: bool(reviewed) and not self.app.busy)

        self.assertEqual(reviewed[0]["candidateId"], reviewed[0]["preview"]["candidateId"])
        self.assertEqual(reviewed[0]["status"], "candidate")
        self.assertIsNone(self.store.current("wechat", self.request["accountKey"], "peer-1"),
                          "opening review must not auto-confirm the candidate")

    def test_cancel_and_context_change_do_not_stage(self):
        import private_chat

        with patch.object(private_chat, "stage_candidate_file", create=True) as stage, \
             patch("local_chat_app.filedialog.askopenfilename", return_value=""):
            self.assertFalse(self.app.import_profile_candidate(expected_request_id=self.request["requestId"]))
            stage.assert_not_called()

        changed = self.base / "other-export"
        with patch.object(private_chat, "stage_candidate_file", create=True) as stage, \
             patch("local_chat_app.filedialog.askopenfilename",
                   side_effect=lambda **kwargs: (setattr(self.app.session, "last_export", changed),
                                                  str(self.candidate_path))[1]), \
             patch("local_chat_app.messagebox.showerror") as error:
            self.app.session.last_export = self.export
            self.assertFalse(self.app.import_profile_candidate(expected_request_id=self.request["requestId"]))
            stage.assert_not_called()
            error.assert_called_once()

    def test_material_callback_captures_export_client_and_request(self):
        value = dict(self.request)
        value.update({"status": "ready", "client": "wechat", "peerId": "peer-1"})
        with patch.object(self.app, "work") as work, \
             patch("private_insights_ui.show_material_request") as show, \
             patch.object(self.app, "import_profile_candidate") as importer:
            self.app.prepare_profile_material()
            completed = work.call_args.args[2]
            completed(value)
            kwargs = show.call_args.kwargs
            self.assertIn("on_import_candidate", kwargs)
            kwargs["on_import_candidate"](value)
            importer.assert_called_once_with(export_root=self.export,
                                             bound_client="wechat",
                                             expected_request_id=self.request["requestId"])

    def test_material_button_reports_picker_cancel_without_staging(self):
        from private_insights_ui import show_material_request

        window = show_material_request(
            self.request,
            parent=self.root,
            on_import_candidate=lambda _request: self.app.import_profile_candidate(
                export_root=self.export,
                bound_client="wechat",
                expected_request_id=self.request["requestId"],
            ),
        )
        self.addCleanup(window.destroy)
        with patch("local_chat_app.filedialog.askopenfilename", return_value=""):
            window._private_material_buttons["import_candidate"].invoke()
        self.assertIn("未接受", window._private_material_action_status.cget("text"))
        self.assertFalse(list((self.store.root / "candidates").glob("*.json")))

    def test_invalid_json_releases_busy_and_corrected_candidate_can_retry(self):
        import private_chat

        invalid = self.base / "invalid-candidate.json"
        invalid.write_text("{bad", encoding="utf-8")
        reviewed = []
        with patch.object(private_chat, "default_store", return_value=self.store.root), \
             patch.object(private_chat, "show_candidate",
                          side_effect=lambda store, value, **kwargs: (
                              reviewed.append(value) or {"status": "awaiting_confirmation"})), \
             patch("local_chat_app.messagebox.showerror"), \
             patch("local_chat_app.filedialog.askopenfilename",
                   side_effect=[str(invalid), str(self.candidate_path)]):
            self.assertTrue(self.app.import_profile_candidate(expected_request_id=self.request["requestId"]))
            self._pump(lambda: not self.app.busy and "未完成" in self.app.status.get())
            self.assertFalse(list((self.store.root / "candidates").glob("*.json")))

            invalid.write_text(self.candidate_path.read_text(encoding="utf-8"), encoding="utf-8")
            self.assertTrue(self.app.import_profile_candidate(expected_request_id=self.request["requestId"]))
            self._pump(lambda: bool(reviewed) and not self.app.busy)

        self.assertEqual(reviewed[0]["status"], "candidate")
        self.assertIsNone(self.store.current("wechat", self.request["accountKey"], "peer-1"))

    def test_picker_state_changes_reject_without_staging(self):
        import private_chat

        for field in ("busy", "read_busy", "batch_running", "closing"):
            with self.subTest(field=field), \
                 patch.object(private_chat, "stage_candidate_file", create=True) as stage, \
                 patch("local_chat_app.filedialog.askopenfilename",
                       side_effect=lambda **kwargs: (
                           setattr(self.app, field, True), str(self.candidate_path))[1]):
                self.app.busy = self.app.read_busy = self.app.batch_running = self.app.closing = False
                self.assertFalse(self.app.import_profile_candidate(expected_request_id=self.request["requestId"]))
                stage.assert_not_called()
                self.app.busy = self.app.read_busy = self.app.batch_running = self.app.closing = False

if __name__ == "__main__":
    unittest.main()
