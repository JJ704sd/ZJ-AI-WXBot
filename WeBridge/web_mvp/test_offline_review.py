"""Synthetic end-to-end review gates; no real accounts or human conclusions."""
import hashlib
import json
from pathlib import Path
import tempfile
import unittest

from offline_chat import ArchiveError
from offline_desktop import DesktopSession
from offline_review import REVIEW_CHECKS
from offline_workflow import review_workflow
from test_database_adapter import create_metadata, create_shard, GROUP
from test_wecom_archive import fixture


class ReviewWorkflowTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix='synthetic-review-')
        self.addCleanup(self.temp.cleanup)
        self.base = Path(self.temp.name)

    def session(self, client):
        source = self.base / client
        if client == 'wechat':
            source.mkdir()
            create_metadata(source)
            create_shard(source, rows=[{'text': '复核合成正文'}])
            chat = GROUP
        else:
            fixture(source)
            chat = 'R:synthetic'
        session = DesktopSession(self.base / ('profile-' + client), client=client)
        session.open_source({'sourceRoot': str(source), 'includeMedia': False})
        return session, chat

    def test_both_clients_require_checks_then_publish_same_rows_and_receipt(self):
        for client in ('wechat', 'wecom'):
            with self.subTest(client=client):
                session, chat = self.session(client)
                parsed = session.prepare_review(chat, copy_media=False)
                root = Path(parsed['view']['viewRoot'])
                original = (root / 'messages.jsonl').read_bytes()
                self.assertIsNone(session.last_export)
                self.assertFalse((session.directory / 'exports').exists())
                rid = parsed['review']['reviewId']
                for checks in ({}, {key: False for key in REVIEW_CHECKS}, {key: 1 for key in REVIEW_CHECKS}):
                    with self.assertRaises(ArchiveError):
                        session.confirm_export(rid, checks, chat=chat)
                exported = session.confirm_export(rid, {key: True for key in REVIEW_CHECKS}, '合成测试确认，不代表人工实测', chat=chat)
                output = Path(exported['output'])
                self.assertEqual((output / 'messages.jsonl').read_bytes(), original)
                rows = [json.loads(line) for line in original.splitlines()]
                self.assertEqual(json.loads((output / 'messages.json').read_text(encoding='utf8')), rows)
                self.assertIn(rows[0]['senderId'], (output / 'messages.md').read_text(encoding='utf8'))
                self.assertEqual(set(exported['exportFiles']), {'json', 'jsonl', 'md'})
                review = json.loads((output / 'review.json').read_text(encoding='utf8'))
                self.assertEqual(review['status'], 'confirmed')
                self.assertEqual(review['chat']['id'], chat)
                self.assertEqual(review['client'], client)
                manifest = json.loads((output / 'manifest.json').read_text(encoding='utf8'))
                self.assertEqual(manifest['humanReview']['reviewId'], rid)
                for item in manifest['artifacts']:
                    self.assertEqual(hashlib.sha256((output / item['path']).read_bytes()).hexdigest(), item['sha256'])
                self.assertIn(str(output), manifest['reporting']['presentation']['cwd'])
                with self.assertRaises(ArchiveError):
                    session.confirm_export(rid, {key: True for key in REVIEW_CHECKS})

    def test_tampered_preview_and_stale_group_or_source_cannot_be_confirmed(self):
        session, chat = self.session('wechat')
        parsed = session.prepare_review(chat, copy_media=False)
        checks = {key: True for key in REVIEW_CHECKS}
        with self.assertRaises(ArchiveError):
            session.confirm_export(parsed['review']['reviewId'], checks, chat='another-group')
        root = Path(parsed['view']['viewRoot'])
        (root / 'messages.jsonl').write_text('changed', encoding='utf8')
        with self.assertRaisesRegex(ArchiveError, '变化'):
            session.confirm_export(parsed['review']['reviewId'], checks, chat=chat)
        self.assertIsNone(session.last_export)
        session.open_source({'sourceRoot': str(self.base / 'wechat')})
        with self.assertRaises(ArchiveError):
            session.confirm_export(parsed['review']['reviewId'], checks, chat=chat)

    def test_reparse_invalidates_previous_review_and_preserves_date_filter(self):
        session, chat = self.session('wecom')
        old = session.prepare_review(chat, copy_media=False)
        new = session.prepare_review(chat, start='2099-01-01', copy_media=False)
        self.assertEqual(new['review']['exportedRows'], 0)
        with self.assertRaises(ArchiveError):
            session.confirm_export(old['review']['reviewId'], {key: True for key in REVIEW_CHECKS})
        exported = session.confirm_export(new['review']['reviewId'], {key: True for key in REVIEW_CHECKS})
        self.assertEqual(exported['report']['startDate'], '2099-01-01')
        self.assertEqual(json.loads(Path(exported['exportFiles']['json']).read_text(encoding='utf8')), [])

    def test_script_cancel_keeps_preview_and_confirm_exports_three_formats(self):
        source = self.base / 'source'
        fixture(source)
        for accepted in (False, True):
            responses = iter(['R:synthetic', '', ''] + ['y' if accepted else 'n'] * 4 + (['合成复核', 'EXPORT'] if accepted else []))
            shown = []
            directory = self.base / ('accept' if accepted else 'cancel')
            result = review_workflow(client='wecom', directory=directory,
                                     config={'sourceRoot': str(source)}, ask=lambda _: next(responses), show=shown.append)
            self.assertTrue(any('R:synthetic\t企微合成群' in line for line in shown))
            self.assertEqual(result['state'], 'completed' if accepted else 'awaiting_review')
            self.assertEqual((directory / 'exports').exists(), accepted)


if __name__ == '__main__':
    unittest.main()
