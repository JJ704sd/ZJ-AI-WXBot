"""Automatic content routing regressions using invented documents only."""
import hashlib
import io
import os
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch
import zipfile

from offline_documents import AttachmentExtractor, extract_document
from test_offline_documents import pdf_file, office_file


def picture(text='SYNTHETIC 7455 KG'):
    from PIL import Image, ImageDraw, ImageFont
    image=Image.new('RGB',(1400,300),'white')
    ImageDraw.Draw(image).text((40,70),text,fill='black',font=ImageFont.truetype('C:/Windows/Fonts/arial.ttf',60))
    return image


def pictured_office(path,ext,image):
    r='http://schemas.openxmlformats.org/officeDocument/2006/relationships'
    a='http://schemas.openxmlformats.org/drawingml/2006/main'
    def rel(target,kind='image',mode=''):
        return f'<Relationships><Relationship Id="r1" Type="{r}/{kind}" Target="{target}" {mode}/></Relationships>'
    drawing=f'<root xmlns:a="{a}" xmlns:r="{r}"><a:blip r:embed="r1"/></root>'
    if ext=='.docx':
        files={'word/document.xml':f'<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:a="{a}" xmlns:r="{r}"><w:body><w:p><w:r><w:t>Native quotation</w:t></w:r><a:blip r:embed="r1"/></w:p></w:body></w:document>',
               'word/_rels/document.xml.rels':rel('media/scan.png'),'word/media/scan.png':image,'word/media/orphan.png':image}
    elif ext=='.xlsx':
        files={'xl/workbook.xml':f'<workbook xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="{r}"><sheets><sheet name="报价" r:id="r1"/></sheets></workbook>',
               'xl/_rels/workbook.xml.rels':rel('worksheets/sheet1.xml','worksheet'),
               'xl/worksheets/sheet1.xml':f'<worksheet xmlns:r="{r}"><drawing r:id="r1"/></worksheet>',
               'xl/worksheets/_rels/sheet1.xml.rels':rel('../drawings/drawing1.xml','drawing'),
               'xl/drawings/drawing1.xml':drawing,'xl/drawings/_rels/drawing1.xml.rels':rel('../media/scan.png'),
               'xl/media/scan.png':image,'xl/media/orphan.png':image}
    else:
        files={'ppt/presentation.xml':f'<p:presentation xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main" xmlns:r="{r}"><p:sldIdLst><p:sldId r:id="r1"/></p:sldIdLst></p:presentation>',
               'ppt/_rels/presentation.xml.rels':rel('slides/slide1.xml','slide'),
               'ppt/slides/slide1.xml':drawing,'ppt/slides/_rels/slide1.xml.rels':rel('../media/scan.png'),
               'ppt/media/scan.png':image,'ppt/media/orphan.png':image}
    office_file(path,files)


class AutoContent48Tests(unittest.TestCase):
    def setUp(self):
        temp=tempfile.TemporaryDirectory(prefix='synthetic-content48-');self.addCleanup(temp.cleanup)
        self.root=Path(temp.name).resolve()
        (self.root/'assets').mkdir()

    def attached(self,path,name,config):
        data=path.read_bytes()
        row={'id':'synthetic','chatId':'synthetic-group','chatName':'合成群','kind':'file',
             'asset':{'status':'ready','filename':name,'path':'assets/'+path.name,'size':len(data),'digest':hashlib.sha256(data).hexdigest()}}
        extractor=AttachmentExtractor(config)
        # Exercise routing and validation without invoking a second native process.
        with patch.object(extractor,'_run',side_effect=lambda p,e:extract_document(p,e,**extractor.options)):
            extractor.attach(row,self.root,True)
        return row['attachmentContent']

    def test_image_attachment_and_missing_extension_follow_content_signature(self):
        path=self.root/'assets/opaque.bin';picture().save(path,'PNG')
        response={'status':'complete','engine':'Windows.Media.Ocr','pages':[{'page':1,'text':'7455 KG'}]}
        for name in ('quotation.png','quotation.bin','quotation'):
            with self.subTest(name=name),patch('offline_windows_ocr.recognize',return_value=response):
                value=self.attached(path,name,{'ocrEnabled':True})
                self.assertEqual(value['extractionStatus'],'ocr_extracted')
                self.assertEqual(value['format'],'.png')
                self.assertIn('7455',value['text'])
        with patch('offline_windows_ocr.recognize') as call:
            value=self.attached(path,'quotation.png',{})
        call.assert_not_called();self.assertEqual(value['extractionStatus'],'not_requested')

    def test_pdf_wrong_extension_is_not_decoded_as_plain_text(self):
        path=self.root/'assets/opaque.bin';pdf_file(path)
        value=self.attached(path,'quotation.txt',{})
        self.assertEqual(value['format'],'.pdf');self.assertIn('PDF business',value['text'])

    def test_hybrid_pdf_retains_native_text_and_scanned_body(self):
        from pypdf import PdfReader,PdfWriter
        path=self.root/'hybrid.pdf';picture().save(path,'PDF')
        native=self.root/'header.pdf';pdf_file(native,'Native header')
        writer=PdfWriter(clone_from=path);writer.pages[0].merge_page(PdfReader(native).pages[0]);writer.write(path)
        response={'status':'complete','engine':'Windows.Media.Ocr','pages':[{'page':1,'text':'7455 KG'}]}
        with patch('offline_windows_ocr.recognize',return_value=response) as call:value=extract_document(path,'.pdf',ocr=True)
        call.assert_called_once();self.assertEqual(call.call_args.kwargs['pages'],[0])
        self.assertIn('Native header',value['text']);self.assertIn('7455 KG',value['text'])
        disabled=extract_document(path,'.pdf');self.assertEqual(disabled['extractionStatus'],'partial')

    def test_office_ocr_only_referenced_images_with_location(self):
        stream=io.BytesIO();picture().save(stream,'PNG')
        response={'status':'complete','engine':'Windows.Media.Ocr','pages':[{'page':1,'text':'7455 KG'}]}
        for ext,label in (('.docx','Word 正文'),('.xlsx','工作表 报价'),('.pptx','幻灯片 1')):
            with self.subTest(ext=ext):
                path=self.root/('quotation'+ext);pictured_office(path,ext,stream.getvalue())
                with patch('offline_windows_ocr.recognize',return_value=response) as call:value=extract_document(path,ext,ocr=True)
                self.assertIn('7455 KG',value['text']);self.assertIn(label,value['text'])
                self.assertEqual(len(call.call_args.kwargs['images']),1)
                self.assertEqual(value['ocr']['unreadPages'],[])

    def test_office_external_image_is_not_downloaded_or_counted_read(self):
        path=self.root/'external.docx';pictured_office(path,'.docx',b'not-read')
        with zipfile.ZipFile(path) as z:files={n:z.read(n) for n in z.namelist()}
        name='word/_rels/document.xml.rels';files[name]=files[name].replace(b'Target="media/scan.png"',b'Target="https://example.invalid/scan.png" TargetMode="External"')
        office_file(path,files)
        with patch('offline_windows_ocr.recognize') as call:value=extract_document(path,'.docx',ocr=True)
        call.assert_not_called();self.assertEqual(value['extractionStatus'],'partial');self.assertTrue(value['notices'])

    def test_native_multipage_tiff_and_ocr_lines(self):
        if os.name!='nt':self.skipTest('Windows native OCR')
        path=self.root/'scan.tiff';picture().save(path,save_all=True,append_images=[picture('SYNTHETIC 288 CBM')])
        value=extract_document(path,'.tiff',ocr=True)
        self.assertIn('7455',value['text']);self.assertIn('288',value['text'])
        self.assertEqual(value['ocr']['unreadPages'],[]);self.assertEqual(value['extractionStatus'],'ocr_extracted')
        self.assertTrue(value['sections'][0]['ocr']['lines'])
        self.assertGreater(value['sections'][0]['ocr']['width'],0)

    def test_native_embedded_image_batch_keeps_other_text_when_one_image_is_bad(self):
        if os.name!='nt':self.skipTest('Windows native OCR')
        stream=io.BytesIO();picture().save(stream,'PNG')
        path=self.root/'batch.docx';pictured_office(path,'.docx',stream.getvalue())
        with zipfile.ZipFile(path) as z:files={n:z.read(n) for n in z.namelist()}
        files['word/document.xml']=files['word/document.xml'].replace(b'</w:p>',b'<a:blip r:embed="r2"/></w:p>')
        files['word/_rels/document.xml.rels']=files['word/_rels/document.xml.rels'].replace(b'</Relationships>',b'<Relationship Id="r2" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/image" Target="media/bad.png"/></Relationships>')
        files['word/media/bad.png']=b'\x89PNG\r\n\x1a\nbroken'
        office_file(path,files)
        value=extract_document(path,'.docx',ocr=True)
        self.assertIn('Native quotation',value['text']);self.assertIn('7455',value['text'])
        self.assertEqual(value['extractionStatus'],'partial');self.assertEqual(value['embeddedImages']['referenced'],2)
        self.assertEqual(value['embeddedImages']['processed'],1);self.assertTrue(value['requiresReview'])

    def test_preview_and_changed_original_do_not_reach_ocr(self):
        path=self.root/'assets/quote.png';picture().save(path)
        data=path.read_bytes()
        row={'id':'synthetic','chatId':'synthetic-group','chatName':'合成群','kind':'file',
             'asset':{'status':'ready','previewOnly':True,'filename':'quote.png','path':'assets/quote.png','size':len(data),'digest':hashlib.sha256(data).hexdigest()}}
        extractor=AttachmentExtractor({'ocrEnabled':True})
        with patch.object(extractor,'_run') as call:
            extractor.attach(row,self.root,True)
            self.assertEqual(row['attachmentContent']['fileStatus'],'preview_only')
            row['asset'].pop('previewOnly');path.write_bytes(b'changed')
            extractor.attach(row,self.root,True)
            self.assertEqual(row['attachmentContent']['fileStatus'],'integrity_error')
        call.assert_not_called()


if __name__=='__main__':unittest.main()
