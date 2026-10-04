"""HTTP contracts for atomic batches over a real synthetic snapshot service."""
import json
import unittest
from unittest.mock import patch

import test_weekly_scheduler_http as http_fixtures
from test_schedule_batch_acceptance import BatchFixture
from test_database_adapter import GROUP, MIXED, ENTERPRISE


class ScheduleBatchHttpTests(unittest.TestCase):
    def setUp(self):
        self.http = http_fixtures.WeeklyScheduleHttpTests()
        self.http.setUp()
        self.addCleanup(self.http.doCleanups)
        self.batch = BatchFixture(inbound=self.http.f,scheduler=self.http.scheduler)
        self.f,self.scheduler = self.batch.f,self.batch.scheduler
        self.addCleanup(lambda:self.assertEqual(self.f.posts,[],'HTTP batch operations must not send messages'))

    def preview(self, payload=None, **headers):
        return self.http.request('POST','/api/jobs/batch/preview',self.batch.payload() if payload is None else payload,**headers)

    def create(self, payload, **headers):
        return self.http.request('POST','/api/jobs/batch',payload,**headers)

    def test_preview_is_read_only_without_hook_and_batch_limits_do_not_relax_single_jobs(self):
        self.f.ready=False
        with patch.object(self.scheduler,'sender_factory',side_effect=AssertionError('Preview must not contact Hook')):
            code,preview=self.preview()
            self.assertEqual(code,200);self.assertTrue(preview['canCreate'])
            self.assertEqual({row['groupId']:row['text'] for row in preview['records']},self.batch.expected)
            self.assertNotIn('sourceRoot',json.dumps(preview));self.assertNotIn(str(self.f.root),json.dumps(preview))
            payload={**self.batch.payload(),'padding':'x'*33000}
            self.assertGreater(len(json.dumps(payload).encode('utf-8')),32768)
            self.assertEqual(self.preview(payload)[0],200)
            large={**self.batch.payload(),'padding':'x'*(256*1024)}
            self.assertEqual(self.preview(large)[0],400)
            self.assertEqual(self.create(large)[0],400)
            old=self.http.data(padding='x'*33000)
            self.assertEqual(self.http.request('POST','/api/jobs',old)[0],400)
            template={'account':self.f.account,'id':self.batch.template_id,'version':self.batch.template['version'],
                      'name':'统一询价','text':'{{客户}}，请发送{{品类}}价格表。','padding':'x'*33000}
            self.assertEqual(self.http.request('POST','/api/schedule-templates/save',template)[0],200)
        self.assertEqual(self.batch.counts(),(0,0,0));self.assertEqual(self.batch.calls,[])
        state=self.http.request('GET','/api/state')[1]
        self.assertIs(state['runtime']['capabilities']['scheduleBatches'],True)
        self.f.engine.windows_scheduler=None
        self.assertIs(self.http.request('GET','/api/state')[1]['runtime']['capabilities']['scheduleBatches'],False)
        self.assertEqual(self.preview()[0],400)

    def test_http_permissions_and_input_rejection_precede_native_probe(self):
        payload=self.batch.submission()
        with patch.object(self.scheduler,'sender_factory',side_effect=AssertionError('Invalid requests must not contact Hook')):
            for headers in ({'Origin':'https://untrusted.invalid'},{'Host':'untrusted.invalid'},
                            {'X-CSRF-Token':''},{'Sec-Fetch-Site':'cross-site'}):
                with self.subTest(headers=headers):
                    self.assertEqual(self.preview(**headers)[0],403)
                    self.assertEqual(self.create(payload,**headers)[0],403)
            for change in ({'account':'other-account'},{'groupIds':[]},{'groupIds':[GROUP,GROUP]},
                           {'groupIds':['missing']*301},{'templateVersion':True},
                           {'windowMinutes':1440},{'windowMinutes':True},{'mode':'weekly','weekdays':[]}):
                with self.subTest(change=change):
                    self.assertEqual(self.preview({**self.batch.payload(),**change})[0],400)
            self.assertEqual(self.create({**payload,'requestId':''})[0],400)
            self.assertEqual(self.create({**payload,'previewDigest':''})[0],400)
        self.assertEqual(self.batch.counts(),(0,0,0))

    def test_invalid_groups_report_all_items_and_never_create_only_the_valid_subset(self):
        self.batch.template=self.scheduler.templates.profile(self.f.account,self.batch.template_id,
            self.batch.template['version'],MIXED,{'客户':''},None)
        self.f.engine.set_watched(self.f.account,[GROUP,MIXED])
        payload=self.batch.payload()
        code,preview=self.preview(payload)
        self.assertEqual(code,200);self.assertFalse(preview['canCreate'])
        self.assertEqual((preview['readyCount'],preview['invalidCount']),(1,2))
        rows={row['groupId']:row for row in preview['records']}
        self.assertEqual(rows[GROUP]['error'],'');self.assertEqual(rows[GROUP]['text'],self.batch.expected[GROUP])
        self.assertEqual(set(rows[MIXED]['missing']),{'客户','品类'})
        self.assertTrue(rows[ENTERPRISE]['error'])
        self.assertEqual(preview['previewDigest'],'')
        code,_=self.create({**payload,'requestId':'synthetic-invalid-batch','previewDigest':'a'*64})
        self.assertIn(code,(400,409));self.assertEqual(self.batch.counts(),(0,0,0))

    def test_template_scope_source_and_first_due_changes_require_a_fresh_preview(self):
        request=self.batch.submission()
        self.batch.template=self.scheduler.templates.save(self.f.account,self.batch.template_id,
            self.batch.template['version'],'新版模板','{{客户}}：新版 {{品类}}')
        self.assertEqual(self.create(request)[0],409)
        request=self.batch.submission()
        self.f.engine.set_watched(self.f.account,[GROUP])
        self.assertIn(self.create(request)[0],(400,409))
        self.f.engine.set_watched(self.f.account,self.batch.groups)
        request=self.batch.submission()
        original_root=self.f.source.config['sourceRoot']
        self.f.source.config={**self.f.source.config,'sourceRoot':str(self.f.root/'another-source')}
        self.f.native['sourceRoot']=self.f.source.config['sourceRoot']
        self.assertEqual(self.create(request)[0],409)
        self.f.source.config={**self.f.source.config,'sourceRoot':original_root};self.f.native['sourceRoot']=original_root
        request=self.batch.submission()
        self.f.now+=60
        code,error=self.create(request)
        self.assertEqual(code,409);self.assertEqual(error['code'],'batch_conflict')
        self.assertEqual(self.batch.counts(),(0,0,0))

    def test_success_receipt_survives_template_deletion_deadline_and_restart_without_restoring_jobs(self):
        payload=self.batch.payload(mode='once',at='2026-10-03T10:01')
        request=self.batch.submission(payload)
        code,result=self.create({**request,'text':'untrusted body','sourceRoot':'Z:/untrusted','deadline':10**20})
        self.assertEqual(code,201);self.assertEqual((result['createdCount'],result['reused']),(3,False))
        self.assertEqual({row['group_id']:row['text'] for row in result['jobs']},self.batch.expected)
        jobs=result['jobs']
        self.assertEqual(self.http.request('POST','/api/jobs/pause',{'account':self.f.account,'id':jobs[0]['id']})[0],200)
        self.assertEqual(self.http.request('POST','/api/jobs/cancel',{'account':self.f.account,'id':jobs[1]['id']})[0],200)
        self.scheduler.templates.delete(self.f.account,self.batch.template_id,self.batch.template['version'])
        self.f.now+=900;self.f.ready=False
        self.scheduler=self.http.new_scheduler()
        self.f.engine.windows_scheduler=self.scheduler;self.batch.scheduler=self.scheduler
        with patch.object(self.scheduler,'sender_factory',side_effect=AssertionError('Successful receipt must be checked before Hook')):
            code,replayed=self.create(request)
            self.assertEqual(code,201);self.assertTrue(replayed['reused'])
            self.assertEqual((replayed['batchId'],replayed['createdCount']),(result['batchId'],3))
            self.assertEqual({row['id'] for row in replayed['jobs']},{row['id'] for row in jobs})
            states={row['id']:(row['state'],row['enabled']) for row in replayed['jobs']}
            self.assertEqual(states[jobs[0]['id']],('paused',False))
            self.assertEqual(states[jobs[1]['id']],('cancelled',False))
            self.assertTrue(all(not row['enabled'] for row in replayed['jobs']))
            self.assertEqual(self.create({**request,'windowMinutes':30})[0],409)
        self.assertEqual(self.batch.counts(),(3,1,0))


if __name__=='__main__':unittest.main()
