"""Notification concurrency through real SQLite intake and an invented transport."""
import threading
import unittest

import test_human_handoffs as fixtures
from test_database_adapter import PEER, SELF, create_shard


class HandoffNotificationConcurrencyTests(unittest.TestCase):
    def setUp(self):
        self.h = fixtures.HandoffTests()
        self.addCleanup(self.h.doCleanups)
        self.h.setUp()
        self.f = self.h.f
        self.queue = self.h.queue
        self.notifications = self.f.service.notifications
        snapshot = self.snapshot('notification-concurrency-initial')
        self.f.activate_snapshot(snapshot)
        self.f.engine.set_watched(self.f.account, [self.f.group, PEER])
        self.f.service.configure(self.f.account, self.f.group, True, '', 30, mode='handoff')
        self.queue.set_routing(self.f.account, self.f.group, 0, '合成负责人')
        self.notifications.configure(self.f.account, self.f.group, 0, 1, PEER, True)

    def snapshot(self, revision, rows=()):
        snapshot = self.f.write_snapshot(revision, {'message/message_0.db': list(rows)})
        create_shard(snapshot, 'message/message_1.db', group=PEER, rows=[])
        return snapshot

    def test_disabling_policy_during_final_get_prevents_post(self):
        self.h.enqueue()
        original = self.f.sender.transport
        probes = []

        def transport(method, path, payload=None):
            result = original(method, path, payload)
            if method == 'GET':
                probes.append(path)
                if len(probes) == 3:
                    self.notifications.configure(self.f.account, self.f.group, 1, 1, PEER, False)
            return result

        self.f.sender.transport = transport
        self.notifications.tick()
        self.assertEqual(len(probes), 3)
        self.assertEqual(self.f.posts, [])
        notice = self.queue.detail(self.f.account, 'event-1')['record']['notification']
        self.assertEqual(notice['status'], 'cancelled')
        self.assertFalse(self.notifications.configuration(self.f.account)['configs'][0]['enabled'])
        self.assertTrue(self.f.service.get(self.f.account, self.f.group)['enabled'])

    def test_slow_post_allows_snapshot_activation_and_original_intake_to_create_next_task(self):
        self.h.enqueue()
        entered, release = threading.Event(), threading.Event()
        errors, workers = [], []
        original = self.f.sender.transport

        def transport(method, path, payload=None):
            if method == 'POST':
                entered.set()
                if not release.wait(5):
                    raise TimeoutError('Synthetic test did not release POST')
            return original(method, path, payload)

        def send():
            try:
                self.notifications.tick()
            except BaseException as error:
                errors.append(error)

        def receive():
            try:
                self.f.now += 1
                snapshot = self.snapshot('during-post-new-inbound', [
                    {'server': 881, 'time': self.f.now, 'text': '发送期间收到的新请求', 'atuserlist': SELF}])
                self.f.activate_snapshot(snapshot)
                self.f.service.tick()
            except BaseException as error:
                errors.append(error)

        self.f.sender.transport = transport
        try:
            sender = threading.Thread(target=send)
            workers.append(sender)
            sender.start()
            self.assertTrue(entered.wait(3), 'Notification did not reach the recording POST')
            reader = threading.Thread(target=receive)
            workers.append(reader)
            reader.start()
            reader.join(3)
            self.assertFalse(reader.is_alive(), 'Snapshot activation and intake must finish while POST is blocked')
            self.assertEqual(errors, [])
            records = self.queue.list(self.f.account)['records']
            new = [row for row in records if row['id'] != 'event-1']
            self.assertEqual(len(new), 1)
            self.assertEqual((new[0]['trigger']['serverId'], new[0]['status']), ('881', 'pending'))
            self.assertEqual(new[0]['notification']['status'], 'queued')
        finally:
            release.set()
            for worker in workers:
                worker.join(3)
        self.assertTrue(all(not worker.is_alive() for worker in workers))
        self.assertEqual(errors, [])
        self.assertEqual(len(self.f.posts), 1)
        notice = self.queue.detail(self.f.account, 'event-1')['record']['notification']
        self.assertEqual(notice['status'], 'submitted_unconfirmed')


if __name__ == '__main__':
    unittest.main()
