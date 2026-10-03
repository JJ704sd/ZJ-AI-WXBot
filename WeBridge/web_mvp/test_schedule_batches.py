"""Batch scheduling over temporary SQLite with an invented native boundary."""
import unittest
from unittest.mock import patch

import test_windows_scheduler as fixtures


class ScheduleBatchTests(unittest.TestCase):
    def setUp(self):
        self.s = fixtures.SchedulerTests()
        self.addCleanup(self.s.doCleanups)
        self.s.setUp()
        self.f, self.scheduler = self.s.f, self.s.scheduler
        self.groups = [self.f.group, 'synthetic-second@chatroom']
        self.f.engine.group_list.append({'id':self.groups[1], 'name':'合成群'})
        self.f.engine.store.set_watched(self.f.account, self.groups)
        self.template = 'synthetic-batch-template'
        templates = self.scheduler.templates
        templates.save(self.f.account, self.template, 0, '业务通知', '您好 {{客户}}')
        for version,group in enumerate(self.groups, 1):
            templates.profile(self.f.account, self.template, version, group, {'客户':str(version)}, None)

    def data(self, **changes):
        return {'account':self.f.account, 'templateId':self.template, 'templateVersion':3,
            'groupIds':self.groups, 'mode':'daily', 'clock':'10:01', **changes}

    def test_preview_renders_saved_profiles_without_sender_or_writes(self):
        with patch.object(self.scheduler, 'sender_factory', side_effect=AssertionError('Preview must not use Hook')):
            result = self.scheduler.batches.preview(self.data())
        self.assertTrue(result['canCreate'])
        self.assertEqual((result['readyCount'],result['invalidCount']), (2,0))
        self.assertEqual([row['text'] for row in result['records']], ['您好 1','您好 2'])
        self.assertEqual([row['contentSource'] for row in result['records']], ['template','template'])
        self.assertEqual(result['nextRun'], self.f.now+60)
        self.assertEqual(result['deadline'], self.f.now+180)
        self.assertEqual(result['existingCount'], 0)
        self.assertEqual(result['capacity'], 500)
        self.assertTrue(result['previewDigest'])
        self.assertEqual(self.scheduler.list(self.f.account), [])
        self.assertEqual(self.f.posts, [])


if __name__ == '__main__':
    unittest.main()
