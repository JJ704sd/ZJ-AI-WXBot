"""HTTP approval/CAS boundaries; all data and Hook replies are synthetic."""
from contextlib import closing
import json
import unittest
from unittest.mock import patch

import test_handoff_http as fixtures
from test_approved_reply_acceptance import ApprovedFixture, approved_card
from test_database_adapter import PEER, MIXED


class ApprovedReplyHttpTests(unittest.TestCase):
    def setUp(self):
        self.http = fixtures.HandoffHttpTests()
        self.addCleanup(self.http.doCleanups)
        self.http.setUp()
        self.a = ApprovedFixture(self.http.f)
        self.f = self.a.f

    def save(self, **changes):
        return self.http.request('POST','/api/reply/policy',self.a.payload(**changes))

    def preview(self, **changes):
        values = self.a.payload();values.pop('enabled');values.pop('cooldown')
        return self.http.request('POST','/api/reply/policy/preview',
            {**values,'text':self.a.card['questions'][0],**changes})

    def get(self, **changes):
        return self.http.get('/api/reply/policy',groupId=self.f.group,**changes)

    def storage(self):
        with closing(self.f.service._db()) as db:
            return tuple([tuple(row) for row in db.execute('SELECT * FROM '+table)]
                         for table in ('rules','baselines','events','handoffs','handoff_notifications'))

    def test_draft_preview_and_cas_are_explicit_and_do_not_probe_or_write_preview(self):
        f = self.f;f.ready = False
        with patch.object(f.service,'sender_factory',side_effect=AssertionError('Draft and preview must not contact Hook')):
            code,policy = self.get();self.assertEqual(code,200);self.assertEqual(policy['version'],0)
            before = self.storage()
            code,result = self.preview()
            self.assertEqual(code,200);self.assertEqual(result['reasonCode'],'matched')
            self.assertEqual(result['matchedCard'],self.a.card)
            self.assertEqual(result['replyText'],self.a.card['replyText'])
            self.assertEqual(result['policyVersion'],0);self.assertEqual(self.storage(),before)
            code,policy = self.save(enabled=False)
            self.assertEqual(code,200);self.assertEqual(policy['version'],1)
            self.assertEqual(policy['cards'],[self.a.card]);self.assertFalse(policy['enabled'])
            code,error = self.save(enabled=False,version=0)
            self.assertEqual((code,error['code']),(409,'policy_conflict'))
            self.assertEqual(self.preview(version=0)[0],409)
            self.assertNotIn('sourceRoot',json.dumps(self.get()[1]))
        self.assertEqual(f.posts,[])

    def test_http_authorization_scope_and_card_validation_precede_native_probe(self):
        payload = self.a.payload()
        with patch.object(self.f.service,'sender_factory',side_effect=AssertionError('Invalid input must not probe Hook')):
            for headers in ({'Origin':'https://untrusted.invalid'},{'Host':'untrusted.invalid'},
                            {'X-CSRF-Token':''},{'Sec-Fetch-Site':'cross-site'}):
                with self.subTest(headers=headers):
                    for path in ('/api/reply/policy','/api/reply/policy/preview'):
                        self.assertEqual(self.http.request('POST',path,payload,**headers)[0],403)
            self.assertEqual(self.http.request('GET','/api/reply/policy',Host='untrusted.invalid')[0],403)
            self.assertEqual(self.get(account='other')[0],400)
            for change in ({'account':'other'},{'groupId':PEER},{'groupId':MIXED},{'version':True},
                           {'enabled':'true'},{'cooldown':True},{'cooldown':4},{'cards':[]},
                           {'cards':[approved_card(questions=['same',' same '])]},
                           {'cards':[approved_card(),approved_card(id='approved-card-synthetic-002')]},
                           {'cards':[approved_card(sourceText='x'*2001)]},
                           {'cards':[approved_card(replyText='bad\x00text')]},
                           {'cards':[approved_card(questions=['x'*501])]}):
                with self.subTest(change=change):self.assertEqual(self.save(**change)[0],400)
        self.assertEqual(self.a.counts(),(0,0,0,0));self.assertEqual(self.f.posts,[])

    def test_only_policy_routes_allow_one_megabyte_and_preview_cannot_grant_mention_authority(self):
        padding = 'x'*(300*1024)
        code,result = self.preview(padding=padding)
        self.assertEqual(code,200);self.assertEqual(result['reasonCode'],'matched')
        exact = self.a.payload(enabled=False,padding='')
        exact['padding'] = 'x'*(1024*1024-len(json.dumps(exact).encode('utf-8')))
        self.assertEqual(len(json.dumps(exact).encode('utf-8')),1024*1024)
        self.assertEqual(self.http.request('POST','/api/reply/policy',exact)[0],200)
        # The server rejects the declared length before reading a body. Sending
        # an unread megabyte races Windows TCP reset against its 400 response.
        for path,limit in (('/api/reply/policy',1024*1024),('/api/reply/policy/preview',1024*1024),
                           ('/api/reply',32768),('/api/jobs/batch/preview',262144)):
            with self.subTest(path=path):
                self.assertEqual(self.http.request('POST',path,{},**{'Content-Length':str(limit+1)})[0],400)
        self.assertEqual(self.a.counts(),(0,0,0,0));self.assertEqual(self.f.posts,[])
        self.assertTrue(self.http.get('/api/state')[1]['runtime']['capabilities']['approvedReplies'])

    def test_draft_preserves_legacy_rule_and_old_endpoint_cannot_reenable_approved_sending(self):
        f = self.f
        existing = self.a.row(80,'启用前已有的未来时间戳',time=f.now+50)
        self.a.snapshot([existing])
        f.service.configure(f.account,f.group,True,'旧固定话术',60,mode='reply')
        before = f.service._rule(f.account,f.group)
        with closing(f.service._db()) as db:baseline = list(map(tuple,db.execute('SELECT * FROM baselines')))
        self.assertEqual(len(baseline),1)
        self.a.snapshot([existing,self.a.row(81,'启用后待处理的另一条消息',time=f.now+60)])
        code,draft = self.save(enabled=False,cooldown=5)
        self.assertEqual(code,200)
        after = f.service._rule(f.account,f.group)
        for key in ('enabled','mode','text','cooldown','activated','lastSent','binding','native','issue'):
            self.assertEqual(after[key],before[key],key)
        with closing(f.service._db()) as db:self.assertEqual(list(map(tuple,db.execute('SELECT * FROM baselines'))),baseline)
        self.assertEqual(self.save()[0],200)
        old = {'account':f.account,'groupId':f.group,'enabled':True,'text':'must not replace approved cards','cooldown':30}
        self.assertEqual(self.http.request('POST','/api/reply',old)[0],400)
        self.assertEqual(self.http.request('POST','/api/reply',{**old,'enabled':False})[0],200)
        closed = self.get()[1];self.assertFalse(closed['enabled']);self.assertEqual(closed['cards'],[self.a.card])
        self.assertGreater(closed['version'],draft['version'])
        self.assertEqual(self.save(version=draft['version'])[0],409)
        self.assertEqual(self.http.request('POST','/api/reply',{**old,'mode':'handoff','text':''})[0],200)
        self.assertEqual(f.service.get(f.account,f.group)['mode'],'handoff')
        self.assertEqual(self.get()[1]['cards'],[self.a.card]);self.assertEqual(f.posts,[])

    def test_execution_history_keeps_frozen_approved_card_after_policy_edit(self):
        f = self.f
        self.assertEqual(self.save()[0],200)
        approved_version = self.get()[1]['version']
        f.now += 1;self.a.snapshot([self.a.row(71)]);f.service.tick()
        self.assertEqual(len(f.posts),1)
        changed = approved_card(replyText='后来批准的另一份正文',sourceVersion='2026-10-05')
        self.assertEqual(self.save(enabled=False,cards=[changed])[0],200)
        code,page = self.http.get('/api/execution-history',source='reply')
        self.assertEqual(code,200)
        record = page['records'][0]
        self.assertEqual(record['approvedPolicy'],{'version':approved_version,'card':self.a.card})
        self.assertEqual(record['text'],self.a.card['replyText'])
        self.assertEqual(self.http.get('/api/execution-history',source='manual')[1]['records'],[])
        all_records = self.http.get('/api/execution-history',source='all')[1]['records']
        self.assertEqual([(row['id'],row['source']) for row in all_records],[(record['id'],'reply')])


if __name__=='__main__':unittest.main()
