"""Local owner routes over synthetic accounts and the durable handoff queue."""
from contextlib import closing
import sqlite3
import threading
import unittest
from unittest.mock import patch

from human_handoffs import HandoffConflict, HumanHandoffs
import test_human_handoffs as fixtures


class HandoffRoutingTests(unittest.TestCase):
    def setUp(self):
        self.h = fixtures.HandoffTests()
        self.h.setUp()
        self.addCleanup(self.h.doCleanups)
        self.f, self.queue = self.h.f, self.h.queue

    def test_routes_cover_only_known_watched_supported_groups_and_use_ids(self):
        f = self.f
        second = 'synthetic-second@chatroom'
        f.engine.group_list = [{'id':f.group,'name':'同名群'}, {'id':second,'name':'同名群'},
            {'id':'filehelper','name':'文件传输助手'}, {'id':'synthetic@im.chatroom','name':'其他类型群'}]
        f.engine.store.set_watched(f.account, [row['id'] for row in f.engine.group_list])
        self.assertEqual(self.queue.routing(f.account), {'routes':[
            {'groupId':f.group,'groupName':'同名群','owner':'','version':0,'updatedAt':None},
            {'groupId':second,'groupName':'同名群','owner':'','version':0,'updatedAt':None},
            {'groupId':'synthetic@im.chatroom','groupName':'其他类型群','owner':'','version':0,'updatedAt':None}]})
        saved = self.queue.set_routing(f.account, f.group, 0, ' 张业务 ')
        self.assertEqual(saved, {'groupId':f.group,'groupName':'同名群','owner':'张业务','version':1,'updatedAt':f.now})
        self.assertEqual(self.queue.routing(f.account)['routes'][1]['owner'], '')
        for group in ('filehelper','unknown@chatroom'):
            with self.subTest(group=group), self.assertRaises(ValueError):
                self.queue.set_routing(f.account, group, 0, '负责人')
        self.assertEqual(f.posts, [])

    def test_enqueue_freezes_default_and_audit_without_claiming_or_reassigning_replays(self):
        f = self.f
        self.queue.set_routing(f.account, f.group, 0, '原负责人')
        self.h.enqueue('old-event')
        old = self.queue.detail(f.account, 'old-event')
        self.assertEqual((old['record']['owner'],old['record']['status']), ('原负责人','pending'))
        self.assertEqual(old['changes'][0]['owner'], '原负责人')
        self.queue.set_routing(f.account, f.group, 1, '新负责人')
        self.h.enqueue('new-event')
        self.h.enqueue('old-event')
        self.assertEqual(self.queue.detail(f.account, 'old-event'), old)
        self.assertEqual(self.queue.detail(f.account, 'new-event')['record']['owner'], '新负责人')
        self.queue.set_routing(f.account, f.group, 2, '')
        self.h.enqueue('unassigned-event')
        self.assertEqual(self.queue.detail(f.account, 'unassigned-event')['record']['owner'], '')
        self.assertEqual(f.posts, [])

    def test_owner_filter_precedes_pagination_and_labels_include_history_and_defaults(self):
        f = self.f
        self.queue.set_routing(f.account, f.group, 0, '张')
        self.h.enqueue('zhang-old', created=10)
        self.h.enqueue('zhang-new', created=20)
        self.queue.set_routing(f.account, f.group, 1, '张三')
        self.h.enqueue('zhangsan', created=30)
        self.queue.set_routing(f.account, f.group, 2, '')
        self.h.enqueue('unassigned', created=40)
        self.queue.set_routing(f.account, f.group, 3, '只有默认配置')
        self.queue.action(f.account, 'zhang-new', 1, 'claim', owner='张')
        self.queue.action(f.account, 'zhang-new', 2, 'complete')
        first = self.queue.list(f.account, status='all', ownerFilter='owner', owner='张', limit=1)
        self.assertEqual([row['id'] for row in first['records']], ['zhang-new'])
        self.assertEqual(first['owners'], sorted(['张','张三','只有默认配置']))
        second = self.queue.list(f.account, status='all', ownerFilter='owner', owner='张', limit=1, cursor=first['nextCursor'])
        self.assertEqual([row['id'] for row in second['records']], ['zhang-old'])
        self.assertFalse(second['hasMore'])
        unassigned = self.queue.list(f.account, ownerFilter='unassigned')
        self.assertEqual([row['id'] for row in unassigned['records']], ['unassigned'])
        self.assertEqual(unassigned['owners'], first['owners'])
        completed = self.queue.list(f.account, status='completed')
        self.assertEqual(completed['owners'], first['owners'])
        for options in ({'ownerFilter':'owner','owner':'张三'}, {'ownerFilter':'unassigned'}, {'ownerFilter':'all'}):
            with self.subTest(options=options), self.assertRaises(ValueError):
                self.queue.list(f.account, status='all', limit=1, cursor=first['nextCursor'], **options)

    def test_routes_use_strict_versions_clear_without_deletion_and_survive_restart(self):
        f = self.f
        first = self.queue.set_routing(f.account, f.group, 0, '甲')
        f.now += 10
        self.assertEqual(self.queue.set_routing(f.account, f.group, 1, '甲'), first)
        self.queue.set_routing(f.account, f.group, 1, '乙')
        for version,owner in ((0,'甲'), (1,'乙')):
            with self.subTest(version=version), self.assertRaises(HandoffConflict):
                self.queue.set_routing(f.account, f.group, version, owner)
        cleared = self.queue.set_routing(f.account, f.group, 2, '')
        self.assertEqual((cleared['owner'],cleared['version'],cleared['updatedAt']), ('',3,f.now))
        self.assertEqual(HumanHandoffs(f.service).routing(f.account)['routes'][0], cleared)
        with closing(f.service._db()) as db:
            self.assertEqual(db.execute('SELECT count(*) FROM handoff_routes').fetchone()[0], 1)

    def test_two_connections_cannot_both_write_the_same_route_version(self):
        f = self.f
        other = HumanHandoffs(f.service)
        self.queue.set_routing(f.account, f.group, 0, '旧负责人')
        start, results, errors = threading.Barrier(2), [], []
        def update(queue, owner):
            start.wait(5)
            try: results.append(queue.set_routing(f.account, f.group, 1, owner))
            except Exception as error: errors.append(error)
        workers = [threading.Thread(target=update, args=(queue,owner))
            for queue,owner in ((self.queue,'窗口甲'),(other,'窗口乙'))]
        for worker in workers: worker.start()
        for worker in workers:
            worker.join(5)
            self.assertFalse(worker.is_alive())
        self.assertEqual(len(results), 1)
        self.assertEqual(len(errors), 1)
        self.assertIsInstance(errors[0], HandoffConflict)
        self.assertEqual(self.queue.routing(f.account)['routes'][0], results[0])

    def test_scope_hides_other_accounts_unwatched_routes_and_owner_history(self):
        f = self.f
        self.queue.set_routing(f.account, f.group, 0, '可见负责人')
        self.h.enqueue()
        with closing(f.service._db()) as db, db:
            db.execute('INSERT INTO handoff_routes VALUES (?,?,?,?,?)', ('database:other',f.group,'其他账号',1,f.now))
        self.h.enqueue('other-account', account='database:other')
        self.assertEqual(self.queue.list(f.account)['owners'], ['可见负责人'])
        with self.assertRaises(ValueError): self.queue.routing('database:other')
        with self.assertRaises(ValueError): self.queue.set_routing('database:other',f.group,1,'越界')
        f.engine.set_watched(f.account, [])
        self.assertEqual(self.queue.routing(f.account), {'routes':[]})
        self.assertEqual(self.queue.list(f.account)['owners'], [])
        with self.assertRaises(ValueError): self.queue.set_routing(f.account,f.group,1,'越界')
        f.engine.set_watched(f.account, [f.group])
        self.assertEqual(self.queue.routing(f.account)['routes'][0]['owner'], '可见负责人')
        self.assertEqual(self.queue.list(f.account)['owners'], ['可见负责人'])

    def test_release_and_reopen_leave_task_unassigned_instead_of_reapplying_default(self):
        f = self.f
        self.queue.set_routing(f.account, f.group, 0, '默认负责人')
        self.h.enqueue()
        with self.assertRaises(ValueError): self.queue.action(f.account,'event-1',1,'claim')
        self.queue.action(f.account,'event-1',1,'claim',owner='实际处理人')
        released = self.queue.action(f.account,'event-1',2,'release')
        self.assertEqual((released['owner'],released['status']), ('','pending'))
        self.queue.action(f.account,'event-1',3,'claim',owner='实际处理人')
        self.queue.action(f.account,'event-1',4,'complete')
        reopened = self.queue.action(f.account,'event-1',5,'reopen')
        self.assertEqual((reopened['owner'],reopened['status']), ('','pending'))
        self.assertEqual(self.queue.list(f.account,ownerFilter='unassigned')['records'], [reopened])
        self.assertEqual(self.queue.routing(f.account)['routes'][0]['owner'], '默认负责人')

    def test_owner_validation_is_shared_by_routing_claims_and_filters(self):
        f = self.f
        self.h.enqueue()
        for owner in (None, 1, 'x'*81, '\r', '\n', '\x00', '\ud800'):
            with self.subTest(owner=repr(owner)):
                with self.assertRaises(ValueError): self.queue.set_routing(f.account,f.group,0,owner)
                with self.assertRaises(ValueError): self.queue.action(f.account,'event-1',1,'claim',owner=owner)
                with self.assertRaises(ValueError): self.queue.list(f.account,ownerFilter='owner',owner=owner)
        for version in (None, True, -1, 1.0):
            with self.subTest(version=version), self.assertRaises(ValueError):
                self.queue.set_routing(f.account,f.group,version,'负责人')
        for options in ({'ownerFilter':'invalid'}, {'ownerFilter':'owner','owner':''}):
            with self.subTest(options=options), self.assertRaises(ValueError): self.queue.list(f.account,**options)
        route = self.queue.set_routing(f.account,f.group,0,'🙂'*80)
        self.assertEqual(route['owner'], '🙂'*80)
        for character in ('\t','\x01','\x7f','\x85','\u2028','\u2029'):
            with self.subTest(legacy_character=repr(character)):
                label = '销售'+character+'张'
                route = self.queue.set_routing(f.account,f.group,route['version'],label)
                self.assertEqual(route['owner'], label)
                self.assertEqual(self.queue.list(f.account,ownerFilter='owner',owner=label)['records'], [])
        self.assertEqual(self.queue.detail(f.account,'event-1')['record']['version'], 1)

    def test_legacy_tab_owner_remains_filterable_and_can_complete_or_release(self):
        f = self.f
        historical_owner = '销售\t张'
        for event in ('legacy-complete','legacy-release'):
            self.h.enqueue(event)
            self.queue.action(f.account,event,1,'claim',owner='原负责人')
        # This label was valid under the original claim contract. Preserve its
        # stored identity instead of migrating or silently normalizing it.
        with closing(f.service._db()) as db, db:
            db.execute('UPDATE handoffs SET owner=?', (historical_owner,))
            db.execute("UPDATE handoff_changes SET owner=? WHERE action='claim'", (historical_owner,))
        page = self.queue.list(f.account,ownerFilter='owner',owner=historical_owner)
        self.assertEqual({row['id'] for row in page['records']}, {'legacy-complete','legacy-release'})
        self.assertEqual(page['owners'], [historical_owner])
        completed = self.queue.action(f.account,'legacy-complete',2,'complete',owner=historical_owner)
        released = self.queue.action(f.account,'legacy-release',2,'release',owner=historical_owner)
        self.assertEqual((completed['status'],completed['owner']), ('completed',historical_owner))
        self.assertEqual((released['status'],released['owner']), ('pending',''))
        self.assertEqual(self.queue.detail(f.account,'legacy-release')['changes'][1]['owner'], historical_owner)

    def test_schema_addition_preserves_existing_rules_baselines_tasks_and_audits(self):
        f = self.f
        f.service.configure(f.account,f.group,True,'',30,mode='handoff')
        self.h.enqueue()
        tables = ('rules','baselines','events','handoffs','handoff_changes')
        with closing(f.service._db()) as db, db:
            before = {table:[tuple(row) for row in db.execute('SELECT * FROM '+table)] for table in tables}
            db.execute('DROP TABLE handoff_routes')
        migrated = HumanHandoffs(f.service)
        migrated.set_routing(f.account,f.group,0,'新默认')
        with closing(f.service._db()) as db:
            after = {table:[tuple(row) for row in db.execute('SELECT * FROM '+table)] for table in tables}
        self.assertEqual(after, before)
        self.assertEqual(migrated.detail(f.account,'event-1')['record']['owner'], '')


if __name__ == '__main__':
    unittest.main()
