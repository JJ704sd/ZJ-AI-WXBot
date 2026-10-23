"""Synthetic concurrency and recovery coverage for ProfileStore."""
import hashlib
import json
from pathlib import Path
import shutil
import threading
import unittest
from unittest.mock import patch

import private_profiles
from private_profiles import ProfileError, ProfileStore
import test_private_profiles


class PrivateStoreRecoveryFixture(unittest.TestCase):
    def setUp(self):
        self._fixture = test_private_profiles.PrivateProfileFixture("runTest")
        self._fixture.setUp()
        self.tmp = self._fixture.tmp
        self.base = self._fixture.base
        self.export = self._fixture.export
        self.store = self._fixture.store

    def tearDown(self):
        self._fixture.tearDown()

    @staticmethod
    def _digest(path: Path, root: Path) -> dict:
        data = path.read_bytes()
        return {"path": path.relative_to(root).as_posix(), "bytes": len(data),
                "sha256": hashlib.sha256(data).hexdigest()}

    def _changed_export(self, review_id: str, text: str) -> Path:
        export = self.base / review_id
        shutil.copytree(self.export, export)
        messages_path = export / "messages.jsonl"
        message = json.loads(messages_path.read_text(encoding="utf-8").splitlines()[0])
        message["text"] = text
        messages_path.write_text(json.dumps(message, ensure_ascii=False) + "\n", encoding="utf-8")
        corpus_path = export / "analysis" / "corpus.jsonl"
        corpus = json.loads(corpus_path.read_text(encoding="utf-8").splitlines()[0])
        corpus["text"] = text
        corpus_path.write_text(json.dumps(corpus, ensure_ascii=False) + "\n", encoding="utf-8")
        review_path = export / "review.json"
        review = json.loads(review_path.read_text(encoding="utf-8"))
        review["reviewId"] = review_id
        review["reviewedArtifacts"] = [self._digest(export / item["path"], export)
                                        for item in review["reviewedArtifacts"]]
        review_path.write_text(json.dumps(review), encoding="utf-8")
        manifest_path = export / "manifest.json"
        manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
        manifest["humanReview"]["reviewId"] = review_id
        manifest["artifacts"] = [self._digest(path, export)
                                  for path in sorted(export.rglob("*"))
                                  if path.is_file() and path.name != "manifest.json"]
        manifest_path.write_text(json.dumps(manifest), encoding="utf-8")
        return export

    @staticmethod
    def _relationship_candidate(request, source_text: str):
        return {"schemaVersion": 1, "requestId": request["requestId"],
                "baseRevision": request["baseRevision"],
                "coveredChunks": request["requiredChunks"],
                "observations": [{"subject": "relationship", "category": "communication",
                                  "basis": "observed", "text": source_text,
                                  "evidence": [{"sourceId": request["sources"][0]["sourceId"],
                                                 "ref": 1}]}],
                "limitations": ["合成并发材料有限"]}

    def test_concurrent_overview_cannot_cross_publish_json_and_markdown(self):
        first = self.store.prepare(self.export)
        first_candidate = self._relationship_candidate(first, "关系A")
        staged = self.store.stage(first["requestId"], first_candidate)
        self.store.confirm(staged["candidateId"], confirmed_by="synthetic reviewer")

        changed_export = self._changed_export("review-overview-race", "需要报价B")
        changed = self.store.prepare(changed_export)
        changed_candidate = self._relationship_candidate(changed, "关系B")
        changed_staged = self.store.stage(changed["requestId"], changed_candidate)

        baseline = self.store.overview("wechat", first["accountKey"])
        json_path = Path(baseline["jsonFile"])
        markdown_path = Path(baseline["markdownFile"])
        first_json_started = threading.Event()
        second_finished = threading.Event()
        first_markdown_written = threading.Event()
        first_seen = False
        real_write_json = private_profiles._write_json
        real_write_text = private_profiles._write_text

        def hooked_write_json(path, value):
            nonlocal first_seen
            is_overview = Path(path).parent.name == "overview"
            if is_overview and not first_seen:
                first_seen = True
                real_write_json(path, value)
                first_json_started.set()
                # Publish the second candidate only after the first overview
                # has taken its old JSON snapshot.  The hook remains active
                # for confirm receipts, but those paths are written through
                # immediately and do not participate in the interleave.
                self.store.confirm(changed_staged["candidateId"],
                                   confirmed_by="synthetic reviewer")
                second_thread.start()
                # An unlocked implementation lets the second overview finish
                # both files before this call returns.  With the production
                # lock it must wait until the first overview has published its
                # Markdown.  The bound keeps a regression from deadlocking.
                second_finished.wait(2)
                return
            real_write_json(path, value)

        def hooked_write_text(path, value):
            real_write_text(path, value)
            if (Path(path).parent.name == "overview"
                    and threading.current_thread() is first_thread):
                first_markdown_written.set()

        errors = []

        def run_overview():
            try:
                self.store.overview("wechat", first["accountKey"])
            except BaseException as exc:  # surface thread failures in the test
                errors.append(exc)

        def run_second_overview():
            try:
                self.store.overview("wechat", first["accountKey"])
            except BaseException as exc:  # surface thread failures in the test
                errors.append(exc)
            finally:
                second_finished.set()

        with patch.object(private_profiles, "_write_json", side_effect=hooked_write_json), \
             patch.object(private_profiles, "_write_text", side_effect=hooked_write_text):
            first_thread = threading.Thread(target=run_overview)
            second_thread = threading.Thread(target=run_second_overview)
            try:
                first_thread.start()
                self.assertTrue(first_json_started.wait(10),
                                "first overview did not start")
            finally:
                first_thread.join(15)
                second_thread.join(15)

        self.assertFalse(errors, errors)
        self.assertFalse(first_thread.is_alive() or second_thread.is_alive())
        self.assertTrue(first_markdown_written.is_set(),
                        "first overview did not publish Markdown")
        stored = json.loads(json_path.read_text(encoding="utf-8"))
        stored_texts = {item["text"] for item in stored["observations"]}
        markdown = markdown_path.read_text(encoding="utf-8")
        self.assertIn("关系A", stored_texts)
        self.assertIn("关系B", stored_texts)
        self.assertIn("关系A", markdown)
        self.assertIn("关系B", markdown)


if __name__ == "__main__":
    unittest.main()
