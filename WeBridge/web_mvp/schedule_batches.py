"""Explicit batch previews and atomic frozen schedules; never submits messages."""
from contextlib import closing
import hashlib
import json

from backend import BridgeError
from schedule_templates import _identity, _version
from windows_scheduler import _next_run, _schedule_spec


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
        return {'account':account, 'templateId':template, 'templateVersion':version,
            'groupIds':groups, **calendar}

    def _account(self, account):
        if account != self.scheduler.engine.account:
            raise ValueError('账号已变化，请重新加载。')

    def _preview(self, request):
        """Caller holds source -> subscriptions -> engine locks."""
        scheduler = self.scheduler
        account = request['account']
        self._account(account)
        name, records = scheduler.templates.render_saved(account, request['templateId'],
            request['templateVersion'], request['groupIds'])
        calendar = {key:request[key] for key in ('mode','clock','at','weekdays','windowMinutes') if key in request}
        due = _next_run(calendar, scheduler.clock())
        deadline = due+calendar.get('windowMinutes',2)*60
        known = {group['id']:group['name'] for group in scheduler.engine.group_list}
        watched = set(scheduler.engine.store.watched(account) or [])
        with closing(scheduler._db()) as db:
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
        with scheduler.source.lock, scheduler.engine.sync_lock, scheduler.engine.lock:
            return self._preview(request)[0]
