"""Operator-selected visual send: preview, stage once, review, submit once.

Images are memory-only and expire. SQLite stores explicit text, coordinates,
window/account evidence and consumed attempts, never screen pixels. The native
worker compares a fresh capture to the reviewed image before each UI mutation.
"""
import base64
import binascii
from contextlib import closing
from datetime import datetime, timezone
import hashlib
import json
import os
from pathlib import Path
import secrets
import sqlite3
import struct
import subprocess
import threading
import time

from windows_sender import (SendError, WindowsSender, _canonical, _input_guard, _check_current_source,
                            _target, _check_frozen_target, _same_request)


SCRIPT = Path(__file__).resolve().parents[1] / 'scripts' / 'windows_visual_send.ps1'
MAX_IMAGE = 8 * 1024 * 1024
TTL = 120
ISSUES = {
    'unsupported': '可视发送仅支持 Windows。',
    'window_changed': '微信窗口或账号绑定发生变化，请重新预览并核对。',
    'window_minimized': '微信窗口恢复后仍不可用，或在复核期间再次最小化；操作已停止，请检查当前窗口和草稿。',
    'owner_unverified': '无法确认当前进程持有所选账号数据库，未继续操作。',
    'window_occluded': '微信窗口仍被遮挡，未继续操作。',
    'foreground_mismatch': '无法将已绑定的微信窗口置于前台，未继续操作。',
    'preview_changed': '窗口内容与刚才核对的图片不一致，未继续操作；请重新预览并核实草稿。',
    'desktop_unavailable': '当前用户桌面不可用，请解锁电脑后重试。',
    'input_desktop_unavailable': '当前用户桌面不可用，请解锁电脑后重试。',
    'window_outside_desktop': '微信窗口部分位于屏幕之外，未继续操作。',
    'capture_unavailable': '无法取得有效的窗口核对图，未继续操作。',
    'capture_too_large': '窗口图片超过支持范围，请缩小窗口后重新预览。',
    'invalid_point': '点选位置不在已核对的窗口图片内。',
    'point_occluded': '点选位置被其他窗口遮挡，未继续操作。',
    'input_busy': '检测到鼠标或修饰键仍按下，未继续操作；请松开后重新核对。',
    'focus_unverified': '无法确认焦点仍属于所选微信窗口，未继续输入；请检查微信草稿。',
    'native_input_failed': '系统没有完整接受输入，可能只输入了部分内容；请手动检查，禁止自动补打。',
    'invalid_reference': '窗口核对图片无效，未继续操作。',
    'helper_unavailable': '原生窗口组件不可用，未继续操作。',
    'unsupported_input_abi': '当前运行环境不支持已验证的 64 位 Windows 输入结构。',
    'invalid_input': '原生操作参数无效，未继续操作。',
    'preview_expired': '核对图片已经失效；如果草稿已填入，请在微信中手动核实，勿重复填入。',
    'timeout': '原生操作超时，结果不确定；请手动检查微信，禁止重复此操作。',
    'native_failed': '原生操作未完整返回，结果不确定；请手动检查微信，禁止重复此操作。',
}


def _native(mode, payload):
    if os.name != 'nt':
        return {'ok': False, 'stage': 'before_input', 'issueCode': 'unsupported'}
    executable = Path(os.environ.get('SystemRoot', r'C:\Windows')) / 'System32/WindowsPowerShell/v1.0/powershell.exe'
    try:
        result = subprocess.run([str(executable), '-NoLogo', '-NoProfile', '-NonInteractive', '-ExecutionPolicy', 'Bypass',
                                 '-File', str(SCRIPT), '-Mode', mode],
                                input=_canonical(payload), capture_output=True, text=True, encoding='utf-8', errors='strict',
                                timeout=20, creationflags=getattr(subprocess, 'CREATE_NO_WINDOW', 0))
        if result.returncode or len(result.stdout) > ((MAX_IMAGE + 2) // 3 * 4 + 50000):
            raise ValueError
        data = json.loads(result.stdout.lstrip('\ufeff'))
        if not isinstance(data, dict):
            raise ValueError
        return data
    except subprocess.TimeoutExpired:
        return {'ok': False, 'stage': 'unknown', 'issueCode': 'timeout'}
    except (OSError, ValueError, UnicodeError):
        return {'ok': False, 'stage': 'unknown', 'issueCode': 'native_failed'}


def _picture(result):
    encoded = result.get('png_base64')
    try:
        if not isinstance(encoded, str) or len(encoded) > ((MAX_IMAGE + 2) // 3 * 4):
            raise ValueError
        data = base64.b64decode(encoded, validate=True)
        if len(data) < 33 or len(data) > MAX_IMAGE or data[:8] != b'\x89PNG\r\n\x1a\n' or data[12:16] != b'IHDR':
            raise ValueError
        width, height = struct.unpack('>II', data[16:24])
        geometry = result.get('binding', {}).get('geometry', {})
        if (not 0 < width <= 5000 or not 0 < height <= 5000 or geometry.get('width') != width or
                geometry.get('height') != height or result.get('width', width) != width or result.get('height', height) != height):
            raise ValueError
        return {'encoded': encoded, 'width': width, 'height': height}
    except (ValueError, TypeError, AttributeError, binascii.Error, struct.error):
        raise SendError('capture_unavailable', ISSUES['capture_unavailable']) from None


def _issue(result):
    code = result.get('issueCode') if isinstance(result, dict) else 'native_failed'
    code = code if code in ISSUES else 'native_failed'
    return {'issueCode': code, 'issue': ISSUES[code]}


def _expires(timestamp):
    return datetime.fromtimestamp(timestamp, timezone.utc).isoformat(timespec='seconds')


class WindowsVisualSender:
    """HTTP callers must supply an account-authorized target name at preview.

    Later stages consume that frozen target; native window metadata contains no
    verified conversation identity and cannot replace these review fields.
    """
    def __init__(self, runtime_dir, *, transport=None, clock=None):
        self.directory = Path(runtime_dir).resolve()
        self.directory.mkdir(parents=True, exist_ok=True)
        self.path = self.directory / 'windows-visual-send.sqlite'
        self.transport, self.clock = transport or _native, clock or time.time
        self.images = {}  # token -> (expiry, decoded metadata + PNG base64), never durable
        self.lock = threading.RLock()
        with closing(self._connect()) as db:
            db.execute('CREATE TABLE IF NOT EXISTS visual_previews (token TEXT PRIMARY KEY,binding TEXT NOT NULL,expires REAL NOT NULL,consumed TEXT NOT NULL)')
            db.execute('CREATE TABLE IF NOT EXISTS visual_drafts (id TEXT PRIMARY KEY,request_hash TEXT NOT NULL,request TEXT NOT NULL,binding TEXT NOT NULL,text_hash TEXT NOT NULL,expires REAL NOT NULL,status TEXT NOT NULL,result TEXT NOT NULL)')
            db.commit()

    def _connect(self):
        db = sqlite3.connect(self.path, timeout=10)
        db.row_factory = sqlite3.Row
        db.execute('PRAGMA synchronous=FULL')
        return db

    def _remember(self, token, picture, expires):
        with self.lock:
            self.images = {key: value for key, value in self.images.items() if value[0] > self.clock()}
            while len(self.images) >= 8:
                self.images.pop(next(iter(self.images)))
            self.images[token] = (expires, picture)

    def _image(self, token):
        with self.lock:
            entry = self.images.get(token)
            if entry is None or entry[0] <= self.clock():
                self.images.pop(token, None)
                raise SendError('preview_expired', ISSUES['preview_expired'])
            return entry[1]

    @staticmethod
    def _public_picture(picture):
        return {'imageDataUrl': 'data:image/png;base64,' + picture['encoded'],
                'width': picture['width'], 'height': picture['height']}

    def preview(self, data):
        # Reuse input validation without requiring a user draft to exist yet.
        if not isinstance(data, dict):
            raise SendError('invalid_request', '窗口预览请求格式无效。')
        request = WindowsSender._request({**data, 'text': 'preview', 'idempotencyKey': 'preview-validation'}, allow_any_target=True)
        selection = {key: request[key] for key in ('pid', 'hwnd', 'sourceRoot', 'targetId')}
        with _input_guard(self.directory):
            result = self.transport('preview', selection)
        if not isinstance(result, dict) or result.get('ok') is not True:
            issue = _issue(result); raise SendError(issue['issueCode'], issue['issue'])
        binding = result.get('binding')
        if (not isinstance(binding, dict) or binding.get('ownerVerified') is not True or
                not binding.get('processStarted') or not binding.get('signature') or
                any(binding.get(key) != selection[key] for key in ('pid', 'hwnd', 'sourceRoot'))):
            raise SendError('owner_unverified', ISSUES['owner_unverified'])
        binding.update(account=request['account'], **_target(request))
        picture = _picture(result)
        token, expires = secrets.token_urlsafe(24), self.clock() + TTL
        with closing(self._connect()) as db:
            db.execute('INSERT INTO visual_previews VALUES (?,?,?,?)', (token, _canonical(binding), expires, ''))
            db.commit()
        self._remember(token, picture, expires)
        return {'status': 'preview', 'previewToken': token, 'expiresAt': _expires(expires),
                **_target(request), 'sourceRoot': selection['sourceRoot'],
                'identityVerified': False, 'targetVerified': False, 'targetBinding': 'operator-confirmed',
                'retryAllowed': False, **self._public_picture(picture)}

    def _view(self, row):
        request = json.loads(row['request'])
        status = row['status']
        if status in ('staging', 'attempted'):
            status = 'unconfirmed'
        result = {'draftId': row['id'], 'status': status, 'text': request['text'], 'textHash': row['text_hash'],
                  'sourceRoot': request['sourceRoot'], **_target(request),
                  'expiresAt': _expires(row['expires']), 'retryAllowed': False, 'delivered': False,
                  'identityVerified': False, 'targetVerified': False, 'targetBinding': 'operator-confirmed', **json.loads(row['result'])}
        if status == 'staged':
            try:
                result.update(self._public_picture(self._image(row['id'])))
            except SendError:
                result.update(status='unconfirmed', **_issue({'issueCode': 'preview_expired'}))
        return result

    def get(self, draft_id):
        with closing(self._connect()) as db:
            row = db.execute('SELECT * FROM visual_drafts WHERE id=?', (draft_id,)).fetchone()
        if row is None:
            raise SendError('draft_missing', '可视发送草稿不存在。')
        return self._view(row)

    def stage(self, data):
        if (not isinstance(data, dict) or data.get('targetConfirmed') is not True or
                data.get('emptyDraftConfirmed') is not True):
            raise SendError('confirmation_required', '请核对图片中的目标会话，并确认原输入框为空且没有附件。')
        token = data.get('previewToken')
        with closing(self._connect()) as db:
            preview = db.execute('SELECT * FROM visual_previews WHERE token=?', (token,)).fetchone()
        if preview is None:
            raise SendError('preview_expired', ISSUES['preview_expired'])
        binding = json.loads(preview['binding'])
        _check_current_source(data, binding)
        _check_frozen_target(data, binding)
        checked = WindowsSender._request({**binding, 'text': data.get('text'), 'idempotencyKey': data.get('idempotencyKey')}, allow_any_target=True)
        request = {**checked, 'previewToken': token}
        for field in ('composePoint', 'sendPoint'):
            point = data.get(field)
            geometry = binding['geometry']
            if (not isinstance(point, list) or len(point) != 2 or any(type(value) is not int for value in point)
                    or not (0 <= point[0] < geometry['width'] and 0 <= point[1] < geometry['height'])):
                raise SendError('invalid_point', ISSUES['invalid_point'])
            request[field] = point
        if sum((a-b)**2 for a,b in zip(request['composePoint'], request['sendPoint'])) < 64:
            raise SendError('invalid_point', '输入框和发送按钮必须点选不同的位置。')
        digest = hashlib.sha256(_canonical(request).encode()).hexdigest()
        draft_id = hashlib.sha256(checked['idempotencyKey'].encode()).hexdigest()[:32]
        with _input_guard(self.directory):
            with closing(self._connect()) as db:
                db.execute('BEGIN IMMEDIATE')
                old = db.execute('SELECT * FROM visual_drafts WHERE id=?', (draft_id,)).fetchone()
                if old is not None:
                    if not _same_request(old, request, digest):
                        raise SendError('idempotency_conflict', '该请求标识已绑定其他内容，未再次填入。')
                    return self._view(old)
                current = db.execute('SELECT * FROM visual_previews WHERE token=?', (token,)).fetchone()
                if current['consumed']:
                    raise SendError('preview_consumed', '这张预览已用于一次草稿操作，请勿重复填入。')
                if current['expires'] <= self.clock():
                    raise SendError('preview_expired', ISSUES['preview_expired'])
                picture = self._image(token)
                text_hash = hashlib.sha256(checked['text'].encode()).hexdigest()
                db.execute('INSERT INTO visual_drafts VALUES (?,?,?,?,?,?,?,?)',
                           (draft_id, digest, _canonical(request), _canonical(binding), text_hash,
                            self.clock() + TTL, 'staging', '{}'))
                db.execute('UPDATE visual_previews SET consumed=? WHERE token=?', (draft_id, token))
                db.commit()  # durable BEFORE clicking/typing; never replay a fill
            try:
                result = self.transport('stage', {'binding': binding, 'reference_png_base64': picture['encoded'],
                                                  'composePoint': request['composePoint'], 'sendPoint': request['sendPoint'], 'text': checked['text']})
            except Exception:
                result = {'ok': False, 'stage': 'unknown', 'issueCode': 'native_failed'}
            status, public, new_binding, staged_picture = 'unconfirmed', _issue(result), binding, None
            if isinstance(result, dict) and result.get('ok') is True and result.get('stage') == 'staged':
                try:
                    returned = result.get('binding')
                    if not isinstance(returned, dict) or any(returned.get(key) != binding[key] for key in ('pid','hwnd','sourceRoot','processStarted','signature','geometry')):
                        raise SendError('window_changed', ISSUES['window_changed'])
                    staged_picture = _picture(result)
                    # The native helper captures and clicks an operator-selected
                    # window; its historical filehelper label is not ID proof.
                    returned.update(account=binding['account'], **_target(binding))
                    new_binding, status, public = returned, 'staged', {}
                except SendError as exc:
                    public = _issue({'issueCode': exc.code})
            elif isinstance(result, dict) and result.get('stage') == 'before_input':
                status = 'blocked'
            expires = self.clock() + TTL
            if staged_picture is not None:
                self._remember(draft_id, staged_picture, expires)
            with closing(self._connect()) as db:
                db.execute('UPDATE visual_drafts SET binding=?,expires=?,status=?,result=? WHERE id=?',
                           (_canonical(new_binding), expires, status, _canonical(public), draft_id))
                db.commit()
            with self.lock:
                self.images.pop(token, None)
        return self.get(draft_id)

    def confirm(self, data):
        if (not isinstance(data, dict) or data.get('targetConfirmed') is not True or
                data.get('textConfirmed') is not True):
            raise SendError('confirmation_required', '请对新图片中的目标和实际填入的完整正文再次明确确认。')
        with _input_guard(self.directory):
            with closing(self._connect()) as db:
                db.execute('BEGIN IMMEDIATE')
                row = db.execute('SELECT * FROM visual_drafts WHERE id=?', (data.get('draftId'),)).fetchone()
                if row is None:
                    raise SendError('draft_missing', '可视发送草稿不存在。')
                _check_current_source(data, json.loads(row['request']))
                _check_frozen_target(data, json.loads(row['request']))
                if row['text_hash'] != data.get('textHash'):
                    raise SendError('text_changed', '确认正文摘要不一致，未点击发送。')
                if row['status'] != 'staged':
                    return self._view(row)
                picture = self._image(row['id'])
                if row['expires'] <= self.clock():
                    raise SendError('preview_expired', ISSUES['preview_expired'])
                db.execute("UPDATE visual_drafts SET status='attempted' WHERE id=?", (row['id'],))
                db.commit()  # durable BEFORE the single send click
            request, binding = json.loads(row['request']), json.loads(row['binding'])
            try:
                result = self.transport('submit', {'binding': binding, 'reference_png_base64': picture['encoded'],
                                                   'composePoint': request['composePoint'], 'sendPoint': request['sendPoint']})
            except Exception:
                result = {'ok': False, 'stage': 'unknown', 'issueCode': 'native_failed'}
            if isinstance(result, dict) and result.get('ok') is True and result.get('stage') == 'submitted':
                status = 'submitted_unconfirmed'
                public = {'issue': '已点击一次发送，尚无接收回执；请核实结果，勿重复此操作。', 'issueCode': ''}
            else:
                status = 'blocked' if isinstance(result, dict) and result.get('stage') == 'before_input' else 'unconfirmed'
                public = _issue(result)
            with closing(self._connect()) as db:
                db.execute('UPDATE visual_drafts SET status=?,result=? WHERE id=?', (status, _canonical(public), row['id']))
                db.commit()
            with self.lock:
                self.images.pop(row['id'], None)
        return self.get(row['id'])
