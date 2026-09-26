#!/usr/bin/env python3
"""Read-only, target-scoped SQLCipher probe; execute inside wechat-lab-linux.

Secrets stay in memory and are passed to SQLCipher on stdin, never argv/logs.
The normal read mode includes WAL; immutable mode is diagnostic only.
"""
import hashlib
import json
from pathlib import Path
import re
import subprocess
import sys
import tempfile

CHAT_ID = "48437025209@chatroom"
TABLE = "Msg_" + hashlib.md5(CHAT_ID.encode()).hexdigest()


def query(path, key, sql, *, raw_key=True, immutable=False):
    # SQLite "read-only" may rebuild/write a -shm index. Only immutable queries
    # may touch a live WeChat DB; WAL diagnostics must use isolated file copies.
    if str(path).startswith('/home/wechat/') and not immutable:
        raise ValueError('Live WeChat WAL access is disabled; query a temporary copy')
    if not re.fullmatch(r"[a-fA-F0-9]+", key):
        raise ValueError("Unexpected key encoding")
    key_sql = f'PRAGMA key = "x\'{key}\'";' if raw_key else f"PRAGMA key = '{key}';"
    uri = "file:" + str(path) + ("?immutable=1" if immutable else "?mode=ro")
    program = ".bail on\n.output /dev/null\n" + key_sql + "\nPRAGMA cipher_compatibility=4;\nPRAGMA query_only=ON;\n.timeout 1500\n.output\n.mode json\n" + sql + "\n"
    result = subprocess.run(["sqlcipher", "-readonly", uri], input=program, text=True, capture_output=True, timeout=12)
    if result.returncode:
        # Never forward the SQL input (which contains keys) in an error.
        raise RuntimeError(result.stderr.strip())
    return json.loads(result.stdout) if result.stdout.strip() else []


def context():
    token = Path('/data/auth-token').read_text().strip()
    account = query('/data/agent.db', token, "SELECT logged_in_user FROM sessions WHERE name='default';", raw_key=False)[0]['logged_in_user']
    if not re.fullmatch(r'[A-Za-z0-9_-]+', account):
        raise ValueError('Unexpected account directory')
    keys = query('/data/agent.db', token, f"SELECT db_name, hex_key FROM wechat_keys WHERE session_id=(SELECT id FROM sessions WHERE name='default') AND account_dir='{account}';", raw_key=False)
    roots = [Path('/home/wechat/Documents/xwechat_files')/account/'db_storage', Path('/home/wechat/xwechat_files')/account/'db_storage']
    root = next(p for p in roots if p.is_dir())
    return root, {r['db_name']: r['hex_key'] for r in keys}


def main():
    root, keys = context()
    print(json.dumps({'stored_key_names': sorted(keys)}, ensure_ascii=False))
    for path in sorted(root.glob('message/message_*.db')):
        if 'fts' in path.name or 'resource' in path.name:
            continue
        key = keys.get(path.name)
        result = {'db': path.name, 'wal_bytes': Path(str(path)+'-wal').stat().st_size if Path(str(path)+'-wal').exists() else 0, 'has_key': key is not None}
        if key:
            with tempfile.TemporaryDirectory(prefix='wechat-lab-read-mode-') as folder:
                copy = Path(folder) / path.name
                copy.write_bytes(path.read_bytes())
                wal = Path(str(path) + '-wal')
                if wal.exists():
                    Path(str(copy) + '-wal').write_bytes(wal.read_bytes())
                result['comparison_uses_temporary_copy'] = True
                for mode in (False, True):
                    found = query(copy, key, f"SELECT name FROM sqlite_master WHERE name='{TABLE}';", immutable=mode)
                    result['immutable' if mode else 'read_only'] = {'table_exists': bool(found)}
                    if found:
                        result['immutable' if mode else 'read_only']['count'] = query(copy,key,f'SELECT count(*) AS n FROM "{TABLE}";',immutable=mode)[0]['n']
                if result['read_only']['table_exists']:
                    result['columns'] = query(copy,key,f'PRAGMA table_info("{TABLE}");')
                    result['target_rows'] = query(copy,key,f'SELECT local_id, server_id, local_type, create_time, hex(message_content) AS content_hex, hex(source) AS source_hex, WCDB_CT_message_content, WCDB_CT_source FROM "{TABLE}" ORDER BY local_id DESC LIMIT 10;')
        print(json.dumps(result, ensure_ascii=False))


if __name__ == '__main__':
    main()
