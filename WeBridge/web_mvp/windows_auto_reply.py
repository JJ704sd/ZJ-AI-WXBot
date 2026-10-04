"""Explicit per-group Windows @ replies; persistent claims, no backlog or retries."""
from contextlib import closing
import hashlib
import json
import sqlite3
import time
import uuid

from backend import BridgeError
from database_adapter import GROUP_ID, has_blocking_warnings


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
                CREATE TABLE IF NOT EXISTS baselines (
                    account TEXT, group_id TEXT, event_id TEXT,
                    PRIMARY KEY(account,group_id,event_id));
            ''')
            for row in db.execute('SELECT * FROM rules').fetchall():
                rule = json.loads(row['payload'])
                migrated = 'mode' not in rule
                if migrated:
                    rule['mode'] = 'reply'
                if 'approvedCards' in rule or 'policyVersion' in rule:
                    rule['policyVersion'] = rule.get('policyVersion',0)+1
                    migrated = True
                if rule.get('enabled'):
                    rule.update(enabled=False, issue='工作台已重启，请重新核对并启用规则。')
                    migrated = True
                if migrated:
                    self._save(db, row['account'], row['group_id'], rule)
            db.execute("UPDATE events SET status='unknown' WHERE status='attempted'")
        from human_handoffs import HumanHandoffs
        self.handoffs = HumanHandoffs(self)
        from handoff_notifications import HandoffNotifications
        self.notifications = HandoffNotifications(self)
        from approved_replies import ApprovedReplies
        self.approved = ApprovedReplies(self)

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
        return json.loads(row[0]) if row else {'enabled': False, 'text': '', 'cooldown': 30, 'issue': '', 'mode': 'reply'}

    def get(self, account, group):
        rule = self._rule(account, group)
        with closing(self._db()) as db:
            rows = db.execute('SELECT created,status,result FROM events WHERE account=? AND group_id=? ORDER BY created DESC LIMIT 10', (account, group)).fetchall()
        result = {key: rule[key] for key in ('enabled', 'text', 'cooldown', 'issue', 'mode')} | {
            'attempts': [{'createdAt': row['created'], 'status': row['status'], **json.loads(row['result'])} for row in rows]}
        if rule['mode']=='approved':
            result.update(policyVersion=rule['policyVersion'],sendingPaused=rule['sendingPaused'])
        return result

    def _binding(self, account, group):
        self.engine.validate(account, group)
        config = self.source.config
        if (not config or not config.get('autoRefresh') or self.source.error or
                not self.engine.self_id or config.get('selfId') != self.engine.self_id):
            raise ValueError('需要正常的自动更新数据库副本，且本人账号必须已确认。')
        if GROUP_ID.fullmatch(group) is None or group not in (self.engine.store.watched(account) or []):
            raise ValueError('仅支持已勾选读取的群聊。')
        return {'account': account, 'sourceId': account, 'selfId': self.engine.self_id, 'sourceRoot': config['sourceRoot']}

    def _messages(self, account, group):
        data = self.engine.adapter.call('messages', account=account, groupId=group)
        if has_blocking_warnings(data['warnings']):
            raise ValueError('消息副本存在解析警告，自动回复已暂停。')
        return data['messages']

    def _inbound(self, account, group, start, end, cursor=None):
        data = self.engine.adapter.call('inbound_messages', account=account, groupId=group,
                                       start=start, end=end, cursor=cursor)
        if has_blocking_warnings(data['warnings']):
            raise ValueError('消息副本存在解析警告，自动回复已暂停。')
        return data

    def configure(self, account, group, enabled, text, cooldown, *, mode=None):
        if type(enabled) is not bool or type(cooldown) is not int or not 5 <= cooldown <= 3600:
            raise ValueError('开关须为布尔值，回复间隔须为 5–3600 秒。')
        if not isinstance(text, str): raise ValueError('回复文本无效。')
        with self.source.lock, self.engine.sync_lock:
            self.engine.validate(account, group)
            rule = self._rule(account, group)
            # Older clients omit this field; preserving the configured mode
            # prevents an old page from silently restoring automatic sending.
            mode = rule['mode'] if mode is None else mode
            if mode == 'approved' and enabled:
                raise ValueError('请通过批准卡片配置重新核对并批准，旧规则入口不能启用批准回复。')
            if mode not in ('reply', 'handoff', 'approved'):
                raise ValueError('请选择固定回复或新 @ 转人工。')
            if not enabled:
                if mode == 'approved':
                    rule.update(enabled=False,issue='',sendingPaused=False)
                else:
                    rule.update(enabled=False, text=text[:2000], cooldown=cooldown, issue='', mode=mode)
            else:
                if self.source.busy: raise ValueError('副本正在更新，请完成后启用。')
                binding = self._binding(account, group)
                native = None
                if mode == 'reply':
                    sender = self.sender_factory()
                    target = next(row for row in self.engine.group_list if row['id'] == group)
                    # Validate the exact same text/target contract as manual Hook sending.
                    sender._request({**binding, 'targetId': group, 'targetName': target['name'],
                                     'text': text, 'idempotencyKey': uuid.uuid4().hex})
                    native = sender.automation_binding(binding)
                    if not sender.supports_target(group): raise ValueError('当前 Hook 桥不支持这个群聊。')
                rule.update(enabled=True,text=text[:2000],cooldown=cooldown,issue='',mode=mode,
                            activated=self.clock(),lastSent=0,binding=binding,native=native,sendingPaused=False)
            rule['policyVersion'] = rule.get('policyVersion',0)+1
            with closing(self._db()) as db, db:
                if enabled:
                    # The enable snapshot may already contain future-dated rows.
                    # Record all of them, independent of the recent UI window.
                    db.execute('DELETE FROM baselines WHERE account=? AND group_id=?', (account, group))
                    cursor = None
                    while True:
                        page = self._inbound(account, group, rule['activated'], None, cursor)
                        db.executemany('INSERT OR IGNORE INTO baselines VALUES (?,?,?)',
                            ((account, group, self._event_id(account, group, row)) for row in page['messages']))
                        if page['complete']: break
                        cursor = page['cursor']
                self._save(db, account, group, rule)
                if not enabled or mode not in ('handoff','approved'):
                    self.notifications.pause_group(db, account, group, '转人工规则已暂停或切换，请重新核对通知配置。')
            return self.get(account, group)

    @staticmethod
    def _event_id(account, group, message):
        server = message['serverId']
        identity = server if int(server) > 0 else message['id']
        return hashlib.sha256((account+'|'+group+'|'+identity).encode()).hexdigest()

    @staticmethod
    def _trigger(message):
        return {'messageId': message['id'], 'serverId': message['serverId'],
                'senderId': message['senderId'], 'senderName': message['senderName'],
                'timestamp': message['timestamp'], 'text': message['text'][:2000],
                'textTruncated': len(message['text']) > 2000}

    @staticmethod
    def _decision(rule, message, cooldown):
        """Freeze the approved reply and its trigger before any send attempt."""
        return {'replyText': rule['text'], 'decision': 'cooldown_skipped' if cooldown else 'reply',
                'trigger': WindowsAutoReply._trigger(message)}

    def _pause(self, account, group, rule, issue):
        rule.update(enabled=False, issue=issue,policyVersion=rule.get('policyVersion',0)+1)
        with closing(self._db()) as db, db:
            self._save(db, account, group, rule)
            self.notifications.pause_group(db, account, group, issue)

    def pause_unwatched(self, account):
        # Called under source.lock + sync_lock by the subscriptions endpoint.
        with closing(self._db()) as db:
            rows = db.execute('SELECT group_id,payload FROM rules WHERE account=?', (account,)).fetchall()
        for row in rows:
            rule = json.loads(row['payload'])
            if rule.get('enabled') and row['group_id'] not in (self.engine.store.watched(account) or []):
                self._pause(account, row['group_id'], rule, '已取消群聊读取，规则已关闭。')

    def pause_all(self, *, sending_only=False):
        with self.source.lock, self.engine.sync_lock:
            with closing(self._db()) as db:
                rows = db.execute('SELECT * FROM rules').fetchall()
            for row in rows:
                rule = json.loads(row['payload'])
                if rule['enabled'] and sending_only and rule['mode']=='approved':
                    with closing(self._db()) as db, db:
                        self.approved.pause_sending(db,row['account'],row['group_id'],rule)
                    continue
                if rule['enabled'] and (not sending_only or rule['mode'] == 'reply'):
                    issue = 'Hook 已断开，固定回复已暂停，请核对后重新启用。' if sending_only else '消息同步异常，规则已暂停，请核对后重新启用。'
                    self._pause(row['account'], row['group_id'], rule, issue)

    def _handoff_revocations(self, account, group):
        """Caller holds source/subscription locks; inspect without handling events."""
        if self.source.busy or self.source.error:
            raise ValueError('副本正在更新或读取异常，请恢复后核对待办。')
        now, cursor = self.clock(), None
        while True:
            page = self._inbound(account, group, now, now, cursor)
            cursor = page['cursor']
            if cursor['phase'] != 'revokes':
                with closing(self._db()) as db, db:
                    self.handoffs.revoke(db, account, group, cursor['revoked'], now)
                return

    @staticmethod
    def eligible(message, account, activated, now):
        # Adapter decoding has already validated coordinates and populated these
        # required fields. This layer checks business eligibility only.
        stamp = message['timestamp']
        return (activated < stamp <= now+5 and now-stamp <= 120
                and message['source'] == 'database' and message['sourceId'] == account
                and message['isSelfKnown'] is True and message['isSelf'] is False
                and bool(message['senderId']) and message['mentionSelf'] is True
                and message['mentionEveryone'] is False and message['mentionStatus'] == 'structured'
                and message['decodeStatus'] == 'ok' and message['kind'] not in ('revoke', 'system')
                and int(message['serverId']) > 0)

    def tick(self):
        # Same lock order as rule writes: source -> subscriptions -> engine validation.
        with self.source.lock, self.engine.sync_lock:
            if self.source.busy: return
            with closing(self._db()) as db:
                rules = db.execute('SELECT * FROM rules').fetchall()
            for saved in rules:
                rule = json.loads(saved['payload'])
                if not rule.get('enabled') or rule['mode']=='approved': continue
                sending = rule['mode'] == 'reply'
                if sending and not self.engine.send_lock.acquire(blocking=False):
                    continue
                try:
                    account, group = saved['account'], saved['group_id']
                    try:
                        binding = self._binding(account, group)
                        if binding != rule['binding']:
                            raise ValueError('账号或数据源已变化，请重新核对并启用。')
                        sender, evidence = None, None
                        if rule['mode'] == 'reply':
                            sender = self.sender_factory()
                            if sender.automation_binding(binding) != rule['native']:
                                raise ValueError('Hook 进程已变化，请重新核对并启用。')
                            # This remains separate from pages of incoming messages.
                            evidence = self._messages(account, group)
                    except (ValueError, BridgeError, OSError, sqlite3.Error):
                        self._pause(account, group, rule, '数据源、群聊读取或 Hook 连接异常，规则已暂停，请核对后重新启用。')
                        continue
                    observed = self.clock()
                    start, end = max(rule['activated'], observed-120), observed+5
                    cursor, reconciled = None, False
                    while rule['enabled']:
                        try:
                            page = self._inbound(account, group, start, end, cursor)
                        except (ValueError, BridgeError, OSError, sqlite3.Error):
                            self._pause(account, group, rule, '消息增量读取异常，规则已暂停，请核对后重新启用。')
                            break
                        if not reconciled and page['cursor']['phase'] != 'revokes':
                            with closing(self._db()) as db, db:
                                self.handoffs.revoke(db, account, group, page['cursor']['revoked'], self.clock())
                            reconciled = True
                        for message in page['messages']:
                            self._handle_message(account, group, rule, binding, sender, message, observed, evidence)
                            if not rule['enabled']: break
                        if page['complete']: break
                        cursor = page['cursor']
                finally:
                    if sending:
                        self.engine.send_lock.release()
        self.approved.tick()

    def _handle_message(self, account, group, rule, binding, sender, message, observed, evidence):
        # Every page belongs to the same observed burst. Reading a later page
        # never turns a cooldown skip into a delayed reply.
        now = self.clock()
        event = self._event_id(account, group, message)
        if not self.eligible(message, account, rule['activated'], now): return
        if rule['mode'] == 'handoff':
            target = next(row for row in self.engine.group_list if row['id'] == group)
            detail = {'decision': 'handoff', 'taskId': event, 'issue': '已创建本机待办，通知状态见待办详情。'}
            with closing(self._db()) as db, db:
                if db.execute('SELECT 1 FROM baselines WHERE account=? AND group_id=? AND event_id=?',
                              (account, group, event)).fetchone(): return
                claimed = db.execute('INSERT OR IGNORE INTO events VALUES (?,?,?,?,?,?)',
                    (event, account, group, now, 'human_pending', json.dumps(detail, ensure_ascii=False))).rowcount
                if claimed:
                    self.handoffs.enqueue(db, event, account, group, target['name'], self._trigger(message), now)
            return
        cooldown = observed-rule['lastSent'] < rule['cooldown']
        detail = self._decision(rule, message, cooldown)
        with closing(self._db()) as db, db:
            if db.execute('SELECT 1 FROM baselines WHERE account=? AND group_id=? AND event_id=?',
                          (account, group, event)).fetchone(): return
            claimed = db.execute('INSERT OR IGNORE INTO events VALUES (?,?,?,?,?,?)',
                (event, account, group, now, 'cooldown_skipped' if cooldown else 'attempted',
                 json.dumps(detail, ensure_ascii=False))).rowcount
        if not claimed or cooldown: return
        # This claim commits before contacting native code. Never replay it.
        target = next(row for row in self.engine.group_list if row['id'] == group)
        status = 'unknown'
        try:
            result = sender.send_automatic({**binding, 'targetId': group, 'targetName': target['name'],
                'text': rule['text'], 'idempotencyKey': 'reply_'+event},
                expected_binding=rule['native'], baseline_messages=evidence)
            status = result['status']
            detail.update({key: result[key] for key in ('draftId', 'issue') if key in result})
        except (ValueError, BridgeError, OSError, sqlite3.Error):
            detail['issue'] = '发送未确认，不会自动重试；请查看微信。'
        finally:
            # An unexpected programming error still leaves a durable unknown
            # claim, but propagates instead of being hidden.
            if status == 'unknown':
                detail.setdefault('issue', '发送未确认，不会自动重试；请查看微信。')
            rule['lastSent'] = now
            if status not in ('submitted_unconfirmed', 'server_accepted', 'local_record_confirmed', 'local_record_observed'):
                rule.update(enabled=False,policyVersion=rule.get('policyVersion',0)+1,
                            issue='发送被阻止或结果未知，规则已暂停；本条不会重发。')
            with closing(self._db()) as db, db:
                db.execute('UPDATE events SET status=?,result=? WHERE id=?', (status, json.dumps(detail, ensure_ascii=False), event))
                self._save(db, account, group, rule)
