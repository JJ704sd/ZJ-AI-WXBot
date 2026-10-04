"""Approved owner notifications, separate from intake and never retried after submission."""
from contextlib import closing
from datetime import datetime, timedelta, timezone
import hashlib
import json
import re
import sqlite3

from backend import BridgeError
from database_adapter import GROUP_ID, has_blocking_warnings
from human_handoffs import HandoffConflict
from windows_hook_sender import HookSendError, validate_text


WINDOW_SECONDS = 600
_FINAL_HOOK = {'blocked', 'expired', 'submitted_unconfirmed', 'server_accepted',
               'local_record_observed', 'local_record_confirmed', 'unknown'}


class NotificationDeferred(Exception):
    """A snapshot refresh is in progress; no notification submission has begun."""


def _json(value):
    return json.dumps(value, ensure_ascii=False)


def _clip(value, limit):
    # Incoming display text can contain characters disallowed by the text sender.
    value = ''.join(ch if ord(ch) >= 32 and ord(ch) != 127 or ch in '\n\t' else ' ' for ch in value)
    return value.encode('utf-16-le')[:limit*2].decode('utf-16-le', errors='ignore')


def _text(task):
    trigger = json.loads(task['trigger'])
    stamp = datetime.fromtimestamp(trigger['timestamp'], timezone(timedelta(hours=8))).strftime('%Y-%m-%d %H:%M:%S')
    heading = (f"【人工待办】\n群：{_clip(task['group_name'], 80)}（{task['group_id']}）\n"
               f"负责人标签：{_clip(task['owner'],160)}\n发起人：{_clip(trigger['senderName'], 80)}（{_clip(trigger['senderId'], 128)}）\n"
               f"时间（北京时间）：{stamp}\n原因：{task['reason']}\n待办编号：{task['id']}\n原消息：\n")
    ending = '\n\n请在本机工作台核对和领取；本提醒不表示已领取或完成。'
    marker = '\n[摘要已截断，请在本机待办和原群核对]'
    budget = 2000-len((heading+ending+marker).encode('utf-16-le'))//2
    excerpt = _clip(trigger['text'], max(0, budget))
    clipped = len(trigger['text'].encode('utf-16-le'))//2 > budget or trigger['textTruncated']
    text = heading+excerpt+(marker if clipped else '')+ending
    validate_text(text)
    return text


class HandoffNotifications:
    def __init__(self, owner):
        self.owner = owner
        self.failure = ''
        with closing(owner._db()) as db, db:
            db.executescript('''
                CREATE TABLE IF NOT EXISTS handoff_notification_policies (
                    account TEXT NOT NULL, group_id TEXT NOT NULL, version INTEGER NOT NULL,
                    payload TEXT NOT NULL, updated REAL NOT NULL, PRIMARY KEY(account,group_id));
                CREATE TABLE IF NOT EXISTS handoff_notifications (
                    task_id TEXT PRIMARY KEY, account TEXT NOT NULL, group_id TEXT NOT NULL,
                    status TEXT NOT NULL, created REAL NOT NULL, expires REAL NOT NULL,
                    draft_id TEXT NOT NULL, spec TEXT NOT NULL, result TEXT NOT NULL);
                CREATE INDEX IF NOT EXISTS handoff_notification_queue ON handoff_notifications(status,created,task_id);
            ''')
            self._pause(db, '工作台已重启，请重新核对并启用通知。')
            db.execute("UPDATE handoff_notifications SET status='unknown' WHERE status='attempted'")

    @staticmethod
    def _policy(db, account, group):
        row = db.execute('SELECT * FROM handoff_notification_policies WHERE account=? AND group_id=?', (account,group)).fetchone()
        return row, json.loads(row['payload']) if row is not None else None

    def _scope(self, account):
        service = self.owner
        scope = service.handoffs._scope(account)
        groups = {row['id']:row['name'] for row in service.engine.group_list
                  if row['id'] in scope and GROUP_ID.fullmatch(row['id']) is not None}
        recipients = {row['id']:row['name'] for row in service.engine.group_list
                      if row['id'] in scope and row['conversationKind'] == 'direct'
                      and row['id'] not in ('filehelper',service.engine.self_id)}
        return groups, recipients

    @staticmethod
    def _config(group, name, route, row, policy):
        return {'groupId':group, 'groupName':name, 'owner':route['owner'] if route is not None else '',
                'routeVersion':route['version'] if route is not None else 0,
                'version':row['version'] if row is not None else 0,
                'enabled':policy['enabled'] if policy is not None else False,
                'targetId':policy['targetId'] if policy is not None else '',
                'targetName':policy['targetName'] if policy is not None else '',
                'issue':policy['issue'] if policy is not None else '',
                'updatedAt':row['updated'] if row is not None else None}

    def configuration(self, account):
        service = self.owner
        with service.source.lock, service.engine.sync_lock, service.engine.lock:
            groups, recipients = self._scope(account)
            with closing(service._db()) as db:
                configs = []
                for group,name in groups.items():
                    route = db.execute('SELECT * FROM handoff_routes WHERE account=? AND group_id=?', (account,group)).fetchone()
                    row,policy = self._policy(db,account,group)
                    configs.append(self._config(group,name,route,row,policy))
            return {'configs':configs, 'recipients':[{'id':id,'name':name} for id,name in recipients.items()]}

    def _configuration_context(self, db, account, group, version, route_version, target, enabled):
        groups,recipients = self._scope(account)
        if group not in groups: raise ValueError('请先勾选读取原群。')
        route = db.execute('SELECT * FROM handoff_routes WHERE account=? AND group_id=?', (account,group)).fetchone()
        if (route['version'] if route is not None else 0) != route_version:
            raise HandoffConflict('群负责人已变化，请重新核对通知收件人。')
        row,policy = self._policy(db,account,group)
        if (row['version'] if row is not None else 0) != version:
            raise HandoffConflict('通知配置已变化，请刷新后核对。')
        if enabled:
            if self.failure: raise ValueError(self.failure)
            if route is None or not route['owner']: raise ValueError('请先设置本机负责人标签，再核对私聊收件人。')
            if target not in recipients: raise ValueError('通知收件人须为当前已勾选读取的私聊，不能是本人或文件传输助手。')
            binding = self.owner._binding(account,group)
        else:
            if target and target not in recipients and (policy is None or policy['targetId'] != target):
                raise ValueError('请选择当前已读取的私聊收件人。')
            binding = None
        name = recipients[target] if target in recipients else policy['targetName'] if target and policy is not None else ''
        return groups[group],route,binding,name

    def configure(self, account, groupId, version, routeVersion, targetId, enabled):
        if not isinstance(groupId,str) or not 1 <= len(groupId) <= 256:
            raise ValueError('通知原群无效。')
        if any(type(value) is not int or value < 0 for value in (version,routeVersion)):
            raise ValueError('通知配置版本无效。')
        if type(enabled) is not bool or not isinstance(targetId,str) or targetId and not re.fullmatch(r'[A-Za-z0-9_.@-]{1,256}',targetId):
            raise ValueError('通知开关或收件人无效。')
        service = self.owner
        with service.source.lock, service.engine.sync_lock, service.engine.lock, closing(service._db()) as db:
            name,route,binding,target_name = self._configuration_context(db,account,groupId,version,routeVersion,targetId,enabled)
        native = None
        if enabled:
            sender = service.sender_factory()
            native = sender.automation_binding(binding)
            if not sender.supports_target(targetId): raise ValueError('当前 Hook 桥不支持该私聊。')
        with service.source.lock, service.engine.sync_lock, service.engine.lock, closing(service._db()) as db, db:
            db.execute('BEGIN IMMEDIATE')
            name,route,current_binding,target_name = self._configuration_context(db,account,groupId,version,routeVersion,targetId,enabled)
            if current_binding != binding: raise ValueError('账号或数据源已变化，请重新核对通知。')
            policy = {'enabled':enabled, 'routeVersion':routeVersion, 'targetId':targetId, 'targetName':target_name,
                      'binding':binding, 'native':native, 'issue':'', 'templateVersion':1}
            now = service.clock()
            db.execute('INSERT OR REPLACE INTO handoff_notification_policies VALUES (?,?,?,?,?)',
                       (account,groupId,version+1,_json(policy),now))
            db.execute("UPDATE handoff_notifications SET status='cancelled',result=? WHERE account=? AND group_id=? AND status='queued'",
                       (_json({'issue':'通知配置已变化，旧队列未提交。'}),account,groupId))
            return self._config(groupId,name,route,{'version':version+1,'updated':now},policy)

    def enqueue(self, db, task):
        row,policy = self._policy(db,task['account'],task['group_id'])
        if policy is None or not policy['enabled'] or not task['owner']: return
        route = db.execute('SELECT * FROM handoff_routes WHERE account=? AND group_id=?', (task['account'],task['group_id'])).fetchone()
        if route['version'] != policy['routeVersion']: return
        key = 'handoff_'+hashlib.sha256((task['account']+'\n'+task['id']).encode('utf-8')).hexdigest()
        spec = {'policyVersion':row['version'], 'routeVersion':route['version'], 'taskVersion':task['version'],
                'owner':task['owner'], 'binding':policy['binding'], 'native':policy['native'],
                'targetId':policy['targetId'], 'targetName':policy['targetName'], 'text':_text(task), 'idempotencyKey':key}
        db.execute('INSERT OR IGNORE INTO handoff_notifications VALUES (?,?,?,?,?,?,?,?,?)',
                   (task['id'],task['account'],task['group_id'],'queued',task['created'],task['created']+WINDOW_SECONDS,'',_json(spec),'{}'))

    @staticmethod
    def cancel_task(db, task_id, reason):
        db.execute("UPDATE handoff_notifications SET status='cancelled',result=? WHERE task_id=? AND status='queued'", (_json({'issue':reason}),task_id))

    def _pause(self, db, reason, *, account=None, group=None, watched=None):
        rows = db.execute('SELECT * FROM handoff_notification_policies').fetchall()
        for row in rows:
            policy = json.loads(row['payload'])
            if account is not None and row['account'] != account: continue
            if group is not None and row['group_id'] != group: continue
            if watched is not None and row['group_id'] in watched and policy['targetId'] in watched: continue
            if policy['enabled']:
                policy.update(enabled=False,issue=reason)
                db.execute('UPDATE handoff_notification_policies SET version=version+1,payload=?,updated=? WHERE account=? AND group_id=?',
                           (_json(policy),self.owner.clock(),row['account'],row['group_id']))
            db.execute("UPDATE handoff_notifications SET status='cancelled',result=? WHERE account=? AND group_id=? AND status='queued'",
                       (_json({'issue':reason}),row['account'],row['group_id']))

    def pause_group(self, db, account, group, reason):
        self._pause(db,reason,account=account,group=group)

    def pause_all(self, reason, unwatched_account=None):
        watched = set(self.owner.engine.store.watched(unwatched_account) or []) if unwatched_account is not None else None
        with closing(self.owner._db()) as db, db:
            db.execute('BEGIN IMMEDIATE')
            self._pause(db,reason,account=unwatched_account,watched=watched)

    def summary(self, task, db):
        row = db.execute('SELECT * FROM handoff_notifications WHERE task_id=?', (task['id'],)).fetchone()
        empty = {'status':'unassigned' if not task['owner'] else 'not_configured',
                 'issue':'未配置或未启用通知；不会补发旧待办。', 'targetId':'', 'targetName':'',
                 'createdAt':None, 'expiresAt':None, 'draftId':'', 'delivered':False, 'retryAllowed':False}
        if row is None: return empty
        spec,result = json.loads(row['spec']),json.loads(row['result'])
        status = 'unknown' if row['status'] == 'attempted' else row['status']
        if row['draft_id'] and status in ('unknown','submitted_unconfirmed','server_accepted','local_record_observed','local_record_confirmed'):
            # A crash can leave the caller's outbox behind its durable Hook journal.
            # Reading that evidence never probes the bridge or resubmits anything.
            try:
                journal = self.owner.sender_factory().get(row['draft_id'],spec['binding'])
            except (HookSendError,OSError,sqlite3.Error):
                result['issue'] = '发送账本暂无法核对，显示上次保存结果；不会自动重试。'
            else:
                if journal['status'] in _FINAL_HOOK:
                    status = journal['status']
                    result.update({key:journal[key] for key in ('issue','issueCode','serverId','serverAccepted','localRecordConfirmed','localRecordObserved') if key in journal})
        return {**empty, 'status':status, 'targetId':spec['targetId'], 'targetName':spec['targetName'],
                'createdAt':row['created'], 'expiresAt':row['expires'], 'draftId':row['draft_id'],
                'issue':'通知排队中，尚未提交。' if status=='queued' else '结果未知，不会自动重试。' if status=='unknown' else '', **result}

    def _validate_pending(self, db, row, spec):
        service = self.owner
        if service.engine.stop.is_set(): raise ValueError('工作台正在停止，未提交通知。')
        if row['status'] != 'queued': raise ValueError('通知已取消或已开始提交，不会重复发送。')
        if service.clock() > row['expires']: raise ValueError('通知已超过创建后 10 分钟，未提交。')
        groups,recipients = self._scope(row['account'])
        if row['group_id'] not in groups or spec['targetId'] not in recipients:
            raise ValueError('原群或收件私聊已取消读取，未提交通知。')
        if service.source.busy: raise NotificationDeferred()
        if service._binding(row['account'],row['group_id']) != spec['binding']:
            raise ValueError('数据源已变化，未提交通知。')
        task = db.execute('SELECT * FROM handoffs WHERE id=?', (row['task_id'],)).fetchone()
        if task['version'] != spec['taskVersion'] or task['status'] != 'pending' or task['revoked']:
            raise ValueError('待办状态已变化或原消息已撤回，未提交通知。')
        policy_row,policy = self._policy(db,row['account'],row['group_id'])
        route = db.execute('SELECT * FROM handoff_routes WHERE account=? AND group_id=?', (row['account'],row['group_id'])).fetchone()
        if (policy_row['version'] != spec['policyVersion'] or not policy['enabled'] or
                route['version'] != spec['routeVersion']):
            raise ValueError('负责人或通知策略已变化，未提交通知。')

    def _claim(self, task_id, draft_id):
        service = self.owner
        failure = None
        with service.source.lock, service.engine.sync_lock, service.engine.lock:
            if service.source.busy: raise NotificationDeferred()
            with closing(service._db()) as db:
                row = db.execute('SELECT * FROM handoff_notifications WHERE task_id=?', (task_id,)).fetchone()
            service._handoff_revocations(row['account'],row['group_id'])
            with closing(service._db()) as db, db:
                db.execute('BEGIN IMMEDIATE')
                row = db.execute('SELECT * FROM handoff_notifications WHERE task_id=?', (task_id,)).fetchone()
                try: self._validate_pending(db,row,json.loads(row['spec']))
                except ValueError as error:
                    failure = str(error)
                    status = 'expired' if service.clock() > row['expires'] else 'cancelled'
                    db.execute("UPDATE handoff_notifications SET status=?,result=? WHERE task_id=? AND status='queued'", (status,_json({'issue':failure}),task_id))
                else:
                    db.execute("UPDATE handoff_notifications SET status='attempted',draft_id=?,result=? WHERE task_id=? AND status='queued'",
                               (draft_id,_json({'attemptedAt':service.clock()}),task_id))
        if failure: raise HookSendError('notification_cancelled',failure)

    def _finish(self, task_id, result):
        with closing(self.owner._db()) as db, db:
            row = db.execute('SELECT * FROM handoff_notifications WHERE task_id=?', (task_id,)).fetchone()
            if row['status'] not in ('queued','attempted'): return
            saved = json.loads(row['result'])
            saved.update({key:result[key] for key in ('issue','issueCode','serverId','serverAccepted','localRecordConfirmed','localRecordObserved') if key in result})
            if result['status']=='expired': saved['issue']='通知已过期，未提交。'
            db.execute('UPDATE handoff_notifications SET status=?,draft_id=?,result=? WHERE task_id=?',
                       (result['status'],result.get('draftId',row['draft_id']),_json(saved),task_id))
            if result['status'] in ('blocked','unknown'):
                self.pause_group(db,row['account'],row['group_id'],'通知发送被阻止或结果未知，请核对后重新启用；旧待办不会补发。')

    def tick(self):
        service = self.owner
        if service.engine.stop.is_set() or not service.engine.send_lock.acquire(blocking=False): return
        task_id = None
        try:
            with closing(service._db()) as db:
                row = db.execute("SELECT * FROM handoff_notifications WHERE status='queued' ORDER BY created,task_id LIMIT 1").fetchone()
            if row is None: return
            task_id,spec = row['task_id'],json.loads(row['spec'])
            try:
                with service.source.lock, service.engine.sync_lock, service.engine.lock, closing(service._db()) as db:
                    self._validate_pending(db,row,spec)
                    data = service.engine.adapter.call('messages',account=row['account'],groupId=spec['targetId'])
                    if has_blocking_warnings(data['warnings']): raise ValueError('收件私聊的消息副本无法核对，未提交通知。')
                sender = service.sender_factory()
                result = sender.send_automatic({**spec['binding'], 'targetId':spec['targetId'], 'targetName':spec['targetName'],
                    'text':spec['text'], 'idempotencyKey':spec['idempotencyKey']}, expected_binding=spec['native'],
                    baseline_messages=data['messages'], deadline=row['expires'], before_submit=lambda draft:self._claim(task_id,draft))
            except NotificationDeferred:
                return
            except (ValueError,BridgeError,OSError) as error:
                if isinstance(error,HookSendError) and error.code == 'hook_busy': return
                with closing(service._db()) as db:
                    current = db.execute('SELECT status FROM handoff_notifications WHERE task_id=?', (task_id,)).fetchone()
                status = 'unknown' if current['status']=='attempted' else 'expired' if service.clock()>row['expires'] else 'blocked'
                result = {'status':status, 'issue':str(error)}
            self._finish(task_id,result)
        finally:
            # A programming error or failed final write cannot leave a replayable attempt.
            try:
                if task_id is not None:
                    with closing(service._db()) as db, db:
                        db.execute("UPDATE handoff_notifications SET status='unknown' WHERE task_id=? AND status='attempted'", (task_id,))
            finally:
                service.engine.send_lock.release()

    def run(self):
        try:
            while not self.owner.engine.stop.is_set():
                self.tick()
                self.owner.engine.stop.wait(1)
        except Exception:
            self.failure = '通知线程已停止，请重启工作台后重新核对并启用通知。'
            self.pause_all('通知线程异常，已暂停；人工待办接收独立运行。')
            with self.owner.engine.lock:
                self.owner.engine.error = '通知线程异常，已暂停；请检查日志。人工待办接收独立运行。'
            raise
