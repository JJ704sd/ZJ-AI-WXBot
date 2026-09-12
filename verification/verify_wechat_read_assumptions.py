"""Reproduce reader limitations with synthetic fixtures, without a WeChat client.

Usage: python verification/verify_wechat_read_assumptions.py --chat-lab PATH
The only input is a trusted local Chat-Lab source checkout. No real chat database,
keyring, client process, client binary, configuration, or model endpoint is used.
Output is JSON on stdout; zero exit means the recorded observations reproduced,
not that the reader meets bot requirements. Fixtures are disposable local files.
"""
from argparse import ArgumentParser
from contextlib import ExitStack
import hashlib
import json
from pathlib import Path
import socket
import sqlite3
import subprocess
import sys
import tempfile
from unittest.mock import patch

EXPECTED_COMMIT = '67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2'


def main():
    parser = ArgumentParser(description=__doc__)
    parser.add_argument('--chat-lab', type=Path, required=True)
    args = parser.parse_args()
    checkout = args.chat_lab.resolve(strict=True)
    if not (checkout / 'src/chatlog_assistant/sources/wechat_messages.py').is_file():
        parser.error('--chat-lab must point to a local Chat-Lab source checkout')
    try:
        actual_commit = subprocess.check_output(
            ['git', '-C', str(checkout), 'rev-parse', 'HEAD'], text=True, stderr=subprocess.PIPE
        ).strip()
        dirty = subprocess.run(
            ['git', '-C', str(checkout), 'diff', '--quiet', 'HEAD', '--', 'src/chatlog_assistant'],
            check=False, capture_output=True,
        ).returncode
    except (OSError, subprocess.CalledProcessError):
        parser.error('Unable to verify the local reference Git revision')
    if actual_commit != EXPECTED_COMMIT or dirty != 0:
        parser.error(f'Require clean source at {EXPECTED_COMMIT}; actual HEAD={actual_commit}, source_diff_status={dirty}')
    sys.path.insert(0, str(checkout / 'src'))

    from chatlog_assistant.sources import wechat_nt, windows_memory
    from chatlog_assistant.sources.wechat_messages import parse_wechat_messages
    from chatlog_assistant.sources.discovery import discover_sources
    from chatlog_assistant.sources.live import _wechat_targets
    from chatlog_assistant.sources.monitor import observe_once
    from chatlog_assistant.models import SubjectMatch
    from chatlog_assistant.storage import Storage

    def blocked(*_args, **_kwargs):
        raise AssertionError('This evidence script forbids external/client access')

    def database(table='Msg_demo'):
        conn = sqlite3.connect(':memory:')
        conn.execute(f'CREATE TABLE {table}(local_id INTEGER, create_time INTEGER, message_content TEXT, real_sender_id INTEGER, local_type INTEGER)')
        return conn

    def add(conn, table, msg_id, sender=9, body='synthetic text'):
        conn.execute(f'INSERT INTO {table} VALUES (?, 1800000000, ?, ?, 1)', (msg_id, body, sender))

    def parse(conn, cursor=None):
        return parse_wechat_messages(conn, source='wechat', account_hint='wxid_self', since_cursor=cursor)

    observations = []
    with ExitStack() as safety:
        safety.enter_context(patch.object(socket.socket, 'connect', blocked))
        safety.enter_context(patch.object(socket, 'create_connection', blocked))
        safety.enter_context(patch.object(wechat_nt, 'probe_wechat', blocked))
        safety.enter_context(patch.object(wechat_nt, '_open_readonly', blocked))
        safety.enter_context(patch.object(wechat_nt, 'list_processes', blocked))
        safety.enter_context(patch.object(windows_memory, 'read_process_memory', blocked))

        with database() as conn:
            add(conn, 'Msg_demo', 9)
            _, cursor = parse(conn)
            add(conn, 'Msg_demo', 10)
            second, _ = parse(conn, cursor)
            observations.append({'case': 'same_second_9_then_10', 'classification': 'observed_limitation', 'cursor': json.loads(cursor), 'new_rows': 1, 'returned_new_messages': len(second), 'reproduced': second == []})

        with database('Msg_z') as conn:
            add(conn, 'Msg_z', 1)
            _, cursor = parse(conn)
            conn.execute('CREATE TABLE Msg_a AS SELECT * FROM Msg_z WHERE 0')
            add(conn, 'Msg_a', 1)
            second, _ = parse(conn, cursor)
            observations.append({'case': 'same_second_smaller_table_arrives_late', 'classification': 'observed_limitation', 'cursor': json.loads(cursor), 'new_rows': 1, 'returned_new_messages': len(second), 'reproduced': second == []})

        # This is deliberately an arbitrary string fixture, not a claim about
        # the actual identifier or table layout of a WeCom external group.
        group = 'synthetic_group@openim'
        table = 'Msg_' + hashlib.md5(group.encode()).hexdigest()
        with database(table) as conn:
            conn.execute('CREATE TABLE name2id(user_name TEXT)')
            conn.execute('INSERT INTO name2id(rowid,user_name) VALUES (9, ?), (10, ?)', ('synthetic_member@openim', group))
            add(conn, table, 1)
            add(conn, table, 2, sender=2)
            messages, _ = parse(conn)
            observations.append({'case': 'openim_string_mapping_with_present_name2id', 'classification': 'synthetic_mapping_only', 'messages': [{'conversation_id': m.conversation_id, 'sender_display': m.sender_display, 'direction': m.direction} for m in messages], 'reproduced': [m.conversation_id for m in messages] == [group, group] and [m.direction for m in messages] == ['inbound', 'outbound']})

        with tempfile.TemporaryDirectory(prefix='chatlab-reader-fixture-') as directory:
            base = Path(directory)
            message_dir = base / 'xwechat_files' / 'wxid_demo_suffix' / 'db_storage' / 'message'
            message_dir.mkdir(parents=True)
            for name in ('message_0.db', 'message_1.db'):
                (message_dir / name).write_bytes(b'synthetic-salt!!?' + bytes(4080))
            sources = discover_sources(base)
            found = {s.database_path.name: _wechat_targets(s, base)[0] is not None for s in sources}
            observations.append({'case': 'discovery_vs_targets', 'classification': 'observed_limitation', 'targets': found, 'reproduced': found == {'message_0.db': True, 'message_1.db': False}})

            storage = Storage(base / 'events.db')
            observe_once(storage, sources)
            Path(str(message_dir / 'message_0.db') + '-wal').write_bytes(b'new synthetic WAL after discovery')
            events = observe_once(storage, sources)
            observations.append({'case': 'new_wal_after_discovery', 'classification': 'observed_limitation', 'new_wal_created': True, 'events_with_original_sources': len(events), 'reproduced': events == []})

            # Exercise the actual extract_wechat_messages source_key handoff.
            # Only its SQLCipher opener is replaced by an in-memory fixture.
            imported = []
            for account in ('account_a', 'account_b'):
                conn = database()
                add(conn, 'Msg_demo', 1, body=f'{account} synthetic')
                target = wechat_nt.EncryptedTarget('synthetic', base / 'never-opened.db', bytes(16))
                with patch.object(wechat_nt, '_open_readonly', return_value=conn):
                    messages, _ = wechat_nt.extract_wechat_messages(target, bytearray(32), source_key=f'wechat:{account}:message_0', account_hint=account)
                imported.extend(messages)
            storage = Storage(base / 'messages.db')
            storage.initialize()
            subject = SubjectMatch(raw_subject=None, bucket='other', confidence=1.0)
            for message in imported:
                storage.upsert_message(message, subject)
            with storage.connect() as conn:
                rows = conn.execute('SELECT content FROM messages').fetchall()
            observations.append({'case': 'source_key_account_namespace_dropped', 'classification': 'observed_limitation', 'supplied_distinct_sources': 2, 'actual_sources': [m.source for m in imported], 'stored_count': len(rows), 'last_stored_content': rows[0][0], 'reproduced': len(rows) == 1 and rows[0][0] == 'account_b synthetic'})

    result = {'reference_commit_evaluated': actual_commit, 'reference_source_clean': dirty == 0, 'all_recorded_observations_reproduced': all(item['reproduced'] for item in observations), 'reader_feasibility_pass': False, 'real_client_tested': False, 'sqlcipher_or_wal_decryption_tested': False, 'observations': observations}
    print(json.dumps(result, ensure_ascii=False, indent=2))
    return 0 if result['all_recorded_observations_reproduced'] else 1


if __name__ == '__main__':
    raise SystemExit(main())
