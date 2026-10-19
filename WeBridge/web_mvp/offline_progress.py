"""Versioned restart checkpoints, constrained to this client's managed caches."""
import json
import hashlib
import os
from pathlib import Path
import tempfile
import threading
from datetime import datetime

from offline_chat import ArchiveError, LocalArchive
from offline_accounts import same_account_source
from offline_review import inventory, validated_approval

MAX_STATE_BYTES = 16 * 1024 * 1024


class ReviewProgress:
    def __init__(self, directory, client):
        self.directory, self.client = Path(directory).resolve(), client
        self.path = self.directory / 'reviews' / 'session-v1.json'
        self._snapshot, self._files = None, None
        self._lock = threading.RLock()

    def _managed(self, relative, area):
        if not isinstance(relative, str) or not relative:
            raise ValueError('invalid_progress_path')
        original = self.directory / relative
        if any(path.is_symlink() or path.is_junction() for path in (original, *original.parents)):
            raise ValueError('redirected_progress_path')
        path = original.resolve()
        base = self.directory / area
        if not path.is_relative_to(base) or path == base:
            raise ValueError('outside_progress_cache')
        return path

    def clear(self):
        with self._lock:
            if os.path.lexists(self.path):
                try:
                    self._managed('reviews/session-v1.json', 'reviews').unlink()
                except (OSError, ValueError):
                    raise ArchiveError('无法清除旧复核进度，请检查工具缓存权限。') from None

    def save(self, archive, reviews, ui):
        with self._lock:
            if not reviews:
                self.clear()
                return
            temporary = None
            try:
                snapshot = self._managed(archive.root.relative_to(self.directory).as_posix(), 'snapshots')
                if snapshot != self._snapshot:
                    self._files, self._snapshot = inventory(snapshot), snapshot
                entries = []
                for pending in reviews.values():
                    relative = pending['root'].relative_to(self.directory).as_posix()
                    self._managed(relative, 'reviews')
                    entry = {'root': relative, 'summary': pending['summary'], 'files': pending['files']}
                    if pending.get('approval'):
                        entry['approval'] = pending['approval']
                    if pending.get('exportTarget'):
                        entry['exportTarget'] = pending['exportTarget']
                    entries.append(entry)
                value = {'version': 1, 'client': self.client, 'sourceRoot': archive.media_config['sourceRoot'],
                         'selfId': archive.state['self_id'], 'snapshot': snapshot.relative_to(self.directory).as_posix(),
                         'snapshotFiles': self._files, 'reviews': entries, 'ui': ui}
                encoded = json.dumps(value, ensure_ascii=False).encode('utf8')
                if len(encoded) > MAX_STATE_BYTES:
                    raise ValueError('progress_too_large')
                self._managed('reviews/session-v1.json', 'reviews')
                self.path.parent.mkdir(parents=True, exist_ok=True)
                fd, temporary = tempfile.mkstemp(prefix='.session-', dir=self.path.parent)
                with os.fdopen(fd, 'wb') as stream:
                    stream.write(encoded)
                    stream.flush()
                    os.fsync(stream.fileno())
                os.replace(temporary, self.path)
            except (OSError, ValueError):
                raise ArchiveError('复核进度未保存，尚未完成本次确认；请检查工具缓存空间或权限后重试。') from None
            finally:
                if temporary:
                    Path(temporary).unlink(missing_ok=True)

    def restore(self, config):
        if not self.path.exists():
            return None
        try:
            path = self._managed('reviews/session-v1.json', 'reviews')
            if path.stat().st_size > MAX_STATE_BYTES:
                raise ValueError('progress_too_large')
            value = json.loads(path.read_text(encoding='utf8'))
            if (not isinstance(value, dict) or type(value.get('version')) is not int or value['version'] != 1 or value.get('client') != self.client or
                    not same_account_source(value.get('sourceRoot'), config.get('sourceRoot'), self.client)):
                raise ValueError('progress_source_changed')
            snapshot = self._managed(value['snapshot'], 'snapshots')
            if inventory(snapshot) != value['snapshotFiles']:
                raise ValueError('progress_snapshot_changed')
            metadata = json.loads((snapshot / 'manifest.json').read_text(encoding='utf8'))
            if not same_account_source(metadata.get('sourceRoot'), config['sourceRoot'], self.client):
                raise ValueError('progress_snapshot_source_changed')
            factory = LocalArchive
            if self.client == 'wecom':
                from wecom_archive import WeComArchive
                factory = WeComArchive
            archive = factory(snapshot, config.get('selfId', ''), config)
            if archive.state['self_id'] != value['selfId']:
                raise ValueError('progress_identity_changed')
            snapshot_time = archive.adapter.get_source_info()['createdAt']
            known_chats = {group['id'] for group in archive.groups()['conversations'] if group['conversationKind'] == 'group'}
            source_fingerprint = hashlib.sha256(str(Path(value['sourceRoot']).resolve()).encode()).hexdigest()
            entries = value['reviews']
            if not isinstance(entries, list) or len(entries) > 1000:
                raise ValueError('invalid_progress_entries')
            restored, rejected, exported = {}, 0, 0
            for entry in entries:
                try:
                    summary = entry['summary']
                    root = self._managed(entry['root'], 'reviews')
                    if (root.name != summary['reviewId'] or summary['client'] != self.client or
                            summary['selfId'] != archive.state['self_id'] or
                            summary['snapshotTime'] != snapshot_time or summary['sourceFingerprint'] != source_fingerprint or
                            summary['chat']['id'] not in known_chats or
                            inventory(root) != entry['files']):
                        raise ValueError('progress_preview_changed')
                    report = json.loads((root / 'manifest.json').read_text(encoding='utf8'))
                    if (report['chat'] != summary['chat'] or report['exportedRows'] != summary['exportedRows'] or
                            any(report.get(key) != summary.get(key) for key in ('startDate','endDate','copyMediaRequested')) or
                            not same_account_source(report['sourceRoot'], snapshot, self.client)):
                        raise ValueError('progress_preview_identity_changed')
                    if entry.get('exportTarget') and self._managed(entry['exportTarget'], 'exports').exists():
                        # A published target is never silently exported again after a crash.
                        exported += 1
                        continue
                    pending = {'archive': archive, 'root': root, 'summary': summary, 'files': entry['files']}
                    if entry.get('approval'):
                        pending['approval'] = entry['approval']
                        try:
                            approval = pending['approval']
                            if (not isinstance(approval, dict) or
                                    any(approval.get(key) != item for key, item in summary.items()) or
                                    approval.get('confirmationBasis') not in ('explicit_review_checklist','explicit_batch_review_checklist') or
                                    not isinstance(approval.get('note'), str) or len(approval['note']) > 4000 or
                                    datetime.fromisoformat(approval['confirmedAt']).tzinfo is None):
                                raise ArchiveError('invalid_saved_approval')
                            validated_approval(pending)
                        except (ValueError, KeyError, TypeError):
                            pending.pop('approval', None)
                            rejected += 1
                    chat = summary['chat']['id']
                    if chat in restored:
                        raise ValueError('duplicate_progress_group')
                    restored[chat] = pending
                except (OSError, ValueError, KeyError, TypeError):
                    rejected += 1
            if not restored:
                if rejected:
                    raise ValueError('no_valid_progress')
                return None
            self._snapshot, self._files = snapshot, value['snapshotFiles']
            ui = value.get('ui', {})
            ui = ui if isinstance(ui, dict) else {}
            selected = ui.get('selected', [])
            ui = {'selected': [chat for chat in selected if isinstance(chat, str)] if isinstance(selected, list) else [],
                  'active': ui.get('active') if isinstance(ui.get('active'), str) else None}
            return {'archive': archive, 'reviews': restored, 'ui': ui,
                    'rejected': rejected, 'exported': exported}
        except (OSError, ValueError, KeyError, TypeError):
            raise ArchiveError('上次复核进度未通过来源或文件校验；已保留缓存，请重新解析。') from None
