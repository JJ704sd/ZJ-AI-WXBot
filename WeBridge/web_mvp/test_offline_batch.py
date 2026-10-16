"""Caller-visible headless workflow, using invented local data only."""
import json
from contextlib import closing
import os
import sqlite3
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest

from test_database_adapter import create_metadata, create_shard, GROUP, SELF


class BatchWorkflowTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix='offline-batch-test-')
        self.addCleanup(self.temp.cleanup)
        self.base = Path(self.temp.name).resolve()
        self.source = self.base / '数据 空格/db_storage'
        self.source.mkdir(parents=True)
        create_metadata(self.source)
        create_shard(self.source, rows=[{'text': '合成业务需求：核对附件'}])
        self.project = Path(__file__).resolve().parents[1]
        self.data = self.base / '应用 数据'
        self.sequence = 0

    def call(self, task):
        self.sequence += 1
        request = self.base / f'request-{self.sequence}.json'
        result = self.base / f'result-{self.sequence}.json'
        request.write_text(json.dumps(task, ensure_ascii=False), encoding='utf-8')
        env = os.environ.copy()
        env['PYTHONPATH'] = os.pathsep.join((str(self.project / '.runtime/offline-build-deps'), str(self.project / 'web_mvp')))
        process = subprocess.run([sys.executable, str(self.project / 'scripts/local_chat_app.py'),
            '--task-json', str(request), '--result-json', str(result), '--data-dir', str(self.data)],
            cwd=self.base, env=env, capture_output=True, text=True, encoding='utf-8', timeout=30)
        return process, json.loads(result.read_text(encoding='utf-8')) if result.is_file() else {}

    def test_list_then_export_without_gui_or_python_command_for_recipient(self):
        first, groups = self.call({'version': 1, 'action': 'groups',
            'source': {'sourceRoot': str(self.source), 'includeMedia': True}})
        self.assertEqual(first.returncode, 0, first.stderr)
        self.assertTrue(groups['ok'])
        self.assertTrue(any(row['id'] == GROUP for row in groups['groups']))
        # A later invocation reuses paths selected through the same data settings.
        second, export = self.call({'version': 1, 'action': 'export', 'chatId': GROUP})
        self.assertEqual(second.returncode, 0, second.stderr)
        self.assertEqual(export['report']['exportedRows'], 1)
        output = Path(export['output'])
        row = json.loads((output / 'messages.jsonl').read_text(encoding='utf-8'))
        self.assertEqual(row['text'], '合成业务需求：核对附件')
        self.assertEqual(row['direction'], 'unknown')
        self.assertTrue((output / '业务阅读.txt').is_file())
        self.assertEqual(set(export['exportFiles']), {'jsonl', 'json', 'md'})
        self.assertEqual(json.loads(Path(export['exportFiles']['json']).read_text(encoding='utf-8')), [row])

    def test_switching_selected_source_does_not_inherit_account_or_self_identity(self):
        process, _ = self.call({'version': 1, 'action': 'groups',
            'source': {'sourceRoot': str(self.source), 'selfId': SELF}})
        self.assertEqual(process.returncode, 0)
        other = self.base / '第二账号/db_storage'
        other.mkdir(parents=True)
        create_metadata(other)
        second_group = 'second-synthetic@chatroom'
        with closing(sqlite3.connect(other / 'contact/contact.db')) as db, db:
            db.execute('UPDATE contact SET username=?,remark=? WHERE username=?',
                       (second_group, '第二账号合成群', GROUP))
            db.execute('UPDATE chat_room SET username=? WHERE username=?', (second_group, GROUP))
        with closing(sqlite3.connect(other / 'session/session.db')) as db, db:
            db.execute('UPDATE SessionTable SET username=? WHERE username=?', (second_group, GROUP))
        create_shard(other, group=second_group, rows=[{'text': '第二账号独立消息'}])
        process, groups = self.call({'version': 1, 'action': 'groups', 'source': {'sourceRoot': str(other)}})
        self.assertEqual(process.returncode, 0)
        self.assertNotIn(GROUP, {group['id'] for group in groups['groups']})
        process, exported = self.call({'version': 1, 'action': 'export', 'chatName': '第二账号合成群'})
        self.assertEqual(process.returncode, 0)
        row = json.loads((Path(exported['output']) / 'messages.jsonl').read_text(encoding='utf-8'))
        self.assertEqual(row['text'], '第二账号独立消息')
        self.assertEqual(row['direction'], 'unknown')

    def test_bad_request_and_raw_key_fields_are_rejected_without_echo(self):
        for task in ({'version': 99, 'action': 'groups'},
                     {'version': 1, 'action': 'groups', 'source': {
                         'sourceRoot': str(self.source), 'key_hex': 'private-sentinel-value'}}):
            process, result = self.call(task)
            self.assertEqual(process.returncode, 2)
            self.assertFalse(result['ok'])
            self.assertNotIn('private-sentinel-value', json.dumps(result))
        self.assertFalse(self.data.exists())

    def test_key_recovery_requires_explicit_process_read_selection(self):
        process, result = self.call({'version': 1, 'action': 'recover_keys',
            'source': {'sourceRoot': str(self.source)}})
        self.assertEqual(process.returncode, 2)
        self.assertIn('明确', result['error'])
        self.assertFalse(self.data.exists())

    def test_existing_result_and_source_directory_are_never_overwritten(self):
        request = self.base / 'guard-request.json'
        result = self.source / 'guard-result.json'
        request.write_text(json.dumps({'version': 1, 'action': 'groups', 'source': {'sourceRoot': str(self.source)}}))
        from offline_batch import run_file
        self.assertEqual(run_file(request, result, self.data), 2)
        self.assertFalse(result.exists())
        existing = self.base / 'existing.json'
        existing.write_text('preserved')
        self.assertEqual(run_file(request, existing, self.data), 2)
        self.assertEqual(existing.read_text(), 'preserved')


if __name__ == '__main__':
    unittest.main()
