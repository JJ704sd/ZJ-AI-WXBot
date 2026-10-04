"""Local human work queue; approved notifications enter a separate durable outbox."""
from contextlib import closing
import json

from database_adapter import GROUP_ID
from execution_history import _cursor_decode, _cursor_encode, _digest


class HandoffConflict(ValueError):
    pass


def _owner_label(value):
    if not isinstance(value, str) or len(value)>80 or any(ch in value for ch in '\r\n\x00'):
        raise ValueError('负责人须为不超过 80 字的单行文本。')
    try: value.encode('utf-8')
    except UnicodeError: raise ValueError('负责人包含无效字符。') from None
    return value.strip()


class HumanHandoffs:
    def __init__(self, owner):
        self.owner = owner
        with closing(owner._db()) as db, db:
            db.execute('''CREATE TABLE IF NOT EXISTS handoffs (
                id TEXT PRIMARY KEY, account TEXT NOT NULL, group_id TEXT NOT NULL,
                group_name TEXT NOT NULL, trigger TEXT NOT NULL, reason TEXT NOT NULL,
                owner TEXT NOT NULL, status TEXT NOT NULL, created REAL NOT NULL,
                updated REAL NOT NULL, version INTEGER NOT NULL, note TEXT NOT NULL,
                revoked INTEGER NOT NULL DEFAULT 0)''')
            db.execute('''CREATE TABLE IF NOT EXISTS handoff_changes (
                task_id TEXT NOT NULL, version INTEGER NOT NULL, action TEXT NOT NULL,
                status TEXT NOT NULL, owner TEXT NOT NULL, note TEXT NOT NULL,
                created REAL NOT NULL, PRIMARY KEY(task_id,version))''')
            db.execute('CREATE INDEX IF NOT EXISTS handoff_scope ON handoffs(account,group_id,status,created DESC,id DESC)')
            db.execute('''CREATE TABLE IF NOT EXISTS handoff_routes (
                account TEXT NOT NULL, group_id TEXT NOT NULL, owner TEXT NOT NULL,
                version INTEGER NOT NULL, updated REAL NOT NULL, PRIMARY KEY(account,group_id))''')

    def _record(self, row, db):
        return {'id': row['id'], 'groupId': row['group_id'], 'groupName': row['group_name'],
            'trigger': json.loads(row['trigger']), 'reason': row['reason'], 'owner': row['owner'],
            'status': row['status'], 'createdAt': row['created'], 'updatedAt': row['updated'],
            'version': row['version'], 'note': row['note'], 'revoked': bool(row['revoked']),
            'notification': self.owner.notifications.summary(row,db)}

    @staticmethod
    def _route(group, name, row):
        return {'groupId':group, 'groupName':name, 'owner':row['owner'] if row is not None else '',
            'version':row['version'] if row is not None else 0, 'updatedAt':row['updated'] if row is not None else None}

    def _routing_groups(self, account):
        scope = self._scope(account)
        return {row['id']:row['name'] for row in self.owner.engine.group_list
                if row['id'] in scope and GROUP_ID.fullmatch(row['id']) is not None}

    def routing(self, account):
        service = self.owner
        with service.source.lock, service.engine.sync_lock, service.engine.lock:
            groups = self._routing_groups(account)
            with closing(service._db()) as db:
                saved = {row['group_id']:row for row in db.execute('''SELECT * FROM handoff_routes
                    WHERE account=? AND group_id IN (SELECT value FROM json_each(?))''',
                    (account,json.dumps(list(groups))))}
            return {'routes':[self._route(group,name,saved.get(group)) for group,name in groups.items()]}

    def set_routing(self, account, groupId, version, owner):
        if not isinstance(groupId, str) or not 1<=len(groupId)<=256:
            raise ValueError('默认负责人会话无效。')
        if type(version) is not int or version<0:
            raise ValueError('默认负责人版本无效，请刷新后操作。')
        owner = _owner_label(owner)
        service = self.owner
        with service.source.lock, service.engine.sync_lock, service.engine.lock:
            groups = self._routing_groups(account)
            if groupId not in groups: raise ValueError('请先勾选读取当前群。')
            with closing(service._db()) as db, db:
                db.execute('BEGIN IMMEDIATE')
                row = db.execute('SELECT * FROM handoff_routes WHERE account=? AND group_id=?', (account,groupId)).fetchone()
                current = row['version'] if row is not None else 0
                if current!=version: raise HandoffConflict('默认负责人已更新，请刷新后核对。')
                if row is not None and row['owner']==owner: return self._route(groupId,groups[groupId],row)
                now = service.clock()
                if row is None:
                    db.execute('INSERT INTO handoff_routes VALUES (?,?,?,?,?)', (account,groupId,owner,1,now))
                else:
                    db.execute('UPDATE handoff_routes SET owner=?,version=?,updated=? WHERE account=? AND group_id=?',
                        (owner,version+1,now,account,groupId))
                service.notifications.pause_group(db,account,groupId,'默认负责人已变化，请重新核对私聊收件人并启用通知。')
                return self._route(groupId,groups[groupId],{'owner':owner,'version':version+1,'updated':now})

    def enqueue(self, db, event, account, group, group_name, trigger, created, *, reason='群规则要求人工处理'):
        route = db.execute('SELECT owner FROM handoff_routes WHERE account=? AND group_id=?', (account,group)).fetchone()
        assigned = route['owner'] if route is not None else ''
        inserted = db.execute('INSERT OR IGNORE INTO handoffs VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)',
            (event, account, group, group_name, json.dumps(trigger, ensure_ascii=False),
             reason, assigned, 'pending', created, created, 1, '', 0)).rowcount
        if inserted:
            db.execute('INSERT INTO handoff_changes VALUES (?,?,?,?,?,?,?)',
                (event, 1, 'created', 'pending', assigned, '', created))
            task = db.execute('SELECT * FROM handoffs WHERE id=?', (event,)).fetchone()
            self.owner.notifications.enqueue(db,task)

    def revoke(self, db, account, group, server_ids, now):
        rows = db.execute('''SELECT * FROM handoffs WHERE account=? AND group_id=? AND revoked=0
            AND json_extract(trigger,'$.serverId') IN (SELECT value FROM json_each(?))''',
            (account, group, json.dumps(server_ids))).fetchall()
        for row in rows:
            trigger = json.loads(row['trigger'])
            trigger.update(text='', textTruncated=False)
            db.execute('UPDATE handoffs SET trigger=?,revoked=1,updated=?,version=version+1 WHERE id=?',
                (json.dumps(trigger, ensure_ascii=False), now, row['id']))
            db.execute("""UPDATE events SET result=json_set(result,'$.trigger.text','',
                '$.trigger.textTruncated',json('false')) WHERE id=? AND json_type(result,'$.trigger')='object'""",
                (row['id'],))
            db.execute('INSERT INTO handoff_changes VALUES (?,?,?,?,?,?,?)',
                (row['id'], row['version']+1, 'revoked', row['status'], row['owner'], row['note'], now))
            self.owner.notifications.cancel_task(db,row['id'],'原消息已撤回，未提交通知。')

    def detail(self, account, id):
        self._validate_id(id)
        service = self.owner
        with service.source.lock, service.engine.sync_lock, service.engine.lock:
            groups = self._scope(account)
            with closing(service._db()) as db:
                row = self._task(db, account, id, groups)
            service._handoff_revocations(account, row['group_id'])
            with closing(service._db()) as db:
                record = self._record(self._task(db, account, id, groups),db)
                rows = db.execute('SELECT * FROM handoff_changes WHERE task_id=? ORDER BY version DESC LIMIT 101',
                    (id,)).fetchall()
            return {'record': record, 'changes': [
                {'version': change['version'], 'action': change['action'], 'status': change['status'],
                 'owner': change['owner'], 'note': change['note'], 'createdAt': change['created']}
                for change in rows[:100]], 'historyTruncated': len(rows) > 100}

    def list(self, account, *, status='open', groupId='', limit=50, cursor='', ownerFilter='all', owner=''):
        if status not in ('open', 'pending', 'in_progress', 'completed', 'all'):
            raise ValueError('待办状态筛选无效。')
        if ownerFilter not in ('all','unassigned','owner'):
            raise ValueError('负责人筛选无效。')
        owner = _owner_label(owner)
        if ownerFilter=='owner' and not owner:
            raise ValueError('请选择要筛选的负责人。')
        try: size = int(limit)
        except (ValueError, TypeError): raise ValueError('待办条数须为 1 至 200 的整数。') from None
        if str(size) != str(limit) or not 1 <= size <= 200:
            raise ValueError('待办条数须为 1 至 200 的整数。')
        if not isinstance(groupId, str) or len(groupId) > 256:
            raise ValueError('会话筛选无效。')
        if not isinstance(cursor, str): raise ValueError('待办翻页游标无效。')
        service = self.owner
        with service.source.lock, service.engine.sync_lock, service.engine.lock:
            groups = self._scope(account)
            if groupId and groupId not in groups:
                raise ValueError('请先勾选读取原群。')
            watched = service.engine.store.rows('SELECT updated_at FROM subscriptions WHERE account=?', (account,))
            scope = _digest({'kind': 'handoffs', 'account': account, 'groups': sorted(groups),
                'watched': watched, 'status': status, 'group': groupId, 'limit': size,
                'ownerFilter':ownerFilter, 'owner':owner,
                'store': str(service.engine.store.path.resolve())})
            position = _cursor_decode(cursor, scope)
            conditions = ['account=?', 'group_id IN (SELECT value FROM json_each(?))']
            args = [account, json.dumps([groupId] if groupId else sorted(groups))]
            if status == 'open': conditions.append("status IN ('pending','in_progress')")
            elif status != 'all':
                conditions.append('status=?'); args.append(status)
            if ownerFilter=='unassigned': conditions.append("owner=''")
            elif ownerFilter=='owner':
                conditions.append('owner=?'); args.append(owner)
            if position:
                created, id = position['last']
                conditions.append('(created < ? OR (created = ? AND id < ?))')
                args.extend((created, created, id))
            with closing(service._db()) as db:
                rows = db.execute('SELECT * FROM handoffs WHERE '+' AND '.join(conditions)+
                    ' ORDER BY created DESC,id DESC LIMIT ?', (*args, size+1)).fetchall()
                visible = json.dumps(sorted(groups))
                owners = [row['owner'] for row in db.execute('''SELECT owner FROM handoff_routes
                    WHERE account=? AND group_id IN (SELECT value FROM json_each(?)) AND owner!=''
                    UNION SELECT owner FROM handoffs
                    WHERE account=? AND group_id IN (SELECT value FROM json_each(?)) AND owner!=''
                    ORDER BY owner''', (account,visible,account,visible))]
                records = [self._record(row,db) for row in rows[:size]]
            more = len(rows) > size
            rows = rows[:size]
            return {'records': records, 'hasMore': more,
                'nextCursor': _cursor_encode(scope, [rows[-1]['created'], rows[-1]['id']]) if more else '',
                'limit': size, 'owners':owners}

    def action(self, account, id, version, action, *, owner='', note=''):
        self._validate_id(id)
        if type(version) is not int or version < 1:
            raise ValueError('待办版本无效，请刷新后操作。')
        if action not in ('claim', 'release', 'complete', 'reopen'):
            raise ValueError('待办操作无效。')
        owner = _owner_label(owner)
        if action == 'claim' and not owner:
            raise ValueError('领取待办时请填写负责人。')
        if not isinstance(note, str) or len(note) > 2000:
            raise ValueError('处理备注须为不超过 2000 字的文本。')
        service = self.owner
        with service.source.lock, service.engine.sync_lock, service.engine.lock:
            groups = self._scope(account)
            with closing(service._db()) as db:
                row = self._task(db, account, id, groups)
            if action == 'complete':
                service._handoff_revocations(account, row['group_id'])
            with closing(service._db()) as db, db:
                row = self._task(db, account, id, groups)
                if row['version'] != version:
                    raise HandoffConflict('待办已被更新，请刷新后核对。')
                expected, state = {'claim': ('pending', 'in_progress'),
                    'release': ('in_progress', 'pending'), 'complete': ('in_progress', 'completed'),
                    'reopen': ('completed', 'pending')}[action]
                if row['status'] != expected:
                    raise ValueError('当前待办状态不支持此操作，请刷新后核对。')
                assigned = owner if action == 'claim' else row['owner'] if action == 'complete' else ''
                now = service.clock()
                changed = db.execute('''UPDATE handoffs SET status=?,owner=?,note=?,updated=?,version=version+1
                    WHERE id=? AND account=? AND version=?''',
                    (state, assigned, note, now, id, account, version)).rowcount
                if not changed:
                    raise HandoffConflict('待办已被更新，请刷新后核对。')
                db.execute('INSERT INTO handoff_changes VALUES (?,?,?,?,?,?,?)',
                    (id, version+1, action, state, assigned, note, now))
                service.notifications.cancel_task(db,id,'待办状态或负责人已变化，未提交通知。')
                return self._record(self._task(db, account, id, groups),db)

    def _scope(self, account):
        engine = self.owner.engine
        if (not engine.read_only or not account or account != engine.account or
                engine.logging_out or engine.connection.get('status') != 'snapshot_ready'):
            raise ValueError('数据源未就绪或账号已变化，请刷新页面。')
        auth = engine.adapter.auth()
        if auth['status'] != 'snapshot_ready' or auth['sourceId'] != account:
            raise ValueError('数据源未就绪或账号已变化，请刷新页面。')
        return {row['id'] for row in engine.group_list} & set(engine.store.watched(account) or [])

    @staticmethod
    def _validate_id(id):
        if not isinstance(id, str) or not 1 <= len(id) <= 512:
            raise ValueError('待办标识无效。')

    @staticmethod
    def _task(db, account, id, groups):
        row = db.execute('SELECT * FROM handoffs WHERE id=? AND account=?', (id, account)).fetchone()
        if row is None or row['group_id'] not in groups:
            raise ValueError('待办不存在或原群已取消读取。')
        return row
