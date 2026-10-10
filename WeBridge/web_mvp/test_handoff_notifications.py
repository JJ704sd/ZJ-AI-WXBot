"""Notification acceptance with temporary SQLite and a recording native boundary."""
from contextlib import closing
import sqlite3
import threading
import unittest
from unittest.mock import patch

from handoff_notifications import HandoffNotifications
from human_handoffs import HandoffConflict
from test_database_adapter import PEER, SELF, create_shard
import test_human_handoffs as fixtures
from windows_hook_sender import HookSendError, validate_text


class HandoffNotificationTests(unittest.TestCase):
    def setUp(self):
        self.h = fixtures.HandoffTests()
        self.h.setUp()
        self.addCleanup(self.h.doCleanups)
        self.f,self.queue = self.h.f,self.h.queue
        self.n = self.f.service.notifications
        root = self.f.write_snapshot('notifications',{'message/message_0.db':[]})
        create_shard(root,'message/message_1.db',group=PEER,rows=[])
        self.f.activate_snapshot(root)
        self.f.engine.set_watched(self.f.account,[self.f.group,PEER])
        self.f.service.configure(self.f.account,self.f.group,True,'',30,mode='handoff')
        self.queue.set_routing(self.f.account,self.f.group,0,'销售组 · 张')

    def enable(self, **changes):
        values = dict(account=self.f.account,groupId=self.f.group,version=0,routeVersion=1,targetId=PEER,enabled=True)
        return self.n.configure(**(values|changes))

    def notification(self, id='event-1'):
        return self.queue.detail(self.f.account,id)['record']['notification']

    def test_explicit_recipient_and_policy_cas_are_separate_from_owner_label(self):
        data = self.n.configuration(self.f.account)
        self.assertEqual(data['recipients'],[{'id':PEER,'name':next(row['name'] for row in self.f.engine.group_list if row['id']==PEER)}])
        self.assertFalse(data['configs'][0]['enabled'])
        for target in (self.f.group,'filehelper',SELF,'missing-contact'):
            with self.subTest(target=target),self.assertRaises(ValueError): self.enable(targetId=target)
        saved = self.enable()
        self.assertEqual((saved['enabled'],saved['targetId'],saved['owner'],saved['version']),(True,PEER,'销售组 · 张',1))
        with self.assertRaises(HandoffConflict): self.enable()
        with self.assertRaises(HandoffConflict): self.enable(version=1,routeVersion=0)
        with self.assertRaises(ValueError): self.enable(version=1,account='other')
        self.assertEqual(self.f.posts,[])

    def test_created_task_audit_and_outbox_commit_together_and_replay_does_not_duplicate(self):
        self.enable()
        enqueue = self.n.enqueue
        def failing(db,task):
            enqueue(db,task)
            raise sqlite3.IntegrityError('synthetic rollback after outbox insert')
        with patch.object(self.n,'enqueue',side_effect=failing),self.assertRaises(sqlite3.IntegrityError): self.h.enqueue()
        with closing(self.f.service._db()) as db:
            for table in ('handoffs','handoff_changes','handoff_notifications'):
                self.assertEqual(db.execute('SELECT count(*) FROM '+table).fetchone()[0],0)
        self.h.enqueue();self.h.enqueue()
        self.assertEqual(self.notification()['status'],'queued')
        with closing(self.f.service._db()) as db:
            self.assertEqual(db.execute('SELECT count(*) FROM handoff_notifications').fetchone()[0],1)
        self.n.tick();self.n.tick()
        record = self.queue.detail(self.f.account,'event-1')['record']
        self.assertEqual((record['status'],record['version']),('pending',1))
        self.assertEqual(record['notification']['status'],'submitted_unconfirmed')
        self.assertFalse(record['notification']['delivered']);self.assertFalse(record['notification']['retryAllowed'])
        self.assertEqual(len(self.f.posts),1)
        self.assertEqual(self.f.posts[0]['targetId'],PEER)
        self.assertIn('销售组 · 张',self.f.posts[0]['text'])
        self.assertIn('请人工确认',self.f.posts[0]['text'])

    def test_content_is_frozen_and_long_original_has_an_explicit_excerpt(self):
        self.enable()
        self.h.trigger['text']='🙂'*2000
        self.h.enqueue()
        self.h.trigger['text']='later changed caller draft'
        self.n.tick()
        text = self.f.posts[0]['text']
        validate_text(text)
        self.assertIn('摘要已截断',text)
        self.assertIn('🙂',text)
        self.assertNotIn('later changed',text)
        self.assertEqual(self.queue.detail(self.f.account,'event-1')['record']['trigger']['text'],'🙂'*2000)

    def test_owner_change_cancels_old_queue_without_reassigning_old_task_or_rule(self):
        self.enable();self.h.enqueue()
        before = self.f.service.get(self.f.account,self.f.group)
        self.queue.set_routing(self.f.account,self.f.group,1,'新负责人')
        self.assertEqual(self.notification()['status'],'cancelled')
        record = self.queue.detail(self.f.account,'event-1')['record']
        self.assertEqual(record['owner'],'销售组 · 张')
        policy = self.n.configuration(self.f.account)['configs'][0]
        self.assertFalse(policy['enabled']);self.assertEqual(policy['version'],2)
        self.assertEqual(self.f.service.get(self.f.account,self.f.group),before)
        self.n.tick();self.assertEqual(self.f.posts,[])

    def test_claim_and_revoke_cancel_queued_notifications_in_the_same_transaction(self):
        self.enable();self.h.enqueue('claimed');self.h.enqueue('revoked')
        claimed = self.queue.action(self.f.account,'claimed',1,'claim',owner='处理人')
        self.assertEqual(claimed['notification']['status'],'cancelled')
        with closing(self.f.service._db()) as db,db:
            self.queue.revoke(db,self.f.account,self.f.group,[self.h.trigger['serverId']],self.f.now)
        self.assertEqual(self.notification('revoked')['status'],'cancelled')
        self.n.tick();self.assertEqual(self.f.posts,[])

    def test_expiry_does_not_submit_or_disable_handoff_intake(self):
        self.enable();self.h.enqueue()
        self.f.now+=601
        self.n.tick()
        self.assertEqual(self.notification()['status'],'expired')
        self.assertTrue(self.f.service.get(self.f.account,self.f.group)['enabled'])
        self.assertTrue(self.n.configuration(self.f.account)['configs'][0]['enabled'])
        self.assertEqual(self.f.posts,[])

    def test_restart_cancels_queue_disables_policy_and_never_backfills_old_tasks(self):
        self.enable();self.h.enqueue()
        self.n=HandoffNotifications(self.f.service);self.f.service.notifications=self.n
        self.assertEqual(self.notification()['status'],'cancelled')
        policy=self.n.configuration(self.f.account)['configs'][0]
        self.assertFalse(policy['enabled'])
        self.enable(version=policy['version'])
        self.n.tick();self.assertEqual(self.f.posts,[])
        self.h.enqueue('new');self.n.tick();self.assertEqual(len(self.f.posts),1)

    def test_unknown_never_retries_and_known_failure_pauses_only_notifications(self):
        self.enable();self.h.enqueue();self.f.outcome='timeout'
        self.n.tick()
        self.assertEqual(self.notification()['status'],'unknown')
        self.assertTrue(self.f.service.get(self.f.account,self.f.group)['enabled'])
        self.assertFalse(self.n.configuration(self.f.account)['configs'][0]['enabled'])
        self.n.tick();self.assertEqual(len(self.f.posts),1)
        binding={'account':self.f.account,'sourceId':self.f.account,'selfId':self.f.source.config['selfId'],
                 'sourceRoot':self.f.source.config['sourceRoot']}
        self.assertTrue(self.f.sender.safety(binding)['paused'])
        self.f.now+=86401
        manual=self.f.sender.prepare({**binding,'targetId':PEER,'targetName':'合成私聊',
            'text':'通知异常后的人工正文','idempotencyKey':'synthetic-notification-blocks-manual'})
        self.assertEqual(self.f.sender.confirm({**binding,**manual,'targetConfirmed':True})['issueCode'],'account_paused')
        self.assertEqual(len(self.f.posts),1)
        self.h.enqueue('after-fault')
        self.assertEqual(self.notification('after-fault')['status'],'not_configured')

    def test_hook_get_and_slow_post_release_source_locks_and_allow_new_intake(self):
        self.enable();self.h.enqueue()
        original=self.f.sender.transport
        checked=[]
        def transport(method,path,payload=None):
            errors=[]
            def concurrently():
                try:
                    with self.f.source.lock,self.f.engine.sync_lock,self.f.engine.lock:
                        checked.append(method)
                    if method=='POST':
                        self.f.now+=1
                        root=self.f.write_snapshot('during-notification-post',{'message/message_0.db':[
                            {'local':1,'server':9101,'time':self.f.now,'sender':2,'text':'通知进行中出现的新 @','atuserlist':SELF}]})
                        create_shard(root,'message/message_1.db',group=PEER,rows=[])
                        self.f.activate_snapshot(root)
                        self.f.service.tick()
                except Exception as error:errors.append(error)
            worker=threading.Thread(target=concurrently)
            worker.start();worker.join(3)
            self.assertFalse(worker.is_alive(),'native I/O must not hold intake locks')
            if errors:raise errors[0]
            return original(method,path,payload)
        self.f.sender.transport=transport
        self.n.tick()
        self.assertIn('GET',checked);self.assertIn('POST',checked)
        rows=self.queue.list(self.f.account)['records']
        self.assertEqual(len(rows),2)
        received=next(row for row in rows if row['id']!='event-1')
        self.assertEqual((received['status'],received['notification']['status']),('pending','queued'))
        self.assertEqual(received['trigger']['serverId'],'9101')
        self.assertEqual(self.notification()['status'],'submitted_unconfirmed')

    def test_final_guard_observes_task_change_and_latest_revocations(self):
        self.enable();self.h.enqueue()
        original=self.f.sender.transport
        def transport(method,path,payload=None):
            if method=='GET':self.queue.action(self.f.account,'event-1',1,'claim',owner='另一个处理人')
            self.f.sender.transport=original
            return original(method,path,payload)
        self.f.sender.transport=transport
        self.n.tick()
        self.assertEqual(self.notification()['status'],'cancelled');self.assertEqual(self.f.posts,[])
        self.h.enqueue('late-revoke')
        calls=[]
        def revocations(account,group):
            calls.append(group)
            with closing(self.f.service._db()) as db,db:
                self.queue.revoke(db,account,group,[self.h.trigger['serverId']],self.f.now)
        with patch.object(self.f.service,'_handoff_revocations',side_effect=revocations):self.n.tick()
        self.assertEqual(calls,[self.f.group]);self.assertEqual(self.f.posts,[])
        self.assertEqual(self.notification('late-revoke')['status'],'cancelled')

    def test_unwatch_recipient_cancels_queue_and_disable_does_not_need_hook(self):
        self.enable();self.h.enqueue()
        self.f.engine.set_watched(self.f.account,[self.f.group])
        self.n.pause_all('取消读取',unwatched_account=self.f.account)
        self.assertEqual(self.notification()['status'],'cancelled')
        policy=self.n.configuration(self.f.account)['configs'][0]
        self.assertEqual(policy['targetId'],PEER);self.assertFalse(policy['enabled'])
        self.f.ready=False
        saved=self.enable(version=policy['version'],enabled=False)
        self.assertFalse(saved['enabled']);self.assertEqual(saved['targetId'],PEER)
        self.n.tick();self.assertEqual(self.f.posts,[])

    def test_shared_admission_defers_without_consuming_queue(self):
        self.enable();self.h.enqueue()
        with self.f.engine.send_lock:self.n.tick()
        self.assertEqual(self.notification()['status'],'queued');self.assertEqual(self.f.posts,[])
        self.n.tick();self.assertEqual(len(self.f.posts),1)

    def test_journal_recovers_finished_evidence_without_resending_after_lost_outbox_write(self):
        self.enable();self.h.enqueue();self.n.tick()
        with closing(self.f.service._db()) as db,db:
            db.execute("UPDATE handoff_notifications SET status='attempted',result='{}'")
        self.n=HandoffNotifications(self.f.service);self.f.service.notifications=self.n
        with patch.object(self.f.sender,'transport',side_effect=AssertionError('journal read must not use native I/O')):
            note=self.notification()
            self.assertEqual(note['status'],'submitted_unconfirmed')
            self.assertTrue(note['draftId']);self.assertFalse(note['delivered'])
            self.n.tick()
        self.assertEqual(len(self.f.posts),1)

    def test_legacy_owner_characters_do_not_make_notification_break_task_creation(self):
        owner='销售\x01\x7f张'
        self.queue.set_routing(self.f.account,self.f.group,1,owner)
        self.enable(routeVersion=2);self.h.enqueue();self.n.tick()
        self.assertEqual(self.queue.detail(self.f.account,'event-1')['record']['owner'],owner)
        self.assertEqual(self.notification()['status'],'submitted_unconfirmed')
        self.assertNotIn('\x01',self.f.posts[0]['text']);self.assertNotIn('\x7f',self.f.posts[0]['text'])

    def test_missing_journal_keeps_task_visible_and_actionable_without_resending(self):
        self.enable();self.h.enqueue();self.n.tick()
        for failure in (HookSendError('draft_missing'),OSError('unreadable'),sqlite3.OperationalError('locked')):
            with self.subTest(failure=type(failure).__name__),patch.object(self.f.sender,'get',side_effect=failure):
                row=self.queue.list(self.f.account)['records'][0]
                self.assertEqual(row['notification']['status'],'submitted_unconfirmed')
                self.assertIn('暂无法核对',row['notification']['issue'])
                self.assertEqual(self.notification()['status'],'submitted_unconfirmed')
        with patch.object(self.f.sender,'get',side_effect=HookSendError('draft_missing')):
            row=self.queue.action(self.f.account,'event-1',1,'claim',owner='处理人')
            self.assertEqual(row['status'],'in_progress')
        self.n.tick();self.assertEqual(len(self.f.posts),1)

    def test_refresh_busy_initially_and_at_final_guard_defers_without_consuming_authority(self):
        self.enable();self.h.enqueue()
        self.f.source.busy=True;self.n.tick();self.f.source.busy=False
        self.assertEqual(self.notification()['status'],'queued')
        original=self.f.sender.transport
        count=0
        def transport(method,path,payload=None):
            nonlocal count
            if method=='GET':
                count+=1
                if count==3:self.f.source.busy=True
            return original(method,path,payload)
        self.f.sender.transport=transport
        self.n.tick()
        self.f.source.busy=False;self.f.sender.transport=original
        self.assertEqual(self.notification()['status'],'queued');self.assertEqual(self.f.posts,[])
        self.assertTrue(self.n.configuration(self.f.account)['configs'][0]['enabled'])
        self.n.tick()
        self.assertEqual(self.notification()['status'],'submitted_unconfirmed');self.assertEqual(len(self.f.posts),1)

    def test_stop_at_final_probe_never_posts(self):
        self.enable();self.h.enqueue()
        original=self.f.sender.transport
        def transport(method,path,payload=None):
            if method=='GET':self.f.engine.stop.set()
            return original(method,path,payload)
        self.f.sender.transport=transport
        self.n.tick()
        self.assertEqual(self.f.posts,[])
        self.assertEqual(self.notification()['status'],'cancelled')

    def test_worker_programming_error_pauses_propagates_and_cannot_be_reenabled(self):
        self.enable();self.h.enqueue()
        with patch.object(self.n,'tick',side_effect=RuntimeError('synthetic programming fault')):
            with self.assertRaisesRegex(RuntimeError,'synthetic programming fault'):self.n.run()
        self.assertTrue(self.n.failure)
        self.assertEqual(self.notification()['status'],'cancelled')
        config=self.n.configuration(self.f.account)['configs'][0]
        self.assertFalse(config['enabled'])
        with self.assertRaisesRegex(ValueError,'重启'):self.enable(version=config['version'])
        self.assertFalse(self.enable(version=config['version'],enabled=False)['enabled'])
        self.h.enqueue('intake-after-worker-error')
        self.assertEqual(self.queue.detail(self.f.account,'intake-after-worker-error')['record']['status'],'pending')
        self.assertTrue(self.f.service.get(self.f.account,self.f.group)['enabled'])
        self.assertEqual(self.f.posts,[])


if __name__=='__main__':unittest.main()
