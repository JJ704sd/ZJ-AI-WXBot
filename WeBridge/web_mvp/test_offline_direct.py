"""Person mapping boundaries, using synthetic adapter rows only."""
from types import SimpleNamespace
import unittest

from offline_chat import ArchiveError
from offline_direct import conversations, select


class DirectMappingTests(unittest.TestCase):
    def archive(self, members):
        row = {'id': 'D:fixture', 'name': '合成联系人', 'conversationKind': 'direct',
               'nameBasis': 'conversation_user_table', 'directEvidence': 'unverified'}
        return SimpleNamespace(state={'self_id': 'synthetic-self', 'contacts': {}},
            member_names={'D:fixture': members}, groups=lambda **_: {'conversations': [row]})

    def test_incomplete_or_ambiguous_participants_cannot_be_selected(self):
        for members in ({}, {'synthetic-self': '我'}, {'peer-a': '甲'},
                        {'peer-a': '甲', 'peer-b': '乙'},
                        {'synthetic-self': '我', 'peer-a': '甲', 'peer-b': '乙'}):
            with self.subTest(members=list(members)):
                archive = self.archive(members)
                self.assertEqual(conversations(archive, 'direct'), [])
                with self.assertRaises(ArchiveError):
                    select(archive, chat_id='D:fixture', mode='direct')

    def test_self_and_one_peer_are_required_for_conversation_mapping(self):
        rows = conversations(self.archive({'synthetic-self': '我', 'peer-a': '甲'}), 'direct')
        self.assertEqual(rows[0]['peerId'], 'peer-a')
        self.assertEqual(rows[0]['directEvidence'], 'conversation_user_table')

    def test_conflicting_group_metadata_is_not_exposed_as_private_chat(self):
        row = {'id': 'R:fixture', 'name': '矛盾会话', 'conversationKind': 'direct',
               'conversationType': 'group', 'nameBasis': 'conversation_user_table'}
        archive = SimpleNamespace(state={'self_id': 'synthetic-self',
                                         'contacts': {'R:fixture': '矛盾会话'}},
            member_names={}, groups=lambda **_: {'conversations': [row]})
        self.assertEqual(conversations(archive, 'direct'), [])
        with self.assertRaises(ArchiveError):
            select(archive, chat_id='R:fixture', mode='direct')

    def test_system_type_is_case_insensitive_for_opaque_ids(self):
        row = {'id': 'opaque-service-1', 'name': '系统服务', 'conversationKind': 'direct',
               'conversationType': ' SYSTEM ', 'nameBasis': 'conversation_table'}
        archive = SimpleNamespace(state={'self_id': 'synthetic-self',
                                         'contacts': {'opaque-service-1': '系统服务'}},
            member_names={}, groups=lambda **_: {'conversations': [row]})
        self.assertEqual(conversations(archive, 'direct'), [])
        with self.assertRaises(ArchiveError):
            select(archive, chat_id='opaque-service-1', mode='direct')


if __name__ == '__main__':
    unittest.main()
