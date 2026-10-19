"""Local desktop workflow. GUI-independent so startup/export can be verified.

Settings contain file references, never key material. Client/Hook tools are not
called. All snapshots and exports belong to this application's data directory.
"""
from datetime import datetime
import hashlib
import json
import os
from pathlib import Path
import tempfile
import uuid

from database_adapter import DatabaseError
from database_snapshot import SnapshotError, prepare_snapshot
from offline_chat import ArchiveError, LocalArchive, discover, workbench_source
from offline_view import ConversationView
from offline_accounts import same_account_source

CONFIG_FIELDS = ('sourceRoot', 'keyFile', 'imageKeyFile', 'selfId', 'includeMedia', 'includeVoice')


def safe_issue(error):
    if isinstance(error, (ArchiveError, SnapshotError, DatabaseError)):
        return str(error)
    if isinstance(error, PermissionError):
        return '文件访问被系统拒绝，请使用拥有该副本读取权限的本机用户运行。'
    return '无法读取本地数据，请检查数据目录、密钥文件和文件访问权限。'


class DesktopSession:
    def __init__(self, data_directory, workbench=None, *, client='wechat'):
        if client not in ('wechat', 'wecom'):
            raise ArchiveError('客户端类型必须为 wechat 或 wecom。')
        self.client = client
        self.directory = Path(data_directory).resolve()
        self.settings_path = self.directory / 'settings.local.json'
        self.workbench = Path(workbench) if workbench else None
        self.settings = self._settings()
        self.archive = None
        self.groups = []
        self.last_export = None
        self.source_status = ''
        self.views = {}
        self.pending_review = None
        self._reviews = {}
        self._exports = {}
        self.last_batch_root = None

    def _settings(self):
        try:
            if self.settings_path.stat().st_size > 65536:
                return {}
            value = json.loads(self.settings_path.read_text(encoding='utf-8-sig'))
            return value if isinstance(value, dict) and value.get('version') == 1 else {}
        except (OSError, ValueError):
            return {}

    def _save(self, config=None, last_chat=None):
        value = dict(self.settings)
        value['version'] = 1
        value['client'] = self.client
        if config is not None:
            previous = value.get('source', {}).get('sourceRoot')
            if previous and not same_account_source(previous, config.get('sourceRoot'), self.client):
                value.pop('lastChat', None)
            value['source'] = {name: config[name] for name in CONFIG_FIELDS if name in config}
        if last_chat is not None:
            value['lastChat'] = last_chat
        self.directory.mkdir(parents=True, exist_ok=True)
        fd, temporary = tempfile.mkstemp(prefix='.settings-', dir=self.directory)
        try:
            with os.fdopen(fd, 'w', encoding='utf-8') as stream:
                json.dump(value, stream, ensure_ascii=False, indent=2)
            os.replace(temporary, self.settings_path)
        finally:
            if Path(temporary).exists():
                Path(temporary).unlink()
        self.settings = value

    def _outside_source(self, config):
        source = Path(config['sourceRoot']).expanduser().resolve()
        account = source.parent if source.name in ('db_storage', 'Data') else source
        if self.directory == account or self.directory.is_relative_to(account):
            raise ArchiveError('程序数据目录不能位于微信账号目录内，请将程序移到其他位置运行。')

    def open_source(self, config, *, save=True):
        self.discard_review()
        if self.settings.get('source') and self.settings.get('client', 'wechat') != self.client:
            raise ArchiveError('当前程序配置属于另一种客户端，请使用各自的启动入口和独立数据目录。')
        config = {name: config[name] for name in CONFIG_FIELDS if name in config}
        if not isinstance(config.get('sourceRoot'), str) or not config['sourceRoot'].strip():
            raise ArchiveError('请选择一个本机账号的数据目录或已经解密的副本目录。')
        config['sourceRoot'] = str(Path(config['sourceRoot']).expanduser().resolve())
        self._outside_source(config)
        snapshot_factory, archive_factory = prepare_snapshot, LocalArchive
        if self.client == 'wecom':
            from wecom_snapshot import prepare_snapshot as snapshot_factory
            from wecom_archive import WeComArchive as archive_factory
        result = snapshot_factory(config['sourceRoot'], self.directory / 'snapshots',
            config.get('keyFile') or None, include_media=config.get('includeMedia', False),
            include_voice=config.get('includeVoice', False))
        archive = archive_factory(result['root'], config.get('selfId', ''), config)
        groups = archive.groups()['conversations']
        # Persist only a source that really passed decryption and schema checks.
        if save:
            self._save(config)
        self.archive, self.groups = archive, groups
        self.source_status = '已创建并验证新的本地副本'
        self.last_export = None
        self.views.clear()
        return self.ready_info()

    def bootstrap(self):
        saved = self.settings.get('source')
        if isinstance(saved, dict) and saved.get('sourceRoot'):
            try:
                return self.open_source(saved)
            except (OSError, ValueError, DatabaseError) as error:
                # Keep the selected source. Never silently switch accounts.
                return {'status': 'needs_source', 'message': safe_issue(error), 'config': saved}
        if self.settings_path.exists() or self.settings_path.is_symlink():
            return {'status': 'needs_source', 'message': '用户配置已存在但无法读取有效数据源；已保留原文件，请在账号设置中修复，或导入旧版配置。'}
        from offline_profiles import default_directory, legacy_settings, read_legacy
        if self.directory == default_directory(self.client):
            paths = legacy_settings(self.client)
            candidates = []
            for path in paths:
                try:
                    value, config = read_legacy(path, self.client)
                    candidates.append((path.stat().st_mtime_ns, path, config))
                except (OSError, ValueError):
                    continue
            if candidates:
                source = candidates[0][2]['sourceRoot']
                if any(not same_account_source(source, config['sourceRoot'], self.client) for _, _, config in candidates[1:]):
                    return {'status': 'needs_source', 'message': '发现多个不同账号的旧配置，未自动选择。请在手动页点击“导入旧版配置”，选择要继续使用的账号配置。'}
                last_error = None
                for _, path, config in sorted(candidates, key=lambda item: item[0], reverse=True)[:8]:
                    try:
                        return self.import_settings(path, overwrite=False)
                    except (OSError, ValueError, DatabaseError) as error:
                        last_error = error
                return {'status': 'needs_source', 'message': '已找到旧配置但校验未通过，旧文件已保留。'+safe_issue(last_error),
                        'config': config}
            if paths:
                return {'status': 'needs_source', 'message': '发现旧配置但格式、客户端或路径不符合要求，已保留旧文件。请在手动页导入正确的旧版配置，或修复数据和密钥路径。'}
        if self.client == 'wechat' and self.workbench and self.workbench.is_file():
            try:
                return self.open_workbench(self.workbench)
            except (OSError, ValueError, KeyError, TypeError, DatabaseError) as error:
                return {'status': 'needs_source', 'message': safe_issue(error)}
        label = '企业微信' if self.client == 'wecom' else '微信'
        return {'status': 'needs_source', 'message': f'首次使用：登录本人{label}后点击“一键自动配置”；已有数据与密钥也可在手动页选择。'}

    def import_settings(self, path, *, overwrite=True):
        """Validate before publishing; automatic migration never overwrites a user profile."""
        self.discard_review()
        from offline_profiles import read_legacy, copy_key_references, publish_settings
        from offline_startup import record
        value, config = read_legacy(path, self.client)
        if not overwrite and self.settings_path.exists():
            self.settings = self._settings()
            return self.bootstrap()
        probe = DesktopSession(self.directory, client=self.client)
        probe.open_source(config, save=False)
        config = copy_key_references(config, self.directory)
        value = {**value, 'version': 1, 'client': self.client,
                 'source': {name: config[name] for name in CONFIG_FIELDS if name in config}}
        if overwrite:
            probe.settings = value
            probe._save(config)
        else:
            try:
                publish_settings(self.settings_path, value)
            except FileExistsError:
                self.settings = self._settings()
                return self.bootstrap()
        self.settings = value
        self.archive, self.groups = probe.archive, probe.groups
        self.last_export = None
        self.views.clear()
        self.archive.media_config.update(config)
        self.source_status = '已迁移并验证旧配置，后续桌面版与 Skill 共用此账号配置'
        record('profile_migration_completed', client=self.client, copiedKeyReferences=sum(bool(config.get(k)) for k in ('keyFile', 'imageKeyFile')))
        return self.ready_info()

    def open_workbench(self, path):
        snapshot, config = workbench_source(path)
        try:
            return self.open_source(config)
        except (OSError, ValueError, DatabaseError) as error:
            # Fallback is an explicit older-data state, not a successful refresh.
            self._outside_source(config)
            value = prepare_snapshot(snapshot, self.directory / 'snapshots',
                include_media=config.get('includeMedia', False))
            archive = LocalArchive(value['root'], config.get('selfId', ''), config)
            groups = archive.groups()['conversations']
            self.archive, self.groups = archive, groups
            self.last_export = None
            self.views.clear()
            self.source_status = '已加载工作台既有副本，未取得新的客户端数据'
            return {**self.ready_info(), 'notice': safe_issue(error)}

    def ready_info(self):
        info = self.archive.adapter.get_source_info()
        config = self.archive.media_config
        profile = self._account_names({'accounts': [{'sourceRoot': config['sourceRoot']}]})['accounts'][0]
        return {'status': 'ready', 'groups': self.groups, 'message': self.source_status,
                'snapshotTime': info['createdAt'], 'coverage': self.archive.coverage(), 'accountProfile': profile}

    def discard_review(self, chat=None):
        if chat is None:
            self._reviews.clear()
            self._exports.clear()
            self.last_batch_root = None
        else:
            self._reviews.pop(chat, None)
            self._exports.pop(chat, None)
        self.pending_review = None
        self.last_export = None

    def activate_review(self, chat):
        """Switch reading targets without losing other groups' unconfirmed batches."""
        self.pending_review = self._reviews.get(chat)
        self.last_export = self._exports.get(chat)

    def prepare_review(self, chat, start=None, end=None, copy_media=True, *, page_size=100):
        """Parse into a private reading cache; no final export or human conclusion."""
        from offline_review import inventory, REVIEW_CHECKS
        if self.archive is None:
            raise ArchiveError('请先加载数据。')
        selected = self.archive.select_chat(chat_id=chat)
        if selected['conversationKind'] != 'group':
            raise ArchiveError('请选择当前账号的群聊 ID。')
        self.discard_review(chat)
        review_id = uuid.uuid4().hex
        output = self.directory / 'reviews' / review_id
        report = self.archive.export(output, chat_id=chat, start=start, end=end, copy_media=copy_media)
        source = self.archive.media_config.get('sourceRoot', '')
        account = Path(source).parent.name if Path(source).name in ('Data', 'db_storage') else Path(source).name
        summary = {'version': 1, 'reviewId': review_id, 'client': self.client,
                   'accountDirectory': account, 'selfId': self.archive.state['self_id'],
                   'identityBasis': report['coverage']['identityBasis'],
                   'sourceFingerprint': hashlib.sha256(str(Path(source).resolve()).encode()).hexdigest(),
                   'snapshotTime': self.archive.adapter.get_source_info()['createdAt'],
                   'chat': report['chat'], 'startDate': start, 'endDate': end,
                   'copyMediaRequested': copy_media, 'exportedRows': report['exportedRows'],
                   'kinds': report['kinds'], 'parseStatuses': report['parseStatuses'],
                   'decodeStatuses': report['decodeStatuses'], 'mediaSummary': report['mediaSummary'],
                   'coverage': report['coverage'], 'warnings': report['warnings'],
                   'limitations': report['limitations']}
        self.views[chat] = ConversationView(output)
        view = self.views[chat].page(kind='business', page_size=page_size)
        self.pending_review = {'archive': self.archive, 'root': output,
                               'files': inventory(output), 'summary': summary}
        self._reviews[chat] = self.pending_review
        self._save(last_chat=chat)
        return {'chat': selected, 'report': report, 'view': view,
                'review': summary, 'reviewChecks': dict(REVIEW_CHECKS), 'state': 'awaiting_review'}

    def confirm_export(self, review_id, checks, note='', *, chat=None):
        """Export an unchanged reviewed batch; never parse a newer result here."""
        self.approve_review(review_id, checks, note, chat=chat)
        pending = self.pending_review
        output = self.directory / 'exports' / (datetime.now().strftime('%Y%m%d-%H%M%S-%f') + '-' + review_id[:8])
        return self._publish_pending(pending, output)

    def approve_review(self, review_id, checks, note='', *, chat=None):
        from offline_review import approve_review
        pending = self.pending_review
        if (not pending or pending['archive'] is not self.archive or
                pending['summary']['reviewId'] != review_id or
                (chat is not None and pending['summary']['chat']['id'] != chat)):
            raise ArchiveError('复核目标已失效，请重新解析当前账号和群聊。')
        self.archive._check()
        pending['approval'] = approve_review(pending, checks, note)
        return {'state': 'reviewed', 'review': pending['approval'], 'chat': pending['summary']['chat']}

    def review_status(self, chat):
        if chat in self._exports:
            return '已导出'
        pending = self._reviews.get(chat)
        return ('已复核' if pending.get('approval') else '待复核') if pending else '未解析'

    def _publish_pending(self, pending, output):
        from offline_review import publish_review
        self.archive._check()
        result = publish_review(pending, output)
        self.last_export = output
        selected = pending['summary']['chat']['id']
        self._exports[selected] = output
        self._reviews.pop(selected, None)
        if self.pending_review is pending:
            self.pending_review = None
        return {'output': str(output), 'report': result, 'humanReview': result['humanReview'],
                'mediaSummary': result['mediaSummary'], 'mediaSummaryText': result['mediaSummaryText'],
                'reporting': result['reporting'],
                'exportFiles': {kind: str(output / name) for kind, name in result['messageExports'].items()}}

    def export_reviewed(self, chats):
        """Preflight every selected batch, then publish each once with a batch index."""
        from offline_chat import write_json
        from offline_review import validated_approval
        if not isinstance(chats, (list, tuple)) or not chats or any(not isinstance(chat, str) for chat in chats):
            raise ArchiveError('请先勾选需要导出的群聊。')
        chats = list(dict.fromkeys(chats))
        if self.archive is None:
            raise ArchiveError('请先加载数据。')
        self.archive._check()
        selected = []
        already = []
        for chat in chats:
            if chat in self._exports:
                already.append({'chatId': chat, 'output': str(self._exports[chat])})
                continue
            pending = self._reviews.get(chat)
            if not pending or pending['archive'] is not self.archive:
                raise ArchiveError('所选群中有未解析或已失效的群，请先解析并逐群复核。')
            validated_approval(pending)
            selected.append(pending)
        result = {'version': 1, 'state': 'completed', 'output': None, 'exports': [], 'failed': [],
                  'alreadyExported': already, 'selectedChatIds': chats}
        if not selected:
            return result
        root = self.directory/'exports'/(datetime.now().strftime('%Y%m%d-%H%M%S-%f')+'-batch-'+uuid.uuid4().hex[:8])
        root.mkdir(parents=True)
        self.last_batch_root = root
        result['output'] = str(root)
        for index, pending in enumerate(selected, 1):
            summary = pending['summary']
            destination = root/(f'{index:02d}-'+summary['reviewId'][:8])
            try:
                exported = self._publish_pending(pending, destination)
                result['exports'].append(exported)
            except Exception as error:
                result['failed'].append({'chatId': summary['chat']['id'], 'chatName': summary['chat']['name'],
                                         'error': safe_issue(error)})
        result['state'] = 'partial' if result['failed'] else 'completed'
        index = {'version': 1, 'state': result['state'], 'selectedChatIds': chats, 'alreadyExported': already,
                 'failed': result['failed'], 'groups': [{'chat': item['report']['chat'],
                    'rows': item['report']['exportedRows'], 'reviewId': item['humanReview']['reviewId'],
                    'directory': Path(item['output']).relative_to(root).as_posix(),
                    'files': {kind: Path(path).relative_to(root).as_posix() for kind, path in item['exportFiles'].items()}}
                    for item in result['exports']]}
        write_json(root/'batch.json', index)
        lines = ['# 群聊导出清单', '', f'本次导出 {len(index["groups"])} 个群，失败 {len(result["failed"])} 个，已导出跳过 {len(already)} 个。', '']
        for group in index['groups']:
            lines += [group['chat']['name']+' · '+group['chat']['id']+' · '+str(group['rows'])+' 条',
                      ' / '.join('['+kind.upper()+']('+path+')' for kind, path in group['files'].items()), '']
        for item in result['failed']:
            lines += ['未完成：'+item['chatName']+' · '+item['chatId']+' · '+item['error'], '']
        for item in already:
            lines += ['已导出保留原结果：'+item['chatId']+' · '+item['output'], '']
        (root/'导出清单.md').write_text('\n'.join(lines), encoding='utf8')
        return result

    def scan(self):
        if self.client == 'wecom':
            from wecom_snapshot import discover as discover_wecom
            return discover_wecom()
        return discover()

    def _account_names(self, discovery):
        from offline_account_profiles import account_profiles
        config = self.archive.media_config if self.archive else self.settings.get('source', {})
        paths = [Path(config['keyFile'])] if config.get('keyFile') else []
        folder = self.directory / 'keys'
        if folder.is_dir() and not folder.is_symlink() and folder.resolve().parent == self.directory:
            from itertools import islice
            paths += [path for path in islice(folder.glob('*.json'), 16) if not path.is_symlink()]
        return account_profiles(discovery, self.client, key_files=list(dict.fromkeys(paths))[:16],
                                configured_source=config.get('sourceRoot', ''), configured_self_id=config.get('selfId', ''))

    def scan_accounts(self):
        """Fresh ownership evidence plus display-only local account names."""
        from offline_accounts import identify_accounts
        return self._account_names(identify_accounts(self.scan(), self.client))

    def automatic_setup(self, config=None, *, allow_process_read=False):
        """Explicit one-click setup; retain old settings format and source binding."""
        if self.settings.get('source') and self.settings.get('client', 'wechat') != self.client:
            return {'status': 'needs_source', 'message': '当前配置属于另一种客户端，请使用其独立启动入口和数据目录。'}
        saved = self.settings.get('source', {})
        supplied = {name: config[name] for name in CONFIG_FIELDS if name in (config or {})}
        source = supplied.get('sourceRoot') or saved.get('sourceRoot')
        if not source:
            discovered = self.scan()
            accounts = discovered['accounts']
            if len(accounts) != 1:
                return {'status': 'needs_source', 'accounts': accounts,
                        'message': '发现多个账号，请先从账号列表选定一个。' if accounts else
                                   '未发现受支持的微信数据目录，请登录本人微信后重试，或手动选择自定义目录。'}
            source = accounts[0]['sourceRoot']
        def normalized(value):
            path = Path(value).expanduser().resolve()
            if self.client == 'wecom':
                from wecom_snapshot import data_root
                return data_root(path)
            return path / 'db_storage' if (path / 'db_storage').is_dir() else path
        source = normalized(source)
        same_source = bool(saved.get('sourceRoot')) and normalized(saved['sourceRoot']) == source
        value = {**(saved if same_source else {}), **supplied, 'sourceRoot': str(source)}
        value.setdefault('includeMedia', True)
        value.setdefault('includeVoice', False)
        if not same_source and not supplied.get('selfId'):
            value['selfId'] = ''
        self._outside_source(value)
        # Reuse only explicit references and this application's own saved keys.
        # Never search other directories for private JSON files.
        attempts = [value]
        folder = self.directory / 'keys'
        if folder.is_dir() and not folder.is_symlink() and folder.resolve() == folder:
            candidates = sorted(folder.glob('*.json'), key=lambda path: path.name, reverse=True)[:16]
            for path in candidates:
                try:
                    if (path.is_file() and not path.is_symlink() and path.resolve().parent == folder
                            and path.stat().st_size <= 65536):
                        attempts.append({**value, 'keyFile': str(path), 'imageKeyFile': ''})
                except OSError:
                    continue
        for attempt in attempts:
            try:
                info = self.open_source(attempt)
                return {**info, 'setupMode': 'reused_or_plaintext',
                        'notice': '已自动加载并校验数据，无需选择密钥文件；后续复用本机设置。'}
            except (OSError, ValueError, DatabaseError):
                pass
        if allow_process_read is not True:
            return {'status': 'needs_source', 'config': value,
                    'message': '未找到可用的本机密钥。登录对应微信后，点击“一键自动配置”尝试恢复。'}
        if self.client == 'wecom':
            from wecom_key_recovery import recover_key_file
        else:
            from portable_key_recovery import recover_key_file
        try:
            result = recover_key_file(source, self.directory, allow_process_read=True,
                                      include_media=value['includeMedia'])
            value['keyFile'] = result['keyFile']
            if result['imageRecovery'] == 'verified_local_samples':
                value['imageKeyFile'] = ''
            info = self.open_source(value)
        except (OSError, ValueError, DatabaseError) as error:
            return {'status': 'needs_source', 'message': safe_issue(error), 'config': value}
        if self.client == 'wecom':
            return {**info, 'setupMode': 'recovered_live', 'imageRecovery': result['imageRecovery'],
                    'notice': '企微数据库密钥已自动恢复并通过副本校验；已保存独立配置。媒体按本机缓存摘要匹配，不需要个微图片密钥。'}
        return {**info, 'setupMode': 'recovered_live', 'imageRecovery': result['imageRecovery'],
                'notice': '数据库密钥已自动恢复并通过副本校验，已记住本机设置。' +
                          ('图片密钥也已验证。' if result['imageRecovery'] == 'verified_local_samples' else
                           '图片密钥未恢复，图片仍按可用、缩略图或缺失显示。')}

    def preview(self, chat, offset=None, kind=None, *, page_size=100, query=''):
        if self.archive is None:
            raise ArchiveError('请先加载数据。')
        self.archive.select_chat(chat_id=chat)
        self.archive._check()
        if chat not in self.views:
            suffix = hashlib.sha256(chat.encode()).hexdigest()[:8]
            output = self.directory / 'views' / (datetime.now().strftime('%Y%m%d-%H%M%S-%f') + '-' + suffix)
            self.archive.export(output, chat_id=chat, copy_media=True)
            self.views[chat] = ConversationView(output)
        result = self.views[chat].page(offset, kind, page_size=page_size, query=query)
        self._save(last_chat=chat)
        return result

    def export(self, chat, start=None, end=None, copy_media=True):
        if self.archive is None:
            raise ArchiveError('请先加载数据。')
        suffix = hashlib.sha256(chat.encode()).hexdigest()[:8]
        output = self.directory / 'exports' / (datetime.now().strftime('%Y%m%d-%H%M%S-%f') + '-' + suffix)
        result = self.archive.export(output, chat_id=chat, start=start, end=end, copy_media=copy_media)
        self._save(last_chat=chat)
        self.last_export = output
        return {'output': str(output), 'report': result,
                'mediaSummary': result['mediaSummary'], 'mediaSummaryText': result['mediaSummaryText'],
                'reporting': result['reporting'],
                'exportFiles': {kind: str(output / name) for kind, name in result['messageExports'].items()}}

    def parse_and_open(self, *, chat_id=None, chat_name=None, start=None, end=None, copy_media=True, page_size=100):
        if self.archive is None:
            raise ArchiveError('请先选择本机数据和匹配密钥。')
        chat = self.archive.select_chat(chat_id=chat_id, chat_name=chat_name)
        result = self.export(chat['id'], start=start, end=end, copy_media=copy_media)
        self.views[chat['id']] = ConversationView(result['output'])
        return {**result, 'chat': chat, 'view': self.preview(chat['id'], kind='business', page_size=page_size)}
