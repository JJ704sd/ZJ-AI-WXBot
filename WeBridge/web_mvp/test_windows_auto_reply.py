"""Synthetic metadata and recording native transport; never contacts WeChat."""
from copy import deepcopy
from pathlib import Path
from types import SimpleNamespace
import tempfile
import threading
import unittest
from unittest.mock import patch

from backend import Engine, Store
from windows_auto_reply import WindowsAutoReply
from windows_hook_sender import WindowsHookSender, PROTOCOL


class AutoReplyTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.now = 1000
        self.account, self.group = 'database:synthetic', 'synthetic@chatroom'
        self.rows, self.warnings, self.posts = [], [], []
        adapter = SimpleNamespace(read_only=True, mode='database', call=self.call)
        self.engine = Engine(Store(self.root/'state.sqlite'), adapter)
        self.engine.account, self.engine.self_id = self.account, 'self'
        self.engine.connection = {'status':'snapshot_ready'}
        self.engine.group_list = [{'id':self.group, 'name':'合成群'}]
        self.engine.store.set_watched(self.account, [self.group])
        self.source = SimpleNamespace(lock=threading.RLock(), busy=False, error='',
            config={'sourceRoot':str(self.root/'source'), 'selfId':'self', 'autoRefresh':True})
        self.profile = {'clientVersion':'4.1.15.13','arch':'x64','moduleName':'Weixin.dll','moduleSha256':'a'*64}
        self.native = {**self.profile, 'pid':123,'processStarted':'134019987654321000',
            'selfId':'self','sourceRoot':self.source.config['sourceRoot']}
        self.ready, self.outcome = True, 'submitted'
        self.sender = WindowsHookSender(self.root/'hook', transport=self.transport, profiles=[self.profile], clock=lambda:self.now)
        self.service = self.service_new()

    def service_new(self):
        return WindowsAutoReply(self.engine, self.source, lambda:self.sender, clock=lambda:self.now)

    def call(self, action, **kwargs):
        if action == 'inbound_messages':
            return {'messages': [deepcopy(row) for row in self.rows
                                 if row['timestamp'] >= kwargs['start'] and
                                 (kwargs['end'] is None or row['timestamp'] <= kwargs['end'])],
                    'warnings': self.warnings, 'cursor': None, 'complete': True}
        return {'messages':deepcopy(self.rows), 'warnings':self.warnings}

    def transport(self, method, path, payload=None):
        if method=='GET':
            return {'protocol':PROTOCOL,'ready':self.ready,'instanceId':'synthetic-instance',
                'capabilities':{'sendText':True,'idempotency':True},'binding':self.native,
                'scope':{'targetPolicy':'selected_conversation'}}
        self.posts.append(deepcopy(payload))
        if self.outcome=='timeout': raise TimeoutError()
        return {**{key:payload[key] for key in ('protocol','requestId','textHash','targetId')},
                'binding':payload['expectedBinding'],'status':self.outcome}

    def enable(self):
        return self.service.configure(self.account,self.group,True,'Hello，斯内特',30)

    def message(self, id=1, **changes):
        return {'id':str(id),'serverId':str(id),'senderId':'other','senderName':'合成业务联系人','timestamp':self.now,
            'isSelfKnown':True,'isSelf':False,'mentionSelf':True,'mentionEveryone':False,
            'mentionStatus':'structured','decodeStatus':'ok','source':'database',
            'sourceId':self.account,'kind':'text','type':1,'text':'@ self', **changes}

    def test_new_explicit_mention_sends_once_and_baseline_never_sends(self):
        self.rows=[self.message()];self.enable();self.now+=1;self.service.tick()
        self.assertEqual(self.posts,[])
        self.rows.append(self.message(2));self.service.tick();self.service.tick()
        self.assertEqual(len(self.posts),1)
        self.assertEqual((self.posts[0]['targetId'],self.posts[0]['text']),(self.group,'Hello，斯内特'))
        self.assertEqual(self.service.get(self.account,self.group)['attempts'][0]['status'],'submitted_unconfirmed')

    def test_plain_at_all_self_unknown_and_revoked_never_trigger(self):
        self.enable();self.now+=1
        changes=[{'mentionSelf':False}, {'mentionEveryone':True}, {'isSelf':True},
            {'isSelfKnown':False}, {'mentionStatus':'unknown'}, {'mentionStatus':'invalid'},
            {'kind':'revoke'}, {'kind':'system'}, {'sourceId':'wrong'}, {'decodeStatus':'error'},
            {'serverId':'0'}, {'senderId':''}]
        self.rows=[self.message(n+1,**change) for n,change in enumerate(changes)]
        self.service.tick();self.assertEqual(self.posts,[])

    def test_cross_shard_duplicate_server_id_and_cooldown_no_backlog(self):
        self.enable();self.now+=1
        self.rows=[self.message(),self.message(id=2,serverId='1'),self.message(3)]
        self.service.tick();self.assertEqual(len(self.posts),1)
        self.now+=31;self.service.tick();self.assertEqual(len(self.posts),1)
        self.rows.append(self.message(4));self.service.tick();self.assertEqual(len(self.posts),2)

    def test_decisions_preserve_trigger_and_approved_text_after_rule_changes(self):
        self.enable();self.now+=1
        self.rows=[self.message(1,text='请问本周价格表？'),self.message(2,text='另一个请求')]
        self.service.tick()
        self.service.configure(self.account,self.group,False,'改后的模板',60)
        attempts=self.service.get(self.account,self.group)['attempts']
        by_message={row['trigger']['messageId']:row for row in attempts}
        self.assertEqual(set(by_message),{'1','2'})
        self.assertEqual(by_message['1']['decision'],'reply')
        self.assertEqual(by_message['1']['trigger']['text'],'请问本周价格表？')
        self.assertEqual(by_message['2']['decision'],'cooldown_skipped')
        self.assertEqual(by_message['2']['status'],'cooldown_skipped')
        self.assertTrue(all(row['replyText']=='Hello，斯内特' for row in attempts))
        self.assertEqual(by_message['1']['trigger']['senderName'],'合成业务联系人')
        self.assertEqual(len(self.posts),1)

    def test_trigger_is_durable_before_transport_and_survives_unknown(self):
        self.enable();self.now+=1;self.rows=[self.message(text='长'*2200)];self.outcome='timeout'
        transport=self.transport
        def inspect_claim(method,path,payload=None):
            if method=='POST':
                attempts=self.service.get(self.account,self.group)['attempts']
                self.assertEqual(len(attempts),1)
                self.assertEqual(attempts[0]['status'],'attempted')
                self.assertEqual(attempts[0]['replyText'],'Hello，斯内特')
                self.assertEqual(len(attempts[0]['trigger']['text']),2000)
                self.assertTrue(attempts[0]['trigger']['textTruncated'])
            return transport(method,path,payload)
        self.sender.transport=inspect_claim
        self.service.tick()
        record=self.service.get(self.account,self.group)['attempts'][0]
        self.assertEqual(record['status'],'unknown')
        self.assertEqual(record['trigger']['messageId'],'1')
        self.assertEqual(record['replyText'],'Hello，斯内特')
        self.service=self.service_new();self.service.tick()
        self.assertEqual(self.service.get(self.account,self.group)['attempts'][0]['trigger'],record['trigger'])
        self.assertEqual(len(self.posts),1)

    def test_unexpected_send_error_is_recorded_then_propagated_without_retry(self):
        self.enable();self.now+=1;self.rows=[self.message()]
        with patch.object(self.sender,'send_automatic',side_effect=RuntimeError('synthetic programmer error')):
            with self.assertRaisesRegex(RuntimeError,'synthetic programmer error'):
                self.service.tick()
        result=self.service.get(self.account,self.group)
        self.assertFalse(result['enabled'])
        self.assertEqual(result['attempts'][0]['status'],'unknown')
        self.assertEqual(result['attempts'][0]['trigger']['messageId'],'1')
        self.service.tick();self.assertEqual(self.posts,[])

    def test_unexpected_read_error_is_not_hidden_as_normal_disconnect(self):
        self.enable()
        with patch.object(self.service,'_messages',side_effect=RuntimeError('synthetic decoder bug')):
            with self.assertRaisesRegex(RuntimeError,'synthetic decoder bug'):
                self.service.tick()
        self.assertEqual(self.service.get(self.account,self.group)['attempts'],[])
        self.assertEqual(self.posts,[])

    def test_execution_history_uses_frozen_reply_and_searchable_trigger_without_hook(self):
        from execution_history import history
        self.enable();self.now+=1
        self.rows=[self.message(1,text='请提供季度价格表'),self.message(2,text='需要联系业务员')]
        self.service.tick()
        self.service.configure(self.account,self.group,False,'新的模板不属于旧记录',30)
        result=history(self.engine,source='reply',query='季度价格表')
        self.assertEqual(len(result['records']),1)
        record=result['records'][0]
        self.assertEqual(record['text'],'Hello，斯内特')
        self.assertFalse(record['textUnavailable'])
        self.assertEqual(record['trigger']['messageId'],'1')
        self.assertEqual(record['decision'],'reply')
        skipped=history(self.engine,source='reply',query='需要联系业务员')['records'][0]
        self.assertEqual(skipped['status'],'cooldown_skipped')
        self.assertEqual(skipped['text'],'Hello，斯内特')
        self.assertEqual(len(history(self.engine,query='合成业务联系人')['records']),2)
        self.engine.store.set_watched(self.account,[])
        self.assertEqual(history(self.engine,source='reply')['records'],[])

    def test_old_and_future_messages_are_not_eligible(self):
        self.enable();self.now+=200
        self.rows=[self.message(1,timestamp=1001),self.message(2,timestamp=self.now+60)]
        self.service.tick();self.assertEqual(self.posts,[])

    def test_timeout_is_durable_no_retry_even_reenable(self):
        self.enable();self.now+=1;self.rows=[self.message()];self.outcome='timeout'
        self.service.tick();self.assertEqual(len(self.posts),1)
        self.assertFalse(self.service.get(self.account,self.group)['enabled'])
        self.service.tick();self.enable();self.now+=40;self.service.tick()
        self.assertEqual(len(self.posts),1)

    def test_restart_disables_rules(self):
        self.enable();self.service=self.service_new();self.now+=1;self.rows=[self.message()]
        self.service.tick();self.assertEqual(self.posts,[])
        self.assertFalse(self.service.get(self.account,self.group)['enabled'])

    def test_failed_baseline_scan_preserves_previous_rule_and_baseline(self):
        from backend import BridgeError
        old = self.message(1, timestamp=self.now+1)
        new = self.message(2, timestamp=self.now+2)
        self.rows = [old]
        self.enable()
        first_page = {'messages': [new], 'warnings': [], 'cursor': {'page': 2}, 'complete': False}
        with patch.object(self.service, '_inbound', side_effect=[first_page, BridgeError('synthetic read failure')]):
            with self.assertRaises(BridgeError):
                self.service.configure(self.account, self.group, True, 'new template', 30)
        self.assertEqual(self.service.get(self.account, self.group)['text'], 'Hello，斯内特')
        self.now += 3
        self.rows = [old, new]
        self.service.tick()
        self.assertEqual(len(self.posts), 1)
        attempt = self.service.get(self.account, self.group)['attempts'][0]
        self.assertEqual(attempt['trigger']['serverId'], '2')
        self.assertEqual(attempt['replyText'], 'Hello，斯内特')

    def test_native_change_requires_reenable(self):
        self.enable();self.now+=1;self.rows=[self.message()];self.native['pid']=124
        self.service.tick();self.assertEqual(self.posts,[])
        self.assertFalse(self.service.get(self.account,self.group)['enabled'])

    def test_disconnect_pauses_and_no_catchup_on_recovery(self):
        self.enable();self.ready=False;self.service.tick();self.ready=True
        self.now+=1;self.rows=[self.message()];self.service.tick();self.assertEqual(self.posts,[])

    def test_source_error_or_unwatch_pauses(self):
        self.enable();self.engine.store.set_watched(self.account,[])
        self.service.pause_unwatched(self.account)
        self.assertFalse(self.service.get(self.account,self.group)['enabled'])
        self.engine.store.set_watched(self.account,[self.group]);self.enable()
        self.source.error='snapshot error';self.service.tick()
        self.assertFalse(self.service.get(self.account,self.group)['enabled'])

    def test_disable_works_with_hook_disconnected(self):
        self.enable();self.ready=False
        self.service.configure(self.account,self.group,False,'Hello，斯内特',30)
        self.assertFalse(self.service.get(self.account,self.group)['enabled'])

    def test_busy_snapshot_does_not_send_and_warning_pauses(self):
        self.enable();self.now+=1;self.rows=[self.message()];self.source.busy=True
        self.service.tick();self.assertEqual(self.posts,[])
        self.source.busy=False;self.warnings=[{'code':'invalid'}];self.service.tick()
        self.assertFalse(self.service.get(self.account,self.group)['enabled'])

    def test_enable_requires_valid_text_group_read_scope_and_auto_refresh(self):
        for text in ('','x'*2001):
            with self.assertRaises(ValueError):self.service.configure(self.account,self.group,True,text,30)
        self.source.config['autoRefresh']=False
        with self.assertRaises(ValueError):self.enable()
        self.assertEqual(self.posts,[])

    def test_http_configuration_csrf_and_rule_readback(self):
        import http.client,json
        from http.server import ThreadingHTTPServer,BaseHTTPRequestHandler
        from server import make_handler,LoginFlow
        self.engine.windows_auto_reply=self.service
        server=ThreadingHTTPServer(('127.0.0.1',0),BaseHTTPRequestHandler)
        port=server.server_port
        server.RequestHandlerClass=make_handler(self.engine,LoginFlow(self.engine),'csrf',port,database_service=self.source)
        thread=threading.Thread(target=server.serve_forever,daemon=True);thread.start()
        try:
            body={'account':self.account,'groupId':self.group,'enabled':True,'text':'Hello，斯内特','cooldown':30}
            for token,status in (('',403),('csrf',200)):
                connection=http.client.HTTPConnection('127.0.0.1',port)
                connection.request('POST','/api/reply',json.dumps(body),{'Origin':f'http://127.0.0.1:{port}',
                    'Content-Type':'application/json','X-CSRF-Token':token})
                response=connection.getresponse();self.assertEqual(response.status,status)
                data=json.loads(response.read());connection.close()
                if status==200:self.assertTrue(data['enabled'])
            self.assertEqual(self.posts,[])
        finally:server.shutdown();server.server_close();thread.join()


if __name__=='__main__':unittest.main()
