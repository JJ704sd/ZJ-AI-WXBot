"""Publish the exact locally parsed batch after an explicit human review."""
from datetime import datetime
import json
from pathlib import Path
import shutil
import tempfile

from database_snapshot import _hash_file
from offline_chat import ArchiveError, BEIJING, write_json
from offline_reporting import completion_report, REPORT_FILE

REVIEW_CHECKS = {
    'accountGroup': '已核对当前账号、群名称与群 ID',
    'rangeCount': '已核对日期范围、记录条数与本地数据范围',
    'content': '已抽查正文、发送人、引用、转发及附件解析状态',
    'gaps': '已检查缺失媒体、未知类型及解析限制，接受已列明的缺口',
}


def inventory(root):
    root = Path(root)
    result = []
    for path in sorted(root.rglob('*')):
        if path.is_symlink() or path.is_junction():
            raise ArchiveError('解析结果包含链接，请重新解析。')
        if path.is_file():
            result.append({'path': path.relative_to(root).as_posix(),
                           'bytes': path.stat().st_size, 'sha256': _hash_file(path)})
    return result


def publish_review(pending, destination, checks, note=''):
    if not isinstance(checks, dict) or set(checks) != set(REVIEW_CHECKS) or any(value is not True for value in checks.values()):
        raise ArchiveError('请由人工完成全部复核检查后再确认导出。')
    if not isinstance(note, str) or len(note) > 4000:
        raise ArchiveError('复核备注须为不超过4000字的文本。')
    root, destination = pending['root'], Path(destination)
    if inventory(root) != pending['files']:
        raise ArchiveError('待复核文件已变化，请重新解析并复核。')
    destination.parent.mkdir(parents=True, exist_ok=True)
    if destination.exists():
        raise ArchiveError('导出目录已存在，请使用新的目录。')
    stage = Path(tempfile.mkdtemp(prefix='.review-export-', dir=destination.parent))
    try:
        shutil.copytree(root, stage, dirs_exist_ok=True)
        if inventory(stage) != pending['files']:
            raise ArchiveError('复制期间解析结果发生变化，请重新解析并复核。')
        report = json.loads((stage / 'manifest.json').read_text(encoding='utf8'))
        review = {**pending['summary'], 'status': 'confirmed',
                  'confirmedAt': datetime.now(BEIJING).isoformat(timespec='seconds'),
                  'confirmationBasis': 'explicit_review_checklist',
                  'checks': dict(checks), 'note': note,
                  'reviewedArtifacts': pending['files']}
        write_json(stage / 'review.json', review)
        report['humanReview'] = {'status': 'confirmed', 'reviewId': review['reviewId'], 'file': 'review.json'}
        report['reporting'] = completion_report(destination, report)
        (stage / REPORT_FILE).write_text(report['reporting']['replyMarkdown'], encoding='utf8')
        report['artifacts'] = [item for item in inventory(stage) if item['path'] != 'manifest.json']
        (stage / 'manifest.json').write_text(json.dumps(report, ensure_ascii=False, indent=2), encoding='utf8')
        if destination.exists():
            raise ArchiveError('导出目录在确认期间已创建，未覆盖。')
        stage.rename(destination)
        return report
    finally:
        if stage.exists() and stage.resolve().parent == destination.parent.resolve() and stage.name.startswith('.review-export-'):
            shutil.rmtree(stage)
