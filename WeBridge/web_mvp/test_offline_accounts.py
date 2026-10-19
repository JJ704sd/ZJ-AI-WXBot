"""Synthetic directories and substituted OS file-owner metadata only."""
from pathlib import Path
import tempfile
import unittest

from offline_accounts import group_choices, identify_accounts


class AccountChoiceTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.base = Path(self.temp.name).resolve()
        self.accounts = []
        for label in ('first', 'second'):
            root = self.base / label / 'db_storage'
            root.mkdir(parents=True)
            (root / 'session.db').write_bytes(b'fixture')
            self.accounts.append({'directoryLabel': label, 'sourceRoot': str(root), 'databases':[{'path':'session.db'}]})

    def test_unique_running_account_is_recommended_even_with_old_directories(self):
        result = identify_accounts({'accounts': self.accounts}, ownership=lambda paths, _client:
            [(81, 100)] if paths[0].parent.parent.name == 'second' else [])
        self.assertEqual(result['recommendedSourceRoot'], self.accounts[1]['sourceRoot'])
        self.assertEqual(result['accounts'][0]['processIds'], [81])
        self.assertEqual(result['activeAccountCount'], 1)
        self.assertNotIn('processIds', self.accounts[0])

    def test_multiple_accounts_or_ambiguous_owners_require_selection(self):
        for owners in ([(81, 100)], [(81, 100), (82, 200)]):
            result = identify_accounts({'accounts':self.accounts}, ownership=lambda *_: owners)
            self.assertIsNone(result['recommendedSourceRoot'])

    def test_unavailable_process_metadata_never_claims_running_or_changes_source(self):
        def denied(*_):raise PermissionError('private-sentinel')
        result = identify_accounts({'accounts': self.accounts}, ownership=denied)
        self.assertIsNone(result['recommendedSourceRoot'])
        self.assertEqual({row['processState'] for row in result['accounts']}, {'unavailable'})
        self.assertNotIn('private-sentinel', str(result))

    def test_one_verified_account_plus_an_unknown_account_is_not_a_unique_recommendation(self):
        def lookup(paths, _client):
            if paths[0].parent.parent.name == 'first':
                return [(81, 100)]
            raise PermissionError('private-sentinel')
        result = identify_accounts({'accounts': self.accounts}, ownership=lookup)
        self.assertEqual(result['activeAccountCount'], 1)
        self.assertIsNone(result['recommendedSourceRoot'])

    def test_truncated_file_probe_is_unknown_instead_of_inactive(self):
        account = dict(self.accounts[0])
        root = Path(account['sourceRoot'])
        names = [f'part_{i}.db' for i in range(33)]
        for name in names:
            (root / name).write_bytes(b'fixture')
        account['databases'] = [{'path': name} for name in names]
        result = identify_accounts({'accounts': [account]}, ownership=lambda *_: [])
        self.assertEqual(result['accounts'][0]['processState'], 'unavailable')

    def test_personal_account_folder_alias_probes_its_database_directory(self):
        account = {**self.accounts[0], 'sourceRoot': str(Path(self.accounts[0]['sourceRoot']).parent)}
        result = identify_accounts({'accounts': [account]}, ownership=lambda *_: [(81, 100)])
        self.assertEqual(result['accounts'][0]['processState'], 'active')

    def test_paths_outside_discovered_database_root_are_never_probed(self):
        self.accounts[0]['databases'] = [{'path':'../outside.db'}]
        result = identify_accounts({'accounts':self.accounts[:1]}, ownership=lambda *_: self.fail('escaped database probe'))
        self.assertEqual(result['accounts'][0]['processState'], 'unavailable')

    def test_wecom_account_resolves_its_data_subdirectory(self):
        root = self.base / 'enterprise'
        (root / 'Data').mkdir(parents=True)
        database = root / 'Data/message.db'
        database.write_bytes(b'fixture')
        def owner(paths, client):
            self.assertEqual(client, 'wecom')
            self.assertEqual(paths, [database])
            return [(91, 300)]
        result = identify_accounts({'accounts':[{'directoryLabel':'enterprise','sourceRoot':str(root),
            'databases':[{'path':'message.db'}]}]}, 'wecom', ownership=owner)
        self.assertEqual(result['recommendedSourceRoot'], str(root))

    def test_recent_search_and_duplicate_names_remain_distinct(self):
        groups = [{'id':'first@chatroom','name':'业务群'}, {'id':'second@chatroom','name':'业务群'},
                  {'id':'third@chatroom','name':'其他群'}]
        result = group_choices(groups, '业务', 'second@chatroom')
        self.assertEqual([row['id'] for row in result], ['second@chatroom','first@chatroom'])
        self.assertEqual(len({row['choiceLabel'] for row in result}), 2)
        self.assertEqual(group_choices(groups, 'THIRD@')[0]['id'], 'third@chatroom')
        self.assertEqual(group_choices(groups, '没有匹配'), [])


if __name__ == '__main__':
    unittest.main()
