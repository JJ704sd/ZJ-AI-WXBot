"""One explicitly reviewed Windows UIA send; no queue, coordinates or retries.

prepare() is read-only. confirm() durably consumes the draft before touching the
client. A submitted result proves only that the native Invoke call returned,
never delivery. The transport owns account/window/control checks in one worker.
"""
from contextlib import closing, contextmanager
from datetime import datetime, timezone
import hashlib
import json
import os
from pathlib import Path
import re
import sqlite3
import subprocess
import time


SCRIPT = Path(__file__).resolve().parents[1] / 'scripts' / 'windows_send.ps1'
MAX_TEXT = 2000
TTL_SECONDS = 120
ISSUES = {
    'unsupported': '此发送入口仅支持 Windows。',
    'uia_send_unavailable': '当前窗口未公开可可靠识别的会话、可写输入框或发送按钮；未输入、未发送。',
    'window_changed': '微信窗口、进程或会话已经变化，请重新准备。',
    'owner_unverified': '无法确认当前微信进程持有所选账号数据库；未输入、未发送。',
    'draft_present': '微信输入框已有草稿或附件，未覆盖；请先手动处理。',
    'draft_unverifiable': '无法确认输入框与附件区为空；未输入、未发送。',
    'text_mismatch': '输入内容未通过完整回读核对；未执行发送，请手动检查微信草稿。',
    'desktop_unavailable': '当前微信用户桌面不可用，请解锁电脑后重新准备。',
    'native_failed': '原生操作没有完整返回，结果不确定；请在微信中核实，禁止重复确认。',
    'timeout': '原生操作超时，结果不确定；请在微信中核实，禁止重复确认。',
}


class SendError(ValueError):
    def __init__(self, code, message):
        super().__init__(message)
        self.code, self.public_message = code, message


def _canonical(value):
    return json.dumps(value, sort_keys=True, ensure_ascii=False, separators=(',', ':'))


def _check_current_source(data, expected):
    source = data.get('sourceRoot')
    if (not isinstance(source, str) or not Path(source).is_absolute() or '\0' in source or
            os.path.normcase(str(Path(source).resolve())) != os.path.normcase(expected['sourceRoot']) or
            data.get('account', '') != expected.get('account', '')):
        raise SendError('source_changed', '当前数据库账号已变化，旧窗口确认已失效；未继续输入或发送。')


def _target(data):
    """The HTTP owner resolves the target against its current account first.

    Native pixels do not prove recipient IDs. These are reviewed display fields,
    frozen in the server-side plan and never interpreted as navigation commands.
    Missing fields in old filehelper records retain their original meaning.
    """
    target_id = data.get('targetId', 'filehelper')
    target_name = data.get('targetName', '文件传输助手' if target_id == 'filehelper' else None)
    if (not isinstance(target_id, str) or not 1 <= len(target_id) <= 256 or
            any(ord(char) < 32 or ord(char) == 127 for char in target_id) or
            not isinstance(target_name, str) or not target_name.strip() or len(target_name) > 512 or
            any(ord(char) < 32 or ord(char) == 127 for char in target_name)):
        raise SendError('invalid_target', '缺少服务端已核实的会话标识或名称，请重新选择当前账号会话。')
    try:
        target_id.encode('utf-8'); target_name.encode('utf-8')
    except UnicodeError:
        raise SendError('invalid_target', '目标会话包含无效字符。') from None
    return {'targetId': target_id, 'targetName': target_name}


def _check_frozen_target(data, expected):
    frozen = _target(expected)
    if any(key in data and data[key] != frozen[key] for key in ('targetId', 'targetName')):
        raise SendError('target_changed', '发送目标与已核对预览不一致，旧确认不能转向其他会话。')


def _same_request(row, request, digest):
    if row['request_hash'] == digest:
        return True
    previous = json.loads(row['request'])
    # Old filehelper rows predate targetName. Expand the reader without updating
    # or replaying their durable attempt records; all other fields remain exact.
    return _canonical({**previous, **_target(previous)}) == _canonical({**request, **_target(request)})


@contextmanager
def _input_guard(directory):
    """One native operation across both senders/processes; never queue input."""
    handle = (Path(directory) / 'windows-input.lock').open('a+b')
    locked = False
    try:
        if not handle.tell():
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
            raise SendError('native_busy', '另一个原生窗口操作正在进行，请等待完成后再手动操作。') from None
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


def _native(mode, payload):
    if os.name != 'nt':
        return {'ok': False, 'issueCode': 'unsupported', 'stage': 'before_input'}
    executable = Path(os.environ.get('SystemRoot', r'C:\Windows')) / 'System32/WindowsPowerShell/v1.0/powershell.exe'
    command = [str(executable), '-NoLogo', '-NoProfile', '-NonInteractive', '-ExecutionPolicy', 'Bypass',
               '-File', str(SCRIPT), '-Mode', mode]
    try:
        result = subprocess.run(command, input=_canonical(payload), capture_output=True,
                                text=True, encoding='utf-8', errors='strict', timeout=15,
                                creationflags=getattr(subprocess, 'CREATE_NO_WINDOW', 0))
        if result.returncode or len(result.stdout) > 50000:
            raise ValueError('invalid worker result')
        data = json.loads(result.stdout.lstrip('\ufeff'))
        if not isinstance(data, dict):
            raise ValueError('invalid worker result')
        return data
    except subprocess.TimeoutExpired:
        return {'ok': False, 'issueCode': 'timeout', 'stage': 'unknown'}
    except (OSError, ValueError, UnicodeError):
        return {'ok': False, 'issueCode': 'native_failed', 'stage': 'unknown'}


class WindowsSender:
    """Public API: prepare(dict), confirm(dict), get(draft_id).

    Native account/target evidence and exact text are frozen for 120 seconds.
    The UI must display targetName/text before asking for targetConfirmed=True.
    Reusing an idempotencyKey with different content is rejected. Existing
    attempts survive restart and are never repeated, including timed-out calls.
    """
    def __init__(self, runtime_dir, *, transport=None, clock=None):
        self.directory = Path(runtime_dir).resolve()
        self.directory.mkdir(parents=True, exist_ok=True)
        self.path = self.directory / 'windows-send.sqlite'
        self.transport = transport or _native
        self.clock = clock or time.time
        with closing(self._connect()) as database:
            database.execute('CREATE TABLE IF NOT EXISTS native_drafts ('
                             'id TEXT PRIMARY KEY, request_hash TEXT NOT NULL, request TEXT NOT NULL, '
                             'binding TEXT NOT NULL, text_hash TEXT NOT NULL, expires REAL NOT NULL, '
                             'status TEXT NOT NULL, result TEXT NOT NULL)')
            database.commit()

    def _connect(self):
        database = sqlite3.connect(self.path, timeout=10)
        database.row_factory = sqlite3.Row
        database.execute('PRAGMA synchronous=FULL')
        return database

    @staticmethod
    def _request(data, *, allow_any_target=False):
        if not isinstance(data, dict):
            raise SendError('invalid_request', '发送请求格式无效。')
        text, source, key = data.get('text'), data.get('sourceRoot'), data.get('idempotencyKey')
        account = data.get('account', '')
        if not isinstance(account, str) or len(account) > 200 or any(ord(char) < 32 for char in account):
            raise SendError('invalid_source', '账号绑定格式无效。')
        if (not isinstance(text, str) or not text.strip() or len(text) > MAX_TEXT or
                any(ord(char) < 32 or ord(char) == 127 for char in text)):
            raise SendError('invalid_text', '请填写 1–2000 字符的单条纯文本，不支持控制字符或换行。')
        try:
            text.encode('utf-8')
        except UnicodeError:
            raise SendError('invalid_text', '消息包含无效字符。') from None
        if not isinstance(source, str) or not Path(source).is_absolute() or '\0' in source:
            raise SendError('invalid_source', '请选择已核实的账号数据库绝对目录。')
        if not isinstance(key, str) or not re.fullmatch(r'[A-Za-z0-9_-]{16,100}', key):
            raise SendError('invalid_key', '缺少有效的一次性发送请求标识。')
        target = _target(data)
        if not allow_any_target and target['targetId'] != 'filehelper':
            raise SendError('unsupported_target', '此 UIA 控件适配只支持文件传输助手；其他会话请使用可视核对发送。')
        coordinates = {}
        for field, maximum in (('pid', 2**31 - 1), ('hwnd', 2**63 - 1)):
            value = str(data.get(field, ''))
            if not value.isascii() or not value.isdecimal() or not 0 < int(value) <= maximum:
                raise SendError('invalid_window', '请选择有效的微信进程及窗口。')
            coordinates[field] = int(value)
        return {**coordinates, 'sourceRoot': str(Path(source).resolve()), 'account': account, **target,
                'text': text, 'idempotencyKey': key}

    @staticmethod
    def _view(row):
        request, binding = json.loads(row['request']), json.loads(row['binding'])
        status = 'unconfirmed' if row['status'] == 'attempted' else row['status']
        return {'draftId': row['id'], 'status': status, 'text': request['text'],
                'textHash': row['text_hash'], 'targetId': request['targetId'],
                'targetName': binding.get('targetName', '文件传输助手'),
                'sourceRoot': request['sourceRoot'], 'account': request['account'], 'pid': request['pid'], 'hwnd': request['hwnd'],
                'expiresAt': datetime.fromtimestamp(row['expires'], timezone.utc).isoformat(timespec='seconds'),
                'retryAllowed': False, 'identityVerified': False, 'delivered': False,
                'targetBinding': 'operator-confirmed', **json.loads(row['result'])}

    def get(self, draft_id):
        with closing(self._connect()) as database:
            row = database.execute('SELECT * FROM native_drafts WHERE id=?', (draft_id,)).fetchone()
        if row is None:
            raise SendError('draft_missing', '发送草稿不存在，请重新准备。')
        return self._view(row)

    def prepare(self, data):
        request = self._request(data)
        digest = hashlib.sha256(_canonical(request).encode('utf-8')).hexdigest()
        draft_id = hashlib.sha256(request['idempotencyKey'].encode()).hexdigest()[:32]
        with closing(self._connect()) as database:
            old = database.execute('SELECT * FROM native_drafts WHERE id=?', (draft_id,)).fetchone()
        if old is not None:
            if not _same_request(old, request, digest):
                raise SendError('idempotency_conflict', '该请求标识已绑定其他内容；未创建或发送新消息。')
            return self._view(old)
        # Text is not passed to the inspector; preparation cannot fill a draft.
        selection = {key: value for key, value in request.items() if key not in ('text', 'idempotencyKey', 'account', 'targetName')}
        inspected = self.transport('inspect', selection)
        if not isinstance(inspected, dict) or inspected.get('ok') is not True:
            code = inspected.get('issueCode', 'native_failed') if isinstance(inspected, dict) else 'native_failed'
            raise SendError(code if code in ISSUES else 'native_failed', ISSUES.get(code, ISSUES['native_failed']))
        binding = inspected.get('binding')
        required = ('processStarted', 'targetRuntimeId', 'editorRuntimeId', 'sendRuntimeId', 'targetName')
        if (not isinstance(binding, dict) or any(not binding.get(key) for key in required) or
                any(binding.get(key) != value for key, value in selection.items()) or
                binding.get('draftEmpty') is not True or binding.get('ownerVerified') is not True):
            raise SendError('unverified_binding', '窗口、账号、目标或空白输入框的验证证据不足。')
        binding['account'] = request['account']
        text_hash = hashlib.sha256(request['text'].encode('utf-8')).hexdigest()
        with closing(self._connect()) as database:
            database.execute('INSERT OR IGNORE INTO native_drafts VALUES (?,?,?,?,?,?,?,?)',
                             (draft_id, digest, _canonical(request), _canonical(binding), text_hash,
                              self.clock() + TTL_SECONDS, 'prepared', '{}'))
            database.commit()
            row = database.execute('SELECT * FROM native_drafts WHERE id=?', (draft_id,)).fetchone()
        if not _same_request(row, request, digest):
            raise SendError('idempotency_conflict', '该请求标识已绑定其他内容。')
        return self._view(row)

    def confirm(self, data):
        with _input_guard(self.directory):
            return self._confirm(data)

    def _confirm(self, data):
        if not isinstance(data, dict) or data.get('targetConfirmed') is not True:
            raise SendError('confirmation_required', '请先核对文件传输助手、账号和完整正文，再明确确认发送。')
        with closing(self._connect()) as database:
            database.execute('BEGIN IMMEDIATE')
            row = database.execute('SELECT * FROM native_drafts WHERE id=?', (data.get('draftId'),)).fetchone()
            if row is None:
                raise SendError('draft_missing', '发送草稿不存在。')
            _check_current_source(data, json.loads(row['request']))
            _check_frozen_target(data, json.loads(row['request']))
            if data.get('textHash') != row['text_hash']:
                raise SendError('text_changed', '正文确认摘要不一致，未执行发送。')
            if row['status'] != 'prepared':
                return self._view(row)
            if self.clock() > row['expires']:
                database.execute("UPDATE native_drafts SET status='expired' WHERE id=?", (row['id'],))
                database.commit()
                return self.get(row['id'])
            database.execute("UPDATE native_drafts SET status='attempted' WHERE id=?", (row['id'],))
            database.commit()  # durable BEFORE any native UI write
        request, binding = json.loads(row['request']), json.loads(row['binding'])
        try:
            outcome = self.transport('submit', {'binding': binding, 'text': request['text']})
        except Exception:
            outcome = {'ok': False, 'issueCode': 'native_failed', 'stage': 'unknown'}
        if not isinstance(outcome, dict):
            outcome = {'ok': False, 'issueCode': 'native_failed', 'stage': 'unknown'}
        if outcome.get('ok') is True and outcome.get('stage') == 'submitted':
            status = 'submitted_unconfirmed'
            result = {'issue': '已向微信提交一次发送操作，尚未取得接收回执；请核实，勿重复确认。', 'issueCode': ''}
        else:
            status = 'blocked' if outcome.get('stage') == 'before_input' else 'unconfirmed'
            code = outcome.get('issueCode')
            code = code if code in ISSUES else 'native_failed'
            result = {'issueCode': code, 'issue': ISSUES[code]}
        with closing(self._connect()) as database:
            database.execute('UPDATE native_drafts SET status=?,result=? WHERE id=?', (status, _canonical(result), row['id']))
            database.commit()
        return self.get(row['id'])
