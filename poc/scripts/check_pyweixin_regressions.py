"""Synthetic regression checks on a source file. Never imports pyweixin or sends."""
import argparse
import ast
import json
import re
from pathlib import Path


def check(path):
    tree = ast.parse(Path(path).read_text(encoding='utf-8-sig'))
    monitor = next(n for n in tree.body if isinstance(n, ast.ClassDef) and n.name == 'Monitor')
    listen = next(n for n in monitor.body if isinstance(n, ast.FunctionDef) and n.name == 'listen_on_chat')
    extract = next(n for n in listen.body if isinstance(n, ast.FunctionDef) and n.name == 'extract_info')
    scope = dict(re=re, is_group=True, groupMembers=['Alice'], friend='Synthetic', myName='Self')
    exec(compile(ast.Module(body=[extract], type_ignores=[]), '<pure-parser>', 'exec'), scope)
    cases = [(['Alice'], ['Bob hello'], (['Bob hello'], [None])),
             (['Alice'], ['Alice hello', 'Bob hello'], (['hello', 'Bob hello'], ['Alice', None])),
             (['A.B'], ['AxB hello'], (['AxB hello'], [None])),
             (['A.B'], ['A.B hello'], (['hello'], ['A.B'])),
             (['Alice', 'Alice'], ['Alice hello'], (['Alice hello'], [None])),
             (['A', 'A B'], ['A B hello'], (['A B hello'], [None]))]
    results = []
    for members, texts, expected in cases:
        scope['groupMembers'] = members
        try:
            passed = scope['extract_info'](texts) == expected
            results.append({'case': len(results)+1, 'passed': passed})
        except Exception as exc:
            results.append({'case': len(results)+1, 'passed': False, 'error_type': type(exc).__name__})
    messages = next(n for n in tree.body if isinstance(n, ast.ClassDef) and n.name == 'Messages')
    send = next(n for n in messages.body if isinstance(n, ast.FunctionDef) and n.name == 'send_messages_to_friend')
    loop = next(n for n in send.body if isinstance(n, ast.For) and isinstance(n.target, ast.Name) and n.target.id == 'message')
    branch = loop.body[0]
    for length, expected in [(1999, (True, False)), (2000, (True, False)), (2001, (False, True))]:
        env = {'message': 'x'*length}
        actual = tuple(eval(compile(ast.Expression(test), '<condition>', 'eval'), env)
                       for test in (branch.test, branch.orelse[0].test))
        results.append({'case': 'length_'+str(length), 'passed': actual == expected})
    return results


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('source')
    parser.add_argument('--output', required=True)
    args = parser.parse_args()
    results = check(args.source)
    report = {'scope': 'synthetic AST-only; no UI', 'passed': all(r['passed'] for r in results), 'results': results}
    Path(args.output).write_text(json.dumps(report, indent=2)+'\n', encoding='utf-8')
    print(json.dumps(report))
    raise SystemExit(0 if report['passed'] else 1)
