"""Dedicated inbound scanning against invented local SQLite snapshots."""
from copy import deepcopy
from contextlib import closing
import importlib.util
import json
from pathlib import Path
import sqlite3
import tempfile
import unittest
from unittest.mock import patch

from database_adapter import DatabaseAdapter, DatabaseError
from test_database_adapter import create_metadata, create_shard, GROUP, MIXED, SELF, STAMP


class InboundMessageTests(unittest.TestCase):
    def setUp(self):
        temp = tempfile.TemporaryDirectory(prefix='webridge-synthetic-inbound-reader-')
        self.addCleanup(temp.cleanup)
        self.root = Path(temp.name)
        create_metadata(self.root)

    def adapter(self, **kwargs):
        return DatabaseAdapter(self.root, self_id=SELF, source_id='synthetic-inbound', **kwargs)

    def page(self, adapter, cursor=None, start=STAMP, end=STAMP + 10000, group=GROUP):
        return adapter.call('inbound_messages', account=adapter.auth()['sourceId'], groupId=group,
                            start=start, end=end, cursor=cursor)

    def collect(self, adapter, **params):
        messages, pages, cursor = [], [], None
        for _ in range(100):
            with patch.object(adapter, '_present_message', wraps=adapter._present_message) as present:
                result = self.page(adapter, cursor=cursor, **params)
                self.assertLessEqual(present.call_count, 500)
            self.assertLessEqual(len(result['messages']), 100)
            self.assertEqual(result['complete'], result['cursor']['complete'])
            messages.extend(result['messages'])
            pages.append(result)
            # Checkpoints remain usable after storage/transport as ordinary JSON.
            cursor = json.loads(json.dumps(result['cursor'], ensure_ascii=False))
            if result['complete']:
                return messages, pages
        self.fail('inbound scan did not terminate')

    def test_multishard_same_second_scan_has_stable_ascending_order_and_no_gaps(self):
        for file in ('message/message_0.db', 'message/message_1.db', 'biz_message/biz_message_0.db'):
            rows = [{'local': i + 1, 'server': i + 1, 'time': STAMP + i // 150,
                     'text': file + ' row ' + str(i), 'atuserlist': SELF if i == 0 else ''} for i in range(201)]
            create_shard(self.root, file, rows=rows)
        messages, pages = self.collect(self.adapter())
        self.assertEqual(len(messages), 603)
        coordinates = [(row['timestamp'], row['dbName'], row['localId']) for row in messages]
        self.assertEqual(coordinates, sorted(coordinates))
        self.assertEqual(len(set(coordinates)), 603)
        self.assertEqual(sum(row['mentionSelf'] for row in messages), 3)
        self.assertGreater(len(pages), 6)
        self.assertTrue(all(not {'contentHash', '_contentHash', 'rowId', '_raw'} & row.keys() for row in messages))

    def test_duplicate_local_ids_use_rowid_tiebreaker_without_dropping_records(self):
        create_shard(self.root, rows=[{'local': 1, 'time': STAMP, 'text': 'body ' + str(i)} for i in range(102)])
        messages, _ = self.collect(self.adapter())
        self.assertEqual([row['text'] for row in messages], ['body ' + str(i) for i in range(102)])

    def test_same_snapshot_reuses_completed_revoke_scan_without_losing_window(self):
        history = [{'local': i + 1, 'time': STAMP + i, 'type': 10000, 'text': 'old system'} for i in range(501)]
        history.append({'local': 900, 'time': STAMP + 1000, 'text': 'current', 'atuserlist': SELF})
        create_shard(self.root, rows=history)
        adapter = self.adapter()
        with patch.object(adapter, '_present_message', wraps=adapter._present_message) as present:
            first, _ = self.collect(adapter, start=STAMP + 1000, end=STAMP + 1001)
        self.assertEqual(present.call_count, 502)
        with patch.object(adapter, '_present_message', wraps=adapter._present_message) as present:
            second, _ = self.collect(adapter, start=STAMP + 1000, end=STAMP + 1001)
        self.assertEqual(second, first)
        self.assertEqual(present.call_count, 1, 'A completed revoke scan should not decode unchanged history again')

    def test_cache_does_not_skip_future_messages_entering_a_later_window(self):
        create_shard(self.root, rows=[
            {'local': 1, 'time': STAMP, 'type': 10000, 'text': 'old system'},
            {'local': 2, 'time': STAMP + 1000, 'text': 'current'},
            {'local': 3, 'time': STAMP + 1010, 'text': 'future', 'atuserlist': SELF}])
        adapter = self.adapter()
        first, _ = self.collect(adapter, start=STAMP + 1000, end=STAMP + 1005)
        self.assertEqual([row['text'] for row in first], ['current'])
        with patch.object(adapter, '_present_message', wraps=adapter._present_message) as present:
            later, _ = self.collect(adapter, start=STAMP + 1000, end=STAMP + 1015)
        self.assertEqual([row['text'] for row in later], ['current', 'future'])
        self.assertEqual(present.call_count, 2)

    def test_reconfigure_same_revision_label_invalidates_cache_and_mutation_still_fails(self):
        path = create_shard(self.root, rows=[{'type': 10000, 'time': STAMP, 'text': 'system'},
                                            {'local': 2, 'time': STAMP + 1000, 'text': 'current'}])
        adapter = self.adapter(source_info={'revision': 'same-label'})
        self.collect(adapter, start=STAMP + 1000)
        adapter.configure(self.root, self_id=SELF, source_id='synthetic-inbound', source_info={'revision': 'same-label'})
        with patch.object(adapter, '_present_message', wraps=adapter._present_message) as present:
            self.collect(adapter, start=STAMP + 1000)
        self.assertEqual(present.call_count, 2)
        with closing(sqlite3.connect(path)) as db:
            db.execute('CREATE TABLE mutation_marker(value)')
            db.commit()
        with self.assertRaises(DatabaseError) as caught:
            self.page(adapter, start=STAMP + 1000)
        self.assertEqual(caught.exception.code, 'snapshot_changed')

    def test_warning_on_earlier_prepass_page_prevents_cache_publication(self):
        create_shard(self.root, rows=[{'local': i + 1, 'time': STAMP + i, 'type': 10000,
                                     'text': b'\xff' if i == 0 else 'system'} for i in range(501)] +
                     [{'local': 900, 'time': STAMP + 1000, 'text': 'current'}])
        adapter = self.adapter()
        first = self.page(adapter, start=STAMP + 1000)
        self.assertEqual(first['warnings'][0]['code'], 'utf8_decode_error')
        self.assertFalse(first['cursor']['revokes_cacheable'])
        self.assertEqual(len(adapter._state['inbound_revoke_cache']), 0)
        second = self.page(adapter, start=STAMP + 1000, cursor=first['cursor'])
        self.assertTrue(second['complete'])
        self.assertEqual(second['warnings'], [])
        self.assertEqual(len(adapter._state['inbound_revoke_cache']), 0)
        with patch.object(adapter, '_present_message', wraps=adapter._present_message) as present:
            self.collect(adapter, start=STAMP + 1000)
        self.assertEqual(present.call_count, 502)

    def test_interrupted_prepass_is_not_published_and_name_warning_still_propagates(self):
        create_shard(self.root, rows=[{'local': i + 1, 'time': STAMP + i, 'type': 10000, 'text': 'system'} for i in range(501)] +
                     [{'local': 900, 'time': STAMP + 1000, 'text': 'current'}])
        with closing(sqlite3.connect(self.root / 'contact/contact.db')) as db:
            db.execute('UPDATE contact SET remark=? WHERE username=?', (b'\xff', SELF))
            db.commit()
        adapter = self.adapter()
        first = self.page(adapter, start=STAMP + 1000)
        self.assertFalse(first['complete'])
        self.assertEqual(len(adapter._state['inbound_revoke_cache']), 0)
        self.assertTrue(first['cursor']['revokes_cacheable'])
        self.collect(adapter, start=STAMP + 1000)
        with patch.object(adapter, '_present_message', wraps=adapter._present_message) as present:
            _, pages = self.collect(adapter, start=STAMP + 1000)
        self.assertEqual(present.call_count, 1)
        self.assertEqual(pages[0]['warnings'][0]['code'], 'contact_label_decode_error')

    def test_cache_lru_count_byte_and_oversize_eviction_preserve_revocation(self):
        groups = [GROUP, MIXED, 'third-cache@chatroom']
        for i, group in enumerate(groups):
            create_shard(self.root, 'message/message_' + str(i) + '.db', group=group, rows=[
                {'local': 1, 'server': 7, 'time': STAMP + 1000, 'text': 'original', 'atuserlist': SELF},
                {'local': 2, 'time': STAMP, 'type': 10002,
                 'text': '<sysmsg><revokemsg><newmsgid>7</newmsgid></revokemsg></sysmsg>'}])
        adapter = self.adapter()
        def read(group):
            rows, _ = self.collect(adapter, group=group, start=STAMP + 1000)
            self.assertEqual(len(rows), 1)
            self.assertEqual(rows[0]['kind'], 'revoke')
            self.assertFalse(rows[0]['mentionSelf'])
            return rows
        with patch('inbound_messages.MAX_REVOKE_CACHE_GROUPS', 2):
            for group in (groups[0], groups[1], groups[0], groups[2]):
                read(group)
            self.assertEqual(list(adapter._state['inbound_revoke_cache']), [groups[0], groups[2]])
            with patch.object(adapter, '_present_message', wraps=adapter._present_message) as present:
                read(groups[1])
            self.assertEqual(present.call_count, 2)
        single_size = max(len(json.dumps({group: ['7']}, ensure_ascii=False).encode()) for group in groups)
        adapter.configure(self.root, self_id=SELF, source_id='synthetic-inbound')
        with patch('inbound_messages.MAX_REVOKE_CACHE_BYTES', single_size + 1):
            for group in groups:
                read(group)
                cache = adapter._state['inbound_revoke_cache']
                self.assertLessEqual(sum(entry['size'] for entry in cache.values()), single_size + 1)
            self.assertEqual(len(cache), 1)
        adapter.configure(self.root, self_id=SELF, source_id='synthetic-inbound')
        with patch('inbound_messages.MAX_REVOKE_CACHE_BYTES', 1):
            for _ in range(2):
                with patch.object(adapter, '_present_message', wraps=adapter._present_message) as present:
                    read(GROUP)
                self.assertEqual(present.call_count, 2)
                self.assertEqual(len(adapter._state['inbound_revoke_cache']), 0)

    def test_inclusive_window_and_open_ended_baseline_include_future_records(self):
        create_shard(self.root, rows=[{'local': i + 1, 'time': stamp, 'text': str(stamp)} for i, stamp in enumerate(
            (STAMP - 1, STAMP, STAMP + 1, STAMP + 999999))])
        adapter = self.adapter()
        window, _ = self.collect(adapter, start=STAMP, end=STAMP + 1)
        self.assertEqual([row['timestamp'] for row in window], [STAMP, STAMP + 1])
        baseline, _ = self.collect(adapter, start=STAMP, end=None)
        self.assertEqual([row['timestamp'] for row in baseline], [STAMP, STAMP + 1, STAMP + 999999])

    def test_revoke_after_end_and_nonstandard_kind_preserve_only_original_identity(self):
        create_shard(self.root, rows=[
            {'local': 2, 'server': 80, 'time': STAMP, 'text': 'private original', 'atuserlist': SELF},
            {'local': 1, 'server': 81, 'time': STAMP, 'type': 49,
             'text': '<msg><appmsg><type>6</type><title>secret.xlsx</title></appmsg></msg>'}])
        create_shard(self.root, 'message/message_1.db', rows=[
            {'local': 1, 'time': STAMP, 'type': 49,
             'text': '<sysmsg><revokemsg><newmsgid>80</newmsgid></revokemsg></sysmsg>'},
            {'local': 2, 'time': STAMP + 100000, 'type': 10002,
             'text': '<sysmsg><revokemsg><newmsgid>81</newmsgid></revokemsg></sysmsg>'}])
        messages, _ = self.collect(self.adapter(), start=STAMP, end=STAMP)
        originals = [row for row in messages if row['serverId'] in ('80', '81')]
        self.assertEqual(len(originals), 2)
        self.assertTrue(all(row['kind'] == 'revoke' and not row['mentionSelf'] for row in originals))
        self.assertTrue(all(row['text'] == '一条消息已撤回' and 'media' not in row for row in originals))
        self.assertTrue(all(row['id'] and row['localId'] for row in originals))

    def test_bounded_prepass_delivers_nothing_before_revocations_are_known(self):
        rows = [{'local': i + 1, 'time': STAMP + i, 'type': 10000, 'text': 'system notice'} for i in range(550)]
        rows.extend([
            {'local': 700, 'server': 700, 'time': STAMP, 'text': 'must stay hidden', 'atuserlist': SELF},
            {'local': 800, 'time': STAMP + 100000, 'type': 10002,
             'text': '<sysmsg><revokemsg><newmsgid>700</newmsgid></revokemsg></sysmsg>'}])
        create_shard(self.root, rows=rows)
        adapter = self.adapter()
        with patch.object(adapter, '_present_message', wraps=adapter._present_message) as present:
            first = self.page(adapter)
        self.assertEqual(present.call_count, 500)
        self.assertFalse(first['complete'])
        self.assertEqual(first['messages'], [])
        self.assertEqual(first['cursor']['phase'], 'revokes')
        cursor, all_messages = first['cursor'], []
        while not cursor['complete']:
            page = self.page(adapter, cursor=cursor)
            all_messages.extend(page['messages'])
            cursor = page['cursor']
        original = next(row for row in all_messages if row['serverId'] == '700')
        self.assertEqual(original['kind'], 'revoke')
        self.assertFalse(original['mentionSelf'])

    def test_revoke_timestamp_before_window_still_hides_newer_original(self):
        create_shard(self.root, rows=[
            {'local': 1, 'server': 7, 'time': STAMP + 2, 'text': 'original mention', 'atuserlist': SELF},
            {'local': 2, 'server': 8, 'time': STAMP, 'type': 10002,
             'text': '<sysmsg><revokemsg><newmsgid>7</newmsgid></revokemsg></sysmsg>'}])
        messages, _ = self.collect(self.adapter(), start=STAMP + 1, end=STAMP + 121)
        self.assertEqual(len(messages), 1)
        self.assertEqual(messages[0]['serverId'], '7')
        self.assertEqual(messages[0]['kind'], 'revoke')
        self.assertFalse(messages[0]['mentionSelf'])
        self.assertNotIn('original mention', messages[0]['text'])

    def test_byte_budget_pending_and_single_large_message_preserve_complete_text(self):
        # Three full texts exceed the page budget; the middle record is itself
        # larger than a page and must be delivered exactly once without truncation.
        bodies = ['a' * 1500000, '中' * 900000, 'z' * 1500000]
        create_shard(self.root, rows=[{'local': i + 1, 'time': STAMP + i, 'text': body} for i, body in enumerate(bodies)])
        messages, pages = self.collect(self.adapter())
        self.assertEqual([row['text'] for row in messages], bodies)
        self.assertEqual([row['localId'] for row in messages], [1, 2, 3])
        self.assertEqual(len(pages), 3)
        self.assertIn('pending', pages[0]['cursor'])
        self.assertFalse(pages[0]['complete'])
        self.assertTrue(pages[-1]['complete'])
        self.assertTrue(all('textTruncated' not in row for row in messages))

    def test_pending_last_record_prevents_premature_complete(self):
        create_shard(self.root, rows=[{'local': i + 1, 'time': STAMP + i, 'text': 'a' * 1500000} for i in range(2)])
        adapter = self.adapter()
        first = self.page(adapter)
        self.assertEqual(first['cursor']['phase'], 'done')
        self.assertFalse(first['complete'])
        second = self.page(adapter, cursor=json.loads(json.dumps(first['cursor'])))
        self.assertEqual([row['localId'] for row in second['messages']], [2])
        self.assertTrue(second['complete'])

    @unittest.skipUnless(importlib.util.find_spec('zstandard'), 'zstandard unavailable')
    def test_actual_zstd_full_content_and_mention_metadata(self):
        import zstandard
        body = '压缩内容' * 3000
        create_shard(self.root, rows=[{'text': 'fallback', 'compressed': zstandard.ZstdCompressor().compress(body.encode()), 'atuserlist': SELF}])
        messages, _ = self.collect(self.adapter())
        self.assertEqual(messages[0]['text'], body)
        self.assertTrue(messages[0]['mentionSelf'])
        self.assertNotIn('_contentHash', messages[0])

    def test_warnings_and_complete_checkpoint_are_returned_to_consumer(self):
        create_shard(self.root, rows=[{'text': b'\xff'}])
        adapter = self.adapter()
        first = self.page(adapter)
        self.assertEqual(first['warnings'][0]['code'], 'utf8_decode_error')
        self.assertEqual(first['messages'][0]['decodeStatus'], 'utf8_decode_error')
        self.assertTrue(first['complete'])
        repeat = self.page(adapter, cursor=first['cursor'])
        self.assertEqual(repeat['messages'], [])
        self.assertTrue(repeat['complete'])

    def test_cursor_scope_revision_and_input_checkpoint_are_preserved(self):
        create_shard(self.root, rows=[{'local': i + 1, 'time': STAMP + i} for i in range(201)])
        create_shard(self.root, 'message/message_1.db', group=MIXED, rows=[])
        adapter = self.adapter(source_info={'revision': 'first'})
        first = self.page(adapter)
        cursor = deepcopy(first['cursor'])
        second = self.page(adapter, cursor=cursor)
        self.assertEqual(cursor, first['cursor'])
        with self.assertRaises(DatabaseError) as caught:
            self.page(adapter, cursor=cursor, group=MIXED)
        self.assertEqual(caught.exception.code, 'inbound_cursor_scope_changed')
        adapter.configure(self.root, source_id='another-account', self_id=SELF, source_info={'revision': 'first'})
        with self.assertRaises(DatabaseError) as caught:
            self.page(adapter, cursor=cursor)
        self.assertEqual(caught.exception.code, 'inbound_cursor_scope_changed')
        adapter.configure(self.root, source_id='synthetic-inbound', self_id=SELF, source_info={'revision': 'second'})
        with self.assertRaises(DatabaseError) as caught:
            self.page(adapter, cursor=second['cursor'])
        self.assertEqual(caught.exception.code, 'inbound_cursor_revision_changed')

    def test_revoke_limit_failure_does_not_advance_callers_checkpoint(self):
        create_shard(self.root, rows=[{'local': i + 1, 'time': STAMP + i, 'type': 10002,
                                     'text': '<sysmsg><revokemsg><newmsgid>' + str(i + 1) + '</newmsgid></revokemsg></sysmsg>'}
                                    for i in range(2)])
        adapter = self.adapter()
        with patch('inbound_messages.MAX_SCAN', 1), patch('inbound_messages.MAX_REVOKED', 1):
            first = self.page(adapter)
            original = deepcopy(first['cursor'])
            with self.assertRaises(DatabaseError) as caught:
                self.page(adapter, cursor=first['cursor'])
            self.assertEqual(caught.exception.code, 'inbound_revoke_limit')
            self.assertEqual(first['cursor'], original)


if __name__ == '__main__':
    unittest.main()
