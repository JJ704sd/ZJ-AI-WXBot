"""Regressions derived from audited structures; all records are invented."""
from contextlib import closing
import hashlib
import json
from pathlib import Path
import sqlite3
import tempfile
import unittest
from unittest.mock import patch

from test_wecom_archive import fixture, pb
from wecom_content import typed_message
from wecom_archive import WeComArchive
from wecom_media import WeComMedia
from offline_quality import ContentQuality
from offline_documents import extract_document, ContentIssue


class Media46Tests(unittest.TestCase):
    def setUp(self):
        temp = tempfile.TemporaryDirectory(prefix='synthetic-media46-')
        self.addCleanup(temp.cleanup)
        self.root = Path(temp.name)
        self.cache = self.root / 'Cache'
        self.cache.mkdir()
        self.output = self.root / 'output'
        self.output.mkdir()
        self.search = WeComMedia({'sourceRoot': str(self.root)})

    def node(self, data):
        return {'kind': 'file', 'media': {'filename': 'report.txt', 'md5': hashlib.md5(data).hexdigest()}}

    def test_fallback_visits_files_outside_fast_index(self):
        data = b'late matching file'
        path = self.cache / 'late.bin'
        path.write_bytes(data)
        self.search.indexed = True  # Fast index has already stopped before this file.
        asset = self.search.attach(self.node(data), self.output)
        self.assertEqual(asset['status'], 'ready')
        self.assertEqual((self.output / asset['path']).read_bytes(), data)

    def test_cross_export_reuses_digests_and_refreshes_changed_new_deleted_files(self):
        old = self.cache / 'old.bin'
        old.write_bytes(b'old')
        list(self.search._fallback(self.node(b'absent')['media']))
        self.search.begin_export()
        list(self.search._fallback(self.node(b'absent')['media']))
        self.assertEqual(self.search.report()['diagnostics'].get('hashCacheReused'), 1)
        self.assertEqual(self.search.report()['diagnostics'].get('hashBytesRead', 0), 0)
        old.write_bytes(b'new-content')
        fresh = self.cache / 'fresh.bin'
        fresh.write_bytes(b'fresh')
        self.search.begin_export()
        self.assertEqual(self.search.attach(self.node(b'new-content'), self.output)['status'], 'ready')
        self.assertEqual(self.search.attach(self.node(b'fresh'), self.output)['status'], 'ready')
        old.unlink()
        self.search.begin_export()
        self.assertEqual(list(self.search._fallback(self.node(b'new-content')['media'])), [])

    def test_large_original_is_streamed_without_preview_decode_limit(self):
        (self.cache / 'large.bin').write_bytes(b'oversize')
        with patch('wecom_media.LIMIT', 4):
            result = self.search.attach(self.node(b'oversize'), self.output)
        self.assertEqual(result['status'],'ready')
        self.assertEqual((self.output/result['path']).read_bytes(),b'oversize')


class Content46Tests(unittest.TestCase):
    def test_export_includes_missing_file_in_embedded_quote_recovery_list(self):
        temp = tempfile.TemporaryDirectory(prefix='synthetic-export46-')
        self.addCleanup(temp.cleanup)
        root = Path(temp.name)
        fixture(root / 'Data')
        (root / 'Data/manifest.json').write_text('{}')
        file = pb(2, 'missing.pdf') + pb(4, 42) + pb(10, 'a'*32)
        extra = pb(1002, pb(1, pb(1, 11) + pb(2, 1700000001) + pb(5, 20) + pb(103, file)))
        with closing(sqlite3.connect(root / 'Data/message.db')) as db, db:
            db.execute('UPDATE message_table SET extra_content=? WHERE message_id=1', (extra,))
        archive = WeComArchive(root / 'Data', media_config={'sourceRoot': str(root / 'Data')})
        report = archive.export(root / 'export', chat_id='R:synthetic', copy_media=True)
        gaps = [json.loads(line) for line in (root / 'export/media-recovery.jsonl').read_text(encoding='utf8').splitlines()]
        self.assertTrue(any(entry['kind']=='file' and entry['context']==['引用来源'] for entry in gaps))
        self.assertTrue((root / 'export' / report['contentQuality']['csvFile']).is_file())
    def test_nested_quote_file_gap_and_spreadsheet_safety(self):
        temp = tempfile.TemporaryDirectory(prefix='synthetic-quality46-')
        self.addCleanup(temp.cleanup)
        root = Path(temp.name)
        row = {'id': '=invented-id', 'chatId': 'invented-chat', 'text': '=SUM(A1:A2)',
               'kind': 'quote', 'parseStatus': 'ok', 'quote': {'sourceLinkStatus': 'source_not_found',
               'message': {'kind': 'record', 'parseStatus': 'ok', 'record': {'items': [
                   {'kind': 'file', 'media': {'filename': '=danger.pdf'}, 'asset': {'status': 'ready'},
                    'attachmentContent': {'fileStatus': 'ready', 'extractionStatus': 'encrypted', 'format': '.pdf'}}]}}}}
        with ContentQuality(root) as quality:
            quality.add(row)
            result = quality.finish()
        entries = [json.loads(line) for line in (root / result['jsonlFile']).read_text(encoding='utf8').splitlines()]
        self.assertEqual(result['quoteLinks']['unlinked'], 1)
        self.assertEqual(entries[1]['issues'], ['document_encrypted'])
        self.assertEqual(entries[1]['nodePath'], [['quote', 0], ['record', 0]])
        self.assertIn("'=danger.pdf", (root / result['csvFile']).read_text(encoding='utf-8-sig'))
        self.assertIn('合法密码', entries[1]['actions'][0])

    def test_pdf_empty_password_readable_and_real_password_remains_encrypted(self):
        from pypdf import PdfWriter
        temp = tempfile.TemporaryDirectory(prefix='synthetic-pdf46-')
        self.addCleanup(temp.cleanup)
        for password in ('', 'synthetic-password'):
            path = Path(temp.name) / ('empty.pdf' if not password else 'locked.pdf')
            writer = PdfWriter()
            writer.add_blank_page(width=100, height=100)
            writer.encrypt(password)
            writer.write(path)
            if password:
                with self.assertRaises(ContentIssue) as raised:
                    extract_document(path, '.pdf')
                self.assertEqual(raised.exception.status, 'encrypted')
            else:
                self.assertEqual(extract_document(path, '.pdf')['extractionStatus'], 'no_text')

    def test_observed_media_variants_and_invalid_variant(self):
        image = typed_message(pb(4, 42) + pb(5, 100) + pb(6, 200) + pb(10, 'a'*32), 101)
        file = typed_message(pb(2, 'report.pdf') + pb(4, 42) + pb(10, 'b'*32), 102)
        self.assertEqual((image['kind'], image['media']['md5']), ('image', 'a'*32))
        self.assertEqual((file['kind'], file['media']['filename']), ('file', 'report.pdf'))
        self.assertNotEqual(typed_message(pb(2, 'secret opaque field'), 102)['parseStatus'], 'ok')

    def test_actual_quote_identifier_without_type_resolves_with_strict_source_guards(self):
        temp = tempfile.TemporaryDirectory(prefix='synthetic-quote46-')
        self.addCleanup(temp.cleanup)
        root = Path(temp.name)
        fixture(root / 'Data')
        (root / 'Data/manifest.json').write_text('{}')
        key = 'syntheticOpaqueKey=='
        with closing(sqlite3.connect(root / 'Data/message.db')) as db, db:
            db.execute('UPDATE message_table SET extra_content=? WHERE message_id=1', (pb(3045, pb(3, pb(3, key))),))
        archive = WeComArchive(root / 'Data', media_config={'sourceRoot': str(root / 'Data')})
        def reply(sender=11):
            row = typed_message(pb(1, pb(1, 0)+pb(2, pb(1, 'reply'))), 2,
                extra=pb(1002, pb(1, pb(1, sender)+pb(2, 1700000001)+pb(16, key))))
            row.update(id='reply', chatId='R:synthetic', decodeStatus='partially_supported')
            return row
        row = reply()
        self.assertEqual(row['quote']['sourceIdentifier'], key)
        archive._link_quote(row, root, False)
        self.assertEqual(row['quote']['sourceLinkStatus'], 'matched_local_source')
        self.assertEqual(row['parseStatus'], 'ok')
        bad = reply(99)
        archive._link_quote(bad, root, False)
        self.assertEqual(bad['quote']['sourceLinkStatus'], 'source_not_found')
        envelope = typed_message(pb(1, pb(1, 0)+pb(2, pb(1, 'reply'))), 2,
            extra=pb(1002, pb(1, pb(1, 11)+pb(2, 1700000001))+pb(2, key)))
        envelope.update(id='envelope-reply', chatId='R:synthetic', decodeStatus='partially_supported')
        archive._link_quote(envelope, root, False)
        self.assertEqual(envelope['quote']['sourceLinkStatus'], 'matched_local_source')
        mismatch = reply()
        mismatch['quote']['contentSha256'] = 'f'*64
        archive._link_quote(mismatch, root, False)
        self.assertEqual(mismatch['quote']['sourceLinkStatus'], 'source_not_found')


if __name__ == '__main__':
    unittest.main()
