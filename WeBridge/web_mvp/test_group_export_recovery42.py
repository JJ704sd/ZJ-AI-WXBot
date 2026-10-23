"""Group export interruption and derived-index regression tests on synthetic data."""
import json
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch

from offline_analysis import build_batch
from offline_chat import ArchiveError
from offline_desktop import DesktopSession
from offline_review import REVIEW_CHECKS, inventory, publish_review
from test_offline_multiselect import multi_group_fixture


class GroupExportRecovery42Tests(unittest.TestCase):
    def setUp(self):
        temporary = tempfile.TemporaryDirectory(prefix='synthetic-group42-')
        self.addCleanup(temporary.cleanup)
        self.base = Path(temporary.name)

    def prepared(self, client='wechat'):
        base = self.base / client
        base.mkdir()
        chats = multi_group_fixture(base / 'source', client)
        session = DesktopSession(base / 'profile', client=client)
        session.open_source({'sourceRoot': str(base / 'source')})
        for chat in chats:
            parsed = session.prepare_review(chat, copy_media=False)
            session.approve_review(parsed['review']['reviewId'],
                                   {key: True for key in REVIEW_CHECKS},
                                   '合成群聊复核', chat=chat)
        session.remember_selection(chats, chats[0])
        return session, chats

    def test_analysis_failure_is_partial_and_repair_restores_analysis_without_republishing(self):
        for client in ('wechat', 'wecom'):
            with self.subTest(client=client):
                session, chats = self.prepared(client)
                with patch('offline_analysis.build_batch', side_effect=OSError('synthetic disk failure')):
                    result = session.export_reviewed(chats)
                self.assertEqual(result['state'], 'partial')
                self.assertFalse(result['metadataComplete'])
                self.assertEqual(result['metadataErrors'][0]['file'], 'batch-analysis')
                root = Path(result['output'])
                bodies = {item['output']: inventory(item['output']) for item in result['exports']}
                repaired = session.repair_export_metadata(root)
                self.assertEqual(repaired['state'], 'completed')
                index = json.loads((root / 'batch.json').read_text(encoding='utf8'))
                self.assertEqual(index['analysis']['groups'], 2)
                self.assertNotIn('analysisError', index)
                for directory, before in bodies.items():
                    self.assertEqual(inventory(directory), before)

    def test_repair_preserves_analysis_entry_and_failed_rebuild_preserves_previous_index(self):
        session, chats = self.prepared()
        exported = session.export_reviewed(chats)
        root = Path(exported['output'])
        previous = inventory(root / 'batch-analysis')
        with patch('offline_analysis._timeline', side_effect=OSError('synthetic derived failure')):
            failed = session.repair_export_metadata(root)
        self.assertFalse(failed['metadataComplete'])
        self.assertEqual(inventory(root / 'batch-analysis'), previous)
        repaired = session.repair_export_metadata(root)
        self.assertTrue(repaired['metadataComplete'])
        index = json.loads((root / 'batch.json').read_text(encoding='utf8'))
        self.assertEqual(index['analysis']['groups'], 2)
        self.assertEqual(inventory(root / 'batch-analysis'), previous)

    def test_all_group_targets_survive_interruption_before_second_publish(self):
        for client in ('wechat', 'wecom'):
            with self.subTest(client=client):
                session, chats = self.prepared(client)
                def interrupt(event):
                    if event['stage'] == 'saved':
                        raise RuntimeError('synthetic interruption after first saved')
                with self.assertRaisesRegex(RuntimeError, 'synthetic interruption'):
                    session.export_reviewed(chats, progress=interrupt)
                root = session.last_batch_root
                resumed = DesktopSession(session.directory, client=client)
                info = resumed.bootstrap(resume=True)
                self.assertEqual(info['restoredPublished'], 1)
                self.assertEqual(info['restoredReviews'], 1)
                repaired = resumed.repair_export_metadata(root)
                self.assertEqual(repaired['state'], 'partial')
                self.assertEqual([item['chatId'] for item in repaired['failed']], [chats[1]])
                retried = resumed.export_reviewed(chats)
                self.assertEqual(len(retried['exports']), 1)
                self.assertEqual(len(retried['alreadyExported']), 1)

    def test_target_plan_checkpoint_failure_does_not_publish_or_change_pending_intents(self):
        session, chats = self.prepared()
        with patch.object(session, '_checkpoint', side_effect=ArchiveError('synthetic checkpoint failure')):
            with self.assertRaisesRegex(ArchiveError, 'checkpoint'):
                session.export_reviewed(chats)
        self.assertTrue(all('exportTarget' not in pending for pending in session._reviews.values()))
        self.assertEqual(list((session.directory / 'exports').rglob('review.json')), [])

    def test_plan_interrupted_before_first_copy_restores_original_batch_location(self):
        session, chats = self.prepared()
        def interrupt(event):
            if event['stage'] == 'exporting':
                raise RuntimeError('synthetic interruption before copying')
        with self.assertRaisesRegex(RuntimeError, 'before copying'):
            session.export_reviewed(chats, progress=interrupt)
        resumed = DesktopSession(session.directory)
        info = resumed.bootstrap(resume=True)
        self.assertEqual(info['restoredReviews'], 2)
        self.assertEqual(info['restoredPublished'], 0)
        self.assertEqual(resumed.last_batch_root, session.last_batch_root)
        repaired = resumed.repair_export_metadata(resumed.last_batch_root)
        self.assertEqual(repaired['state'], 'partial')
        self.assertEqual(len(repaired['failed']), 2)

    def test_analysis_replace_failure_restores_previous_complete_directory(self):
        session, chats = self.prepared()
        exported = session.export_reviewed(chats)
        root = Path(exported['output'])
        previous = inventory(root / 'batch-analysis')
        rename = Path.rename
        def fail_stage(path, target):
            if (path.name.startswith('.batch-analysis-') and
                    not path.name.startswith('.batch-analysis-previous-')):
                raise PermissionError('synthetic replacement failure')
            return rename(path, target)
        with patch.object(Path, 'rename', fail_stage):
            failed = session.repair_export_metadata(root)
        self.assertFalse(failed['metadataComplete'])
        self.assertEqual(inventory(root / 'batch-analysis'), previous)

    def test_progress_reports_saved_failure_analysis_and_completion_without_swallowing_errors(self):
        session, chats = self.prepared()
        events = []
        original = session._publish_pending
        def fail_second(pending, destination):
            if pending['summary']['chat']['id'] == chats[1]:
                raise OSError('synthetic second export failure')
            return original(pending, destination)
        with patch.object(session, '_publish_pending', side_effect=fail_second):
            result = session.export_reviewed(chats, progress=events.append)
        self.assertEqual(result['state'], 'partial')
        self.assertEqual([event['stage'] for event in events],
                         ['validating', 'exporting', 'saved', 'exporting', 'failed', 'analysis', 'completed'])
        self.assertTrue(all(event['total'] == 2 for event in events))
        self.assertEqual(events[-1]['completed'], 1)
        self.assertEqual(events[2]['chatId'], chats[0])
        self.assertEqual(events[4]['chatId'], chats[1])

    def test_publish_hashes_staged_body_once_but_still_rejects_changed_copy(self):
        session, chats = self.prepared()
        pending = session._reviews[chats[0]]
        from database_snapshot import _hash_file
        calls = []
        def counted(path):
            if Path(path).name == 'messages.jsonl' and '.review-export-' in str(path):
                calls.append(str(path))
            return _hash_file(path)
        with patch('offline_review._hash_file', side_effect=counted):
            report = publish_review(pending, self.base / 'published')
        self.assertEqual(len(calls), 1)
        self.assertEqual(report['artifacts'], [entry for entry in inventory(self.base / 'published')
                                              if entry['path'] != 'manifest.json'])
        import shutil
        copytree = shutil.copytree
        def changed_copy(source, target, *args, **kwargs):
            result = copytree(source, target, *args, **kwargs)
            if Path(source) == pending['root']:
                (Path(target) / 'messages.jsonl').write_text('changed', encoding='utf8')
            return result
        with patch('offline_review.shutil.copytree', side_effect=changed_copy):
            with self.assertRaisesRegex(ArchiveError, '变化'):
                publish_review(pending, self.base / 'rejected')
        self.assertFalse((self.base / 'rejected').exists())


if __name__ == '__main__':
    unittest.main()
