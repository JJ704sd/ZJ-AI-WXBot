"""Exercise the real command parser and wizard using synthetic local sources."""
from contextlib import redirect_stderr, redirect_stdout
import importlib.util
import io
import json
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch

from test_database_adapter import create_metadata, create_shard, GROUP

SPEC = importlib.util.spec_from_file_location('local_chat_cli', Path(__file__).resolve().parents[1] / 'scripts/local_chat.py')
CLI = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(CLI)


class OfflineCliTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name).resolve()
        self.source = self.root / 'snapshot'
        self.source.mkdir()
        create_metadata(self.source)
        create_shard(self.source)

    def call(self, args):
        stdout, stderr = io.StringIO(), io.StringIO()
        with redirect_stdout(stdout), redirect_stderr(stderr):
            status = CLI.main(args)
        return status, stdout.getvalue(), stderr.getvalue()

    def test_groups_then_export_using_cli(self):
        status, out, err = self.call(['groups', '--snapshot', str(self.source)])
        self.assertEqual(status, 0, err)
        self.assertTrue(any(row['id'] == GROUP for row in json.loads(out)['conversations']))
        destination = self.root / 'export'
        status, out, err = self.call(['export', '--snapshot', str(self.source), '--chat', GROUP, '--output', str(destination)])
        self.assertEqual(status, 0, err)
        self.assertEqual(json.loads(out)['exportedRows'], 1)
        self.assertTrue((destination / 'chat.html').is_file())

    def test_invalid_date_and_existing_output_have_safe_diagnostics(self):
        args = ['export', '--snapshot', str(self.source), '--chat', GROUP, '--output', str(self.root / 'export')]
        status, out, err = self.call(args + ['--start-date', 'not-a-date'])
        self.assertEqual(status, 2)
        self.assertIn('YYYY-MM-DD', json.loads(err)['error'])
        self.assertEqual(out, '')
        (self.root / 'export').mkdir()
        status, out, err = self.call(args)
        self.assertEqual(status, 2)
        self.assertIn('已存在', json.loads(err)['error'])

    def test_unknown_failure_does_not_echo_payload_or_key(self):
        with patch.object(CLI, 'run', side_effect=ValueError('sensitive-payload-marker')):
            status, out, err = self.call(['discover'])
        self.assertEqual(status, 2)
        self.assertNotIn('sensitive-payload-marker', err)

    def test_review_command_lists_ids_and_does_not_export_failed_review(self):
        inputs = [GROUP, '', '', 'n', 'n', 'n', 'n']
        with patch('builtins.input', side_effect=inputs), redirect_stdout(io.StringIO()) as out:
            status = CLI.main(['review', '--client', 'wechat', '--source', str(self.source),
                               '--data-dir', str(self.root / 'review-profile')])
        self.assertEqual(status, 0)
        self.assertIn('合成普通群', out.getvalue())
        self.assertIn(GROUP, out.getvalue())
        self.assertIn('awaiting_review', out.getvalue())
        self.assertFalse((self.root / 'review-profile/exports').exists())


if __name__ == '__main__':
    unittest.main()
