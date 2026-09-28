"""Synthetic metadata and recording native transport; never contacts WeChat."""
from copy import deepcopy
from pathlib import Path
from types import SimpleNamespace
import tempfile
import threading
import unittest

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
        return {'id':str(id),'serverId':str(id),'senderId':'other','timestamp':self.now,
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
