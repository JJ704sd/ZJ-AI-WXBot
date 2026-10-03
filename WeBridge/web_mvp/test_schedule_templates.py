"""Local template contracts against synthetic accounts and SQLite only."""
from contextlib import closing
import json
import sqlite3
import threading
import unittest
from unittest.mock import patch

import test_windows_scheduler as fixtures
from schedule_templates import ScheduleTemplates, TemplateConflict


class ScheduleTemplateTests(unittest.TestCase):
    def setUp(self):
        self.f = fixtures.SchedulerTests()
        self.f.setUp()
        self.addCleanup(self.f.doCleanups)
        self.state = self.f.f
        self.service = self.f.scheduler.templates
        self.id = 'synthetic-price-template-001'

    def save(self, **changes):
        return self.service.save(self.state.account, **{
            'id':self.id, 'version':0, 'name':'每周通知', 'text':'{{群名}}：本周价格 {{价格}} 元。', **changes})

    def test_create_list_update_and_delete_are_local_only(self):
        self.state.source.config = None
        self.state.source.error = 'synthetic offline'
        with patch.object(self.f.scheduler, 'sender_factory', side_effect=AssertionError('templates never contact Hook')):
            created = self.save()
            self.assertEqual(created, {'id':self.id, 'name':'每周通知', 'text':'{{群名}}：本周价格 {{价格}} 元。',
                'version':1, 'variables':['群名','价格'], 'targets':[], 'groupId':'',
                'profile':{'values':{},'overrideText':None}})
            self.assertEqual(self.service.list(self.state.account), {'templates':[
                {'id':self.id,'name':'每周通知','version':1,'variables':['群名','价格'],'targetCount':0}]})
            changed = self.save(version=1, name='价格通知')
            self.assertEqual(changed['version'], 2)
            self.assertEqual(self.service.item(self.state.account, self.id), changed)
            self.assertEqual(self.service.delete(self.state.account, self.id, 2), {'deleted':True})
            self.assertEqual(self.service.list(self.state.account), {'templates':[]})
        self.assertEqual(self.state.posts, [])

    def test_profile_drafts_preview_and_literal_override_are_separate(self):
        self.save()
        draft = self.service.profile(self.state.account, self.id, 1, self.state.group,
            {'群名':'测试群','价格':''}, None)
        self.assertEqual(draft['version'], 2)
        self.assertEqual(draft['targets'], [{'groupId':self.state.group,'targetName':'合成群'}])
        with self.assertRaisesRegex(ValueError, '价格'):
            self.service.preview(self.state.account, self.id, 2, self.state.group, draft['profile']['values'], None)
        result = self.service.preview(self.state.account, self.id, 2, self.state.group,
            {'群名':'测试群','价格':'12.50'}, None)
        self.assertEqual(result, {'id':self.id,'version':2,'groupId':self.state.group,
            'templateName':'每周通知','text':'测试群：本周价格 12.50 元。'})
        self.assertEqual(self.service.item(self.state.account, self.id, self.state.group), draft)
        draft = self.service.profile(self.state.account, self.id, 2, self.state.group, {}, '')
        self.assertEqual(draft['profile']['overrideText'], '')
        with self.assertRaises(ValueError):
            self.service.preview(self.state.account, self.id, 3, self.state.group, {}, '')
        self.assertEqual(self.service.preview(self.state.account, self.id, 3, self.state.group,
            {}, '字面 {{价格}}')['text'], '字面 {{价格}}')
        self.assertEqual(self.state.posts, [])

    def test_save_retry_noop_and_stale_versions_do_not_overwrite(self):
        created = self.save()
        self.assertEqual(self.save(), created)
        changed = self.save(version=1, name='修订通知')
        self.assertEqual(changed['version'], 2)
        with self.assertRaises(TemplateConflict): self.save(version=1, name='修订通知')
        self.assertEqual(self.save(version=2, name='修订通知'), changed)
        for changes in ({'version':0}, {'version':1,'text':'different'}, {'version':0,'name':'修订通知'}):
            with self.subTest(changes=changes), self.assertRaises(TemplateConflict): self.save(**changes)
        self.service.profile(self.state.account, self.id, 2, self.state.group, {}, None)
        for operation in (
            lambda:self.service.profile(self.state.account, self.id, 2, self.state.group, {}, None),
            lambda:self.service.preview(self.state.account, self.id, 2, self.state.group, {}, 'text'),
            lambda:self.service.delete(self.state.account, self.id, 2)):
            with self.assertRaises(TemplateConflict): operation()
        self.assertEqual(self.service.item(self.state.account, self.id)['version'], 3)

    def test_concurrent_profile_changes_have_one_winner(self):
        self.save()
        barrier, results, errors = threading.Barrier(2), [], []
        def update(value):
            barrier.wait(5)
            try:
                results.append(self.service.profile(self.state.account, self.id, 1, self.state.group,
                    {'群名':value}, None))
            except Exception as error: errors.append(error)
        threads = [threading.Thread(target=update, args=(name,)) for name in ('甲','乙')]
        for thread in threads: thread.start()
        for thread in threads:
            thread.join(5)
            self.assertFalse(thread.is_alive())
        self.assertEqual(len(results), 1)
        self.assertEqual(len(errors), 1)
        self.assertIsInstance(errors[0], TemplateConflict)
        self.assertEqual(self.service.item(self.state.account, self.id, self.state.group), results[0])

    def test_profile_update_cannot_be_acknowledged_by_stale_template_save(self):
        self.save()
        self.service.profile(self.state.account, self.id, 1, self.state.group, {'价格':'旧值'}, None)
        latest = self.service.profile(self.state.account, self.id, 2, self.state.group, {'价格':'新值'}, None)
        with self.assertRaises(TemplateConflict):
            self.save(version=2)
        self.assertEqual(self.service.item(self.state.account, self.id, self.state.group), latest)

    def test_account_isolation_and_restart_preserve_saved_profiles(self):
        self.save()
        expected = self.service.profile(self.state.account, self.id, 1, self.state.group, {'价格':'10'}, None)
        self.service = ScheduleTemplates(self.state.engine)
        self.assertEqual(self.service.item(self.state.account, self.id, self.state.group), expected)
        original_account = self.state.account
        self.state.engine.account = self.state.account = 'database:other'
        with self.assertRaisesRegex(ValueError, '账号已变化'): self.service.list(original_account)
        self.assertEqual(self.service.list(self.state.account), {'templates':[]})
        other = self.save(name='另一个账号', text='other')
        self.assertEqual(other['version'], 1)
        self.service.delete(self.state.account, self.id, 1)
        self.state.engine.account = self.state.account = original_account
        self.assertEqual(self.service.item(original_account, self.id, self.state.group), expected)
        self.assertNotIn('sourceRoot', json.dumps(expected))
        self.state.engine.account = ''
        with self.assertRaises(ValueError): self.service.list('')

    def test_template_edit_filters_old_values_without_erasing_saved_profile(self):
        self.save()
        self.service.profile(self.state.account, self.id, 1, self.state.group,
            {'群名':'原群','价格':'20'}, None)
        self.save(version=2, text='{{群名}} 本周更新')
        visible = self.service.item(self.state.account, self.id, self.state.group)
        self.assertEqual(visible['profile']['values'], {'群名':'原群'})
        with closing(sqlite3.connect(self.service.path)) as db:
            payload = json.loads(db.execute('SELECT payload FROM templates').fetchone()[0])
        self.assertEqual(payload['profiles'][self.state.group]['values'], {'群名':'原群','价格':'20'})
        self.save(version=3)
        self.assertEqual(self.service.item(self.state.account, self.id, self.state.group)['profile']['values'],
            {'群名':'原群','价格':'20'})
        self.service.profile(self.state.account, self.id, 4, self.state.group, {'群名':'新群'}, None)
        self.assertEqual(self.service.item(self.state.account, self.id, self.state.group)['profile']['values'], {'群名':'新群'})

    def test_unknown_targets_rejected_but_saved_targets_work_after_unwatch_and_offline(self):
        self.save()
        with self.assertRaises(ValueError):
            self.service.profile(self.state.account, self.id, 1, 'unknown', {}, None)
        self.state.engine.store.set_watched(self.state.account, [])
        self.service.profile(self.state.account, self.id, 1, self.state.group, {}, '明确正文')
        self.state.engine.group_list = []
        self.state.engine.connection = {'status':'disconnected'}
        self.state.source.config = None
        saved = self.service.profile(self.state.account, self.id, 2, self.state.group, {}, '离线草稿')
        self.assertEqual(saved['targets'], [{'groupId':self.state.group,'targetName':'合成群'}])
        self.assertEqual(self.service.preview(self.state.account, self.id, 3, self.state.group, {}, '离线草稿')['text'], '离线草稿')
        self.assertEqual(self.state.posts, [])

    def test_placeholders_are_strict_and_replacement_is_one_pass(self):
        invalid = ('{{}}', '{{ key}}', '{{1key}}', '{{a.b}}', '{{x+1}}', '{{key}', 'text }}',
            '{{{{a}}}}', '{{'+'x'*33+'}}', ''.join('{{v'+str(index)+'}}' for index in range(21)))
        for text in invalid:
            with self.subTest(text=text), self.assertRaises(ValueError): self.save(text=text)
        created = self.save(text='单括号 {原文}，{{客户_1}} / {{客户_1}}')
        self.assertEqual(created['variables'], ['客户_1'])
        preview = self.service.preview(self.state.account, self.id, 1, self.state.group,
            {'客户_1':'{{不会再展开}}'}, None)
        self.assertEqual(preview['text'], '单括号 {原文}，{{不会再展开}} / {{不会再展开}}')

    def test_input_and_render_share_hook_unicode_and_control_limits(self):
        for text in ('', ' ', '\ud800', '\x00', 'x\r\ny', '\x7f', '🙂'*1001, '中'*2001):
            with self.subTest(text=text[:15]), self.assertRaises(ValueError): self.save(text=text)
        accepted = self.save(text='🙂'*1000)
        self.assertEqual(len(accepted['text'].encode('utf-16-le'))//2, 2000)
        self.save(version=1, text='{{内容}}{{内容}}')
        for value in (None, 123, 'x'*501, '\ud800', '\x01'):
            with self.subTest(value=str(value)[:15]), self.assertRaises(ValueError):
                self.service.profile(self.state.account, self.id, 2, self.state.group, {'内容':value}, None)
        self.service.profile(self.state.account, self.id, 2, self.state.group, {'内容':'🙂'*500}, None)
        self.assertEqual(self.service.preview(self.state.account, self.id, 3, self.state.group,
            {'内容':'🙂'*500}, None)['text'], '🙂'*1000)
        self.save(version=3, text='{{内容}}{{内容}}多')
        with self.assertRaises(ValueError):
            self.service.preview(self.state.account, self.id, 4, self.state.group, {'内容':'🙂'*500}, None)
        for override in (False, 10, '\x00', '\ud800', '🙂'*1001):
            with self.subTest(override=str(override)[:15]), self.assertRaises(ValueError):
                self.service.profile(self.state.account, self.id, 4, self.state.group, {}, override)

    def test_request_types_and_unknown_variables_are_rejected_without_mutation(self):
        for changes in ({'id':'bad'}, {'id':None}, {'version':True}, {'version':-1},
                {'name':''}, {'name':'x'*81}, {'name':'\ud800'}, {'text':None}):
            with self.subTest(changes=changes), self.assertRaises(ValueError): self.save(**changes)
        self.save()
        for values in (None, [], {'unknown':'x'}):
            with self.subTest(values=values), self.assertRaises(ValueError):
                self.service.profile(self.state.account, self.id, 1, self.state.group, values, None)
        for group in (None, '', [], 1, 'g'*257):
            with self.subTest(group=group), self.assertRaises(ValueError):
                self.service.profile(self.state.account, self.id, 1, group, {}, None)
        self.assertEqual(self.service.item(self.state.account, self.id)['version'], 1)

    def test_record_caps_allow_existing_template_and_profile_updates(self):
        self.save()
        with closing(sqlite3.connect(self.service.path)) as db, db:
            payload = json.loads(db.execute('SELECT payload FROM templates').fetchone()[0])
            db.executemany('INSERT INTO templates VALUES (?,?,1,?)',
                ((self.state.account,f'synthetic-template-limit-{index}',json.dumps(payload)) for index in range(99)))
            payload['profiles'] = {f'known-{index}':{'targetName':'已保存群','values':{},'overrideText':None}
                for index in range(500)}
            db.execute('UPDATE templates SET payload=? WHERE id=?', (json.dumps(payload),self.id))
        with self.assertRaisesRegex(ValueError, '100'): self.save(id='synthetic-extra-template')
        self.save(version=1, name='仍可修改')
        with self.assertRaisesRegex(ValueError, '500'):
            self.service.profile(self.state.account, self.id, 2, self.state.group, {}, None)
        result = self.service.profile(self.state.account, self.id, 2, 'known-0', {}, None)
        self.assertEqual(result['version'], 3)
        self.assertEqual(len(result['targets']), 500)


if __name__ == '__main__':
    unittest.main()
