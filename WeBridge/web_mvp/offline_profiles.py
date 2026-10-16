"""One user profile per client; bounded legacy discovery, no account probing."""
import hashlib
import json
import os
from pathlib import Path
import sys
import tempfile


def default_directory(client):
    if client not in ('wechat', 'wecom'):
        raise ValueError('Unsupported client')
    root = Path(os.environ.get('LOCALAPPDATA') or Path.home()/'AppData/Local')
    return (root / ('LocalWeComArchive' if client == 'wecom' else 'LocalWechatArchive')).resolve()


def application_directory():
    return (Path(sys.executable).resolve().parent if getattr(sys, 'frozen', False)
            else Path(__file__).resolve().parents[1]/'.runtime/local-chat-desktop')


def _linked(path):
    return path.is_symlink() or path.is_junction()


def legacy_settings(client):
    """Only named old profiles beside/near the EXE or current workspace, never disk-wide."""
    app = application_directory()
    roots = list(dict.fromkeys((app, app.parent, Path.cwd().resolve())))
    roots += [root/'build' for root in list(roots)]
    name = 'local-chat-data-wecom' if client == 'wecom' else 'local-chat-data'
    found = set()
    for root in roots:
        try:
            if not root.is_dir() or _linked(root):
                continue
            directories = [root]
            # Bound filesystem work even in a large Downloads/project directory.
            with os.scandir(root) as entries:
                for index, entry in enumerate(entries):
                    if index >= 256:
                        break
                    if entry.is_dir(follow_symlinks=False) and not _linked(Path(entry.path)):
                        directories.append(Path(entry.path))
            for directory in directories:
                profile = directory/name
                settings = profile/'settings.local.json'
                if not _linked(profile) and not _linked(settings) and settings.is_file():
                    found.add(settings.resolve())
        except OSError:
            continue
    return sorted(found, key=lambda path: str(path).lower())[:64]


def read_legacy(path, client):
    path = Path(path).resolve()
    if path.name != 'settings.local.json' or path.stat().st_size > 65536:
        raise ValueError('请选择旧程序目录下的 settings.local.json，文件上限64 KiB。')
    value = json.loads(path.read_text(encoding='utf-8-sig'))
    if not isinstance(value, dict) or value.get('version') != 1:
        raise ValueError('旧配置的格式或版本不支持。')
    if value.get('client', 'wechat') != client:
        raise ValueError('旧配置属于另一种客户端，请使用对应的个微或企微入口。')
    config = value.get('source')
    if not isinstance(config, dict) or not isinstance(config.get('sourceRoot'), str) or not config['sourceRoot'].strip():
        raise ValueError('旧配置缺少已确认的数据目录。')
    config = dict(config)
    for name in ('sourceRoot', 'keyFile', 'imageKeyFile'):
        reference = config.get(name)
        if reference:
            if not isinstance(reference, str):
                raise ValueError('旧配置中的数据与密钥必须为文件路径。')
            target = Path(reference).expanduser()
            config[name] = str((target if target.is_absolute() else path.parent/target).resolve())
    for name in ('includeMedia', 'includeVoice'):
        if name in config and not isinstance(config[name], bool):
            raise ValueError('旧配置中的媒体选项格式不正确。')
    if 'selfId' in config and not isinstance(config['selfId'], str):
        raise ValueError('旧配置中的本人ID格式不正确。')
    return value, config


def copy_key_references(config, directory):
    """Copy only explicitly referenced keys; leave chat data and old files in place."""
    config = dict(config)
    for name in ('keyFile', 'imageKeyFile'):
        if not config.get(name):
            continue
        source = Path(config[name])
        if source.stat().st_size > 1024*1024:
            raise ValueError('旧配置引用的密钥文件超过1 MiB，请在手动页确认文件。')
        data = source.read_bytes()
        if len(data) > 1024*1024:
            raise ValueError('旧配置引用的密钥文件超过1 MiB。')
        folder = directory/'keys'
        if _linked(folder):
            raise ValueError('配置密钥目录不能为链接目录。')
        folder.mkdir(parents=True, exist_ok=True)
        target = folder/('imported-'+hashlib.sha256(data).hexdigest()+'.json')
        if target.exists():
            if _linked(target) or target.read_bytes() != data:
                raise ValueError('迁移密钥文件发生冲突，请保留旧配置并检查目标目录。')
        else:
            try:
                _atomic_create(target, data)
            except FileExistsError:
                if _linked(target) or target.read_bytes() != data:
                    raise ValueError('迁移密钥文件发生冲突。')
        config[name] = str(target)
    return config


def _atomic_create(path, data):
    """Publish a complete file without replacing a concurrently created profile."""
    path.parent.mkdir(parents=True, exist_ok=True)
    fd, temporary = tempfile.mkstemp(prefix='.profile-', dir=path.parent)
    try:
        with os.fdopen(fd, 'wb') as stream:
            stream.write(data)
            stream.flush()
            os.fsync(stream.fileno())
        if os.name == 'nt':
            os.rename(temporary, path)  # Windows rename refuses an existing destination.
        else:
            os.link(temporary, path)
    finally:
        Path(temporary).unlink(missing_ok=True)


def publish_settings(path, value):
    _atomic_create(path, json.dumps(value, ensure_ascii=False, indent=2).encode('utf8'))
