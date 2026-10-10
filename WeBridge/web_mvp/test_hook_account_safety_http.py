"""Actual local HTTP handlers and SQLite with an invented native boundary."""
import unittest
import test_windows_hook_http as http_fixtures
import test_windows_hook_sender as native_fixtures
from server import make_handler, LoginFlow
from windows_hook_sender import WindowsHookSender


class AccountSafetyHttpTests(unittest.TestCase):
    def setUp(self):
        self.h=http_fixtures.HookHttpTests();self.h.setUp();self.addCleanup(self.h.tearDown)
        self.f=native_fixtures.HookTests();self.f.setUp();self.addCleanup(self.f.doCleanups)
        self.f.source={'account':self.h.account,'sourceId':self.h.account,'selfId':self.h.engine.self_id,
                       'sourceRoot':self.h.database.config['sourceRoot']}
        self.f.native.update(selfId=self.f.source['selfId'],sourceRoot=self.f.source['sourceRoot'])
        self.f.scope={'targetPolicy':'selected_conversation'}
        self.sender=WindowsHookSender(self.h.root/'runtime',transport=self.f.transport,
                                      profiles=[self.f.profile],clock=lambda:self.f.now)
        self.h.server.RequestHandlerClass=make_handler(self.h.engine,LoginFlow(self.h.engine),'csrf',self.h.port,
                                            database_service=self.h.database,hook_sender=self.sender)
        self.path='/api/windows/hook/safety'

    def action(self,action,version,**extra):
        return self.h.request('POST',self.path,{'account':self.h.account,'action':action,'version':version,**extra})

    def test_limits_and_pause_are_scoped_csrf_protected_and_compare_and_swap(self):
        code,state=self.h.request('GET',self.path);self.assertEqual(code,200)
        self.assertEqual(self.h.request('GET',self.path+'?account=stale-tab')[0],400)
        self.assertEqual(self.h.request('POST',self.path,{'account':self.h.account,'action':'pause','version':0},
                         **{'X-CSRF-Token':''})[0],403)
        limits={**state['limits'],'perMinute':3}
        self.assertEqual(self.action('configure',0,limits=limits)[0],400)
        self.assertEqual(self.action('configure',0,limits=limits,confirmed=True)[0],200)
        self.assertEqual(self.action('pause',0)[0],400)
        code,paused=self.action('pause',1);self.assertEqual(code,200);self.assertTrue(paused['paused'])
        self.assertFalse(self.h.request('GET','/api/windows/hook/status')[1]['available'])
        self.assertEqual(self.action('resume',paused['version'],acknowledged=False)[0],400)
        self.assertEqual(self.action('resume',paused['version'],acknowledged=True)[0],200)
        self.assertFalse(any(call[0]=='POST' for call in self.f.calls))

    def test_browser_identity_cannot_select_another_accounts_policy(self):
        body={'account':self.h.account,'action':'pause','version':0,'selfId':'wrong-browser-identity',
              'sourceId':'wrong-source','sourceRoot':'Z:/wrong'}
        self.assertEqual(self.h.request('POST',self.path,body)[0],200)
        self.assertTrue(self.sender.safety(self.f.source)['paused'])
        self.assertFalse(self.sender.safety({**self.f.source,'selfId':'different-current-identity'})['paused'])
        self.assertEqual(self.h.request('POST',self.path,{**body,'account':'wrong-account'})[0],400)

    def test_resume_requires_matching_current_native_account_even_after_reconnect(self):
        _,paused=self.action('pause',0)
        self.f.native['selfId']='wrong-current-native-account'
        self.assertEqual(self.action('resume',paused['version'],acknowledged=True)[0],400)
        self.assertTrue(self.h.request('GET',self.path)[1]['paused'])
        self.assertFalse(any(call[0]=='POST' for call in self.f.calls))

    def test_invalid_limits_cannot_disable_protection_or_unpause(self):
        _,paused=self.action('pause',0)
        for value in (0,True,10000):
            limits={**paused['limits'],'minimumIntervalSeconds':value}
            self.assertEqual(self.action('configure',paused['version'],limits=limits,confirmed=True)[0],400)
        self.assertTrue(self.h.request('GET',self.path)[1]['paused'])

    def test_resume_disables_old_rule_and_schedule_before_any_worker_observes_pause(self):
        from windows_auto_reply import WindowsAutoReply
        from windows_scheduler import WindowsScheduler
        service=WindowsAutoReply(self.h.engine,self.h.database,lambda:self.sender,clock=lambda:self.f.now)
        scheduler=WindowsScheduler(self.h.engine,self.h.database,lambda:self.sender,clock=lambda:self.f.now)
        self.h.engine.windows_auto_reply=service;self.h.engine.windows_scheduler=scheduler
        service.configure(self.h.account,self.h.target,True,'合成批准正文',30)
        scheduler.create({'account':self.h.account,'groupId':self.h.target,'text':'合成计划正文',
            'requestId':'synthetic-http-resume-rule','mode':'daily','clock':'10:01'})
        self.f.outcome=TimeoutError()
        draft=self.sender.prepare({**self.f.source,'targetId':self.h.target,'targetName':'当前会话',
            'text':'合成未知正文','idempotencyKey':'synthetic-http-unknown'})
        self.sender.confirm({**self.f.source,**draft,'targetConfirmed':True})
        self.assertTrue(service.get(self.h.account,self.h.target)['enabled'])
        self.assertTrue(scheduler.list(self.h.account)[0]['enabled'])
        _,paused=self.h.request('GET',self.path)
        self.assertEqual(self.action('resume',paused['version']-1,acknowledged=True)[0],400)
        self.assertTrue(service.get(self.h.account,self.h.target)['enabled'])
        self.assertTrue(scheduler.list(self.h.account)[0]['enabled'])
        self.assertEqual(self.action('resume',paused['version'],acknowledged=True)[0],200)
        self.assertFalse(service.get(self.h.account,self.h.target)['enabled'])
        self.assertFalse(scheduler.list(self.h.account)[0]['enabled'])
        self.assertEqual(sum(call[0]=='POST' for call in self.f.calls),1)


if __name__=='__main__':unittest.main()
