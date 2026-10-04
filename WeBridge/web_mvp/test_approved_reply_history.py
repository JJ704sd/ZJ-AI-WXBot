"""Read-only approval evidence projection over temporary SQLite journals."""
from contextlib import closing
import json
import sqlite3
import unittest

import test_execution_history as fixtures
from execution_history import history


class ApprovedReplyHistoryTests(unittest.TestCase):
    def setUp(self):
        self.fixture = fixtures.HistoryTests()
        self.addCleanup(self.fixture.doCleanups)
        self.fixture.setUp()
        self.card = {'id':'synthetic-approved-card', 'name':'资料申请流程',
            'questions':['请说明资料申请流程'], 'sourceTitle':'批准流程资料', 'sourceVersion':'2026-10-04-v1',
            'sourceText':'填写申请表，由负责人核对。', 'replyText':'请填写申请表，由负责人核对。'}

    def insert(self, id, result, *, account='a', group='g', status='submitted_unconfirmed'):
        with closing(sqlite3.connect(self.fixture.root/'windows-auto-reply.sqlite')) as db, db:
            db.execute('INSERT INTO events VALUES (?,?,?,?,?,?)',
                (id,account,group,200,status,json.dumps(result,ensure_ascii=False)))

    def test_original_material_is_searchable_and_internal_fields_do_not_leak(self):
        result = {'decision':'reply', 'reasonCode':'matched', 'replyText':self.card['replyText'],
            'approvedPolicy':{'version':7, 'card':{**self.card, 'native':'PRIVATE_NATIVE'}, 'sourceRoot':'PRIVATE_SOURCE'},
            'binding':{'selfId':'PRIVATE_SELF'}}
        self.insert('approved-event',result)
        self.insert('other-account',result,account='b')
        self.insert('unwatched-group',result,group='hidden')
        for query in ('资料申请流程','批准流程资料','2026-10-04-v1'):
            with self.subTest(query=query):
                records = history(self.fixture.engine,self.fixture.hook,query=query)['records']
                self.assertEqual(len(records),1)
                record = records[0]
                self.assertEqual(record['approvedPolicy'],{'version':7,'card':self.card})
                self.assertEqual(record['reasonCode'],'matched')
                self.assertEqual(record['text'],self.card['replyText'])
                self.assertFalse(record['delivered'])
                self.assertNotIn('PRIVATE_',json.dumps(record))

    def test_unmatched_handoff_keeps_policy_version_without_inventing_a_card_or_answer(self):
        self.insert('unmatched',{'decision':'handoff','reasonCode':'unmatched','issue':'未匹配批准问法',
            'approvedPolicy':{'version':8,'card':None}},status='human_pending')
        self.fixture.draft('legacy-manual')
        records = history(self.fixture.engine,self.fixture.hook)['records']
        unmatched = next(record for record in records if record['id']=='reply:unmatched')
        self.assertEqual(unmatched['approvedPolicy'],{'version':8,'card':None})
        self.assertEqual(unmatched['reasonCode'],'unmatched')
        self.assertEqual(unmatched['text'],'')
        self.assertFalse(unmatched['textUnavailable'])
        manual = next(record for record in records if record['source']=='manual')
        self.assertIsNone(manual['approvedPolicy'])
        self.assertEqual(manual['reasonCode'],'')


if __name__ == '__main__':
    unittest.main()
