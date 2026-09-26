"""Manually build and activate database copies; never extract keys or send messages."""
from datetime import datetime, timezone
import hashlib
import json
from pathlib import Path
import shutil
import threading
import time

from backend import BridgeError


def utc_now():
    return datetime.now(timezone.utc).isoformat(timespec='seconds')


class DatabaseService:
    def __init__(self, adapter, runtime_directory, engine=None):
        self.adapter = adapter
        self.directory = Path(runtime_directory).resolve()
        self.directory.mkdir(parents=True, exist_ok=True)
        self.config_path = self.directory / 'database-config.json'
        self.snapshot_directory = self.directory / 'database-snapshots'
        self.engine = engine
        self.lock = threading.RLock()
        self.busy = False
        self.error = ''
        self.config = {}
        self.worker = None
        self.source_signature = None
        self.next_check = 0
        self.active_root = None
        self.previous_root = None
        self._restore()

    def _restore(self):
        if not self.config_path.exists():
            return
        try:
            saved = json.loads(self.config_path.read_text(encoding='utf-8'))
            config = self._validate_config(saved['config'])
            root = Path(saved['snapshotRoot']).resolve()
            if not root.is_relative_to(self.snapshot_directory.resolve()) or root == self.snapshot_directory.resolve():
                raise ValueError('Invalid snapshot location')
            self.adapter.configure(root, self_id=config['selfId'], source_id=saved['source']['id'], source_info=saved['source'])
            self.config = config
            self.active_root = root
            previous = saved.get('previousSnapshotRoot')
            if previous:
                previous = Path(previous)
                resolved = previous.resolve()
                if (previous.is_absolute() and not previous.is_symlink() and resolved.parent == self.snapshot_directory.resolve()
                        and resolved != root and resolved.is_dir()):
                    self.previous_root = resolved
        except (OSError, ValueError, KeyError, TypeError, BridgeError):
            self.error = '上次数据库副本无法加载，请重新选择源目录并创建副本。'

    @staticmethod
    def _validate_config(data):
        if not isinstance(data, dict):
            raise ValueError('数据库配置格式无效。')
        clean = {}
        for key in ('sourceRoot', 'selfId', 'keyFile'):
            value = data.get(key, '')
            if not isinstance(value, str) or len(value) > 2048 or '\0' in value:
                raise ValueError('数据库配置字段无效。')
            clean[key] = value.strip()
        if not clean['sourceRoot'] or not Path(clean['sourceRoot']).is_absolute():
            raise ValueError('请填写数据库源目录的完整绝对路径。')
        if clean['keyFile'] and not Path(clean['keyFile']).is_absolute():
            raise ValueError('密钥文件须为本机绝对路径，请勿填写密钥内容。')
        if len(clean['selfId']) > 200 or any(c in clean['selfId'] for c in '\r\n'):
            raise ValueError('本人微信标识格式无效。')
        clean['sourceRoot'] = str(Path(clean['sourceRoot']).resolve())
        auto = data.get('autoRefresh', True)
        if not isinstance(auto, bool):
            raise ValueError('自动接收开关格式无效。')
        clean['autoRefresh'] = auto
        if clean['keyFile']:
            clean['keyFile'] = str(Path(clean['keyFile']).resolve())
        return clean

    def snapshot(self):
        with self.lock:
            return {'mode': 'database', 'configured': bool(self.config),
                    'config': dict(self.config), 'source': self.adapter.get_source_info(),
                    'busy': self.busy, 'error': self.error}

    @staticmethod
    def _signature(config):
        from database_snapshot import _inventory
        root = Path(config['sourceRoot'])
        if (root / 'db_storage').is_dir():
            root = root / 'db_storage'
        return _inventory(root)

    def check_for_changes(self):
        """Poll file metadata; copy only changed sources, at most every 5 seconds."""
        with self.lock:
            if self.busy or not self.config or not self.config.get('autoRefresh', True) or time.monotonic() < self.next_check:
                return
            self.next_check = time.monotonic() + 5
            config = dict(self.config)
            try:
                current = self._signature(config)
                if current != self.source_signature:
                    self.configure(config)
            except Exception as exc:
                self.error = getattr(exc, 'public_message', '源目录暂不可读，保留上次副本，稍后重新检查。')
                self.next_check = time.monotonic() + 15

    def configure(self, data):
        config = self._validate_config(data)
        source = Path(config['sourceRoot'])
        if not source.is_dir():
            raise ValueError('数据库源目录不存在或当前用户不能访问。')
        # Never write a managed copy inside its source, or read our own output as input.
        snapshots = self.snapshot_directory.resolve()
        if source == snapshots or source.is_relative_to(snapshots) or snapshots.is_relative_to(source):
            raise ValueError('源目录与工作台副本目录不能相互包含。')
        with self.lock:
            if self.busy:
                raise ValueError('正在创建副本，请等待当前操作完成。')
            self.busy = True
            self.error = ''
            self.worker = threading.Thread(target=self._build, args=(config,), name='database-copy', daemon=True)
            self.worker.start()
        return {'ok': True, **self.snapshot()}

    def refresh(self):
        with self.lock:
            config = dict(self.config)
        if not config:
            raise ValueError('请先配置数据库源目录。')
        return self.configure(config)

    def _build(self, config):
        activated = False
        prepared_root = None
        pending = None
        try:
            observed = self._signature(config)
            from database_snapshot import prepare_snapshot
            prepared = prepare_snapshot(config['sourceRoot'], self.snapshot_directory, keys_file=config['keyFile'] or None)
            root = Path(prepared['root']).resolve()
            if not root.is_relative_to(self.snapshot_directory.resolve()) or root == self.snapshot_directory.resolve():
                raise ValueError('Invalid snapshot result')
            prepared_root = root
            identity = config['sourceRoot'].casefold() + '\0' + config['selfId']
            source = {**prepared.get('source', {}), 'id': 'database:' + hashlib.sha256(identity.encode()).hexdigest()[:24],
                      'revision': root.name, 'sourceRoot': config['sourceRoot'],
                      'createdAt': prepared.get('source', {}).get('createdAt') or utc_now(),
                      'status': 'ready', 'updatePolicy': 'on_change' if config['autoRefresh'] else 'manual',
                      'pollIntervalSeconds': 5 if config['autoRefresh'] else None}
            saved = {'config': config, 'source': source, 'snapshotRoot': str(root),
                     'previousSnapshotRoot': str(self.active_root) if self.active_root else None}
            pending = self.config_path.with_suffix('.json.tmp')
            pending.write_text(json.dumps(saved, ensure_ascii=False, indent=2), encoding='utf-8')
            # Adapter validates all files before replacing its current source.
            with self.lock:
                self.adapter.configure(root, self_id=config['selfId'], source_id=source['id'], source_info=source)
                activated = True
                disposable = self.previous_root
                self.previous_root = self.active_root
                self.active_root = root
                self.config = config
                self.source_signature = observed
            pending.replace(self.config_path)
            # A successful activation holds no open connection to older roots.
            # Keep one previous generation; delete only roots this service owned.
            if disposable is not None and disposable not in (root, self.previous_root):
                self._remove_generation(disposable)
            if self.engine:
                self.engine.refresh_connection(force=True)
        except Exception as exc:
            # Only our typed public snapshot errors may reach the browser.
            message = getattr(exc, 'public_message', None)
            with self.lock:
                if activated:
                    self.error = '新副本已加载，但配置保存或界面刷新未完成；请检查磁盘权限，重启前重新创建副本以保存配置。'
                else:
                    self.error = message if isinstance(message, str) else str(exc) if isinstance(exc, BridgeError) else '副本创建或校验失败，当前已加载副本仍可查看。请检查源目录、密钥文件和磁盘空间。'
                self.next_check = time.monotonic() + 15
        finally:
            # Only this build's validated, unpublished generation is disposable.
            # Never remove a loaded generation, including after a save failure.
            if not activated and prepared_root is not None:
                try:
                    self._remove_generation(prepared_root)
                except OSError:
                    with self.lock:
                        self.error += ' 未发布副本清理失败，请检查工作台副本目录权限。'
            if pending is not None:
                try:
                    pending.unlink(missing_ok=True)
                except OSError:
                    with self.lock:
                        self.error += ' 临时配置清理失败。'
            if activated and self.engine:
                try:
                    self.engine.refresh_connection(force=True)
                except Exception:
                    pass
            with self.lock:
                self.busy = False

    def _remove_generation(self, generation):
        managed = self.snapshot_directory.resolve()
        target = generation.resolve()
        if target.parent == managed and not generation.is_symlink() and target != self.active_root:
            shutil.rmtree(target)
