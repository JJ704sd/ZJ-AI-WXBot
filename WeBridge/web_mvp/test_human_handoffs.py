"""Human queue acceptance over real local SQLite and invented message snapshots."""
from contextlib import closing
import sqlite3
import tempfile
import unittest
from unittest.mock import patch

from human_handoffs import HumanHandoffs, HandoffConflict
from test_windows_inbound import InboundFixture
from test_database_adapter import MIXED
from test_database_adapter import SELF


class HandoffTests(unittest.TestCase):
    def setUp(self):
        directory = tempfile.TemporaryDirectory(prefix='webridge-synthetic-handoff-')
        self.addCleanup(directory.cleanup)
        self.f = InboundFixture(directory.name)
        self.queue = HumanHandoffs(self.f.service)
        self.trigger = {'messageId': 'message-1', 'serverId': '9001',
            'senderId': 'synthetic-sender', 'senderName': '合成业务联系人',
            'timestamp': self.f.now, 'text': '<img src=x onerror=alert(1)>请人工确认',
            'textTruncated': False}

    def enqueue(self, event='event-1', *, account=None, group=None, created=None):
        f = self.f
        with closing(f.service._db()) as db, db:
            self.queue.enqueue(db, event, account or f.account, group or f.group,
                '合成业务群', self.trigger, f.now if created is None else created)

    def test_enqueue_is_durable_deduplicated_and_keeps_original_context(self):
        self.enqueue()
        self.enqueue()
        page = HumanHandoffs(self.f.service).list(self.f.account)
        self.assertEqual(len(page['records']), 1)
        record = page['records'][0]
        self.assertEqual(record, {'id': 'event-1', 'groupId': self.f.group,
            'groupName': '合成业务群', 'trigger': self.trigger, 'reason': '群规则要求人工处理',
            'owner': '', 'status': 'pending', 'createdAt': self.f.now,
            'updatedAt': self.f.now, 'version': 1, 'note': '', 'revoked': False,
            'notification': {'status':'unassigned', 'issue':'未配置或未启用通知；不会补发旧待办。',
                'targetId':'', 'targetName':'', 'createdAt':None, 'expiresAt':None, 'draftId':'',
                'delivered':False, 'retryAllowed':False}})
        self.assertFalse(page['hasMore'])
        self.assertEqual(self.f.posts, [])

    def test_claim_release_and_stale_updates_have_explicit_versions(self):
        self.enqueue()
        self.f.now += 10
        claimed = self.queue.action(self.f.account, 'event-1', 1, 'claim', owner='张业务', note='正在核对')
        self.assertEqual((claimed['status'], claimed['owner'], claimed['version']), ('in_progress', '张业务', 2))
        self.assertEqual(claimed['updatedAt'], self.f.now)
        with self.assertRaises(HandoffConflict):
            self.queue.action(self.f.account, 'event-1', 1, 'claim', owner='另一个业务员')
        self.assertEqual(self.queue.list(self.f.account)['records'][0], claimed)
        released = self.queue.action(self.f.account, 'event-1', 2, 'release', note='交回统一队列')
        self.assertEqual((released['status'], released['owner'], released['version']), ('pending', '', 3))
        self.assertEqual(self.f.posts, [])

    def test_scope_filters_every_record_and_revokes_old_cursor(self):
        self.enqueue('wanted-a', created=10)
        self.enqueue('wanted-b', created=10)
        self.enqueue('unwatched', group=MIXED, created=20)
        self.enqueue('other-account', account='another-source', created=30)
        page = self.queue.list(self.f.account, limit=1)
        self.assertEqual([row['id'] for row in page['records']], ['wanted-b'])
        self.assertTrue(page['hasMore'])
        self.enqueue('newer', created=40)
        tail = self.queue.list(self.f.account, limit=1, cursor=page['nextCursor'])
        self.assertEqual([row['id'] for row in tail['records']], ['wanted-a'])
        self.assertFalse(tail['hasMore'])
        self.f.engine.set_watched(self.f.account, [])
        self.assertEqual(self.queue.list(self.f.account)['records'], [])
        with self.assertRaises(ValueError):
            self.queue.list(self.f.account, limit=1, cursor=page['nextCursor'])
        with self.assertRaises(ValueError):
            self.queue.action(self.f.account, 'wanted-a', 1, 'claim', owner='负责人')
        with self.assertRaises(ValueError):
            self.queue.list('another-source')

    def test_filter_and_cursor_validation_before_reading(self):
        self.enqueue()
        self.enqueue('second')
        cursor = self.queue.list(self.f.account, limit=1)['nextCursor']
        for options in ({'status': 'bogus'}, {'limit': True}, {'limit': 0}, {'limit': 201},
                        {'limit': '01'}, {'cursor': 'broken'}, {'cursor': 'x'*4097},
                        {'cursor': cursor, 'limit': 1, 'status': 'pending'}, {'groupId': MIXED}):
            with self.subTest(options=options), self.assertRaises(ValueError):
                self.queue.list(self.f.account, **options)

    def test_detail_refreshes_old_revocation_once_and_complete_requires_new_version(self):
        self.enqueue()
        self.queue.action(self.f.account, 'event-1', 1, 'claim', owner='负责人', note='核对价格')
        self.f.now += 86400
        root = self.f.write_snapshot('old-revoke', {'message/message_0.db': [
            {'local': 2, 'server': 9002, 'time': self.f.now-3600, 'type': 10002,
             'text': '<sysmsg><revokemsg><newmsgid>9001</newmsgid></revokemsg></sysmsg>'}]})
        self.f.activate_snapshot(root)
        self.assertFalse(self.f.service.get(self.f.account, self.f.group)['enabled'])
        with self.assertRaises(HandoffConflict):
            self.queue.action(self.f.account, 'event-1', 2, 'complete', note='完成')
        detail = self.queue.detail(self.f.account, 'event-1')
        record = detail['record']
        self.assertEqual((record['revoked'], record['trigger']['text'], record['trigger']['textTruncated']), (True, '', False))
        self.assertEqual((record['version'], record['status'], record['owner'], record['note']), (3, 'in_progress', '负责人', '核对价格'))
        self.assertEqual([change['action'] for change in detail['changes']], ['revoked', 'claim', 'created'])
        self.assertFalse(detail['historyTruncated'])
        self.assertEqual(self.queue.detail(self.f.account, 'event-1'), detail)
        completed = self.queue.action(self.f.account, 'event-1', 3, 'complete', note='已核实撤回')
        self.assertEqual((completed['status'], completed['owner'], completed['version']), ('completed', '负责人', 4))
        reopened = self.queue.action(self.f.account, 'event-1', 4, 'reopen')
        self.assertEqual((reopened['status'], reopened['owner'], reopened['version']), ('pending', '', 5))
        self.assertEqual(self.f.posts, [])

    def test_detail_and_completion_preserve_task_on_unreadable_snapshot(self):
        self.enqueue()
        claimed = self.queue.action(self.f.account, 'event-1', 1, 'claim', owner='负责人')
        for attribute, value in (('busy', True), ('error', 'snapshot failed')):
            with self.subTest(attribute=attribute):
                setattr(self.f.source, attribute, value)
                with self.assertRaises(ValueError):
                    self.queue.detail(self.f.account, 'event-1')
                with self.assertRaises(ValueError):
                    self.queue.action(self.f.account, 'event-1', 2, 'complete')
                self.assertEqual(self.queue.list(self.f.account)['records'][0], claimed)
                setattr(self.f.source, attribute, False if attribute == 'busy' else '')

    def test_adapter_source_change_blocks_stale_engine_account(self):
        self.enqueue()
        next_source = self.f.write_snapshot('next-source', {'message/message_0.db': []})
        self.f.adapter.configure(next_source, self_id=SELF, source_id='database:another-source')
        self.assertEqual(self.f.engine.account, self.f.account)
        for operation in (lambda: self.queue.list(self.f.account),
                          lambda: self.queue.detail(self.f.account, 'event-1'),
                          lambda: self.queue.action(self.f.account, 'event-1', 1, 'claim', owner='负责人')):
            with self.assertRaises(ValueError):
                operation()

    def test_revocation_is_scoped_and_transactional(self):
        self.enqueue()
        self.enqueue('other-account', account='database:other')
        self.enqueue('other-group', group=MIXED)
        with self.assertRaisesRegex(RuntimeError, 'rollback'):
            with closing(self.f.service._db()) as db, db:
                self.queue.revoke(db, self.f.account, self.f.group, ['9001'], self.f.now+1)
                raise RuntimeError('rollback')
        with closing(self.f.service._db()) as db, db:
            self.assertEqual(db.execute('SELECT SUM(revoked) FROM handoffs').fetchone()[0], 0)
            self.queue.revoke(db, self.f.account, self.f.group, ['9001'], self.f.now+2)
        with closing(self.f.service._db()) as db:
            records = {row['id']: self.queue._record(row,db) for row in db.execute('SELECT * FROM handoffs')}
            self.assertEqual(db.execute('SELECT COUNT(*) FROM handoff_changes').fetchone()[0], 4)
        self.assertTrue(records['event-1']['revoked'])
        self.assertFalse(records['other-account']['revoked'])
        self.assertFalse(records['other-group']['revoked'])

    def test_history_returns_latest_100_changes_with_truncation_flag(self):
        self.enqueue()
        for version in range(1, 103):
            action = 'claim' if version % 2 else 'release'
            self.queue.action(self.f.account, 'event-1', version, action, owner='负责人')
        detail = self.queue.detail(self.f.account, 'event-1')
        self.assertEqual(len(detail['changes']), 100)
        self.assertTrue(detail['historyTruncated'])
        self.assertEqual([change['version'] for change in detail['changes']], list(range(103, 3, -1)))

    def test_audit_write_failure_rolls_back_claim(self):
        self.enqueue()
        original = self.queue.list(self.f.account)['records'][0]
        with closing(self.f.service._db()) as db, db:
            db.execute("""CREATE TRIGGER fail_claim BEFORE INSERT ON handoff_changes
                WHEN NEW.action='claim' BEGIN SELECT RAISE(ABORT,'synthetic audit failure'); END""")
        with self.assertRaisesRegex(sqlite3.IntegrityError, 'synthetic audit failure'):
            self.queue.action(self.f.account, 'event-1', 1, 'claim', owner='负责人')
        self.assertEqual(self.queue.list(self.f.account)['records'][0], original)
        self.assertEqual(len(self.queue.detail(self.f.account, 'event-1')['changes']), 1)

    def test_detail_holds_source_subscription_and_engine_locks_during_refresh(self):
        self.enqueue()
        original = self.f.adapter.call
        def locked_call(*args, **kwargs):
            self.assertTrue(self.f.source.lock._is_owned())
            self.assertTrue(self.f.engine.sync_lock.locked())
            self.assertTrue(self.f.engine.lock._is_owned())
            return original(*args, **kwargs)
        with patch.object(self.f.adapter, 'call', side_effect=locked_call) as read:
            self.assertEqual(self.queue.detail(self.f.account, 'event-1')['record']['id'], 'event-1')
            self.assertTrue(read.called)


if __name__ == '__main__':
    unittest.main()
