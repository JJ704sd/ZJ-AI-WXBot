"""Account-wide protections with invented identities and a recording transport."""
import unittest
from contextlib import closing
import json
import sqlite3
from unittest.mock import patch
from windows_hook_sender import WindowsHookSender, HookSendError
import test_windows_hook_sender as fixtures


class AccountSafetyTests(unittest.TestCase):
    def setUp(self):
        self.f = fixtures.HookTests()
        self.f.setUp()
        self.addCleanup(self.f.doCleanups)

    def send(self, key):
        draft = self.f.sender.prepare({**self.f.data, 'idempotencyKey': key})
        return self.f.sender.confirm(self.f.confirm_data(draft))

    def test_distinct_request_ids_cannot_burst_identical_text(self):
        self.assertEqual(self.send('synthetic-safety-first')['status'], 'server_accepted')
        second = self.send('synthetic-safety-second')
        self.assertEqual((second['status'], second['issueCode']), ('blocked', 'account_rate_limited'))
        self.assertEqual(sum(call[0] == 'POST' for call in self.f.calls), 1)

    def test_unknown_stops_new_requests_after_all_rate_windows(self):
        self.f.outcome = TimeoutError('synthetic response lost')
        first = self.send('synthetic-safety-unknown')
        self.assertEqual(first['status'], 'unknown')
        self.f.now += 86401
        self.f.outcome = 'server_accepted'
        second = self.send('synthetic-safety-after-unknown')
        self.assertEqual((second['status'], second['issueCode']), ('blocked', 'account_paused'))
        self.assertEqual(sum(call[0] == 'POST' for call in self.f.calls), 1)

    def test_pause_survives_restart_and_new_directory_for_same_identity(self):
        self.f.outcome = TimeoutError()
        first = self.send('synthetic-persistent-unknown')
        self.f.sender = WindowsHookSender(self.f.root, transport=self.f.transport,
            profiles=[self.f.profile], clock=lambda:self.f.now)
        self.assertTrue(self.f.sender.safety(self.f.source)['paused'])
        self.f.source['sourceRoot'] = str(self.f.root/'another-selected-directory')
        self.f.native['sourceRoot'] = self.f.source['sourceRoot']
        self.f.data.update(self.f.source)
        self.f.now += 86401
        self.assertEqual(self.send('synthetic-new-source-directory')['issueCode'], 'account_paused')
        self.assertEqual(self.f.sender.get(first['draftId'], {**self.f.source,
            'sourceRoot':str(self.f.root/'synthetic-account')})['status'], 'unknown')

    def test_resume_requires_current_version_ack_and_fresh_binding_and_never_replays(self):
        self.f.outcome = TimeoutError()
        first = self.send('synthetic-resume-unknown')
        state = self.f.sender.safety(self.f.source)
        with self.assertRaises(HookSendError): self.f.sender.resume_safety(self.f.source,state['version'],False)
        with self.assertRaises(HookSendError): self.f.sender.resume_safety(self.f.source,state['version']-1,True)
        self.f.instance = 'changed-current-instance'
        self.f.native['selfId'] = 'another-current-identity'
        with self.assertRaises(HookSendError): self.f.sender.resume_safety(self.f.source,state['version'],True)
        self.assertTrue(self.f.sender.safety(self.f.source)['paused'])
        self.f.native['selfId'] = self.f.source['selfId']
        self.f.sender.resume_safety(self.f.source,state['version'],True)
        self.f.outcome='server_accepted';self.f.now+=31
        self.assertEqual(self.f.sender.confirm(self.f.confirm_data(first))['status'],'unknown')
        self.assertEqual(self.send('synthetic-resumed-new-request')['status'],'server_accepted')
        self.assertEqual(sum(call[0]=='POST' for call in self.f.calls),2)

    def test_identities_are_dynamic_isolated_and_never_rejected_by_fixture_prefix(self):
        identities = ['operator.selected.A9','different_selected_id_20','配置中的本人']
        for i,identity in enumerate(identities):
            self.f.source.update(account='selected-source-'+str(i),sourceId='selected-source-'+str(i),selfId=identity)
            self.f.native['selfId']=identity;self.f.data.update(self.f.source)
            self.assertEqual(self.send('synthetic-dynamic-account-'+str(i))['status'],'server_accepted')
        self.assertEqual(sum(call[0]=='POST' for call in self.f.calls),len(identities))

    def test_unknown_pause_is_isolated_to_selected_identity(self):
        original=dict(self.f.source)
        self.f.outcome=TimeoutError();self.send('synthetic-pause-original')
        self.f.source.update(account='another-selected-source',sourceId='another-selected-source',selfId='another-selected-owner')
        self.f.native['selfId']=self.f.source['selfId'];self.f.data.update(self.f.source)
        self.f.outcome='server_accepted'
        self.assertEqual(self.send('synthetic-other-owner')['status'],'server_accepted')
        self.assertTrue(self.f.sender.safety(original)['paused'])
        self.assertFalse(self.f.sender.safety(self.f.source)['paused'])

    def test_minute_and_day_budgets_are_shared_and_configuration_cannot_resume(self):
        limits={'minimumIntervalSeconds':1,'perMinute':2,'per24Hours':3,'duplicateWindowSeconds':5}
        state=self.f.sender.safety(self.f.source)
        self.f.sender.configure_safety(self.f.source,limits,state['version'])
        self.assertEqual(self.send('synthetic-quota-one')['status'],'server_accepted')
        self.f.now+=5
        self.assertEqual(self.send('synthetic-quota-two')['status'],'server_accepted')
        self.f.now+=5
        self.assertEqual(self.send('synthetic-quota-minute')['issueCode'],'account_rate_limited')
        self.f.now+=60
        self.assertEqual(self.send('synthetic-quota-three')['status'],'server_accepted')
        self.f.now+=60
        self.assertEqual(self.send('synthetic-quota-day')['issueCode'],'account_rate_limited')
        self.f.now+=86400
        self.f.outcome=TimeoutError()
        self.assertEqual(self.send('synthetic-quota-unknown')['status'],'unknown')
        state=self.f.sender.safety(self.f.source)
        self.assertTrue(self.f.sender.configure_safety(self.f.source,limits,state['version'])['paused'])

    def test_duplicate_content_survives_spacing_but_only_same_target_is_blocked(self):
        self.assertEqual(self.send('synthetic-duplicate-one')['status'],'server_accepted')
        self.f.now+=5
        self.assertEqual(self.send('synthetic-duplicate-two')['issueCode'],'account_rate_limited')
        self.f.scope={'targetPolicy':'selected_conversation'}
        self.f.data.update(targetId='selected-other-target',targetName='另一当前会话')
        self.assertEqual(self.send('synthetic-different-target')['status'],'server_accepted')

    def test_old_unknown_journal_migrates_without_identity_allowlist_or_replay(self):
        self.f.outcome=TimeoutError()
        old=self.send('synthetic-legacy-unknown')
        self.f.sender.account_safety.path.unlink()
        self.f.sender=WindowsHookSender(self.f.root,transport=self.f.transport,
            profiles=[self.f.profile],clock=lambda:self.f.now)
        self.assertTrue(self.f.sender.safety(self.f.source)['paused'])
        self.f.now+=86401
        self.assertEqual(self.send('synthetic-legacy-new')['issueCode'],'account_paused')
        self.assertEqual(self.f.sender.confirm(self.f.confirm_data(old))['status'],'unknown')

    def test_failure_after_admission_is_conservatively_paused_before_next_send(self):
        draft=self.f.sender.prepare(self.f.data)
        with patch.object(self.f.sender,'_connect',side_effect=sqlite3.OperationalError('synthetic write failure')):
            with self.assertRaises(sqlite3.Error):self.f.sender.confirm(self.f.confirm_data(draft))
        # Simulate a crash after the durable safety claim, before the native boundary.
        self.f.sender.account_safety.admit(self.f.data,draft['draftId'],self.f.data['targetId'],draft['textHash'])
        self.f.now+=86401
        self.assertEqual(self.send('synthetic-after-orphan')['issueCode'],'account_paused')
        self.assertEqual(sum(call[0]=='POST' for call in self.f.calls),0)

    def test_late_native_success_cannot_clear_a_transport_unknown(self):
        self.f.outcome=TimeoutError()
        result=self.send('synthetic-late-native-result')
        self.f.sender.account_safety.finish(self.f.source,result['draftId'],'submitted')
        status=self.f.sender.safety(self.f.source)
        self.assertTrue(status['paused']);self.assertEqual(status['unresolvedCount'],1)

    def test_status_is_additive_and_a_disconnected_bridge_does_not_clear_pause(self):
        self.f.outcome=TimeoutError();self.send('synthetic-status-pause')
        self.assertEqual(self.f.sender.status(self.f.source)['issueCode'],'account_paused')
        self.f.sender.transport=None
        status=self.f.sender.status(self.f.source)
        self.assertFalse(status['available']);self.assertTrue(status['safety']['paused'])

    def test_workbench_and_native_bridge_count_the_same_request_once(self):
        import test_windows_hook_bridge as native
        boundary=native.FakeNative();boundary.binding=self.f.sender.automation_binding(self.f.source)
        bridge=native.bridge_module.TextBridge(boundary,self.f.root,clock=lambda:self.f.now)
        original=self.f.transport
        self.f.sender.transport=lambda method,path,payload=None: original(method,path,payload) if method=='GET' else bridge.send(payload)
        self.assertEqual(self.send('synthetic-shared-native-request')['status'],'submitted_unconfirmed')
        self.assertEqual(self.f.sender.safety(self.f.source)['usage']['minute'],1)
        self.assertEqual(self.send('synthetic-shared-native-burst')['issueCode'],'account_rate_limited')
        self.assertEqual(len(boundary.calls),2)

    def test_configured_sender_uses_shared_budget_with_nested_draft_directory(self):
        import hashlib
        import test_windows_hook_bridge as native
        boundary=native.FakeNative();boundary.binding=self.f.sender.automation_binding(self.f.source)
        bridge=native.bridge_module.TextBridge(boundary,self.f.root,clock=lambda:self.f.now)
        (self.f.root/'token').write_text('a'*32,encoding='ascii')
        (self.f.root/'profiles.json').write_text(json.dumps([self.f.profile]),encoding='utf-8')
        config=self.f.root/'hook-config.json'
        config.write_text(json.dumps({'endpoint':'http://127.0.0.1:8789','tokenFile':'token',
                                     'profilesFile':'profiles.json'}),encoding='utf-8')
        client=WindowsHookSender.from_config(self.f.root/'hook-send',config,safety_directory=self.f.root)
        client.clock=lambda:self.f.now;client.account_safety.clock=client.clock
        client.transport=self.f.transport
        request={'protocol':native.bridge_module.PROTOCOL,'requestId':'b'*32,'draftId':'b'*32,
            'textHash':hashlib.sha256(b'direct initial').hexdigest(),'text':'direct initial','targetId':'filehelper',
            'expectedBinding':boundary.binding}
        self.assertEqual(bridge.send(request)['status'],'submitted')
        draft=client.prepare({**self.f.data,'idempotencyKey':'synthetic-nested-budget'})
        self.assertEqual(client.confirm(self.f.confirm_data(draft))['issueCode'],'account_rate_limited')
        self.assertEqual(client.safety(self.f.source)['usage']['minute'],1)
        self.assertEqual(len(boundary.calls),2)

    def test_missing_config_in_uncreated_directory_stays_disconnected(self):
        unused=self.f.root/'not-created'/'config.json'
        client=WindowsHookSender.from_config(self.f.root/'standalone-drafts',unused)
        self.assertIsNone(client.transport)
        self.assertEqual(client.account_safety.path.parent,client.directory)
        self.assertFalse(unused.parent.exists())

    def test_native_direct_limits_unknown_and_old_journal_are_not_bypassable(self):
        import test_windows_hook_bridge as native
        boundary=native.FakeNative()
        bridge=native.bridge_module.TextBridge(boundary,self.f.root,clock=lambda:self.f.now)
        def request(marker):
            import hashlib
            text='synthetic direct text'
            return {'protocol':native.bridge_module.PROTOCOL,'requestId':marker*32,'draftId':marker*32,
                'textHash':hashlib.sha256(text.encode()).hexdigest(),'text':text,'targetId':'filehelper',
                'expectedBinding':boundary.binding}
        self.assertEqual(bridge.send(request('a'))['status'],'submitted')
        denied=bridge.send(request('b'))
        self.assertEqual((denied['status'],denied['issueCode']),('not_submitted','account_rate_limited'))
        self.f.now+=31
        self.assertEqual(bridge.send(request('b')),denied)
        boundary.fail=True
        self.assertEqual(bridge.send(request('c'))['status'],'unknown')
        bridge.safety.path.unlink()
        replacement=native.FakeNative()
        restarted=native.bridge_module.TextBridge(replacement,self.f.root,clock=lambda:self.f.now)
        self.f.now+=86401
        self.assertEqual(restarted.send(request('d'))['issueCode'],'account_paused')
        self.assertEqual(replacement.calls,[])

    def test_interrupted_native_boundary_immediately_pauses_account(self):
        import test_windows_hook_bridge as native
        boundary=native.FakeNative();bridge=native.bridge_module.TextBridge(boundary,self.f.root,clock=lambda:self.f.now)
        request={'protocol':native.bridge_module.PROTOCOL,'requestId':'a'*32,'draftId':'a'*32,
            'textHash':__import__('hashlib').sha256(b'synthetic text').hexdigest(),'text':'synthetic text',
            'targetId':'filehelper','expectedBinding':boundary.binding}
        with patch.object(boundary,'submit',side_effect=KeyboardInterrupt()):
            with self.assertRaises(KeyboardInterrupt):bridge.send(request)
        self.assertTrue(bridge.safety.status(boundary.binding)['paused'])


class CrossFeatureSafetyTests(unittest.TestCase):
    def setUp(self):
        import test_windows_auto_reply as auto
        self.f=auto.AutoReplyTests();self.f.setUp();self.addCleanup(self.f.doCleanups)

    def test_unknown_in_first_group_stops_second_group_in_same_tick(self):
        f=self.f;second='synthetic-second@chatroom'
        f.engine.group_list.append({'id':second,'name':'第二合成群'})
        f.engine.store.set_watched(f.account,[f.group,second])
        for group in (f.group,second):f.service.configure(f.account,group,True,'合成固定正文',30)
        f.now+=1;f.rows=[f.message()];f.outcome='timeout'
        original=f.transport
        def transport(method,path,payload=None):
            try:return original(method,path,payload)
            finally:
                if method=='POST':f.now+=31;f.outcome='submitted'
        f.sender.transport=transport;f.service.tick()
        self.assertEqual(len(f.posts),1)
        self.assertFalse(f.service.get(f.account,f.group)['enabled'])
        self.assertFalse(f.service.get(f.account,second)['enabled'])

    def test_manual_unknown_stops_an_enabled_schedule_and_auto_reply(self):
        from windows_scheduler import WindowsScheduler,BEIJING
        from datetime import datetime
        f=self.f;f.now=datetime(2026,10,10,10,0,tzinfo=BEIJING).timestamp()
        f.enable()
        scheduler=WindowsScheduler(f.engine,f.source,lambda:f.sender,clock=lambda:f.now)
        job=scheduler.create({'account':f.account,'groupId':f.group,'text':'合成计划正文',
            'requestId':'synthetic-cross-schedule','mode':'once','at':'2026-10-10T10:01'})
        source={'account':f.account,'sourceId':f.account,'selfId':'self','sourceRoot':f.source.config['sourceRoot']}
        draft=f.sender.prepare({**source,'targetId':f.group,'targetName':'当前合成群',
            'text':'合成人工正文','idempotencyKey':'synthetic-cross-manual'})
        f.outcome='timeout';self.assertEqual(f.sender.confirm({**source,**draft,'targetConfirmed':True})['status'],'unknown')
        f.now=job['nextRun'];f.rows=[f.message()];f.service.tick();scheduler.tick()
        self.assertEqual(len(f.posts),1)
        self.assertFalse(f.service.get(f.account,f.group)['enabled'])
        self.assertFalse(scheduler.list(f.account)[0]['enabled'])
        f.acknowledge_account()
        self.assertFalse(f.service.get(f.account,f.group)['enabled'])
        self.assertFalse(scheduler.list(f.account)[0]['enabled'])


if __name__ == '__main__':
    unittest.main()
