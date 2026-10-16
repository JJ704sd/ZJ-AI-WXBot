"""Loss-aware WeCom protobuf presentation. Unknown fields stay in rawColumns.
Field mappings are based on Windows 5.0.12 source snapshots, not WeChat types.
No generated protobuf runtime or network access is required.
"""
from datetime import datetime, timezone, timedelta
import re

MAX_BYTES, MAX_FIELDS, MAX_DEPTH = 4 * 1024 * 1024, 10000, 10
FORWARD_FIELDS = {0: 101, 2: 101, 4: 107, 14: 103, 15: 103, 20: 103, 22: 105, 23: 105, 29: 106}


def fields(data):
    if not isinstance(data, bytes) or len(data) > MAX_BYTES:
        return []
    offset, result = 0, []
    def varint():
        nonlocal offset
        value = 0
        for shift in range(0, 70, 7):
            if offset >= len(data):
                raise ValueError
            byte = data[offset]
            offset += 1
            value |= (byte & 127) << shift
            if byte < 128:
                return value
        raise ValueError
    try:
        while offset < len(data):
            tag = varint()
            number, wire = tag >> 3, tag & 7
            if not number or len(result) >= MAX_FIELDS:
                raise ValueError
            if wire == 0:
                value = varint()
            elif wire in (1, 5):
                size = 8 if wire == 1 else 4
                value = data[offset:offset + size]
                offset += size
            elif wire == 2:
                size = varint()
                value = data[offset:offset + size]
                offset += size
                if len(value) != size:
                    raise ValueError
            else:
                raise ValueError
            if offset > len(data):
                raise ValueError
            result.append((number, wire, value))
        return result
    except (ValueError, IndexError):
        return []


def values(data, number, wire=2):
    return [value for field, kind, value in fields(data) if field == number and kind == wire]


def value(data, number, default=b'', wire=2):
    items = values(data, number, wire)
    return items[0] if items else default


def text(data):
    if isinstance(data, str):
        return data
    try:
        decoded = data.decode('utf8')
        return decoded if all(ord(c) >= 32 or c in '\r\n\t' for c in decoded) else ''
    except (UnicodeError, AttributeError):
        return ''


def leaves(data, depth=0):
    if depth >= MAX_DEPTH:
        return []
    result = []
    for _, wire, child in fields(data):
        if wire != 2:
            continue
        nested = fields(child)
        if nested:
            result.extend(leaves(child, depth + 1))
        elif text(child):
            result.append(text(child))
    return result


def typed_message(data, kind, *, depth=0, extra=b'', prefix=''):
    result = {'kind': 'unknown', 'text': '', 'links': [], 'parseStatus': 'unsupported_wecom_type', 'baseType': kind, 'subType': 0,
              'mentions': {'ids': [], 'self': None, 'status': 'none'}}
    if depth >= MAX_DEPTH:
        return {**result, 'parseStatus': 'depth_limit'}
    if kind in (0, 2):
        chunks, mention_ids, unsupported = [], [], False
        for block in values(data, 1):
            body = value(block, 2)
            block_type = value(block, 1, -1, 0)
            if block_type in (0, 3):
                chunks.extend(text(v) for v in values(body, 1) if text(v))
            elif block_type in (5, 10):
                member = value(body, 1, None, 0)
                name = text(value(body, 2))
                if member is not None and name:
                    chunks.append('@' + name)
                    mention_ids.append(str(member))
                else:
                    unsupported = True
            else:
                unsupported = True
        result.update(kind='text', text=''.join(chunks), parseStatus='ok' if not unsupported and (chunks or not data) else 'unsupported_text_blocks',
                      mentions={'ids': list(dict.fromkeys(mention_ids)), 'self': None, 'status': 'structured_wecom' if mention_ids else 'none'})
        result['links'] = re.findall(r'https?://[^\s<>"\x00-\x1f]+', result['text'])
    elif kind in (14, 15, 20, 22, 23, 29):
        label = {14: 'image', 15: 'file', 20: 'file', 22: 'video', 23: 'video', 29: 'emoji'}[kind]
        filename = text(value(data, 2)) if kind in (14, 15, 20) else text(value(data, 107)) if kind == 22 else label
        digest_field = 6 if kind == 29 else 9 if kind in (22, 23) else 10
        result.update(kind=label, text=filename or label, parseStatus='ok',
                      media={'filename': filename or label, 'md5': text(value(data, digest_field)),
                             'size': value(data, 3 if kind in (22, 23) else 4, 0, 0),
                             'width': value(data, 5, 0, 0), 'height': value(data, 6, 0, 0),
                             'thumbnailMd5': text(value(data, 30 if kind == 14 else 18)),
                             'thumbnailSize': value(data, 27 if kind == 14 else 17, 0, 0)})
    elif kind == 4:
        items = []
        entries = values(data, 1)
        for index, entry in enumerate(entries):
            subtype = value(entry, 5, -1, 0)
            # Embedded content lives in a field specific to its message type.
            field = FORWARD_FIELDS.get(subtype)
            payload = value(entry, field) if field else b''
            part = prefix + '.' + str(index) if prefix else str(index)
            row = typed_message(payload, subtype, depth=depth + 1, extra=value(entry, 17), prefix=part) if payload else {
                **result, 'parseStatus': 'unsupported_forward_payload'}
            stamp = value(entry, 2, 0, 0)
            stamp = stamp // 1000 if stamp > 20000000000 else stamp
            try:
                iso = datetime.fromtimestamp(stamp, timezone(timedelta(hours=8))).isoformat() if stamp else ''
            except (ValueError, OSError, OverflowError):
                iso = ''
            row.update(part=part, dataType=subtype, senderId=str(value(entry, 1, 0, 0)),
                       senderName=text(value(entry, 11)), timestamp=stamp, time=iso)
            items.append(row)
        result.update(kind='record', text=text(value(data, 2)) or '转发聊天记录', parseStatus='ok',
                      record={'title': text(value(data, 2)), 'items': items, 'count': len(items),
                              'status': 'ok' if items and all(v['parseStatus'] == 'ok' for v in items) else 'partially_supported'})
    elif kind in (13, 31, 38, 104):
        content = value(data, 1) if kind == 31 else data
        title = text(value(content, 3 if kind == 13 else 1))
        description = text(value(content, 4 if kind == 13 else 2))
        url = text(value(content, 1 if kind == 13 else 5 if kind == 31 else 3))
        result.update(kind='link' if url.startswith(('https://', 'http://')) else 'system', text=title,
                      description=description, links=[url] if url.startswith(('https://', 'http://')) else [], parseStatus='ok')
    elif kind in (503, 1001, 1002, 1003, 1004, 1011, 1017, 1022, 1023, 1051, 1052):
        result.update(kind='system', text=text(data) or '企微系统事件（原始字段见 JSONL）', parseStatus='plain_system')
    else:
        # Do not treat arbitrary protobuf strings (keys, server IDs) as prose.
        result['text'] = '未适配的企微消息类型 ' + str(kind) + '；原始字段已保留。'
    return result
