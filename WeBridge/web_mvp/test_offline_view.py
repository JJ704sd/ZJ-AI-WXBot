"""Attachment viewer checks use only temporary synthetic files."""
import hashlib
import json
from pathlib import Path
import tempfile
import unittest

from offline_chat import ArchiveError
from offline_view import attachment_path, document_path, read_image, ConversationView


class AttachmentViewTests(unittest.TestCase):
    def test_media_gap_filters_include_quoted_and_nested_forwarded_sources(self):
        with tempfile.TemporaryDirectory() as folder:
            root = Path(folder)
            (root / 'manifest.json').write_text('{}', encoding='utf8')
            rows = [
                {'id':'quoted-image', 'kind':'quote', 'quote':{'message':{'kind':'image','asset':{'status':'unavailable'}}}},
                {'id':'nested-file', 'kind':'record', 'record':{'items':[{'kind':'quote','quote':{
                    'message':{'kind':'file','asset':{'status':'pending'}}}}]}},
                {'id':'ready-image', 'kind':'image','asset':{'status':'ready'}},
            ]
            (root / 'messages.jsonl').write_text(''.join(json.dumps(row)+'\n' for row in rows), encoding='utf8')
            view = ConversationView(root)
            self.assertEqual([row['id'] for row in view.page(kind='missing_images')['messages']], ['quoted-image'])
            self.assertEqual([row['id'] for row in view.page(kind='missing_media')['messages']], ['quoted-image','nested-file'])

    def test_large_pages_and_keyword_search_keep_target_message_context(self):
        with tempfile.TemporaryDirectory() as folder:
            root = Path(folder)
            (root / 'manifest.json').write_text('{}', encoding='utf8')
            rows = [{'id': str(index), 'kind': 'text', 'senderName': '合成发送人', 'text': '普通消息'} for index in range(650)]
            rows[50].update(kind='record', record={'items': [{'kind':'text','text':'转发内业务需求','senderName':'内嵌发送人'}]})
            rows[600].update(kind='file', attachmentContent={'text':'附件正文中的业务需求'})
            (root / 'messages.jsonl').write_text(''.join(json.dumps(row,ensure_ascii=False)+'\n' for row in rows), encoding='utf8')
            view = ConversationView(root)
            self.assertEqual(len(view.page(page_size=300)['messages']), 300)
            first = view.page(0, page_size=500)
            last = view.page(500, page_size=500)
            self.assertEqual([r['id'] for r in first['messages']+last['messages']], [str(i) for i in range(650)])
            found = view.page(query='业务需求', page_size=300)
            self.assertEqual(found['total'], 2)
            self.assertEqual([row['id'] for row in found['messages']], ['50','600'])
            self.assertEqual(found['messages'][0]['record']['items'][0]['senderName'], '内嵌发送人')
            self.assertEqual(view.page(query='不存在')['total'], 0)
            self.assertEqual(view.page(query='')['total'], 650)
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name).resolve()
        (self.root / 'assets').mkdir()

    def asset(self, data, name='report.pdf'):
        digest = hashlib.sha256(data).hexdigest()
        relative = 'assets/' + digest + Path(name).suffix
        (self.root / relative).write_bytes(data)
        return {'path': relative, 'status': 'ready', 'digest': digest, 'size': len(data), 'filename': name}

    def test_document_uses_original_name_and_unchanged_content(self):
        data = b'%PDF-1.7\nSynthetic document'
        asset = self.asset(data, '合成报告.pdf')
        opened = document_path(self.root, asset)
        self.assertEqual(opened.name, '合成报告.pdf')
        self.assertEqual(opened.read_bytes(), data)
        self.assertEqual(document_path(self.root, asset), opened)
        opened.write_bytes(b'changed')
        with self.assertRaisesRegex(ArchiveError, '已变化'):
            document_path(self.root, asset)

    def test_tampered_or_external_asset_cannot_be_opened(self):
        asset = self.asset(b'original')
        (self.root / asset['path']).write_bytes(b'tampered')
        with self.assertRaises(ArchiveError):
            attachment_path(self.root, asset)
        external = self.root / 'private.pdf'
        external.write_bytes(b'original')
        asset['path'] = 'assets/../private.pdf'
        with self.assertRaises(ArchiveError):
            attachment_path(self.root, asset)

    def test_program_attachments_are_not_executed_by_open_button(self):
        asset = self.asset(b'synthetic executable', 'program.exe')
        with self.assertRaisesRegex(ArchiveError, '直接查看方式'):
            document_path(self.root, asset)

    def test_image_is_decoded_and_fits_preview_bounds(self):
        from io import BytesIO
        from PIL import Image
        buffer = BytesIO()
        Image.new('RGB', (1600, 800), '#4285f4').save(buffer, format='JPEG')
        asset = self.asset(buffer.getvalue(), 'image.jpg')
        image = read_image(self.root, asset, (400, 300))
        self.assertEqual(image.size, (400, 200))
        self.assertEqual(image.mode, 'RGBA')


if __name__ == '__main__':
    unittest.main()
