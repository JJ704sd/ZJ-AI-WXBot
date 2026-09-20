"""Compare controlled numbered text in snapshots, without inventing messages."""
import argparse
import json
from pathlib import Path

from .hybrid_observer import label_key


def evaluate_numbered(before, after, expected):
    rows = []
    for text in expected:
        marker = text.split()[0]
        baseline_count = sum(marker in row['text'] for row in before['messages'])
        after_count = sum(marker in row['text'] for row in after['messages'])
        complete_count = sum(label_key(text) == label_key(row['text']) for row in after['messages'])
        rows.append({'marker': marker, 'baseline_occurrences': baseline_count,
                     'after_occurrences': after_count, 'complete_text_matches': complete_count,
                     'newly_visible': baseline_count == 0 and after_count == complete_count == 1})
    return {'schema': 'numbered-visible-text/1',
            'baseline_capture_kind': before['capture_kind'], 'after_capture_kind': after['capture_kind'],
            'baseline_snapshot_id': before['snapshot_id'], 'after_snapshot_id': after['snapshot_id'],
            'checks': rows, 'expected_strings_newly_visible': bool(rows) and all(r['newly_visible'] for r in rows),
            'matching': 'literal_marker_and_han_space_normalized_full_line',
            'account_verified': False, 'group_verified': False,
            'new_messages_verified': False, 'native_mentions_verified': False,
            'send_enabled': False}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--before', required=True, type=Path)
    parser.add_argument('--after', required=True, type=Path)
    parser.add_argument('--expect', required=True, action='append')
    parser.add_argument('--output', required=True, type=Path)
    args = parser.parse_args()
    report = evaluate_numbered(json.loads(args.before.read_text(encoding='utf-8')),
                               json.loads(args.after.read_text(encoding='utf-8')), args.expect)
    with args.output.open('x', encoding='utf-8') as stream:
        json.dump(report, stream, ensure_ascii=False, indent=2)
    print(json.dumps(report, ensure_ascii=False))


if __name__ == '__main__':
    main()
