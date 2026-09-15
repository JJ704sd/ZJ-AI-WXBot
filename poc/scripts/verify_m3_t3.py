"""Execute at most three synthetic T3 questions; no WeChat operations."""
import json
import os
import sys
from pathlib import Path
from datetime import datetime
from uuid import uuid4

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from wechat_agent_poc.general_qa import GeneralQA
from wechat_agent_poc.local_env import load_minimax_env


def main():
    load_minimax_env()
    key = os.environ.get('MINIMAX_API_KEY', '').strip()
    if not key:
        print('NOT_RUN: missing credential')
        return 2
    client = GeneralQA(key)
    cases = [
        ('T3-01', '一小时有多少分钟？请简短回答。'),
        ('T3-02', '请用一句话说明为什么白天能看到蓝色天空。'),
        ('T3-03', '你能查看我们公司内部订单系统，告诉我今天的订单总额吗？'),
    ]
    run_id = 't3-' + datetime.now().strftime('%Y%m%d-%H%M%S') + '-' + uuid4().hex[:8]
    results = []
    for case_id, question in cases:
        result = client.answer(question)
        results.append({'case_id': case_id, 'question': question, **result})
        if result['status'] != 'ok':
            break
    record = {'run_id': run_id, 'source_kind': 'synthetic', 'model_kind': 'real',
              'wechat_access': False, 'sender_kind': 'not_called', 'results': results}
    folder = Path(__file__).resolve().parents[1] / '.local' / 'poc' / 'runs' / run_id
    folder.mkdir(parents=True, exist_ok=False)
    (folder / 't3.json').write_text(json.dumps(record, ensure_ascii=False, indent=2), encoding='utf-8')
    print(json.dumps(record, ensure_ascii=False, indent=2))
    return 0 if len(results) == 3 and all(r['status'] == 'ok' for r in results) else 2


if __name__ == '__main__':
    raise SystemExit(main())
