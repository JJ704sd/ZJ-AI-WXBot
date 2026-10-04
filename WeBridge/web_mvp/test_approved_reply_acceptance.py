"""Approved replies over invented snapshots and a recording native boundary."""
from contextlib import closing
from copy import deepcopy
import json
import sqlite3
import tempfile
import threading
import unittest

from execution_history import history
from test_database_adapter import MIXED, PEER, SELF, create_shard
from test_windows_inbound import InboundFixture
from windows_hook_sender import _send_guard


def approved_card(**changes):
    return {'id':'approved-card-synthetic-001','name':'售后资料',
            'questions':['@合成本人\u2005请提供售后流程','请提供\n售后流程'],
            'sourceTitle':'合成售后手册','sourceVersion':'2026-10-04',
            'sourceText':'售后申请需提供订单号，由业务员核实。',
            'replyText':'售后申请请提供订单号，后续由业务员核实。',**changes}


class ApprovedFixture:
    """Composition avoids importing another TestCase into discovery."""
    def __init__(self, inbound=None):
        self.directory = None if inbound is not None else tempfile.TemporaryDirectory(prefix='webridge-approved-acceptance-')
        self.f = inbound if inbound is not None else InboundFixture(self.directory.name)
        self.f.engine.windows_auto_reply = self.f.service
        self.card = approved_card()
        self.generation = 0
        self.snapshot([])
        self.f.engine.set_watched(self.f.account,[self.f.group,PEER])

    def close(self):
        if self.directory is not None:self.directory.cleanup()

    def snapshot(self, rows, *, duplicate=False):
        self.generation += 1
        shards = {'message/message_0.db':list(rows)}
        if duplicate:shards['biz_message/biz_message_0.db'] = [dict(row,local=index+101) for index,row in enumerate(rows)]
        root = self.f.write_snapshot('approved-'+str(self.generation),shards)
        create_shard(root,'message/message_1.db',group=PEER,rows=[])
        self.f.activate_snapshot(root)

    def payload(self, **changes):
        policy = self.f.service.approved.get(self.f.account,self.f.group)
        return {'account':self.f.account,'groupId':self.f.group,'version':policy['version'],
                'enabled':True,'cooldown':30,'cards':[deepcopy(self.card)],**changes}

    def enable(self, **changes):
        return self.f.service.approved.configure(self.payload(**changes))

    def row(self, server, text=None, **changes):
        return {'local':server,'server':server,'time':self.f.now,'sender':2,
                'text':self.card['questions'][0] if text is None else text,'atuserlist':SELF,**changes}

    def tasks(self):
        return self.f.service.handoffs.list(self.f.account)['records']

    def counts(self):
        with closing(self.f.service._db()) as db:
            return tuple(db.execute('SELECT count(*) FROM '+table).fetchone()[0]
                         for table in ('events','handoffs','handoff_changes','handoff_notifications'))

    def notifications(self):
        route = self.f.service.handoffs.set_routing(self.f.account,self.f.group,0,'合成业务负责人')
        return self.f.service.notifications.configure(self.f.account,self.f.group,0,route['version'],PEER,True)


class ApprovedReplyAcceptanceTests(unittest.TestCase):
    def fixture(self):
        fixture = ApprovedFixture()
        self.addCleanup(fixture.close)
        return fixture

    def test_full_message_matching_routes_other_requests_to_distinct_handoffs(self):
        a = self.fixture();f = a.f;a.enable();f.now += 1
        rows = [a.row(1,'  请提供\r\n售后流程  '),
                a.row(2,a.card['questions'][0]+'，再确认这笔订单。'),
                a.row(3,'请不要提供售后流程，请确认订单。'),
                a.row(4,'<msg><img aeskey="synthetic" /></msg>',type=3),
                a.row(5),a.row(6,atuserlist=''),a.row(7,sender=1)]
        a.snapshot(rows,duplicate=True)
        f.service.tick();f.service.tick()
        self.assertEqual(len(f.posts),1)
        self.assertEqual((f.posts[0]['targetId'],f.posts[0]['text']),(f.group,a.card['replyText']))
        tasks = a.tasks()
        self.assertEqual({row['trigger']['serverId'] for row in tasks},{'2','3','4','5'})
        self.assertTrue(all(row['status']=='pending' and row['reason'] for row in tasks))
        reasons = {row['trigger']['serverId']:row['reason'] for row in tasks}
        self.assertNotEqual(reasons['2'],reasons['4'])
        self.assertNotEqual(reasons['2'],reasons['5'])
        f.now += 31;f.service.tick()
        self.assertEqual(len(f.posts),1,'Cooldown handoffs are not delayed-send work items')

    def test_mixed_group_uses_formal_identity_for_policy_handoff_owner_and_notification(self):
        a = self.fixture();f = a.f;f.group = MIXED
        a.snapshot([]);f.engine.set_watched(f.account,[MIXED,PEER])
        a.enable();a.notifications();f.now += 1
        a.snapshot([a.row(8),a.row(9,'混合群里另一条需要业务员核对的请求')])
        f.service.tick()
        self.assertEqual(len(f.posts),1)
        self.assertEqual(f.posts[0]['targetId'],MIXED)
        tasks = a.tasks();self.assertEqual(len(tasks),1)
        self.assertEqual((tasks[0]['groupId'],tasks[0]['owner'],tasks[0]['notification']['status']),
                         (MIXED,'合成业务负责人','queued'))
        config = f.service.notifications.configuration(f.account)
        self.assertEqual(config['configs'][0]['groupId'],MIXED)
        self.assertEqual(config['configs'][0]['targetId'],PEER)

    def test_unknown_submission_creates_review_task_and_never_replays_after_restart(self):
        a = self.fixture();f = a.f;approved = a.enable();f.outcome = 'timeout';f.now += 1
        original = a.row(11);a.snapshot([original]);f.service.tick();f.service.tick()
        self.assertEqual(len(f.posts),1)
        self.assertEqual(a.counts()[:2],(1,1))
        task = a.tasks()[0]
        self.assertIn('未知',task['reason'])
        current = f.service.approved.get(f.account,f.group)
        self.assertTrue(current['enabled']);self.assertTrue(current['sendingPaused'])
        self.assertGreater(current['version'],approved['version'])
        with closing(f.service._db()) as db:
            self.assertEqual(db.execute('SELECT status FROM events').fetchone()[0],'unknown')
        f.service = f.new_service();f.engine.windows_auto_reply = f.service
        restarted = f.service.approved.get(f.account,f.group)
        self.assertFalse(restarted['enabled']);self.assertGreater(restarted['version'],current['version'])
        f.outcome = 'submitted';f.now += 31;a.enable()
        a.snapshot([original],duplicate=True);f.service.tick()
        self.assertEqual(len(f.posts),1)
        self.assertEqual(a.counts()[:2],(1,1))

    def test_hook_offline_and_sending_pause_keep_receiving_unmatched_and_matched_requests(self):
        a = self.fixture();f = a.f;approved = a.enable();f.ready = False;f.now += 1
        a.snapshot([a.row(21,'未批准的新问题'),a.row(22)])
        f.service.tick()
        self.assertEqual(f.posts,[])
        self.assertEqual({row['trigger']['serverId'] for row in a.tasks()},{'21','22'})
        policy = f.service.approved.get(f.account,f.group)
        self.assertTrue(policy['enabled']);self.assertTrue(policy['sendingPaused'])
        self.assertGreater(policy['version'],approved['version'])
        f.ready = True;f.now += 1
        a.snapshot([a.row(23)]);f.service.tick()
        self.assertEqual(f.posts,[],'Restoring Hook availability does not silently reapprove sending')
        self.assertEqual(len(a.tasks()),3)

    def test_handoff_and_notification_insert_failures_roll_back_event_task_and_outbox(self):
        for table in ('handoffs','handoff_notifications'):
            with self.subTest(table=table):
                a = self.fixture();f = a.f;a.enable();a.notifications();f.now += 1
                a.snapshot([a.row(31,'请人工核实这个订单')])
                with closing(f.service._db()) as db,db:
                    db.execute('CREATE TRIGGER approved_failure BEFORE INSERT ON '+table+
                               " BEGIN SELECT RAISE(ABORT,'synthetic approved intake failure'); END")
                with self.assertRaises(sqlite3.IntegrityError):f.service.tick()
                self.assertEqual(a.counts(),(0,0,0,0))
                with closing(f.service._db()) as db,db:db.execute('DROP TRIGGER approved_failure')
                f.service.tick();f.service.tick()
                self.assertEqual(a.counts(),(1,1,1,1))
                self.assertEqual(a.tasks()[0]['notification']['status'],'queued')
                self.assertEqual(f.posts,[])

    def test_final_probe_policy_change_or_revoke_prevents_native_post(self):
        for mutation in ('policy','revoke'):
            with self.subTest(mutation=mutation):
                a = self.fixture();f = a.f;a.enable();f.now += 1
                message = a.row(41);a.snapshot([message])
                original,changed = f.sender.transport,[]
                def transport(method,path,payload=None):
                    result = original(method,path,payload)
                    if method=='GET' and not changed:
                        with closing(f.sender._connect()) as db:
                            prepared = db.execute("SELECT count(*) FROM hook_drafts WHERE status='prepared'").fetchone()[0]
                        if prepared:
                            changed.append(mutation)
                            if mutation=='policy':a.enable(enabled=False)
                            else:a.snapshot([message,a.row(42,
                                '<sysmsg><revokemsg><newmsgid>41</newmsgid></revokemsg></sysmsg>',type=10002)])
                    return result
                f.sender.transport = transport
                f.service.tick();f.service.tick()
                self.assertEqual(changed,[mutation]);self.assertEqual(f.posts,[])
                with closing(f.service._db()) as db:
                    self.assertEqual(db.execute("SELECT count(*) FROM events WHERE status IN ('attempted','unknown','submitted_unconfirmed')").fetchone()[0],0)

    def test_final_probe_busy_defers_without_consuming_and_later_submits_once(self):
        a = self.fixture();f = a.f;a.enable();f.now += 1;a.snapshot([a.row(51)])
        original,changed = f.sender.transport,[]
        def transport(method,path,payload=None):
            result = original(method,path,payload)
            if method=='GET' and not changed:
                with closing(f.sender._connect()) as db:
                    prepared = db.execute("SELECT count(*) FROM hook_drafts WHERE status='prepared'").fetchone()[0]
                if prepared:changed.append(True);f.source.busy = True
            return result
        f.sender.transport = transport
        f.service.tick()
        self.assertEqual(changed,[True]);self.assertEqual(f.posts,[])
        self.assertEqual(a.counts(),(0,0,0,0))
        f.source.busy = False;f.service.tick();f.service.tick()
        self.assertEqual(len(f.posts),1)

    def test_native_file_lock_defers_without_consuming_or_pausing_approval(self):
        a = self.fixture();f = a.f;approved = a.enable();f.now += 1;a.snapshot([a.row(55)])
        with _send_guard(f.sender.directory):
            f.service.tick()
        self.assertEqual(f.posts,[]);self.assertEqual(a.counts(),(0,0,0,0))
        policy = f.service.approved.get(f.account,f.group)
        self.assertTrue(policy['enabled']);self.assertFalse(policy['sendingPaused'])
        self.assertEqual(policy['version'],approved['version'])
        f.service.tick();f.service.tick()
        self.assertEqual(len(f.posts),1);self.assertEqual(a.counts()[:2],(1,0))

    def test_revoked_handoff_and_unknown_review_hide_original_text_from_history_and_search(self):
        for outcome in ('unmatched','unknown'):
            with self.subTest(outcome=outcome):
                a = self.fixture();f = a.f;a.enable();f.now += 1
                query = '需要人工核对的合成客户原文XYZ' if outcome=='unmatched' else '请提供\r\n售后流程'
                text = query if outcome=='unmatched' else '  '+query+'  '
                if outcome=='unknown':f.outcome = 'timeout'
                message = a.row(56,text);a.snapshot([message]);f.service.tick()
                task = a.tasks()[0]
                before = history(f.engine,f.sender,source='reply')['records'][0]
                self.assertEqual(before['trigger']['text'],text)
                self.assertEqual(len(history(f.engine,f.sender,source='reply',query=query)['records']),1)
                f.now += 1
                a.snapshot([message,a.row(57,
                    '<sysmsg><revokemsg><newmsgid>56</newmsgid></revokemsg></sysmsg>',type=10002)])
                f.service.tick()
                record = f.service.handoffs.detail(f.account,task['id'])['record']
                self.assertTrue(record['revoked']);self.assertEqual(record['trigger']['text'],'')
                after = history(f.engine,f.sender,source='reply')['records'][0]
                self.assertEqual(after['trigger']['text'],'');self.assertFalse(after['trigger']['textTruncated'])
                self.assertEqual(after['status'],before['status'])
                self.assertEqual(after['approvedPolicy'],before['approvedPolicy'])
                self.assertEqual(history(f.engine,f.sender,source='reply',query=query)['records'],[])
                f.service = f.new_service();f.engine.windows_auto_reply = f.service
                self.assertEqual(history(f.engine,f.sender,source='reply')['records'][0]['trigger']['text'],'')
                self.assertEqual(len(f.posts),int(outcome=='unknown'))

    def test_slow_post_releases_intake_locks_and_busy_sender_leaves_matched_event_unconsumed(self):
        a = self.fixture();f = a.f;a.enable();a.notifications();f.now += 1
        first = a.row(61);a.snapshot([first])
        entered,release = threading.Event(),threading.Event()
        errors,workers,checked = [],[],[]
        original = f.sender.transport
        def transport(method,path,payload=None):
            if method=='GET':
                def check():
                    with f.source.lock,f.engine.sync_lock,f.engine.lock:checked.append(True)
                worker = threading.Thread(target=check,daemon=True);worker.start();worker.join(2)
                if worker.is_alive():raise AssertionError('Hook GET holds intake locks')
            if method=='POST':
                entered.set()
                if not release.wait(6):raise TimeoutError('Synthetic POST was not released')
            return original(method,path,payload)
        def run(call):
            try:call()
            except BaseException as error:errors.append(error)
        def receive():
            f.now += 1
            a.snapshot([first,a.row(62,'发送期间的新人工请求'),a.row(63)])
            f.service.tick()
        f.sender.transport = transport
        try:
            sender = threading.Thread(target=lambda:run(f.service.tick),daemon=True);workers.append(sender);sender.start()
            self.assertTrue(entered.wait(3),'Approved reply never reached the synthetic POST')
            reader = threading.Thread(target=lambda:run(receive),daemon=True);workers.append(reader);reader.start();reader.join(3)
            self.assertFalse(reader.is_alive(),'Real snapshot refresh and intake must complete while POST waits')
            self.assertEqual(errors,[])
            self.assertEqual({row['trigger']['serverId'] for row in a.tasks()},{'62'})
            self.assertEqual(a.tasks()[0]['notification']['status'],'queued')
            self.assertEqual(a.counts()[0],2,'The second matched message must not be consumed while sender admission is busy')
        finally:
            release.set()
            for worker in workers:worker.join(3)
        self.assertTrue(all(not worker.is_alive() for worker in workers));self.assertEqual(errors,[])
        self.assertTrue(checked);self.assertEqual(len(f.posts),1)


if __name__=='__main__':unittest.main()
