"""Restart recovery is checked only against isolated, invented account data."""
from pathlib import Path
from contextlib import closing
import json
import hashlib
import sqlite3
import tempfile
import unittest
from unittest.mock import patch

from offline_desktop import DesktopSession
from offline_chat import ArchiveError
from offline_review import REVIEW_CHECKS
from test_offline_multiselect import multi_group_fixture
from test_wecom_archive import fixture,pb
from offline_view import document_path


class ReviewProgressTests(unittest.TestCase):
    def test_opening_an_attachment_does_not_invalidate_review_or_restart_recovery(self):
        with tempfile.TemporaryDirectory(prefix='synthetic-view-before-review-') as folder:
            base=Path(folder);source=base/'source';fixture(source)
            cache=source/'Cache/File';cache.mkdir(parents=True)
            data='合成附件业务资料'.encode('utf8');(cache/'requirement.txt').write_bytes(data)
            body=pb(2,'requirement.txt')+pb(4,len(data))+pb(10,hashlib.md5(data).hexdigest())
            with closing(sqlite3.connect(source/'message.db')) as db,db:
                db.execute('INSERT INTO message_table VALUES(?,?,?,?,?,?,?,?,?,?,?)',
                    (3,13,3,11,'R:synthetic',20,1700000003,0,body,b'',b''))
            session=DesktopSession(base/'profile',client='wecom');session.open_source({'sourceRoot':str(source)})
            parsed=session.prepare_review('R:synthetic',copy_media=True)
            root=Path(parsed['view']['viewRoot']);row=json.loads((root/'messages.json').read_text(encoding='utf8'))[-1]
            self.assertEqual(document_path(root,row['asset']).read_bytes(),data)
            session.approve_review(parsed['review']['reviewId'],{key:True for key in REVIEW_CHECKS})
            resumed=DesktopSession(session.directory,client='wecom');resumed.bootstrap(resume=True)
            self.assertEqual(resumed.review_status('R:synthetic'),'已复核')
            result=resumed.export_reviewed(['R:synthetic'])
            self.assertFalse((Path(result['exports'][0]['output'])/'opened').exists())

    def prepared(self, base, client='wecom'):
        source=base/'source';chats=multi_group_fixture(source,client)
        session=DesktopSession(base/'profile',client=client)
        session.open_source({'sourceRoot':str(source)})
        parsed={chat:session.prepare_review(chat,copy_media=False) for chat in chats}
        session.remember_selection(chats,chats[-1])
        return session,chats,parsed

    def test_restart_restores_exact_unexported_previews_and_confirmations(self):
        for client in ('wechat','wecom'):
            with self.subTest(client=client),tempfile.TemporaryDirectory(prefix='synthetic-review-resume-') as folder:
                base=Path(folder);source=base/'source';chats=multi_group_fixture(source,client)
                session=DesktopSession(base/'profile',client=client)
                session.open_source({'sourceRoot':str(source)})
                first=session.prepare_review(chats[0],copy_media=False)
                self.assertEqual(first['review']['snapshotTime'],json.loads((session.archive.root/'manifest.json').read_text(encoding='utf8'))['createdAt'])
                session.approve_review(first['review']['reviewId'],{key:True for key in REVIEW_CHECKS},'合成确认，不代表人工验收')
                second=session.prepare_review(chats[1],copy_media=False)
                resumed=DesktopSession(session.directory,client=client)
                info=resumed.bootstrap(resume=True)
                self.assertEqual(resumed.review_status(chats[0]),'已复核')
                self.assertEqual(resumed.review_status(chats[1]),'待复核')
                self.assertEqual(info['restoredReviews'],2)
                resumed.activate_review(chats[0])
                self.assertEqual(resumed.pending_review['summary']['reviewId'],first['review']['reviewId'])
                self.assertEqual(resumed.pending_review['approval']['note'],'合成确认，不代表人工验收')
                self.assertEqual(resumed.preview(chats[1])['viewRoot'],second['view']['viewRoot'])
                self.assertFalse((session.directory/'exports').exists())

    def test_resume_uses_frozen_snapshot_until_an_explicit_refresh(self):
        with tempfile.TemporaryDirectory(prefix='synthetic-frozen-resume-') as folder:
            base=Path(folder);session,chats,parsed=self.prepared(base)
            old_rows=parsed[chats[0]]['report']['exportedRows']
            with closing(sqlite3.connect(base/'source/message.db')) as db,db:
                db.execute('INSERT INTO message_table SELECT 50,500,50,sender_id,conversation_id,content_type,send_time+100,flag,content,extra_content,local_extra_content FROM message_table WHERE message_id=1')
            resumed=DesktopSession(session.directory,client='wecom')
            info=resumed.bootstrap(resume=True)
            self.assertIn('上次副本',info['message'])
            self.assertEqual(info['resumeSelection'],chats)
            self.assertEqual(info['resumeActiveChat'],chats[-1])
            self.assertEqual(resumed.preview(chats[0])['sourceTotal'],old_rows)
            resumed.open_source(resumed.settings['source'])
            self.assertEqual(resumed.review_status(chats[0]),'未解析')
            self.assertGreater(resumed.prepare_review(chats[0],copy_media=False)['report']['exportedRows'],old_rows)

    def test_changed_preview_is_rejected_but_other_review_survives(self):
        with tempfile.TemporaryDirectory(prefix='synthetic-changed-preview-') as folder:
            session,chats,parsed=self.prepared(Path(folder))
            session.activate_review(chats[0])
            session.approve_review(parsed[chats[0]]['review']['reviewId'],{key:True for key in REVIEW_CHECKS})
            (Path(parsed[chats[1]]['view']['viewRoot'])/'messages.jsonl').write_text('changed',encoding='utf8')
            resumed=DesktopSession(session.directory,client='wecom');info=resumed.bootstrap(resume=True)
            self.assertEqual(info['restoredReviews'],1)
            self.assertEqual(resumed.review_status(chats[0]),'已复核')
            self.assertEqual(resumed.review_status(chats[1]),'未解析')
            self.assertNotIn(chats[1],info['resumeSelection'])

    def test_changed_snapshot_foreign_source_and_legacy_state_never_restore_approval(self):
        for alteration in ('snapshot','source','legacy'):
            with self.subTest(alteration=alteration),tempfile.TemporaryDirectory(prefix='synthetic-invalid-resume-') as folder:
                session,chats,parsed=self.prepared(Path(folder))
                session.activate_review(chats[0]);session.approve_review(parsed[chats[0]]['review']['reviewId'],{key:True for key in REVIEW_CHECKS})
                path=session.directory/'reviews/session-v1.json'
                value=json.loads(path.read_text(encoding='utf8'))
                if alteration=='snapshot':
                    (session.archive.root/'manifest.json').write_text('{}',encoding='utf8')
                elif alteration=='source':
                    value['sourceRoot']=str(Path(folder)/'other-account');path.write_text(json.dumps(value),encoding='utf8')
                else:path.unlink()
                resumed=DesktopSession(session.directory,client='wecom');info=resumed.bootstrap(resume=True)
                self.assertEqual(info['status'],'ready')
                self.assertEqual(resumed.review_status(chats[0]),'未解析')
                self.assertFalse((session.directory/'exports').exists())

    def test_failed_checkpoint_does_not_mark_any_group_confirmed(self):
        with tempfile.TemporaryDirectory(prefix='synthetic-checkpoint-failure-') as folder:
            session,chats,parsed=self.prepared(Path(folder))
            ids={chat:parsed[chat]['review']['reviewId'] for chat in chats}
            with patch('offline_progress.os.replace',side_effect=PermissionError):
                with self.assertRaises(ArchiveError):session.approve_reviews(ids,{key:True for key in REVIEW_CHECKS})
            self.assertTrue(all(session.review_status(chat)=='待复核' for chat in chats))
            resumed=DesktopSession(session.directory,client='wecom');resumed.bootstrap(resume=True)
            self.assertTrue(all(resumed.review_status(chat)=='待复核' for chat in chats))

    def test_published_export_is_not_restored_when_final_checkpoint_is_interrupted(self):
        with tempfile.TemporaryDirectory(prefix='synthetic-export-intent-') as folder:
            session,chats,parsed=self.prepared(Path(folder))
            session.activate_review(chats[0]);session.approve_review(parsed[chats[0]]['review']['reviewId'],{key:True for key in REVIEW_CHECKS})
            save=session._progress.save
            def fail_after_publish(archive,reviews,ui):
                if chats[0] not in reviews:raise ArchiveError('synthetic_write_interruption')
                return save(archive,reviews,ui)
            with patch.object(session._progress,'save',side_effect=fail_after_publish):
                exported=session.export_reviewed([chats[0]])
            self.assertEqual(len(exported['exports']),1)
            resumed=DesktopSession(session.directory,client='wecom');info=resumed.bootstrap(resume=True)
            self.assertEqual(info['restoredReviews'],1)
            self.assertEqual(resumed.review_status(chats[1]),'待复核')
            self.assertEqual(len(list((session.directory/'exports').rglob('review.json'))),1)

    def test_saved_approval_metadata_change_restores_preview_as_unreviewed(self):
        with tempfile.TemporaryDirectory(prefix='synthetic-review-metadata-') as folder:
            session,chats,parsed=self.prepared(Path(folder))
            session.activate_review(chats[0]);session.approve_review(parsed[chats[0]]['review']['reviewId'],{key:True for key in REVIEW_CHECKS})
            path=session.directory/'reviews/session-v1.json';value=json.loads(path.read_text(encoding='utf8'))
            value['reviews'][0]['approval']['startDate']='2099-01-01'
            path.write_text(json.dumps(value),encoding='utf8')
            resumed=DesktopSession(session.directory,client='wecom');resumed.bootstrap(resume=True)
            self.assertEqual(resumed.review_status(chats[0]),'待复核')

    def test_fresh_metadata_load_does_not_erase_another_saved_review(self):
        with tempfile.TemporaryDirectory(prefix='synthetic-readonly-start-') as folder:
            session,chats,parsed=self.prepared(Path(folder))
            session.activate_review(chats[0]);session.approve_review(parsed[chats[0]]['review']['reviewId'],{key:True for key in REVIEW_CHECKS})
            DesktopSession(session.directory,client='wecom').bootstrap()
            resumed=DesktopSession(session.directory,client='wecom');resumed.bootstrap(resume=True)
            self.assertEqual(resumed.review_status(chats[0]),'已复核')


if __name__=='__main__':unittest.main()
