"""Match media only inside the selected WeCom account, with content checks."""
from collections import defaultdict
import hashlib
import itertools
import mimetypes
import os
from pathlib import Path
import re

from wecom_content import leaves

LIMIT = 100 * 1024 * 1024


class WeComMedia:
    def __init__(self, config):
        source = Path(config['sourceRoot']).resolve()
        self.account = source.parent if source.name == 'Data' else source
        self.files, self.sizes, self.names = [], defaultdict(list), defaultdict(list)
        self.recovered = 0
        self.indexed = False
        self.diagnostics = defaultdict(int)
        self.hashes = None

    def begin_export(self):
        """Newly opened/downloaded client files are visible on every target export."""
        self.files, self.sizes, self.names = [], defaultdict(list), defaultdict(list)
        self.indexed = False
        self.hashes = None
        self.diagnostics.clear()

    def _fallback(self, media):
        """Find exact bytes despite renamed files or stale size hints; bounded."""
        digests = [v.casefold() for v in (media.get('md5'), media.get('thumbnailMd5'))
                   if isinstance(v, str) and re.fullmatch('[a-fA-F0-9]{32}', v)]
        if not digests:
            return
        if self.hashes is None:
            self.hashes = defaultdict(list)
            remaining = 512 * 1024 * 1024
            for path in self.files:
                if not path.is_relative_to(self.account / 'Cache'):
                    continue
                try:
                    stamp = path.stat()
                    if not 0 < stamp.st_size <= min(LIMIT, remaining):
                        self.diagnostics['digestBudgetLimited'] = 1
                        continue
                    remaining -= stamp.st_size
                    digest = hashlib.md5()
                    with path.open('rb') as stream:
                        unread = stamp.st_size
                        while unread:
                            chunk = stream.read(min(1024 * 1024, unread))
                            if not chunk:
                                break
                            digest.update(chunk)
                            unread -= len(chunk)
                    after = path.stat()
                    if not unread and (after.st_size, after.st_mtime_ns, after.st_ino) == (stamp.st_size, stamp.st_mtime_ns, stamp.st_ino):
                        self.hashes[digest.hexdigest()].append(path)
                except OSError:
                    self.diagnostics['cacheReadErrors'] += 1
        for digest in digests:
            yield from self.hashes.get(digest, [])

    def _index(self):
        if self.indexed:
            return
        self.indexed = True
        for name in ('Cache', 'Emotion'):
            folder = self.account / name
            if not folder.is_dir() or folder.is_symlink():
                continue
            for parent, dirs, files in os.walk(folder, followlinks=False):
                dirs[:] = [v for v in dirs if not (Path(parent) / v).is_symlink() and (Path(parent) / v).resolve().is_relative_to(self.account)]
                for name in files:
                    path = Path(parent) / name
                    if path.is_symlink() or not path.resolve().is_relative_to(self.account):
                        continue
                    try:
                        size = path.stat().st_size
                    except OSError:
                        continue
                    if 0 < size <= LIMIT:
                        self.files.append(path)
                        self.sizes[size].append(path)
                        self.names[path.name.casefold()].append(path)
                    if len(self.files) >= 50000:
                        self.diagnostics['fileIndexLimited'] = 1
                        return

    def report(self, before=0):
        return {'scope': 'selected_wecom_account_cache', 'indexedFiles': len(self.files),
                'recoveredReferences': self.recovered - before, 'networkFetched': False,
                'refreshedForExport': True, 'diagnostics': dict(self.diagnostics)}

    def attach(self, node, destination, local_extra=b''):
        media, kind = node.get('media', {}), node['kind']
        unavailable = {'status': 'unavailable', 'reasonCode': 'local_cache_not_matched',
                       'reason': '所选企微账号中未找到可验证的本地图片或附件；这不代表客户端从未下载。打开原消息的图片或下载附件后，重新解析此群即可检查新缓存。'}
        if kind == 'emoji':
            return {**unavailable, 'reason': '表情为可选内容，未匹配时不影响业务消息保留。'}
        self._index()
        candidates, linked = [], set()
        for value in leaves(local_extra):
            # Old absolute paths are remapped only at known account subtrees.
            for subtree in ('Cache', 'Emotion'):
                marker = '\\' + subtree + '\\'
                if marker.casefold() in value.casefold():
                    tail = re.split(re.escape(marker), value, maxsplit=1, flags=re.I)[1]
                    candidate = self.account / subtree / Path(tail.replace('\\', '/'))
                    if candidate.resolve().is_relative_to(self.account):
                        candidates.append(candidate)
                        linked.add(candidate)
        filename = media.get('filename', '')
        for name in (filename, filename + '.temp'):
            candidates.extend(self.names.get(name.casefold(), []))
        candidates.extend(self.sizes.get(media.get('size', 0), []))
        candidates.extend(self.sizes.get(media.get('thumbnailSize', 0), []))
        if len(candidates) > 1000:
            candidates = candidates[:1000]
        preview = None
        linked_existing, linked_invalid = False, False
        seen = set()
        for path in itertools.chain(candidates, self._fallback(media)):
            if path in seen:
                continue
            seen.add(path)
            try:
                if not path.is_file() or path.is_symlink() or not path.resolve().is_relative_to(self.account):
                    continue
                stamp = path.stat()
                linked_existing = linked_existing or path in linked
                if stamp.st_size > LIMIT:
                    continue
                with path.open('rb') as stream:
                    data = stream.read(LIMIT + 1)
                if path.stat().st_mtime_ns != stamp.st_mtime_ns or len(data) != stamp.st_size:
                    continue
                digest = hashlib.md5(data).hexdigest()
                original = bool(media.get('md5')) and digest.casefold() == media['md5'].casefold()
                thumbnail = bool(media.get('thumbnailMd5')) and digest.casefold() == media['thumbnailMd5'].casefold()
                # An exact path in THIS message's local metadata can identify a
                # client-converted preview. A name or dimensions alone cannot.
                converted = kind == 'image' and path in linked and not original and not thumbnail
                if not original and not thumbnail and not converted:
                    continue
                mime, extension = mimetypes.guess_type(filename or path.name)[0], Path(filename).suffix.lower()
                if kind == 'image' or thumbnail:
                    from PIL import Image
                    import io
                    with Image.open(io.BytesIO(data)) as image:
                        width, height = image.size
                        image.verify()
                        fmt = (image.format or '').lower()
                    extension = '.' + ('jpg' if fmt == 'jpeg' else fmt)
                    mime = 'image/' + ('jpeg' if fmt == 'jpeg' else fmt)
                    if converted:
                        expected_w, expected_h = media.get('width', 0), media.get('height', 0)
                        if (not expected_w or not expected_h or width > expected_w or height > expected_h
                                or abs(width * expected_h / (height * expected_w) - 1) > .02):
                            linked_invalid = True
                            continue
                sha = hashlib.sha256(data).hexdigest()
                extension = extension if re.fullmatch(r'\.[a-zA-Z0-9]{1,10}', extension) else '.bin'
                relative = 'assets/' + sha + extension
                assets = destination / 'assets'
                assets.mkdir(exist_ok=True)
                target = destination / relative
                if not target.exists():
                    with target.open('xb') as stream:
                        stream.write(data)
                asset = {'status': 'ready', 'path': relative, 'filename': filename or path.name,
                         'size': len(data), 'digest': sha, 'mime': mime or 'application/octet-stream',
                         'previewOnly': not original, 'reason': '' if original else '仅找到经摘要校验的缩略图或视频封面。',
                         'matchBasis': 'content_md5', 'sourceRelativePath': path.relative_to(self.account).as_posix()}
                if converted:
                    asset.update(previewVariant='local_converted', matchBasis='原消息缓存路径+图片格式与尺寸校验',
                        reason='本地预览：企微缓存已转码或缩放，原图摘要未匹配；可查看，但不计为原图。',
                        width=width, height=height)
                if original:
                    self.recovered += 1
                    return asset
                if not preview or (converted and preview.get('previewVariant') != 'local_converted'):
                    preview = asset
            except (OSError, ValueError, ImportError):
                continue
        if preview:
            self.recovered += 1
            self.diagnostics['localConverted' if preview.get('previewVariant') == 'local_converted' else 'thumbnail'] += 1
            return preview
        if linked:
            code = 'linked_cache_not_validated' if linked_existing or linked_invalid else 'linked_cache_absent'
            unavailable.update(reasonCode=code, reason=(
                '原消息指向的缓存存在，但格式、尺寸或完整性未通过校验，未作为可用图片。请在企微打开原图后重新解析此群。'
                if code == 'linked_cache_not_validated' else
                '原消息指向的缓存文件当前不可访问或已被清理，其他候选也未匹配。请在企微打开原图后重新解析此群。'))
        self.diagnostics[unavailable['reasonCode']] += 1
        return unavailable
