"""Explicit per-group Windows @ replies; persistent claims, no backlog or retries."""
from contextlib import closing
import hashlib
import json
import math
import sqlite3
import time
import uuid


class WindowsAutoReply:
    def __init__(self, engine, database_service, sender_factory, *, clock=time.time):
        self.engine, self.source, self.sender_factory, self.clock = engine, database_service, sender_factory, clock
        self.path = engine.store.path.parent / 'windows-auto-reply.sqlite'
        with closing(self._db()) as db, db:
            db.executescript('''
                CREATE TABLE IF NOT EXISTS rules (
                    account TEXT, group_id TEXT, payload TEXT, PRIMARY KEY(account,group_id));
                CREATE TABLE IF NOT EXISTS events (
                    id TEXT PRIMARY KEY, account TEXT, group_id TEXT, created REAL, status TEXT, result TEXT);
            ''')
            for row in db.execute('SELECT * FROM rules').fetchall():
                rule = json.loads(row['payload'])
                if rule.get('enabled'):
                    rule.update(enabled=False, issue='工作台已重启，请重新核对并启用规则。')
                    self._save(db, row['account'], row['group_id'], rule)
            db.execute("UPDATE events SET status='unknown' WHERE status='attempted'")

    def _db(self):
        db = sqlite3.connect(self.path, timeout=10)
        db.row_factory = sqlite3.Row
        db.execute('PRAGMA synchronous=FULL')
        return db

    @staticmethod
    def _save(db, account, group, rule):
        db.execute('INSERT OR REPLACE INTO rules VALUES (?,?,?)', (account, group, json.dumps(rule, ensure_ascii=False)))

    def _rule(self, account, group):
        with closing(self._db()) as db:
            row = db.execute('SELECT payload FROM rules WHERE account=? AND group_id=?', (account, group)).fetchone()
        return json.loads(row[0]) if row else {'enabled': False, 'text': '', 'cooldown': 30, 'issue': ''}

    def get(self, account, group):
        rule = self._rule(account, group)
        with closing(self._db()) as db:
            rows = db.execute('SELECT created,status,result FROM events WHERE account=? AND group_id=? ORDER BY created DESC LIMIT 10', (account, group)).fetchall()
        return {key: rule.get(key) for key in ('enabled', 'text', 'cooldown', 'issue')} | {
            'attempts': [{'createdAt': row['created'], 'status': row['status'], **json.loads(row['result'])} for row in rows]}

    def _binding(self, account, group):
        self.engine.validate(account, group)
        config = self.source.config
        if (not config or not config.get('autoRefresh') or self.source.error or
                not self.engine.self_id or config.get('selfId') != self.engine.self_id):
            raise ValueError('需要正常的自动更新数据库副本，且本人账号必须已确认。')
        if not group.endswith('@chatroom') or group not in (self.engine.store.watched(account) or []):
            raise ValueError('仅支持已勾选读取的群聊。')
        return {'account': account, 'sourceId': account, 'selfId': self.engine.self_id, 'sourceRoot': config['sourceRoot']}

    def _messages(self, account, group):
        data = self.engine.adapter.call('messages', account=account, groupId=group)
        if data.get('warnings'):
            raise ValueError('消息副本存在解析警告，自动回复已暂停。')
        return data['messages']

    def configure(self, account, group, enabled, text, cooldown):
        if type(enabled) is not bool or type(cooldown) is not int or not 5 <= cooldown <= 3600:
            raise ValueError('开关须为布尔值，回复间隔须为 5–3600 秒。')
        if not isinstance(text, str): raise ValueError('回复文本无效。')
        with self.source.lock, self.engine.sync_lock:
            self.engine.validate(account, group)
            rule = self._rule(account, group)
            if not enabled:
                rule.update(enabled=False, text=text[:2000], cooldown=cooldown, issue='')
            else:
                if self.source.busy: raise ValueError('副本正在更新，请完成后启用。')
                binding = self._binding(account, group)
                sender = self.sender_factory()
                target = next(row for row in self.engine.group_list if row['id'] == group)
                # Validate the exact same text/target contract as manual Hook sending.
                sender._request({**binding, 'targetId': group, 'targetName': target['name'],
                                 'text': text, 'idempotencyKey': uuid.uuid4().hex})
                native = sender.automation_binding(binding)
                if not sender.supports_target(group): raise ValueError('当前 Hook 桥不支持这个群聊。')
                rows = self._messages(account, group)
                rule = {'enabled': True, 'text': text, 'cooldown': cooldown, 'issue': '',
                        'activated': self.clock(), 'lastSent': 0,
                        'binding': binding, 'native': native,
                        'baseline': [self._event_id(account, group, row) for row in rows]}
            with closing(self._db()) as db, db: self._save(db, account, group, rule)
            return self.get(account, group)

    @staticmethod
    def _event_id(account, group, message):
        server = message.get('serverId', '')
        identity = str(server) if str(server).isdigit() and int(server) > 0 else message.get('id', '')
        return hashlib.sha256((account+'|'+group+'|'+identity).encode()).hexdigest()

    def _pause(self, account, group, rule, issue):
        rule.update(enabled=False, issue=issue)
        with closing(self._db()) as db, db: self._save(db, account, group, rule)

    def pause_unwatched(self, account):
        # Called under source.lock + sync_lock by the subscriptions endpoint.
        with closing(self._db()) as db:
            rows = db.execute('SELECT group_id,payload FROM rules WHERE account=?', (account,)).fetchall()
        for row in rows:
            rule = json.loads(row['payload'])
            if rule.get('enabled') and row['group_id'] not in (self.engine.store.watched(account) or []):
                self._pause(account, row['group_id'], rule, '已取消群聊读取，规则已关闭。')

    def pause_all(self):
        with self.source.lock, self.engine.sync_lock:
            with closing(self._db()) as db:
                rows = db.execute('SELECT * FROM rules').fetchall()
            for row in rows:
                rule = json.loads(row['payload'])
                if rule.get('enabled'):
                    self._pause(row['account'], row['group_id'], rule, '消息同步异常，规则已暂停，请核对后重新启用。')

    @staticmethod
    def eligible(message, account, activated, now):
        stamp = message.get('timestamp')
        return (type(stamp) in (int, float) and math.isfinite(stamp) and activated < stamp <= now+5 and now-stamp <= 120
                and message.get('source') == 'database' and message.get('sourceId') == account
                and message.get('isSelfKnown') is True and message.get('isSelf') is False
                and bool(message.get('senderId')) and message.get('mentionSelf') is True
                and message.get('mentionEveryone') is False and message.get('mentionStatus') == 'structured'
                and message.get('decodeStatus') == 'ok' and message.get('kind') not in ('revoke', 'system')
                and str(message.get('serverId', '')).isdigit() and int(message['serverId']) > 0)

    def tick(self):
        # Same lock order as rule writes: source -> subscriptions -> engine validation.
        with self.source.lock, self.engine.sync_lock:
            if self.source.busy: return
            with closing(self._db()) as db:
                rules = db.execute('SELECT * FROM rules').fetchall()
            for saved in rules:
                rule = json.loads(saved['payload'])
                if not rule.get('enabled'): continue
                account, group = saved['account'], saved['group_id']
                try:
                    binding = self._binding(account, group)
                    sender = self.sender_factory()
                    if binding != rule['binding'] or sender.automation_binding(binding) != rule['native']:
                        raise ValueError('账号或 Hook 进程已变化，请重新核对并启用。')
                    rows = self._messages(account, group)
                except Exception:
                    self._pause(account, group, rule, '数据源、群聊读取或 Hook 连接异常，规则已暂停，请核对后重新启用。')
                    continue
                now = self.clock()
                for message in rows:
                    event = self._event_id(account, group, message)
                    if event in rule['baseline'] or not self.eligible(message, account, rule['activated'], now): continue
                    cooldown = now-rule['lastSent'] < rule['cooldown']
                    with closing(self._db()) as db, db:
                        claimed = db.execute('INSERT OR IGNORE INTO events VALUES (?,?,?,?,?,?)',
                            (event, account, group, now, 'cooldown_skipped' if cooldown else 'attempted', '{}')).rowcount
                    if not claimed or cooldown: continue
                    # This claim commits before contacting native code. Never replay it.
                    target = next(row for row in self.engine.group_list if row['id'] == group)
                    try:
                        result = sender.send_automatic({**binding, 'targetId': group, 'targetName': target['name'],
                            'text': rule['text'], 'idempotencyKey': 'reply_'+event},
                            expected_binding=rule['native'], baseline_messages=rows)
                        status = result['status']
                        detail = {key: result[key] for key in ('draftId', 'issue') if key in result}
                    except Exception:
                        status, detail = 'unknown', {'issue': '发送未确认，不会自动重试；请查看微信。'}
                    rule['lastSent'] = now
                    if status not in ('submitted_unconfirmed', 'server_accepted', 'local_record_confirmed', 'local_record_observed'):
                        rule.update(enabled=False, issue='发送被阻止或结果未知，规则已暂停；本条不会重发。')
                    with closing(self._db()) as db, db:
                        db.execute('UPDATE events SET status=?,result=? WHERE id=?', (status, json.dumps(detail, ensure_ascii=False), event))
                        self._save(db, account, group, rule)
                    if not rule['enabled']: break
