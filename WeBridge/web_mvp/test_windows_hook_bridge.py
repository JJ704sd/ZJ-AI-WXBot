"""Core repeatable-bridge tests using a synthetic native boundary only."""
from contextlib import closing
import hashlib
import importlib.util
import json
from pathlib import Path
import sys
import tempfile
import unittest
from unittest.mock import patch, Mock

SCRIPTS = Path(__file__).resolve().parents[1] / 'scripts'
WEB = Path(__file__).resolve().parent
if str(WEB) not in sys.path:
    sys.path.insert(0, str(WEB))
if str(SCRIPTS) not in sys.path:
    sys.path.insert(0, str(SCRIPTS))
spec = importlib.util.spec_from_file_location('repeatable_bridge_test_module', SCRIPTS / 'run_windows_hook_bridge.py')
bridge_module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(bridge_module)
from windows_hook_bridge import WindowsHookBridgeManager


class FakeNative:
    def __init__(self):
        self.binding = {**bridge_module.PROFILE, 'pid': 123, 'processStarted': '134000000000000000',
            'selfId': 'wxid_synthetic', 'sourceRoot': 'd:\\synthetic\\db_storage', 'instanceId': 'synthetic-instance'}
        self.detached = self.invalidated = False
        self.calls = []
        self.targets = []
        self.fail = False
        self.during_construct = None

    def revalidate(self):
        if self.invalidated:
            raise bridge_module.SmokeError('native_session_unavailable')

    def construct(self, payload):
        self.calls.append(('construct', payload['requestId']))
        self.targets.append(payload['targetId'])
        if self.during_construct:
            self.during_construct()
        return {'constructionId': payload['requestId'],
                'clientMessageId': '00000000-0000-0000-0000-' + payload['requestId'][:12]}

    def submit(self, payload, construction):
        self.calls.append(('submit', payload['requestId']))
        if self.fail:
            raise bridge_module.SmokeError('native_timeout')
        return {'state': 'submitted_unconfirmed', 'submissionAttempted': True, 'nativeReturned': True,
                'clientMessageId': construction['clientMessageId'], 'ready': True, 'callerReferencesReleased': True}


class RepeatableBridgeTests(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory()
        self.directory = Path(self.temporary.name)
        self.native = FakeNative()
        self.bridge = bridge_module.TextBridge(self.native, self.directory)

    def tearDown(self):
        self.temporary.cleanup()

    def request(self, marker='a', text='中文消息😀', target='filehelper'):
        return {'protocol': bridge_module.PROTOCOL, 'requestId': marker*32, 'draftId': marker*32,
            'textHash': hashlib.sha256(text.encode('utf-8')).hexdigest(), 'text': text, 'targetId': target,
            'expectedBinding': self.native.binding}

    def test_distinct_unicode_messages_submit_once_each_and_replay_only_reads(self):
        first = self.bridge.send(self.request())
        second = self.bridge.send(self.request('b', '第二条\n文件助手'))
        self.assertEqual((first['status'], second['status']), ('submitted', 'submitted'))
        self.assertEqual(self.bridge.send(self.request()), first)
        self.assertEqual(len(self.native.calls), 4)
        self.assertFalse(first['delivered'])
        self.assertTrue(self.bridge.status()['ready'])

    def test_disk_record_precedes_construct_and_unknown_survives_restart(self):
        def check_latch():
            with closing(self.bridge.connect()) as database:
                response = json.loads(database.execute('SELECT response FROM attempts').fetchone()[0])
            self.assertEqual(response['status'], 'unknown')
        self.native.during_construct = check_latch
        self.native.fail = True
        result = self.bridge.send(self.request())
        self.assertEqual(result['status'], 'unknown')
        replacement = FakeNative()
        restarted = bridge_module.TextBridge(replacement, self.directory)
        self.assertEqual(restarted.send(self.request()), result)
        self.assertEqual(replacement.calls, [])
        self.assertFalse(self.bridge.status()['ready'])

    def test_scope_and_utf16_limit_are_consistent_with_native(self):
        for payload in (self.request(text='😀'*1001), self.request(target='display name'),
                        self.request(target='群显示名'), self.request(target='x'*257)):
            with self.assertRaises(bridge_module.SmokeError):
                self.bridge.send(payload)
        self.assertEqual(self.native.calls, [])
        self.assertEqual(self.bridge.send(self.request(text='😀'*1000))['status'], 'submitted')

    def test_selected_targets_pass_through_and_request_cannot_change_target(self):
        self.assertEqual(self.bridge.status()['scope']['targetPolicy'], 'selected_conversation')
        self.assertNotIn('targetId', self.bridge.status()['scope'])
        first = self.bridge.send(self.request(target='wxid_synthetic_one'))
        second = self.bridge.send(self.request('b', target='12345678@chatroom'))
        self.assertEqual((first['status'], second['status']), ('submitted', 'submitted'))
        self.assertEqual(self.native.targets, ['wxid_synthetic_one', '12345678@chatroom'])
        changed = self.bridge.send(self.request(target='different@openim'))
        self.assertEqual(changed['status'], 'not_submitted')
        self.assertFalse(changed['submissionAttempted'])
        self.assertEqual(len(self.native.calls), 4)

    def test_changed_account_or_process_binding_does_not_call_native(self):
        request = self.request(target='wxid_synthetic_one')
        request['expectedBinding'] = {**self.native.binding, 'pid': 456}
        result = self.bridge.send(request)
        self.assertEqual(result['status'], 'not_submitted')
        self.assertFalse(result['submissionAttempted'])
        self.assertEqual(self.native.calls, [])

    def test_configuration_cleanup_keeps_another_instance(self):
        first = bridge_module.OwnedConfiguration(self.directory, 'a'*32, 'first-token', 8789)
        second = bridge_module.OwnedConfiguration(self.directory, 'b'*32, 'second-token', 8789)
        first.publish()
        second.publish()
        first.cleanup()
        self.assertEqual(json.loads((self.directory / 'hook-config.json').read_text()), second.config)
        self.assertFalse((self.directory / first.token_name).exists())
        self.assertTrue((self.directory / second.token_name).exists())
        second.cleanup()
        self.assertFalse((self.directory / 'hook-config.json').exists())

    @patch('windows_hook_bridge.process_matches', return_value=False)
    @patch('windows_hook_bridge.subprocess.Popen')
    def test_manager_launches_hidden_once_and_requests_graceful_stop(self, popen, process_matches):
        child = Mock(pid=456)
        child.poll.return_value = None
        popen.return_value = child
        manager = WindowsHookBridgeManager(self.directory)
        self.assertEqual(manager.start()['state'], 'starting')
        manager.start()
        self.assertEqual(popen.call_count, 1)
        self.assertEqual(manager.stop()['state'], 'stopping')
        stop = json.loads((self.directory / 'hook-bridge-stop.json').read_text())
        self.assertEqual(stop['instanceId'], manager.instance_id)
        child.terminate.assert_not_called()
        child.kill.assert_not_called()


if __name__ == '__main__':
    unittest.main()
