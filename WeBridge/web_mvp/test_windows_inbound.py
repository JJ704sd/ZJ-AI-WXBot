"""Inbound acceptance over invented immutable SQLite snapshots, never WeChat.

InboundFixture keeps the real adapter, engine, reply service and Hook journal.
Only the clock, snapshot-building service and native HTTP boundary are replaced.
Each snapshot generation has its own directory; account/source identity stays
constant while its revision changes, matching DatabaseService activation.
"""
from copy import deepcopy
from contextlib import closing
from pathlib import Path
import sqlite3
import tempfile
import threading
from types import SimpleNamespace
import unittest

from backend import Engine, Store
from database_adapter import DatabaseAdapter
from test_database_adapter import create_metadata, create_shard, GROUP, PEER, SELF, STAMP
from windows_auto_reply import WindowsAutoReply
from windows_hook_sender import PROTOCOL, WindowsHookSender


class InboundFixture:
    """Reusable real-SQLite fixture; callers own the temporary root's lifetime."""

    def __init__(self, root):
        self.root=Path(root)
        self.now=STAMP
        self.account='database:synthetic-inbound'
        self.group=GROUP
        self.reply_text='已收到，请查看已批准的资料。'
        self.posts=[]
        self.ready=True
        self.outcome='submitted'
        self.source=SimpleNamespace(lock=threading.RLock(),busy=False,error='',
            config={'sourceRoot':str(self.root/'source'),'selfId':SELF,'autoRefresh':True})
        profile={'clientVersion':'4.1.15.13','arch':'x64','moduleName':'Weixin.dll','moduleSha256':'a'*64}
        self.native={**profile,'pid':123,'processStarted':'134019987654321000',
                     'selfId':SELF,'sourceRoot':self.source.config['sourceRoot']}
        self.adapter=DatabaseAdapter()
        self.engine=Engine(Store(self.root/'runtime/state.sqlite'),self.adapter)
        self.sender=WindowsHookSender(self.root/'runtime/hook',transport=self.transport,
            profiles=[profile],clock=lambda:self.now)
        self.service=self.new_service()
        initial=self.write_snapshot('initial',{'message/message_0.db':[]})
        self.activate_snapshot(initial)
        self.engine.set_watched(self.account,[self.group])

    def acknowledge_account(self):
        source={'account':self.account,'sourceId':self.account,'selfId':self.source.config['selfId'],
                'sourceRoot':self.source.config['sourceRoot']}
        state=self.sender.safety(source)
        self.sender.resume_safety(source,state['version'],True)

    def write_snapshot(self, revision, shards):
        """Build a fresh generation from {relative shard filename: raw row list}."""
        root=self.root/'snapshots'/revision
        create_metadata(root)
        for relative,rows in shards.items():
            create_shard(root,relative,rows=rows,group=self.group)
        return root

    def activate_snapshot(self, root):
        with self.source.lock:
            self.adapter.configure(root,self_id=SELF,source_id=self.account,
                source_info={'revision':root.name,'sourceRoot':self.source.config['sourceRoot']})
            self.engine.refresh_connection(force=True)

    def new_service(self):
        return WindowsAutoReply(self.engine,self.source,lambda:self.sender,clock=lambda:self.now)

    def enable(self, cooldown=30):
        return self.service.configure(self.account,self.group,True,self.reply_text,cooldown)

    def transport(self, method, path, payload=None):
        if (method,path)==('GET','/v1/status'):
            return {'protocol':PROTOCOL,'ready':self.ready,'instanceId':'synthetic-inbound-instance',
                    'capabilities':{'sendText':True,'idempotency':True},'binding':deepcopy(self.native),
                    'scope':{'targetPolicy':'selected_conversation'}}
        if (method,path)!=('POST','/v1/send-text'):
            raise AssertionError('Unexpected recording transport operation')
        self.posts.append(deepcopy(payload))
        if self.outcome=='timeout':raise TimeoutError('Synthetic native transport timeout')
        return {**{key:payload[key] for key in ('protocol','requestId','textHash','targetId')},
                'binding':deepcopy(payload['expectedBinding']),'status':self.outcome}


class WindowsInboundTests(unittest.TestCase):
    def setUp(self):
        directory=tempfile.TemporaryDirectory(prefix='webridge-synthetic-inbound-')
        self.addCleanup(directory.cleanup)
        self.f=InboundFixture(directory.name)

    def test_201_message_burst_processes_oldest_real_mention_exactly_once(self):
        f=self.f
        f.enable()
        rows=[{'local':1,'server':1,'time':STAMP+1,'sender':2,
               'text':'请提供批准资料','atuserlist':SELF}]
        rows.extend({'local':number,'server':number,'time':STAMP+2,'sender':2,
                     'text':'普通业务消息 '+str(number),'atuserlist':''} for number in range(2,202))
        updated=f.write_snapshot('burst-201',{'message/message_0.db':rows})
        f.now=STAMP+2
        f.activate_snapshot(updated)

        # Prove the input is a decoded, new, non-self structured mention in the
        # same account, and that only the default recent-200 view omits it.
        all_rows=f.adapter.call('messages',account=f.account,groupId=f.group,limit=2000)
        self.assertEqual(all_rows['warnings'],[])
        self.assertEqual(len(all_rows['messages']),201)
        mentions=[row for row in all_rows['messages'] if row['mentionSelf']]
        self.assertEqual(len(mentions),1)
        trigger=mentions[0]
        self.assertEqual(trigger['serverId'],'1')
        self.assertEqual(trigger['mentionStatus'],'structured')
        self.assertEqual(trigger['decodeStatus'],'ok')
        self.assertEqual(trigger['sourceId'],f.account)
        self.assertTrue(trigger['isSelfKnown']);self.assertFalse(trigger['isSelf'])
        self.assertEqual(trigger['timestamp'],STAMP+1)
        recent=f.adapter.call('messages',account=f.account,groupId=f.group)
        self.assertEqual(len(recent['messages']),200)
        self.assertFalse(any(row['mentionSelf'] for row in recent['messages']))
        self.assertTrue(f.service.get(f.account,f.group)['enabled'])
        self.assertEqual(f.posts,[])

        f.service.tick()
        f.service.tick()

        self.assertEqual(len(f.posts),1,
            'The oldest eligible structured mention in a 201-message burst must not be lost behind the recent-200 UI window.')
        self.assertEqual((f.posts[0]['targetId'],f.posts[0]['text']),(f.group,f.reply_text))
        attempts=f.service.get(f.account,f.group)['attempts']
        self.assertEqual(len(attempts),1)
        self.assertEqual(attempts[0]['status'],'submitted_unconfirmed')
        self.assertEqual(attempts[0]['trigger']['serverId'],'1')

    def test_unrelated_contact_display_error_does_not_stop_approved_reply(self):
        f = self.f
        for revision, rows in (
            ('display-warning-enable', []),
            ('display-warning-new-message', [{'server': 7, 'time': STAMP+1,
                                              'text': '批准范围内的问题', 'atuserlist': SELF}]),
        ):
            root = f.write_snapshot(revision, {'message/message_0.db': rows})
            with closing(sqlite3.connect(root/'contact/contact.db')) as db, db:
                db.execute('INSERT INTO contact VALUES (?,?,?,?,?)',
                           ('unrelated_contact', b'\xff', '', '', 0))
            f.activate_snapshot(root)
            self.assertTrue(f.adapter.call('groups', account=f.account)['warnings'])
            if not rows:
                f.enable()
            else:
                f.now = STAMP+1
                f.service.tick()
        self.assertTrue(f.service.get(f.account, f.group)['enabled'])
        self.assertEqual(len(f.posts), 1)
        self.assertEqual(f.posts[0]['targetId'], f.group)

    def test_display_fallback_preserves_recipient_and_sender_identity(self):
        f = self.f
        root = f.write_snapshot('bad-group-and-peer-labels', {'message/message_0.db': []})
        with closing(sqlite3.connect(root/'contact/contact.db')) as db, db:
            db.execute('UPDATE contact SET remark=? WHERE CAST(username AS TEXT) IN (?,?)',
                       (b'\xff', f.group, PEER))
            db.execute('UPDATE contact SET remark=? WHERE username=?',
                       (b'\xff', 'deleted@chatroom'))
        f.activate_snapshot(root)
        groups = f.adapter.call('groups', account=f.account)
        self.assertEqual(next(row for row in groups['groups'] if row['id'] == f.group)['name'], f.group)
        self.assertNotIn('deleted@chatroom', [row['id'] for row in groups['groups']])
        self.assertTrue(all(row['code'] == 'contact_label_decode_error' for row in groups['warnings']))
        f.enable()
        updated = f.write_snapshot('new-with-bad-sender-label', {'message/message_0.db': [
            {'server': 8, 'time': STAMP+1, 'text': '已批准的问题', 'atuserlist': SELF}]})
        with closing(sqlite3.connect(updated/'contact/contact.db')) as db, db:
            db.execute('UPDATE contact SET remark=? WHERE CAST(username AS TEXT) IN (?,?)',
                       (b'\xff', f.group, PEER))
        f.activate_snapshot(updated)
        f.now = STAMP+1
        f.service.tick()
        self.assertEqual(len(f.posts), 1)
        self.assertEqual(f.posts[0]['targetId'], f.group)
        trigger = f.service.get(f.account, f.group)['attempts'][0]['trigger']
        self.assertEqual((trigger['senderId'], trigger['senderName']), (PEER, PEER))

    def test_contact_identity_and_deletion_errors_still_block_enable(self):
        f = self.f
        for index, (username, deleted) in enumerate(((b'\xff', 0), ('broken_deletion', 'not-an-integer'))):
            with self.subTest(username=username):
                root = f.write_snapshot('invalid-contact-'+str(index), {'message/message_0.db': []})
                with closing(sqlite3.connect(root/'contact/contact.db')) as db, db:
                    db.execute('INSERT INTO contact VALUES (?,?,?,?,?)', (username, b'\xff', '', '', deleted))
                f.activate_snapshot(root)
                warnings = f.adapter.call('groups', account=f.account)['warnings']
                self.assertIn('contact_decode_error', [row['code'] for row in warnings])
                with self.assertRaises(ValueError):
                    f.enable()
        self.assertEqual(f.posts, [])

    def test_display_warning_does_not_override_message_decode_failure(self):
        f = self.f
        f.enable()
        root = f.write_snapshot('display-and-body-corruption', {'message/message_0.db': [
            {'server': 9, 'time': STAMP+1, 'text': b'\xff', 'atuserlist': SELF}]})
        with closing(sqlite3.connect(root/'contact/contact.db')) as db, db:
            db.execute('INSERT INTO contact VALUES (?,?,?,?,?)', ('unrelated_contact', b'\xff', '', '', 0))
        f.activate_snapshot(root)
        f.now = STAMP+1
        f.service.tick()
        self.assertFalse(f.service.get(f.account, f.group)['enabled'])
        self.assertEqual(f.posts, [])

    def test_same_second_burst_across_shards_keeps_oldest_mention(self):
        f=self.f;f.enable();f.now=STAMP+2
        rows=[{'local':number,'server':number,'time':STAMP+1,'sender':2,
               'text':'同秒业务消息 '+str(number),'atuserlist':SELF if number==1 else ''}
              for number in range(1,1206)]
        root=f.write_snapshot('same-second-multiple-shards',{
            'message/message_0.db':rows[:603],
            'biz_message/biz_message_0.db':rows[603:]})
        f.activate_snapshot(root)
        f.service.tick();f.service.tick()
        self.assertEqual(len(f.posts),1,'A same-second burst over multiple pages and shards must retain its oldest mention.')
        attempts=f.service.get(f.account,f.group)['attempts']
        self.assertEqual(len(attempts),1)
        self.assertEqual(attempts[0]['trigger']['serverId'],'1')

    def test_new_revision_accepts_lower_local_id_and_older_fresh_time_once(self):
        f=self.f;f.enable();f.now=STAMP+20
        observed={'local':100,'server':100,'time':STAMP+10,'text':'先观察到的普通消息','atuserlist':''}
        first=f.write_snapshot('observed-higher-coordinate',{'message/message_0.db':[observed]})
        f.activate_snapshot(first);f.service.tick()
        self.assertEqual(f.posts,[])
        late={'local':1,'server':900,'time':STAMP+5,'text':'稍后副本补入的有效提及','atuserlist':SELF}
        shards={'message/message_0.db':[late,observed],
                'biz_message/biz_message_0.db':[{**late,'local':7}]}
        changed=f.write_snapshot('inserted-lower-coordinate',shards)
        f.activate_snapshot(changed);f.service.tick();f.service.tick()
        self.assertEqual(len(f.posts),1)
        attempts=f.service.get(f.account,f.group)['attempts']
        self.assertEqual(len(attempts),1)
        self.assertEqual(attempts[0]['trigger']['serverId'],'900')
        f.now+=31
        unchanged=f.write_snapshot('same-event-next-revision',shards)
        f.activate_snapshot(unchanged);f.service.tick()
        self.assertEqual(len(f.posts),1,'Cross-shard copies and later snapshot revisions must not resubmit the same event.')

    def test_future_dated_pre_enable_mention_beyond_recent_window_is_baseline(self):
        f=self.f
        existing=[{'local':1,'server':1,'time':STAMP+1,'text':'启用前已存在但时间略靠后的提及','atuserlist':SELF}]
        existing.extend({'local':number,'server':number,'time':STAMP+2,
                         'text':'启用前普通消息 '+str(number),'atuserlist':''} for number in range(2,202))
        old=f.write_snapshot('future-dated-before-enable',{'message/message_0.db':existing})
        f.activate_snapshot(old)
        f.enable()
        self.assertEqual(f.posts,[])
        fresh={'local':202,'server':900,'time':STAMP+3,'text':'启用后真正新增的提及','atuserlist':SELF}
        new=f.write_snapshot('new-after-full-baseline',{'message/message_0.db':existing+[fresh]})
        f.now=STAMP+3;f.activate_snapshot(new);f.service.tick();f.service.tick()
        self.assertEqual(len(f.posts),1)
        attempts=f.service.get(f.account,f.group)['attempts']
        self.assertEqual(len(attempts),1,'A known pre-enable message must never become a new trigger because of its future-dated timestamp.')
        self.assertEqual(attempts[0]['trigger']['serverId'],'900')

    def test_later_page_cross_shard_revoke_blocks_original_mention(self):
        f=self.f;f.enable();f.now=STAMP+4
        original={'local':1,'server':1,'time':STAMP+1,'text':'本条随后撤回','atuserlist':SELF}
        healthy={'local':2000,'server':5000,'time':STAMP+4,'text':'仍有效的新提及','atuserlist':SELF}
        later=[{'local':number,'server':number,'time':STAMP+2,
                'text':'两条事件之间的普通消息','atuserlist':''} for number in range(2,1203)]
        later.append({'local':1203,'server':1203,'time':STAMP+3,'type':10002,
            'text':'<sysmsg><revokemsg><newmsgid>1</newmsgid><replacemsg>合成撤回</replacemsg></revokemsg></sysmsg>'})
        root=f.write_snapshot('cross-shard-late-revoke',{
            'message/message_0.db':[original,healthy],
            'biz_message/biz_message_0.db':later})
        f.activate_snapshot(root)
        decoded=f.adapter.call('messages',account=f.account,groupId=f.group,limit=2000)['messages']
        self.assertEqual(next(row for row in decoded if row['serverId']=='1')['kind'],'revoke')
        f.service.tick();f.service.tick()
        self.assertEqual(len(f.posts),1)
        attempts=f.service.get(f.account,f.group)['attempts']
        self.assertEqual(len(attempts),1,'A revoked mention must never be claimed before a later page reveals its revocation.')
        self.assertEqual(attempts[0]['trigger']['serverId'],'5000')

    def test_unknown_claim_survives_restart_reenable_without_resubmission(self):
        f=self.f;f.enable();f.now=STAMP+1;f.outcome='timeout'
        message={'local':1,'server':700,'time':STAMP+1,'text':'提交结果未知的请求','atuserlist':SELF}
        root=f.write_snapshot('unknown-first-attempt',{'message/message_0.db':[message]})
        f.activate_snapshot(root);f.service.tick()
        self.assertEqual(len(f.posts),1)
        self.assertEqual(f.service.get(f.account,f.group)['attempts'][0]['status'],'unknown')
        f.service=f.new_service()
        self.assertFalse(f.service.get(f.account,f.group)['enabled'])
        f.outcome='submitted';f.now+=31
        with self.assertRaises(ValueError):f.enable()
        f.acknowledge_account();f.enable()
        copied=f.write_snapshot('unknown-reappears-after-restart',{
            'message/message_0.db':[message],
            'biz_message/biz_message_0.db':[{**message,'local':9}]})
        f.activate_snapshot(copied);f.service.tick();f.service.tick()
        self.assertTrue(f.service.get(f.account,f.group)['enabled'])
        self.assertEqual(len(f.posts),1,'A persisted unknown attempt cannot be resubmitted by restart or re-enabling.')
        attempts=f.service.get(f.account,f.group)['attempts']
        self.assertEqual(len(attempts),1)
        self.assertEqual(attempts[0]['status'],'unknown')
        self.assertEqual(attempts[0]['trigger']['serverId'],'700')

    def test_cooldown_spans_pages_without_queuing_skipped_mentions(self):
        f=self.f;f.enable(cooldown=30);f.now=STAMP+2
        rows=[{'local':1,'server':1,'time':STAMP+1,'text':'突发中第一条提及','atuserlist':SELF}]
        rows.extend({'local':number,'server':number,'time':STAMP+1,
                     'text':'跨页普通消息','atuserlist':''} for number in range(2,1202))
        rows.append({'local':1202,'server':1202,'time':STAMP+2,'text':'同次突发较后页的提及','atuserlist':SELF})
        root=f.write_snapshot('cooldown-crosses-pages',{'message/message_0.db':rows})
        f.activate_snapshot(root);f.service.tick()
        self.assertEqual(len(f.posts),1)
        attempts=f.service.get(f.account,f.group)['attempts']
        statuses={row['trigger']['serverId']:row['status'] for row in attempts}
        self.assertEqual(statuses,{'1':'submitted_unconfirmed','1202':'cooldown_skipped'})
        f.now+=31;f.service.tick()
        self.assertEqual(len(f.posts),1,'Previously skipped mentions must not turn into a queue after cooldown expires.')
        fresh={'local':1203,'server':9000,'time':f.now,'text':'冷却结束后真正新增的提及','atuserlist':SELF}
        updated=f.write_snapshot('fresh-after-cooldown',{'message/message_0.db':rows+[fresh]})
        f.activate_snapshot(updated);f.service.tick();f.service.tick()
        self.assertEqual(len(f.posts),2)
        attempts=f.service.get(f.account,f.group)['attempts']
        statuses={row['trigger']['serverId']:row['status'] for row in attempts}
        self.assertEqual(statuses,{'1':'submitted_unconfirmed','1202':'cooldown_skipped','9000':'submitted_unconfirmed'})


if __name__=='__main__':unittest.main()
