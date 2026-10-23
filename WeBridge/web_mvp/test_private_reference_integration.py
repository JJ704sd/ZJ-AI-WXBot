"""Verified export -> search -> candidate evidence, using only synthetic files."""
import hashlib
import json
import unittest

import test_private_profiles as fixtures
from private_insights import search_messages


class ReferenceIntegrationTests(unittest.TestCase):
    setUp = fixtures.PrivateProfileFixture.setUp
    tearDown = fixtures.PrivateProfileFixture.tearDown
    candidate = fixtures.PrivateProfileFixture.candidate

    def rehash_export(self):
        for filename, field in (('review.json', 'reviewedArtifacts'), ('manifest.json', 'artifacts')):
            path = self.export / filename
            value = json.loads(path.read_text(encoding='utf8'))
            if filename == 'manifest.json':
                value['exportedRows'] = len((self.export / 'messages.jsonl').read_text(encoding='utf8').splitlines())
            for item in value[field]:
                artifact = self.export / item['path']
                item.update(bytes=artifact.stat().st_size,
                            sha256=hashlib.sha256(artifact.read_bytes()).hexdigest())
            path.write_text(json.dumps(value), encoding='utf8')

    def test_search_reference_can_stage_against_the_verified_analysis_number(self):
        corpus = self.export / 'analysis/corpus.jsonl'
        value = json.loads(corpus.read_text(encoding='utf8'))
        value['ref'] = 7
        corpus.write_text(json.dumps(value) + '\n', encoding='utf8')
        (self.export / 'analysis/index.json').write_text(
            json.dumps({'chunks': [{'file': 'part-001.md', 'refs': [7, 7]}]}), encoding='utf8')
        self.rehash_export()
        source = self.store.inspect_export(self.export)
        self.assertEqual(source['messages'][0]['ref'], 1)
        found = search_messages(source, '报价')['items'][0]
        self.assertEqual(found['ref'], 7)
        request = self.store.prepare(self.export)
        candidate = self.candidate(request)
        candidate['observations'][0]['evidence'][0]['ref'] = found['ref']
        staged = self.store.stage(request['requestId'], candidate)
        evidence = self.store.candidate(staged['candidateId'])['changes'][0]['evidence'][0]
        self.assertEqual((evidence['messageId'], evidence['ref'], evidence['text']),
                         ('m1', 7, '需要报价'))

    def test_non_analysis_record_remains_searchable_without_a_candidate_reference(self):
        path = self.export / 'messages.jsonl'
        path.write_text(path.read_text(encoding='utf8') + json.dumps({
            'id': None, 'messageId': 'media-only', 'ref': 99,
            'senderId': 'peer-1', 'direction': 'incoming', 'kind': 'image',
            'text': '图片线索', 'time': '2026-10-22T10:00:00+08:00'}) + '\n', encoding='utf8')
        self.rehash_export()
        source = self.store.inspect_export(self.export)
        found = search_messages(source, '图片线索')['items'][0]
        self.assertEqual(found['messageId'], 'media-only')
        self.assertIsNone(found['ref'])


if __name__ == '__main__':
    unittest.main()
