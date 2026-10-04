"""Explicit batch previews and atomic frozen schedules; never submits messages."""
from contextlib import closing
import hashlib
import json
import re

from backend import BridgeError
from schedule_templates import _identity, _version
from windows_hook_sender import WindowsHookSender
from windows_scheduler import _new_job, _next_run, _schedule_spec, once_at


class BatchConflict(ValueError):
    pass


def _json(value):
    return json.dumps(value, ensure_ascii=False, sort_keys=True, separators=(',', ':'))


def _digest(value):
    return hashlib.sha256(_json(value).encode('utf-8')).hexdigest()


class ScheduleBatches:
    def __init__(self, scheduler):
        self.scheduler = scheduler
        with closing(scheduler._db()) as db, db:
            db.execute('''CREATE TABLE IF NOT EXISTS schedule_batches (
                id TEXT PRIMARY KEY, account TEXT NOT NULL, request_id TEXT NOT NULL,
                request TEXT NOT NULL, job_ids TEXT NOT NULL, UNIQUE(account,request_id))''')

    @staticmethod
    def _request(data):
        if not isinstance(data, dict): raise ValueError('批量任务请求无效。')
        account, template, version = data.get('account'), data.get('templateId'), data.get('templateVersion')
        if not isinstance(account, str) or not account: raise ValueError('账号无效，请重新加载。')
        _identity(template)
        _version(version)
        groups = data.get('groupIds')
        if (not isinstance(groups, list) or not 1<=len(groups)<=300 or
                any(not isinstance(group,str) or not 1<=len(group)<=256 for group in groups) or
                len(set(groups)) != len(groups)):
            raise ValueError('请选择 1–300 个不重复的会话。')
        calendar = _schedule_spec(data)
        del calendar['groupId'], calendar['text']
        if calendar['mode']=='once': once_at(calendar['at'], float('-inf'))
        return {'account':account, 'templateId':template, 'templateVersion':version,
            'groupIds':groups, **calendar}

    def _account(self, account):
        if account != self.scheduler.engine.account:
            raise ValueError('账号已变化，请重新加载。')

    def _preview(self, request, db, *, confirming=False):
        """Caller holds source -> subscriptions -> engine locks."""
        scheduler = self.scheduler
        account = request['account']
        self._account(account)
        name, records = scheduler.templates.render_saved(account, request['templateId'],
            request['templateVersion'], request['groupIds'])
        calendar = {key:request[key] for key in ('mode','clock','at','weekdays','windowMinutes') if key in request}
        try: due = _next_run(calendar, scheduler.clock())
        except ValueError:
            if confirming: raise BatchConflict('首个执行时间已过，请重新预览后确认。') from None
            raise
        deadline = due+calendar.get('windowMinutes',2)*60
        known = {group['id']:group['name'] for group in scheduler.engine.group_list}
        watched = set(scheduler.engine.store.watched(account) or [])
        jobs = [json.loads(row[0]) for row in db.execute('SELECT payload FROM schedules WHERE account=?', (account,))]
        issues, binding, specifications = [], None, []
        if len(jobs)+len(records)>500: issues.append('本批创建后将超过当前账号 500 条本机任务记录上限。')
        if scheduler.source.busy: issues.append('副本正在更新，请稍后重新预览。')
        for record in records:
            group = record['groupId']
            record.update(targetName=known.get(group,''), existingCount=sum(job['group_id']==group for job in jobs), duplicate=False)
            if group not in known or group not in watched:
                record['error'] = '请将当前账号的有效收件会话勾选到读取范围。'
            elif binding is None and not scheduler.source.busy:
                try: binding = scheduler._binding(account, group)
                except (ValueError,BridgeError) as error:
                    if str(error) not in issues: issues.append(str(error))
            if binding is not None and not record['error']:
                try:
                    WindowsHookSender._request({**binding, 'targetId':group, 'targetName':record['targetName'],
                        'text':record['text'], 'idempotencyKey':_digest({'account':account,'groupId':group})})
                except ValueError as error:
                    record['error'] = str(error)
            spec = {'groupId':group, 'text':record['text'], **calendar}
            specifications.append(spec)
            record['duplicate'] = any(job['state'] in ('active','paused') and job['spec']==spec for job in jobs)
            if record['duplicate']: record['error'] = '已有启用或暂停的相同计划，本批不会重复创建。'
        invalid = sum(bool(record['error']) for record in records)
        can_create = not issues and invalid==0
        result = {'templateId':request['templateId'], 'templateVersion':request['templateVersion'],
            'templateName':name, 'mode':calendar['mode'], 'clock':calendar['clock'], 'at':calendar['at'],
            'weekdays':calendar.get('weekdays',[]), 'windowMinutes':calendar.get('windowMinutes',2),
            'nextRun':due, 'deadline':deadline, 'records':records, 'readyCount':len(records)-invalid,
            'invalidCount':invalid, 'existingCount':len(jobs), 'capacity':500, 'canCreate':can_create,
            'previewDigest':'', 'issues':issues}
        if can_create:
            result['previewDigest'] = _digest({'account':account, 'binding':binding,
                'templateId':request['templateId'], 'templateVersion':request['templateVersion'], 'templateName':name,
                'calendar':calendar, 'nextRun':due, 'deadline':deadline,
                'records':sorted(({key:record[key] for key in ('groupId','targetName','text','contentSource')}
                    for record in records), key=lambda record:record['groupId'])})
        return result, specifications, binding

    def preview(self, data):
        request = self._request(data)
        scheduler = self.scheduler
        with scheduler.source.lock, scheduler.engine.sync_lock, scheduler.engine.lock, closing(scheduler._db()) as db:
            return self._preview(request, db)[0]

    @staticmethod
    def _receipt(db, account, key, encoded):
        receipt = db.execute('SELECT * FROM schedule_batches WHERE account=? AND request_id=?', (account,key)).fetchone()
        if receipt is not None and receipt['request']!=encoded:
            raise BatchConflict('此批次请求标识已绑定其他预览，请重新打开批量创建窗口。')
        return receipt

    def _result(self, receipt, *, reused):
        scheduler = self.scheduler
        jobs = [scheduler._view(scheduler._job(receipt['account'], id)) for id in json.loads(receipt['job_ids'])]
        return {'batchId':receipt['id'], 'createdCount':len(jobs), 'jobs':jobs, 'reused':reused}

    def _confirmed_preview(self, request, db, digest):
        preview, specifications, binding = self._preview(request, db, confirming=True)
        if not preview['canCreate']:
            issues = preview['issues'] + [record['error'] for record in preview['records'] if record['error']]
            raise BatchConflict('本批不能创建，请重新预览：'+issues[0])
        if preview['previewDigest']!=digest:
            raise BatchConflict('预览正文、会话、数据源或首个执行时间已变化，请重新预览后确认。')
        return preview, specifications, binding

    def create(self, data):
        request = self._request(data)
        key, digest = data.get('requestId'), data.get('previewDigest')
        if not isinstance(key,str) or not re.fullmatch(r'[A-Za-z0-9_-]{16,100}',key):
            raise ValueError('缺少有效的批次请求标识，请重新打开创建窗口。')
        if not isinstance(digest,str) or not re.fullmatch(r'[a-f0-9]{64}',digest):
            raise ValueError('缺少有效的批量预览，请重新预览后确认。')
        encoded = _json({**request, 'groupIds':sorted(request['groupIds']), 'previewDigest':digest})
        scheduler, account = self.scheduler, request['account']
        with scheduler.source.lock, scheduler.engine.sync_lock, scheduler.engine.lock:
            self._account(account)
            with closing(scheduler._db()) as db:
                receipt = self._receipt(db,account,key,encoded)
                if receipt is not None: return self._result(receipt,reused=True)
                preview, _, binding = self._confirmed_preview(request,db,digest)

        # A single capability probe runs outside intake locks. No draft or POST
        # is created; the scheduler will revalidate authority when each job runs.
        sender = scheduler.sender_factory()
        native = sender.automation_binding(binding)
        if any(not sender.supports_target(record['groupId']) for record in preview['records']):
            raise ValueError('Hook 不支持本批中的所有收件会话，未创建任何任务。')

        with scheduler.source.lock, scheduler.engine.sync_lock, scheduler.engine.lock:
            self._account(account)
            with closing(scheduler._db()) as db, db:
                db.execute('BEGIN IMMEDIATE')
                receipt = self._receipt(db,account,key,encoded)
                reused = receipt is not None
                if receipt is None:
                    preview, specifications, binding = self._confirmed_preview(request,db,digest)
                    batch_id = _digest({'account':account, 'requestId':key, 'kind':'schedule_batch'})
                    jobs = []
                    for record,spec in zip(preview['records'], specifications):
                        id = _digest({'batchId':batch_id, 'groupId':record['groupId']})
                        job = _new_job(id,account,spec,record['targetName'],binding,native,preview['nextRun'])
                        job['batchId'] = batch_id
                        jobs.append(job)
                    receipt = {'id':batch_id, 'account':account, 'job_ids':_json([job['id'] for job in jobs])}
                    db.execute('INSERT INTO schedule_batches VALUES (?,?,?,?,?)',
                        (batch_id,account,key,encoded,receipt['job_ids']))
                    db.executemany('INSERT INTO schedules VALUES (?,?,?)',
                        ((job['id'],account,json.dumps(job,ensure_ascii=False)) for job in jobs))
                    if preview['nextRun'] <= scheduler.clock():
                        raise BatchConflict('首个执行时间已过，请重新预览后确认。')
            # Read views only after the transaction commits, while holding the
            # outer locks so concurrent pause/cancel cannot split this response.
            return self._result(receipt,reused=reused)
