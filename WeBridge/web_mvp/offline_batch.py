"""Versioned JSON requests for the portable desktop EXE, without a GUI.

The same validated snapshot/export workflow is shared with interactive use.
Input is file references and filters; no source documents become instructions.
"""
import json
from pathlib import Path

from offline_chat import ArchiveError, discover
from offline_desktop import CONFIG_FIELDS, DesktopSession, safe_issue

MAX_REQUEST_BYTES = 65536
TASK_FIELDS = {'version', 'action', 'source', 'roots', 'chatId', 'chatName', 'startDate', 'endDate', 'copyMedia',
               'allowProcessRead', 'timeoutSeconds', 'scanBudgetMiB'}


def execute(task, directory):
    if not isinstance(task, dict) or set(task) - TASK_FIELDS or task.get('version') != 1:
        raise ArchiveError('请求格式或版本不支持；需要 version=1 的本地任务。')
    action = task.get('action')
    if action not in ('discover', 'groups', 'export', 'recover_keys'):
        raise ArchiveError('本地任务类型不支持。')
    if action == 'recover_keys' and task.get('allowProcessRead') is not True:
        raise ArchiveError('恢复密钥需要用户明确选择只读访问本机当前微信进程。')
    if action == 'discover':
        roots = task.get('roots')
        if roots is not None and (not isinstance(roots, list) or len(roots) > 16 or
                                  not all(isinstance(root, str) and root for root in roots)):
            raise ArchiveError('发现目录应为不超过16项的路径列表。')
        return {'ok': True, 'action': action, **discover(roots)}
    if action == 'export':
        if bool(task.get('chatId')) == bool(task.get('chatName')):
            raise ArchiveError('导出时需要且只能提供 chatId 或 chatName。')
        for name in ('chatId', 'chatName', 'startDate', 'endDate'):
            if name in task and not isinstance(task[name], str):
                raise ArchiveError('会话与日期筛选必须是字符串。')
        if 'copyMedia' in task and not isinstance(task['copyMedia'], bool):
            raise ArchiveError('copyMedia 必须为布尔值。')
    session = DesktopSession(directory)
    config = task.get('source')
    if config is not None:
        if not isinstance(config, dict) or set(config) - set(CONFIG_FIELDS):
            raise ArchiveError('数据设置只接受数据、已有密钥的文件路径及支持的选项。')
        if any(not isinstance(config[name], bool) for name in ('includeMedia', 'includeVoice') if name in config):
            raise ArchiveError('附件索引与语音选项必须为布尔值。')
        if any(not isinstance(config[name], str) for name in ('sourceRoot', 'keyFile', 'imageKeyFile', 'selfId') if name in config):
            raise ArchiveError('数据和密钥设置必须为路径字符串，不接受密钥正文。')
        if action == 'recover_keys':
            from portable_key_recovery import recover_key_file
            recovered = recover_key_file(config.get('sourceRoot', ''), directory, allow_process_read=True,
                include_media=config.get('includeMedia', True), timeout=task.get('timeoutSeconds', 30),
                budget_mib=task.get('scanBudgetMiB', 512))
            config = {**config, 'keyFile': recovered['keyFile'],
                      'imageKeyFile': '' if recovered['imageRecovery'] == 'verified_local_samples' else config.get('imageKeyFile', '')}
        info = session.open_source(config)
    else:
        if action == 'recover_keys':
            raise ArchiveError('恢复密钥需要明确选择当前本机微信的数据目录。')
        info = session.bootstrap()
    if info['status'] != 'ready':
        return {'ok': False, 'action': action, 'error': info['message'], 'needsSource': True}
    if action == 'recover_keys':
        return {'ok': True, 'action': action, **recovered, 'groups': info['groups'],
                'sourceStatus': info['message'], 'snapshotTime': info['snapshotTime']}
    if action == 'groups':
        return {'ok': True, 'action': action, 'groups': info['groups'],
                'sourceStatus': info['message'], 'snapshotTime': info['snapshotTime'], 'coverage': info['coverage']}
    selected = session.archive.select_chat(chat_id=task.get('chatId'), chat_name=task.get('chatName'))
    result = session.export(selected['id'], task.get('startDate') or None, task.get('endDate') or None,
                            copy_media=task.get('copyMedia', True))
    return {'ok': True, 'action': action, **result}


def run_file(request, result, directory):
    request, result = Path(request).resolve(), Path(result).resolve()
    if result.exists():
        return 2
    try:
        if request.stat().st_size > MAX_REQUEST_BYTES:
            raise ArchiveError('任务文件超过64 KiB支持上限。')
        with request.open('rb') as handle:
            data = handle.read(MAX_REQUEST_BYTES + 1)
        if len(data) > MAX_REQUEST_BYTES:
            raise ArchiveError('任务文件超过64 KiB支持上限。')
        task = json.loads(data.decode('utf-8-sig'))
        config = task.get('source', {}) if isinstance(task, dict) else {}
        if not config:
            config = DesktopSession(directory).settings.get('source', {})
        if isinstance(config, dict) and isinstance(config.get('sourceRoot'), str) and config['sourceRoot']:
            source = Path(config['sourceRoot']).resolve()
            account = source.parent if source.name == 'db_storage' else source
            if result == account or result.is_relative_to(account):
                return 2  # Never write even an error report into the input account.
        value = execute(task, directory)
    except Exception as error:
        value = {'ok': False, 'error': safe_issue(error)}
    try:
        result.parent.mkdir(parents=True, exist_ok=True)
        with result.open('x', encoding='utf-8') as handle:
            json.dump(value, handle, ensure_ascii=False, indent=2)
    except OSError:
        return 2
    return 0 if value['ok'] else 2
