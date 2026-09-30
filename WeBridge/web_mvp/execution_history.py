"""Bounded, read-only execution history. Never probes or submits to native code."""
from contextlib import closing
import json
import sqlite3

LIMIT = 200
MAX_LIMIT = 2000

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


def history(engine, hook_sender=None, *, limit=LIMIT):
    limit = history_limit(limit)
    account = engine.account
    targets = {g['id']: g.get('name') or g['id'] for g in engine.group_list
               if g['id'] in (engine.store.watched(account) or [])}
    if not account or not targets: return {'records': [], 'limit': limit, 'truncated': False}
    records, drafts = [], {}
    allowed = tuple(targets)
    marks = ','.join('?' for _ in allowed)
    runtime = engine.store.path.parent
    if not engine.read_only:
        for row in engine.store.rows(f'SELECT * FROM outbox WHERE account=? AND group_id IN ({marks}) ORDER BY created_at DESC LIMIT ?', (account, *allowed, limit+1)):
            if row['group_id'] in targets:
                records.append(dict(id=row['id'], source=row['origin'], targetId=row['group_id'],
                                    text=row['text'], createdAt=row['created_at'], status=row['status'], timeBasis='执行记录时间'))
    else:
        if hook_sender is not None:
            rows = read_rows(hook_sender.path,
                f"SELECT * FROM hook_drafts WHERE json_extract(request,'$.account')=? AND json_extract(request,'$.targetId') IN ({marks}) ORDER BY expires DESC LIMIT ?",
                (account, *allowed, limit+1))
            for row in rows:
                request, result = json.loads(row['request']), json.loads(row['result'])
                # Source paths, native bindings, hashes and baseline IDs never cross the API.
                draft = dict(id=row['id'], source='manual', targetId=request['targetId'], text=request['text'],
                             createdAt=result.get('submittedAtEpoch', row['expires']-120),
                             timeBasis='提交时间' if result.get('submittedAtEpoch') else '草稿准备时间',
                             status=row['status'], issue=result.get('issue', ''))
                drafts[row['id']] = draft
                if not request['idempotencyKey'].startswith(('reply_', 'schedule_')): records.append(draft)
        automatic = read_rows(runtime/'windows-auto-reply.sqlite',
            f'SELECT * FROM events WHERE account=? AND group_id IN ({marks}) ORDER BY created DESC LIMIT ?',
            (account, *allowed, limit+1))
        scheduled = read_rows(runtime/'windows-schedules.sqlite',
            f"SELECT r.*,s.payload FROM runs r JOIN schedules s ON s.id=r.job_id WHERE s.account=? AND json_extract(s.payload,'$.group_id') IN ({marks}) ORDER BY r.created DESC LIMIT ?",
            (account, *allowed, limit+1))
        for source, rows in [('reply', automatic), ('schedule', scheduled)]:
            for row in rows:
                result = json.loads(row['result'])
                job = json.loads(row['payload']) if source=='schedule' else {}
                draft = drafts.get(result.get('draftId'), {})
                records.append(dict(id=source+':'+row['id'], source=source,
                    targetId=job.get('group_id') or row['group_id'],
                    text=job.get('text') or draft.get('text', ''),
                    createdAt=row['created'], timeBasis='执行记录时间',
                    status=draft.get('status', row['status']), issue=result.get('issue', ''),
                    textUnavailable=source=='reply' and not draft.get('text')))
    records.sort(key=lambda row: (row['createdAt'], row['id']), reverse=True)
    for row in records:
        row.update(targetName=targets[row['targetId']], label=LABELS.get(row['status'], '结果待核对'),
                   pending=row['status'] in PENDING, attention=row['status'] in ISSUES, delivered=False)
    return {'records': records[:limit], 'limit': limit, 'truncated': len(records)>limit}
