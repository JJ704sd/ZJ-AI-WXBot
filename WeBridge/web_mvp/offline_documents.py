"""Local, bounded attachment text extraction shared by both client exports."""
from collections import Counter
from copy import deepcopy
import hashlib
import json
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
FILE_LABELS={'ready':'原文件已取得','missing':'原文件未取得','not_loaded':'未加载原文件',
             'preview_only':'只有预览，原文件未取得','integrity_error':'原文件完整性校验失败'}
TEXT_LABELS={'extracted':'已提取正文','partial':'部分提取','no_text':'无可提取文字，可能需要OCR',
             'encrypted':'文件加密，未提取','unsupported':'格式未支持','failed':'正文提取失败',
             'too_large':'超过正文提取大小上限','timeout':'正文提取超时','budget_exceeded':'本次提取预算已用完',
             'original_unavailable':'缺少原文件，未提取','not_requested':'未请求加载附件'}


class ContentIssue(ValueError):
    def __init__(self,status,notice):self.status,self.notice=status,notice


class TextResult:
    def __init__(self):self.sections=[];self.characters=0;self.truncated=False;self.notices=[]
    def add(self,label,text):
        text=str(text).replace('\r\n','\n').replace('\r','\n')
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


def _office(path,ext,out):
    with zipfile.ZipFile(path) as z:
        entries=z.infolist()
        if len(entries)>5000 or sum(e.file_size for e in entries)>40*1024*1024:
            raise ContentIssue('too_large','文档展开后超过40MB或5000个条目。')
        if any(e.flag_bits&1 for e in entries):raise ContentIssue('encrypted','文档加密，未尝试密码。')
        if ext=='.docx':
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
                for para in _xml(z,name).iter(A+'p'):
                    out.add('幻灯片 '+str(number),''.join(n.text or '' if n.tag==A+'t' else '\n' for n in para.iter() if n.tag in (A+'t',A+'br')))
                note_rels=_rels(z,posixpath.dirname(name)+'/_rels/'+posixpath.basename(name)+'.rels',posixpath.dirname(name))
                for target in note_rels.values():
                    if target.startswith('ppt/notesSlides/notesSlide'):
                        for para in _xml(z,target).iter(A+'p'):out.add('幻灯片 '+str(number)+' 备注',''.join(n.text or '' for n in para.iter(A+'t')))
                if out.characters>=MAX_TEXT:break


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


def extract_document(path,ext):
    """Worker-side parser; does not launch Office, resolve links or run formulas."""
    out=TextResult()
    if ext=='.pdf':
        from pypdf import PdfReader
        import logging
        logging.getLogger('pypdf').setLevel(logging.CRITICAL)
        reader=PdfReader(path,strict=False)
        if reader.is_encrypted:raise ContentIssue('encrypted','PDF文件加密，未尝试密码。')
        pages=len(reader.pages)
        if pages>MAX_PAGES:out.truncated=True
        for index in range(min(pages,MAX_PAGES)):
            try:
                text=reader.pages[index].extract_text() or ''
                if text.strip():out.add('第 '+str(index+1)+' 页',text)
                else:out.notices.append('第 '+str(index+1)+' 页无可提取文字，可能需要OCR。')
            except Exception:out.notices.append('第 '+str(index+1)+' 页文字提取失败。')
            if out.characters>=MAX_TEXT:break
        # An all-image PDF must not be presented as successful extraction.
        if not out.sections and not out.truncated:return {**out.result(),'extractionStatus':'no_text'}
    elif ext in ('.docx','.xlsx','.pptx'):
        if path.read_bytes()[:8]==bytes.fromhex('d0cf11e0a1b11ae1'):
            raise ContentIssue('encrypted','Office文件为加密容器，未尝试密码。')
        _office(path,ext,out)
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
    return out.result()


def _worker(path,ext,connection):
    try:
        try:result=extract_document(Path(path),ext)
        except ContentIssue as issue:result={'extractionStatus':issue.status,'text':'','sections':[],'characters':0,'truncated':False,'notices':[issue.notice]}
        except Exception:result={'extractionStatus':'failed','text':'','sections':[],'characters':0,'truncated':False,'notices':['文件结构损坏或此内容尚未支持，原文件仍保留。']}
        connection.send(result)
    finally:connection.close()


class AttachmentExtractor:
    def __init__(self):self.cache={};self.file_counts=Counter();self.status_counts=Counter();self.total=0;self.characters=0;self.started=None
    def _run(self,path,ext):
        context=multiprocessing.get_context('spawn');parent,child=context.Pipe(duplex=False)
        process=context.Process(target=_worker,args=(str(path),ext,child),daemon=True)
        try:
            process.start();child.close()
            if parent.poll(15):return parent.recv()
            return {'extractionStatus':'timeout','notices':['单个附件提取超过15秒，原文件保留。']}
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
            if node.get('kind')!='file':continue
            asset=node.get('asset') or {};filename=asset.get('filename') or node.get('media',{}).get('filename') or ''
            ext=Path(filename).suffix.lower();status=asset.get('status')
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
            if copy_media and file_status=='ready':
                if self.started is None:self.started=time.monotonic()
                value['extractionStatus']='unsupported'
                if ext in SUPPORTED:
                    try:
                        relative=asset.get('path','');path=(destination/relative).resolve()
                        if not relative.startswith('assets/') or not path.is_relative_to((destination/'assets').resolve()) or not path.is_file():raise ValueError('invalid_asset')
                        if path.stat().st_size!=asset.get('size') or hashlib.sha256(path.read_bytes()).hexdigest()!=asset.get('digest'):raise ValueError('changed_asset')
                        if path.stat().st_size>MAX_FILE:value.update(extractionStatus='too_large',notices=['正文提取限20MB，原文件已保留。'])
                        elif (asset['digest'],ext) in self.cache:value.update(deepcopy(self.cache[(asset['digest'],ext)]))
                        elif time.monotonic()-self.started>180:value.update(extractionStatus='budget_exceeded',notices=['本次附件正文提取超过180秒预算，原文件保留。'])
                        else:
                            result=self._run(path,ext);self.cache[(asset['digest'],ext)]=result;value.update(deepcopy(result))
                    except (OSError,ValueError):value.update(fileStatus='integrity_error',extractionStatus='failed',notices=['附件文件或完整性校验失败。'])
                else:value['notices']=['暂未支持此格式的正文提取，原文件保留。']
            value['fileStatusText']=FILE_LABELS[value['fileStatus']]
            value['extractionStatusText']=TEXT_LABELS[value['extractionStatus']]
            node['attachmentContent']=value
            self.total+=1;self.file_counts[value['fileStatus']]+=1;self.status_counts[value['extractionStatus']]+=1;self.characters+=value['characters']
    def summary(self):return {'schemaVersion':1,'unit':'reference_occurrence','total':self.total,'fileStatuses':dict(self.file_counts),'extractionStatuses':dict(self.status_counts),'characters':self.characters,'uniqueContentsProcessed':len(self.cache)}


def summary_text(summary):
    statuses=summary['extractionStatuses']
    return '附件正文（按引用）：'+('无附件。' if not summary['total'] else '、'.join(TEXT_LABELS[k]+' '+str(v)+'处' for k,v in statuses.items())+'。文件取得状态与正文提取状态分别记录；扫描图片及图表内文字未做OCR。')
