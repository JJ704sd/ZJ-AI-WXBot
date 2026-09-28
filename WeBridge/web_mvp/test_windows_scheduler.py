"""Synthetic clock, account and native transport; no real sends."""
from datetime import datetime
import threading
import unittest
import test_windows_auto_reply as fixtures
from windows_scheduler import WindowsScheduler, BEIJING, next_daily, once_at


class SchedulerTests(unittest.TestCase):
    def setUp(self):
        self.f = fixtures.AutoReplyTests()
        self.f.setUp()
        self.addCleanup(self.f.doCleanups)
        self.f.now = datetime(2026,9,28,10,0,tzinfo=BEIJING).timestamp()
        self.scheduler = self.new()

    def new(self):
        return WindowsScheduler(self.f.engine,self.f.source,lambda:self.f.sender,clock=lambda:self.f.now)

    def data(self, **changes):
        return {'account':self.f.account,'groupId':self.f.group,'text':'定时合成测试',
                'requestId':'synthetic-schedule-request-001','mode':'once','at':'2026-09-28T10:01', **changes}

    def job(self): return self.scheduler.list(self.f.account)[0]

    def test_once_only_after_due_and_never_repeat(self):
        job=self.scheduler.create(self.data());self.scheduler.tick();self.assertEqual(self.f.posts,[])
        self.f.now=job['nextRun'];self.scheduler.tick();self.scheduler.tick()
        self.assertEqual(len(self.f.posts),1)
        self.assertEqual(self.f.posts[0]['text'],'定时合成测试')
        self.assertEqual(self.job()['state'],'finished')
        self.assertIsNone(self.job()['nextRun'])

    def test_daily_beijing_next_day_and_no_backfill(self):
        job=self.scheduler.create(self.data(mode='daily',clock='10:00'))
        self.assertEqual(job['nextRun'],self.f.now+86400)
        self.f.now=job['nextRun'];self.scheduler.tick()
        self.assertEqual(len(self.f.posts),1)
        self.assertEqual(self.job()['nextRun'],self.f.now+86400)
        self.assertTrue(self.job()['enabled'])

    def test_private_recipient_supported(self):
        self.f.engine.group_list.append({'id':'filehelper','name':'文件传输助手'})
        self.f.engine.store.set_watched(self.f.account,['filehelper',self.f.group])
        job=self.scheduler.create(self.data(groupId='filehelper'))
        self.f.now=job['nextRun'];self.scheduler.tick()
        self.assertEqual(self.f.posts[0]['targetId'],'filehelper')

    def test_request_id_dedup_and_conflict(self):
        job=self.scheduler.create(self.data())
        self.assertEqual(self.scheduler.create(self.data())['id'],job['id'])
        with self.assertRaises(ValueError):self.scheduler.create(self.data(text='different'))
        self.assertEqual(len(self.scheduler.list(self.f.account)),1)

    def test_pause_resume_and_cancel(self):
        job=self.scheduler.create(self.data())
        self.scheduler.action(self.f.account,job['id'],'pause');self.scheduler.tick()
        self.assertFalse(self.job()['enabled'])
        self.scheduler.action(self.f.account,job['id'],'resume')
        self.assertTrue(self.job()['enabled'])
        self.scheduler.action(self.f.account,job['id'],'cancel')
        self.f.now=job['nextRun'];self.scheduler.tick();self.assertEqual(self.f.posts,[])
        with self.assertRaises(ValueError):self.scheduler.action(self.f.account,job['id'],'resume')

    def test_restart_pauses_pending_jobs(self):
        job=self.scheduler.create(self.data());self.scheduler=self.new()
        self.f.now=job['nextRun'];self.scheduler.tick()
        self.assertEqual(self.f.posts,[]);self.assertEqual(self.job()['state'],'paused')

    def test_late_once_is_missed_not_sent(self):
        job=self.scheduler.create(self.data());self.f.now=job['nextRun']+121;self.scheduler.tick()
        self.assertEqual(self.f.posts,[]);self.assertEqual(self.job()['state'],'missed')
        self.assertEqual(self.job()['runs'][0]['status'],'missed')

    def test_late_daily_skips_to_next_future_occurrence(self):
        job=self.scheduler.create(self.data(mode='daily',clock='10:01'))
        self.f.now=job['nextRun']+2*86400+121;self.scheduler.tick()
        self.assertEqual(self.f.posts,[]);self.assertGreater(self.job()['nextRun'],self.f.now)
        self.assertEqual(len(self.job()['runs']),1)

    def test_native_change_and_disconnect_pause_even_before_due(self):
        self.scheduler.create(self.data());self.f.native['pid']=124;self.scheduler.tick()
        self.assertFalse(self.job()['enabled']);self.assertEqual(self.f.posts,[])

    def test_unwatch_and_source_errors_block(self):
        self.scheduler.create(self.data());self.f.engine.store.set_watched(self.f.account,[])
        self.scheduler.pause_all(unwatched_account=self.f.account)
        self.assertFalse(self.job()['enabled'])
        with self.assertRaises(ValueError):self.scheduler.action(self.f.account,self.job()['id'],'resume')

    def test_unknown_once_never_retries_or_resumes(self):
        job=self.scheduler.create(self.data());self.f.now=job['nextRun'];self.f.outcome='timeout'
        self.scheduler.tick();self.scheduler.tick()
        self.assertEqual(len(self.f.posts),1);self.assertEqual(self.job()['runs'][0]['status'],'unknown')
        with self.assertRaises(ValueError):self.scheduler.action(self.f.account,job['id'],'resume')

    def test_unknown_daily_resume_schedules_only_next_day(self):
        job=self.scheduler.create(self.data(mode='daily',clock='10:01'));self.f.now=job['nextRun'];self.f.outcome='timeout'
        self.scheduler.tick();self.scheduler.action(self.f.account,job['id'],'resume');self.scheduler.tick()
        self.assertEqual(len(self.f.posts),1);self.assertEqual(self.job()['nextRun'],self.f.now+86400)

    def test_concurrent_ticks_claim_once(self):
        job=self.scheduler.create(self.data());self.f.now=job['nextRun']
        threads=[threading.Thread(target=self.scheduler.tick) for _ in range(2)]
        for thread in threads:thread.start()
        for thread in threads:thread.join()
        self.assertEqual(len(self.f.posts),1)

    def test_busy_snapshot_waits(self):
        job=self.scheduler.create(self.data());self.f.now=job['nextRun'];self.f.source.busy=True
        self.scheduler.tick();self.assertEqual(self.f.posts,[])
        self.f.source.busy=False;self.scheduler.tick();self.assertEqual(len(self.f.posts),1)

    def test_invalid_time_text_identity_and_mentions(self):
        for changes in ({'at':'2026-02-30T10:00'},{'at':'2026-09-28T09:00'},{'mode':'weekly'},
                        {'text':''},{'account':'wrong'},{'groupId':'wrong'},{'mentionIds':['other']},
                        {'mode':'daily','clock':'25:61'}):
            with self.subTest(changes=changes),self.assertRaises(ValueError):self.scheduler.create(self.data(**changes))
        self.assertEqual(self.f.posts,[])

    def test_no_cross_account_management(self):
        job=self.scheduler.create(self.data())
        with self.assertRaises(ValueError):self.scheduler.action('wrong',job['id'],'cancel')
        self.assertEqual(self.scheduler.list('wrong'),[])

    def test_time_zone_does_not_depend_on_windows_timezone(self):
        self.assertEqual(once_at('2026-09-28T10:01',self.f.now),self.f.now+60)
        self.assertEqual(datetime.fromtimestamp(next_daily('00:00',self.f.now),BEIJING).isoformat(),'2026-09-29T00:00:00+08:00')

    def test_http_csrf_create_pause_resume_cancel(self):
        import http.client,json
        from http.server import ThreadingHTTPServer,BaseHTTPRequestHandler
        from server import make_handler,LoginFlow
        self.f.engine.windows_scheduler=self.scheduler
        server=ThreadingHTTPServer(('127.0.0.1',0),BaseHTTPRequestHandler);port=server.server_port
        server.RequestHandlerClass=make_handler(self.f.engine,LoginFlow(self.f.engine),'csrf',port,database_service=self.f.source)
        thread=threading.Thread(target=server.serve_forever,daemon=True);thread.start()
        def request(path,body,token='csrf'):
            conn=http.client.HTTPConnection('127.0.0.1',port)
            try:
                conn.request('POST',path,json.dumps(body),{'Origin':f'http://127.0.0.1:{port}','Content-Type':'application/json','X-CSRF-Token':token})
                response=conn.getresponse();return response.status,json.loads(response.read())
            finally:conn.close()
        try:
            self.assertEqual(request('/api/jobs',self.data(),'')[0],403)
            status,job=request('/api/jobs',self.data());self.assertEqual(status,201)
            for action,expected in [('pause','paused'),('resume','active'),('cancel','cancelled')]:
                status,result=request('/api/jobs/'+action,{'account':self.f.account,'id':job['id']})
                self.assertEqual((status,result['state']),(200,expected))
            self.assertEqual(self.f.posts,[])
        finally:server.shutdown();server.server_close();thread.join()


if __name__=='__main__':unittest.main()
