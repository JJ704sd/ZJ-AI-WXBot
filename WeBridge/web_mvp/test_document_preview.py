import tempfile
import unittest
import zipfile
from pathlib import Path
from document_preview import preview, W, S, R


class DocumentPreviewTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.path = Path(self.temp.name)/'asset.blob'

    def package(self, files):
        with zipfile.ZipFile(self.path, 'w') as archive:
            for name, text in files.items(): archive.writestr(name, text)

    def test_word_paragraph_and_table(self):
        self.package({'word/document.xml': f'<w:document xmlns:w="{W[1:-1]}"><w:body><w:p><w:r><w:t>中文</w:t><w:br/><w:t>正文</w:t></w:r></w:p><w:tbl><w:tr><w:tc><w:p><w:r><w:t>表格</w:t></w:r></w:p></w:tc></w:tr></w:tbl></w:body></w:document>'})
        data = preview(self.path, '测试.docx')
        self.assertEqual(data['blocks'], [{'text':'中文\n正文'}, {'rows':[['表格']]}])

    def test_excel_multiple_sheets_and_inert_formula(self):
        self.package({'xl/workbook.xml':f'<workbook xmlns="{S[1:-1]}" xmlns:r="{R[1:-1]}"><sheets><sheet name="一" r:id="r1"/><sheet name="二" r:id="r2"/></sheets></workbook>',
            'xl/_rels/workbook.xml.rels':'<Relationships><Relationship Id="r1" Type="a/worksheet" Target="worksheets/sheet1.xml"/><Relationship Id="r2" Type="a/worksheet" Target="worksheets/sheet2.xml"/></Relationships>',
            'xl/worksheets/sheet1.xml':f'<worksheet xmlns="{S[1:-1]}"><sheetData><row><c r="D8"><f>1+2</f><v>3</v></c></row></sheetData></worksheet>',
            'xl/worksheets/sheet2.xml':f'<worksheet xmlns="{S[1:-1]}"><sheetData><row><c r="A1" t="inlineStr"><is><t>中文</t></is></c></row></sheetData></worksheet>'})
        sheets = preview(self.path, '测试.xlsx')['sheets']
        self.assertEqual(len(sheets), 2)
        self.assertEqual(sheets[0]['rows'][0][0], {'ref':'D8', 'text':'3 [公式: =1+2]'})
        self.assertEqual(sheets[1]['rows'][0][0]['text'], '中文')

    def test_text_encoding_and_limit(self):
        self.path.write_bytes('中文'.encode('gb18030'))
        self.assertEqual(preview(self.path, 'a.md')['text'], '中文')
        self.path.write_text('a'*200001, encoding='utf-8')
        self.assertTrue(preview(self.path, 'a.md')['truncated'])

    def test_reject_entities_and_bad_archive(self):
        self.package({'word/document.xml':'<!DOCTYPE x [<!ENTITY y "x">]><x/>'})
        with self.assertRaises(ValueError): preview(self.path, 'a.docx')
        self.path.write_bytes(b'not zip')
        with self.assertRaises(ValueError): preview(self.path, 'a.xlsx')
        self.assertEqual(preview(self.path, 'a.doc')['kind'], 'unsupported')

    def test_reject_large_expanded_archive(self):
        self.package({'padding': 'a'*(25*1024*1024)})
        with self.assertRaises(ValueError): preview(self.path, 'a.docx')

    def test_http_uses_authorized_asset_and_rechecks(self):
        import json
        import threading
        from http.server import ThreadingHTTPServer
        from urllib.request import urlopen
        from urllib.error import HTTPError
        from server import make_handler
        self.path.write_text('# 本机预览', encoding='utf-8')
        asset_path = self.path
        class Cache:
            calls = 0
            def get(self, asset_id, account):
                self.calls += 1
                if (asset_id, account) != ('sample', 'allowed'): raise ValueError('禁止访问')
                return {'path':asset_path, 'public':{'filename':'sample.md'}}
        cache = Cache()
        server = ThreadingHTTPServer(('127.0.0.1', 0), make_handler(None, None, '', 0, media_cache=cache))
        port = server.server_port
        server.RequestHandlerClass = make_handler(None, None, '', port, media_cache=cache)
        thread = threading.Thread(target=server.serve_forever, daemon=True)
        thread.start()
        try:
            with urlopen(f'http://127.0.0.1:{port}/api/document-preview?id=sample&account=allowed') as response:
                self.assertEqual(json.load(response)['text'], '# 本机预览')
            self.assertEqual(cache.calls, 2)
            with self.assertRaises(HTTPError) as caught:
                urlopen(f'http://127.0.0.1:{port}/api/document-preview?id=sample&account=wrong')
            self.assertEqual(caught.exception.code, 400)
            caught.exception.close()
        finally:
            server.shutdown(); server.server_close(); thread.join()


if __name__ == '__main__': unittest.main()
