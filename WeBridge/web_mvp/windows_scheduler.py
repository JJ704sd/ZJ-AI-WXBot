"""Local Windows text schedules with frozen targets and durable one-shot runs."""
from contextlib import closing
from datetime import datetime, timedelta, timezone
import hashlib
import json
import re
import sqlite3
import time

from backend import BridgeError
from database_adapter import has_blocking_warnings
from schedule_templates import ScheduleTemplates
from windows_hook_sender import HookSendError, ISSUES

BEIJING = timezone(timedelta(hours=8))
DAY_SECONDS = 86400
RESULTS = {'submitted_unconfirmed': '已调用微信发送入口，尚未确认送达',
           'server_accepted': '服务器已接受，尚未确认收件端送达',
           'unknown': '结果未知，不会自动重试', 'blocked': '发送被阻止',
           'not_submitted': '发送前检查未通过，未提交',
           'expired': '发送已过期', 'missed': '已超过本次计划的发送窗口，已跳过'}


def _check_clock(clock):
    if not isinstance(clock, str) or not re.fullmatch(r'(?:[01][0-9]|2[0-3]):[0-5][0-9]', clock):
        raise ValueError('请选择有效的北京时间 HH:MM。')


def _next_recurring(clock, weekdays, now):
    hour, minute = map(int, clock.split(':'))
    due = datetime.fromtimestamp(now, BEIJING).replace(hour=hour, minute=minute, second=0, microsecond=0)
    if due.timestamp() <= now: due += timedelta(days=1)
    due += timedelta(days=min((day-due.isoweekday()) % 7 for day in weekdays))
    return due.timestamp()


def next_daily(clock, now):
    _check_clock(clock)
    return _next_recurring(clock, range(1, 8), now)


def _weekdays(job):
    return job['weekdays'] if job['mode']=='weekly' else list(range(1, 8)) if job['mode']=='daily' else []


def _next_run(job, now):
    return once_at(job['at'], now) if job['mode']=='once' else _next_recurring(job['clock'], _weekdays(job), now)


def _due_runs(job, now):
    first_due = job['nextRun']
    if job['mode']=='once': return first_due, ()
    weekdays = _weekdays(job)
    first_weekday = datetime.fromtimestamp(first_due, BEIJING).isoweekday()
    elapsed_days = int((now-first_due)//DAY_SECONDS)
    last_weekday = (first_weekday-1+elapsed_days) % 7+1
    elapsed_days -= min((last_weekday-day) % 7 for day in weekdays)
    # The fixed Beijing offset allows arithmetic dates. Stream only selected
    # weekdays so long offline gaps neither invent runs nor allocate a date list.
    earlier = (first_due+day*DAY_SECONDS for day in range(elapsed_days)
               if (first_weekday-1+day) % 7+1 in weekdays)
    return first_due+elapsed_days*DAY_SECONDS, earlier


def once_at(value, now):
    if not isinstance(value, str) or not re.fullmatch(r'\d{4}-\d{2}-\d{2}T\d{2}:\d{2}', value):
        raise ValueError('请选择一次性发送的北京时间日期和时间。')
    try: due = datetime.fromisoformat(value).replace(tzinfo=BEIJING).timestamp()
    except (ValueError, OverflowError, OSError): raise ValueError('发送日期或时间无效。') from None
    if due <= now: raise ValueError('发送时间必须晚于当前时间。')
    return due


def _run_id(job_id, due):
    return hashlib.sha256((job_id+'|'+str(int(due))).encode()).hexdigest()


def _schedule_spec(data):
    if data.get('mentionIds'): raise ValueError('Windows 定时发送目前只支持普通文本。')
    mode = data.get('mode', 'daily')
    if mode not in ('once','daily','weekly'): raise ValueError('请选择一次发送、每日发送或按星期发送。')
    window = data.get('windowMinutes', 2)
    if type(window) is not int or not 1<=window<=1439:
        raise ValueError('发送窗口必须是 1 至 1439 分钟的整数。')
    spec = {'groupId':data.get('groupId'), 'text':data.get('text'), 'mode':mode,
            'clock':data.get('clock','') if mode!='once' else '', 'at':data.get('at','') if mode=='once' else ''}
    if window != 2: spec['windowMinutes'] = window
    if mode=='weekly':
        weekdays = data.get('weekdays')
        if (not isinstance(weekdays, list) or not weekdays or
                any(type(day) is not int or not 1<=day<=7 for day in weekdays) or
                len(set(weekdays)) != len(weekdays)):
            raise ValueError('请至少选择一个不重复的星期，星期一至日对应整数 1 至 7。')
        spec['weekdays'] = sorted(weekdays)
    elif 'weekdays' in data:
        raise ValueError('只有按星期发送的任务可以指定星期。')
    if mode!='once': _check_clock(spec['clock'])
    return spec


class WindowsScheduler:
    def __init__(self, engine, source, sender_factory, *, clock=time.time):
        self.engine, self.source, self.sender_factory, self.clock = engine, source, sender_factory, clock
        self._pause_requests = 0
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
        self.templates = ScheduleTemplates(engine)
        from schedule_batches import ScheduleBatches
        self.batches = ScheduleBatches(self)

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
            'weekdays': _weekdays(job), 'windowMinutes': job.get('windowMinutes', 2), 'mentions': [], 'runs': runs,
            'last_result': runs[0]['label'] if runs else '', 'timezone': 'Asia/Shanghai'}

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
        spec = _schedule_spec(data)
        mode, window = spec['mode'], spec.get('windowMinutes', 2)
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
            due = _next_run(spec, self.clock())
            native = sender.automation_binding(binding)
            if not sender.supports_target(group): raise ValueError('Hook 不支持所选会话。')
            job = {'id':id, 'account':account, 'group_id':group, 'targetName':target['name'],
                   'text':spec['text'], 'mode':mode, 'clock':spec['clock'], 'at':spec['at'], 'spec':spec,
                   'nextRun':due, 'enabled':True, 'state':'active', 'issue':'', 'binding':binding, 'native':native}
            if mode=='weekly': job['weekdays'] = spec['weekdays']
            if window != 2: job['windowMinutes'] = window
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
                due = _next_run(job, self.clock())
                job.update(enabled=True, state='active', issue='', nextRun=due, native=native)
            with closing(self._db()) as db, db: self._save(db, job)
            return self._view(job)

    def pause_scope(self, account, groupId=''):
        if not isinstance(groupId, str) or len(groupId)>256:
            raise ValueError('暂停会话范围无效。')
        with self.engine.lock:
            if not account or account != self.engine.account:
                raise ValueError('账号已变化，请刷新页面。')
            # Register before waiting for tick's source lock; concurrent pause
            # requests must each keep the next job from starting until resolved.
            self._pause_requests += 1
        try:
            with self.source.lock, self.engine.sync_lock, self.engine.lock:
                if account != self.engine.account:
                    raise ValueError('账号已变化，请刷新页面。')
                with closing(self._db()) as db, db:
                    paused = db.execute("""UPDATE schedules SET payload=json_set(payload,
                        '$.enabled',json('false'),'$.state','paused','$.issue','已手动批量暂停。')
                        WHERE account=? AND json_extract(payload,'$.enabled')=1
                        AND (?='' OR json_extract(payload,'$.group_id')=?)""", (account,groupId,groupId)).rowcount
                return {'pausedCount':paused, 'jobs':self.list(account)}
        finally:
            with self.engine.lock:
                self._pause_requests -= 1

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
                with self.engine.lock:
                    if self._pause_requests:
                        return
                # Once past this checkpoint, this job may finish before pause commits.
                job = json.loads(row[0])
                if not job['enabled']: continue
                if not self.engine.send_lock.acquire(blocking=False):
                    continue
                try:
                    try:
                        binding = self._binding(job['account'], job['group_id'])
                        sender = self.sender_factory()
                        if binding != job['binding'] or sender.automation_binding(binding) != job['native']:
                            raise ValueError('binding changed')
                    except (BridgeError, ValueError):
                        job.update(enabled=False, state='paused', issue='账号、读取范围或 Hook 连接变化，请核对后恢复。')
                        with closing(self._db()) as db, db: self._save(db, job)
                        continue
                    now, due = self.clock(), job['nextRun']
                    if now < due: continue
                    due, earlier = _due_runs(job, now)
                    id = _run_id(job['id'], due)
                    deadline = due+job.get('windowMinutes', 2)*60
                    missed = now > deadline
                    with closing(self._db()) as db, db:
                        # Earlier runs and the final claim commit together before
                        # any submission. Existing unknown results stay untouched.
                        db.executemany('INSERT OR IGNORE INTO runs VALUES (?,?,?,?,?,?)',
                            ((_run_id(job['id'],previous),job['id'],previous,now,'missed','{}') for previous in earlier))
                        claimed = db.execute('INSERT OR IGNORE INTO runs VALUES (?,?,?,?,?,?)',
                            (id, job['id'], due, now, 'missed' if missed else 'attempted', '{}')).rowcount
                    # A previously claimed occurrence must never reach native code again.
                    if not claimed:
                        job.update(enabled=False, state='paused', issue='本次计划已有处理记录，不会重复提交。')
                        with closing(self._db()) as db, db: self._save(db, job)
                        continue
                    status, result, unexpected_error = 'missed', {}, None
                    if not missed:
                        try:
                            messages = self.engine.adapter.call('messages', account=job['account'], groupId=job['group_id'])
                        except BridgeError:
                            status, result = 'not_submitted', {'issueCode':'snapshot_read_failed',
                                'issue':'发送前读取消息副本失败，未调用发送入口；本次计划不会自动重试。'}
                        except Exception as error:
                            # Preserve the known no-submission evidence, but propagate
                            # programming/unexpected I/O errors after durably pausing.
                            unexpected_error = error
                            status, result = 'not_submitted', {'issueCode':'preflight_unexpected',
                                'issue':'发送前检查发生非预期异常，未调用发送入口；任务已暂停，请检查后台错误。'}
                        else:
                            if has_blocking_warnings(messages['warnings']):
                                status, result = 'not_submitted', {'issueCode':'snapshot_warning',
                                    'issue':'发送前消息副本存在解析警告，未调用发送入口；请检查副本，本次计划不会自动重试。'}
                            elif self.clock() > deadline:
                                status, result = 'missed', {'issueCode':'schedule_window_expired',
                                    'issue':ISSUES['schedule_window_expired']}
                            else:
                                # This opaque operation includes prepare, POST and result
                                # persistence. Its exceptions cannot prove no submission.
                                try:
                                    outcome = sender.send_automatic({**binding, 'targetId':job['group_id'], 'targetName':job['targetName'],
                                        'text':job['text'], 'idempotencyKey':'schedule_'+id},
                                        expected_binding=job['native'], baseline_messages=messages['messages'], deadline=deadline)
                                    status = outcome['status']
                                    if status=='expired' and outcome['issueCode']=='schedule_window_expired': status = 'missed'
                                    result = {k:outcome[k] for k in ('draftId','issue','issueCode') if k in outcome}
                                except HookSendError:
                                    status, result = 'unknown', {'issue':'发送结果未确认，本次不自动重试。'}
                                except Exception as error:
                                    unexpected_error = error
                                    status, result = 'unknown', {'issue':'发送调用或结果记录发生非预期异常，结果未确认；本次不自动重试。'}
                    # Retain the next unprocessed occurrence when an operation spans
                    # later dates; the next tick must account for every elapsed run.
                    job['nextRun'] = _next_run(job, now) if job['mode']!='once' else None
                    if job['mode']=='once': job.update(enabled=False, state='missed' if status=='missed' else 'finished')
                    if status not in ('missed','submitted_unconfirmed','server_accepted'):
                        job.update(enabled=False, state='paused', issue=(result['issue'] if status=='not_submitted' else
                            '本次发送被阻止或结果未知，请核对微信；不会重试本次计划。'))
                    with closing(self._db()) as db, db:
                        db.execute('UPDATE runs SET status=?,result=? WHERE id=?', (status,json.dumps(result,ensure_ascii=False),id))
                        self._save(db, job)
                    if unexpected_error is not None:
                        raise unexpected_error
                finally:
                    self.engine.send_lock.release()
