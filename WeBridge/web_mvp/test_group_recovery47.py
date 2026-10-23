"""Content recovery regressions; all documents and account records are invented."""
from contextlib import closing
import hashlib
import io
import json
import os
from pathlib import Path
import sqlite3
import subprocess
import tempfile
import unittest
from unittest.mock import patch

from offline_documents import extract_document, ContentIssue, AttachmentExtractor, read_passwords
from offline_supplements import SupplementalMedia
from test_offline_documents import pdf_file, office_file
from test_wecom_archive import fixture, pb


class Recovery47Tests(unittest.TestCase):
    def setUp(self):
        temp = tempfile.TemporaryDirectory(prefix='synthetic-recovery47-')
        self.addCleanup(temp.cleanup)
        self.root = Path(temp.name).resolve()

    def row(self, data=b'original', name='quote.txt', kind='file'):
        return {'id':'synthetic-message','chatId':'R:synthetic','chatName':'合成群','kind':kind,
                'media':{'filename':name,'md5':hashlib.md5(data).hexdigest()},
                'asset':{'status':'unavailable','reason':'not_cached'}}

    def test_supplement_digest_not_filename_and_recheck_new_changed_files(self):
        source = self.root/'supplement';source.mkdir()
        (source/'quote.txt').write_bytes(b'wrong same filename')
        (source/'renamed.bin').write_bytes(b'original')
        target = self.root/'output';target.mkdir()
        search = SupplementalMedia(source)
        row = self.row();search.attach(row,target)
        self.assertEqual((target/row['asset']['path']).read_bytes(),b'original')
        self.assertEqual(row['asset']['source'],'user_supplement')
        search.begin_export()
        (source/'renamed.bin').write_bytes(b'changed')
        (source/'new.txt').write_bytes(b'new')
        absent = self.row();search.attach(absent,target)
        self.assertEqual(absent['asset']['status'],'unavailable')
        new = self.row(b'new');search.attach(new,target)
        self.assertEqual(new['asset']['status'],'ready')
        self.assertGreater(search.report().get('reused',0),0)

    def test_changed_after_scan_is_not_copied(self):
        source=self.root/'supplement';source.mkdir()
        (source/'original').write_bytes(b'original')
        target=self.root/'output';target.mkdir()
        search=SupplementalMedia(source);search._scan(target)
        (source/'original').write_bytes(b'changed')
        row=self.row();search.attach(row,target)
        self.assertEqual(row['asset']['status'],'unavailable')
        self.assertEqual(list((target/'assets').iterdir()),[])

    def test_wrong_password_missing_password_and_correct_pdf(self):
        path=self.root/'encrypted.pdf';pdf_file(path,encrypted=True)
        for password,expected in ((None,'encrypted'),('wrong','password_rejected')):
            with self.assertRaises(ContentIssue) as raised:extract_document(path,'.pdf',password=password)
            self.assertEqual(raised.exception.status,expected)
        value=extract_document(path,'.pdf',password='unprovided-password')
        self.assertIn('PDF business requirement',value['text'])
        self.assertEqual(value['decryption']['status'],'opened')
        self.assertNotIn('unprovided-password',json.dumps(value))

    def test_office_password_decryption_and_integrity(self):
        from msoffcrypto.format.ooxml import OOXMLFile
        plain=self.root/'plain.docx'
        # The dependency's experimental encryptor requires a regular (>4096 byte) package stream.
        office_file(plain,{'synthetic-padding': 'x'*5000, '[Content_Types].xml':'<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types"/>',
            'word/document.xml':'<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"><w:body><w:p><w:r><w:t>Synthetic freight quote 37/KG</w:t></w:r></w:p></w:body></w:document>'})
        encrypted=self.root/'encrypted.docx'
        with plain.open('rb') as source,encrypted.open('wb') as output:
            OOXMLFile(source).encrypt('synthetic-password',output)
        self.assertIn('37/KG',extract_document(encrypted,'.docx',password='synthetic-password')['text'])
        with self.assertRaises(ContentIssue) as raised:extract_document(encrypted,'.docx',password='wrong')
        self.assertEqual(raised.exception.status,'password_rejected')
        with self.assertRaises(ContentIssue):extract_document(encrypted,'.docx')

    def test_password_map_is_hash_scoped_and_invalid_data_rejected(self):
        path=self.root/'passwords.json'
        path.write_text(json.dumps({'schemaVersion':1,'passwords':{'a'*64:'synthetic-secret'}}))
        self.assertEqual(read_passwords(path),{'a'*64:'synthetic-secret'})
        path.write_text(json.dumps({'schemaVersion':1,'passwords':{'quote.pdf':'synthetic-secret'}}))
        with self.assertRaises(ValueError):read_passwords(path)

    def test_completeness_does_not_count_previews_as_originals_or_missing_fields_as_zero(self):
        from offline_completeness import summarize,compact_values
        report={'exportedRows':100,'mediaSummary':{'images':{'total':20,'original':3,'localPreview':7,'thumbnail':1,'missing':8,'notLoaded':1}},
                'attachmentTextSummary':{'total':12,'extractionStatuses':{'extracted':2,'ocr_extracted':3,'partial':1,'encrypted':6}},
                'contentQuality':{'counts':{'occurrences':10},'quoteLinks':{'linked':5,'unlinked':9}}}
        value=summarize([report])
        self.assertEqual((value['original'],value['preview'],value['notChecked']),(3,8,1))
        self.assertEqual((value['withText'],value['ocrText'],value['passwordNeeded']),(6,3,6))
        self.assertEqual((value['linked'],value['unlinked']),(5,9))
        self.assertEqual(compact_values(summarize([{'exportedRows':0}])),('0','待核查','待核查','待核查'))

    def test_partial_ocr_keeps_completed_pages_and_native_text(self):
        from pypdf import PdfReader,PdfWriter
        path=self.root/'mixed.pdf';pdf_file(path)
        writer=PdfWriter();writer.append(PdfReader(path));writer.add_blank_page(width=400,height=300);writer.add_blank_page(width=400,height=300);writer.write(path)
        result={'status':'timeout','engine':'Windows.Media.Ocr','pages':[{'page':2,'text':'OCR synthetic 7455 KG','language':'en-US'}]}
        with patch('offline_windows_ocr.recognize',return_value=result) as call:
            value=extract_document(path,'.pdf',ocr=True)
        self.assertEqual(call.call_args.kwargs['pages'],[1,2])
        self.assertEqual(value['extractionStatus'],'partial')
        self.assertIn('PDF business requirement',value['text'])
        self.assertIn('7455',value['text'])
        self.assertEqual(value['ocr']['unreadPages'],[3])
        self.assertTrue(value['requiresReview'])

    def test_mixed_pdf_page_order_and_multipage_tiff_are_explicit(self):
        from pypdf import PdfReader,PdfWriter
        from PIL import Image
        path=self.root/'mixed.pdf';pdf_file(path)
        reader=PdfReader(path);writer=PdfWriter();writer.add_page(reader.pages[0]);writer.add_blank_page(width=400,height=300);writer.add_page(reader.pages[0]);writer.write(path)
        result={'status':'complete','engine':'Windows.Media.Ocr','pages':[{'page':2,'text':'synthetic OCR middle'}]}
        with patch('offline_windows_ocr.recognize',return_value=result):value=extract_document(path,'.pdf',ocr=True)
        self.assertEqual([s['location'].split()[1] for s in value['sections']],['1','2','3'])
        tif=self.root/'scan.tiff';im=Image.new('RGB',(20,20),'white');im.save(tif,save_all=True,append_images=[im])
        result['pages']=[{'page':1,'text':'synthetic first frame'}]
        with patch('offline_windows_ocr.recognize',return_value=result):value=extract_document(tif,'.tiff',ocr=True)
        self.assertEqual(value['extractionStatus'],'partial')
        self.assertEqual(value['ocr']['unreadPages'],[2])

    def test_timeout_reader_preserves_emitted_pages_and_password_is_stdin_only(self):
        from offline_windows_ocr import recognize
        partial=b'{"page":1,"text":"synthetic"}\n'
        with patch('offline_windows_ocr.os.name','nt'),patch('offline_windows_ocr.subprocess.run',side_effect=subprocess.TimeoutExpired('synthetic',1,output=partial)) as call:
            value=recognize(self.root/'x.pdf',pages=[0,1],password='synthetic-secret',timeout=1)
        self.assertEqual(value['status'],'timeout');self.assertEqual(len(value['pages']),1)
        self.assertNotIn('synthetic-secret',' '.join(call.call_args.args[0]))
        self.assertIn(b'synthetic-secret',call.call_args.kwargs['input'])

    def test_no_global_time_budget_blocks_later_attachments(self):
        assets=self.root/'assets';assets.mkdir()
        extractor=AttachmentExtractor()
        for index in range(2):
            data=('synthetic '+str(index)).encode();path=assets/(str(index)+'.txt');path.write_bytes(data)
            row=self.row(data);row['asset']={'status':'ready','filename':'quote.txt','path':'assets/'+path.name,'size':len(data),'digest':hashlib.sha256(data).hexdigest()}
            with patch('offline_documents.time.monotonic',return_value=1000+index*1000):
                extractor.attach(row,self.root,True)
            self.assertEqual(row['attachmentContent']['extractionStatus'],'extracted')

    def test_end_to_end_supplement_nested_file_and_analysis(self):
        from wecom_archive import WeComArchive
        source=self.root/'Data';fixture(source);(source/'manifest.json').write_text('{}')
        folder=self.root/'manual';folder.mkdir();data=b'synthetic freight 37/KG';(folder/'saved.txt').write_bytes(data)
        file=pb(2,'quote.txt')+pb(4,len(data))+pb(10,hashlib.md5(data).hexdigest())
        extra=pb(1002,pb(1,pb(1,11)+pb(2,1700000001)+pb(5,20)+pb(103,file)))
        with closing(sqlite3.connect(source/'message.db')) as db,db:db.execute('UPDATE message_table SET extra_content=? WHERE message_id=1',(extra,))
        archive=WeComArchive(source,media_config={'sourceRoot':str(source),'supplementRoot':str(folder)})
        target=self.root/'export';report=archive.export(target,chat_id='R:synthetic',copy_media=True)
        self.assertEqual(report['supplementalMediaSearch']['recoveredReferences'],1)
        self.assertIn('37/KG',(target/'业务阅读.txt').read_text(encoding='utf-8-sig'))
        rows=[json.loads(line) for line in (target/'messages.jsonl').read_text(encoding='utf8').splitlines()]
        self.assertEqual(rows[0]['quote']['message']['attachmentContent']['extractionStatus'],'extracted')
        self.assertEqual(report['mediaStatuses']['ready'],1)

    def test_settings_keep_review_and_do_not_persist_password_or_cross_accounts(self):
        from offline_desktop import DesktopSession
        from test_offline_multiselect import multi_group_fixture
        source=self.root/'source';chats=multi_group_fixture(source,'wecom')
        session=DesktopSession(self.root/'profile',client='wecom');session.open_source({'sourceRoot':str(source)})
        session.prepare_review(chats[0],copy_media=False)
        pending=session.pending_review
        session.set_content_options({'ocrEnabled':True,'supplementRoot':str(self.root)}, {'a'*64:'synthetic-secret'})
        self.assertIs(session.pending_review,pending)
        self.assertNotIn('synthetic-secret',session.settings_path.read_text())
        session.open_source({'sourceRoot':str(source),'ocrEnabled':True})
        self.assertEqual(session.archive.media_config['_documentPasswords']['a'*64],'synthetic-secret')
        other=self.root/'other';multi_group_fixture(other,'wecom')
        session.open_source({'sourceRoot':str(other)})
        self.assertNotIn('_documentPasswords',session.archive.media_config)
        self.assertNotIn('ocrEnabled',session.settings['source'])

    @unittest.skipUnless(os.name=='nt','Windows native OCR')
    def test_native_image_and_scanned_encrypted_pdf_ocr(self):
        from PIL import Image,ImageDraw,ImageFont
        from pypdf import PdfReader,PdfWriter
        image=Image.new('RGB',(1400,300),'white')
        ImageDraw.Draw(image).text((40,70),'SYNTHETIC 7455 KG',fill='black',font=ImageFont.truetype('C:/Windows/Fonts/arial.ttf',60))
        path=self.root/'scan.png';image.save(path)
        result=extract_document(path,'.png',ocr=True)
        self.assertIn('7455',result['text']);self.assertEqual(result['extractionStatus'],'ocr_extracted')
        pdf=self.root/'scan.pdf';image.save(pdf,'PDF')
        writer=PdfWriter();writer.append(PdfReader(pdf));writer.encrypt('synthetic-password');writer.write(pdf)
        result=extract_document(pdf,'.pdf',ocr=True,password='synthetic-password')
        self.assertIn('7455',result['text']);self.assertTrue(result['requiresReview'])
        self.assertNotIn('synthetic-password',json.dumps(result))


if __name__=='__main__':unittest.main()
