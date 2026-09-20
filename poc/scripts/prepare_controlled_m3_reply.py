"""Prepare one short M3 reply to an observed numbered test line. Does not send."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import secrets
import sys
import time
from urllib import request, error

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from wechat_agent_poc.local_env import load_minimax_env
from wechat_agent_poc.hybrid_observer import label_key
from wechat_agent_poc.m3_ocr import NoRedirect, ENDPOINT


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--source-snapshot', required=True, type=Path)
    parser.add_argument('--trigger', required=True)
    parser.add_argument('--output', required=True, type=Path)
    args = parser.parse_args()
    source = json.loads(args.source_snapshot.read_text(encoding='utf-8'))
    matches = [r['text'] for r in source['messages'] if label_key(r['text']) == label_key(args.trigger)]
    if source['capture_kind'] != 'live_window' or len(matches) != 1 or not args.trigger.startswith('UIA-READ-'):
        raise ValueError('controlled_trigger_not_observed_once')
    prefix = 'UIA-ACK-' + secrets.token_hex(4).upper()
    load_minimax_env()
    key = os.environ.get('MINIMAX_API_KEY', '').strip()
    if not key:
        raise ValueError('key_absent')
    with args.output.open('x', encoding='utf-8') as stream:
        report = {'status': 'ERROR', 'reply_prefix': prefix, 'requests': 1,
                  'source_sha256': hashlib.sha256(args.source_snapshot.read_bytes()).hexdigest(),
                  'source_snapshot_id': source['snapshot_id'], 'trigger': matches[0],
                  'send_attempts': 0}
        body = {'model': 'MiniMax-M3', 'thinking': {'type': 'disabled'}, 'reasoning_split': True,
                'max_completion_tokens': 128, 'stream': False,
                'messages': [{'role': 'system', 'content':
                    f'这是单次受控收发测试。用一句简短中文确认收到下面的测试消息。必须以 {prefix} 和一个空格开头。只输出这句回复，不要换行、@任何人或承诺自动回复已经开启。'},
                    {'role': 'user', 'content': matches[0]}]}
        req = request.Request(ENDPOINT, data=json.dumps(body).encode('utf-8'),
                              headers={'Content-Type': 'application/json', 'Authorization': 'Bearer ' + key}, method='POST')
        start = time.monotonic()
        try:
            with request.build_opener(NoRedirect()).open(req, timeout=20) as response:
                raw = json.loads(response.read(1024 * 1024))
            choice = raw['choices'][0]
            text = choice['message']['content'].strip()
            if (raw.get('model') != 'MiniMax-M3' or choice.get('finish_reason') != 'stop'
                    or choice['message'].get('tool_calls') or raw.get('error')
                    or (raw.get('base_resp') or {}).get('status_code', 0)
                    or not text.startswith(prefix + ' ') or not 1 <= len(text) <= 120
                    or '@' in text or any(ord(c) < 32 or ord(c) == 127 for c in text)):
                raise ValueError('invalid_reply')
            report.update(status='PREPARED', text=text,
                          usage={k: v for k, v in (raw.get('usage') or {}).items()
                                 if k in ('prompt_tokens', 'completion_tokens', 'total_tokens') and type(v) is int})
        except (error.URLError, TimeoutError, ValueError, KeyError, IndexError, TypeError):
            report['reason'] = 'request_or_reply_failed_no_retry'
        finally:
            report['elapsed_seconds'] = round(time.monotonic() - start, 3)
            req.remove_header('Authorization')
            json.dump(report, stream, ensure_ascii=False, indent=2)
    print(json.dumps(report, ensure_ascii=False))
    return 0 if report['status'] == 'PREPARED' else 2


if __name__ == '__main__':
    raise SystemExit(main())
