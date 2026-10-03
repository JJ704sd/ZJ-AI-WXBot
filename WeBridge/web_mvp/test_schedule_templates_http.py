"""Template HTTP workflows with synthetic accounts and recording transport."""
from contextlib import closing
import http.client
import json
import unittest
from unittest.mock import patch

from test_database_adapter import MIXED
import test_weekly_scheduler_http as fixtures


class ScheduleTemplateHttpTests(unittest.TestCase):
    def setUp(self):
        self.fixture = fixtures.WeeklyScheduleHttpTests()
        self.fixture.setUp()
        self.addCleanup(self.fixture.doCleanups)
        self.f = self.fixture.f
        self.scheduler = self.fixture.scheduler
        self.template_id = 'synthetic-template-http-001'

    def post(self, action, **changes):
        return self.fixture.request('POST', '/api/schedule-templates/'+action,
            {'account': self.f.account, 'id': self.template_id, **changes})

    def get(self, group=''):
        return self.fixture.request('GET', '/api/schedule-templates/item?account='+
            self.f.account+'&id='+self.template_id+'&groupId='+group)

    def create(self, **changes):
        code, result = self.post('save', **{
            'version': 0, 'name': '统一询价', 'text': '{{客户}}，请发送{{品类}}价格表。', **changes})
        self.assertEqual(code, 200)
        return result

    def test_offline_template_profiles_preview_and_restart_are_account_scoped(self):
        for group in self.f.engine.group_list:
            if group['id'] in (self.f.group, MIXED):
                group['name'] = '同名合成业务群'
        self.f.ready, self.f.source.busy = False, True
        self.f.source.error = 'synthetic disconnected source'
        with patch.object(self.f.sender, '_probe', side_effect=AssertionError('Templates must not probe Hook')):
            template = self.create()
            values = {'客户': '甲工厂', '品类': '钢材'}
            code, configured = self.post('profile', version=template['version'], groupId=self.f.group,
                values=values, overrideText=None)
            self.assertEqual(code, 200)
            code, second = self.post('profile', version=configured['version'], groupId=MIXED,
                values={}, overrideText='乙工厂的完整询价正文')
            self.assertEqual(code, 200)
            self.assertEqual(len(second['targets']), 2)
            code, preview = self.post('preview', version=second['version'], groupId=self.f.group,
                values=values, overrideText=None)
            self.assertEqual((code, preview['text']), (200, '甲工厂，请发送钢材价格表。'))
            code, override = self.post('preview', version=second['version'], groupId=MIXED,
                values={}, overrideText='乙工厂的完整询价正文')
            self.assertEqual((code, override['text']), (200, '乙工厂的完整询价正文'))
            self.f.engine.windows_scheduler = self.fixture.new_scheduler()
            self.assertEqual(self.get(self.f.group)[1]['profile'], {'values': values, 'overrideText': None})
            self.assertEqual(self.get(MIXED)[1]['profile']['overrideText'], '乙工厂的完整询价正文')
            listing = self.fixture.request('GET', '/api/schedule-templates?account='+self.f.account)[1]
            self.assertEqual(listing['templates'][0]['targetCount'], 2)
            self.assertNotIn(str(self.f.root), str(listing))
            self.assertEqual(self.scheduler.list(self.f.account), [])
            with self.f.engine.lock:
                self.f.engine.account = 'database:other-synthetic-account'
            try:
                code, other = self.fixture.request('GET', '/api/schedule-templates?account=database:other-synthetic-account')
                self.assertEqual((code, other), (200, {'templates': []}))
                code, _ = self.fixture.request('GET', '/api/schedule-templates/item?account=database:other-synthetic-account&id='+self.template_id)
                self.assertEqual(code, 400)
                self.assertEqual(self.get()[0], 400)
            finally:
                with self.f.engine.lock:
                    self.f.engine.account = self.f.account
        self.assertEqual(self.f.posts, [])

    def test_conflicts_and_incomplete_profile_never_fall_back_to_template(self):
        template = self.create()
        code, draft = self.post('profile', version=template['version'], groupId=self.f.group,
            values={'客户': ''}, overrideText=None)
        self.assertEqual(code, 200)
        code, error = self.post('preview', version=draft['version'], groupId=self.f.group,
            values={'客户': ''}, overrideText=None)
        self.assertEqual(code, 400)
        self.assertTrue(any(name in error['error'] for name in ('客户', '品类')))
        code, empty_override = self.post('profile', version=draft['version'], groupId=self.f.group,
            values={'客户': '甲工厂', '品类': '钢材'}, overrideText='')
        self.assertEqual(code, 200)
        self.assertEqual(self.post('preview', version=empty_override['version'], groupId=self.f.group,
            values={'客户': '甲工厂', '品类': '钢材'}, overrideText='')[0], 400)
        code, conflict = self.post('save', version=template['version'], name='过期编辑', text='不同内容')
        self.assertEqual((code, conflict['code']), (409, 'template_conflict'))
        self.assertEqual(self.post('delete', version=template['version'])[0], 409)
        self.assertEqual(self.get(self.f.group)[1]['profile']['overrideText'], '')
        self.assertEqual(self.scheduler.list(self.f.account), [])
        self.assertEqual(self.f.posts, [])

    def test_template_preview_becomes_frozen_job_text_even_after_edit_and_delete(self):
        template = self.create()
        code, preview = self.post('preview', version=template['version'], groupId=self.f.group,
            values={'客户': '甲工厂', '品类': '钢材'}, overrideText=None)
        self.assertEqual(code, 200)
        payload = self.fixture.data(text=preview['text'])
        code, job = self.fixture.request('POST', '/api/jobs', payload)
        self.assertEqual(code, 201)
        code, changed = self.post('save', version=template['version'], name='新版询价', text='{{客户}}，新版内容')
        self.assertEqual(code, 200)
        self.assertEqual(self.post('delete', version=changed['version']), (200, {'deleted': True}))
        self.assertEqual(self.fixture.request('POST', '/api/jobs', payload)[1]['id'], job['id'])
        self.assertEqual(self.fixture.request('POST', '/api/jobs', {**payload, 'text': '已人工修改正文'})[0], 400)
        self.f.now = job['nextRun']
        self.scheduler.tick()
        self.scheduler.tick()
        self.assertEqual(len(self.f.posts), 1)
        self.assertEqual(self.f.posts[0]['text'], '甲工厂，请发送钢材价格表。')
        self.assertEqual(self.scheduler.list(self.f.account)[0]['text'], preview['text'])

    def test_large_valid_profile_drafts_do_not_relax_other_request_limits(self):
        variables = ['内容'+str(index) for index in range(20)]
        template = self.create(text=''.join('{{'+key+'}}' for key in variables))
        values = {key: '🙂'*500 for key in variables}
        profile = {'version': template['version'], 'groupId': self.f.group,
                   'values': values, 'overrideText': None}
        self.assertGreater(len(json.dumps(profile).encode('ascii')), 32768)
        code, saved = self.post('profile', **profile)
        self.assertEqual(code, 200)
        self.assertEqual(self.get(self.f.group)[1]['profile']['values'], values)
        self.assertEqual(self.post('preview', **{**profile, 'version': saved['version']})[0], 400)
        code, error = self.fixture.request('POST', '/api/jobs',
            self.fixture.data(padding='x'*33000))
        self.assertEqual(code, 400)
        self.assertIn('请求大小', error['error'])
        self.assertEqual(self.scheduler.list(self.f.account), [])
        self.assertEqual(self.f.posts, [])

    def test_capability_static_module_and_http_permissions(self):
        code, state = self.fixture.request('GET', '/api/state')
        self.assertEqual(code, 200)
        self.assertIs(state['runtime']['capabilities']['scheduleTemplates'], True)
        with closing(http.client.HTTPConnection('127.0.0.1', self.fixture.port, timeout=5)) as connection:
            connection.request('GET', '/schedule_template_ui.js')
            with closing(connection.getresponse()) as response:
                body = response.read().decode('utf-8')
                self.assertEqual(response.status, 200)
                self.assertIn('javascript', response.getheader('Content-Type'))
                self.assertIn('schedule-template-dialog', body)
        for headers in ({'Origin': 'https://untrusted.invalid'}, {'X-CSRF-Token': ''}, {'Host': 'untrusted.invalid'}):
            with self.subTest(headers=headers):
                code, _ = self.fixture.request('POST', '/api/schedule-templates/save',
                    {'account': self.f.account, 'id': self.template_id, 'version': 0, 'name': '受保护模板', 'text': '正文'}, **headers)
                self.assertEqual(code, 403)
        self.assertEqual(self.post('save', account='wrong-account', version=0, name='错误账号', text='正文')[0], 400)
        listing = self.fixture.request('GET', '/api/schedule-templates?account='+self.f.account)[1]
        self.assertEqual(listing, {'templates': []})
        self.f.engine.windows_scheduler = None
        state = self.fixture.request('GET', '/api/state')[1]
        self.assertIs(state['runtime']['capabilities']['scheduleTemplates'], False)
        self.assertEqual(self.post('save', version=0, name='不支持的模板', text='正文')[0], 400)
        self.assertEqual(self.f.posts, [])


if __name__ == '__main__':
    unittest.main()
