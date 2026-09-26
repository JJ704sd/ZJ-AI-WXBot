import json
from pathlib import Path
import tempfile
import threading
import unittest
from datetime import datetime
from backend import Engine, Store, TZ


class FakeAdapter:
    def __init__(self):self.account='account-a';self.messages=[];self.sent=[]
    def auth(self):return {'status':'logged_in' if self.account else 'logged_out','loggedInUser':self.account}
    def logout(self):self.account=None;return {'success':True}
    def call(self,action,**params):
        if action=='messages':return {'messages':self.messages}
        if action=='groups':return {'groups':[{'id':'group-a','name':'测试群'}],'selfId':'self-a','name':'测试账号'}
        if action=='send':self.sent.append(params);return {'status':'sent','serverId':'123'}
        return {}


class CoreTests(unittest.TestCase):
    def setUp(self):
        self.temp=tempfile.TemporaryDirectory();self.store=Store(Path(self.temp.name)/'state.sqlite')
        self.t=datetime(2026,9,22,8,0,tzinfo=TZ).timestamp()
    def tearDown(self):self.temp.cleanup()
    def message(self,id='1',**changes):
        return {'id':id,'serverId':id,'senderId':'other','timestamp':self.t+2,'isSelf':False,'mentionSelf':True,**changes}
    def rule(self):self.store.set_reply('account-a','group-a',True,'已收到',30,now=self.t)

    def test_idempotent_manual_requests_do_not_double_queue(self):
        for _ in range(2):self.store.enqueue('account-a','group-a','hello',[],id='request-123',now=self.t)
        self.assertEqual(len(self.store.outbox('account-a')),1)
        with self.assertRaises(ValueError):self.store.enqueue('account-a','group-a','changed',[],id='request-123')

    def test_same_server_message_triggers_only_once_even_after_cooldown(self):
        self.rule();self.assertTrue(self.store.auto_reply('account-a','group-a',self.message(),now=self.t+3))
        self.assertFalse(self.store.auto_reply('account-a','group-a',self.message(),now=self.t+100))
        row=self.store.outbox('account-a')[0];self.assertEqual(row['mentions'],['other'])

    def test_plain_self_everyone_and_pre_activation_messages_do_not_reply(self):
        self.rule()
        for msg in [self.message(mentionSelf=False),self.message(isSelf=True),self.message(mentionSelf=False,mentionEveryone=True),self.message(timestamp=self.t-10),self.message(serverId='0')]:
            self.assertFalse(self.store.auto_reply('account-a','group-a',msg,now=self.t+100))
        self.assertEqual(self.store.outbox('account-a'),[])

    def test_cooldown_and_disable_cancel_queued_replies(self):
        self.rule();self.assertTrue(self.store.auto_reply('account-a','group-a',self.message('1'),now=self.t+3))
        self.assertFalse(self.store.auto_reply('account-a','group-a',self.message('2'),now=self.t+4))
        self.store.set_reply('account-a','group-a',False,'已收到',30,now=self.t+5)
        self.assertEqual(self.store.outbox('account-a')[0]['status'],'cancelled')

    def test_enabling_reply_baselines_existing_mentions(self):
        adapter=FakeAdapter();adapter.messages=[self.message()];engine=Engine(self.store,adapter)
        engine.refresh_connection();engine.set_watched('account-a',['group-a']);engine.set_reply('account-a','group-a',True,'已收到',30)
        engine.sync_group('account-a','group-a')
        self.assertEqual(self.store.outbox('account-a'),[])

    def test_first_poll_after_restart_never_replays_unseen_history(self):
        self.rule();adapter=FakeAdapter();adapter.messages=[self.message()]
        engine=Engine(self.store,adapter);engine.refresh_connection();engine.sync_group('account-a','group-a')
        self.assertEqual(self.store.outbox('account-a'),[])

    def test_daily_job_runs_once_per_day_and_uses_bound_account(self):
        self.store.add_job('account-a','group-a','daily',['other'],'09:00',now=self.t)
        self.assertEqual(self.store.schedule_due('account-b',self.t+3600),[])
        self.assertEqual(len(self.store.schedule_due('account-a',self.t+3600)),1)
        self.assertEqual(self.store.schedule_due('account-a',self.t+3601),[])
        self.assertEqual(len(self.store.schedule_due('account-a',self.t+86400+3600)),1)

    def test_daily_time_already_passed_starts_tomorrow(self):
        self.store.add_job('account-a','group-a','daily',[],'07:00',now=self.t)
        self.assertEqual(self.store.schedule_due('account-a',self.t),[])
        self.assertEqual(len(self.store.schedule_due('account-a',self.t+86400-3600)),1)

    def test_missed_jobs_beyond_grace_are_not_sent(self):
        self.store.add_job('account-a','group-a','daily',[],'09:00',now=self.t)
        self.assertEqual(self.store.schedule_due('account-a',self.t+7200),[])
        self.assertEqual(self.store.outbox('account-a'),[])

    def test_restart_keeps_unknown_outcome_and_cancels_unsent_queue(self):
        self.store.enqueue('account-a','group-a','one',[],id='request-111');self.store.claim()
        self.store.enqueue('account-a','group-a','two',[],id='request-222')
        restored=Store(self.store.path);rows={r['id']:r for r in restored.outbox('account-a')}
        self.assertEqual(rows['request-111']['status'],'unknown');self.assertEqual(rows['request-222']['status'],'cancelled')
        self.assertIsNone(restored.claim())

    def test_daily_disable_cancels_unsubmitted_occurrence(self):
        id=self.store.add_job('account-a','group-a','daily',[],'09:00',now=self.t)
        self.store.schedule_due('account-a',self.t+3600);self.store.cancel_job('account-a',id)
        self.assertEqual(self.store.outbox('account-a')[0]['status'],'cancelled');self.assertIsNone(self.store.claim())

    def test_account_change_blocks_old_group_actions(self):
        adapter=FakeAdapter();engine=Engine(self.store,adapter);engine.refresh_connection();adapter.account='account-b';engine.refresh_connection()
        with self.assertRaises(ValueError):engine.validate('account-a','group-a')

    def test_auth_poll_finishing_after_logout_cannot_restore_old_account(self):
        adapter=FakeAdapter();engine=Engine(self.store,adapter);engine.refresh_connection()
        entered=threading.Event();release=threading.Event();original=adapter.auth;calls=[]
        def delayed_auth():
            calls.append(True);result=original()
            if len(calls)==1:
                entered.set();release.wait(3)
            return result
        adapter.auth=delayed_auth
        stale=threading.Thread(target=engine.refresh_connection)
        stale.start()
        try:
            self.assertTrue(entered.wait(2))
            engine.logout('account-a')
            self.assertIsNone(engine.account)
        finally:
            release.set();stale.join(timeout=3)
        self.assertFalse(stale.is_alive())
        self.assertIsNone(engine.account)
        self.assertEqual(engine.connection['status'],'logged_out')

    def test_background_auth_poll_does_not_discard_inflight_group_refresh(self):
        adapter=FakeAdapter();engine=Engine(self.store,adapter);engine.refresh_connection()
        entered=threading.Event();release=threading.Event();original=adapter.call
        def delayed_groups(action,**params):
            result=original(action,**params)
            if action=='groups':
                result['groups'].append({'id':'group-new','name':'新加入的群'})
                entered.set();release.wait(3)
            return result
        adapter.call=delayed_groups
        refresh=threading.Thread(target=engine.refresh_connection,kwargs={'force':True})
        refresh.start()
        try:
            self.assertTrue(entered.wait(2))
            # The ordinary polling loop only checks auth when groups are cached.
            engine.refresh_connection()
        finally:
            release.set();refresh.join(timeout=3)
        self.assertFalse(refresh.is_alive())
        self.assertIn('group-new',[group['id'] for group in engine.group_list])

    def test_old_group_query_cannot_overwrite_a_newer_completed_refresh(self):
        adapter=FakeAdapter();engine=Engine(self.store,adapter);engine.refresh_connection()
        entered=threading.Event();release=threading.Event();original=adapter.call;queries=[]
        def reordered_groups(action,**params):
            result=original(action,**params)
            if action=='groups':
                queries.append(True)
                version=len(queries)
                result['groups']=[{'id':f'group-{version}','name':f'更新{version}'}]
                if version==1:
                    entered.set();release.wait(3)
            return result
        adapter.call=reordered_groups
        first=threading.Thread(target=engine.refresh_connection,kwargs={'force':True})
        first.start()
        try:
            self.assertTrue(entered.wait(2))
            engine.refresh_connection(force=True)
        finally:
            release.set();first.join(timeout=3)
        self.assertFalse(first.is_alive())
        self.assertEqual([group['id'] for group in engine.group_list],['group-2'])

    def test_new_account_reading_is_opt_in_and_removal_disables_reply(self):
        engine=Engine(self.store,FakeAdapter());engine.refresh_connection()
        self.assertEqual(self.store.watched('account-a'),[])
        with self.assertRaises(ValueError):engine.set_reply('account-a','group-a',True,'test',30)
        engine.set_watched('account-a',['group-a']);engine.set_reply('account-a','group-a',True,'test',30)
        engine.set_watched('account-a',[])
        self.assertFalse(self.store.reply('account-a','group-a')['enabled'])

    def test_logout_pauses_reply_and_cancels_unsubmitted_messages(self):
        self.rule();adapter=FakeAdapter();engine=Engine(self.store,adapter);engine.refresh_connection()
        self.store.enqueue('account-a','group-a','queued',[],id='logout-test')
        engine.logout('account-a')
        self.assertIsNone(engine.account)
        self.assertFalse(self.store.reply('account-a','group-a')['enabled'])
        self.assertEqual(self.store.outbox('account-a')[0]['status'],'cancelled')

    def test_removed_scope_and_logout_during_query_do_not_ingest(self):
        adapter=FakeAdapter();engine=Engine(self.store,adapter);engine.refresh_connection()
        adapter.messages=[self.message()]
        engine.sync_group('account-a','group-a')
        self.assertEqual(self.store.rows('SELECT * FROM messages'),[])
        engine.set_watched('account-a',['group-a'])
        original_call=adapter.call
        def logged_out_during_query(action,**params):
            result=original_call(action,**params)
            if action=='messages':engine.logging_out=True
            return result
        adapter.call=logged_out_during_query
        with self.assertRaises(ValueError):engine.sync_group('account-a','group-a')
        self.assertEqual(self.store.rows('SELECT * FROM messages'),[])

    def test_revoke_update_removes_attachment_presentation(self):
        original=self.message('9',kind='image',media={'kind':'image'},text='image')
        self.store.ingest('account-a','group-a',[original])
        notice=self.message('10',kind='revoke',revokedServerId='9',text='已撤回')
        self.store.ingest('account-a','group-a',[notice])
        payload=json.loads(self.store.rows('SELECT payload FROM messages WHERE id=?',('9',))[0]['payload'])
        self.assertEqual(payload['kind'],'revoke');self.assertNotIn('media',payload)
        self.assertFalse(self.store.auto_reply('account-a','group-a',notice))


if __name__=='__main__':unittest.main()
