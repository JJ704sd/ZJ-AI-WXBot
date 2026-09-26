"""Cross-platform process locking and read-only workbench diagnostics."""
import importlib.util
import os
from pathlib import Path
import platform
import shutil

from backend import ROOT


class ProcessLock:
    """Hold a byte/file lock for the lifetime of one workbench process."""
    def __init__(self, path):
        self.path = Path(path)
        self.file = None

    def __enter__(self):
        self.file = self.path.open('a+b')
        try:
            if os.name == 'nt':
                import msvcrt
                if self.file.seek(0, os.SEEK_END) == 0:
                    self.file.write(b'0')
                    self.file.flush()
                self.file.seek(0)
                msvcrt.locking(self.file.fileno(), msvcrt.LK_NBLCK, 1)
            else:
                import fcntl
                fcntl.flock(self.file, fcntl.LOCK_EX | fcntl.LOCK_NB)
        except (OSError, BlockingIOError):
            self.file.close()
            self.file = None
            raise RuntimeError('工作台已在运行，请打开已有页面或先停止服务。') from None
        return self

    def __exit__(self, *args):
        if self.file is None:
            return
        try:
            if os.name == 'nt':
                import msvcrt
                self.file.seek(0)
                msvcrt.locking(self.file.fileno(), msvcrt.LK_UNLCK, 1)
            else:
                import fcntl
                fcntl.flock(self.file, fcntl.LOCK_UN)
        finally:
            self.file.close()
            self.file = None


def runtime_summary(engine):
    mode = getattr(engine.adapter, 'mode', 'live')
    demo = mode == 'demo'
    database = mode == 'database'
    database_service = getattr(engine, 'database_service', None)
    with engine.lock:
        connected = bool(engine.account) and engine.connection.get('status') == ('snapshot_ready' if database else 'logged_in') and not engine.logging_out
        bridge_ready = connected and bool(engine.self_id)
    return {'mode': mode, 'platform': platform.system(),
            'connected': connected, 'bridgeKind': 'database-copy' if database else 'demo' if demo else 'linux-docker',
            'source': engine.adapter.get_source_info() if database else None,
            'databaseState': {'busy': database_service.busy, 'error': database_service.error} if database_service else None,
            'capabilities': {'demo': demo, 'read': connected, 'readOnly': database,
                             'desktopSend':database and getattr(engine,'desktop_sender',None) is not None,
                             'hookSendInterface':database and getattr(engine,'hook_sender',None) is not None,
                             'scheduledSend':not database, 'automaticReplies':not database,
                             'mentions': bool(engine.self_id), 'supportsLiveSend': not demo and not database,
                             'liveSend': not demo and not database and bridge_ready,
                             'media': not demo and not database and bridge_ready,
                             'canSend': not database and bridge_ready,
                             'send': 'disabled' if database else 'simulated' if demo else 'live'}}


def environment_report(engine):
    """Inspect local prerequisites and cached state without probing a real account."""
    summary = runtime_summary(engine)
    demo = summary['mode'] == 'demo'
    database = summary['mode'] == 'database'
    directory = engine.store.path.parent.resolve()
    checks = [
        {'id': 'python', 'label': 'Python 运行环境', 'status': 'ok', 'detail': platform.python_version()},
        {'id': 'storage', 'label': '本地状态数据库', 'status': 'ok', 'detail': str(engine.store.path.resolve())},
        {'id': 'mode', 'label': '运行模式', 'status': 'ok',
         'detail': '数据库副本：读取已校验副本，按源文件变化更新；Windows Hook 发送单独校验版本和账号。' if database else '本地演示：所有消息为合成数据，发送仅在本地模拟。' if demo else 'Docker 桥接：连接本机 Linux 微信实验容器。'},
    ]
    if database:
        for dependency, label in [('cryptography', '加密副本解密组件'), ('zstandard', '压缩消息解码组件')]:
            available = importlib.util.find_spec(dependency) is not None
            checks.append({'id': dependency, 'label': label, 'status': 'ok' if available else 'warning',
                           'detail': '已安装。' if available else '未安装；需要处理对应数据时安装 web_mvp/requirements-database.txt。'})
        checks.append({'id': 'source', 'label': '数据库副本', 'status': 'ok' if summary['connected'] else 'warning',
                       'detail': '副本可读，更新策略由数据源设置控制。' if summary['connected'] else '请在数据源设置中创建或加载副本。'})
        return {**summary, 'pythonVersion': platform.python_version(), 'timezone': 'Asia/Shanghai',
                'runtimeDirectory': str(directory), 'prerequisitesReady': True, 'ready': summary['connected'],
                'checks': checks, 'limitations': ['可读状态表示上一次副本校验成功；源消息写入和后续更新可能延迟或失败。',
                                                'Windows Hook 尚需当前客户端版本适配和真实发送验证；不启用定时发送、自动回复或附件发送。']}
    docker = shutil.which('docker') is not None
    token = (ROOT / '.secrets/linux-token').is_file()
    websockets = importlib.util.find_spec('websockets') is not None
    for key, label, available, detail in [
        ('docker', 'Docker 命令', docker, '已找到 Docker 命令；守护进程和容器状态未单独探测。' if docker else '未找到 Docker；真实模式需要 Docker Desktop 和 Linux 容器。'),
        ('token', '桥接配置', token, '已找到令牌文件（未展示内容）。' if token else '缺少 .secrets/linux-token；请完成实验容器配置。'),
        ('websockets', '扫码登录依赖', websockets, '已安装 websockets。' if websockets else '真实扫码需安装 web_mvp/requirements.txt。'),
    ]:
        checks.append({'id': key, 'label': label, 'status': 'ok' if available else ('warning' if demo else 'error'),
                       'detail': detail + (' 演示模式不需要此项。' if demo else '')})
    connection = engine.snapshot()['connection']
    if not demo:
        checks.append({'id': 'connection', 'label': '微信连接',
                       'status': 'ok' if connection.get('status') == 'logged_in' else 'warning',
                       'detail': '当前账号已连接。' if connection.get('status') == 'logged_in' else connection.get('error', '当前尚未登录，请连接微信。')})
    prerequisites_ready = not any(c['status'] == 'error' for c in checks)
    return {**summary, 'pythonVersion': platform.python_version(), 'timezone': 'Asia/Shanghai',
            'runtimeDirectory': str(directory), 'prerequisitesReady': prerequisites_ready,
            'ready': prerequisites_ready and summary['capabilities']['canSend'],
            'checks': checks, 'limitations': [
                'live 模式使用 Linux 微信 Docker 实验桥接，不代表已接入本机 Windows 微信。',
                '演示结果不能证明真实微信的读取、发送或附件能力。',
            ]}
