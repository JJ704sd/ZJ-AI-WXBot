"""Reference equivalence across source tables and groups; all records invented."""
from contextlib import closing
import hashlib
import sqlite3
import tempfile
from pathlib import Path
import unittest

from wecom_archive import WeComArchive
from test_wecom_archive import fixture, pb


class GroupQuote44Tests(unittest.TestCase):
    def setUp(self):
        temporary = tempfile.TemporaryDirectory(prefix='synthetic-quotes44-')
        self.addCleanup(temporary.cleanup)
        self.root = Path(temporary.name)
        self.source = self.root / 'Data'
        fixture(self.source)
        (self.source / 'manifest.json').write_text('{}', encoding='utf8')
        self.token = 'a' * 32
        self.extra = pb(3045, pb(1, self.token))

    def archive(self):
        return WeComArchive(self.source, media_config={'sourceRoot': str(self.source)})

    def quote(self, chat='R:synthetic', digest=None):
        result = {'id': 'synthetic-reply', 'chatId': chat, 'parseStatus': 'partial_quote',
                  'quote': {'sourceToken': self.token, 'sourceType': 2, 'senderId': '11',
                            'sourceTimestamp': 1700000001, 'resolutionStatus': 'unresolved',
                            'message': {'kind': 'unknown', 'text': ''}}}
        if digest:
            result['quote']['contentSha256'] = digest
        return result

    def test_duplicate_tokens_across_tables_keep_content_match_and_ambiguity(self):
        alternate = pb(1, pb(1, 0) + pb(2, pb(1, 'second table source')))
        with closing(sqlite3.connect(self.source / 'message.db')) as db, db:
            db.execute('UPDATE message_table SET extra_content=? WHERE message_id=1', (self.extra,))
            db.execute('CREATE TABLE message_small_table AS SELECT * FROM message_table WHERE message_id=1')
            db.execute('UPDATE message_small_table SET message_id=50,send_time=?,content=?',
                       (1700000001000, alternate))
        archive = self.archive()
        matched = self.quote(digest=hashlib.sha256(alternate).hexdigest())
        archive._link_quote(matched, self.root, False)
        quote = matched['quote']
        self.assertEqual(quote['sourceLinkStatus'], 'matched_local_source')
        self.assertEqual(quote['sourceMessageId'], 'message.db|message_small_table|50')
        self.assertEqual(quote['sourceProvenance'], {'database': 'message.db', 'table': 'message_small_table',
                                                   'localId': 50, 'sourceRowId': 1})
        self.assertEqual(quote['message']['text'], 'second table source')
        self.assertEqual(quote['message']['timestamp'], 1700000001)
        self.assertEqual(matched['parseStatus'], 'ok')
        ambiguous = self.quote()
        archive._link_quote(ambiguous, self.root, False)
        self.assertEqual(ambiguous['quote']['sourceLinkStatus'], 'ambiguous_source')
        self.assertNotIn('sourceMessageId', ambiguous['quote'])
        mismatch = self.quote(digest='f' * 64)
        archive._link_quote(mismatch, self.root, False)
        self.assertEqual(mismatch['quote']['sourceLinkStatus'], 'source_not_found')

    def test_reusing_archive_between_groups_cannot_reuse_other_group_candidates(self):
        with closing(sqlite3.connect(self.source / 'session.db')) as db, db:
            db.execute('INSERT INTO conversation_table VALUES(?,?,?,?)', ('R:second', 'Second group', '', 1700000001))
        with closing(sqlite3.connect(self.source / 'message.db')) as db, db:
            db.execute('UPDATE message_table SET extra_content=? WHERE message_id=1', (self.extra,))
            db.execute('INSERT INTO message_table SELECT 99,99,99,sender_id,?,content_type,send_time,flag,content,extra_content,local_extra_content '
                       'FROM message_table WHERE message_id=1', ('R:second',))
            db.execute('CREATE TABLE kf_message_tableV1 AS SELECT message_id,server_id,sender_id,conversation_id,'
                       'content_type,send_time,content FROM message_table')
        archive = self.archive()
        for chat, local in (('R:synthetic', 1), ('R:second', 99), ('R:synthetic', 1)):
            with self.subTest(chat=chat):
                reply = self.quote(chat)
                archive._link_quote(reply, self.root, False)
                self.assertEqual(reply['quote']['sourceLinkStatus'], 'matched_local_source')
                self.assertEqual(reply['quote']['sourceMessageId'], 'message.db|message_table|' + str(local))


if __name__ == '__main__':
    unittest.main()
