"""Synthetic coverage for citable analysis material; no real chats or accounts."""
from datetime import datetime
import json
from pathlib import Path
import tempfile
import unittest

from offline_analysis import AnalysisWriter, build_batch
from offline_chat import BEIJING, LocalArchive
from test_database_adapter import create_metadata, create_shard, ENTERPRISE, GROUP, PEER, SELF, STAMP


def lines(path):
    return [json.loads(line) for line in Path(path).read_text(encoding='utf-8').splitlines()]


class AnalysisExportTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix='offline-analysis-test-')
        self.addCleanup(self.temp.cleanup)
        self.base = Path(self.temp.name).resolve()
        self.source = self.base / 'source'
        self.source.mkdir()
        create_metadata(self.source)

    def export(self, rows, name='export'):
        create_shard(self.source, rows=rows)
        destination = self.base / name
        report = LocalArchive(self.source, SELF).export(destination, chat_id=GROUP)
        return report, destination

    def test_rows_are_citable_with_replies_mentions_recalls_and_roster(self):
        quote = ('<msg><appmsg><type>57</type><title>收到，下午给报价</title><refermsg><type>1</type><svrid>10</svrid>'
                 '<chatusr>' + PEER + '</chatusr><displayname>引用人</displayname><content>请提供报价单</content>'
                 '</refermsg></appmsg></msg>')
        report, destination = self.export([
            {'local': 1, 'server': 10, 'sender': 2, 'time': STAMP, 'text': '请提供报价单',
             'source': '<msgsource><atuserlist>' + ENTERPRISE + '</atuserlist></msgsource>'},
            {'local': 2, 'server': 11, 'sender': 3, 'time': STAMP + 60, 'type': 49, 'text': quote},
            {'local': 3, 'server': 12, 'sender': 2, 'time': STAMP + 90, 'type': 47, 'text': '<msg><emoji/></msg>'},
            {'local': 4, 'server': 13, 'sender': 1, 'time': STAMP + 120, 'text': '临时消息'},
            {'local': 5, 'server': 14, 'sender': 1, 'time': STAMP + 130, 'type': 10002,
             'text': '<sysmsg><revokemsg><newmsgid>13</newmsgid><replacemsg>你撤回了一条消息</replacemsg></revokemsg></sysmsg>'}])
        summary = report['analysis']
        corpus = lines(destination / summary['corpusFile'])
        self.assertEqual([record['ref'] for record in corpus], [1, 2, 3, 4])
        messages = {row['id'] for row in lines(destination / 'messages.jsonl')}
        self.assertTrue({record['id'] for record in corpus} <= messages)
        self.assertEqual(corpus[0]['mentions'], ['合成企业联系人'])
        self.assertEqual(corpus[1]['replyTo'], {'ref': 1, 'basis': 'unique_server_id'})
        self.assertEqual(corpus[1]['quoted'], {'sender': corpus[0]['sender'], 'senderId': PEER, 'text': '请提供报价单'})
        self.assertEqual(corpus[3]['revokes'], 3)
        part = (destination / summary['chunkFiles'][0]).read_text(encoding='utf-8')
        self.assertIn('（回复 #1 ' + corpus[0]['sender'] + '「请提供报价单」）', part)
        self.assertIn('（@ 合成企业联系人）', part)
        self.assertIn('（被撤回的是 #3）', part)
        self.assertIn('合成企业联系人（企业微信，群昵称 合成企业成员）', part)
        self.assertNotIn('emoji', part)
        roster = {person['senderId']: person for person in
                  json.loads((destination / summary['participantsFile']).read_text(encoding='utf-8'))['participants']}
        self.assertEqual(roster[PEER]['groupNickname'], '合成群昵称')
        self.assertEqual(roster[PEER]['repliesReceived'], 1)
        self.assertEqual(roster[ENTERPRISE]['mentionsReceived'], 1)
        self.assertEqual(roster[ENTERPRISE]['accountType'], '企业微信')
        self.assertTrue(roster[SELF]['isSelf'])
        artifacts = {item['path'] for item in report['artifacts']}
        self.assertTrue({'analysis/index.json', 'analysis/README.md', 'analysis/part-001.md'} <= artifacts)
        self.assertIn('业务分析材料', report['reporting']['replyMarkdown'])

    def test_unconfirmed_quote_source_is_not_linked(self):
        quote = ('<msg><appmsg><type>57</type><title>同意</title><refermsg><type>1</type><svrid>10</svrid>'
                 '<displayname>引用人</displayname><content>方案</content></refermsg></appmsg></msg>')
        report, destination = self.export([
            {'local': 1, 'server': 10, 'time': STAMP, 'text': '方案'},
            {'local': 2, 'server': 10, 'time': STAMP + 1, 'text': '方案'},
            {'local': 3, 'server': 11, 'time': STAMP + 2, 'type': 49, 'text': quote}])
        corpus = lines(destination / report['analysis']['corpusFile'])
        self.assertIsNone(corpus[2]['replyTo'])
        self.assertEqual(report['analysis']['links'], {'replyUnlinked': 1})

    def test_chunks_break_at_day_or_gap_and_keep_every_row(self):
        root = self.base / 'stage'
        root.mkdir()
        chat = {'id': GROUP, 'name': '合成群'}
        with AnalysisWriter(root, chat, budget=200) as writer:
            for index in range(30):
                stamp = STAMP + index * 600 + (86400 if index >= 20 else 0)
                writer.add({'id': f'm|{index}', 'kind': 'text', 'text': '业务内容' * 5, 'senderId': PEER,
                            'senderName': '合成联系人', 'timestamp': stamp, 'isSelf': False,
                            'time': datetime.fromtimestamp(stamp, BEIJING).isoformat()})
            summary = writer.finish()
        index = json.loads((root / 'analysis/index.json').read_text(encoding='utf-8'))
        self.assertGreater(len(index['chunks']), 1)
        self.assertEqual(sum(chunk['rows'] for chunk in index['chunks']), 30)
        refs = [ref for chunk in index['chunks'] for ref in range(chunk['refs'][0], chunk['refs'][1] + 1)]
        self.assertEqual(refs, list(range(1, 31)))
        self.assertTrue(all(chunk['characters'] < 2 * 200 + 1000 for chunk in index['chunks']))
        self.assertEqual(summary['rows'], 30)
        for record in lines(root / 'analysis/corpus.jsonl'):
            self.assertIn('[#' + str(record['ref']) + ' ', (root / 'analysis' / record['chunk']).read_text(encoding='utf-8'))

    def test_long_attachment_text_is_excerpted_but_kept_in_corpus(self):
        root = self.base / 'stage'
        root.mkdir()
        text = '条款' * 4000
        with AnalysisWriter(root, {'id': GROUP, 'name': '合成群'}) as writer:
            writer.add({'id': 'm|1', 'kind': 'file', 'text': '合同.docx', 'senderId': PEER, 'senderName': '合成联系人',
                        'timestamp': STAMP, 'time': '2023-11-15T06:13:20+08:00', 'media': {'filename': '合同.docx'},
                        'asset': {'status': 'ready', 'filename': '合同.docx'},
                        'attachmentContent': {'fileStatus': 'ready', 'extractionStatus': 'extracted',
                                              'characters': len(text), 'truncated': False, 'text': text}})
            writer.finish()
        part = (root / 'analysis/part-001.md').read_text(encoding='utf-8')
        self.assertIn('[附件 合同.docx · 原件 · 正文已提取]', part)
        self.assertIn('正文共 8000 字', part)
        self.assertLess(len(part), 5000)
        self.assertEqual(lines(root / 'analysis/corpus.jsonl')[0]['attachment']['text'], text)

    def test_batch_index_merges_timeline_and_shared_speakers(self):
        root = self.base / 'batch'
        root.mkdir()
        groups = []
        for number, (chat, offset) in enumerate((('a@chatroom', 0), ('b@chatroom', 30)), 1):
            directory = f'{number:02d}-synthetic'
            (root / directory).mkdir()
            info = {'id': chat, 'name': '合成群' + str(number)}
            with AnalysisWriter(root / directory, info, [{'id': PEER, 'name': '合成联系人'}]) as writer:
                for index in range(2):
                    stamp = STAMP + offset + index * 60
                    writer.add({'id': f'{chat}|{index}', 'kind': 'text', 'text': f'{chat} 第{index}条',
                                'senderId': PEER, 'senderName': '合成联系人', 'timestamp': stamp,
                                'time': str(stamp), 'isSelf': False})
                writer.finish()
            groups.append({'chat': info, 'directory': directory})
        summary = build_batch(root, groups)
        timeline = lines(root / summary['timelineFile'])
        self.assertEqual([item['cite'] for item in timeline], ['G1#1', 'G2#1', 'G1#2', 'G2#2'])
        index = json.loads((root / summary['indexFile']).read_text(encoding='utf-8'))
        self.assertEqual(index['sharedParticipants'][0]['senderId'], PEER)
        self.assertIn('在多个群发言的人', (root / summary['readmeFile']).read_text(encoding='utf-8'))


if __name__ == '__main__':
    unittest.main()
