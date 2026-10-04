"""Independent batch acceptance using real synthetic snapshots and SQLite only."""
from contextlib import closing
from datetime import datetime
import json
import sqlite3
import tempfile
import threading
import unittest
from unittest.mock import patch

from test_database_adapter import GROUP, MIXED, ENTERPRISE, STAMP
from test_windows_inbound import InboundFixture
from windows_scheduler import BEIJING, WindowsScheduler


class BatchFixture:
    """Composition fixture; construction and cleanup never touch a real source."""
    def __init__(self, count=3, *, inbound=None, scheduler=None, profiles=True):
        self.directory = None if inbound is not None else tempfile.TemporaryDirectory(prefix='webridge-batch-acceptance-')
        self.f = inbound if inbound is not None else InboundFixture(self.directory.name)
        self.f.now = datetime(2026,10,3,10,0,tzinfo=BEIJING).timestamp()
        self.scheduler = scheduler if scheduler is not None else WindowsScheduler(
            self.f.engine,self.f.source,lambda:self.f.sender,clock=lambda:self.f.now)
        self.f.engine.windows_scheduler = self.scheduler
        self.groups = [GROUP,MIXED,ENTERPRISE]
        for index in range(3,count):
            suffix = ('@chatroom','@im.chatroom','')[index%3]
            self.groups.append('synthetic-batch-'+str(index)+'-'+'x'*110+suffix)
        self.groups = self.groups[:count]
        root = self.f.write_snapshot('batch-'+str(count),{'message/message_0.db':[]})
        with closing(sqlite3.connect(root/'contact/contact.db')) as db,db:
            for group in self.groups:
                changed = db.execute('UPDATE contact SET remark=? WHERE CAST(username AS TEXT)=?',('同名合成会话',group)).rowcount
                if not changed: db.execute('INSERT INTO contact VALUES (?,?,?,?,?)',(group,'同名合成会话','','',0))
        with closing(sqlite3.connect(root/'session/session.db')) as db,db:
            db.execute('DELETE FROM SessionTable')
            db.executemany('INSERT INTO SessionTable VALUES (?,?)',((group,STAMP) for group in self.groups))
        self.f.activate_snapshot(root)
        self.f.engine.set_watched(self.f.account,self.groups)
        self.template_id = 'synthetic-batch-template-001'
        text = '{{客户}}，请发送{{品类}}价格表。' if profiles else '统一固定通知。'
        self.template = self.scheduler.templates.save(self.f.account,self.template_id,0,'统一询价',text)
        self.expected = {}
        for index,group in enumerate(self.groups):
            values = {'客户':'客户'+str(index),'品类':'品类'+str(index)}
            override = '完整覆盖'+str(index)+'：请核对采购价格。' if index%11==0 else None
            self.expected[group] = override if override is not None else values['客户']+'，请发送'+values['品类']+'价格表。'
            if profiles:
                self.template = self.scheduler.templates.profile(self.f.account,self.template_id,self.template['version'],group,values,override)
            else:self.expected[group] = text
        self.calls = []
        original = self.f.sender.transport
        def transport(method,path,payload=None):
            self.calls.append((method,path))
            if method=='POST':
                self.f.posts.append(payload)
                raise AssertionError('Batch preview and creation must never submit native messages')
            return original(method,path,payload)
        self.f.sender.transport = transport

    def close(self):
        if self.directory is not None:self.directory.cleanup()

    def payload(self, **changes):
        return {'account':self.f.account,'templateId':self.template_id,'templateVersion':self.template['version'],
                'groupIds':list(self.groups),'mode':'daily','clock':'10:01','windowMinutes':15,**changes}

    def submission(self, payload=None, **changes):
        payload = self.payload() if payload is None else payload
        preview = self.scheduler.batches.preview(payload)
        return {**payload,'requestId':'synthetic-batch-request-001','previewDigest':preview['previewDigest'],**changes}

    def counts(self):
        with closing(self.scheduler._db()) as db:
            return tuple(db.execute('SELECT count(*) FROM '+table).fetchone()[0] for table in ('schedules','schedule_batches','runs'))


class ScheduleBatchAcceptanceTests(unittest.TestCase):
    def fixture(self, count=3, **options):
        fixture = BatchFixture(count,**options)
        self.addCleanup(fixture.close)
        self.addCleanup(lambda:self.assertEqual(fixture.f.posts,[],'No native POST is authorized by these tests'))
        return fixture

    def test_three_hundred_real_snapshot_targets_keep_unique_frozen_content(self):
        f = self.fixture(300)
        payload = f.payload()
        self.assertGreater(len(json.dumps(payload).encode('utf-8')),32768)
        preview = f.scheduler.batches.preview(payload)
        self.assertTrue(preview['canCreate']);self.assertEqual(preview['readyCount'],300)
        self.assertEqual(preview['invalidCount'],0);self.assertEqual(len(preview['records']),300)
        self.assertEqual({row['groupId']:row['text'] for row in preview['records']},f.expected)
        self.assertEqual({row['targetName'] for row in preview['records']},{'同名合成会话'})
        self.assertEqual({row['contentSource'] for row in preview['records']},{'template','override'})
        self.assertEqual(f.calls,[]);self.assertEqual(f.counts(),(0,0,0))
        with closing(f.f.sender._connect()) as db:self.assertEqual(db.execute('SELECT count(*) FROM hook_drafts').fetchone()[0],0)
        result = f.scheduler.batches.create({**payload,'requestId':'synthetic-300-batch-request','previewDigest':preview['previewDigest']})
        self.assertEqual((result['createdCount'],result['reused']),(300,False))
        self.assertEqual({job['group_id']:job['text'] for job in result['jobs']},f.expected)
        self.assertEqual(len({job['id'] for job in result['jobs']}),300)
        self.assertTrue(all(job['nextRun']==preview['nextRun'] and job['windowMinutes']==15 for job in result['jobs']))
        self.assertEqual(f.counts(),(300,1,0))
        self.assertEqual(f.calls,[('GET','/v1/status')])
        f.scheduler.templates.delete(f.f.account,f.template_id,f.template['version'])
        self.assertEqual({job['group_id']:job['text'] for job in f.scheduler.list(f.f.account)},f.expected)

    def test_capacity_counts_archived_records_and_never_creates_a_partial_batch(self):
        f = self.fixture()
        seed = f.scheduler.create({'account':f.f.account,'groupId':GROUP,'requestId':'synthetic-capacity-seed',
                                  'text':'existing unrelated record','mode':'daily','clock':'09:00'})
        with closing(f.scheduler._db()) as db,db:
            job = json.loads(db.execute('SELECT payload FROM schedules WHERE id=?',(seed['id'],)).fetchone()[0])
            db.execute('DELETE FROM schedules')
            for index in range(498):
                row = {**job,'id':'archived-'+str(index),'enabled':False,'state':'cancelled' if index%2 else 'finished'}
                db.execute('INSERT INTO schedules VALUES (?,?,?)',(row['id'],f.f.account,json.dumps(row)))
        preview = f.scheduler.batches.preview(f.payload())
        self.assertEqual((preview['existingCount'],preview['capacity']),(498,500))
        self.assertFalse(preview['canCreate']);self.assertTrue(preview['issues'])
        with self.assertRaises(ValueError):f.scheduler.batches.create(f.submission())
        self.assertEqual(f.counts(),(498,0,0))
        with closing(f.scheduler._db()) as db,db:db.execute("DELETE FROM schedules WHERE id='archived-497'")
        result = f.scheduler.batches.create(f.submission())
        self.assertEqual(result['createdCount'],3);self.assertEqual(f.counts(),(500,1,0))

    def test_third_insert_failure_rolls_back_jobs_and_receipt_and_request_can_retry(self):
        f = self.fixture()
        request = f.submission()
        with closing(f.scheduler._db()) as db,db:
            db.execute("""CREATE TRIGGER fail_third_schedule BEFORE INSERT ON schedules
                WHEN (SELECT count(*) FROM schedules)>=2
                BEGIN SELECT RAISE(ABORT,'synthetic third schedule failure'); END""")
        with self.assertRaisesRegex(sqlite3.IntegrityError,'third schedule'):
            f.scheduler.batches.create(request)
        self.assertEqual(f.counts(),(0,0,0))
        with closing(f.scheduler._db()) as db,db:db.execute('DROP TRIGGER fail_third_schedule')
        result = f.scheduler.batches.create(request)
        self.assertEqual((result['createdCount'],result['reused']),(3,False))
        self.assertEqual(f.counts(),(3,1,0))

    def test_concurrent_same_request_is_one_batch_and_hook_probe_releases_source_locks(self):
        f = self.fixture()
        request = f.submission()
        original = f.f.sender.transport
        probes = threading.Barrier(2)
        lock_checks,results,errors = [],[],[]
        def transport(method,path,payload=None):
            def take_locks():
                with f.f.source.lock,f.f.engine.sync_lock,f.f.engine.lock:lock_checks.append(True)
            checker = threading.Thread(target=take_locks,daemon=True)
            checker.start();checker.join(3)
            if checker.is_alive():raise AssertionError('Hook GET held source/subscription/engine locks')
            probes.wait(5)
            return original(method,path,payload)
        f.f.sender.transport = transport
        def create():
            try:results.append(f.scheduler.batches.create(request))
            except Exception as error:errors.append(error)
        workers = [threading.Thread(target=create) for _ in range(2)]
        for worker in workers:worker.start()
        for worker in workers:worker.join(10);self.assertFalse(worker.is_alive())
        self.assertEqual(errors,[]);self.assertEqual(len(lock_checks),2)
        self.assertEqual(len(results),2);self.assertEqual({row['reused'] for row in results},{False,True})
        self.assertEqual(results[0]['batchId'],results[1]['batchId'])
        self.assertEqual({job['id'] for job in results[0]['jobs']},{job['id'] for job in results[1]['jobs']})
        self.assertEqual(f.counts(),(3,1,0))

    def test_probe_time_template_scope_and_source_changes_reject_the_entire_batch(self):
        for mutation in ('template','scope','source'):
            with self.subTest(mutation=mutation):
                f = self.fixture()
                request = f.submission()
                original = f.f.sender.transport
                def transport(method,path,payload=None):
                    response = original(method,path,payload)
                    if mutation=='template':
                        f.scheduler.templates.save(f.f.account,f.template_id,f.template['version'],'新模板','已变化的完整文本')
                    elif mutation=='scope':f.f.engine.set_watched(f.f.account,[GROUP])
                    else:f.f.source.config={**f.f.source.config,'sourceRoot':str(f.f.root/'another-source')}
                    return response
                f.f.sender.transport = transport
                with self.assertRaises(ValueError):f.scheduler.batches.create(request)
                self.assertEqual(f.counts(),(0,0,0))

    def test_shared_weekly_midnight_window_and_expired_first_due_never_roll_forward(self):
        f = self.fixture()
        weekly = f.payload(mode='weekly',clock='23:59',weekdays=[5],windowMinutes=5)
        preview = f.scheduler.batches.preview(weekly)
        self.assertEqual(preview['nextRun'],datetime(2026,10,9,23,59,tzinfo=BEIJING).timestamp())
        self.assertEqual(preview['deadline'],datetime(2026,10,10,0,4,tzinfo=BEIJING).timestamp())
        request = f.submission()
        f.f.now+=60
        with self.assertRaises(ValueError):f.scheduler.batches.create(request)
        self.assertEqual(f.counts(),(0,0,0))
        fresh = f.scheduler.batches.preview(f.payload())
        self.assertEqual(fresh['nextRun'],datetime(2026,10,4,10,1,tzinfo=BEIJING).timestamp())
        self.assertNotEqual(fresh['previewDigest'],request['previewDigest'])

    def test_saved_old_variables_are_filtered_but_empty_override_is_not_a_fallback(self):
        f = self.fixture()
        f.template = f.scheduler.templates.save(f.f.account,f.template_id,f.template['version'],'精简模板','{{客户}}，请确认。')
        preview = f.scheduler.batches.preview(f.payload())
        self.assertTrue(preview['canCreate'])
        self.assertEqual(next(row['text'] for row in preview['records'] if row['groupId']==MIXED),'客户1，请确认。')
        f.template = f.scheduler.templates.profile(f.f.account,f.template_id,f.template['version'],MIXED,{},'')
        preview = f.scheduler.batches.preview(f.payload())
        self.assertFalse(preview['canCreate']);self.assertEqual(preview['invalidCount'],1)
        bad = next(row for row in preview['records'] if row['groupId']==MIXED)
        self.assertEqual(bad['contentSource'],'override');self.assertEqual(bad['text'],'');self.assertTrue(bad['error'])
        with self.assertRaises(ValueError):f.scheduler.batches.create(f.submission())
        self.assertEqual(f.counts(),(0,0,0))


if __name__=='__main__':unittest.main()
