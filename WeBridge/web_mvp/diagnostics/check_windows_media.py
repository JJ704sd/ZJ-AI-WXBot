"""Explicit local acceptance. Counts on stdout; identifiers only in private report."""
import argparse
import collections
import io
import json
from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from database_adapter import DatabaseAdapter
from windows_media import resolve_local, descriptor


def media_rows(messages):
    for message in messages:
        if message.get('media'):
            yield message, ''
        def nested(record):
            for item in record.get('items', []):
                if item.get('media'):
                    yield message, item['media']['part']
                if item.get('record'):
                    yield from nested(item['record'])
        if message.get('record'):
            yield from nested(message['record'])


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--config', type=Path, required=True, help='Saved database-config.json')
    parser.add_argument('--snapshot', type=Path, help='Optional retained immutable snapshot')
    parser.add_argument('--image-key-file', type=Path)
    parser.add_argument('--limit', type=int, default=200, choices=range(1, 2001), metavar='1..2000')
    parser.add_argument('--report', type=Path, required=True, help='Private local JSON report (never commit)')
    args = parser.parse_args()
    saved = json.loads(args.config.read_text(encoding='utf-8'))
    config = saved['config']
    if args.image_key_file:
        config['imageKeyFile'] = str(args.image_key_file.resolve())
    snapshot = args.snapshot or Path(saved['snapshotRoot'])
    adapter = DatabaseAdapter(snapshot, self_id=config['selfId'])
    account = adapter.auth()['sourceId']
    counts, reasons, examples = collections.Counter(), collections.Counter(), {}
    for group in adapter.call('groups', account=account)['groups']:
        rows = adapter._messages(adapter._state, group['id'], include_raw=True, limit=args.limit)['messages']
        for row, part in media_rows(rows):
            try:
                kind, _, _ = descriptor(row, part)
                result, data = resolve_local(snapshot, config, group['id'], row, part)
                counts[kind + ':' + result['status'] + (':preview' if result.get('previewOnly') else '')] += 1
                if data is not None:
                    if result['mime'].startswith('image/'):
                        try:
                            from PIL import Image
                            with Image.open(io.BytesIO(data)) as image:
                                image.verify()
                            counts['image_decoder_verified'] += 1
                        except ImportError:
                            counts['image_decoder_unavailable'] += 1
                    key = kind + (':preview' if result['previewOnly'] else '')
                    examples.setdefault(key, {'group': group['id'], 'localId': row['localId'], 'dbName': row['dbName'],
                                             'part': part, 'size': len(data), 'mime': result['mime'], 'previewOnly': result['previewOnly']})
                else:
                    reasons[result.get('reason', '')] += 1
            except Exception as exc:
                counts['failure:' + type(exc).__name__] += 1
    report = {'limitPerConversation': args.limit, 'counts': dict(counts), 'reasons': dict(reasons)}
    args.report.parent.mkdir(mode=0o700, parents=True, exist_ok=True)
    args.report.write_text(json.dumps({**report, 'examples': examples}, ensure_ascii=False, indent=2), encoding='utf-8')
    print(json.dumps(report, ensure_ascii=False))
    return int(any(key.startswith('failure:') for key in counts))


if __name__ == '__main__':
    raise SystemExit(main())
