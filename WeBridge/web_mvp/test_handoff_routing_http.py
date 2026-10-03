"""Owner routing HTTP acceptance with invented snapshots and no native access."""
from contextlib import closing
import sqlite3
import unittest
from unittest.mock import patch

import test_handoff_http as fixtures
from test_database_adapter import SELF, STAMP, create_shard, membership


SECOND = 'synthetic-second@chatroom'


class HandoffRoutingHttpTests(unittest.TestCase):
    def setUp(self):
        self.fixture = fixtures.HandoffHttpTests()
        self.fixture.setUp()
        self.addCleanup(self.fixture.doCleanups)
        self.f = self.fixture.f
        self.snapshot('routing-initial')
        self.f.engine.set_watched(self.f.account, [self.f.group, SECOND])

    def snapshot(self, revision, first=(), second=()):
        root = self.f.write_snapshot(revision, {'message/message_0.db': list(first)})
        with closing(sqlite3.connect(root/'contact/contact.db')) as db, db:
            db.execute('UPDATE contact SET remark=? WHERE username=?', ('同名合成业务群', self.f.group))
            db.execute('INSERT INTO contact VALUES (?,?,?,?,?)', (SECOND, '同名合成业务群', '', '', 0))
            db.execute('INSERT INTO chat_room VALUES (?,?,?)', (SECOND, SELF, membership()))
        with closing(sqlite3.connect(root/'session/session.db')) as db, db:
            db.execute('INSERT INTO SessionTable VALUES (?,?)', (SECOND, STAMP))
        create_shard(root, 'message/message_1.db', group=SECOND, rows=list(second))
        self.f.activate_snapshot(root)

    def routing(self, **changes):
        return self.fixture.get('/api/handoffs/routing', **changes)

    def save(self, owner, version=0, group=None, **changes):
        return self.fixture.request('POST', '/api/handoffs/routing', {
            'account': self.f.account, 'groupId': self.f.group if group is None else group,
            'version': version, 'owner': owner, **changes})

    def rule_storage(self):
        with closing(self.f.service._db()) as db:
            return (list(map(tuple, db.execute('SELECT * FROM rules ORDER BY account,group_id'))),
                    list(map(tuple, db.execute('SELECT * FROM baselines ORDER BY account,group_id,event_id'))))

    def test_routing_assigns_new_mentions_without_rebaselining_or_claiming(self):
        f = self.f
        code, initial = self.routing()
        self.assertEqual(code, 200)
        self.assertEqual({row['groupId'] for row in initial['routes']}, {f.group, SECOND})
        self.assertTrue(all(row['owner'] == '' and row['version'] == 0 and row['updatedAt'] is None
                            for row in initial['routes']))
        with patch.object(f.service, 'sender_factory', side_effect=AssertionError('Routing must not contact Hook')):
            self.assertEqual(self.save('销售一组')[0], 200)
            self.assertEqual(self.save('销售二组', group=SECOND)[0], 200)
            for group in (f.group, SECOND):
                code, _ = self.fixture.request('POST', '/api/reply', {
                    'account': f.account, 'groupId': group, 'enabled': True,
                    'text': '', 'cooldown': 30, 'mode': 'handoff'})
                self.assertEqual(code, 200)
            f.now += 1
            first = {'server': 101, 'time': f.now, 'text': '请一组核实', 'atuserlist': SELF}
            second = {'server': 201, 'time': f.now, 'text': '请二组核实', 'atuserlist': SELF}
            self.snapshot('routing-unprocessed', [first], [second])
            before = self.rule_storage()
            self.assertEqual(self.save('销售新一组', version=1)[0], 200)
            self.assertEqual(self.rule_storage(), before)
            f.service.tick()
            f.service.tick()
            code, page = self.fixture.get()
            self.assertEqual(code, 200)
            tasks = {row['groupId']: row for row in page['records']}
            self.assertEqual(set(tasks), {f.group, SECOND})
            self.assertEqual({group: row['owner'] for group, row in tasks.items()},
                             {f.group: '销售新一组', SECOND: '销售二组'})
            self.assertTrue(all(row['status'] == 'pending' for row in tasks.values()))
            self.assertEqual(self.save('', version=2)[0], 200)
            f.service.tick()
            self.assertEqual(self.fixture.get()[1]['records'], page['records'])
            code, detail = self.fixture.get('/api/handoffs/detail', id=tasks[f.group]['id'])
            self.assertEqual(code, 200)
            self.assertEqual(detail['changes'][0]['owner'], '销售新一组')
            self.assertEqual(detail['changes'][0]['action'], 'created')
            self.assertIn('销售新一组', self.fixture.get()[1]['owners'])
            before = self.rule_storage()
            payload = {'account': f.account, 'id': tasks[f.group]['id'], 'owner': '销售新一组'}
            for version, action, expected, owner in (
                    (1, 'claim', 'in_progress', '销售新一组'),
                    (2, 'complete', 'completed', '销售新一组'),
                    (3, 'reopen', 'pending', '')):
                code, record = self.fixture.request('POST', '/api/handoffs/action',
                    {**payload, 'version': version, 'action': action})
                self.assertEqual((code, record['status'], record['owner']), (200, expected, owner))
            self.assertEqual(self.rule_storage(), before)
        self.assertEqual(f.posts, [])

    def test_exact_owner_filter_precedes_pagination_and_keeps_historical_labels(self):
        self.assertEqual(self.save('业务A')[0], 200)
        self.fixture.enqueue('wanted-old', created=1)
        self.fixture.enqueue('wanted-new', created=2)
        self.assertEqual(self.save('业务AB', version=1)[0], 200)
        self.fixture.enqueue('different-owner', created=3)
        self.assertEqual(self.save('', version=2)[0], 200)
        self.fixture.enqueue('unassigned', created=4)
        self.assertEqual(self.save('不可见群标签', group=SECOND)[0], 200)
        self.fixture.enqueue('other-group', group=SECOND, created=5)
        self.f.engine.set_watched(self.f.account, [self.f.group])
        query = {'ownerFilter': 'owner', 'owner': '业务A', 'limit': 1}
        code, page = self.fixture.get(**query)
        self.assertEqual(code, 200)
        self.assertEqual([row['id'] for row in page['records']], ['wanted-new'])
        self.assertEqual(page['owners'], ['业务A', '业务AB'])
        code, tail = self.fixture.get(**query, cursor=page['nextCursor'])
        self.assertEqual(code, 200)
        self.assertEqual([row['id'] for row in tail['records']], ['wanted-old'])
        self.assertFalse(tail['hasMore'])
        self.assertEqual(self.fixture.get(**{**query, 'owner': '业务AB'}, cursor=page['nextCursor'])[0], 400)
        self.assertEqual(self.fixture.get(ownerFilter='unassigned')[1]['records'][0]['id'], 'unassigned')
        self.assertEqual(len(self.fixture.get()[1]['records']), 4, 'Old clients still see all visible owners.')
        self.assertEqual(self.fixture.get(ownerFilter='owner', owner='不存在的标签')[1]['records'], [])
        self.assertEqual({row['groupId'] for row in self.routing()[1]['routes']}, {self.f.group})
        self.assertEqual(self.save('不允许改未读取群', version=1, group=SECOND)[0], 400)
        self.assertEqual(self.f.posts, [])

    def test_routing_cas_restart_capability_and_http_guards(self):
        self.assertTrue(self.fixture.get('/api/state')[1]['runtime']['capabilities']['handoffRouting'])
        code, script = self.fixture.request('GET', '/handoff_routing_ui.js')
        self.assertEqual(code, 200)
        self.assertIn(b'handoff-routing', script)
        for headers in ({'Origin': 'https://untrusted.invalid'}, {'Host': 'untrusted.invalid'},
                        {'X-CSRF-Token': ''}, {'Sec-Fetch-Site': 'cross-site'}):
            with self.subTest(headers=headers):
                code, _ = self.fixture.request('POST', '/api/handoffs/routing', {
                    'account': self.f.account, 'groupId': self.f.group, 'version': 0, 'owner': '业务员'}, **headers)
                self.assertEqual(code, 403)
        for changes in ({'account': 'wrong'}, {'group': 'filehelper'}, {'version': True},
                        {'owner': 'line\nbreak'}, {'owner': '\ud800'}, {'owner': 'x'*81}):
            with self.subTest(changes=changes):
                self.assertEqual(self.save(**{'owner': '业务员', **changes})[0], 400)
        code, saved = self.save('业务员')
        self.assertEqual((code, saved['version']), (200, 1))
        code, conflict = self.save('另一个业务员')
        self.assertEqual((code, conflict['code']), (409, 'handoff_conflict'))
        self.f.service = self.f.new_service()
        self.f.engine.windows_auto_reply = self.f.service
        self.assertEqual(next(row for row in self.routing()[1]['routes'] if row['groupId'] == self.f.group), saved)
        self.assertEqual(self.routing(account='wrong')[0], 400)
        self.f.engine.windows_auto_reply = None
        self.assertFalse(self.fixture.get('/api/state')[1]['runtime']['capabilities']['handoffRouting'])
        self.assertEqual(self.routing()[0], 400)
        self.assertEqual(self.save('不可用', version=1)[0], 400)
        self.assertEqual(self.f.posts, [])


if __name__ == '__main__':
    unittest.main()
