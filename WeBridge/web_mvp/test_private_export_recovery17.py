"""Synthetic failure reproduction for the 1.7 export recovery boundary."""
import json
import hashlib
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch

from offline_chat import ArchiveError
from offline_desktop import DesktopSession
from offline_review import REVIEW_CHECKS, inventory
from test_offline_multiselect import multi_group_fixture


class PrivateExportRecovery17Tests(unittest.TestCase):
    def _prepared(self, base):
        source = base / "source"
        chats = multi_group_fixture(source, "wechat")
        session = DesktopSession(base / "profile", client="wechat")
        session.open_source({"sourceRoot": str(source)})
        parsed = {
            chat: session.prepare_review(chat, copy_media=False)
            for chat in chats
        }
        return session, chats, parsed

    @staticmethod
    def _approve(session, chat, parsed):
        session.activate_review(chat)
        return session.approve_review(
            parsed[chat]["review"]["reviewId"],
            {key: True for key in REVIEW_CHECKS},
            "合成复核，不代表真实账号验收",
            chat=chat,
        )

    @staticmethod
    def _rewrite_manifest(target):
        manifest_path = Path(target) / "manifest.json"
        manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
        manifest["artifacts"] = [item for item in inventory(target)
                                  if item["path"] != "manifest.json"]
        manifest_path.write_text(json.dumps(manifest, ensure_ascii=False, indent=2),
                                 encoding="utf-8")

    def test_reparse_failure_preserves_existing_review_until_new_work_succeeds(self):
        with tempfile.TemporaryDirectory(prefix="private17-reparse-failure-") as folder:
            session, chats, parsed = self._prepared(Path(folder))
            self._approve(session, chats[0], parsed)
            self.assertEqual(session.review_status(chats[0]), "已复核")

            with patch.object(session.archive, "export",
                              side_effect=ArchiveError("synthetic reparse failure")):
                with self.assertRaises(ArchiveError):
                    session.prepare_review(chats[0], copy_media=False)

            self.assertEqual(session.review_status(chats[0]), "已复核")
            resumed = DesktopSession(Path(folder) / "profile", client="wechat")
            info = resumed.bootstrap(resume=True)
            self.assertGreater(info.get("restoredReviews", 0), 0)
            self.assertEqual(resumed.review_status(chats[0]), "已复核")

    def test_batch_index_write_failure_returns_metadata_error_and_restores_exports(self):
        with tempfile.TemporaryDirectory(prefix="private17-batch-index-failure-") as folder:
            session, chats, parsed = self._prepared(Path(folder))
            for chat in chats:
                self._approve(session, chat, parsed)

            with patch("offline_review.atomic_write_json",
                       side_effect=OSError("synthetic batch failure")):
                result = session.export_reviewed(chats)

            self.assertEqual(result["state"], "partial")
            self.assertFalse(result["metadataComplete"])
            self.assertEqual(result["metadataErrors"][0]["file"], "batch.json")
            self.assertIn("清单写入失败", result["metadataErrors"][0]["error"])
            batch_root = session.last_batch_root
            self.assertIsNotNone(batch_root)
            self.assertEqual(len(list(Path(batch_root).rglob("review.json"))), 2)
            self.assertFalse((Path(batch_root) / "batch.json").exists())

            resumed = DesktopSession(Path(folder) / "profile", client="wechat")
            info = resumed.bootstrap(resume=True)
            self.assertEqual(info["restoredPublished"], 2)
            self.assertEqual(resumed.review_status(chats[0]), "已导出")
            self.assertEqual(resumed.review_status(chats[1]), "已导出")
            repeated = resumed.export_reviewed(chats)
            self.assertEqual(repeated["exports"], [])
            self.assertEqual(len(repeated["alreadyExported"]), 2)
            repaired = resumed.repair_export_metadata(batch_root)
            self.assertTrue(repaired["metadataComplete"], repaired)
            self.assertTrue((Path(batch_root) / "batch.json").is_file())
            self.assertTrue((Path(batch_root) / "导出清单.md").is_file())

    def test_readme_write_failure_returns_metadata_error_after_exports_complete(self):
        with tempfile.TemporaryDirectory(prefix="private17-readme-failure-") as folder:
            session, chats, parsed = self._prepared(Path(folder))
            for chat in chats:
                self._approve(session, chat, parsed)

            with patch("offline_review.atomic_write_text",
                       side_effect=OSError("synthetic README failure")):
                result = session.export_reviewed(chats)

            batch_root = session.last_batch_root
            self.assertEqual(len(list(Path(batch_root).rglob("review.json"))), 2)
            batch = json.loads((Path(batch_root) / "batch.json").read_text(encoding="utf-8"))
            self.assertEqual(result["state"], "partial")
            self.assertFalse(result["metadataComplete"])
            self.assertEqual(batch["state"], "partial")
            self.assertFalse(batch["metadataComplete"])
            self.assertEqual(batch["metadataErrors"][0]["file"], "导出清单.md")
            self.assertIn("清单写入失败", batch["metadataErrors"][0]["error"])
            self.assertFalse((Path(batch_root) / "导出清单.md").exists())

    def test_direct_wechat_and_wecom_exports_restore_and_retry_without_republishing(self):
        from test_private_chat_integration import direct_source
        for client in ("wechat", "wecom"):
            with self.subTest(client=client), tempfile.TemporaryDirectory(prefix="private17-direct-") as folder:
                base = Path(folder)
                source, chat, self_id = direct_source(base, client)
                session = DesktopSession(base / "profile", client=client,
                                         conversation_mode="direct")
                session.open_source({"sourceRoot": str(source), "selfId": self_id})
                parsed = session.prepare_review(chat, copy_media=False)
                session.activate_review(chat)
                session.approve_review(parsed["review"]["reviewId"],
                                       {key: True for key in REVIEW_CHECKS},
                                       "合成私聊复核", chat=chat)
                exported = session.confirm_export(parsed["review"]["reviewId"],
                    {key: True for key in REVIEW_CHECKS}, "合成私聊复核", chat=chat)
                self.assertTrue(Path(exported["output"]).is_dir())

                resumed = DesktopSession(base / "profile", client=client,
                                         conversation_mode="direct")
                info = resumed.bootstrap(resume=True)
                self.assertEqual(info["restoredPublished"], 1)
                self.assertEqual(resumed.review_status(chat), "已导出")
                repeated = resumed.export_reviewed([chat])
                self.assertEqual(repeated["exports"], [])
                self.assertEqual(len(repeated["alreadyExported"]), 1)

    def test_tampered_published_file_is_not_restored_as_completed(self):
        with tempfile.TemporaryDirectory(prefix="private17-tampered-published-") as folder:
            session, chats, parsed = self._prepared(Path(folder))
            self._approve(session, chats[0], parsed)
            result = session.export_reviewed([chats[0]])
            output = Path(result["exports"][0]["output"])
            (output / "messages.jsonl").write_text("tampered", encoding="utf-8")
            self._rewrite_manifest(output)

            resumed = DesktopSession(Path(folder) / "profile", client="wechat")
            info = resumed.bootstrap(resume=True)
            self.assertEqual(info["status"], "ready")
            self.assertEqual(resumed.review_status(chats[0]), "未解析")
            self.assertEqual(info["restoredPublished"], 0)

    def test_published_identity_must_match_current_direct_mapping(self):
        from test_private_chat_integration import direct_source
        with tempfile.TemporaryDirectory(prefix="private17-peer-mapping-") as folder:
            base = Path(folder)
            source, chat, self_id = direct_source(base, "wechat")
            session = DesktopSession(base / "profile", client="wechat",
                                     conversation_mode="direct")
            session.open_source({"sourceRoot": str(source), "selfId": self_id})
            parsed = session.prepare_review(chat, copy_media=False)
            session.activate_review(chat)
            session.approve_review(parsed["review"]["reviewId"],
                                   {key: True for key in REVIEW_CHECKS},
                                   "合成身份校验", chat=chat)
            result = session.confirm_export(parsed["review"]["reviewId"],
                {key: True for key in REVIEW_CHECKS}, "合成身份校验", chat=chat)
            output = Path(result["output"])

            review_path = output / "review.json"
            review = json.loads(review_path.read_text(encoding="utf-8"))
            review["peerId"] = "wrong-peer"
            review["relationship"] = "wrong-relationship"
            review_path.write_text(json.dumps(review, ensure_ascii=False, indent=2),
                                   encoding="utf-8")
            self._rewrite_manifest(output)
            checkpoint = json.loads(session._progress.path.read_text(encoding="utf-8"))
            entry = checkpoint["reviews"][0]
            entry["summary"]["peerId"] = "wrong-peer"
            entry["summary"]["relationship"] = "wrong-relationship"
            entry["approval"]["peerId"] = "wrong-peer"
            entry["approval"]["relationship"] = "wrong-relationship"
            session._progress.path.write_text(json.dumps(checkpoint, ensure_ascii=False, indent=2),
                                              encoding="utf-8")

            resumed = DesktopSession(base / "profile", client="wechat",
                                     conversation_mode="direct")
            info = resumed.bootstrap(resume=True)
            self.assertEqual(info["status"], "ready")
            self.assertEqual(info.get("restoredPublished", 0), 0)
            self.assertEqual(resumed.review_status(chat), "未解析")

    def test_checkpoint_failure_keeps_previous_review_in_memory_and_after_restart(self):
        with tempfile.TemporaryDirectory(prefix="private17-checkpoint-failure-") as folder:
            session, chats, parsed = self._prepared(Path(folder))
            self._approve(session, chats[0], parsed)
            old_review_id = parsed[chats[0]]["review"]["reviewId"]

            with patch.object(session._progress, "save",
                              side_effect=ArchiveError("synthetic checkpoint failure")):
                with self.assertRaises(ArchiveError):
                    session.prepare_review(chats[0], copy_media=False)

            self.assertEqual(session.review_status(chats[0]), "已复核")
            self.assertEqual(session._reviews[chats[0]]["summary"]["reviewId"], old_review_id)
            resumed = DesktopSession(Path(folder) / "profile", client="wechat")
            info = resumed.bootstrap(resume=True)
            self.assertEqual(info["status"], "ready")
            self.assertEqual(resumed.review_status(chats[0]), "已复核")
            self.assertEqual(resumed._reviews[chats[0]]["summary"]["reviewId"], old_review_id)

    def test_settings_save_failure_keeps_previous_review_and_successful_reparse_clears_old_export(self):
        with tempfile.TemporaryDirectory(prefix="private17-settings-failure-") as folder:
            session, chats, parsed = self._prepared(Path(folder))
            self._approve(session, chats[0], parsed)
            exported = session.export_reviewed([chats[0]])
            session.activate_review(chats[0])
            old_review_id = parsed[chats[0]]["review"]["reviewId"]
            old_output = Path(exported["exports"][0]["output"])
            self.assertEqual(session.last_export, old_output)

            with patch.object(session, "_save", side_effect=OSError("synthetic settings failure")):
                with self.assertRaises(OSError):
                    session.prepare_review(chats[0], copy_media=False)
            self.assertEqual(session.review_status(chats[0]), "已导出")
            self.assertEqual(session._published_reviews[chats[0]]["summary"]["reviewId"], old_review_id)
            self.assertEqual(session.last_export, old_output)

            session.prepare_review(chats[0], copy_media=False)
            self.assertIsNone(session.last_export)
            self.assertEqual(session.review_status(chats[0]), "待复核")

    def test_repair_rejects_foreign_path_and_tampered_published_result(self):
        with tempfile.TemporaryDirectory(prefix="private17-repair-boundary-") as folder:
            session, chats, parsed = self._prepared(Path(folder))
            self._approve(session, chats[0], parsed)
            result = session.export_reviewed([chats[0]])
            batch_root = Path(result["output"])

            foreign = Path(folder) / "foreign" / "exports" / "batch"
            foreign.mkdir(parents=True)
            with self.assertRaises(ArchiveError):
                session.repair_export_metadata(foreign)

            (Path(result["exports"][0]["output"]) / "messages.jsonl").write_text(
                "tampered\n", encoding="utf-8")
            repaired = session.repair_export_metadata(batch_root)
            self.assertFalse(repaired["metadataComplete"])
            self.assertTrue(repaired["metadataErrors"])
            self.assertEqual(repaired["exports"], [])

    def test_partial_batch_restart_retries_only_failed_session(self):
        with tempfile.TemporaryDirectory(prefix="private17-partial-retry-") as folder:
            session, chats, parsed = self._prepared(Path(folder))
            for chat in chats:
                self._approve(session, chat, parsed)

            from offline_review import publish_review as real_publish
            failed_once = {chats[1]: True}

            def publish_with_one_failure(pending, output, checks=None, note=''):
                chat_id = pending["summary"]["chat"]["id"]
                if failed_once.pop(chat_id, False):
                    raise ArchiveError("synthetic one-session publish failure")
                return real_publish(pending, output, checks, note)

            with patch("offline_review.publish_review", side_effect=publish_with_one_failure):
                first = session.export_reviewed(chats)
            self.assertEqual(len(first["exports"]), 1)
            self.assertEqual(len(first["failed"]), 1)
            successful_output = Path(first["exports"][0]["output"])
            successful_messages = successful_output / "messages.jsonl"
            before_sha = hashlib.sha256(successful_messages.read_bytes()).hexdigest()
            repaired = session.repair_export_metadata(Path(first["output"]))
            self.assertEqual(repaired["state"], "partial")
            self.assertTrue(repaired["metadataComplete"], repaired)
            self.assertEqual(len(repaired["exports"]), 1)
            self.assertEqual(len(repaired["failed"]), 1)
            self.assertEqual({item["chatId"] for item in repaired["failed"]}, {chats[1]})
            self.assertEqual(set(json.loads((Path(first["output"]) / "batch.json").read_text(
                encoding="utf-8"))["selectedChatIds"]), set(chats))
            self.assertEqual(hashlib.sha256(successful_messages.read_bytes()).hexdigest(), before_sha)

            resumed = DesktopSession(Path(folder) / "profile", client="wechat")
            info = resumed.bootstrap(resume=True)
            self.assertEqual(info["restoredPublished"], 1)
            self.assertGreaterEqual(info["restoredReviews"], 1)
            retry = resumed.export_reviewed(chats)
            self.assertEqual(len(retry["exports"]), 1)
            self.assertEqual(len(retry["alreadyExported"]), 1)
            self.assertEqual(retry["failed"], [])
            self.assertEqual(resumed.review_status(chats[0]), "已导出")
            self.assertEqual(resumed.review_status(chats[1]), "已导出")

    def test_snapshot_change_does_not_restore_completed_export(self):
        with tempfile.TemporaryDirectory(prefix="private17-snapshot-change-") as folder:
            session, chats, parsed = self._prepared(Path(folder))
            self._approve(session, chats[0], parsed)
            session.export_reviewed([chats[0]])
            (session.archive.root / "synthetic-snapshot-change.txt").write_text(
                "changed", encoding="utf-8")

            resumed = DesktopSession(Path(folder) / "profile", client="wechat")
            info = resumed.bootstrap(resume=True)
            self.assertEqual(info["status"], "ready")
            self.assertEqual(info.get("restoredPublished", 0), 0)
            self.assertEqual(resumed.review_status(chats[0]), "未解析")


if __name__ == "__main__":
    unittest.main()
