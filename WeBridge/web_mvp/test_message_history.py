"""History acceptance uses synthetic SQLite shards only, never live WeChat."""
from contextlib import closing
from datetime import datetime, timedelta, timezone
import importlib.util
import json
from pathlib import Path
import sqlite3
import tempfile
import unittest
from unittest.mock import patch

from database_adapter import DatabaseAdapter, DatabaseError
from message_history import validate_history_params
from test_database_adapter import create_metadata, create_shard, GROUP, MIXED, PEER, SELF, STAMP


class MessageHistoryTests(unittest.TestCase):
    def setUp(self):
        temp = tempfile.TemporaryDirectory(prefix='webridge-synthetic-history-')
        self.addCleanup(temp.cleanup)
        self.root = Path(temp.name)
        create_metadata(self.root)

    def adapter(self, **kwargs):
        return DatabaseAdapter(self.root, **kwargs)

    def page(self, adapter, **params):
        return adapter.call('message_history', account=adapter.auth()['sourceId'], groupId=GROUP, **params)

    def collect(self, adapter, **params):
        messages, pages, cursor = [], [], ''
        for _ in range(200):
            page = self.page(adapter, cursor=cursor, **params)
            self.assertLessEqual(page['scanned'], 5000)
            self.assertEqual(page['messages'], sorted(page['messages'], key=lambda row: (row['timestamp'], row['id'])))
            messages.extend(page['messages'])
            pages.append(page)
            if not page['hasMore']:
                self.assertEqual(page['nextCursor'], '')
                return messages, pages
            self.assertTrue(page['nextCursor'])
            cursor = page['nextCursor']
        self.fail('history cursor did not terminate')

    def test_searches_beyond_2000_and_continues_after_empty_bounded_page(self):
        create_shard(self.root, rows=[{'local': i + 1, 'server': i + 1, 'time': STAMP + i,
                                     'text': 'needle oldest' if i == 0 else 'plain ' + str(i)} for i in range(6105)])
        adapter = self.adapter()
        first = self.page(adapter, query='NEEDLE', limit=10)
        self.assertEqual(first['messages'], [])
        self.assertEqual(first['scanned'], 5000)
        self.assertTrue(first['scanLimited'])
        self.assertTrue(first['hasMore'])
        second = self.page(adapter, query='NEEDLE', limit=10, cursor=first['nextCursor'])
        self.assertEqual([row['text'] for row in second['messages']], ['needle oldest'])
        self.assertFalse(second['hasMore'])
        self.assertEqual(second['scanned'], 1105)
        self.assertEqual(len(adapter.call('messages', account=adapter.auth()['sourceId'], groupId=GROUP)['messages']), 200)

    def test_same_second_multishard_paging_dedupes_without_dropping_conflicts(self):
        rows = [{'local': i + 1, 'server': i + 100, 'time': STAMP,
                 'text': 'same second ' + str(i)} for i in range(120)]
        create_shard(self.root, rows=rows)
        create_shard(self.root, 'message/message_1.db', rows=rows)
        create_shard(self.root, 'biz_message/biz_message_0.db', rows=[
            {'local': 1, 'server': 100, 'time': STAMP, 'text': 'server conflict'},
            {'local': 2, 'server': 0, 'time': STAMP, 'text': 'local only'}])
        messages, pages = self.collect(self.adapter(), limit=17)
        self.assertEqual(len(messages), 122)
        self.assertEqual(len({row['id'] for row in messages}), 122)
        self.assertIn('server conflict', {row['text'] for row in messages})
        self.assertGreater(len(pages), 2)
        self.assertFalse(any('_contentHash' in row or '_raw' in row for row in messages))

    def test_date_includes_both_shanghai_midnight_boundaries(self):
        start = int(datetime(2026, 10, 2, tzinfo=timezone(timedelta(hours=8))).timestamp())
        create_shard(self.root, rows=[{'local': i + 1, 'time': stamp, 'text': str(stamp)} for i, stamp in enumerate(
            (start - 1, start, start + 86399, start + 86400))])
        messages, _ = self.collect(self.adapter(), startDate='2026-10-02', endDate='2026-10-02', limit=1)
        self.assertEqual({row['timestamp'] for row in messages}, {start, start + 86399})

    def test_sender_and_attachment_filename_and_nested_record_text_search(self):
        create_shard(self.root, rows=[
            {'local': 1, 'sender': 1, 'text': 'ordinary'},
            {'local': 2, 'sender': 2, 'type': 49, 'text': '<msg><appmsg><type>6</type><title>Budget_2026.xlsx</title></appmsg></msg>'},
            {'local': 3, 'sender': 1, 'type': 49, 'text': '<msg><appmsg><type>19</type><title>记录</title><recorditem>&lt;recordinfo&gt;&lt;datalist&gt;&lt;dataitem datatype="1"&gt;&lt;sourcename&gt;EmbeddedUser&lt;/sourcename&gt;&lt;datadesc&gt;NestedNeedle&lt;/datadesc&gt;&lt;/dataitem&gt;&lt;/datalist&gt;&lt;/recordinfo&gt;</recorditem></appmsg></msg>'}])
        adapter = self.adapter()
        self.assertEqual(len(self.page(adapter, query='合成联系人')['messages']), 1)
        self.assertEqual(self.page(adapter, query='BUDGET_2026')['messages'][0]['kind'], 'file')
        self.assertEqual(self.page(adapter, query='nestedneedle')['messages'][0]['kind'], 'record')

    @unittest.skipUnless(importlib.util.find_spec('zstandard'), 'zstandard unavailable in this interpreter')
    def test_searches_actual_zstd_decoded_body(self):
        import zstandard
        create_shard(self.root, rows=[{'text': 'uncompressed fallback is not the body',
                                     'compressed': zstandard.ZstdCompressor().compress('压缩内容唯一词'.encode())}])
        result = self.page(self.adapter(), query='唯一词')
        self.assertEqual(result['messages'][0]['text'], '压缩内容唯一词')
        self.assertEqual(result['messages'][0]['decodeStatus'], 'ok')

    def test_corrupt_compressed_content_returns_warning_without_raw_data(self):
        create_shard(self.root, rows=[{'compressed': b'\x28\xb5\x2f\xfdinvalid'}])
        result = self.page(self.adapter())
        self.assertEqual(result['messages'][0]['kind'], 'unsupported')
        self.assertTrue(result['warnings'])
        self.assertNotIn('_raw', result['messages'][0])

    def test_revoke_outside_date_and_same_second_older_local_id_hides_original(self):
        start = int(datetime(2026, 10, 2, tzinfo=timezone(timedelta(hours=8))).timestamp())
        create_shard(self.root, rows=[
            {'local': 20, 'server': 100, 'time': start, 'text': 'private original'},
            {'local': 30, 'server': 101, 'time': start, 'type': 49,
             'text': '<msg><appmsg><type>6</type><title>private.xlsx</title></appmsg></msg>'},
            {'local': 1, 'server': 102, 'type': 10002, 'time': start,
             'text': '<sysmsg><revokemsg><newmsgid>100</newmsgid><replacemsg>same second revoke</replacemsg></revokemsg></sysmsg>'},
            {'local': 2, 'server': 103, 'type': 10002, 'time': start + 86400,
             'text': '<sysmsg><revokemsg><newmsgid>101</newmsgid><replacemsg>next day revoke</replacemsg></revokemsg></sysmsg>'}])
        adapter = self.adapter()
        rows, _ = self.collect(adapter, limit=1, startDate='2026-10-02', endDate='2026-10-02')
        self.assertTrue(all(row['kind'] == 'revoke' for row in rows))
        self.assertFalse(any('media' in row for row in rows))
        self.assertEqual(self.page(adapter, query='private')['messages'], [])

    def test_bounded_revoke_prepass_continues_and_preserves_hidden_content(self):
        rows = [{'local': i + 1, 'server': i + 1, 'time': STAMP + i, 'type': 10000, 'text': 'system'} for i in range(5001)]
        rows += [{'local': 6000, 'server': 6000, 'time': STAMP - 1, 'text': 'secret'},
                 {'local': 6001, 'time': STAMP + 6001, 'type': 10002,
                  'text': '<sysmsg><revokemsg><newmsgid>6000</newmsgid></revokemsg></sysmsg>'}]
        create_shard(self.root, rows=rows)
        adapter = self.adapter()
        first = self.page(adapter, query='secret')
        self.assertEqual(first['messages'], [])
        self.assertEqual(first['scanned'], 5000)
        self.assertEqual(first['warnings'][-1]['code'], 'history_preparing_revocations')
        cursor = first['nextCursor']
        for _ in range(5):
            page = self.page(adapter, query='secret', cursor=cursor)
            self.assertEqual(page['messages'], [])
            if not page['hasMore']:
                break
            cursor = page['nextCursor']
        else:
            self.fail('bounded revoke prepass never completed')

    def test_cursor_conditions_account_conversation_revision_and_retry(self):
        create_shard(self.root, rows=[{'local': i + 1, 'time': STAMP + i, 'text': 'row'} for i in range(6)])
        create_shard(self.root, 'message/message_1.db', group=MIXED)
        adapter = self.adapter(source_id='account-a')
        first = self.page(adapter, limit=1)
        cursor = first['nextCursor']
        for change in ({'query': 'changed'}, {'limit': 2}, {'startDate': '2023-01-01'}):
            params = {'limit': 1, 'cursor': cursor, **change}
            with self.assertRaises(DatabaseError) as caught:
                self.page(adapter, **params)
            self.assertEqual(caught.exception.code, 'history_cursor_mismatch')
        with self.assertRaises(DatabaseError) as caught:
            adapter.call('message_history', account='account-b', groupId=GROUP, limit=1, cursor=cursor)
        self.assertEqual(caught.exception.code, 'source_changed')
        with self.assertRaises(DatabaseError) as caught:
            adapter.call('message_history', account='account-a', groupId=MIXED, limit=1, cursor=cursor)
        self.assertEqual(caught.exception.code, 'history_cursor_mismatch')
        second = self.page(adapter, limit=1, cursor=cursor)
        self.assertEqual(self.page(adapter, limit=1, cursor=cursor), second)
        adapter.configure(self.root, source_id='account-a', source_info={'revision': 'reloaded-revision'})
        with self.assertRaises(DatabaseError) as caught:
            self.page(adapter, limit=1, cursor=second['nextCursor'])
        self.assertEqual(caught.exception.code, 'history_cursor_expired')

    def test_cursor_ttl_and_cache_count_are_bounded(self):
        create_shard(self.root, rows=[{'local': i + 1, 'time': STAMP + i, 'text': 'row'} for i in range(3)])
        adapter = self.adapter()
        with patch('message_history.MAX_SESSIONS', 2), patch('message_history.time.monotonic', return_value=10):
            first = self.page(adapter, limit=1)
            self.page(adapter, limit=1)
            third = self.page(adapter, limit=1)
            self.assertEqual(len(adapter._state['history_sessions']), 2)
            with self.assertRaises(DatabaseError) as caught:
                self.page(adapter, limit=1, cursor=first['nextCursor'])
            self.assertEqual(caught.exception.code, 'history_cursor_expired')
        with patch('message_history.time.monotonic', return_value=10000):
            with self.assertRaises(DatabaseError) as caught:
                self.page(adapter, limit=1, cursor=third['nextCursor'])
            self.assertEqual(caught.exception.code, 'history_cursor_expired')

    def test_back_back_forward_replays_immutable_pages(self):
        create_shard(self.root, rows=[{'local': i + 1, 'time': STAMP + i, 'text': str(i)} for i in range(10)])
        adapter = self.adapter()
        first = self.page(adapter, limit=1)
        token2 = first['nextCursor']
        second = self.page(adapter, limit=1, cursor=token2)
        token3 = second['nextCursor']
        third = self.page(adapter, limit=1, cursor=token3)
        fourth = self.page(adapter, limit=1, cursor=third['nextCursor'])
        self.assertEqual(self.page(adapter, limit=1, cursor=token3), third)
        self.assertEqual(self.page(adapter, limit=1, cursor=token2), second)
        self.assertEqual(self.page(adapter, limit=1, cursor=token3), third)
        self.assertEqual(self.page(adapter, limit=1, cursor=third['nextCursor']), fourth)
        fifth = self.page(adapter, limit=1, cursor=fourth['nextCursor'])
        self.assertEqual(fifth['messages'][0]['text'], '5')

    def test_page_replay_cache_evicts_old_tokens(self):
        create_shard(self.root, rows=[{'local': i + 1, 'time': STAMP + i} for i in range(10)])
        adapter = self.adapter()
        first = self.page(adapter, limit=1)
        first_token = first['nextCursor']
        cursor = first_token
        with patch('message_history.MAX_CACHED_PAGES', 2):
            for _ in range(4):
                cursor = self.page(adapter, limit=1, cursor=cursor)['nextCursor']
            self.assertEqual(len(adapter._state['history_pages']), 2)
            with self.assertRaises(DatabaseError) as caught:
                self.page(adapter, limit=1, cursor=first_token)
            self.assertEqual(caught.exception.code, 'history_cursor_expired')

    def test_nonstandard_nontext_sysmsg_still_revokes(self):
        create_shard(self.root, rows=[
            {'local': 1, 'server': 100, 'time': STAMP, 'text': 'hidden original'},
            {'local': 2, 'time': STAMP + 1, 'type': 49,
             'text': '<sysmsg><revokemsg><newmsgid>100</newmsgid></revokemsg></sysmsg>'}])
        result, _ = self.collect(self.adapter(), limit=1, query='hidden')
        self.assertEqual(result, [])

    def test_revoke_state_has_a_byte_limit(self):
        create_shard(self.root, rows=[
            {'local': 1, 'server': 100, 'time': STAMP, 'text': 'hidden original'},
            {'local': 2, 'time': STAMP + 1, 'type': 10002,
             'text': '<sysmsg><revokemsg><newmsgid>100</newmsgid><replacemsg>long replacement</replacemsg></revokemsg></sysmsg>'}])
        adapter = self.adapter()
        with patch('message_history.MAX_REVOKE_BYTES', 1):
            with self.assertRaises(DatabaseError) as caught:
                self.page(adapter)
            self.assertEqual(caught.exception.code, 'history_state_limit')

    def test_page_cache_evicts_by_total_bytes_before_32_page_limit(self):
        # Use the supported 2 MiB page / 16 MiB cache relationship, rather than
        # patching the entire cache below a single valid page's size.
        create_shard(self.root, rows=[{'local': i + 1, 'time': STAMP + i, 'text': '汉' * 8000}
                                     for i in range(900)])
        adapter = self.adapter()
        first = self.page(adapter, limit=2000)
        oldest = cursor = first['nextCursor']
        request_count = 0
        while cursor:
            last_cursor = cursor
            page = self.page(adapter, limit=2000, cursor=cursor)
            request_count += 1
            self.assertLessEqual(sum(item['size'] for item in adapter._state['history_pages'].values()), 16 * 1024 * 1024)
            cursor = page['nextCursor']
        self.assertLess(request_count, 32)
        self.assertLess(len(adapter._state['history_pages']), request_count)
        with self.assertRaises(DatabaseError) as caught:
            self.page(adapter, limit=2000, cursor=oldest)
        self.assertEqual(caught.exception.code, 'history_cursor_expired')
        self.assertEqual(self.page(adapter, limit=2000, cursor=last_cursor), page)

    def test_full_text_match_before_summary_and_byte_limited_pages_have_no_gaps(self):
        create_shard(self.root, rows=[{'local': i + 1, 'server': i + 1, 'time': STAMP + i,
                                     'text': ('汉' * 16000) + 'FULL_TEXT_TAIL_' + str(i)} for i in range(150)])
        adapter = self.adapter()
        messages, pages = self.collect(adapter, query='FULL_TEXT_TAIL', limit=2000)
        self.assertEqual(len(messages), 150)
        self.assertEqual({row['localId'] for row in messages}, set(range(1, 151)))
        self.assertGreater(len(pages), 1)
        self.assertTrue(pages[0]['pageLimited'])
        self.assertTrue(all(row['textTruncated'] and len(row['text']) == 8000 for row in messages))
        self.assertTrue(all('FULL_TEXT_TAIL' not in row['text'] for row in messages))
        self.assertTrue(all(len(json.dumps(page, ensure_ascii=False).encode()) <= 2 * 1024 * 1024 for page in pages))
        self.assertLessEqual(sum(page['size'] for page in adapter._state['history_pages'].values()), 16 * 1024 * 1024)

    def test_last_pending_message_remains_available_when_raw_stream_ended(self):
        create_shard(self.root, rows=[{'local': i + 1, 'time': STAMP + i, 'text': 'x' * 8000} for i in range(4)])
        with patch('message_history.MAX_PAGE_BYTES', 30000):
            messages, pages = self.collect(self.adapter(), limit=2000)
        self.assertEqual({row['localId'] for row in messages}, {1, 2, 3, 4})
        self.assertFalse(pages[-1]['hasMore'])
        self.assertEqual(pages[-1]['nextCursor'], '')

    def test_cursor_cannot_be_imported_into_another_adapter(self):
        create_shard(self.root, rows=[{'local': i + 1, 'time': STAMP + i} for i in range(3)])
        first = self.page(self.adapter(source_id='same-id'), limit=1)
        with self.assertRaises(DatabaseError) as caught:
            self.page(self.adapter(source_id='same-id'), limit=1, cursor=first['nextCursor'])
        self.assertEqual(caught.exception.code, 'history_cursor_expired')

    def test_snapshot_mutation_refuses_continuation(self):
        path = create_shard(self.root, rows=[{'local': i + 1, 'time': STAMP + i} for i in range(3)])
        adapter = self.adapter()
        first = self.page(adapter, limit=1)
        with closing(sqlite3.connect(path)) as db:
            db.execute('CREATE TABLE mutation_marker(value)')
            db.commit()
        with self.assertRaises(DatabaseError) as caught:
            self.page(adapter, limit=1, cursor=first['nextCursor'])
        self.assertEqual(caught.exception.code, 'snapshot_changed')

    def test_validation_rejects_malformed_or_unbounded_input(self):
        for params in ({'limit': True}, {'limit': 0}, {'limit': 2001}, {'query': 'x' * 201},
                       {'query': 'line\nsecond'}, {'query': []}, {'cursor': 'x' * 10000},
                       {'cursor': '../bad'}, {'startDate': '2026-02-30'}, {'startDate': '10/02/2026'},
                       {'startDate': '2026-10-03', 'endDate': '2026-10-02'}, {'endDate': None}):
            with self.subTest(params=params), self.assertRaises(DatabaseError) as caught:
                validate_history_params(params)
            self.assertEqual(caught.exception.code, 'invalid_history_params')
        self.assertEqual(validate_history_params({'limit': '2000', 'query': ' Text '})['limit'], 2000)
        self.assertEqual(validate_history_params({'query': ' Text '})['query'], 'Text')

    def test_limit_strings_use_canonical_http_integer_syntax(self):
        for value in ('01', '0001', '+1', '1.0', ' 1', '1 ', '', '0', '-1', '2001'):
            with self.subTest(value=value):
                with self.assertRaises(DatabaseError) as caught:
                    validate_history_params({'limit': value})
                self.assertEqual(caught.exception.code, 'invalid_history_params')
        for value in ('1', '2000', 1, 2000):
            self.assertEqual(validate_history_params({'limit': value})['limit'], int(value))


if __name__ == '__main__':
    unittest.main()
