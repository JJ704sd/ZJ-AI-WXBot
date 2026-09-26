"""Authenticated loopback Windows Hook bridge and durable, one-shot sending.

This module never loads a DLL, injects, reads process memory or operates the UI.
A separately reviewed native bridge must implement ``webridge.windows-hook.v1``:

GET /v1/status -> {protocol, ready, instanceId, capabilities: {sendText,
idempotency}, binding: {pid, processStarted, clientVersion, arch, moduleName,
moduleSha256, selfId, sourceRoot}}. processStarted is a Windows FILETIME string.
Optional scope.targetPolicy='selected_conversation' permits server-validated
conversation IDs; older scope.targetId (or no scope) stays fixed-target only.
POST /v1/send-text accepts {protocol, requestId, draftId, textHash, text, targetId,
expectedBinding}. The bridge MUST atomically recheck expectedBinding before
calling WeChat and durably deduplicate requestId, including unknown outcomes.
Its response echoes protocol/requestId/textHash/targetId/binding and has status
not_submitted (submissionAttempted=false), submitted, or server_accepted (with a
positive serverId from the correlated native acknowledgement).

Profiles are a trusted server-side exact-build allowlist, never browser data.
No profile is bundled: no current Windows build is claimed supported. Network
errors after POST are unknown and never replayed. Database reconciliation is
evidence of a local outgoing record, never recipient delivery.
"""
from contextlib import closing, contextmanager
from datetime import datetime, timezone
import hashlib
import ipaddress
import json
import os
from pathlib import Path
import re
import sqlite3
import time
import urllib.error
import urllib.parse
import urllib.request


PROTOCOL = 'webridge.windows-hook.v1'
TTL_SECONDS = 120
MAX_RESPONSE = 131072
STATUS_TIMEOUT = 3
SEND_TIMEOUT = 12
ISSUES = {
    'bridge_not_configured': '尚未配置经过适配的本机 Hook 桥，未启用发送。',
    'bridge_config_invalid': '本机 Hook 配置文件无效或不可读取，未启用发送。',
    'bridge_unavailable': '无法连接本机 Hook 桥，未执行发送。',
    'bridge_invalid': '本机 Hook 桥返回的协议或身份信息不完整，未启用发送。',
    'bridge_not_ready': '本机 Hook 桥尚未就绪，未执行发送。',
    'unsupported_version': '当前客户端版本和模块哈希尚无已配置的 Hook 适配，未启用发送。',
    'unsupported_target': '当前发送桥尚未开放该会话，请重新连接发送后再试。',
    'source_changed': '当前数据库账号与发送绑定不一致，旧确认已失效。',
    'binding_changed': '微信进程、账号、模块或 Hook 桥实例已变化，请重新准备。',
    'not_submitted': 'Hook 桥确认尚未调用微信发送入口，本次请求已停止。',
    'outcome_unknown': '发送调用未返回可核对的结果；请检查微信和数据库记录，不会自动重试。',
    'hook_busy': '另一个 Hook 发送操作正在进行，请等待其返回。',
}


class HookSendError(ValueError):
    def __init__(self, code, message=None):
        self.code = code
        self.public_message = message or ISSUES.get(code, ISSUES['bridge_invalid'])
        super().__init__(self.public_message)


def _json(value):
    return json.dumps(value, ensure_ascii=False, sort_keys=True, separators=(',', ':'))


def _hash(value):
    return hashlib.sha256(value.encode('utf-8')).hexdigest()


def _string(value, maximum=256):
    if not isinstance(value, str) or not 1 <= len(value) <= maximum or any(ord(c) < 32 or ord(c) == 127 for c in value):
        return False
    try:
        value.encode('utf-8')
        return True
    except UnicodeError:
        return False


def _root(value):
    if not _string(value, 32768) or not Path(value).is_absolute():
        raise HookSendError('source_changed')
    try:
        return os.path.normcase(str(Path(value).resolve()))
    except OSError:
        raise HookSendError('source_changed') from None


def _source(data):
    if not isinstance(data, dict):
        raise HookSendError('source_changed')
    account = data.get('account', data.get('sourceId'))
    if (not _string(account) or not _string(data.get('selfId')) or
            ('sourceId' in data and data['sourceId'] != account)):
        raise HookSendError('source_changed')
    return {'account': account, 'sourceId': account, 'selfId': data['selfId'], 'sourceRoot': _root(data.get('sourceRoot'))}


def _same_source(data, expected):
    if _source(data) != {key: expected[key] for key in ('account', 'sourceId', 'selfId', 'sourceRoot')}:
        raise HookSendError('source_changed')


def _profile(value):
    if (not isinstance(value, dict) or not re.fullmatch(r'\d+\.\d+\.\d+\.\d+', str(value.get('clientVersion', ''))) or
            value.get('arch') not in ('x64', 'x86', 'arm64') or
            str(value.get('moduleName', '')).casefold() not in ('weixin.dll', 'wechatwin.dll') or
            not re.fullmatch(r'[a-fA-F0-9]{64}', str(value.get('moduleSha256', '')))):
        raise HookSendError('bridge_invalid')
    return {key: value[key].lower() if key in ('moduleName', 'moduleSha256') else value[key]
            for key in ('clientVersion', 'arch', 'moduleName', 'moduleSha256')}


def _native_binding(value, instance):
    profile = _profile(value)
    pid = value.get('pid')
    started = value.get('processStarted')
    if (type(pid) is not int or not 0 < pid <= 0xffffffff or
            not isinstance(started, str) or not re.fullmatch(r'[1-9][0-9]{0,19}', started) or
            int(started) > 0xffffffffffffffff or not _string(value.get('selfId')) or
            not _string(instance, 128)):
        raise HookSendError('bridge_invalid')
    return {**profile, 'pid': pid, 'processStarted': started, 'selfId': value['selfId'],
            'sourceRoot': _root(value.get('sourceRoot')), 'instanceId': instance}


class _NoRedirect(urllib.request.HTTPRedirectHandler):
    def redirect_request(self, *args, **kwargs):
        raise urllib.error.URLError('redirect refused')


class LoopbackTransport:
    """One HTTP request per call; no proxies, DNS hosts, redirects or retries."""
    def __init__(self, endpoint, token):
        try:
            parsed = urllib.parse.urlsplit(endpoint)
            address = ipaddress.ip_address(parsed.hostname or '')
            if (parsed.scheme != 'http' or not address.is_loopback or parsed.username is not None or
                    parsed.password is not None or parsed.path not in ('', '/') or parsed.query or parsed.fragment or
                    parsed.port is None or not 1 <= parsed.port <= 65535 or '%' in str(parsed.hostname)):
                raise ValueError()
            if not isinstance(token, str) or not re.fullmatch(r'[A-Za-z0-9_-]{32,256}', token):
                raise ValueError()
        except (ValueError, TypeError, AttributeError):
            raise HookSendError('bridge_not_configured') from None
        self.endpoint = endpoint.rstrip('/')
        self.token = token
        self.opener = urllib.request.build_opener(urllib.request.ProxyHandler({}), _NoRedirect())

    def __call__(self, method, path, payload=None):
        body = None if payload is None else _json(payload).encode('utf-8')
        request = urllib.request.Request(self.endpoint + path, data=body, method=method,
            headers={'Authorization': 'Bearer ' + self.token, 'Accept': 'application/json', 'Content-Type': 'application/json'})
        try:
            timeout = STATUS_TIMEOUT if method == 'GET' else SEND_TIMEOUT
            deadline = time.monotonic() + timeout
            with self.opener.open(request, timeout=timeout) as response:
                if response.status != 200 or response.headers.get_content_type() != 'application/json':
                    raise ValueError()
                raw = bytearray()
                while True:
                    if time.monotonic() >= deadline:
                        raise TimeoutError()
                    part = response.read1(min(16384, MAX_RESPONSE + 1 - len(raw)))
                    if not part:
                        break
                    raw.extend(part)
                    if len(raw) > MAX_RESPONSE:
                        raise ValueError()
                result = json.loads(raw.decode('utf-8'))
                if not isinstance(result, dict):
                    raise ValueError()
                return result
        except Exception:
            # No response body, exception text, URL or token leaves this boundary.
            raise HookSendError('bridge_unavailable' if method == 'GET' else 'outcome_unknown') from None


@contextmanager
def _send_guard(directory):
    handle = (directory / 'windows-hook-send.lock').open('a+b')
    locked = False
    try:
        if handle.seek(0, os.SEEK_END) == 0:
            handle.write(b'0'); handle.flush()
        handle.seek(0)
        try:
            if os.name == 'nt':
                import msvcrt
                msvcrt.locking(handle.fileno(), msvcrt.LK_NBLCK, 1)
            else:
                import fcntl
                fcntl.flock(handle.fileno(), fcntl.LOCK_EX | fcntl.LOCK_NB)
            locked = True
        except OSError:
            raise HookSendError('hook_busy') from None
        yield
    finally:
        if locked:
            handle.seek(0)
            if os.name == 'nt':
                import msvcrt
                msvcrt.locking(handle.fileno(), msvcrt.LK_UNLCK, 1)
            else:
                import fcntl
                fcntl.flock(handle.fileno(), fcntl.LOCK_UN)
        handle.close()


class WindowsHookSender:
    def __init__(self, runtime_dir, *, endpoint=None, token=None, profiles=(), transport=None, clock=None):
        self.directory = Path(runtime_dir).resolve()
        self.directory.mkdir(parents=True, exist_ok=True)
        self.path = self.directory / 'windows-hook-send.sqlite'
        self.profiles = tuple(_profile(row) for row in profiles)
        self.transport = transport if transport is not None else LoopbackTransport(endpoint, token) if endpoint else None
        self.clock = clock or time.time
        self.configuration_error = None
        self.target_scope = {'targetId': 'filehelper'}
        with closing(self._connect()) as database:
            database.execute('CREATE TABLE IF NOT EXISTS hook_drafts ('
                'id TEXT PRIMARY KEY, request_hash TEXT NOT NULL, request TEXT NOT NULL, '
                'binding TEXT NOT NULL, text_hash TEXT NOT NULL, expires REAL NOT NULL, '
                'status TEXT NOT NULL, result TEXT NOT NULL)')
            database.commit()

    @classmethod
    def from_config(cls, runtime_dir, config_file):
        """Load a local operator-owned JSON file; never take this from the API.

        Shape: {"endpoint":"http://127.0.0.1:PORT", "tokenFile":"hook-token",
        "profilesFile":"hook-profiles.json"}. Relative filenames are resolved
        against config_file's parent. tokenFile contains a 32..256 character
        URL-safe bearer secret. profilesFile contains an array of exact reviewed
        {clientVersion,arch,moduleName,moduleSha256} builds (or {"profiles": [...]}).
        Empty profiles are valid but cannot authorize a build. Missing config
        starts disconnected; invalid config fails closed with a fixed message.
        """
        path = Path(config_file).resolve()
        def read_bounded(selected, limit):
            with selected.open('rb') as stream:
                raw = stream.read(limit + 1)
            if len(raw) > limit:
                raise ValueError()
            return raw.decode('utf-8-sig')
        try:
            if not path.exists():
                return cls(runtime_dir)
            config = json.loads(read_bounded(path, 65536))
            if (not isinstance(config, dict) or set(config) != {'endpoint', 'tokenFile', 'profilesFile'} or
                    any(not _string(value, 32768) for value in config.values())):
                raise ValueError()
            token_path, profiles_path = (path.parent / config[key] for key in ('tokenFile', 'profilesFile'))
            token = read_bounded(token_path, 1024).strip()
            profiles = json.loads(read_bounded(profiles_path, 65536))
            if isinstance(profiles, dict) and set(profiles) == {'profiles'}:
                profiles = profiles['profiles']
            if not isinstance(profiles, list) or len(profiles) > 64:
                raise ValueError()
            return cls(runtime_dir, endpoint=config['endpoint'], token=token, profiles=profiles)
        except (OSError, ValueError, TypeError, UnicodeError):
            instance = cls(runtime_dir)
            instance.configuration_error = 'bridge_config_invalid'
            return instance

    def _connect(self):
        database = sqlite3.connect(self.path, timeout=10)
        database.row_factory = sqlite3.Row
        database.execute('PRAGMA synchronous=FULL')
        return database

    def _probe(self, source=None):
        if self.configuration_error:
            raise HookSendError(self.configuration_error)
        if self.transport is None:
            raise HookSendError('bridge_not_configured')
        try:
            response = self.transport('GET', '/v1/status')
        except Exception:
            raise HookSendError('bridge_unavailable') from None
        if not isinstance(response, dict) or response.get('protocol') != PROTOCOL:
            raise HookSendError('bridge_invalid')
        binding = _native_binding(response.get('binding'), response.get('instanceId'))
        if source is not None and (source['selfId'] != binding['selfId'] or source['sourceRoot'] != binding['sourceRoot']):
            raise HookSendError('source_changed')
        if _profile(binding) not in self.profiles:
            error = HookSendError('unsupported_version')
            error.observed = binding
            raise error
        capabilities = response.get('capabilities')
        if (response.get('ready') is not True or not isinstance(capabilities, dict) or
                capabilities.get('sendText') is not True or capabilities.get('idempotency') is not True):
            raise HookSendError('bridge_not_ready')
        scope = response.get('scope', {'targetId': 'filehelper'})
        if not isinstance(scope, dict):
            raise HookSendError('bridge_invalid')
        if scope.get('targetPolicy') == 'selected_conversation':
            self.target_scope = {'targetPolicy': 'selected_conversation'}
        elif isinstance(scope.get('targetId'), str) and re.fullmatch(r'[A-Za-z0-9_.@-]{1,256}', scope['targetId']):
            self.target_scope = {'targetId': scope['targetId']}
        else:
            raise HookSendError('bridge_invalid')
        return binding

    def supports_target(self, target_id):
        return (isinstance(target_id, str) and re.fullmatch(r'[A-Za-z0-9_.@-]{1,256}', target_id) is not None and
                (self.target_scope.get('targetPolicy') == 'selected_conversation' or
                 self.target_scope.get('targetId') == target_id))

    def status(self, binding=None):
        result = {'supported': True, 'available': False, 'bridgeConfigured': self.transport is not None,
                  'protocol': PROTOCOL, 'transport': 'loopback-http', 'delivered': False, 'retryAllowed': False}
        try:
            source = _source(binding) if binding is not None else None
            native = self._probe(source)
            result.update(available=source is not None, **{key: native[key] for key in
                ('clientVersion', 'arch', 'moduleName', 'moduleSha256', 'selfId')}, processId=native['pid'])
            if source is None:
                raise HookSendError('source_changed')
            result.update(scope=dict(self.target_scope), issueCode='', issue='Hook 桥和当前数据库账号绑定已核对；发送仍需确认。')
        except HookSendError as error:
            observed = getattr(error, 'observed', None)
            if observed:
                result.update(**{key: observed[key] for key in ('clientVersion', 'arch', 'moduleName', 'moduleSha256')}, processId=observed['pid'])
            result.update(issueCode=error.code, issue=error.public_message)
        return result

    @staticmethod
    def _request(data):
        source = _source(data)
        text, key = data.get('text'), data.get('idempotencyKey')
        if (not isinstance(text, str) or not text.strip() or len(text) > 2000 or
                any(ord(c) < 32 and c not in '\n\t' or ord(c) == 127 for c in text)):
            raise HookSendError('invalid_text', '请填写 1–2000 字符的纯文本消息。')
        try:
            if len(text.encode('utf-16-le')) // 2 > 2000 or len(text.encode('utf-8')) > 8000:
                raise HookSendError('invalid_text', '纯文本消息最多 2000 字符。')
        except UnicodeError:
            raise HookSendError('invalid_text', '消息包含无效字符。') from None
        if not isinstance(key, str) or not re.fullmatch(r'[A-Za-z0-9_-]{16,100}', key):
            raise HookSendError('invalid_key', '缺少有效的一次性发送请求标识。')
        if (not isinstance(data.get('targetId'), str) or not re.fullmatch(r'[A-Za-z0-9_.@-]{1,256}', data['targetId']) or
                not _string(data.get('targetName'), 512)):
            raise HookSendError('invalid_target', '缺少服务端已核实的当前账号会话。')
        if data.get('mentionIds'):
            raise HookSendError('unsupported_mentions', '当前 Hook 桥契约仅发送普通文本，尚未适配真实 @。')
        return {**source, 'text': text, 'idempotencyKey': key, 'targetId': data['targetId'], 'targetName': data['targetName']}

    @staticmethod
    def _view(row):
        request = json.loads(row['request'])
        status = 'unknown' if row['status'] == 'attempted' else row['status']
        result = json.loads(row['result'])
        if status == 'unknown' and not result.get('issue'):
            result.update(issueCode='outcome_unknown', issue=ISSUES['outcome_unknown'])
        public_result = {key: value for key, value in result.items() if key not in ('baselineMessageIds', 'submittedAtEpoch')}
        return {'draftId': row['id'], 'status': status, 'text': request['text'], 'textHash': row['text_hash'],
                'targetId': request['targetId'], 'targetName': request['targetName'],
                'expiresAt': datetime.fromtimestamp(row['expires'], timezone.utc).isoformat(timespec='seconds'),
                'retryAllowed': False, 'delivered': False,
                'serverAccepted': status in ('server_accepted', 'local_record_confirmed'),
                'localRecordConfirmed': status == 'local_record_confirmed',
                'localRecordObserved': status == 'local_record_observed', **public_result}

    def _row(self, draft_id):
        if not isinstance(draft_id, str) or not re.fullmatch(r'[a-f0-9]{32}', draft_id):
            raise HookSendError('draft_missing', '发送草稿不存在。')
        with closing(self._connect()) as database:
            row = database.execute('SELECT * FROM hook_drafts WHERE id=?', (draft_id,)).fetchone()
        if row is None:
            raise HookSendError('draft_missing', '发送草稿不存在。')
        return row

    def get(self, draft_id, source_binding=None):
        row = self._row(draft_id)
        _same_source(source_binding, json.loads(row['request']))
        return self._view(row)

    def prepare(self, data):
        request = self._request(data)
        digest, draft_id = _hash(_json(request)), _hash(request['idempotencyKey'])[:32]
        with closing(self._connect()) as database:
            previous = database.execute('SELECT * FROM hook_drafts WHERE id=?', (draft_id,)).fetchone()
        if previous is not None:
            if previous['request_hash'] != digest:
                raise HookSendError('idempotency_conflict', '该请求标识已绑定其他目标或内容。')
            return self._view(previous)
        binding = self._probe(request)
        if not self.supports_target(request['targetId']):
            raise HookSendError('unsupported_target')
        with closing(self._connect()) as database:
            database.execute('INSERT OR IGNORE INTO hook_drafts VALUES (?,?,?,?,?,?,?,?)',
                (draft_id, digest, _json(request), _json(binding), _hash(request['text']), self.clock() + TTL_SECONDS, 'prepared', '{}'))
            database.commit()
        row = self._row(draft_id)
        if row['request_hash'] != digest:
            raise HookSendError('idempotency_conflict', '该请求标识已绑定其他目标或内容。')
        return self._view(row)

    def _save_result(self, draft_id, status, result):
        with closing(self._connect()) as database:
            database.execute('UPDATE hook_drafts SET status=?,result=? WHERE id=?', (status, _json(result), draft_id))
            database.commit()
        return self._view(self._row(draft_id))

    def confirm(self, data, *, baseline_messages=None):
        if not isinstance(data, dict) or data.get('targetConfirmed') is not True:
            raise HookSendError('confirmation_required', '请核对账号、目标会话和完整正文后确认发送。')
        with _send_guard(self.directory):
            row = self._row(data.get('draftId'))
            request, binding = json.loads(row['request']), json.loads(row['binding'])
            _same_source(data, request)
            if data.get('textHash') != row['text_hash'] or any(key in data and data[key] != request[key] for key in ('targetId', 'targetName', 'text')):
                raise HookSendError('draft_changed', '确认内容与已准备的目标或正文不一致。')
            if row['status'] != 'prepared':
                return self._view(row)
            if self.clock() >= row['expires']:
                return self._save_result(row['id'], 'expired', {'issue': '确认已过期，未执行发送。', 'issueCode': 'expired'})
            try:
                if self._probe(request) != binding:
                    raise HookSendError('binding_changed')
                if not self.supports_target(request['targetId']):
                    raise HookSendError('unsupported_target')
            except HookSendError as error:
                return self._save_result(row['id'], 'blocked', {'issueCode': error.code, 'issue': error.public_message})
            evidence = {}
            if baseline_messages is not None:
                if not isinstance(baseline_messages, (list, tuple)):
                    raise HookSendError('invalid_evidence', '无法记录发送前的数据库消息基线。')
                evidence = {'baselineMessageIds': [message['id'] for message in baseline_messages
                    if isinstance(message, dict) and isinstance(message.get('id'), str)],
                    'submittedAtEpoch': self.clock()}
            with closing(self._connect()) as database:
                database.execute("UPDATE hook_drafts SET status='attempted',result=? WHERE id=? AND status='prepared'",
                                 (_json(evidence), row['id']))
                database.commit()  # durable before handing anything to native code
            payload = {'protocol': PROTOCOL, 'requestId': row['id'], 'draftId': row['id'], 'textHash': row['text_hash'],
                       'text': request['text'], 'targetId': request['targetId'], 'expectedBinding': binding}
            status, result = 'unknown', {'issueCode': 'outcome_unknown', 'issue': ISSUES['outcome_unknown']}
            correlated = False
            try:
                outcome = self.transport('POST', '/v1/send-text', payload)
                correlated = (isinstance(outcome, dict) and all(outcome.get(key) == payload[key] for key in
                              ('protocol', 'requestId', 'textHash', 'targetId')) and
                              _native_binding(outcome.get('binding'), outcome.get('binding', {}).get('instanceId')) == binding)
                if correlated:
                    if outcome.get('status') == 'not_submitted' and outcome.get('submissionAttempted') is False:
                        status, result = 'blocked', {'issueCode': 'not_submitted', 'issue': ISSUES['not_submitted']}
                    elif outcome.get('status') == 'submitted':
                        status, result = 'submitted_unconfirmed', {'issueCode': '', 'issue': '微信原生发送入口已调用一次，尚无可核对的服务器回执。'}
                    elif outcome.get('status') == 'server_accepted' and isinstance(outcome.get('serverId'), str) and re.fullmatch(r'[1-9][0-9]{0,19}', outcome['serverId']):
                        status, result = 'server_accepted', {'serverId': outcome['serverId'], 'issueCode': '',
                            'issue': '已取得匹配本次请求的服务器接受回执；尚未确认本地存档或收件端送达。'}
            except Exception:
                pass
            if correlated:
                client_id = outcome.get('clientMessageId')
                if _string(client_id, 128):
                    result['clientMessageId'] = client_id
            return self._save_result(row['id'], status, {**evidence, **result})

    def reconcile(self, draft_id, messages, source_binding, *, target_id):
        """Accept only exact correlated outgoing DB records supplied by the server.

        The caller reads ``messages`` from target_id in the currently validated
        snapshot. It must never accept these rows or source fields from a browser.
        Without a server ACK ID, a new self-authored row is only an observation,
        not exact request attribution. Unknown submissions are never resolved
        by text/time similarity.
        """
        row = self._row(draft_id)
        request = json.loads(row['request'])
        _same_source(source_binding, request)
        if target_id != request['targetId']:
            raise HookSendError('target_changed', '数据库核对目标与原发送目标不一致。')
        if row['status'] not in ('server_accepted', 'submitted_unconfirmed'):
            return self._view(row)
        result = json.loads(row['result'])
        if not isinstance(messages, (list, tuple)):
            raise HookSendError('invalid_evidence', '数据库确认记录格式无效。')
        if row['status'] == 'submitted_unconfirmed':
            if 'baselineMessageIds' not in result or 'submittedAtEpoch' not in result:
                return self._view(row)  # Old drafts lack a pre-send observation baseline.
            baseline = set(result['baselineMessageIds'])
            started = result['submittedAtEpoch']
            with closing(self._connect()) as database:
                claimed = set()
                for previous in database.execute("SELECT request,result FROM hook_drafts WHERE status IN ('local_record_observed','local_record_confirmed')"):
                    old_request, old_result = json.loads(previous['request']), json.loads(previous['result'])
                    if old_request['sourceId'] == request['sourceId'] and old_request['targetId'] == target_id:
                        claimed.add(old_result.get('serverId'))
            candidates = {message['id']: message for message in messages if isinstance(message, dict) and
                isinstance(message.get('id'), str) and message['id'] not in baseline and
                isinstance(message.get('serverId'), str) and re.fullmatch(r'[1-9][0-9]{0,19}', message['serverId']) and
                message['serverId'] not in claimed and message.get('source') == 'database' and
                message.get('sourceId') == request['sourceId'] and message.get('senderId') == request['selfId'] and
                message.get('isSelfKnown') is True and message.get('isSelf') is True and
                type(message.get('type')) is int and message['type'] == 1 and message.get('decodeStatus') == 'ok' and
                message.get('text') == request['text'] and message.get('kind') not in ('revoke', 'system') and
                type(message.get('timestamp')) is int and int(started) <= message['timestamp'] <= int(started) + 120}
            if len(candidates) == 1:
                message = next(iter(candidates.values()))
                result.update(serverId=message['serverId'], observedMessageId=message['id'], serverAccepted=False,
                    issue='数据库副本出现一条新增的本人同文本记录；未取得服务器回执，不能据此证明收件端送达。',
                    databaseObservedAt=datetime.fromtimestamp(self.clock(), timezone.utc).isoformat(timespec='seconds'))
                return self._save_result(row['id'], 'local_record_observed', result)
            return self._view(row)
        for message in messages:
            if (isinstance(message, dict) and message.get('serverId') == result['serverId'] and
                    message.get('source') == 'database' and message.get('sourceId') == request['sourceId'] and
                    message.get('senderId') == request['selfId'] and message.get('isSelfKnown') is True and
                    message.get('isSelf') is True and type(message.get('type')) is int and message['type'] == 1 and
                    message.get('text') == request['text'] and message.get('kind') not in ('revoke', 'system')):
                result.update(issue='数据库副本已出现对应的本人文本记录；这不等同收件端送达。',
                              databaseConfirmedAt=datetime.fromtimestamp(self.clock(), timezone.utc).isoformat(timespec='seconds'))
                return self._save_result(row['id'], 'local_record_confirmed', result)
        return self._view(row)
