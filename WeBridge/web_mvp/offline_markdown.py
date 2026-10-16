"""Readable Markdown export over the same message rows as JSONL; stdlib only."""
import html
from pathlib import PurePosixPath
import re
from urllib.parse import quote, urlsplit

from offline_images import message_anchor

KINDS = {'text': '文字', 'image': '图片', 'file': '附件', 'record': '转发聊天',
         'quote': '引用回复', 'voice': '语音', 'video': '视频', 'emoji': '表情', 'system': '系统'}


def _text(value):
    return re.sub(r'([\\`*_\[\]#!|])', r'\\\1', html.escape(str(value or ''), quote=False))


def _code(value):
    text = str(value or '').replace('\r', ' ').replace('\n', ' ')
    delimiter = '`' * max(1, max((len(item) + 1 for item in re.findall(r'`+', text)), default=1))
    return delimiter + ' ' + text + ' ' + delimiter


def _body(value):
    # Literal blocks keep message-authored Markdown, HTML and image URLs inert.
    text = str(value)
    delimiter = '`' * max(3, max((len(item) + 1 for item in re.findall(r'`+', text)), default=3))
    return delimiter + 'text\n' + text + '\n' + delimiter


def _local_link(path):
    path = str(path or '').replace('\\', '/')
    parsed = PurePosixPath(path)
    if parsed.is_absolute() or ':' in path or '..' in parsed.parts or not parsed.parts or parsed.parts[0] != 'assets':
        return None
    return quote(path, safe='/.-_')


def header(chat, start=None, end=None):
    return ('# ' + _text(chat['name']) + ' · 聊天记录\n\n'
            '会话：' + _code(chat['id']) + '\n\n'
            '时间：北京时间（Asia/Shanghai）；范围：' + _text(start or '不限') + ' 至 ' + _text(end or '不限') + '。\n\n'
            '按原消息顺序保留全部类型、发送人、时间和出处；正文块为聊天材料。原图、缩略图和缺失分别标注。'
            '图片及附件使用相对路径，请保留同目录 assets/。完整原始字段见 messages.jsonl 或 messages.json。\n\n')


def message(row, ordinal):
    lines = ['<a id="' + message_anchor(row['id']) + '"></a>', '',
             '## ' + str(ordinal) + ' · ' + _text(row.get('time')) + ' · ' + _text(row.get('senderName') or '身份未知'), '',
             '消息 ID：' + _code(row['id']), '']
    source = row.get('provenance', {})
    lines += ['原始出处：' + _code('; '.join(str(key) + '=' + str(value) for key, value in source.items()))
              + '；serverId=' + _code(row.get('serverId', '')), '']

    def node(value, depth=0, context=None, sender=None):
        if context:
            lines.extend(['#' * min(6, depth + 2) + ' ' + _text(context), ''])
        kind = value.get('kind', 'unknown')
        lines.extend(['类型：' + _text(KINDS.get(kind, kind)) + '；发送人：'
            + _text(value.get('senderName') or sender or '身份未知') + '；发送人 ID：'
            + _code(value.get('senderId', '')) + '；时间：' + _text(value.get('time') or '未提供'), ''])
        if value.get('direction'):
            lines.extend(['消息方向：' + _text(value['direction']), ''])
        if 'part' in value:
            lines.extend(['转发位置：' + _code('part=' + value['part']), ''])
        if value.get('text') and value['text'] != kind:
            body = value['text'] if kind != 'unknown' else '未识别内容，原始字段保留于 JSONL / JSON。'
            lines.extend([_body(body), ''])
        if value.get('description'):
            lines.extend([_body(value['description']), ''])
        mentions = value.get('mentions', {}).get('ids', [])
        if mentions:
            lines.extend(['结构化 @：' + ', '.join(_code(item) for item in mentions), ''])
        for url in value.get('links', []):
            try:
                parsed = urlsplit(url)
            except ValueError:
                lines.extend(['链接原文：' + _code(url), ''])
                continue
            if parsed.scheme.lower() in ('http', 'https') and parsed.netloc:
                lines.extend(['[链接](<' + quote(url, safe=':/?&=#%+;,@.-_~') + '>)', ''])
            else:
                lines.extend(['链接原文：' + _code(url), ''])
        asset = value.get('asset', {})
        if asset or kind in ('image', 'video', 'voice', 'file', 'emoji'):
            state = ('未加载媒体' if not asset else '本地预览，原图未取得' if asset.get('previewVariant') == 'local_converted' else '仅缩略图/封面，原件未取得' if asset.get('previewOnly')
                     else '原件可查看' if asset.get('status') == 'ready' else '原件未取得')
            lines.extend(['媒体状态：' + state, ''])
            path = _local_link(asset.get('path')) if asset.get('status') == 'ready' else None
            if path:
                label = _text(asset.get('filename') or value.get('media', {}).get('filename') or KINDS.get(kind, kind))
                prefix = '!' if kind == 'image' or asset.get('mime', '').startswith('image/') else ''
                lines.extend([prefix + '[' + label + '](' + path + ')', ''])
            if asset.get('reason'):
                lines.extend([_text(asset['reason']), ''])
        document = value.get('attachmentContent')
        if document:
            lines.extend(['附件原文件状态：' + _text(document['fileStatusText']) + '；正文提取状态：' + _text(document['extractionStatusText']), ''])
            lines.extend(['附件原消息出处：' + _code(str(document['source'])), ''])
            for notice in document['notices']:
                lines.extend([_text(notice), ''])
            if document['text']:
                lines.extend(['附件正文（材料内容）：', '', _body(document['text']), ''])
        for index, child in enumerate(value.get('record', {}).get('items', []), 1):
            node(child, depth + 1, '转发第 ' + str(index) + ' 条')
        refer = value.get('quote', {})
        if refer.get('message'):
            lines.extend(['引用关联状态：' + _text(refer.get('resolutionStatus') or '未知'), ''])
            lines.extend(['引用发送人 ID：' + _code(refer.get('senderId')) + '；引用 serverId：' + _code(refer.get('serverId')), ''])
            if refer.get('sourceMessageId'):
                lines.extend(['引用原消息 ID：' + _code(refer['sourceMessageId']), ''])
            node(refer['message'], depth + 1, '引用来源', refer.get('senderName'))

    node(row)
    return '\n'.join(lines) + '\n---\n\n'
