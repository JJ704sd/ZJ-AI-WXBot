"""Bounded, local content previews. Never execute macros, formulas or links."""
from pathlib import Path
import posixpath
import zipfile
import xml.etree.ElementTree as ET

MAX_FILE = 20 * 1024 * 1024
MAX_XML = 24 * 1024 * 1024
W = '{http://schemas.openxmlformats.org/wordprocessingml/2006/main}'
S = '{http://schemas.openxmlformats.org/spreadsheetml/2006/main}'
R = '{http://schemas.openxmlformats.org/officeDocument/2006/relationships}'


def xml(archive, name):
    data = archive.read(name)
    if b'<!DOCTYPE' in data.upper() or b'<!ENTITY' in data.upper():
        raise ValueError('附件包含不支持的 XML 声明。')
    return ET.fromstring(data)


def word_text(node):
    return ''.join(n.text or '' if n.tag == W+'t' else '\t' if n.tag == W+'tab' else '\n'
                   for n in node.iter() if n.tag in (W+'t', W+'tab', W+'br'))[:20000]


def preview(path, filename):
    path = Path(path)
    if path.stat().st_size > MAX_FILE:
        raise ValueError('预览限 20 MB 以内的文件，请下载原文件查看。')
    ext = Path(filename).suffix.lower()
    if ext in ('.doc', '.xls'):
        return {'kind': 'unsupported', 'notice': '旧版 DOC / XLS 暂不支持内嵌预览，请下载打开或另存为 DOCX / XLSX。'}
    if ext in ('.md', '.txt', '.csv', '.json', '.log'):
        data = path.read_bytes()
        try: text = data.decode('utf-8-sig')
        except UnicodeDecodeError:
            try: text = data.decode('gb18030')
            except UnicodeDecodeError: raise ValueError('无法识别文本编码，请下载原文件查看。') from None
        return {'kind': 'markdown' if ext == '.md' else 'text', 'text': text[:200000],
                'truncated': len(text) > 200000}
    if ext not in ('.docx', '.xlsx'):
        return {'kind': 'unsupported', 'notice': '此格式暂不支持内嵌预览，请下载原文件查看。'}
    try:
        with zipfile.ZipFile(path) as archive:
            entries = archive.infolist()
            if len(entries) > 5000 or sum(i.file_size for i in entries) > MAX_XML:
                raise ValueError('附件解压后过大，请下载原文件查看。')
            if ext == '.docx':
                body = xml(archive, 'word/document.xml').find(W+'body')
                if body is None: raise ValueError('Word 正文缺失。')
                blocks = []
                for item in list(body)[:1000]:
                    if item.tag == W+'p': blocks.append({'text': word_text(item)})
                    elif item.tag == W+'tbl':
                        blocks.append({'rows': [[word_text(c) for c in list(r.findall(W+'tc'))[:50]]
                                                for r in list(item.findall(W+'tr'))[:200]]})
                return {'kind': 'word', 'blocks': blocks,
                        'notice': '内容预览：最多 1000 个段落/表格，每表 200 行、50 列；图片、页眉和精确分页请下载查看。'}
            strings = []
            if 'xl/sharedStrings.xml' in archive.namelist():
                strings = [''.join(n.text or '' for n in si.iter(S+'t'))[:20000]
                           for si in xml(archive, 'xl/sharedStrings.xml')]
            rels = {r.get('Id'): r.get('Target', '') for r in xml(archive, 'xl/_rels/workbook.xml.rels')
                    if r.get('TargetMode') != 'External' and r.get('Type', '').endswith('/worksheet')}
            sheets = []
            for sheet in list(xml(archive, 'xl/workbook.xml').iter(S+'sheet'))[:20]:
                target = rels.get(sheet.get(R+'id'), '')
                name = posixpath.normpath(target.lstrip('/') if target.startswith('/') else 'xl/'+target)
                if not name.startswith('xl/') or name not in archive.namelist(): continue
                rows = []
                for row in list(xml(archive, name).iter(S+'row'))[:200]:
                    cells = []
                    for cell in list(row.findall(S+'c'))[:50]:
                        value = cell.findtext(S+'v', '')
                        if cell.get('t') == 's':
                            try: value = strings[int(value)] if int(value) >= 0 else ''
                            except (ValueError, IndexError): value = ''
                        elif cell.get('t') == 'inlineStr': value = ''.join(n.text or '' for n in cell.iter(S+'t'))
                        elif cell.get('t') == 'b': value = 'TRUE' if value == '1' else 'FALSE'
                        formula = cell.findtext(S+'f')
                        if formula is not None: value = (value+' ' if value else '')+'[公式: ='+formula+']'
                        cells.append({'ref': cell.get('r', ''), 'text': value[:20000]})
                    rows.append(cells)
                sheets.append({'name': sheet.get('name', 'Sheet'), 'rows': rows})
            return {'kind': 'spreadsheet', 'sheets': sheets,
                    'notice': '内容预览：最多 20 张表，每表 200 行、每行 50 个单元格；显示单元格地址和原始值，日期可能为序号。公式只显示缓存值，不执行计算。'}
    except (zipfile.BadZipFile, KeyError, ET.ParseError, RuntimeError, NotImplementedError):
        raise ValueError('附件损坏、加密或格式不受支持，请下载原文件查看。') from None
