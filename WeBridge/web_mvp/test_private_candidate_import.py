"""Synthetic contract tests for the host candidate import service."""
import hashlib
import json
import os
import shutil
import subprocess
import unittest

from private_profiles import ProfileError
import scripts.private_chat as private_chat
import test_private_profiles


class PrivateCandidateImportFixture(unittest.TestCase):
    def setUp(self):
        self._fixture = test_private_profiles.PrivateProfileFixture("runTest")
        self._fixture.setUp()
        self.base = self._fixture.base
        self.export = self._fixture.export
        self.store = self._fixture.store
        self.request = self.store.prepare(self.export)
        self.candidate = self._fixture.candidate(self.request)
        self.candidate_path = self.base / "host-candidate.json"
        self._write_candidate(self.candidate)

    def tearDown(self):
        self._fixture.tearDown()

    def _write_candidate(self, value):
        self.candidate_path.write_text(json.dumps(value, ensure_ascii=False), encoding="utf-8")

    @staticmethod
    def _digest(path, root):
        data = path.read_bytes()
        return {"path": path.relative_to(root).as_posix(), "bytes": len(data),
                "sha256": hashlib.sha256(data).hexdigest()}

    def _clone_export(self, name, *, review_id=None, mutate=None, text=None,
                      sender_id=None):
        export = self.base / name
        shutil.copytree(self.export, export)
        if text is not None:
            messages = export / "messages.jsonl"
            row = json.loads(messages.read_text(encoding="utf-8").splitlines()[0])
            row["text"] = text
            messages.write_text(json.dumps(row, ensure_ascii=False) + "\n", encoding="utf-8")
            corpus = export / "analysis" / "corpus.jsonl"
            row = json.loads(corpus.read_text(encoding="utf-8").splitlines()[0])
            row["text"] = text
            corpus.write_text(json.dumps(row, ensure_ascii=False) + "\n", encoding="utf-8")

        review_path = export / "review.json"
        review = json.loads(review_path.read_text(encoding="utf-8"))
        manifest_path = export / "manifest.json"
        manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
        if review_id is not None:
            review["reviewId"] = review_id
            manifest["humanReview"]["reviewId"] = review_id
        if mutate is not None:
            mutate(review, manifest)
        if sender_id is not None:
            for relative in ("messages.jsonl", "analysis/corpus.jsonl"):
                path = export / relative
                rows = [json.loads(line) for line in path.read_text(encoding="utf-8").splitlines()]
                for row in rows:
                    row["senderId"] = sender_id
                path.write_text("".join(json.dumps(row, ensure_ascii=False) + "\n"
                                                 for row in rows), encoding="utf-8")
        for item in review["reviewedArtifacts"]:
            item.update(self._digest(export / item["path"], export))
        review_path.write_text(json.dumps(review, ensure_ascii=False), encoding="utf-8")
        manifest["artifacts"] = [
            self._digest(path, export)
            for path in sorted(export.rglob("*"))
            if path.is_file() and path.name != "manifest.json"
        ]
        manifest_path.write_text(json.dumps(manifest, ensure_ascii=False), encoding="utf-8")
        return export

    def _assert_no_staged_candidate(self):
        candidates = [path for path in (self.store.root / "candidates").glob("cand-*.json")
                      if not path.name.endswith(".preview.json")]
        self.assertEqual(candidates, [])

    def _stage(self, *, export_root=None, bound_client="wechat", expected_request_id=None):
        return private_chat.stage_candidate_file(
            self.store, self.candidate_path,
            export_root=self.export if export_root is None else export_root,
            bound_client=bound_client,
            expected_request_id=expected_request_id,
        )

    def test_valid_import_resolves_evidence_without_confirming_and_is_idempotent(self):
        original = self.candidate_path.read_bytes()
        first = self._stage()
        second = self._stage()

        self.assertEqual(first["candidateId"], second["candidateId"])
        self.assertEqual(first["identity"]["peerId"], "peer-1")
        evidence = first["changes"][0]["evidence"][0]
        self.assertEqual(evidence["text"], "需要报价")
        self.assertEqual(evidence["senderId"], "peer-1")
        self.assertEqual(self.candidate_path.read_bytes(), original)
        self.assertIsNone(self.store.current("wechat", self.request["accountKey"], "peer-1"))
        candidates = [path for path in (self.store.root / "candidates").glob("cand-*.json")
                      if not path.name.endswith(".preview.json")]
        self.assertEqual(len(candidates), 1)

    def test_expected_request_and_identity_mismatch_are_rejected_before_stage(self):
        cases = [
            ("wrong client binding", self.export, "wecom", None),
            ("wrong request window", self.export, "wechat", "req-does-not-match"),
        ]
        for name, export_root, bound_client, expected in cases:
            with self.subTest(name=name):
                with self.assertRaises(ProfileError):
                    self._stage(export_root=export_root, bound_client=bound_client,
                                expected_request_id=expected)
                self._assert_no_staged_candidate()

        for name, mutate in (
                ("account", lambda review, manifest: (
                    review.update(selfId="self-2"), manifest.update(selfId="self-2"))),
                ("contact", lambda review, manifest: (
                    review.update(peerId="peer-2", chat={**review["chat"], "id": "peer-2"}),
                    manifest["chat"].update(id="peer-2"))),
        ):
            with self.subTest(name=name):
                export_root = self._clone_export(
                    "mismatch-" + name, mutate=mutate,
                    sender_id="peer-2" if name == "contact" else None)
                inspected = self.store.inspect_export(export_root)
                self.assertNotEqual(
                    {inspected["identity"][key] for key in ("accountKey", "peerId")},
                    {self.request[key] for key in ("accountKey", "peerId")},
                )
                with self.assertRaises(ProfileError):
                    self._stage(export_root=export_root)
                self._assert_no_staged_candidate()

    def test_invalid_candidate_shapes_size_and_evidence_do_not_stage(self):
        invalid_values = [
            ("malformed JSON", None),
            ("top-level list", []),
            ("missing requestId", {key: value for key, value in self.candidate.items()
                                    if key != "requestId"}),
        ]
        for name, value in invalid_values:
            with self.subTest(name=name):
                if value is None:
                    self.candidate_path.write_text("{broken", encoding="utf-8")
                else:
                    self._write_candidate(value)
                with self.assertRaises(ProfileError):
                    self._stage()
                self._assert_no_staged_candidate()
                self._write_candidate(self.candidate)

        for invalid_request_id in (True, [], {}):
            with self.subTest(invalid_request_id=repr(invalid_request_id)):
                invalid = dict(self.candidate, requestId=invalid_request_id)
                self._write_candidate(invalid)
                with self.assertRaises(ProfileError):
                    self._stage()
                self._assert_no_staged_candidate()
                self._write_candidate(self.candidate)

        self.candidate_path.write_bytes(b"{}" + b"x" * (4 * 1024 * 1024))
        with self.assertRaises(ProfileError):
            self._stage()
        self._assert_no_staged_candidate()

        fake = json.loads(json.dumps(self.candidate))
        fake["observations"][0]["evidence"][0]["ref"] = 99
        self._write_candidate(fake)
        with self.assertRaises(ProfileError):
            self._stage()
        self._assert_no_staged_candidate()

    def test_linked_candidate_input_is_rejected_when_links_are_available(self):
        if os.name == "nt":
            target = self.base / "candidate-junction-target"
            junction = self.base / "candidate-junction"
            target.mkdir()
            target_candidate = target / "host-candidate.json"
            target_candidate.write_bytes(self.candidate_path.read_bytes())
            env = os.environ.copy()
            env["CODEX_PRIVATE_CANDIDATE_JUNCTION"] = str(junction)
            env["CODEX_PRIVATE_CANDIDATE_TARGET"] = str(target)
            command = (
                "$ErrorActionPreference = 'Stop'; "
                "New-Item -ItemType Junction "
                "-Path $env:CODEX_PRIVATE_CANDIDATE_JUNCTION "
                "-Target $env:CODEX_PRIVATE_CANDIDATE_TARGET | Out-Null"
            )
            try:
                result = subprocess.run(
                    ["powershell", "-NoProfile", "-NonInteractive", "-Command", command],
                    env=env, capture_output=True, text=True, check=False)
            except (OSError, subprocess.SubprocessError) as error:
                self.skipTest(f"当前环境不支持 PowerShell Junction：{error}")
            if result.returncode != 0 or not junction.is_dir():
                detail = (result.stderr or result.stdout or "未知错误").strip()
                self.skipTest(f"当前环境无法创建 Junction：{detail}")
            candidate_path = junction / "host-candidate.json"
            try:
                with self.assertRaises(ProfileError):
                    private_chat.stage_candidate_file(
                        self.store, candidate_path, export_root=self.export,
                        bound_client="wechat")
                self._assert_no_staged_candidate()
            finally:
                # The target is a test directory under the fixture.  Remove
                # only the verified Junction itself; never recurse through it.
                os.rmdir(junction)
            return

        link = self.base / "candidate-link.json"
        try:
            os.symlink(self.candidate_path, link)
        except (OSError, NotImplementedError) as error:
            self.skipTest(f"当前环境不支持符号链接：{error}")
        try:
            with self.assertRaises(ProfileError):
                private_chat.stage_candidate_file(
                    self.store, link, export_root=self.export, bound_client="wechat")
            self._assert_no_staged_candidate()
        finally:
            if link.is_symlink():
                link.unlink()

    def test_unreviewed_or_changed_export_is_rejected(self):
        unreviewed = self._clone_export(
            "unreviewed", mutate=lambda review, manifest: (
                review.update(status="pending"),
                manifest["humanReview"].update(status="pending")),
        )
        with self.assertRaises(ProfileError):
            self._stage(export_root=unreviewed)
        self._assert_no_staged_candidate()

        changed = self.base / "changed-export"
        shutil.copytree(self.export, changed)
        messages = changed / "messages.jsonl"
        row = json.loads(messages.read_text(encoding="utf-8").splitlines()[0])
        row["text"] = "篡改后内容"
        messages.write_text(json.dumps(row, ensure_ascii=False) + "\n", encoding="utf-8")
        with self.assertRaises(ProfileError):
            self._stage(export_root=changed)
        self._assert_no_staged_candidate()

    def test_stale_base_is_rejected_without_creating_a_second_candidate(self):
        first = self.store.stage(self.request["requestId"], self.candidate)
        self.store.confirm(first["candidateId"], confirmed_by="synthetic reviewer")
        stale = dict(self.candidate)
        stale["observations"] = [dict(stale["observations"][0], text="过期候选")]
        self._write_candidate(stale)
        with self.assertRaises(ProfileError):
            self._stage()
        candidates = [path for path in (self.store.root / "candidates").glob("cand-*.json")
                      if not path.name.endswith(".preview.json")]
        self.assertEqual(len(candidates), 1)

    def test_same_identity_different_valid_batch_is_allowed(self):
        second_export = self._clone_export(
            "same-identity-batch-2", review_id="review-2", text="第二批次材料")
        second_request = self.store.prepare(second_export)
        self.assertEqual(second_request["status"], "ready")
        second_candidate = self._fixture.candidate(second_request, text="第二批次观察")
        second_path = self.base / "host-candidate-2.json"
        second_path.write_text(json.dumps(second_candidate, ensure_ascii=False), encoding="utf-8")

        # The ordinary menu is allowed to import another valid batch for the
        # same identity while the currently selected export remains the first
        # batch.  A material-window binding to the first request rejects it.
        result = private_chat.stage_candidate_file(
            self.store, second_path, export_root=self.export, bound_client="wechat")
        self.assertEqual(result["identity"]["accountKey"], second_request["accountKey"])
        self.assertEqual(result["identity"]["peerId"], second_request["peerId"])
        self.assertEqual(result["changes"][0]["evidence"][0]["text"], "第二批次材料")
        first_message = json.loads(
            (self.export / "messages.jsonl").read_text(encoding="utf-8").splitlines()[0])
        self.assertEqual(first_message["text"], "需要报价")
        self.assertIsNone(self.store.current("wechat", second_request["accountKey"], "peer-1"))
        with self.assertRaises(ProfileError):
            private_chat.stage_candidate_file(
                self.store, second_path, export_root=self.export, bound_client="wechat",
                expected_request_id=self.request["requestId"])


if __name__ == "__main__":
    unittest.main()
