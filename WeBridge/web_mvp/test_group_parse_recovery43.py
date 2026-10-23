"""Invented malformed rows and mixed timestamp storage; no real account data."""
from contextlib import closing
import hashlib
import json
from pathlib import Path
import sqlite3
import struct
import tempfile
import unittest
import zlib

from offline_desktop import DesktopSession
from offline_review import REVIEW_CHECKS, inventory
from test_database_adapter import create_metadata, create_shard, GROUP, STAMP
from test_wecom_archive import fixture, pb


class GroupParseRecovery43Tests(unittest.TestCase):
    def setUp(self):
        temporary = tempfile.TemporaryDirectory(prefix='synthetic-parse43-')
        self.addCleanup(temporary.cleanup)
        self.base = Path(temporary.name)

    def source(self, client, rows=None):
        source = self.base / client
        if client == 'wechat':
            source.mkdir()
            create_metadata(source)
            create_shard(source, rows=rows)
        else:
            fixture(source)
        return source

    def session(self, source, client):
        session = DesktopSession(self.base / ('profile-' + client), client=client)
        self.assertEqual(session.open_source({'sourceRoot': str(source)})['status'], 'ready')
        return session

    @staticmethod
    def rows(parsed):
        return json.loads((Path(parsed['view']['viewRoot']) / 'messages.json').read_text(encoding='utf8'))

    def test_wechat_bad_fields_keep_all_rows_raw_evidence_and_stable_valid_references(self):
        source = self.source('wechat', [
            {'local': 1, 'text': '正常起始'},
            {'local': None, 'time': STAMP + 1, 'text': 'ID缺失但正文有效'},
            {'local': 3, 'time': None, 'text': '时间未知但正文有效'},
            {'local': 4, 'time': STAMP + 3, 'type': 'invalid', 'text': '类型异常原文'},
            {'local': 5, 'time': STAMP + 4, 'sender': 5, 'text': '发送人编码异常'},
            {'local': 6, 'time': STAMP + 5, 'server': 'invalid', 'text': '服务器编号异常'},
            {'local': 7, 'time': STAMP + 6, 'text': '正常结尾'},
        ])
        with closing(sqlite3.connect(source / 'message/message_0.db')) as db, db:
            db.execute('INSERT INTO Name2Id VALUES(?)', (b'\xff',))
        session = self.session(source, 'wechat')
        parsed = session.prepare_review(GROUP, start='2023-11-15', end='2023-11-15', copy_media=False)
        rows = self.rows(parsed)
        self.assertEqual(len(rows), 7)
        self.assertEqual(len({row['id'] for row in rows}), 7)
        self.assertTrue(rows[0]['id'].endswith('|1'))
        self.assertNotIn('rowid:', rows[0]['id'])
        missing_id = next(row for row in rows if row['rawColumns']['local_id'] is None)
        self.assertIn('|rowid:', missing_id['id'])
        self.assertEqual(missing_id['provenance']['sourceRowId'], 2)
        self.assertIsNone(missing_id['localId'])
        self.assertEqual(rows[-1]['text'], '时间未知但正文有效')
        self.assertIsNone(rows[-1]['timestamp'])
        invalid_sender = next(row for row in rows if row['localId'] == 5)
        self.assertEqual(invalid_sender['senderId'], '')
        self.assertEqual(invalid_sender['provenance']['senderValue'], {'encoding': 'base64', 'data': '/w=='})
        self.assertEqual(parsed['report']['parseStatuses']['invalid_metadata'], 5)
        self.assertEqual(parsed['report']['recordIssues']['unknownTimeRows'], 1)
        self.assertEqual(parsed['report']['recordIssues']['unknownTimeIncludedOutsideDateFilter'], 1)
        self.assertTrue(any('无法确认是否位于所选日期范围' in warning for warning in parsed['report']['warnings']))
        text = (Path(parsed['view']['viewRoot']) / '解析结果.md').read_text(encoding='utf8')
        self.assertIn('无法确认是否位于所选日期范围', text)
        self.assertIn('字段异常', (Path(parsed['view']['viewRoot']) / 'messages.md').read_text(encoding='utf8'))
        analysis_root = Path(parsed['view']['viewRoot']) / 'analysis'
        corpus = [json.loads(line) for line in (analysis_root / 'corpus.jsonl').read_text(encoding='utf8').splitlines()]
        unknown = next(row for row in corpus if row['id'] == rows[-1]['id'])
        self.assertEqual(unknown['metadataIssues'], ['create_time'])
        self.assertEqual(unknown['parseStatus'], 'invalid_metadata')
        self.assertEqual(unknown['contentParseStatus'], 'ok')
        part = (analysis_root / unknown['chunk']).read_text(encoding='utf8')
        self.assertIn('字段异常：create_time', part)
        self.assertIn('时间未知', part)
        session.approve_review(parsed['review']['reviewId'], {key: True for key in REVIEW_CHECKS}, chat=GROUP)
        exported = session.export_reviewed([GROUP])
        self.assertEqual(exported['state'], 'completed')
        self.assertEqual(json.loads((Path(exported['exports'][0]['output']) / 'messages.json').read_text(encoding='utf8')), rows)

    def test_wecom_mixed_seconds_milliseconds_and_unknown_time_preserve_range_and_order(self):
        source = self.source('wecom')
        with closing(sqlite3.connect(source / 'message.db')) as db, db:
            body = db.execute('SELECT content FROM message_table WHERE message_id=1').fetchone()[0]
            db.execute('UPDATE message_table SET send_time=? WHERE message_id=1', ((STAMP + 1) * 1000,))
            for mid, stamp in ((3, 'invalid'), (4, None), (5, (STAMP + 3) * 1000)):
                db.execute('INSERT INTO message_table VALUES(?,?,?,?,?,?,?,?,?,?,?)',
                           (mid, mid + 10, mid, 11, 'R:synthetic', 2, stamp, 0, body, b'', b''))
            db.execute('CREATE TABLE message_small_table AS SELECT * FROM message_table WHERE message_id=5')
            db.execute('UPDATE message_small_table SET message_id=6,send_time=?', (STAMP + 2,))
        session = self.session(source, 'wecom')
        parsed = session.prepare_review('R:synthetic', start='2023-11-15', end='2023-11-15', copy_media=False)
        rows = self.rows(parsed)
        self.assertEqual([row['localId'] for row in rows], [1, 2, 6, 5, 3, 4])
        self.assertEqual([row['timestamp'] for row in rows], [STAMP + 1, STAMP + 2, STAMP + 2, STAMP + 3, None, None])
        self.assertEqual(rows[0]['rawColumns']['send_time'], (STAMP + 1) * 1000)
        self.assertEqual(rows[-2]['rawColumns']['send_time'], 'invalid')
        self.assertEqual(parsed['report']['recordIssues']['unknownTimeIncludedOutsideDateFilter'], 2)
        self.assertEqual(parsed['report']['parseStatuses']['invalid_metadata'], 2)
        outside = session.prepare_review('R:synthetic', start='2099-01-01', end='2099-01-01', copy_media=False)
        self.assertEqual([row['localId'] for row in self.rows(outside)], [3, 4])

    def test_wechat_normalized_multishard_order_and_out_of_range_time_are_retained(self):
        source = self.source('wechat', [{'local': 1, 'time': STAMP + 5}, {'local': 2, 'time': None}])
        create_shard(source, relative='message/message_1.db', rows=[
            {'local': 3, 'time': STAMP + 2}, {'local': 4, 'time': 2 ** 63 - 1}])
        parsed = self.session(source, 'wechat').prepare_review(GROUP, copy_media=False)
        rows = self.rows(parsed)
        self.assertEqual([row['localId'] for row in rows], [3, 1, 2, 4])
        self.assertEqual(parsed['report']['recordIssues']['unknownTimeRows'], 2)
        self.assertTrue(all(row['timestamp'] is None for row in rows[-2:]))

    def test_wecom_bad_metadata_preserves_raw_values_and_unknown_sender_is_not_incoming(self):
        source = self.source('wecom')
        with closing(sqlite3.connect(source / 'message.db')) as db, db:
            db.execute('UPDATE message_table SET message_id=NULL,content_type=?,sender_id=? WHERE message_id=1',
                       ('invalid', b'\xff'))
        session = DesktopSession(self.base / 'profile-wecom', client='wecom')
        session.open_source({'sourceRoot': str(source), 'selfId': '11'})
        parsed = session.prepare_review('R:synthetic', copy_media=False)
        rows = self.rows(parsed)
        self.assertEqual(len(rows), 2)
        bad = rows[0]
        self.assertEqual(bad['id'], 'message.db|message_table|rowid:1')
        self.assertEqual(bad['parseStatus'], 'invalid_metadata')
        self.assertEqual(set(bad['metadataIssues']), {'message_id', 'content_type', 'sender_id'})
        self.assertEqual(bad['rawColumns']['sender_id'], {'encoding': 'base64', 'data': '/w=='})
        self.assertEqual(bad['rawColumns']['content_type'], 'invalid')
        self.assertIsNone(bad['isSelf'])
        self.assertEqual(bad['direction'], 'unknown')
        self.assertEqual(bad['senderIdentityBasis'], 'unknown')
        self.assertTrue(rows[1]['isSelf'])

    def test_wecom_uniform_milliseconds_and_subsecond_tables_merge_in_normalized_order(self):
        source = self.source('wecom')
        with closing(sqlite3.connect(source / 'message.db')) as db, db:
            db.execute('UPDATE message_table SET send_time=?', ((STAMP + 1) * 1000,))
            db.execute('CREATE TABLE message_small_table AS SELECT * FROM message_table')
            db.execute('UPDATE message_small_table SET message_id=3,send_time=? WHERE message_id=1',
                       ((STAMP + 1) * 1000 + 900,))
            db.execute('UPDATE message_small_table SET message_id=4,send_time=? WHERE message_id=2',
                       ((STAMP + 1) * 1000 + 100,))
        session = self.session(source, 'wecom')
        parsed = session.prepare_review('R:synthetic', start='2023-11-15', end='2023-11-15', copy_media=False)
        rows = self.rows(parsed)
        self.assertEqual([row['localId'] for row in rows], [1, 2, 3, 4])
        self.assertEqual([row['timestamp'] for row in rows], [STAMP + 1] * 4)
        outside = session.prepare_review('R:synthetic', start='2099-01-01', end='2099-01-01', copy_media=False)
        self.assertEqual(self.rows(outside), [])

    def test_wecom_oversized_image_only_marks_that_attachment_unavailable(self):
        from PIL import Image
        account = self.base / 'account'
        account.mkdir()
        source = account / 'Data'
        fixture(source)
        cached = account / 'Cache/Image/huge.png'
        cached.parent.mkdir(parents=True)
        Image.new('RGB', (1, 1)).save(cached)
        data = bytearray(cached.read_bytes())
        data[16:24] = struct.pack('>II', 20000, 20000)
        data[29:33] = struct.pack('>I', zlib.crc32(data[12:29]))
        cached.write_bytes(data)
        content = pb(4, len(data)) + pb(5, 20000) + pb(6, 20000) + pb(10, hashlib.md5(data).hexdigest())
        with closing(sqlite3.connect(source / 'message.db')) as db, db:
            db.execute('INSERT INTO message_table VALUES(?,?,?,?,?,?,?,?,?,?,?)',
                       (3, 13, 3, 11, 'R:synthetic', 14, STAMP + 3, 0, content, b'', pb(1, str(cached))))
        parsed = self.session(source, 'wecom').prepare_review('R:synthetic', copy_media=True)
        rows = self.rows(parsed)
        self.assertEqual(len(rows), 3)
        self.assertEqual(rows[-1]['asset']['status'], 'unavailable')
        self.assertEqual(rows[-1]['asset']['reasonCode'], 'image_pixel_limit')
        self.assertIn('像素', rows[-1]['asset']['reason'])
        self.assertEqual(parsed['report']['mediaSummary']['images']['missing'], 1)
        self.assertFalse(any('huge.png' in item['path'] for item in inventory(Path(parsed['view']['viewRoot']))))


if __name__ == '__main__':
    unittest.main()
