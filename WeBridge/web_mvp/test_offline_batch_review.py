"""Review once, then publish a selected batch. Invented records only."""
import json
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch
from offline_chat import ArchiveError
from offline_desktop import DesktopSession
from offline_review import REVIEW_CHECKS, publish_review
from test_offline_multiselect import multi_group_fixture

class BatchReviewTests(unittest.TestCase):
    def setUp(self):
        self.temp=tempfile.TemporaryDirectory(prefix='synthetic-reviewed-batch-')
        self.addCleanup(self.temp.cleanup)
        self.base=Path(self.temp.name)

    def prepare(self,client):
        source=self.base/client
        chats=multi_group_fixture(source,client)
        session=DesktopSession(self.base/(client+'-profile'),client=client)
        session.open_source({'sourceRoot':str(source)})
        parsed={chat:session.prepare_review(chat,copy_media=False) for chat in chats}
        return session,chats,parsed

    def approve(self,session,chat,parsed):
        session.activate_review(chat)
        return session.approve_review(parsed[chat]['review']['reviewId'],
            {key:True for key in REVIEW_CHECKS},'合成复核记录 '+chat,chat=chat)

    def test_approve_without_export_then_publish_all_and_skip_duplicates(self):
        for client in ('wechat','wecom'):
            with self.subTest(client=client):
                session,chats,parsed=self.prepare(client)
                a=self.approve(session,chats[0],parsed)
                self.assertFalse((session.directory/'exports').exists())
                with self.assertRaises(ArchiveError):session.export_reviewed(chats)
                self.assertFalse((session.directory/'exports').exists())
                b=self.approve(session,chats[1],parsed)
                result=session.export_reviewed(chats+chats)
                self.assertEqual(len(result['exports']),2)
                root=Path(result['output'])
                index=json.loads((root/'batch.json').read_text(encoding='utf8'))
                self.assertEqual({x['chat']['id'] for x in index['groups']},set(chats))
                for original,item in zip((a,b),result['exports']):
                    output=Path(item['output'])
                    review=json.loads((output/'review.json').read_text(encoding='utf8'))
                    self.assertEqual(review,original['review'])
                    self.assertEqual((output/'messages.jsonl').read_bytes(),
                                     (Path(parsed[review['chat']['id']]['view']['viewRoot'])/'messages.jsonl').read_bytes())
                    self.assertTrue((output/'messages.json').is_file() and (output/'messages.md').is_file())
                again=session.export_reviewed(chats)
                self.assertEqual(again['exports'],[])
                self.assertEqual(len(again['alreadyExported']),2)
                self.assertEqual(len(list((session.directory/'exports').iterdir())),1)

    def test_preflight_rejects_changed_or_reparsed_group_before_any_export(self):
        session,chats,parsed=self.prepare('wecom')
        for chat in chats:self.approve(session,chat,parsed)
        root=Path(parsed[chats[1]]['view']['viewRoot'])
        (root/'messages.jsonl').write_text('changed',encoding='utf8')
        with self.assertRaises(ArchiveError):session.export_reviewed(chats)
        self.assertFalse((session.directory/'exports').exists())
        self.assertEqual(session.review_status(chats[0]),'已复核')
        self.assertEqual(session.review_status(chats[1]),'待复核')
        session.prepare_review(chats[1],copy_media=False)
        with self.assertRaises(ArchiveError):session.export_reviewed(chats)
        session.open_source(session.settings['source'])
        with self.assertRaises(ArchiveError):session.export_reviewed(chats)

    def test_partial_export_can_retry_remaining_groups_without_duplicate(self):
        session,chats,parsed=self.prepare('wechat')
        for chat in chats:self.approve(session,chat,parsed)
        def fail_second(pending,*args,**kwargs):
            if pending['summary']['chat']['id']==chats[1]:raise PermissionError('private-error-sentinel')
            return publish_review(pending,*args,**kwargs)
        with patch('offline_review.publish_review',side_effect=fail_second):
            result=session.export_reviewed(chats)
        self.assertEqual(result['state'],'partial')
        self.assertEqual(len(result['exports']),1)
        self.assertNotIn('private-error',result['failed'][0]['error'])
        self.assertEqual(session.review_status(chats[0]),'已导出')
        self.assertEqual(session.review_status(chats[1]),'已复核')
        original=Path(result['exports'][0]['output'])
        again=session.export_reviewed(chats)
        self.assertEqual(len(again['exports']),1)
        self.assertEqual(len(again['alreadyExported']),1)
        self.assertTrue(original.is_dir())
        self.assertEqual(len(list((session.directory/'exports').rglob('review.json'))),2)

    def test_export_uses_only_selected_reviewed_ids(self):
        session,chats,parsed=self.prepare('wecom')
        for chat in chats:self.approve(session,chat,parsed)
        result=session.export_reviewed([chats[1]])
        self.assertEqual([x['report']['chat']['id'] for x in result['exports']],[chats[1]])
        self.assertEqual(session.review_status(chats[0]),'已复核')
        self.assertEqual(session.review_status(chats[1]),'已导出')
        with self.assertRaises(ArchiveError):session.export_reviewed([])

if __name__=='__main__':unittest.main()
