"""Public desktop workflow tests on synthetic sources; no GUI/client automation."""
import hashlib
import json
from pathlib import Path
import tempfile
import unittest

from offline_chat import ArchiveError
from offline_desktop import DesktopSession
from test_database_adapter import create_metadata, create_shard, GROUP, SELF


class DesktopSessionTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix='offline-desktop-test-')
        self.addCleanup(self.temp.cleanup)
        self.base = Path(self.temp.name).resolve()
        self.source = self.base / 'source'
        self.source.mkdir()
        create_metadata(self.source)
        create_shard(self.source, rows=[{'text': '桌面合成消息', 'source': '<msgsource/>'}])
        self.data = self.base / 'application-data'

    def config(self):
        return {'sourceRoot': str(self.source), 'selfId': SELF, 'includeMedia': False}

    def workbench(self, config=None):
        import shutil
        runtime = self.base / 'workbench-runtime'
        snapshot = runtime / 'database-snapshots/snapshot-fixture'
        snapshot.parent.mkdir(parents=True)
        shutil.copytree(self.source, snapshot)
        path = runtime / 'database-config.json'
        path.write_text(json.dumps({'snapshotRoot': str(snapshot), 'config': config or self.config()}), encoding='utf-8')
        return path, snapshot

    def test_automatic_startup_uses_known_config_and_owns_independent_copy(self):
        path, snapshot = self.workbench()
        before = hashlib.sha256(path.read_bytes()).hexdigest()
        session = DesktopSession(self.data, path)
        result = session.bootstrap()
        self.assertEqual(result['status'], 'ready')
        self.assertTrue(any(group['id'] == GROUP for group in result['groups']))
        self.assertNotEqual(session.archive.root, snapshot)
        self.assertTrue(session.archive.root.is_relative_to(self.data))
        self.assertEqual(hashlib.sha256(path.read_bytes()).hexdigest(), before)
        self.assertEqual(session.archive.state['self_id'], SELF)

    def test_repeat_launch_needs_no_workbench_or_path_input(self):
        session = DesktopSession(self.data)
        session.open_source(self.config())
        original_snapshot = session.archive.root
        session.preview(GROUP)
        again = DesktopSession(self.data)
        self.assertEqual(again.bootstrap()['status'], 'ready')
        self.assertEqual(again.settings['lastChat'], GROUP)
        self.assertNotEqual(again.archive.root, original_snapshot)

    def test_named_parse_opens_export_as_reading_view_and_reuses_first_setup(self):
        first = DesktopSession(self.data)
        self.assertEqual(first.bootstrap()['status'], 'needs_source')
        first.open_source(self.config())  # The first-use data selector's public operation.
        parsed = first.parse_and_open(chat_name='合成普通群')
        self.assertEqual(parsed['chat']['id'], GROUP)
        self.assertEqual(parsed['report']['exportedRows'], 1)
        self.assertEqual(parsed['view']['total'], 1)
        self.assertEqual(parsed['view']['viewRoot'], parsed['output'])
        self.assertEqual(parsed['view']['messages'][0]['text'], '桌面合成消息')
        self.assertTrue((Path(parsed['output']) / '业务阅读.txt').is_file())
        # A later short request needs only the group name, not source/key paths.
        again = DesktopSession(self.data)
        self.assertEqual(again.bootstrap()['status'], 'ready')
        repeated = again.parse_and_open(chat_name='合成普通群')
        self.assertEqual(repeated['chat']['id'], GROUP)
        self.assertNotEqual(parsed['output'], repeated['output'])
        self.assertFalse((self.data / 'views').exists())

    def test_named_parse_never_falls_back_to_remembered_group(self):
        session = DesktopSession(self.data)
        session.open_source(self.config())
        session.preview(GROUP)
        with self.assertRaises(ArchiveError):
            session.parse_and_open(chat_name='并不存在的群')
        self.assertIsNone(session.last_export)

    def test_selected_group_exports_real_artifacts_and_remembers_selection(self):
        session = DesktopSession(self.data)
        session.open_source(self.config())
        result = session.export(GROUP)
        self.assertEqual(result['report']['exportedRows'], 1)
        self.assertTrue((session.last_export / 'chat.html').is_file())
        row = json.loads((session.last_export / 'messages.jsonl').read_text(encoding='utf-8'))
        self.assertEqual(row['text'], '桌面合成消息')
        self.assertEqual(json.loads(session.settings_path.read_text(encoding='utf-8'))['lastChat'], GROUP)

    def test_unavailable_live_source_is_labelled_existing_snapshot(self):
        config = self.config()
        config['sourceRoot'] = str(self.base / 'missing-live-source')
        path, snapshot = self.workbench(config)
        session = DesktopSession(self.data, path)
        result = session.bootstrap()
        self.assertEqual(result['status'], 'ready')
        self.assertIn('既有副本', result['message'])
        self.assertIn('notice', result)
        self.assertNotEqual(session.archive.root, snapshot)

    def test_saved_account_failure_does_not_switch_to_other_source(self):
        session = DesktopSession(self.data)
        session._save({'sourceRoot': str(self.base / 'selected-but-missing')})
        path, _snapshot = self.workbench()
        again = DesktopSession(self.data, path)
        result = again.bootstrap()
        self.assertEqual(result['status'], 'needs_source')
        self.assertIsNone(again.archive)

    def test_new_user_is_given_configuration_state_not_fake_success(self):
        result = DesktopSession(self.data).bootstrap()
        self.assertEqual(result['status'], 'needs_source')
        self.assertFalse(self.data.exists())

    def test_failed_refresh_keeps_current_good_source(self):
        session = DesktopSession(self.data)
        session.open_source(self.config())
        root = session.archive.root
        bad = self.config()
        bad['sourceRoot'] = str(self.base / 'missing')
        with self.assertRaises(ValueError):
            session.open_source(bad)
        self.assertEqual(session.archive.root, root)
        self.assertEqual(session.preview(GROUP)['messages'][0]['text'], '桌面合成消息')

    def test_data_directory_cannot_write_inside_wechat_account(self):
        session = DesktopSession(self.source / 'tool-data')
        with self.assertRaisesRegex(ArchiveError, '不能位于微信账号目录'):
            session.open_source(self.config())
        self.assertFalse((self.source / 'tool-data').exists())

    def test_settings_whitelist_references_never_contains_key_material(self):
        config = self.config()
        config['unexpected_secret'] = 'secret-sentinel'
        session = DesktopSession(self.data)
        session.open_source(config)
        self.assertNotIn('secret-sentinel', session.settings_path.read_text(encoding='utf-8'))

    def test_paged_reading_reaches_older_records_and_preserves_nested_bodies(self):
        from test_database_adapter import STAMP
        nested = '<recordinfo><datalist><dataitem datatype="1"><sourcename>合成人员</sourcename><datadesc>嵌套消息全文</datadesc></dataitem></datalist></recordinfo>'
        xml = '<msg><appmsg><type>19</type><title>合成转发</title><recorditem><recordinfo><datalist><dataitem datatype="17"><recordxml>' + nested + '</recordxml></dataitem></datalist></recordinfo></recorditem></appmsg></msg>'
        rows = [{'local': i, 'time': STAMP + i + 10, 'text': '合成历史 ' + str(i)} for i in range(1, 205)]
        rows.append({'local': 205, 'time': STAMP + 220, 'type': 49, 'text': xml})
        create_shard(self.source, 'message/message_1.db', rows=rows)
        session = DesktopSession(self.data)
        session.open_source(self.config())
        recent = session.preview(GROUP)
        self.assertEqual(recent['total'], 206)
        self.assertEqual(len(recent['messages']), 100)
        pages = [session.preview(GROUP, offset)['messages'] for offset in (0, 100, 200)]
        self.assertEqual(len({row['id'] for page in pages for row in page}), 206)
        record = session.preview(GROUP, kind='record')['messages'][0]
        self.assertEqual(record['record']['items'][0]['record']['items'][0]['text'], '嵌套消息全文')
        self.assertIsNone(session.last_export)


if __name__ == '__main__':
    unittest.main()
