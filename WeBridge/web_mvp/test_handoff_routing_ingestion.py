"""Assigned human tasks from invented database snapshots; no Hook invocation."""
import threading
import unittest
from unittest.mock import patch

import test_handoff_ingestion as fixtures
from test_database_adapter import SELF


class HandoffRoutingIngestionTests(unittest.TestCase):
    def setUp(self):
        self.h = fixtures.HandoffIngestionTests()
        self.h.setUp()
        self.addCleanup(self.h.doCleanups)
        self.f = self.h.f
        self.queue = self.f.service.handoffs

    def test_new_mentions_use_current_default_without_reassigning_existing_events(self):
        f = self.f
        with patch.object(f.service,'sender_factory',side_effect=AssertionError('routing must never contact Hook')):
            self.queue.set_routing(f.account,f.group,0,'首位负责人')
            self.h.enable()
            f.now += 1
            first = {'local':1,'server':11,'time':f.now,'text':'第一项业务','atuserlist':SELF}
            self.h.update('first-owner', [first])
            f.service.tick()
            old = self.h.tasks()[0]
            self.assertEqual((old['owner'],old['status']), ('首位负责人','pending'))
            self.queue.set_routing(f.account,f.group,1,'下一位负责人')
            f.now += 1
            self.h.update('next-owner', [first,
                {'local':2,'server':12,'time':f.now,'text':'第二项业务','atuserlist':SELF}])
            f.service.tick()
            f.service.tick()
        tasks = {row['trigger']['serverId']:row for row in self.h.tasks()}
        self.assertEqual(tasks['11'], old)
        self.assertEqual(tasks['12']['owner'], '下一位负责人')
        self.assertEqual(self.queue.detail(f.account,old['id'])['changes'][0]['owner'], '首位负责人')
        self.assertEqual(len(f.service.get(f.account,f.group)['attempts']), 2)
        self.assertEqual(f.posts, [])

    def test_default_update_waiting_on_enqueue_does_not_change_frozen_transaction(self):
        f = self.f
        self.queue.set_routing(f.account,f.group,0,'事务开始时负责人')
        self.h.enable()
        f.now += 1
        first = {'local':1,'server':11,'time':f.now,'text':'并发业务','atuserlist':SELF}
        self.h.update('routing-race', [first])
        enqueued, update_waiting, release = threading.Event(), threading.Event(), threading.Event()
        source_lock = f.source.lock
        class ObservedLock:
            def __enter__(self):
                if threading.current_thread().name=='routing-update': update_waiting.set()
                return source_lock.__enter__()
            def __exit__(self, *args): return source_lock.__exit__(*args)
        f.source.lock = ObservedLock()
        original_enqueue = self.queue.enqueue
        def blocked_enqueue(db, *args, **kwargs):
            self.assertTrue(db.in_transaction)
            original_enqueue(db,*args,**kwargs)
            enqueued.set()
            if not release.wait(5): raise TimeoutError('synthetic enqueue was not released')
        workers, errors = [], []
        def start(name, operation):
            def run():
                try: operation()
                except Exception as error: errors.append(error)
            worker = threading.Thread(target=run,name=name)
            workers.append(worker)
            worker.start()
        with patch.object(self.queue,'enqueue',side_effect=blocked_enqueue):
            try:
                start('inbound-tick',f.service.tick)
                self.assertTrue(enqueued.wait(5))
                start('routing-update',lambda:self.queue.set_routing(f.account,f.group,1,'更新后的负责人'))
                self.assertTrue(update_waiting.wait(5))
            finally:
                release.set()
                for worker in workers:
                    worker.join(5)
                    self.assertFalse(worker.is_alive())
        self.assertEqual(errors, [])
        old = self.h.tasks()[0]
        self.assertEqual(old['owner'], '事务开始时负责人')
        self.assertEqual(self.queue.detail(f.account,old['id'])['changes'][0]['owner'], '事务开始时负责人')
        self.assertEqual(self.queue.routing(f.account)['routes'][0]['owner'], '更新后的负责人')
        f.now += 1
        self.h.update('after-routing-race', [first,
            {'local':2,'server':12,'time':f.now,'text':'后续业务','atuserlist':SELF}])
        f.service.tick()
        self.assertEqual({row['trigger']['serverId']:row['owner'] for row in self.h.tasks()},
            {'11':'事务开始时负责人','12':'更新后的负责人'})
        self.assertEqual(f.posts, [])


if __name__ == '__main__':
    unittest.main()
