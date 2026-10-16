"""Attachment viewer checks use only temporary synthetic files."""
import hashlib
from pathlib import Path
import tempfile
import unittest

from offline_chat import ArchiveError
from offline_view import attachment_path, document_path, read_image


class AttachmentViewTests(unittest.TestCase):
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
