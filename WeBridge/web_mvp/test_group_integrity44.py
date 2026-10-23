"""Synthetic operation-boundary checks; no client processes or account data."""
from contextlib import closing
import json
import os
from pathlib import Path
import sqlite3
import tempfile
import threading
import unittest
from unittest.mock import patch

from offline_chat import ArchiveError
from offline_desktop import DesktopSession
from offline_review import REVIEW_CHECKS
from test_offline_multiselect import multi_group_fixture


class GroupIntegrity44Tests(unittest.TestCase):
    def setUp(self):
        temporary = tempfile.TemporaryDirectory(prefix='synthetic-integrity44-')
        self.addCleanup(temporary.cleanup)
        self.base = Path(temporary.name)

    def prepared(self, client):
        base = self.base / client
        base.mkdir()
        chats = multi_group_fixture(base / 'source', client)
        if client == 'wechat':
            with closing(sqlite3.connect(base / 'source/message/media_0.db')) as db, db:
                db.execute('CREATE TABLE synthetic_voice(payload BLOB)')
                db.execute('INSERT INTO synthetic_voice VALUES(zeroblob(4096))')
        session = DesktopSession(base / 'profile', client=client)
        session.open_source({'sourceRoot': str(base / 'source'), 'includeVoice': client == 'wechat'})
        reviews, bodies = {}, {}
        for chat in chats:
            parsed = session.prepare_review(chat, copy_media=False)
            reviews[chat] = parsed['review']['reviewId']
            bodies[chat] = (Path(parsed['view']['viewRoot']) / 'messages.jsonl').read_bytes()
        session.approve_reviews(reviews, {key: True for key in REVIEW_CHECKS})
        target = session.archive.root / ('message/media_0.db' if client == 'wechat' else 'message.db')
        return session, chats, bodies, target

    @staticmethod
    def change_preserving_stamp(path):
        stamp = path.stat()
        original = path.read_bytes()
        changed = bytearray(original)
        changed[-1] ^= 1
        path.write_bytes(changed)
        os.utime(path, ns=(stamp.st_atime_ns, stamp.st_mtime_ns))
        return original, stamp

    def test_change_after_last_publish_is_partial_and_keeps_verified_outputs(self):
        for client in ('wechat', 'wecom'):
            with self.subTest(client=client):
                session, chats, bodies, target = self.prepared(client)
                restored = []
                events = []
                def change(event):
                    events.append(event['stage'])
                    if event['stage'] == 'saved' and event['completed'] == len(chats):
                        restored.append(self.change_preserving_stamp(target))
                result = session.export_reviewed(chats, progress=change)
                self.assertEqual(result['state'], 'partial')
                self.assertNotIn('completed', events)
                self.assertFalse(result['metadataComplete'])
                self.assertTrue(any(item['file'] == 'source_snapshot' for item in result['metadataErrors']))
                self.assertEqual(len(result['exports']), len(chats))
                for item in result['exports']:
                    self.assertEqual((Path(item['output']) / 'messages.jsonl').read_bytes(), bodies[item['report']['chat']['id']])
                index = json.loads((Path(result['output']) / 'batch.json').read_text(encoding='utf8'))
                self.assertEqual(index['state'], 'partial')
                with self.assertRaisesRegex(ArchiveError, '变化'):
                    session.export_reviewed(chats)
                original, stamp = restored[0]
                target.write_bytes(original)
                os.utime(target, ns=(stamp.st_atime_ns, stamp.st_mtime_ns))
                self.assertEqual(session.export_reviewed(chats)['state'], 'completed')

    def test_repair_end_check_catches_same_size_change_and_preserves_published_bodies(self):
        for client in ('wechat', 'wecom'):
            with self.subTest(client=client):
                session, chats, bodies, target = self.prepared(client)
                exported = session.export_reviewed(chats)
                root = Path(exported['output'])
                replace = os.replace
                changed = []
                def replace_then_change(source, destination):
                    value = replace(source, destination)
                    if Path(destination) == root / 'batch.json' and not changed:
                        changed.append(self.change_preserving_stamp(target))
                    return value
                with patch('offline_review.os.replace', side_effect=replace_then_change):
                    result = session.repair_export_metadata(root)
                self.assertEqual(result['state'], 'partial')
                self.assertTrue(any(item['file'] == 'source_snapshot' for item in result['metadataErrors']))
                self.assertEqual(json.loads((root / 'batch.json').read_text(encoding='utf8'))['state'], 'partial')
                for item in exported['exports']:
                    self.assertEqual((Path(item['output']) / 'messages.jsonl').read_bytes(), bodies[item['report']['chat']['id']])

    def test_interrupted_batch_keeps_original_error_and_next_operation_rechecks(self):
        session, chats, _, target = self.prepared('wechat')
        changed = []
        def interrupt(event):
            if event['stage'] == 'saved':
                changed.append(self.change_preserving_stamp(target))
                raise RuntimeError('synthetic interrupted batch')
        with self.assertRaisesRegex(RuntimeError, 'synthetic interrupted batch'):
            session.export_reviewed(chats, progress=interrupt)
        self.assertEqual(len(session._exports), 1)
        with self.assertRaisesRegex(ArchiveError, '变化'):
            session.archive.groups()
        original, stamp = changed[0]
        target.write_bytes(original)
        os.utime(target, ns=(stamp.st_atime_ns, stamp.st_mtime_ns))
        result = session.export_reviewed(chats)
        self.assertEqual(result['state'], 'completed')
        self.assertEqual(len(result['alreadyExported']), 1)

    def test_separate_thread_does_not_reuse_running_batch_validation(self):
        session, chats, _, target = self.prepared('wecom')
        errors = []
        def independent_read():
            try:
                session.archive.groups()
            except ArchiveError as error:
                errors.append(str(error))
        def concurrent_change(event):
            if event['stage'] != 'saved' or event['completed'] != 1:
                return
            original, stamp = self.change_preserving_stamp(target)
            try:
                worker = threading.Thread(target=independent_read)
                worker.start()
                worker.join(timeout=5)
                self.assertFalse(worker.is_alive())
            finally:
                target.write_bytes(original)
                os.utime(target, ns=(stamp.st_atime_ns, stamp.st_mtime_ns))
        result = session.export_reviewed(chats, progress=concurrent_change)
        self.assertEqual(result['state'], 'completed')
        self.assertEqual(len(errors), 1)
        self.assertIn('变化', errors[0])


if __name__ == '__main__':
    unittest.main()
