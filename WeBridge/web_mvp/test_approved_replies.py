"""Approved whole-message replies using temporary SQLite and a recording Hook."""
from copy import deepcopy
from contextlib import closing
import json
import threading
import unittest
from unittest.mock import patch

import test_windows_auto_reply as fixtures
from approved_replies import ApprovedPolicyConflict


class ApprovedReplyTests(unittest.TestCase):
    def setUp(self):
        self.f = fixtures.AutoReplyTests()
        self.addCleanup(self.f.doCleanups)
        self.f.setUp()
        self.card = {'id':'synthetic-approved-card', 'name':'批准的交付说明',
            'questions':['请说明交付流程'], 'sourceTitle':'批准资料', 'sourceVersion':'2026-10-04',
            'sourceText':'收到订单后由业务人员核对。', 'replyText':'收到订单后由业务人员核对。'}

    def data(self, **changes):
        return {'account':self.f.account, 'groupId':self.f.group, 'version':0,
            'enabled':False, 'cooldown':30, 'cards':[deepcopy(self.card)], **changes}

    def test_draft_and_preview_are_offline_and_preserve_legacy_rule(self):
        before = self.f.service.get(self.f.account,self.f.group)
        self.f.source.busy, self.f.ready = True, False
        with patch.object(self.f.service,'sender_factory',side_effect=AssertionError('Draft/preview must not use Hook')):
            result = self.f.service.approved.configure(self.data(cooldown=90))
            matched = self.f.service.approved.preview(self.data(version=1,text='  请说明交付流程  '))
            unknown = self.f.service.approved.preview(self.data(version=1,text='请说明交付流程，以及其他问题'))
        self.assertEqual((result['version'],result['enabled'],result['mode'],result['cooldown']), (1,False,'reply',90))
        self.assertEqual(self.f.service.get(self.f.account,self.f.group), before)
        self.assertEqual((matched['decision'],matched['reasonCode'],matched['replyText']), ('reply','matched',self.card['replyText']))
        self.assertEqual(matched['matchedCard'], self.card)
        self.assertEqual((unknown['decision'],unknown['reasonCode'],unknown['matchedCard']), ('handoff','unmatched',None))
        self.assertEqual(self.f.posts, [])

    def test_matched_reply_and_unmatched_or_cooldown_handoff_are_durable(self):
        self.f.service.approved.configure(self.data(enabled=True))
        self.f.now += 1
        self.f.rows = [self.f.message(1,text=self.card['questions'][0]),
            self.f.message(2,text='未批准的新问题'), self.f.message(3,text=self.card['questions'][0])]
        self.f.service.tick()
        self.f.service.tick()
        self.assertEqual([row['text'] for row in self.f.posts], [self.card['replyText']])
        attempts = self.f.service.get(self.f.account,self.f.group)['attempts']
        by_message = {row['trigger']['messageId']:row for row in attempts}
        self.assertEqual(by_message['1']['status'], 'submitted_unconfirmed')
        self.assertEqual(by_message['1']['approvedPolicy'], {'version':1,'card':self.card})
        self.assertEqual(by_message['2']['reasonCode'], 'unmatched')
        self.assertEqual(by_message['3']['reasonCode'], 'cooldown')
        with closing(self.f.service._db()) as db:
            tasks = db.execute('SELECT reason,status FROM handoffs').fetchall()
        self.assertEqual(len(tasks), 2)
        self.assertTrue(all(row['status']=='pending' for row in tasks))
        self.assertEqual(self.f.service.approved.get(self.f.account,self.f.group)['version'],1)

    def test_legacy_rule_edits_preserve_cards_and_invalidate_policy_revision(self):
        f = self.f
        f.rows = [f.message()]
        f.enable()
        before = f.service._rule(f.account,f.group)
        with closing(f.service._db()) as db:
            baseline = [tuple(row) for row in db.execute('SELECT * FROM baselines')]
        draft = f.service.approved.configure(self.data(version=1,cooldown=90))
        after = f.service._rule(f.account,f.group)
        self.assertEqual({key:after[key] for key in before if key!='policyVersion'},
                         {key:before[key] for key in before if key!='policyVersion'})
        with closing(f.service._db()) as db:
            self.assertEqual([tuple(row) for row in db.execute('SELECT * FROM baselines')],baseline)
        self.assertEqual((draft['version'],draft['cooldown'],draft['enabled']),(2,90,False))
        f.service.configure(f.account,f.group,False,'another fixed reply',60,mode='handoff')
        current = f.service.approved.get(f.account,f.group)
        self.assertEqual((current['version'],current['mode'],current['cards']),(3,'handoff',[self.card]))
        with self.assertRaises(ApprovedPolicyConflict):f.service.approved.configure(self.data(version=2))
        f.service.approved.configure(self.data(version=3,enabled=True))
        with self.assertRaises(ValueError):f.service.configure(f.account,f.group,True,'bypass',30)
        with self.assertRaises(ValueError):f.service.configure(f.account,f.group,True,'bypass',30,mode='approved')
        f.service.configure(f.account,f.group,False,'cannot overwrite card',5)
        current = f.service.approved.get(f.account,f.group)
        self.assertEqual((current['version'],current['enabled'],current['cards']),(5,False,[self.card]))

    def test_approval_probe_releases_locks_and_legacy_edit_wins_cas(self):
        f,errors,entered = self.f,[],[]
        original = f.sender.transport
        def edit():
            try:
                f.service.configure(f.account,f.group,False,'new fixed draft',30)
                entered.append(True)
            except BaseException as error:errors.append(error)
        def transport(method,path,payload=None):
            if method=='GET':
                worker = threading.Thread(target=edit,daemon=True)
                worker.start();worker.join(3)
                self.assertFalse(worker.is_alive(),'Approval probe must not hold intake locks')
            return original(method,path,payload)
        f.sender.transport = transport
        with self.assertRaises(ApprovedPolicyConflict):f.service.approved.configure(self.data(enabled=True))
        self.assertEqual(errors,[]);self.assertEqual(entered,[True])
        self.assertEqual(f.service._rule(f.account,f.group)['text'],'new fixed draft')
        self.assertFalse(f.service.approved.get(f.account,f.group)['enabled'])
        self.assertEqual(f.posts,[])

    def test_card_boundaries_and_invalid_unicode_are_rejected_before_hook_or_save(self):
        invalid = [self.data(version=True),self.data(enabled=1),self.data(cooldown=4),
            self.data(enabled=True,cards=[]),self.data(cards=[{**self.card,'questions':['same',' same ']}]),
            self.data(cards=[self.card,{**self.card,'id':'second-unique-card'}]),
            self.data(cards=[{**self.card,'name':''}]),
            self.data(cards=[{**self.card,'sourceText':'x'*2001}]),
            self.data(cards=[{**self.card,'questions':['x'*501]}]),
            self.data(cards=[{**self.card,'replyText':'🙂'*1001}]),
            self.data(cards=[{**self.card,'replyText':'invalid\x01'}]),
            self.data(cards=[{**self.card,'sourceVersion':'\ud800'}])]
        with patch.object(self.f.service,'sender_factory',side_effect=AssertionError('Invalid cards must not probe')):
            for data in invalid:
                with self.subTest(data=data),self.assertRaises(ValueError):self.f.service.approved.configure(data)
        self.assertEqual(self.f.service.approved.get(self.f.account,self.f.group)['version'],0)
        card = {**self.card,'questions':['  第一行\r\n第二行  ','Ａ'],
                'sourceText':'🙂'*2000,'replyText':'🙂'*1000}
        saved = self.f.service.approved.configure(self.data(cards=[card]))
        self.assertEqual(saved['cards'][0]['questions'],['第一行\n第二行','Ａ'])
        matched = self.f.service.approved.preview(self.data(version=1,cards=[card],text='第一行\n第二行'))
        mismatch = self.f.service.approved.preview(self.data(version=1,cards=[card],text='A'))
        self.assertEqual(matched['decision'],'reply');self.assertEqual(mismatch['decision'],'handoff')

    def test_crash_after_durable_claim_recovers_unknown_task_without_probe_or_replay(self):
        f = self.f
        f.service.approved.configure(self.data(enabled=True))
        f.now += 1
        message = f.message(text=self.card['questions'][0])
        event = f.service._event_id(f.account,f.group,message)
        detail = {'decision':'reply','reasonCode':'matched','replyText':self.card['replyText'],
                  'targetName':'冻结原群名','trigger':f.service._trigger(message),
                  'approvedPolicy':{'version':1,'card':self.card},'draftId':'a'*32}
        with closing(f.service._db()) as db,db:
            db.execute('INSERT INTO events VALUES (?,?,?,?,?,?)',
                       (event,f.account,f.group,f.now,'attempted',json.dumps(detail,ensure_ascii=False)))
            db.execute('INSERT INTO events VALUES (?,?,?,?,?,?)',
                       ('legacy',f.account,f.group,f.now,'unknown','{}'))
        f.engine.group_list = []
        with patch.object(f.sender,'automation_binding',side_effect=AssertionError('Restart must not probe')):
            recovered = f.service_new()
            self.assertEqual(recovered._rule(f.account,f.group)['policyVersion'],2)
            with closing(recovered._db()) as db,db:
                db.execute("UPDATE handoffs SET status='completed',version=2 WHERE id=?",(event,))
                db.execute('INSERT INTO handoff_changes VALUES (?,?,?,?,?,?,?)',
                           (event,2,'complete','completed','','checked',f.now))
                existing = json.loads(db.execute('SELECT result FROM events WHERE id=?',(event,)).fetchone()[0])
                existing['issue'] = '保留原 Hook 未知结果证据'
                db.execute('UPDATE events SET result=? WHERE id=?',(json.dumps(existing,ensure_ascii=False),event))
                db.execute('INSERT INTO handoff_notifications VALUES (?,?,?,?,?,?,?,?,?)',
                           (event,f.account,f.group,'unknown',f.now,f.now+600,'b'*32,'{}','{}'))
            restarted = f.service_new()
        with closing(restarted._db()) as db:
            task = db.execute('SELECT * FROM handoffs').fetchone()
            saved = db.execute('SELECT * FROM events WHERE id=?',(event,)).fetchone()
            self.assertEqual(db.execute('SELECT count(*) FROM handoffs').fetchone()[0],1)
            self.assertEqual(db.execute('SELECT count(*) FROM handoff_changes').fetchone()[0],2)
            self.assertEqual(db.execute('SELECT count(*) FROM handoff_notifications').fetchone()[0],1)
        self.assertEqual((task['group_name'],task['status'],task['version'],task['id']),('冻结原群名','completed',2,event))
        self.assertIn('勿盲目重发',task['reason'])
        self.assertEqual(saved['status'],'unknown')
        self.assertEqual(json.loads(saved['result'])['approvedPolicy'],detail['approvedPolicy'])
        self.assertEqual(json.loads(saved['result'])['reasonCode'],'submission_unknown')
        self.assertEqual(json.loads(saved['result'])['issue'],'保留原 Hook 未知结果证据')
        self.assertEqual(restarted._rule(f.account,f.group)['policyVersion'],3)
        self.assertEqual(f.posts,[])

    def test_restart_invalidates_closed_approved_and_legacy_card_drafts_without_changing_metadata(self):
        f = self.f
        for mode in ('reply','approved'):
            with self.subTest(mode=mode):
                version = f.service.approved.get(f.account,f.group)['version']
                if mode=='approved':
                    f.service.approved.configure(self.data(version=version,enabled=True))
                    version += 1
                f.service.approved.configure(self.data(version=version,enabled=False,cooldown=90))
                before = f.service._rule(f.account,f.group)
                before['issue'] = '保留已关闭草稿的说明'
                with closing(f.service._db()) as db,db:f.service._save(db,f.account,f.group,before)
                with patch.object(f.sender,'automation_binding',side_effect=AssertionError('Draft restart must not probe')):
                    f.service = f.service_new()
                after = f.service._rule(f.account,f.group)
                self.assertEqual(after,{**before,'policyVersion':before['policyVersion']+1})
                self.assertEqual((after['mode'],after['enabled']),(mode,False))
                with self.assertRaises(ApprovedPolicyConflict):
                    f.service.approved.configure(self.data(version=before['policyVersion']))
        self.assertEqual(f.posts,[])

    def test_restart_does_not_add_versions_to_unversioned_legacy_rules(self):
        f = self.f
        legacy = {'enabled':False,'mode':'reply','text':'旧固定文本','cooldown':30,'issue':'保留旧说明'}
        with closing(f.service._db()) as db,db:
            f.service._save(db,f.account,f.group,legacy)
            f.service._save(db,f.account,'enabled-legacy@chatroom',{**legacy,'enabled':True})
        restarted = f.service_new()
        self.assertEqual(restarted._rule(f.account,f.group),legacy)
        previously_enabled = restarted._rule(f.account,'enabled-legacy@chatroom')
        self.assertFalse(previously_enabled['enabled'])
        self.assertNotIn('policyVersion',previously_enabled)

    def test_source_failure_disables_intake_but_hook_stop_only_pauses_sending(self):
        f = self.f
        f.service.approved.configure(self.data(enabled=True))
        initial = f.service.get(f.account,f.group)
        self.assertEqual((initial['policyVersion'],initial['sendingPaused']),(1,False))
        f.service.pause_all(sending_only=True)
        policy = f.service.approved.get(f.account,f.group)
        self.assertEqual((policy['version'],policy['enabled'],policy['sendingPaused']),(2,True,True))
        legacy_view = f.service.get(f.account,f.group)
        self.assertEqual((legacy_view['policyVersion'],legacy_view['sendingPaused']),
                         (policy['version'],policy['sendingPaused']))
        f.now += 1;f.rows = [f.message(text=self.card['questions'][0])]
        f.service.tick()
        self.assertEqual(f.posts,[])
        self.assertEqual(f.service.get(f.account,f.group)['attempts'][0]['reasonCode'],'sending_unavailable')
        f.source.error = 'synthetic source error'
        f.service.tick()
        policy = f.service.approved.get(f.account,f.group)
        self.assertEqual((policy['enabled'],policy['version']),(False,3))

    def test_programming_failure_during_evidence_read_releases_send_admission(self):
        f = self.f
        f.service.approved.configure(self.data(enabled=True))
        f.now += 1;f.rows = [f.message(text=self.card['questions'][0])]
        with patch.object(f.service,'_messages',side_effect=RuntimeError('synthetic implementation failure')):
            with self.assertRaises(RuntimeError):f.service.tick()
        available = f.engine.send_lock.acquire(blocking=False)
        if available:f.engine.send_lock.release()
        self.assertTrue(available,'Unexpected failures must not strand the shared send admission')


if __name__ == '__main__': unittest.main()
