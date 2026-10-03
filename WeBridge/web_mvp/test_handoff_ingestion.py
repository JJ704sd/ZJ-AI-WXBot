"""Real synthetic snapshots feed local human tasks without any native sending."""
from contextlib import closing
import json
import sqlite3
import tempfile
import unittest
from unittest.mock import patch

from test_windows_inbound import InboundFixture
from test_database_adapter import STAMP, SELF


class HandoffIngestionTests(unittest.TestCase):
    def setUp(self):
        temp = tempfile.TemporaryDirectory(prefix='webridge-synthetic-handoff-')
        self.addCleanup(temp.cleanup)
        self.f = InboundFixture(temp.name)

    def enable(self):
        return self.f.service.configure(self.f.account, self.f.group, True, '', 30, mode='handoff')

    def update(self, revision, rows):
        self.f.activate_snapshot(self.f.write_snapshot(revision, {'message/message_0.db': rows}))

    def tasks(self):
        return self.f.service.handoffs.list(self.f.account)['records']

    def test_new_mentions_create_distinct_tasks_without_hook_or_cooldown(self):
        f = self.f
        with patch.object(f.service, 'sender_factory', side_effect=AssertionError('Must not contact Hook')):
            self.assertEqual(self.enable()['mode'], 'handoff')
            f.now = STAMP+1
            self.update('two-requests', [
                {'local': 1, 'server': 11, 'time': f.now, 'text': '需要业务员处理第一项', 'atuserlist': SELF},
                {'local': 2, 'server': 12, 'time': f.now, 'text': '还有第二项', 'atuserlist': SELF},
            ])
            f.service.tick()
            f.service.tick()
        tasks = self.tasks()
        self.assertEqual(len(tasks), 2)
        self.assertEqual({row['trigger']['serverId'] for row in tasks}, {'11', '12'})
        self.assertTrue(all(row['status'] == 'pending' and row['owner'] == '' for row in tasks))
        self.assertEqual(f.posts, [])
        self.assertTrue(all(row['status'] == 'human_pending' for row in f.service.get(f.account, f.group)['attempts']))

    def test_atomic_enqueue_failure_leaves_no_claim_and_can_be_processed_once(self):
        f = self.f
        self.enable()
        f.now += 1
        self.update('one-request', [{'server': 11, 'time': f.now, 'text': '待处理', 'atuserlist': SELF}])
        with closing(f.service._db()) as db, db:
            db.execute("""CREATE TRIGGER fail_task BEFORE INSERT ON handoffs
                BEGIN SELECT RAISE(ABORT, 'synthetic disk failure'); END""")
        with self.assertRaisesRegex(sqlite3.IntegrityError, 'synthetic disk failure'):
            f.service.tick()
        self.assertEqual(self.tasks(), [])
        self.assertEqual(f.service.get(f.account, f.group)['attempts'], [])
        self.assertEqual(f.posts, [])
        with closing(f.service._db()) as db, db:
            db.execute('DROP TRIGGER fail_task')
        f.service.tick()
        f.service.tick()
        self.assertEqual(len(self.tasks()), 1)
        event = f.service.get(f.account, f.group)['attempts'][0]
        self.assertEqual(event['taskId'], self.tasks()[0]['id'])
        self.assertNotIn('trigger', event, 'Do not duplicate retractable message text in the execution ledger.')

    def test_cross_page_and_cross_shard_requests_are_deduplicated_without_cooldown(self):
        f = self.f
        self.enable()
        f.now += 1
        rows = [{'local': n, 'server': n, 'time': f.now, 'text': '请求 '+str(n), 'atuserlist': SELF}
                for n in range(1, 202)]
        f.activate_snapshot(f.write_snapshot('many-requests', {
            'message/message_0.db': rows, 'biz_message/biz_message_0.db': rows[:3]}))
        f.service.tick()
        f.service.tick()
        first = f.service.handoffs.list(f.account, limit=200)
        second = f.service.handoffs.list(f.account, limit=200, cursor=first['nextCursor'])
        self.assertTrue(first['hasMore'])
        self.assertFalse(second['hasMore'])
        records = first['records']+second['records']
        self.assertEqual(len(records), 201)
        self.assertEqual({row['trigger']['serverId'] for row in records}, {str(n) for n in range(1, 202)})
        self.assertEqual(f.posts, [])

    def test_mode_switch_rechecks_hook_and_baselines_existing_future_messages(self):
        f = self.f
        f.ready = False
        self.enable()
        f.now += 1
        old = {'local': 1, 'server': 1, 'time': f.now+1, 'text': '切换前消息', 'atuserlist': SELF}
        self.update('before-switch', [old])
        f.service.tick()
        self.assertEqual(len(self.tasks()), 1)
        with self.assertRaises(ValueError):
            f.service.configure(f.account, f.group, True, f.reply_text, 30, mode='reply')
        self.assertEqual(f.service.get(f.account, f.group)['mode'], 'handoff')
        f.ready = True
        unprocessed = {'local': 3, 'server': 3, 'time': f.now+2, 'text': '切换前已有但尚未处理', 'atuserlist': SELF}
        self.update('unprocessed-before-switch', [old, unprocessed])
        f.service.configure(f.account, f.group, True, f.reply_text, 30, mode='reply')
        f.now += 2
        new = {'local': 2, 'server': 2, 'time': f.now, 'text': '切换后消息', 'atuserlist': SELF}
        self.update('after-switch', [old, new, unprocessed])
        f.service.tick()
        f.service.tick()
        self.assertEqual(len(f.posts), 1)
        self.assertEqual(f.posts[0]['text'], f.reply_text)
        self.assertEqual(len(self.tasks()), 1)
        sent = next(row for row in f.service.get(f.account, f.group)['attempts'] if row['decision'] == 'reply')
        self.assertEqual(sent['trigger']['serverId'], '2')
        self.assertEqual(len(f.service.get(f.account, f.group)['attempts']), 2)

    def test_handoff_lifecycle_preserves_mode_and_does_not_require_native_connection(self):
        f = self.f
        with patch.object(f.service, 'sender_factory', side_effect=AssertionError('Must not contact Hook')):
            self.enable()
            # An older client must not silently restore sending mode.
            saved = f.service.configure(f.account, f.group, True, '', 30)
            self.assertEqual(saved['mode'], 'handoff')
            f.service.pause_all(sending_only=True)
            self.assertTrue(f.service.get(f.account, f.group)['enabled'])
            f.source.error = 'synthetic refresh failure'
            f.service.tick()
            self.assertFalse(f.service.get(f.account, f.group)['enabled'])
            f.source.error = ''
            self.enable()
            f.engine.set_watched(f.account, [])
            f.service.pause_unwatched(f.account)
            self.assertFalse(f.service.get(f.account, f.group)['enabled'])
            f.engine.set_watched(f.account, [f.group])
            self.enable()
        f.service = f.new_service()
        saved = f.service.get(f.account, f.group)
        self.assertFalse(saved['enabled'])
        self.assertEqual(saved['mode'], 'handoff')
        self.assertIn('重启', saved['issue'])
        self.assertEqual(f.posts, [])

    def test_legacy_rule_is_migrated_once_and_disabled_at_startup(self):
        f = self.f
        f.enable()
        with closing(f.service._db()) as db, db:
            old = json.loads(db.execute('SELECT payload FROM rules').fetchone()[0])
            del old['mode']
            db.execute('UPDATE rules SET payload=?', (json.dumps(old),))
        f.service = f.new_service()
        rule = f.service.get(f.account, f.group)
        self.assertEqual(rule['mode'], 'reply')
        self.assertFalse(rule['enabled'])
        self.assertIn('重启', rule['issue'])
        self.assertEqual(f.posts, [])

    def test_revocation_prepass_rejects_new_task_and_masks_existing_old_task(self):
        f = self.f
        self.enable()
        f.now += 1
        original = {'local': 1, 'server': 11, 'time': f.now, 'text': '随后撤回的原文', 'atuserlist': SELF}
        self.update('first-task', [original])
        f.service.tick()
        task = self.tasks()[0]
        f.now += 130
        fresh = {'local': 2, 'server': 12, 'time': f.now, 'text': '同副本撤回', 'atuserlist': SELF}
        revokes = [{'local': i, 'server': i+100, 'time': f.now, 'type': 10002,
                    'text': '<sysmsg><revokemsg><newmsgid>'+str(server)+'</newmsgid>'
                            '<replacemsg>合成撤回</replacemsg></revokemsg></sysmsg>'}
                   for i, server in enumerate((11, 12), 1)]
        f.activate_snapshot(f.write_snapshot('revoked-after-window', {
            'message/message_0.db': [original, fresh], 'biz_message/biz_message_0.db': revokes}))
        f.service.tick()
        f.service.tick()
        records = self.tasks()
        self.assertEqual(len(records), 1)
        self.assertEqual(records[0]['id'], task['id'])
        self.assertTrue(records[0]['revoked'])
        self.assertEqual(records[0]['trigger']['text'], '')
        self.assertEqual(records[0]['version'], 2, 'A repeated snapshot must not create repeated revocation updates.')
        self.assertEqual(f.posts, [])


if __name__ == '__main__':
    unittest.main()
