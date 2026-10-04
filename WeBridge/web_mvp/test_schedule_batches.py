"""Batch scheduling over temporary SQLite with an invented native boundary."""
from contextlib import closing
import json
import sqlite3
import unittest
from unittest.mock import patch

import test_windows_scheduler as fixtures
from schedule_batches import BatchConflict
from schedule_templates import TemplateConflict


class ScheduleBatchTests(unittest.TestCase):
    def setUp(self):
        self.s = fixtures.SchedulerTests()
        self.addCleanup(self.s.doCleanups)
        self.s.setUp()
        self.f, self.scheduler = self.s.f, self.s.scheduler
        self.groups = [self.f.group, 'synthetic-second@chatroom']
        self.f.engine.group_list.append({'id':self.groups[1], 'name':'合成群'})
        self.f.engine.store.set_watched(self.f.account, self.groups)
        self.template = 'synthetic-batch-template'
        templates = self.scheduler.templates
        templates.save(self.f.account, self.template, 0, '业务通知', '您好 {{客户}}')
        for version,group in enumerate(self.groups, 1):
            templates.profile(self.f.account, self.template, version, group, {'客户':str(version)}, None)

    def data(self, **changes):
        return {'account':self.f.account, 'templateId':self.template, 'templateVersion':3,
            'groupIds':self.groups, 'mode':'daily', 'clock':'10:01', **changes}

    def request(self, **changes):
        data = self.data(**changes)
        preview = self.scheduler.batches.preview(data)
        return {**data, 'requestId':'synthetic-batch-request', 'previewDigest':preview['previewDigest']}

    def test_preview_renders_saved_profiles_without_sender_or_writes(self):
        with patch.object(self.scheduler, 'sender_factory', side_effect=AssertionError('Preview must not use Hook')):
            result = self.scheduler.batches.preview(self.data())
        self.assertTrue(result['canCreate'])
        self.assertEqual((result['readyCount'],result['invalidCount']), (2,0))
        self.assertEqual([row['text'] for row in result['records']], ['您好 1','您好 2'])
        self.assertEqual([row['contentSource'] for row in result['records']], ['template','template'])
        self.assertEqual(result['nextRun'], self.f.now+60)
        self.assertEqual(result['deadline'], self.f.now+180)
        self.assertEqual(result['existingCount'], 0)
        self.assertEqual(result['capacity'], 500)
        self.assertTrue(result['previewDigest'])
        self.assertEqual(self.scheduler.list(self.f.account), [])
        self.assertEqual(self.f.posts, [])

    def test_create_freezes_all_jobs_with_one_probe_and_no_submission(self):
        preview = self.scheduler.batches.preview(self.data(windowMinutes=5))
        calls, transport = [], self.f.sender.transport
        def record(method, path, payload=None):
            calls.append(method)
            return transport(method, path, payload)
        with patch.object(self.f.sender, 'transport', side_effect=record):
            result = self.scheduler.batches.create(self.data(windowMinutes=5,
                requestId='synthetic-batch-request', previewDigest=preview['previewDigest']))
        self.assertEqual(calls, ['GET'])
        self.assertEqual(result['createdCount'], 2)
        self.assertFalse(result['reused'])
        self.assertEqual([job['text'] for job in result['jobs']], ['您好 1','您好 2'])
        self.assertTrue(all(job['enabled'] and job['state']=='active' for job in result['jobs']))
        self.assertTrue(all(job['batchId']==result['batchId'] for job in result['jobs']))
        self.assertTrue(all(job['nextRun']==preview['nextRun'] and job['windowMinutes']==5 for job in result['jobs']))
        self.assertEqual(len(self.scheduler.list(self.f.account)), 2)
        self.assertEqual(self.f.posts, [])

    def test_successful_retry_survives_restart_deleted_template_and_past_due_without_reenabling(self):
        request = self.request(mode='once', at='2026-09-28T10:01')
        first = self.scheduler.batches.create(request)
        self.scheduler.action(self.f.account, first['jobs'][0]['id'], 'cancel')
        self.scheduler.templates.delete(self.f.account,self.template,3)
        self.scheduler = self.s.new()
        self.f.now += 86400
        self.f.source.busy, self.f.ready = True, False
        self.f.engine.store.set_watched(self.f.account, [])
        with patch.object(self.scheduler, 'sender_factory', side_effect=AssertionError('Retry must not use Hook')):
            retry = self.scheduler.batches.create({**request, 'groupIds':list(reversed(self.groups)), 'windowMinutes':2})
        self.assertEqual(retry['batchId'], first['batchId'])
        self.assertTrue(retry['reused'])
        self.assertEqual(retry['createdCount'], 2)
        self.assertEqual([job['state'] for job in retry['jobs']], ['cancelled','paused'])
        self.assertTrue(all(not job['enabled'] for job in retry['jobs']))
        self.assertEqual(len(self.scheduler.list(self.f.account)), 2)
        self.assertEqual(self.f.posts, [])

    def test_key_reuse_with_changed_request_is_conflict_before_hook(self):
        request = self.request()
        self.scheduler.batches.create(request)
        with patch.object(self.scheduler, 'sender_factory', side_effect=AssertionError('Conflict must not use Hook')):
            for changes in ({'clock':'11:00'}, {'previewDigest':'a'*64}, {'groupIds':self.groups[:1]}, {'windowMinutes':5}):
                with self.subTest(changes=changes), self.assertRaises(BatchConflict):
                    self.scheduler.batches.create({**request, **changes})
        self.assertEqual(len(self.scheduler.list(self.f.account)), 2)

    def test_missing_variables_empty_override_and_literal_override_are_distinct(self):
        templates = self.scheduler.templates
        templates.profile(self.f.account,self.template,3,self.groups[0],{},None)
        templates.profile(self.f.account,self.template,4,self.groups[1],{},'')
        preview = self.scheduler.batches.preview(self.data(templateVersion=5))
        self.assertEqual((preview['readyCount'],preview['invalidCount']), (0,2))
        self.assertEqual(preview['records'][0]['missing'], ['客户'])
        self.assertEqual(preview['records'][1]['missing'], [])
        self.assertEqual(preview['records'][1]['contentSource'], 'override')
        self.assertTrue(all(row['error'] for row in preview['records']))
        self.assertFalse(preview['canCreate'])
        self.assertEqual(preview['previewDigest'], '')
        with self.assertRaises(BatchConflict):
            self.scheduler.batches.create(self.data(templateVersion=5,
                requestId='synthetic-invalid-batch', previewDigest='a'*64))
        self.assertEqual(self.scheduler.list(self.f.account), [])
        templates.profile(self.f.account,self.template,5,self.groups[1],{},'字面 {{客户}}')
        literal = self.scheduler.batches.preview(self.data(templateVersion=6,groupIds=self.groups[1:]))
        self.assertTrue(literal['canCreate'])
        self.assertEqual(literal['records'][0]['text'], '字面 {{客户}}')

    def test_removed_variables_are_filtered_without_erasing_saved_values(self):
        self.scheduler.templates.save(self.f.account,self.template,3,'不含变量','统一正文')
        preview = self.scheduler.batches.preview(self.data(templateVersion=4))
        self.assertTrue(preview['canCreate'])
        self.assertEqual([row['text'] for row in preview['records']], ['统一正文','统一正文'])
        with closing(self.scheduler.templates._db()) as db:
            payload = json.loads(db.execute('SELECT payload FROM templates').fetchone()[0])
        self.assertEqual(payload['profiles'][self.groups[0]]['values'], {'客户':'1'})

    def test_template_change_requires_new_preview_without_creating_tasks(self):
        request = self.request()
        self.scheduler.templates.profile(self.f.account,self.template,3,self.groups[0],{'客户':'改后值'},None)
        with patch.object(self.scheduler, 'sender_factory', side_effect=AssertionError('Stale template must not use Hook')):
            with self.assertRaises(TemplateConflict): self.scheduler.batches.create(request)
        self.assertEqual(self.scheduler.list(self.f.account), [])

    def test_active_or_paused_identical_plan_blocks_but_other_plan_only_informs(self):
        old = self.scheduler.create(self.s.data(text='您好 1',mode='daily',clock='10:01'))
        self.scheduler.action(self.f.account,old['id'],'pause')
        preview = self.scheduler.batches.preview(self.data())
        self.assertEqual((preview['readyCount'],preview['invalidCount'],preview['existingCount']), (1,1,1))
        self.assertTrue(preview['records'][0]['duplicate'])
        self.assertEqual(preview['records'][0]['existingCount'], 1)
        other = self.scheduler.batches.preview(self.data(clock='10:02'))
        self.assertTrue(other['canCreate'])
        self.assertFalse(any(row['duplicate'] for row in other['records']))
        self.scheduler.action(self.f.account,old['id'],'cancel')
        allowed = self.scheduler.batches.preview(self.data())
        self.assertTrue(allowed['canCreate'])
        self.assertEqual(allowed['existingCount'], 1)

    def test_crossing_first_due_never_silently_moves_once_daily_or_weekly(self):
        start = self.f.now
        for calendar in ({'mode':'once','at':'2026-09-28T10:01'}, {}, {'mode':'weekly','weekdays':[1]}):
            with self.subTest(calendar=calendar):
                self.f.now = start
                request = self.request(**calendar)
                self.f.now += 60
                with self.assertRaises(BatchConflict): self.scheduler.batches.create(request)
        self.assertEqual(self.scheduler.list(self.f.account), [])
        self.assertEqual(self.f.posts, [])

    def test_preview_rejects_bad_selection_and_calendar_without_mutation(self):
        cases = ({'groupIds':[]}, {'groupIds':self.groups*2}, {'groupIds':['x']*301},
            {'groupIds':[None]}, {'groupIds':'wrong'}, {'templateVersion':True},
            {'windowMinutes':True}, {'windowMinutes':1440}, {'mode':'weekly','weekdays':[1,1]},
            {'mode':'weekly','weekdays':[True]}, {'weekdays':[]}, {'mode':'once','at':'invalid'})
        with patch.object(self.scheduler, 'sender_factory', side_effect=AssertionError('Invalid input must not use Hook')):
            for change in cases:
                with self.subTest(change=change), self.assertRaises(ValueError):
                    self.scheduler.batches.preview(self.data(**change))
        self.assertEqual(self.scheduler.list(self.f.account), [])

    def test_due_crossed_during_sql_writes_rolls_back_jobs_and_receipt(self):
        request = self.request()
        path, state, due = self.scheduler.path, self.f, self.f.now+60
        class SlowWrites(sqlite3.Connection):
            def executemany(connection, sql, parameters):
                result = super().executemany(sql, parameters)
                if sql.startswith('INSERT INTO schedules '): state.now = due
                return result
        def connect():
            db = sqlite3.connect(path, factory=SlowWrites)
            db.row_factory = sqlite3.Row
            db.execute('PRAGMA synchronous=FULL')
            return db
        with patch.object(self.scheduler, '_db', side_effect=connect), self.assertRaises(BatchConflict):
            self.scheduler.batches.create(request)
        self.assertEqual(self.scheduler.list(self.f.account), [])
        with closing(self.scheduler._db()) as db:
            self.assertEqual(db.execute('SELECT count(*) FROM schedule_batches').fetchone()[0], 0)


if __name__ == '__main__':
    unittest.main()
