"""Local Windows text schedules with frozen targets and durable one-shot runs."""
from contextlib import closing
from datetime import datetime, timedelta, timezone
import hashlib
import json
import re
import sqlite3
import time

BEIJING = timezone(timedelta(hours=8))
RESULTS = {'submitted_unconfirmed': '已调用微信发送入口，尚未确认送达',
           'server_accepted': '服务器已接受，尚未确认收件端送达',
           'unknown': '结果未知，不会自动重试', 'blocked': '发送被阻止',
           'expired': '发送已过期', 'missed': '超过计划时间 2 分钟，已跳过'}


def next_daily(clock, now):
    if not isinstance(clock, str) or not re.fullmatch(r'(?:[01][0-9]|2[0-3]):[0-5][0-9]', clock):
        raise ValueError('请选择有效的北京时间 HH:MM。')
    hour, minute = map(int, clock.split(':'))
    due = datetime.fromtimestamp(now, BEIJING).replace(hour=hour, minute=minute, second=0, microsecond=0)
    if due.timestamp() <= now: due += timedelta(days=1)
    return due.timestamp()


def once_at(value, now):
    if not isinstance(value, str) or not re.fullmatch(r'\d{4}-\d{2}-\d{2}T\d{2}:\d{2}', value):
        raise ValueError('请选择一次性发送的北京时间日期和时间。')
    try: due = datetime.fromisoformat(value).replace(tzinfo=BEIJING).timestamp()
    except (ValueError, OverflowError, OSError): raise ValueError('发送日期或时间无效。') from None
    if due <= now: raise ValueError('发送时间必须晚于当前时间。')
    return due


class WindowsScheduler:
    def __init__(self, engine, source, sender_factory, *, clock=time.time):
        self.engine, self.source, self.sender_factory, self.clock = engine, source, sender_factory, clock
        self.path = engine.store.path.parent/'windows-schedules.sqlite'
        with closing(self._db()) as db, db:
            db.executescript('''CREATE TABLE IF NOT EXISTS schedules(id TEXT PRIMARY KEY, account TEXT, payload TEXT);
                CREATE TABLE IF NOT EXISTS runs(id TEXT PRIMARY KEY, job_id TEXT, due REAL, created REAL, status TEXT, result TEXT);''')
            for row in db.execute('SELECT payload FROM schedules').fetchall():
                job = json.loads(row[0])
                if job['enabled']:
                    job.update(enabled=False, state='paused', issue='工作台已重启，请核对任务后恢复。')
                    self._save(db, job)
            db.execute("UPDATE runs SET status='unknown' WHERE status='attempted'")

    def _db(self):
        db = sqlite3.connect(self.path, timeout=10)
        db.row_factory = sqlite3.Row
        db.execute('PRAGMA synchronous=FULL')
        return db

    @staticmethod
    def _save(db, job):
        db.execute('INSERT OR REPLACE INTO schedules VALUES (?,?,?)', (job['id'], job['account'], json.dumps(job, ensure_ascii=False)))

    def _job(self, account, id):
        with closing(self._db()) as db:
            row = db.execute('SELECT payload FROM schedules WHERE id=? AND account=?', (id, account)).fetchone()
        if not row: raise ValueError('当前账号下找不到此任务。')
        return json.loads(row[0])

    def _view(self, job):
        with closing(self._db()) as db:
            rows = db.execute('SELECT due,created,status,result FROM runs WHERE job_id=? ORDER BY due DESC LIMIT 10', (job['id'],)).fetchall()
        runs = [{'due': r['due'], 'createdAt': r['created'], 'status': r['status'],
                 'label': RESULTS.get(r['status'], '处理结果待核对'), **json.loads(r['result'])} for r in rows]
        return {k: job[k] for k in ('id','group_id','targetName','text','mode','clock','at','enabled','state','issue','nextRun')} | {
            'mentions': [], 'runs': runs, 'last_result': runs[0]['label'] if runs else '', 'timezone': 'Asia/Shanghai'}

    def list(self, account):
        with closing(self._db()) as db:
            rows = db.execute('SELECT payload FROM schedules WHERE account=? ORDER BY rowid DESC', (account,)).fetchall()
        return [self._view(json.loads(row[0])) for row in rows]

    def _binding(self, account, target):
        self.engine.validate(account, target)
        config = self.source.config
        if not config or self.source.error or not self.engine.self_id or config.get('selfId') != self.engine.self_id:
            raise ValueError('数据库账号未确认或数据源异常，请先恢复连接。')
        if target not in (self.engine.store.watched(account) or []):
            raise ValueError('请先将收件会话勾选到读取范围。')
        return {'account':account, 'sourceId':account, 'selfId':self.engine.self_id, 'sourceRoot':config['sourceRoot']}

    def create(self, data):
        account, group, key = data.get('account'), data.get('groupId'), data.get('requestId')
        if not isinstance(key, str) or not re.fullmatch(r'[A-Za-z0-9_-]{16,100}', key):
            raise ValueError('缺少有效的任务请求标识，请重新打开创建窗口。')
        if data.get('mentionIds'): raise ValueError('Windows 定时发送目前只支持普通文本。')
        mode = data.get('mode', 'daily')
        if mode not in ('once','daily'): raise ValueError('请选择一次发送或每日发送。')
        spec = {'groupId':group, 'text':data.get('text'), 'mode':mode,
                'clock':data.get('clock','') if mode=='daily' else '', 'at':data.get('at','') if mode=='once' else ''}
        id = hashlib.sha256((str(account)+'|'+key).encode()).hexdigest()
        with self.source.lock, self.engine.sync_lock:
            if account != self.engine.account or not account: raise ValueError('账号已变化，请刷新页面。')
            with closing(self._db()) as db:
                old = db.execute('SELECT payload FROM schedules WHERE id=?', (id,)).fetchone()
                count = db.execute('SELECT count(*) FROM schedules WHERE account=?', (account,)).fetchone()[0]
            if old:
                job = json.loads(old[0])
                if job['spec'] != spec: raise ValueError('此请求已绑定其他任务，请重新打开创建窗口。')
                return self._view(job)
            if count >= 500: raise ValueError('当前账号已达到本机任务记录上限。')
            if self.source.busy: raise ValueError('副本正在更新，请稍后创建。')
            binding = self._binding(account, group)
            sender = self.sender_factory()
            target = next(row for row in self.engine.group_list if row['id']==group)
            sender._request({**binding, 'targetId':group, 'targetName':target['name'], 'text':spec['text'], 'idempotencyKey':id})
            due = next_daily(spec['clock'], self.clock()) if mode=='daily' else once_at(spec['at'], self.clock())
            native = sender.automation_binding(binding)
            if not sender.supports_target(group): raise ValueError('Hook 不支持所选会话。')
            job = {'id':id, 'account':account, 'group_id':group, 'targetName':target['name'],
                   'text':spec['text'], 'mode':mode, 'clock':spec['clock'], 'at':spec['at'], 'spec':spec,
                   'nextRun':due, 'enabled':True, 'state':'active', 'issue':'', 'binding':binding, 'native':native}
            with closing(self._db()) as db, db: self._save(db, job)
            return self._view(job)

    def action(self, account, id, action):
        if action not in ('pause','resume','cancel'): raise ValueError('任务操作无效。')
        with self.source.lock, self.engine.sync_lock:
            if account != self.engine.account or not account: raise ValueError('账号已变化。')
            job = self._job(account, id)
            if action == 'cancel': job.update(enabled=False, state='cancelled', issue='任务已取消。')
            elif action == 'pause':
                if job['enabled']: job.update(enabled=False, state='paused', issue='已手动暂停。')
            elif not job['enabled']:
                if job['state'] in ('cancelled','finished','missed'): raise ValueError('此任务已结束，请创建新任务。')
                with closing(self._db()) as db:
                    attempted = db.execute('SELECT 1 FROM runs WHERE job_id=?', (id,)).fetchone()
                if job['mode']=='once' and attempted: raise ValueError('此一次性任务已有执行记录，不能重试。')
                if self.source.busy: raise ValueError('副本正在更新，请稍后恢复。')
                binding = self._binding(account, job['group_id'])
                if binding != job['binding']: raise ValueError('任务绑定的账号或数据源已变化。')
                sender = self.sender_factory()
                native = sender.automation_binding(binding)
                if not sender.supports_target(job['group_id']): raise ValueError('Hook 不支持所选会话。')
                due = next_daily(job['clock'], self.clock()) if job['mode']=='daily' else once_at(job['at'], self.clock())
                job.update(enabled=True, state='active', issue='', nextRun=due, native=native)
            with closing(self._db()) as db, db: self._save(db, job)
            return self._view(job)

    def pause_all(self, reason='数据源或 Hook 连接异常，请核对后恢复任务。', *, unwatched_account=None):
        with self.source.lock, self.engine.sync_lock:
            with closing(self._db()) as db, db:
                for row in db.execute('SELECT payload FROM schedules').fetchall():
                    job = json.loads(row[0])
                    if not job['enabled']: continue
                    if unwatched_account is not None and (job['account'] != unwatched_account or
                            job['group_id'] in (self.engine.store.watched(unwatched_account) or [])): continue
                    job.update(enabled=False, state='paused', issue=reason)
                    self._save(db, job)

    def tick(self):
        with self.source.lock, self.engine.sync_lock:
            if self.source.busy: return
            with closing(self._db()) as db:
                saved = db.execute('SELECT payload FROM schedules ORDER BY rowid').fetchall()
            for row in saved:
                job = json.loads(row[0])
                if not job['enabled']: continue
                try:
                    binding = self._binding(job['account'], job['group_id'])
                    sender = self.sender_factory()
                    if binding != job['binding'] or sender.automation_binding(binding) != job['native']:
                        raise ValueError('binding changed')
                except Exception:
                    job.update(enabled=False, state='paused', issue='账号、读取范围或 Hook 连接变化，请核对后恢复。')
                    with closing(self._db()) as db, db: self._save(db, job)
                    continue
                now, due = self.clock(), job['nextRun']
                if now < due: continue
                id = hashlib.sha256((job['id']+'|'+str(int(due))).encode()).hexdigest()
                missed = now-due > 120
                with closing(self._db()) as db, db:
                    claimed = db.execute('INSERT OR IGNORE INTO runs VALUES (?,?,?,?,?,?)',
                        (id, job['id'], due, now, 'missed' if missed else 'attempted', '{}')).rowcount
                # A previously claimed occurrence must never reach native code again.
                if not claimed:
                    job.update(enabled=False, state='paused', issue='本次计划已有处理记录，不会重复提交。')
                    with closing(self._db()) as db, db: self._save(db, job)
                    continue
                status, result = 'missed', {}
                if not missed:
                    try:
                        messages = self.engine.adapter.call('messages', account=job['account'], groupId=job['group_id'])
                        if messages.get('warnings'): raise ValueError('message snapshot warning')
                        outcome = sender.send_automatic({**binding, 'targetId':job['group_id'], 'targetName':job['targetName'],
                            'text':job['text'], 'idempotencyKey':'schedule_'+id},
                            expected_binding=job['native'], baseline_messages=messages['messages'])
                        status = outcome['status']
                        result = {k:outcome[k] for k in ('draftId','issue') if k in outcome}
                    except Exception:
                        status, result = 'unknown', {'issue':'发送结果未确认，本次不自动重试。'}
                job['nextRun'] = next_daily(job['clock'], now) if job['mode']=='daily' else None
                if job['mode']=='once': job.update(enabled=False, state='missed' if missed else 'finished')
                if status not in ('missed','submitted_unconfirmed','server_accepted'):
                    job.update(enabled=False, state='paused', issue='本次发送被阻止或结果未知，请核对微信；不会重试本次计划。')
                with closing(self._db()) as db, db:
                    db.execute('UPDATE runs SET status=?,result=? WHERE id=?', (status,json.dumps(result,ensure_ascii=False),id))
                    self._save(db, job)
