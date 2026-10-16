"""Image references with source context, shared by desktop and offline HTML."""
import hashlib


def image_state(asset):
    if not asset:
        return 'not_loaded', '未加载媒体 · 尚未核对缓存'
    if asset.get('status') == 'ready':
        return ('preview', '仅缩略图 · 原图未取得') if asset.get('previewOnly') else ('original', '原图可查看')
    return 'missing', '图片缺失 · 影响判断时需补充'


def message_anchor(message_id):
    return 'msg-' + hashlib.sha256(str(message_id).encode('utf-8')).hexdigest()[:24]


def message_nodes(root):
    """Walk ordinary, forwarded and quoted occurrences in the same reading scope."""
    def walk(node, trail=(), node_path=()):
        yield node, trail, node_path
        for index, child in enumerate(node.get('record', {}).get('items', []), 1):
            yield from walk(child, (*trail, f'转发第 {index} 条'), (*node_path, ('record', index - 1)))
        if node.get('quote', {}).get('message'):
            yield from walk(node['quote']['message'], (*trail, '引用来源'), (*node_path, ('quote', 0)))
    yield from walk(root)


def image_references(root):
    """Retain reference occurrences, including quoted/forwarded images; no dedup by file."""
    for node, trail, node_path in message_nodes(root):
        if node.get('kind') == 'image':
            yield {'asset': node.get('asset', {}), 'senderName': node.get('senderName') or '身份未知',
                   'time': node.get('time') or '', 'part': node.get('part') or '',
                   'rootMessageId': root.get('id', ''), 'rootTime': root.get('time') or '',
                   'rootSenderName': root.get('senderName') or '身份未知',
                   'provenance': root.get('provenance', {}), 'trail': list(trail), 'nodePath': list(node_path),
                   'context': ' / '.join(trail) if trail else '普通消息'}
