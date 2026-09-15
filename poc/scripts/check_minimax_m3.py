"""One synthetic M3 request; no WeChat access, key persistence, or retries."""
import argparse
import getpass
import json
import os
import time
import sys
from pathlib import Path
from urllib import error, request

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from wechat_agent_poc.local_env import load_minimax_env


class NoRedirect(request.HTTPRedirectHandler):
    def redirect_request(self, req, fp, code, msg, headers, newurl):
        return None


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--env-only', action='store_true', help='Do not prompt for a key')
    args = parser.parse_args()
    load_minimax_env()
    key = os.environ.get('MINIMAX_API_KEY', '').strip()
    if not key and not args.env_only:
        key = getpass.getpass('MiniMax API Key (hidden, not saved): ').strip()
    if not key:
        print('NOT_RUN: MINIMAX_API_KEY is absent.')
        return 2
    body = {
        'model': 'MiniMax-M3',
        'messages': [
            {'role': 'system', 'content': 'Answer briefly. Output only the final answer.'},
            {'role': 'user', 'content': 'What is 2 + 3? Reply with only the number.'},
        ],
        'thinking': {'type': 'disabled'},
        'reasoning_split': True,
        'max_completion_tokens': 128,
        'stream': False,
    }
    req = request.Request(
        'https://api.minimax.cn/v1/chat/completions',
        data=json.dumps(body).encode('utf-8'),
        headers={'Content-Type': 'application/json', 'Authorization': 'Bearer ' + key},
        method='POST',
    )
    started = time.monotonic()
    try:
        with request.build_opener(NoRedirect()).open(req, timeout=12) as response:
            raw = json.loads(response.read(1024 * 1024).decode('utf-8'))
        base = raw.get('base_resp') or {}
        if base.get('status_code', 0) != 0 or raw.get('error'):
            print('FAILED: API business error; check key, model access and balance in console.')
            return 2
        choice = raw['choices'][0]
        message = choice['message']
        valid = (
            raw.get('model') == 'MiniMax-M3'
            and choice.get('finish_reason') == 'stop'
            and not message.get('tool_calls')
            and message.get('content', '').strip() == '5'
        )
        # Never print the raw response, request, credentials, or reasoning.
        print(json.dumps({'status': 'PASS' if valid else 'FAILED_RESPONSE_VALIDATION',
                          'expected_answer_matched': valid,
                          'elapsed_seconds': round(time.monotonic() - started, 2),
                          'requests': 1, 'wechat_access': False}))
        return 0 if valid else 2
    except error.HTTPError as exc:
        print(f'FAILED: HTTP {exc.code}; no retry. Check console and endpoint.')
        return 2
    except (error.URLError, TimeoutError):
        print('FAILED: network/TLS/timeout; no retry. Response body is not logged.')
        return 2
    except (ValueError, KeyError, IndexError, TypeError, AttributeError):
        print('FAILED: unexpected response format; raw response is not logged.')
        return 2
    finally:
        key = None
        req.remove_header('Authorization')


if __name__ == '__main__':
    raise SystemExit(main())
