"""Local, bounded attachment text extraction shared by both client exports."""
from collections import Counter
from copy import deepcopy
import hashlib
import json
import io
import multiprocessing
from pathlib import Path
import posixpath
import re
import struct
import time
import xml.etree.ElementTree as ET
import zipfile

MAX_FILE=20*1024*1024
MAX_TEXT=200000
MAX_SECTIONS=1000
MAX_PAGES=100
W='{http://schemas.openxmlformats.org/wordprocessingml/2006/main}'
S='{http://schemas.openxmlformats.org/spreadsheetml/2006/main}'
A='{http://schemas.openxmlformats.org/drawingml/2006/main}'
R='{http://schemas.openxmlformats.org/officeDocument/2006/relationships}'
P='{http://schemas.openxmlformats.org/presentationml/2006/main}'
SUPPORTED={'.pdf','.docx','.doc','.xlsx','.xls','.pptx','.ppt','.txt','.csv','.md','.json','.log'}
IMAGE_FORMATS={'.png','.jpg','.jpeg','.bmp','.tif','.tiff','.webp','.gif'}
FILE_LABELS={'ready':'原文件已取得','missing':'原文件未取得','not_loaded':'未加载原文件',
             'preview_only':'只有预览，原文件未取得','integrity_error':'原文件完整性校验失败'}
TEXT_LABELS={'extracted':'已提取正文','partial':'部分提取','no_text':'无可提取文字，可能需要OCR',
             'encrypted':'文件加密，未提取','unsupported':'格式未支持','failed':'正文提取失败',
             'too_large':'超过正文提取大小上限','timeout':'正文提取超时','budget_exceeded':'本次提取预算已用完',
             'integrity_error':'解密后完整性校验失败','ocr_extracted':'OCR文字待人工核对','ocr_unavailable':'本机OCR不可用','password_rejected':'密码不匹配','unsupported_encryption':'加密格式暂未支持',
             'original_unavailable':'缺少原文件，未提取','not_requested':'未请求加载附件'}


class ContentIssue(ValueError):
    def __init__(self,status,notice):self.status,self.notice=status,notice


class TextResult:
    def __init__(self):self.sections=[];self.characters=0;self.truncated=False;self.notices=[];self.encoding_issue=False
    def add(self,label,text):
        text=str(text).replace('\r\n','\n').replace('\r','\n')
        # PDF character maps can emit UTF-16 surrogates instead of Unicode scalars.
        text=re.sub(r'[\ud800-\udbff][\udc00-\udfff]',
                    lambda match:match[0].encode('utf-16-le','surrogatepass').decode('utf-16-le'),text)
        readable=text.encode('utf-8','backslashreplace').decode('utf-8')
        if readable!=text:
            if not self.encoding_issue:
                self.notices.append('正文含异常 Unicode 代理字符，已保留为 \\uXXXX 转义标记；请核对原件。')
            self.encoding_issue=True
            text=readable
        text=re.sub(r'[\x00-\x08\x0b\x0c\x0e-\x1f]','',text).strip()
        if not text:return
        if len(self.sections)>=MAX_SECTIONS or self.characters>=MAX_TEXT:
            self.truncated=True;return
        available=MAX_TEXT-self.characters
        if len(text)>available:text=text[:available];self.truncated=True
        self.sections.append({'location':label,'text':text});self.characters+=len(text)
    def result(self):
        status=('partial' if self.truncated or self.notices else 'extracted') if self.sections else 'no_text'
        return {'extractionStatus':status,'text':'\n\n'.join('['+s['location']+']\n'+s['text'] for s in self.sections),
                'sections':self.sections,'characters':self.characters,'truncated':self.truncated,
                **({'requiresReview':True} if self.encoding_issue else {}),
                'notices':self.notices+(['正文达到数量或长度上限，未提取的部分不作已读取处理。'] if self.truncated else [])}


def _xml(z,name):
    if name not in z.namelist():raise ContentIssue('failed','文档核心结构缺失。')
    data=z.read(name)
    declarations=data.replace(b'\x00',b'').upper()
    if b'<!DOCTYPE' in declarations or b'<!ENTITY' in declarations:
        raise ContentIssue('failed','XML结构不受支持。')
    return ET.fromstring(data)


def _target(base,target):
    name=posixpath.normpath(target.lstrip('/') if target.startswith('/') else posixpath.join(base,target))
    if name.startswith('../') or name not in ('word','xl','ppt') and not name.startswith(('word/','xl/','ppt/')):
        raise ContentIssue('failed','文档内部引用超出支持范围。')
    return name


def _rels(z,name,base):
    if name not in z.namelist():return {}
    return {r.get('Id'):_target(base,r.get('Target','')) for r in _xml(z,name)
            if r.get('TargetMode')!='External' and r.get('Target')}


def _word_text(node):
    return ''.join(n.text or '' if n.tag==W+'t' else '\t' if n.tag==W+'tab' else '\n'
                   for n in node.iter() if n.tag in (W+'t',W+'tab',W+'br'))


def detect_format(path,declared):
    """Prefer an identifiable original format to an attachment's display name."""
    with path.open('rb') as stream:head=stream.read(1024)
    if b'%PDF-' in head[:1024]:return '.pdf'
    if head.startswith(b'\x89PNG\r\n\x1a\n'):return '.png'
    if head.startswith(b'\xff\xd8\xff'):return '.jpg'
    if head.startswith((b'II*\x00',b'MM\x00*')):return '.tiff'
    if head.startswith(b'BM'):return '.bmp'
    if head.startswith((b'GIF87a',b'GIF89a')):return '.gif'
    if head.startswith(b'RIFF') and head[8:12]==b'WEBP':return '.webp'
    if head.startswith(b'PK\x03\x04'):
        try:
            with zipfile.ZipFile(path) as z:
                names=set(z.namelist())
                for name,ext in [('word/document.xml','.docx'),('xl/workbook.xml','.xlsx'),('ppt/presentation.xml','.pptx')]:
                    if name in names:return ext
        except zipfile.BadZipFile:pass
    return declared


def _office(path,ext,out,extra=None,ocr=False):
    with zipfile.ZipFile(path) as z:
        entries=z.infolist()
        if len(entries)>5000 or sum(e.file_size for e in entries)>40*1024*1024:
            raise ContentIssue('too_large','文档展开后超过40MB或5000个条目。')
        if any(e.flag_bits&1 for e in entries):raise ContentIssue('encrypted','文档加密，未尝试密码。')
        parts=[]
        if ext=='.docx':
            parts.append(('word/document.xml','Word 正文'))
            body=_xml(z,'word/document.xml').find(W+'body')
            if body is None:raise ContentIssue('failed','Word正文结构缺失。')
            for number,node in enumerate(body,1):
                if node.tag==W+'p':out.add('段落 '+str(number),_word_text(node))
                elif node.tag==W+'tbl':
                    for rownum,row in enumerate(node.findall(W+'tr'),1):
                        out.add(f'表格 {number} 行 {rownum}','\t'.join(_word_text(c) for c in row.findall(W+'tc')))
                if out.truncated:break
            for name in sorted(z.namelist()):
                if re.fullmatch(r'word/(?:header\d+|footer\d+|footnotes|endnotes)\.xml',name):
                    for para in _xml(z,name).iter(W+'p'):out.add(name,_word_text(para))
        elif ext=='.xlsx':
            book=_xml(z,'xl/workbook.xml');rels=_rels(z,'xl/_rels/workbook.xml.rels','xl')
            strings=[]
            if 'xl/sharedStrings.xml' in z.namelist():strings=[''.join(n.text or '' for n in si.iter(S+'t')) for si in _xml(z,'xl/sharedStrings.xml')]
            for sheet in book.iter(S+'sheet'):
                target=rels.get(sheet.get(R+'id'))
                if not target:out.notices.append('有工作表引用未解析。');continue
                parts.append((target,'工作表 '+sheet.get('name','')))
                for row in _xml(z,target).iter(S+'row'):
                    cells=[]
                    for cell in row.findall(S+'c'):
                        value=cell.findtext(S+'v','');kind=cell.get('t','')
                        if kind=='s':value=strings[int(value)] if value.isdigit() and int(value)<len(strings) else '[共享文本缺失]'
                        elif kind=='inlineStr':value=''.join(n.text or '' for n in cell.iter(S+'t'))
                        elif kind=='b':value='TRUE' if value=='1' else 'FALSE'
                        formula=cell.findtext(S+'f')
                        if formula is not None:value+=((' ' if value else '')+'[公式未执行: ='+formula+']')
                        if value:cells.append(cell.get('r','?')+'='+value)
                    out.add('工作表 '+sheet.get('name','')+' 行 '+row.get('r','?'),'\t'.join(cells))
                    if out.truncated:break
                if out.truncated:break
        else:
            presentation=_xml(z,'ppt/presentation.xml');rels=_rels(z,'ppt/_rels/presentation.xml.rels','ppt')
            slides=list(presentation.iter(P+'sldId'))
            if len(slides)>MAX_PAGES:out.truncated=True
            for number,slide in enumerate(slides[:MAX_PAGES],1):
                name=rels.get(slide.get(R+'id'))
                if not name:out.notices.append('有幻灯片引用未解析。');continue
                parts.append((name,'幻灯片 '+str(number)))
                for para in _xml(z,name).iter(A+'p'):
                    out.add('幻灯片 '+str(number),''.join(n.text or '' if n.tag==A+'t' else '\n' for n in para.iter() if n.tag in (A+'t',A+'br')))
                note_rels=_rels(z,posixpath.dirname(name)+'/_rels/'+posixpath.basename(name)+'.rels',posixpath.dirname(name))
                for target in note_rels.values():
                    if target.startswith('ppt/notesSlides/notesSlide'):
                        parts.append((target,'幻灯片 '+str(number)+' 备注'))
                        for para in _xml(z,target).iter(A+'p'):out.add('幻灯片 '+str(number)+' 备注',''.join(n.text or '' for n in para.iter(A+'t')))
                if out.characters>=MAX_TEXT:break
        from offline_document_images import extract_embedded_images
        extract_embedded_images(z,parts,out,extra if extra is not None else {},ocr)


def _legacy_word(ole,out):
    word=ole.openstream('WordDocument').read()
    if len(word)<34 or word[:2]!=b'\xec\xa5':raise ContentIssue('unsupported','不支持此DOC版本，原文件保留。')
    flags=struct.unpack_from('<H',word,10)[0]
    if flags&0x8100:raise ContentIssue('encrypted','DOC文件加密，未尝试密码。')
    table=ole.openstream('1Table' if flags&0x200 else '0Table').read()
    offset=32;csw=struct.unpack_from('<H',word,offset)[0];offset+=2+csw*2
    cslw=struct.unpack_from('<H',word,offset)[0];rglw=offset+2
    ccp=struct.unpack_from('<I',word,rglw+12)[0]
    offset=rglw+cslw*4
    pairs=struct.unpack_from('<H',word,offset)[0];offset+=2
    if pairs<=33:raise ContentIssue('unsupported','此DOC版本没有受支持的正文片段索引。')
    start,length=struct.unpack_from('<II',word,offset+33*8);clx=table[start:start+length]
    cursor=0
    while cursor<len(clx) and clx[cursor]==1:cursor+=3+struct.unpack_from('<H',clx,cursor+1)[0]
    if cursor+5>len(clx) or clx[cursor]!=2:raise ContentIssue('unsupported','DOC正文片段索引不受支持。')
    size=struct.unpack_from('<I',clx,cursor+1)[0];plc=clx[cursor+5:cursor+5+size]
    if size<4 or (size-4)%12 or len(plc)!=size:raise ContentIssue('failed','DOC正文片段结构损坏。')
    count=(size-4)//12;text=[]
    for index in range(count):
        low,high=struct.unpack_from('<II',plc,index*4)
        if low>=ccp:break
        chars=min(high,ccp)-low
        if chars<0:raise ContentIssue('failed','DOC字符位置异常。')
        fc=struct.unpack_from('<I',plc,4*(count+1)+8*index+2)[0]
        compressed=bool(fc&0x40000000);start=fc&0x3fffffff
        if compressed:start//=2
        raw=word[start:start+chars*(1 if compressed else 2)]
        if len(raw)!=chars*(1 if compressed else 2):raise ContentIssue('failed','DOC正文片段不完整。')
        text.append(raw.decode('cp1252' if compressed else 'utf-16-le',errors='replace'))
        if sum(map(len,text))>=MAX_TEXT:out.truncated=True;break
    for number,line in enumerate(''.join(text).replace('\x07','\t').replace('\r','\n').splitlines(),1):out.add('正文段落 '+str(number),line)
    out.notices.append('旧版DOC已提取主文档文字；图形、文本框、修订和版式未完整还原。')


def _legacy_ppt(ole,out):
    data=ole.openstream('PowerPoint Document').read();current=ole.openstream('Current User').read()
    latest=struct.unpack_from('<I',current,16)[0];persist={};edit=latest;seen=set();doc_id=None
    while edit and edit not in seen and len(seen)<128:
        seen.add(edit)
        if edit+36>len(data):raise ContentIssue('failed','PPT编辑索引损坏。')
        previous,directory,document=struct.unpack_from('<III',data,edit+16)
        if doc_id is None:doc_id=document
        _,kind,size=struct.unpack_from('<HHI',data,directory)
        if kind not in (6001,6002) or directory+8+size>len(data):raise ContentIssue('unsupported','PPT持久对象索引未支持。')
        pos,end=directory+8,directory+8+size
        while pos+4<=end:
            packed=struct.unpack_from('<I',data,pos)[0];pos+=4;first,count=packed&0xfffff,packed>>20
            if not count or pos+4*count>end:raise ContentIssue('failed','PPT对象索引损坏。')
            for i in range(count):persist.setdefault(first+i,struct.unpack_from('<I',data,pos+4*i)[0])
            pos+=4*count
        edit=previous
    visited=set()
    def records(start,end,depth=0):
        if depth>32:out.notices.append('PPT嵌套层级超过限制。');return
        pos=start
        while pos+8<=end:
            ver,kind,size=struct.unpack_from('<HHI',data,pos);low,high=pos+8,pos+8+size
            if high>end:raise ContentIssue('failed','PPT记录边界异常。')
            if kind==4000:out.add('旧版幻灯片文字',data[low:high].decode('utf-16-le',errors='replace'))
            elif kind==4008:out.add('旧版幻灯片文字',data[low:high].decode('latin1'))
            elif kind==1011 and size>=4:object_record(struct.unpack_from('<I',data,low)[0],depth+1)
            elif ver&15==15 or kind==0xf00d:records(low,high,depth+1)
            if out.characters>=MAX_TEXT:return
            pos=high
    def object_record(identifier,depth=0):
        if identifier in visited:return
        visited.add(identifier);pos=persist.get(identifier)
        if pos is None:out.notices.append('有PPT对象未取得。');return
        if pos+8>len(data):raise ContentIssue('failed','PPT对象边界异常。')
        size=struct.unpack_from('<I',data,pos+4)[0]
        if pos+8+size>len(data):raise ContentIssue('failed','PPT对象内容损坏。')
        records(pos,pos+8+size,depth)
    object_record(doc_id)
    out.notices.append('旧版PPT按当前编辑的对象索引提取文字；图表、图形和精确页序未完整还原。')


def _pdf_has_images(page):
    # Inspect resources without decompressing every raster before Windows renders it.
    pending=[page.get('/Resources',{})];seen=set()
    while pending:
        resource=pending.pop()
        resources=resource.get_object() if hasattr(resource,'get_object') else resource
        objects=resources['/XObject'].get_object() if '/XObject' in resources else {}
        for reference in objects.values():
            image=reference.get_object()
            if id(image) in seen:continue
            seen.add(id(image))
            if image.get('/Subtype')=='/Image':return True
            if image.get('/Subtype')=='/Form':pending.append(image.get('/Resources',{}))
    contents=page.get_contents()
    return bool(contents and any(operator==b'INLINE IMAGE' for _,operator in contents.operations))


def extract_document(path,ext, *, password=None, ocr=False):
    """Worker-side parser; does not launch Office, resolve links or run formulas."""
    out=TextResult()
    extra={}
    if ext in IMAGE_FORMATS:
        _ocr_into(out,extra,path,password=password)
    elif ext=='.pdf':
        from pypdf import PdfReader
        import logging
        logging.getLogger('pypdf').setLevel(logging.CRITICAL)
        reader=PdfReader(path,strict=False)
        if reader.is_encrypted:
            if not reader.decrypt(password if password is not None else ''):
                raise ContentIssue('password_rejected' if password is not None else 'encrypted',
                    '所提供的PDF打开密码不匹配。' if password is not None else 'PDF需要打开密码；可按文件摘要提供已知密码。')
            extra['decryption']={'status':'opened','passwordSupplied':password is not None}
        pages=len(reader.pages)
        if pages>MAX_PAGES:out.truncated=True
        needs_ocr=[]
        for index in range(min(pages,MAX_PAGES)):
            try:
                text=reader.pages[index].extract_text() or ''
                if text.strip():out.add('第 '+str(index+1)+' 页',text)
                if not text.strip() or _pdf_has_images(reader.pages[index]):needs_ocr.append(index)
            except Exception:needs_ocr.append(index)
            if out.characters>=MAX_TEXT:
                if index+1<pages:out.truncated=True
                break
        if needs_ocr:
            if ocr:_ocr_into(out,extra,path,pages=needs_ocr,password=password)
            else:out.notices.extend('第 '+str(index+1)+' 页含图片或无可提取文字；可启用文档 OCR 补充。' for index in needs_ocr)
        # Native text and OCR arrive in separate passes; preserve document page order.
        out.sections.sort(key=lambda section:int(re.match(r'第 (\d+) 页',section['location'])[1]))
    elif ext in ('.docx','.xlsx','.pptx'):
        if path.read_bytes()[:8]==bytes.fromhex('d0cf11e0a1b11ae1'):
            if password is None:raise ContentIssue('encrypted','Office文件需要打开密码；可按文件摘要提供已知密码。')
            import msoffcrypto
            from msoffcrypto.exceptions import InvalidKeyError, DecryptionError
            try:
                with path.open('rb') as source:
                    encrypted=msoffcrypto.OfficeFile(source)
                    encrypted.load_key(password=password,verify_password=True)
                    plain=io.BytesIO()
                    try:encrypted.decrypt(plain,verify_integrity=True)
                    except InvalidKeyError:raise ContentIssue('integrity_error','密码已验证，但文件内容完整性校验未通过；保留原件，不使用解密内容。')
                    plain.seek(0)
                    _office(plain,ext,out,extra,ocr)
                    extra['decryption']={'status':'opened','passwordSupplied':True}
            except InvalidKeyError:raise ContentIssue('password_rejected','所提供的Office打开密码不匹配。')
            except DecryptionError:raise ContentIssue('unsupported_encryption','此加密格式暂未支持，原文件保留。')
        else:_office(path,ext,out,extra,ocr)
    elif ext=='.xls':
        import xlrd
        try:book=xlrd.open_workbook(str(path),on_demand=True)
        except xlrd.XLRDError as error:
            if 'encrypt' in str(error).lower():raise ContentIssue('encrypted','Excel文件加密，未尝试密码。')
            raise
        try:
            for sheet in book.sheets():
                for rownum in range(sheet.nrows):
                    cells=[]
                    for col in range(sheet.ncols):
                        cell=sheet.cell(rownum,col);value=cell.value
                        if cell.ctype==xlrd.XL_CELL_DATE:
                            try:value=xlrd.xldate.xldate_as_datetime(value,book.datemode).isoformat()
                            except (ValueError,OverflowError):pass
                        if value!='':cells.append(xlrd.formula.colname(col)+str(rownum+1)+'='+str(value))
                    out.add('工作表 '+sheet.name+' 行 '+str(rownum+1),'\t'.join(cells))
                    if out.truncated:break
                if out.truncated:break
        finally:book.release_resources()
    elif ext in ('.doc','.ppt'):
        import olefile
        with olefile.OleFileIO(path) as ole:
            if ole.exists('EncryptedPackage') or ole.exists('EncryptionInfo'):
                raise ContentIssue('encrypted','Office文件加密，未尝试密码。')
            (_legacy_word if ext=='.doc' else _legacy_ppt)(ole,out)
    else:
        data=path.read_bytes()
        try:text=data.decode('utf-8-sig')
        except UnicodeDecodeError:
            try:text=data.decode('gb18030')
            except UnicodeDecodeError:raise ContentIssue('failed','文本编码未识别。')
        out.add('文件正文',text)
    result=out.result()
    if extra.get('ocr'):
        result['requiresReview']=True
        if not result['text'] and extra['ocr']['status']=='unavailable':result['extractionStatus']='ocr_unavailable'
        elif result['text'] and result['extractionStatus']=='extracted':result['extractionStatus']='ocr_extracted'
    return {**result,**extra}


def _ocr_into(out,extra,path,*,pages=None,password=None,images=None,page_labels=None):
    from offline_windows_ocr import recognize
    options={'pages':pages,'password':password}
    if images is not None:options['images']=images
    result=recognize(path,**options)
    extra['ocr']={k:v for k,v in result.items() if k!='pages'}
    extra['ocr']['recognizedPages']=[]
    extra['ocr']['languages']=sorted({p['language'] for p in result['pages'] if p.get('language')})
    completed=set()
    for page in result['pages']:
        if page.get('text','').strip():
            label=(page_labels or {}).get(page['page'],'第 '+str(page['page'])+' 页')
            before=len(out.sections)
            out.add(label+' OCR（请核对数字、单位和表格）',page['text'])
            if len(out.sections)>before and page.get('lines'):
                # Coordinates refer to the rendered OCR bitmap, not PDF points or worksheet cells.
                layout={k:page[k] for k in ('page','width','height','textAngle') if k in page}
                layout['coordinateUnit']='rendered_pixel'
                remaining=len(out.sections[-1]['text']);lines=[]
                for line in page['lines']:
                    if remaining<=0:break
                    lines.append(line);remaining-=len(line.get('text',''))
                layout['lines']=lines
                out.sections[-1]['ocr']=layout
            extra['ocr']['recognizedPages'].append(page['page'])
            completed.add(page['page'])
    expected=set(range(1,len(images)+1)) if images is not None else set(i+1 for i in pages) if pages is not None else {1}
    if pages is None and images is None:
        from PIL import Image
        with Image.open(path) as image:
            if image.n_frames>1:
                expected=set(range(1,min(image.n_frames,MAX_PAGES)+1))
                if image.n_frames>MAX_PAGES:out.truncated=True
    missing=sorted(expected-completed)
    extra['ocr']['unreadPages']=missing
    if missing:out.notices.append('OCR未取得以下页的文字：'+','.join(map(str,missing))+'；原件保留。')
    if result['status']!='complete':out.notices.append('本机OCR未完整完成：'+result['status']+'；已取得的文字保留。')


def read_passwords(filename):
    if not filename:return {}
    path=Path(filename)
    if path.stat().st_size>1024*1024:raise ValueError('password_file_too_large')
    value=json.loads(path.read_text(encoding='utf-8-sig'))
    entries=value.get('passwords') if isinstance(value,dict) and value.get('schemaVersion')==1 else None
    if not isinstance(entries,dict) or any(not re.fullmatch('[a-fA-F0-9]{64}',k) or not isinstance(v,str) or len(v)>1024 for k,v in entries.items()):
        raise ValueError('invalid_password_file')
    return {k.lower():v for k,v in entries.items() if v}



def _worker(path,ext,connection,options=None):
    try:
        try:result=extract_document(Path(path),ext,**(options or {}))
        except ContentIssue as issue:result={'extractionStatus':issue.status,'text':'','sections':[],'characters':0,'truncated':False,'notices':[issue.notice]}
        except Exception:result={'extractionStatus':'failed','text':'','sections':[],'characters':0,'truncated':False,'notices':['文件结构损坏或此内容尚未支持，原文件仍保留。']}
        connection.send(result)
    finally:connection.close()


class AttachmentExtractor:
    def __init__(self,config=None,progress=None):
        self.config=config or {};self.progress=progress
        self.cache={};self.file_counts=Counter();self.status_counts=Counter();self.total=0;self.characters=0;self.image_total=0;self.ocr_total=0;self.preview_ocr_total=0
        self.password_issue=False
        try:self.passwords=read_passwords(self.config.get('documentPasswordFile'))
        except (OSError,ValueError):self.passwords={};self.password_issue=True
        self.passwords.update(self.config.get('_documentPasswords',{}))
        self.options={}

    def _run(self,path,ext):
        context=multiprocessing.get_context('spawn');parent,child=context.Pipe(duplex=False)
        process=context.Process(target=_worker,args=(str(path),ext,child,self.options),daemon=True)
        try:
            process.start();child.close()
            deadline=time.monotonic()+(90 if self.options.get('ocr') else 15)
            while time.monotonic()<deadline:
                if parent.poll(.25):return parent.recv()
                if self.progress:self.progress({'stage':'attachment_text','processedFiles':self.total,'imageFiles':self.image_total})
            return {'extractionStatus':'timeout','notices':['单个文件正文提取超时，原文件保留；后续文件继续。']}
        except (EOFError,OSError):return {'extractionStatus':'failed','notices':['附件提取进程未正常完成，原文件保留。']}
        finally:
            parent.close();child.close()
            if process.pid:
                process.join(.2)
                if process.is_alive():process.terminate();process.join(2)
                process.close()
    def attach(self,row,destination,copy_media):
        from offline_images import message_nodes
        for node,trail,_ in message_nodes(row):
            is_image=node.get('kind')=='image'
            if node.get('kind')!='file' and not (is_image and self.config.get('ocrImages')):continue
            asset=node.get('asset') or {};filename=asset.get('filename') or node.get('media',{}).get('filename') or ''
            ext=Path(asset.get('path','') if is_image else filename).suffix.lower();status=asset.get('status')
            file_status='not_loaded' if not asset else 'preview_only' if asset.get('previewOnly') else 'ready' if status=='ready' else 'missing'
            value={'schemaVersion':1,'filename':filename,'format':ext,'fileStatus':file_status,
                   'extractionStatus':'not_requested' if not copy_media else 'original_unavailable',
                   'text':'','sections':[],'characters':0,'truncated':False,'notices':[],
                   'source':{'chatId':row['chatId'],'chatName':row['chatName'],'rootMessageId':row['id'],
                             'rootSenderName':row.get('senderName',''),'rootSenderId':row.get('senderId',''),
                             'rootTime':row.get('time',''),'serverId':row.get('serverId',''),
                             'senderName':node.get('senderName') or row.get('senderName',''),
                             'senderId':node.get('senderId') or row.get('senderId',''),
                             'time':node.get('time') or row.get('time',''),'part':node.get('part',''),
                             'context':list(trail),'provenance':deepcopy(row.get('provenance',{}))}}
            preview_ocr=is_image and file_status=='preview_only' and status=='ready' and self.config.get('ocrImages')
            if copy_media and (file_status=='ready' or preview_ocr):
                value['extractionStatus']='unsupported'
                try:
                    relative=asset.get('path','');path=(destination/relative).resolve()
                    if not relative.startswith('assets/') or not path.is_relative_to((destination/'assets').resolve()) or not path.is_file():raise ValueError('invalid_asset')
                    with path.open('rb') as stream:digest=hashlib.file_digest(stream,'sha256').hexdigest()
                    if path.stat().st_size!=asset.get('size') or digest!=asset.get('digest'):raise ValueError('changed_asset')
                    if path.stat().st_size>MAX_FILE:value.update(extractionStatus='too_large',notices=['正文提取限20MB，原文件已保留。'])
                    else:
                        detected=detect_format(path,ext)
                        value.update(declaredFormat=ext,format=detected,formatSource='content_signature' if detected!=ext else 'signature_or_filename')
                        ext=detected
                        use_ocr=bool(is_image or self.config.get('ocrEnabled'))
                        cache_key=(digest,ext,use_ocr)
                        if ext in IMAGE_FORMATS and not use_ocr:
                            value.update(extractionStatus='not_requested',notices=['这是图片附件；启用文档 OCR 后可自动识别正文。'])
                        elif ext not in SUPPORTED|IMAGE_FORMATS:value['notices']=['暂未支持此格式的正文提取，原文件保留。']
                        elif cache_key in self.cache:value.update(deepcopy(self.cache[cache_key]))
                        else:
                            self.options={'password':self.passwords.get(digest),'ocr':use_ocr}
                            result=self._run(path,ext);self.cache[cache_key]=result;value.update(deepcopy(result))
                except (OSError,ValueError):value.update(fileStatus='integrity_error',extractionStatus='failed',notices=['附件文件或完整性校验失败。'])
            if self.password_issue and value['extractionStatus']=='encrypted':value['notices'].append('密码文件无法读取或格式不正确；未记录其中内容。')
            value['sha256']=asset.get('digest','')
            value['contentKind']='image_ocr' if is_image else 'attachment'
            if preview_ocr:
                value['sourceQuality']='preview';value['requiresReview']=True
                value['notices'].append('文字来自本地预览或缩略图，原图仍未取得；小字和裁切内容可能缺失。')
                if value['text']:
                    value['extractionStatus']='partial'
                    for section in value['sections']:section['location']='预览图 · '+section['location']
                    value['text']='[预览图 OCR，原图未取得]\n'+value['text']
                    self.preview_ocr_total+=1
            value['fileStatusText']=FILE_LABELS[value['fileStatus']]
            value['extractionStatusText']=TEXT_LABELS[value['extractionStatus']]
            node['attachmentContent']=value
            if value.get('ocr',{}).get('recognizedPages'):self.ocr_total+=1
            if is_image:self.image_total+=1
            self.total+=1;self.file_counts[value['fileStatus']]+=1;self.status_counts[value['extractionStatus']]+=1;self.characters+=value['characters']
    def summary(self):return {'schemaVersion':1,'unit':'reference_occurrence','total':self.total,'imageOCRReferences':self.image_total,'ocrTextReferences':self.ocr_total,'previewOCRReferences':self.preview_ocr_total,'passwordFileIssue':self.password_issue,'fileStatuses':dict(self.file_counts),'extractionStatuses':dict(self.status_counts),'characters':self.characters,'uniqueContentsProcessed':len(self.cache)}


def summary_text(summary):
    statuses=summary['extractionStatuses']
    return '附件正文（按引用）：'+('无附件。' if not summary['total'] else '、'.join(TEXT_LABELS[k]+' '+str(v)+'处' for k,v in statuses.items())+'。文件取得状态与正文提取状态分别记录；OCR文字另行标注，须核对数字、单位和表格；未启用或未完成OCR的内容不作已读取处理。')
