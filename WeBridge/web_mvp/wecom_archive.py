"""WeCom data adapter sharing the existing desktop view and export pipeline."""
from contextlib import closing
from collections import Counter
from datetime import datetime
import hashlib
import json
from pathlib import Path
import sqlite3

from database_adapter import _quote
from database_snapshot import _hash_file
from offline_chat import ArchiveError, LocalArchive, BEIJING, json_value
from wecom_content import typed_message, value, values, quote_entry, FORWARD_FIELDS
from wecom_media import WeComMedia
from offline_images import message_nodes

TABLES = ('message_table', 'message_small_table', 'kf_message_tableV1')
REQUIRED = {'message_id', 'server_id', 'sender_id', 'conversation_id', 'content_type', 'send_time', 'content'}


def connect(path):
    db = sqlite3.connect(path.as_uri() + '?mode=ro&immutable=1', uri=True)
    db.row_factory = sqlite3.Row
    def decode(value):
        try:
            return value.decode('utf8')
        except UnicodeDecodeError:
            return value
    db.text_factory = decode
    return db


def tables(db):
    return {row[0] for row in db.execute("select name from sqlite_master where type='table'")}


class WeComArchive(LocalArchive):
    def __init__(self, snapshot, self_id='', media_config=None):
        self.root, self.media_config = Path(snapshot).resolve(), media_config or {}
        self.metadata = json.loads((self.root / 'manifest.json').read_text(encoding='utf8'))
        self.fingerprints = {p: _hash_file(p) for p in self.root.glob('*.db')}
        self.adapter = self
        self.media_search = WeComMedia(self.media_config)
        self.contacts, self.member_names = {}, {}
        with closing(connect(self.root / 'user.db')) as db:
            for row in db.execute('SELECT id,name,real_name FROM user_table'):
                self.contacts[str(row['id'])] = row['real_name'] or row['name'] or str(row['id'])
        if not self_id:
            source = Path(self.media_config.get('sourceRoot', self.root))
            label = source.parent.name if source.name == 'Data' else source.name
            self_id = label if label.isdigit() and label in self.contacts else ''
        self.state = {'groups': [], 'contacts': self.contacts, 'self_id': self_id, 'warnings': []}
        with closing(connect(self.root / 'session.db')) as db:
            for row in db.execute('SELECT id,name,roomname_remark,last_message_time FROM conversation_table'):
                row = dict(row)
                cid = row['id']
                self.state['groups'].append({'id': cid, 'name': row.get('roomname_remark') or row.get('name') or cid,
                    'conversationKind': 'group' if cid.startswith('R:') else 'direct',
                    'lastMessageTime': row.get('last_message_time'), 'nameBasis': 'conversation_table'})
            if 'conversation_user_table' in tables(db):
                for row in db.execute('SELECT conversation_id,user_id,nick_name FROM conversation_user_table'):
                    self.member_names.setdefault(row['conversation_id'], {})[str(row['user_id'])] = row['nick_name'] or self.contacts.get(str(row['user_id']), str(row['user_id']))
        self.message_tables, self.message_counts = [], {}
        with closing(connect(self.root / 'message.db')) as db:
            present = tables(db)
            for table in TABLES:
                if table not in present:
                    continue
                columns = {r[1] for r in db.execute('PRAGMA table_info(' + _quote(table) + ')')}
                if not REQUIRED <= columns:
                    raise ArchiveError('企微消息表字段未支持，未加载部分数据。')
                self.message_tables.append(table)
                for cid, count in db.execute('SELECT conversation_id,count(*) FROM ' + _quote(table) + ' GROUP BY conversation_id'):
                    self.message_counts[cid] = self.message_counts.get(cid, 0) + count
            known = {v['id'] for v in self.state['groups']}
            for cid in self.message_counts.keys() - known:
                self.state['groups'].append({'id': cid, 'name': cid, 'conversationKind': 'group' if cid.startswith('R:') else 'direct', 'nameBasis': 'unmapped_conversation_id'})
        if not self.message_tables:
            raise ArchiveError('企微副本没有受支持的消息表。')

    def get_source_info(self):
        return self.metadata

    def _check(self):
        if {p for p in self.root.glob('*.db')} != set(self.fingerprints) or any(_hash_file(p) != digest for p, digest in self.fingerprints.items()):
            raise ArchiveError('企微副本在读取期间变化，请重新加载。')

    def coverage(self):
        return {'client': 'wecom', 'storageFamily': 'WeCom Windows wxSQLite3 AES-128 / SQLite',
                'scope': 'local_snapshot_only', 'cloudHistoryFetched': False,
                'selfIdConfigured': bool(self.state['self_id']),
                'identityBasis': 'selected_account_or_supplied_self_id' if self.state['self_id'] else 'unknown',
                'supportedMessageTables': self.message_tables, 'unsupportedTypesPreserved': True}

    def groups(self, include_direct=False):
        self._check()
        return {'schemaVersion': 1, 'conversations': [{**row, 'localMessageCount': self.message_counts.get(row['id'], 0),
                 'hasLocalMessages': bool(self.message_counts.get(row['id'])), 'messageDatabases': ['message.db']}
                for row in self.state['groups'] if include_direct or row['conversationKind'] == 'group'],
                'warnings': self.state['warnings'], 'coverage': self.coverage()}

    def members(self, chat):
        return {'members': [{'id': key, 'name': name} for key, name in self.member_names.get(chat, {}).items()],
                'warnings': [], 'historicalSpeakersAreMembers': False}

    def _streams(self, stack, chat, low, high, *, server_id=None):
        streams, schemas = [], []
        for table in self.message_tables:
            db = stack.enter_context(closing(connect(self.root / 'message.db')))
            conditions, params = ['conversation_id=?'], [chat]
            # Windows stores seconds; preserve raw values and support ms variants.
            maximum = db.execute('SELECT max(send_time) FROM ' + _quote(table) + ' WHERE conversation_id=?', (chat,)).fetchone()[0]
            scale = 1000 if (maximum or 0) > 20000000000 else 1
            for operator, stamp in (('>=', low), ('<', high)):
                if stamp is not None:
                    conditions.append('send_time' + operator + '?')
                    params.append(stamp * scale)
            if server_id is not None:
                conditions.append('server_id=?')
                params.append(server_id)
            cursor = db.execute('SELECT *,message_id AS local_id,send_time/' + str(scale) + ' AS create_time FROM '
                                + _quote(table) + ' WHERE ' + ' AND '.join(conditions) + ' ORDER BY send_time,message_id', params)
            streams.append(self._stream(cursor, 'message.db', table))
            schemas.append({'database': 'message.db', 'table': table, 'columns': [r[1] for r in db.execute('PRAGMA table_info(' + _quote(table) + ')')]})
        return streams, schemas

    def _message(self, item, file, table, chat):
        raw = {k: v for k, v in item.items() if k not in ('local_id', 'create_time')}
        stamp, mid, sender = int(item['create_time']), int(item['message_id']), str(item['sender_id'])
        result = typed_message(item['content'], item['content_type'], extra=item.get('extra_content', b''))
        for node, _, _ in message_nodes(result):
            quote = node.get('quote')
            if quote and not quote.get('senderName'):
                name = self.member_names.get(chat['id'], {}).get(quote['senderId']) or self.contacts.get(quote['senderId'], '')
                quote['senderName'] = quote['message']['senderName'] = name
        own = bool(self.state['self_id'])
        result['mentions']['self'] = self.state['self_id'] in result['mentions']['ids'] if own else None
        try:
            iso = datetime.fromtimestamp(stamp, BEIJING).isoformat()
        except (OverflowError, ValueError, OSError):
            iso = None
        return {'schemaVersion': 1, 'client': 'wecom', 'chatId': chat['id'], 'chatName': chat['name'],
                'id': file + '|' + table + '|' + str(mid), 'localId': mid, 'serverId': str(item['server_id']),
                'timestamp': stamp, 'time': iso, 'localType': item['content_type'], 'senderId': sender,
                'senderName': self.member_names.get(chat['id'], {}).get(sender) or self.contacts.get(sender, sender),
                'senderIdentityBasis': 'conversation_user_table/user_table', 'senderConflict': False,
                'isSelf': sender == self.state['self_id'] if own else None,
                'direction': ('outgoing' if sender == self.state['self_id'] else 'incoming') if own else 'unknown',
                **result,
                'decodeStatus': 'ok' if result['parseStatus'] in ('ok', 'plain_system') else 'partially_supported',
                'decodeAttempts': [], 'rawContent': '', 'rawColumns': {k: json_value(v) for k, v in raw.items()},
                'provenance': {'database': file, 'table': table, 'localId': mid}}

    def _link_quote(self, row, destination, copy_media, visited=None, depth=0):
        quote = row.get('quote')
        if not quote:
            return
        token = quote.get('sourceToken')
        quote['sourceLinkStatus'] = 'source_id_unavailable'
        if not token or depth >= 10:
            return
        chat = row['chatId']
        cached_chat, index = getattr(self, '_quote_sources', (None, {}))
        if cached_chat != chat:
            index = {}
            with closing(connect(self.root / 'message.db')) as db:
                available = tables(db)
                for table in TABLES:
                    if table not in available:
                        continue
                    for item in db.execute('SELECT *,send_time AS create_time FROM '+_quote(table)+' WHERE conversation_id=?', (chat,)):
                        record = dict(item)
                        stamp = int(record['send_time'])
                        record['create_time'] = stamp // 1000 if stamp > 20000000000 else stamp
                        candidate = value(value(record.get('extra_content', b''), 3045), 1)
                        if candidate:
                            index.setdefault(candidate, []).append((record, table))
            self._quote_sources = chat, index
        candidates = []
        for item, table in index.get(token.encode('ascii'), []):
            stamp = int(item['send_time'])
            stamp = stamp // 1000 if stamp > 20000000000 else stamp
            if (int(item['content_type']) != quote['sourceType'] or str(item['sender_id']) != quote['senderId'] or
                    stamp != quote['sourceTimestamp'] or
                    (quote.get('contentSha256') and (not isinstance(item['content'], bytes) or
                     hashlib.sha256(item['content']).hexdigest() != quote['contentSha256']))):
                continue
            candidates.append((item, table))
        if len(candidates) != 1:
            quote['sourceLinkStatus'] = 'ambiguous_source' if candidates else 'source_not_found'
            return
        item, table = candidates[0]
        source = self._message(item, 'message.db', table, self.select_chat(chat_id=chat))
        visited = set(visited or ()) | {row['id']}
        if source['id'] in visited:
            quote['sourceLinkStatus'] = 'cyclic_source'
            return
        quote.update(sourceLinkStatus='matched_local_source', sourceMessageId=source['id'],
                     sourceLocalId=source['localId'], sourceProvenance=source['provenance'])
        if quote['resolutionStatus'] == 'embedded' or source['decodeStatus'] != 'ok':
            return
        if copy_media:
            self._media(source, destination, Counter())
        self._link_quote(source, destination, copy_media, visited, depth + 1)
        quote.update(resolutionStatus='linked_local_source', embeddedMessage=quote['message'],
                     message={key: val for key, val in source.items() if key not in ('rawColumns','rawContent','quote')})
        if source.get('quote'):
            quote['message']['quote'] = source['quote']
        if row['parseStatus'] == 'partial_quote':
            row.update(parseStatus='ok', decodeStatus='ok')

    def _media(self, row, destination, media_counts):
        raw = row.get('rawColumns', {}).get('local_extra_content', {})
        import base64
        local = base64.b64decode(raw['data']) if isinstance(raw, dict) and raw.get('encoding') == 'base64' else b''
        raw_content = row.get('rawColumns', {}).get('content', {})
        content = base64.b64decode(raw_content['data']) if isinstance(raw_content, dict) and raw_content.get('encoding') == 'base64' else b''
        raw_extra = row.get('rawColumns', {}).get('extra_content', {})
        extra = base64.b64decode(raw_extra['data']) if isinstance(raw_extra, dict) and raw_extra.get('encoding') == 'base64' else b''
        def attach(node, payload, local_hint, extra):
            if node['kind'] in ('image', 'file', 'video', 'voice', 'emoji'):
                node['asset'] = self.media_search.attach(node, destination, local_hint)
                media_counts['preview_only' if node['asset'].get('previewOnly') else node['asset']['status']] += 1
            entries = values(payload, 1) if node.get('kind') == 'record' else []
            for index, child in enumerate(node.get('record', {}).get('items', [])):
                if child.get('timestamp'):
                    try:
                        child['time'] = datetime.fromtimestamp(child['timestamp'], BEIJING).isoformat()
                    except (ValueError, OSError, OverflowError):
                        pass
                entry = entries[index] if index < len(entries) else b''
                field = FORWARD_FIELDS.get(child.get('dataType'))
                attach(child, value(entry, field) if field else b'', value(entry, 17), value(entry, 17))
            if node.get('quote'):
                entry = quote_entry(extra)
                field = FORWARD_FIELDS.get(node['quote'].get('sourceType'))
                attach(node['quote']['message'], value(entry, field) if field else b'', value(entry, 17), value(entry, 17))
        attach(row, content, local, extra)
