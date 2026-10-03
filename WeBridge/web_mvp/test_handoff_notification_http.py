"""Notification acceptance through HTTP, synthetic snapshots and recording Hook."""
from contextlib import closing
import json
import unittest
from unittest.mock import patch

import test_handoff_http as fixtures
from test_database_adapter import ENTERPRISE, PEER, SELF, create_shard


class HandoffNotificationHttpTests(unittest.TestCase):
    def setUp(self):
        self.fixture = fixtures.HandoffHttpTests()
        self.fixture.setUp()
        self.addCleanup(self.fixture.doCleanups)
        self.f = self.fixture.f
        self.snapshot('notification-http-initial')
        self.f.engine.set_watched(self.f.account, [self.f.group, PEER, ENTERPRISE, 'filehelper'])

    def snapshot(self, revision, rows=()):
        root = self.f.write_snapshot(revision, {'message/message_0.db': list(rows)})
        create_shard(root, 'message/message_1.db', group=PEER, rows=[])
        self.f.activate_snapshot(root)

    def post(self, path, **data):
        return self.fixture.request('POST', path, {'account': self.f.account, **data})

    def setup_route(self):
        code, _ = self.post('/api/reply', groupId=self.f.group, enabled=True,
                            text='', cooldown=30, mode='handoff')
        self.assertEqual(code, 200)
        code, route = self.post('/api/handoffs/routing', groupId=self.f.group, version=0, owner='销售一组')
        self.assertEqual(code, 200)
        return route

    def save(self, **changes):
        return self.post('/api/handoffs/notifications', **{
            'groupId': self.f.group, 'version': 0, 'routeVersion': 1,
            'targetId': PEER, 'enabled': True, **changes})

    def storage(self):
        with closing(self.f.service._db()) as db:
            return (list(map(tuple, db.execute('SELECT * FROM rules'))),
                    list(map(tuple, db.execute('SELECT * FROM baselines'))))

    def test_new_handoff_notifies_frozen_private_target_once_with_separate_evidence(self):
        f = self.f
        self.setup_route()
        self.fixture.enqueue('pre-existing-task')
        before = self.storage()
        code, config = self.save(targetName='untrusted name', text='untrusted text',
                                 sourceRoot='Z:/untrusted', selfId='untrusted')
        self.assertEqual(code, 200)
        self.assertEqual((config['targetId'], config['enabled'], config['version']), (PEER, True, 1))
        self.assertNotEqual(config['targetName'], 'untrusted name')
        self.assertEqual(self.storage(), before, 'Notification configuration must not rebaseline inbound messages.')
        self.assertEqual(f.posts, [])

        f.now += 1
        self.snapshot('notification-http-arrival', [
            {'server': 301, 'time': f.now, 'text': '请业务员核实这条请求', 'atuserlist': SELF}])
        f.service.tick()
        code, page = self.fixture.get()
        self.assertEqual(code, 200)
        task = next(row for row in page['records'] if row['id'] != 'pre-existing-task')
        self.assertEqual(task['notification']['status'], 'queued')
        self.assertEqual(f.posts, [], 'Inbound collection never calls the Hook sender.')
        f.service.notifications.tick()
        f.service.notifications.tick()
        self.assertEqual(len(f.posts), 1)
        self.assertEqual(f.posts[0]['targetId'], PEER)
        self.assertIn('请业务员核实这条请求', f.posts[0]['text'])
        self.assertNotIn('untrusted', json.dumps(f.posts[0], ensure_ascii=False))
        code, detail = self.fixture.get('/api/handoffs/detail', id=task['id'])
        self.assertEqual(code, 200)
        notice = detail['record']['notification']
        self.assertEqual(notice['status'], 'submitted_unconfirmed')
        self.assertFalse(notice['delivered'])
        self.assertFalse(notice['retryAllowed'])
        self.assertEqual(notice['targetId'], PEER)
        self.assertEqual(notice['draftId'], f.posts[0]['draftId'])
        self.assertEqual(detail['record']['status'], 'pending')
        self.assertEqual(detail['record']['owner'], '销售一组')
        code, old = self.fixture.get('/api/handoffs/detail', id='pre-existing-task')
        self.assertEqual((code, old['record']['notification']['status']), (200, 'not_configured'))
        code, history = self.fixture.get('/api/execution-history', source='manual')
        self.assertEqual(code, 200)
        self.assertFalse(any(row['id'] == notice['draftId'] for row in history['records']))

    def test_configuration_guards_scope_and_stale_versions_do_not_grant_sending(self):
        self.setup_route()
        code, data = self.fixture.get('/api/handoffs/notifications')
        self.assertEqual(code, 200)
        self.assertEqual({row['id'] for row in data['recipients']}, {PEER, ENTERPRISE})
        self.assertEqual({row['groupId'] for row in data['configs']}, {self.f.group})
        self.assertNotIn('sourceRoot', json.dumps(data))
        payload = {'account': self.f.account, 'groupId': self.f.group, 'version': 0,
                   'routeVersion': 1, 'targetId': PEER, 'enabled': True}
        for headers in ({'Origin': 'https://untrusted.invalid'}, {'Host': 'untrusted.invalid'},
                        {'X-CSRF-Token': ''}, {'Sec-Fetch-Site': 'cross-site'}):
            with self.subTest(headers=headers):
                self.assertEqual(self.fixture.request('POST', '/api/handoffs/notifications', payload, **headers)[0], 403)
        for changes in ({'account': 'other'}, {'groupId': PEER}, {'targetId': SELF},
                        {'targetId': 'filehelper'}, {'targetId': self.f.group},
                        {'targetId': 'invented'}, {'enabled': 'true'}, {'version': True},
                        {'routeVersion': True}):
            with self.subTest(changes=changes):
                self.assertEqual(self.save(**changes)[0], 400)
        self.assertEqual(self.save(routeVersion=0)[0], 409)
        self.assertEqual(self.save()[0], 200)
        code, error = self.save(targetId=ENTERPRISE)
        self.assertEqual((code, error['code']), (409, 'handoff_conflict'))
        self.assertEqual(self.fixture.get('/api/handoffs/notifications', account='other')[0], 400)
        self.assertEqual(self.f.posts, [])

    def test_hook_stop_and_unsubscribe_cancel_only_unsent_notifications_not_intake(self):
        self.setup_route()
        self.assertEqual(self.save()[0], 200)
        self.fixture.enqueue('waiting')
        code, _ = self.post('/api/windows/hook/stop')
        self.assertEqual(code, 200)
        self.f.service.notifications.tick()
        notice = self.fixture.get('/api/handoffs/detail', id='waiting')[1]['record']['notification']
        self.assertEqual(notice['status'], 'cancelled')
        self.assertTrue(self.f.service.get(self.f.account, self.f.group)['enabled'])
        config = self.fixture.get('/api/handoffs/notifications')[1]['configs'][0]
        self.assertFalse(config['enabled'])
        self.assertEqual(self.save(version=config['version'])[0], 200)
        self.fixture.enqueue('waiting-after-enable')
        self.assertEqual(self.post('/api/subscriptions', groupIds=[self.f.group])[0], 200)
        self.f.service.notifications.tick()
        notice = self.fixture.get('/api/handoffs/detail', id='waiting-after-enable')[1]['record']['notification']
        self.assertEqual(notice['status'], 'cancelled')
        self.assertTrue(self.f.service.get(self.f.account, self.f.group)['enabled'])
        self.assertEqual(self.f.posts, [])

    def test_capability_static_asset_and_worker_lifecycle(self):
        self.assertTrue(self.fixture.get('/api/state')[1]['runtime']['capabilities']['handoffNotifications'])
        code, script = self.fixture.request('GET', '/handoff_notification_ui.js')
        self.assertEqual(code, 200)
        self.assertIn(b'handoff-notification', script)
        engine = self.f.engine
        with patch.object(engine, 'poll_loop') as poll, patch.object(self.f.service.notifications, 'run') as notify:
            engine.start()
            for thread in engine.threads:
                thread.join(timeout=2)
                self.assertFalse(thread.is_alive())
        poll.assert_called_once_with()
        notify.assert_called_once_with()
        engine.windows_auto_reply = None
        self.assertFalse(self.fixture.get('/api/state')[1]['runtime']['capabilities']['handoffNotifications'])
        self.assertEqual(self.fixture.get('/api/handoffs/notifications')[0], 400)
        self.assertEqual(self.save()[0], 400)


if __name__ == '__main__':
    unittest.main()
