"""Versioned, explicitly approved whole-message answers and human fallback."""
from contextlib import closing
import json
import re
import sqlite3

from backend import BridgeError
from database_adapter import GROUP_ID
from windows_hook_sender import HookSendError, validate_text


REASONS = {
    'matched':'完整问法匹配已批准卡片。',
    'unmatched':'未匹配已批准的完整问法，请人工核对。',
    'unsupported_message':'消息不是普通文本，请人工核对。',
    'cooldown':'处于批准回复冷却期，请人工处理。',
    'sending_unavailable':'批准回复发送已暂停，请人工处理。',
    'submission_unknown':'发送结果未知，请先核对微信记录，勿盲目重发。',
}


class ApprovedPolicyConflict(ValueError):
    pass


class ApprovedDeferred(Exception):
    """A refreshing snapshot does not revoke otherwise valid approval."""


def _normalize(value):
    return value.replace('\r\n','\n').strip()


def _bounded(value, limit, label):
    if not isinstance(value,str) or not value.strip() or len(value)>limit or '\x00' in value:
        raise ValueError(f'{label}须为 1–{limit} 字符的有效文本。')
    try: value.encode('utf-8')
    except UnicodeError: raise ValueError(f'{label}包含无效字符。') from None
    return value


def _cards(cards):
    if not isinstance(cards,list) or len(cards)>20: raise ValueError('每群最多保存 20 张批准卡片。')
    result, ids, questions = [], set(), set()
    for card in cards:
        if not isinstance(card,dict): raise ValueError('批准卡片格式无效。')
        id = card.get('id')
        if not isinstance(id,str) or not re.fullmatch(r'[A-Za-z0-9_-]{16,100}',id) or id in ids:
            raise ValueError('批准卡片标识无效或重复。')
        ids.add(id)
        variants = card.get('questions')
        if not isinstance(variants,list) or not 1<=len(variants)<=5:
            raise ValueError('每张卡片须填写 1–5 条完整问法。')
        normalized = []
        for question in variants:
            if not isinstance(question,str): raise ValueError('完整问法须为文本。')
            question = _bounded(_normalize(question),500,'完整问法')
            if question in questions: raise ValueError('完整问法不能在卡片内或不同卡片间重复。')
            questions.add(question)
            normalized.append(question)
        validate_text(card.get('replyText'))
        result.append({'id':id, 'name':_bounded(card.get('name'),80,'卡片名称'), 'questions':normalized,
            'sourceTitle':_bounded(card.get('sourceTitle'),120,'资料标题'),
            'sourceVersion':_bounded(card.get('sourceVersion'),80,'资料版本'),
            'sourceText':_bounded(card.get('sourceText'),2000,'批准资料'), 'replyText':card['replyText']})
    return result


def _match(cards, text, version):
    normalized = _normalize(text)
    card = next((card for card in cards if normalized in card['questions']), None)
    reason = 'matched' if card is not None else 'unmatched'
    return {'decision':'reply' if card is not None else 'handoff', 'reasonCode':reason,
        'reason':REASONS[reason], 'matchedCard':card, 'replyText':card['replyText'] if card is not None else '',
        'policyVersion':version}


class ApprovedReplies:
    def __init__(self, owner):
        self.owner = owner
        # A crash after the durable event claim cannot make that event retryable.
        with closing(owner._db()) as db, db:
            rows = db.execute("""SELECT e.* FROM events e WHERE e.status='unknown'
                AND json_type(e.result,'$.approvedPolicy')='object'
                AND NOT EXISTS (SELECT 1 FROM handoffs h WHERE h.id=e.id)""").fetchall()
            for row in rows:
                detail = json.loads(row['result'])
                detail.update(reasonCode='submission_unknown',issue=REASONS['submission_unknown'],taskId=row['id'])
                db.execute('UPDATE events SET result=? WHERE id=?',(json.dumps(detail,ensure_ascii=False),row['id']))
                owner.handoffs.enqueue(db,row['id'],row['account'],row['group_id'],detail['targetName'],
                    detail['trigger'],row['created'],reason=REASONS['submission_unknown'])

    def _context(self, account, group):
        engine = self.owner.engine
        if not account or account!=engine.account: raise ValueError('账号已变化，请重新加载。')
        if not isinstance(group,str) or GROUP_ID.fullmatch(group) is None:
            raise ValueError('请选择当前账号的有效群聊。')
        target = next((row for row in engine.group_list if row['id']==group),None)
        if target is None: raise ValueError('请选择当前账号的有效群聊。')
        return target['name']

    @staticmethod
    def _view(account, group, rule):
        return {'account':account, 'groupId':group, 'version':rule.get('policyVersion',0),
            'enabled':rule['mode']=='approved' and rule['enabled'], 'mode':rule['mode'],
            'cooldown':rule.get('policyCooldown',rule['cooldown']), 'cards':rule.get('approvedCards',[]),
            'issue':rule['issue'], 'sendingPaused':rule.get('sendingPaused',False)}

    def get(self, account, groupId):
        with self.owner.engine.lock:
            self._context(account,groupId)
            return self._view(account,groupId,self.owner._rule(account,groupId))

    @staticmethod
    def _version(version):
        if type(version) is not int or version<0: raise ValueError('批准策略版本无效，请重新加载。')

    def _current(self, account, group, version):
        name = self._context(account,group)
        rule = self.owner._rule(account,group)
        if rule.get('policyVersion',0)!=version:
            raise ApprovedPolicyConflict('群规则或批准卡片已变化，请重新加载后核对。')
        return rule, name

    def preview(self, data):
        if not isinstance(data,dict): raise ValueError('预览请求无效。')
        account, group, version = data.get('account'), data.get('groupId'), data.get('version')
        self._version(version)
        cards = _cards(data.get('cards'))
        text = data.get('text')
        if not isinstance(text,str): raise ValueError('待匹配内容须为文本。')
        try: text.encode('utf-8')
        except UnicodeError: raise ValueError('待匹配内容包含无效字符。') from None
        with self.owner.engine.lock:
            self._current(account,group,version)
            return _match(cards,text,version)

    def configure(self, data):
        if not isinstance(data,dict): raise ValueError('批准策略请求无效。')
        account, group, version = data.get('account'), data.get('groupId'), data.get('version')
        enabled, cooldown = data.get('enabled'), data.get('cooldown')
        self._version(version)
        if type(enabled) is not bool or type(cooldown) is not int or not 5<=cooldown<=3600:
            raise ValueError('开关须为布尔值，回复间隔须为 5–3600 秒。')
        cards = _cards(data.get('cards'))
        if enabled and not cards: raise ValueError('请至少批准一张完整卡片。')
        owner = self.owner
        with owner.source.lock, owner.engine.sync_lock, owner.engine.lock:
            rule, name = self._current(account,group,version)
            if enabled:
                if owner.source.busy: raise ValueError('副本正在更新，请完成后批准。')
                binding = owner._binding(account,group)
            else:
                with closing(owner._db()) as db, db:
                    db.execute('BEGIN IMMEDIATE')
                    rule, _ = self._current(account,group,version)
                    rule.update(policyVersion=version+1,approvedCards=cards,policyCooldown=cooldown)
                    if rule['mode']=='approved':
                        rule.update(enabled=False,sendingPaused=False,issue='')
                        owner.notifications.pause_group(db,account,group,'批准回复规则已关闭，请重新核对通知配置。')
                    owner._save(db,account,group,rule)
                return self._view(account,group,rule)

        sender = owner.sender_factory()
        native = sender.automation_binding(binding)
        if not sender.supports_target(group): raise ValueError('当前 Hook 桥不支持这个群聊。')
        for card in cards:
            sender._request({**binding, 'targetId':group, 'targetName':name, 'text':card['replyText'],
                'idempotencyKey':card['id']})
        with owner.source.lock, owner.engine.sync_lock, owner.engine.lock, closing(owner._db()) as db, db:
            db.execute('BEGIN IMMEDIATE')
            rule, current_name = self._current(account,group,version)
            if owner.source.busy or owner._binding(account,group)!=binding or current_name!=name:
                raise ApprovedPolicyConflict('批准期间账号、数据源或群聊已变化，请重新核对。')
            rule.update(enabled=True,mode='approved',policyVersion=version+1,approvedCards=cards,
                policyCooldown=cooldown,cooldown=cooldown,sendingPaused=False,issue='',
                activated=owner.clock(),lastSent=0,binding=binding,native=native)
            db.execute('DELETE FROM baselines WHERE account=? AND group_id=?', (account,group))
            cursor = None
            while True:
                page = owner._inbound(account,group,rule['activated'],None,cursor)
                db.executemany('INSERT OR IGNORE INTO baselines VALUES (?,?,?)',
                    ((account,group,owner._event_id(account,group,message)) for message in page['messages']))
                if page['complete']: break
                cursor = page['cursor']
            owner._save(db,account,group,rule)
            return self._view(account,group,rule)

    def pause_sending(self, db, account, group, rule):
        if not rule.get('sendingPaused',False):
            rule.update(sendingPaused=True,policyVersion=rule.get('policyVersion',0)+1,
                        issue='批准回复发送已暂停，请核对 Hook 和结果后重新批准；新请求继续转人工。')
            self.owner._save(db,account,group,rule)

    def _collect(self, account, group, rule, now):
        owner = self.owner
        messages, cursor = [], None
        while True:
            page = owner._inbound(account,group,max(rule['activated'],now-120),now+5,cursor)
            messages.extend(page['messages'])
            cursor = page['cursor']
            if page['complete']:
                return messages,cursor['revoked']

    @staticmethod
    def _seen(db, account, group, event):
        return (db.execute('SELECT 1 FROM events WHERE id=?',(event,)).fetchone() is not None or
            db.execute('SELECT 1 FROM baselines WHERE account=? AND group_id=? AND event_id=?',
                       (account,group,event)).fetchone() is not None)

    def _detail(self, rule, name, message, card, reason):
        return {'decision':'reply' if reason=='matched' else 'handoff', 'reasonCode':reason,
                'replyText':card['replyText'] if card is not None else '',
                'trigger':self.owner._trigger(message), 'targetName':name,
                'approvedPolicy':{'version':rule['policyVersion'],'card':card}}

    def _handoff(self, db, account, group, event, detail, now, reason):
        detail.update(decision='handoff',reasonCode=reason,issue=REASONS[reason],taskId=event)
        inserted = db.execute('INSERT OR IGNORE INTO events VALUES (?,?,?,?,?,?)',
            (event,account,group,now,'human_pending',json.dumps(detail,ensure_ascii=False))).rowcount
        if inserted:
            self.owner.handoffs.enqueue(db,event,account,group,detail['targetName'],detail['trigger'],now,
                                       reason=REASONS[reason])

    def tick(self):
        owner = self.owner
        with owner.source.lock, owner.engine.sync_lock, owner.engine.lock:
            if owner.source.busy: return
            with closing(owner._db()) as db:
                rows = db.execute("SELECT account,group_id FROM rules WHERE json_extract(payload,'$.enabled')=1 AND json_extract(payload,'$.mode')='approved'").fetchall()
        for row in rows:
            account, group = row['account'],row['group_id']
            with owner.source.lock, owner.engine.sync_lock, owner.engine.lock:
                if owner.source.busy: return
                rule = owner._rule(account,group)
                if not rule['enabled'] or rule['mode']!='approved': continue
                try:
                    if owner._binding(account,group)!=rule['binding']:
                        raise ValueError('账号或副本来源已变化。')
                    observed = owner.clock()
                    messages,revoked = self._collect(account,group,rule,observed)
                except (ValueError,BridgeError,OSError,sqlite3.Error):
                    owner._pause(account,group,rule,'消息副本或群聊读取异常，批准回复处理已暂停，请核对后重新批准。')
                    continue
                with closing(owner._db()) as db, db:
                    owner.handoffs.revoke(db,account,group,revoked,owner.clock())
            for message in messages:
                if message['serverId'] not in revoked:
                    self._process(account,group,message,observed)

    def _process(self, account, group, message, observed):
        owner = self.owner
        with owner.source.lock, owner.engine.sync_lock, owner.engine.lock:
            if owner.source.busy: return
            rule = owner._rule(account,group)
            if not rule['enabled'] or rule['mode']!='approved': return
            now = owner.clock()
            if not owner.eligible(message,account,rule['activated'],now): return
            try:
                binding = owner._binding(account,group)
                if binding!=rule['binding']: raise ValueError('账号或副本来源已变化。')
            except (ValueError,BridgeError,OSError):
                owner._pause(account,group,rule,'消息副本或群聊读取异常，批准回复处理已暂停，请核对后重新批准。')
                return
            event = owner._event_id(account,group,message)
            with closing(owner._db()) as db:
                if self._seen(db,account,group,event): return
            name = self._context(account,group)
            match = _match(rule['approvedCards'],message['text'],rule['policyVersion'])
            card,reason = match['matchedCard'],match['reasonCode']
            if message['type']!=1:
                card,reason = None,'unsupported_message'
            elif card is not None:
                if rule['sendingPaused']: reason = 'sending_unavailable'
                elif observed-rule['lastSent']<rule['policyCooldown']: reason = 'cooldown'
            detail = self._detail(rule,name,message,card,reason)
            if reason!='matched':
                with closing(owner._db()) as db, db:
                    db.execute('BEGIN IMMEDIATE')
                    if not self._seen(db,account,group,event):
                        self._handoff(db,account,group,event,detail,now,reason)
                return
            if not owner.engine.send_lock.acquire(blocking=False): return
            try:
                evidence = owner._messages(account,group)
            except (ValueError,BridgeError,OSError,sqlite3.Error):
                owner.engine.send_lock.release()
                owner._pause(account,group,rule,'消息副本读取异常，批准回复处理已暂停，请核对后重新批准。')
                return
            except BaseException:
                owner.engine.send_lock.release()
                raise
            context = {'account':account,'group':group,'event':event,'rule':rule,'message':message,
                       'detail':detail,'claimed':False,'binding':binding,'name':name}
        try:
            result = owner.sender_factory().send_automatic({**binding,'targetId':group,'targetName':name,
                'text':card['replyText'],'idempotencyKey':'reply_approved_'+event+'_'+str(rule['policyVersion'])},
                expected_binding=rule['native'],baseline_messages=evidence,
                before_submit=lambda draft:self._claim(context,draft))
        except ApprovedDeferred:
            return
        except HookSendError as error:
            if error.code=='hook_busy': return
            self._finish(context,{'status':'unknown' if context['claimed'] else 'blocked',
                                 'issueCode':error.code,'issue':error.public_message})
        except BaseException:
            if context['claimed']:
                self._finish(context,{'status':'unknown','issue':REASONS['submission_unknown']})
            raise
        else:
            self._finish(context,result)
        finally:
            owner.engine.send_lock.release()

    def _claim(self, context, draft):
        owner = self.owner
        account,group,event = context['account'],context['group'],context['event']
        with owner.source.lock, owner.engine.sync_lock, owner.engine.lock:
            if owner.source.busy: raise ApprovedDeferred()
            if owner.engine.stop.is_set():
                raise HookSendError('approved_not_authorized','工作台正在停止，本条未提交。')
            rule = owner._rule(account,group)
            if (not rule['enabled'] or rule['mode']!='approved' or rule['sendingPaused'] or
                    rule['policyVersion']!=context['rule']['policyVersion']):
                raise HookSendError('approved_not_authorized','批准策略已变化，本条未提交。')
            try:
                if owner._binding(account,group)!=context['binding'] or self._context(account,group)!=context['name']:
                    raise ValueError('账号、来源或目标已变化。')
                messages,revoked = self._collect(account,group,rule,owner.clock())
            except (ValueError,BridgeError,OSError,sqlite3.Error):
                owner._pause(account,group,rule,'消息副本或群聊读取异常，批准回复处理已暂停，请核对后重新批准。')
                raise HookSendError('approved_not_authorized','消息来源已变化或读取异常，本条未提交。') from None
            message = next((row for row in messages if owner._event_id(account,group,row)==event),None)
            if (message is None or message['serverId'] in revoked or
                    not owner.eligible(message,account,rule['activated'],owner.clock()) or
                    any(message[key]!=context['message'][key] for key in ('text','type','senderId','timestamp'))):
                raise HookSendError('approved_not_authorized','原消息已变化、撤回或超过处理时间，本条未提交。')
            with closing(owner._db()) as db, db:
                db.execute('BEGIN IMMEDIATE')
                owner.handoffs.revoke(db,account,group,revoked,owner.clock())
                if self._seen(db,account,group,event):
                    raise HookSendError('approved_not_authorized','消息已处理或属于启用前基线，本条未提交。')
                context['detail']['draftId'] = draft
                db.execute('INSERT INTO events VALUES (?,?,?,?,?,?)',(event,account,group,owner.clock(),
                    'attempted',json.dumps(context['detail'],ensure_ascii=False)))
            context['claimed'] = True

    def _finish(self, context, result):
        owner = self.owner
        account,group,event = context['account'],context['group'],context['event']
        if result.get('issueCode')=='approved_not_authorized': return
        with owner.source.lock, owner.engine.sync_lock, owner.engine.lock, closing(owner._db()) as db, db:
            db.execute('BEGIN IMMEDIATE')
            rule = owner._rule(account,group)
            detail = context['detail']
            detail.update({key:result[key] for key in ('draftId','issue','issueCode') if key in result})
            status = result['status']
            if not context['claimed']:
                if (not rule['enabled'] or rule['mode']!='approved' or
                        rule['policyVersion']!=context['rule']['policyVersion']): return
                self.pause_sending(db,account,group,rule)
                if not self._seen(db,account,group,event):
                    self._handoff(db,account,group,event,detail,owner.clock(),'sending_unavailable')
                return
            successful = status in ('submitted_unconfirmed','server_accepted','local_record_confirmed','local_record_observed')
            if not successful:
                reason = 'submission_unknown' if status=='unknown' else 'sending_unavailable'
                detail.update(reasonCode=reason,taskId=event,
                              issue=REASONS[reason]+(' '+result['issue'] if result.get('issue') else ''))
                owner.handoffs.enqueue(db,event,account,group,detail['targetName'],detail['trigger'],owner.clock(),
                                       reason=REASONS[reason])
                if rule['enabled'] and rule['mode']=='approved':
                    self.pause_sending(db,account,group,rule)
            db.execute('UPDATE events SET status=?,result=? WHERE id=?',
                       (status,json.dumps(detail,ensure_ascii=False),event))
            if rule['mode']=='approved':
                rule['lastSent'] = owner.clock()
                owner._save(db,account,group,rule)
