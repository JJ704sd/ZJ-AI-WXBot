"""Read-only execution queries; never probe native code or submit/reconcile sends.

Pagination bounds Python memory and responses, not SQLite scan time: existing
tables lack searchable-text/time indexes. Cursors tolerate newer inserts but do
not freeze status changes or database edits between requests.
"""
import base64
from contextlib import closing
from datetime import datetime, timedelta, timezone
import hashlib
import hmac
import json
import math
import re
import secrets
import sqlite3

LIMIT = 200
MAX_LIMIT = 2000
MAX_QUERY = 200
MAX_CURSOR = 4096
BEIJING = timezone(timedelta(hours=8))
_CURSOR_KEY = secrets.token_bytes(32)  # A restart deliberately invalidates cursors.


def history_limit(value):
    try: limit = int(value)
    except (TypeError, ValueError): raise ValueError("历史条数须为 1 至 2000 的整数。") from None
    if str(limit) != str(value) or not 1 <= limit <= MAX_LIMIT:
        raise ValueError("历史条数须为 1 至 2000 的整数。")
    return limit


LABELS = {
    'prepared': '草稿已准备，未发送', 'attempted': '处理中，结果待核对',
    'submitted_unconfirmed': '已提交，收件端待确认', 'server_accepted': '服务器已接受，收件端待确认',
    'local_record_observed': '已观察到本地记录，收件端待确认',
    'local_record_confirmed': '服务器接受并匹配本地记录，收件端待确认',
    'unknown': '结果未知，不自动重试', 'blocked': '发送被阻止', 'failed': '发送失败',
    'expired': '已过期', 'missed': '已错过，不补发', 'cancelled': '已取消',
    'cooldown_skipped': '回复间隔内已跳过', 'not_submitted': '未提交',
    'queued': '等待发送', 'sending': '发送中', 'sent': '服务器已接受，收件端待确认',
}
PENDING = {'attempted', 'sending', 'unknown', 'submitted_unconfirmed', 'server_accepted',
           'local_record_observed', 'local_record_confirmed', 'sent'}
ISSUES = {'unknown', 'blocked', 'failed', 'expired', 'missed', 'not_submitted'}


def read_rows(path, sql, args):
    if not path.is_file(): return []
    with closing(sqlite3.connect(path.resolve().as_uri()+'?mode=ro', uri=True, timeout=5)) as db:
        db.row_factory = sqlite3.Row
        return db.execute(sql, args).fetchall()


def _date(value):
    if value == '': return None
    if not isinstance(value, str) or not re.fullmatch(r'[0-9]{4}-[0-9]{2}-[0-9]{2}', value):
        raise ValueError('日期须为有效的 YYYY-MM-DD 北京时间日期。')
    try:
        # Arithmetic avoids Windows timestamp restrictions before 1970.
        day = datetime.fromisoformat(value).replace(tzinfo=BEIJING)
        return (day-datetime(1970, 1, 1, tzinfo=timezone.utc)).total_seconds()
    except ValueError:
        raise ValueError('日期须为有效的 YYYY-MM-DD 北京时间日期。') from None


def _digest(value):
    return hashlib.sha256(json.dumps(value, ensure_ascii=False, sort_keys=True,
                                     separators=(',', ':')).encode()).hexdigest()


def _cursor_encode(scope, last):
    raw = json.dumps({'v': 1, 'scope': scope, 'last': last},
                     separators=(',', ':'), ensure_ascii=True).encode()
    payload = base64.urlsafe_b64encode(raw).decode().rstrip('=')
    return payload+'.'+hmac.new(_CURSOR_KEY, payload.encode(), hashlib.sha256).hexdigest()


def _cursor_decode(value, scope):
    if not value: return None
    error = '历史翻页游标无效或已过期，请重新查询。'
    if not isinstance(value, str) or len(value) > MAX_CURSOR or not re.fullmatch(r'[A-Za-z0-9_-]+\.[0-9a-f]{64}', value):
        raise ValueError(error)
    payload, signature = value.split('.')
    if not hmac.compare_digest(signature, hmac.new(_CURSOR_KEY, payload.encode(), hashlib.sha256).hexdigest()):
        raise ValueError(error)
    try:
        data = json.loads(base64.urlsafe_b64decode(payload+'='*(-len(payload) % 4)))
        if not isinstance(data, dict) or data.get('v') != 1 or data.get('scope') != scope:
            raise ValueError(error)
        point = data['last']
        if (not isinstance(point, list) or len(point) != 2 or
                type(point[0]) not in (int, float) or not math.isfinite(point[0]) or
                not isinstance(point[1], str) or not 1 <= len(point[1]) <= 512):
            raise ValueError(error)
        return data
    except (ValueError, TypeError, KeyError, UnicodeError):
        raise ValueError(error) from None


def _attach(db, alias, path):
    if path is None or not path.is_file(): return False
    # Alias is internal; every persisted database is opened explicitly read-only.
    db.execute(f'ATTACH DATABASE ? AS {alias}', (path.resolve().as_uri()+'?mode=ro',))
    return True


def _sources(db, engine, hook_sender, source):
    """Project a strict public column list before filtering and joining sources."""
    parts = []
    if not engine.read_only:
        if _attach(db, 'state', engine.store.path):
            parts.append("""SELECT o.id,o.origin AS source,o.group_id AS targetId,
                o.text,o.created_at AS createdAt,o.status,'' AS issue,
                '执行记录时间' AS timeBasis,0 AS textUnavailable,'' AS decision,NULL AS trigger
                FROM state.outbox o JOIN targets t ON t.id=o.group_id
                WHERE o.account=:account""")
        return parts
    runtime = engine.store.path.parent
    hook = _attach(db, 'hook', hook_sender.path if hook_sender is not None else None)
    if hook and source in ('all', 'manual'):
        parts.append("""SELECT d.id,'manual' AS source,
            json_extract(d.request,'$.targetId') AS targetId,
            coalesce(json_extract(d.request,'$.text'),'') AS text,
            coalesce(json_extract(d.result,'$.submittedAtEpoch'),d.expires-120) AS createdAt,
            d.status,coalesce(json_extract(d.result,'$.issue'),'') AS issue,
            CASE WHEN json_extract(d.result,'$.submittedAtEpoch') IS NOT NULL
                THEN '提交时间' ELSE '草稿准备时间' END AS timeBasis,0 AS textUnavailable,
            '' AS decision,NULL AS trigger
            FROM hook.hook_drafts d JOIN targets t ON t.id=json_extract(d.request,'$.targetId')
            WHERE json_extract(d.request,'$.account')=:account
              AND substr(coalesce(json_extract(d.request,'$.idempotencyKey'),''),1,6)!='reply_'
              AND substr(coalesce(json_extract(d.request,'$.idempotencyKey'),''),1,9)!='schedule_'""")
    for kind, path in [('reply', runtime/'windows-auto-reply.sqlite'),
                       ('schedule', runtime/'windows-schedules.sqlite')]:
        if source not in ('all', kind) or not _attach(db, kind, path): continue
        if kind == 'reply':
            base = 'reply.events r JOIN targets t ON t.id=r.group_id'
            target, where = 'r.group_id', 'r.account=:account'
            fallback = "coalesce(json_extract(r.result,'$.replyText'),'')"
            decision = "coalesce(json_extract(r.result,'$.decision'),'')"
            fields = ('messageId', 'serverId', 'senderId', 'senderName', 'timestamp', 'text', 'textTruncated')
            projection = ','.join(f"'{key}',json_extract(r.result,'$.trigger.{key}')" for key in fields)
            trigger = f"CASE WHEN json_type(r.result,'$.trigger')='object' THEN json_object({projection}) END"
        else:
            base = "schedule.runs r JOIN schedule.schedules s ON s.id=r.job_id JOIN targets t ON t.id=json_extract(s.payload,'$.group_id')"
            target, where = "json_extract(s.payload,'$.group_id')", 's.account=:account'
            # Schedule targets/text are frozen at creation; no rule is consulted.
            fallback = "coalesce(json_extract(s.payload,'$.text'),'')"
            decision, trigger = "''", 'NULL'
        if hook:
            base += f""" LEFT JOIN hook.hook_drafts d ON d.id=json_extract(r.result,'$.draftId')
                AND json_extract(d.request,'$.account')=:account
                AND json_extract(d.request,'$.targetId')={target}"""
            text = f"coalesce(json_extract(d.request,'$.text'),{fallback})"
            status = 'coalesce(d.status,r.status)'
            issue = "coalesce(json_extract(d.result,'$.issue'),json_extract(r.result,'$.issue'),'')"
        else:
            text, status, issue = fallback, 'r.status', "coalesce(json_extract(r.result,'$.issue'),'')"
        parts.append(f"""SELECT '{kind}:'||r.id AS id,'{kind}' AS source,{target} AS targetId,
            {text} AS text,r.created AS createdAt,{status} AS status,{issue} AS issue,
            '执行记录时间' AS timeBasis,CASE WHEN {text}='' THEN 1 ELSE 0 END AS textUnavailable,
            {decision} AS decision,{trigger} AS trigger
            FROM {base} WHERE {where}""")
    return parts


def history(engine, hook_sender=None, *, limit=LIMIT, query='', source='all',
            status='all', startDate='', endDate='', cursor=''):
    limit = history_limit(limit)
    if not isinstance(query, str) or len(query) > MAX_QUERY:
        raise ValueError('历史关键词须为不超过 200 字的文本。')
    query = query.strip().casefold()
    if source not in ('all', 'manual', 'reply', 'schedule'):
        raise ValueError('历史来源无效。')
    if status not in ('all', 'pending', 'attention'):
        raise ValueError('历史状态无效。')
    start, end = _date(startDate), _date(endDate)
    if start is not None and end is not None and start > end:
        raise ValueError('开始日期不能晚于结束日期。')
    if not isinstance(cursor, str): raise ValueError('历史翻页游标无效，请重新查询。')
    account = engine.account
    subscriptions = read_rows(engine.store.path,
        'SELECT group_ids,updated_at FROM subscriptions WHERE account=?', (account,)) if account else []
    watched = json.loads(subscriptions[0]['group_ids']) if subscriptions else []
    targets = {g['id']: g.get('name') or g['id'] for g in engine.group_list if g['id'] in watched}
    scope = _digest({'account': account, 'targets': targets,
        'subscriptionRevision': subscriptions[0]['updated_at'] if subscriptions else None,
        'store': str(engine.store.path.resolve()), 'readonly': engine.read_only,
        'hook': str(hook_sender.path.resolve()) if hook_sender is not None else None,
        'query': query, 'source': source, 'status': status, 'start': startDate, 'end': endDate,
        'limit': limit})
    page = _cursor_decode(cursor, scope)
    response = {'records': [], 'limit': limit, 'truncated': False, 'hasMore': False, 'nextCursor': ''}
    if not account or not targets: return response
    # SQLite filters every historical row. Only limit+1 public rows leave SQLite.
    with closing(sqlite3.connect(':memory:', uri=True, timeout=5)) as db:
        db.row_factory = sqlite3.Row
        db.create_function('casefold', 1, lambda value: str(value or '').casefold(), deterministic=True)
        parts = _sources(db, engine, hook_sender, source)
        if not parts: return response
        db.execute('PRAGMA query_only=ON')
        args = {'account': account, 'targets': json.dumps(targets, ensure_ascii=False), 'limit': limit+1}
        filters = []
        if source != 'all':
            filters.append('r.source=:source'); args['source'] = source
        if status != 'all':
            filters.append('r.status IN (SELECT value FROM json_each(:statuses))')
            args['statuses'] = json.dumps(sorted(PENDING if status == 'pending' else ISSUES))
        if query:
            filters.append("instr(casefold(r.text||char(10)||t.name||char(10)||r.targetId||char(10)||r.id||char(10)||r.issue"
                           "||char(10)||coalesce(json_extract(r.trigger,'$.text'),'')"
                           "||char(10)||coalesce(json_extract(r.trigger,'$.senderName'),'')),:query)>0")
            args['query'] = query
        if start is not None:
            filters.append('r.createdAt>=:start'); args['start'] = start
        if end is not None:
            filters.append('r.createdAt<:end'); args['end'] = end+86400
        if page:
            filters.append('(r.createdAt<:lastTime OR (r.createdAt=:lastTime AND r.id<:lastId))')
            args['lastTime'], args['lastId'] = page['last']
        sql = ('WITH targets AS (SELECT key AS id,value AS name FROM json_each(:targets)), '
               'records AS ('+' UNION ALL '.join(parts)+') '
               'SELECT r.*,t.name AS targetName FROM records r JOIN targets t ON t.id=r.targetId '
               + ('WHERE '+' AND '.join(filters)+' ' if filters else '')
               + 'ORDER BY r.createdAt DESC,r.id DESC LIMIT :limit')
        records = [dict(row) for row in db.execute(sql, args).fetchall()]
    more = len(records) > limit
    records = records[:limit]
    for row in records:
        row['trigger'] = json.loads(row['trigger']) if row['trigger'] is not None else None
        if row['trigger'] is not None:
            row['trigger']['textTruncated'] = bool(row['trigger']['textTruncated'])
        row.update(label=LABELS.get(row['status'], '结果待核对'),
                   pending=row['status'] in PENDING, attention=row['status'] in ISSUES,
                   textUnavailable=bool(row['textUnavailable']), delivered=False)
    response.update(records=records, truncated=more, hasMore=more)
    if more:
        response['nextCursor'] = _cursor_encode(scope, [records[-1]['createdAt'], records[-1]['id']])
    return response
