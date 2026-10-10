"""Recovery guards using temporary SQLite and invented native identities."""
import unittest
import sqlite3
from contextlib import closing
import test_windows_hook_sender as fixtures


class PreparedRecoveryTests(unittest.TestCase):
    def setUp(self):
        self.f=fixtures.HookTests();self.f.setUp();self.addCleanup(self.f.doCleanups)

    def test_pre_pause_draft_cannot_send_after_explicit_account_resume(self):
        draft=self.f.sender.prepare(self.f.data)
        paused=self.f.sender.pause_safety(self.f.source,0)
        self.f.sender.resume_safety(self.f.source,paused['version'],True)
        result=self.f.sender.confirm(self.f.confirm_data(draft))
        self.assertEqual((result['status'],result.get('issueCode')),('blocked','safety_policy_changed'))
        self.assertFalse(any(call[0]=='POST' for call in self.f.calls))
        fresh=self.f.sender.prepare({**self.f.data,'idempotencyKey':'synthetic-fresh-after-recovery'})
        self.assertEqual(self.f.sender.confirm(self.f.confirm_data(fresh))['status'],'server_accepted')

    def test_limit_change_invalidates_old_draft_and_browser_cannot_override_version(self):
        draft=self.f.sender.prepare(self.f.data)
        current=self.f.sender.safety(self.f.source)
        changed=self.f.sender.configure_safety(self.f.source,{**current['limits'],'perMinute':7},current['version'])
        result=self.f.sender.confirm({**self.f.confirm_data(draft),'safetyVersion':changed['version']})
        self.assertEqual(result.get('issueCode'),'safety_policy_changed')
        self.assertFalse(any(call[0]=='POST' for call in self.f.calls))

    def test_unknown_recovery_invalidates_other_prepared_drafts(self):
        old=self.f.sender.prepare(self.f.data)
        unknown=self.f.sender.prepare({**self.f.data,'idempotencyKey':'synthetic-other-unknown',
                                      'text':'a separate synthetic unknown result'})
        self.f.outcome=TimeoutError()
        self.assertEqual(self.f.sender.confirm(self.f.confirm_data(unknown))['status'],'unknown')
        paused=self.f.sender.safety(self.f.source)
        self.f.sender.resume_safety(self.f.source,paused['version'],True)
        self.f.now+=31
        self.assertEqual(self.f.sender.confirm(self.f.confirm_data(old)).get('issueCode'),'safety_policy_changed')
        self.assertEqual(sum(call[0]=='POST' for call in self.f.calls),1)

    def test_another_accounts_policy_change_does_not_invalidate_current_draft(self):
        draft=self.f.sender.prepare(self.f.data)
        other={**self.f.source,'selfId':'different-configured-self'}
        current=self.f.sender.safety(other)
        self.f.sender.configure_safety(other,{**current['limits'],'perMinute':3},current['version'])
        self.assertEqual(self.f.sender.confirm(self.f.confirm_data(draft))['status'],'server_accepted')

    def test_legacy_unversioned_prepared_draft_requires_fresh_confirmation(self):
        draft=self.f.sender.prepare(self.f.data)
        with closing(sqlite3.connect(self.f.sender.path)) as db:
            db.execute('UPDATE hook_drafts SET result=? WHERE id=?',('{}',draft['draftId']));db.commit()
        self.assertEqual(self.f.sender.confirm(self.f.confirm_data(draft)).get('issueCode'),'safety_policy_changed')
        self.assertFalse(any(call[0]=='POST' for call in self.f.calls))

    def test_policy_change_after_business_check_is_rechecked_atomically_at_admission(self):
        current=self.f.sender.safety(self.f.source)
        def changed_after_check(draft_id):
            self.f.sender.account_safety.configure(self.f.source,{**current['limits'],'perMinute':7},current['version'])
        result=self.f.sender.send_automatic(self.f.data,expected_binding=self.f.sender.automation_binding(self.f.source),
                baseline_messages=[],before_submit=changed_after_check)
        self.assertEqual(result.get('issueCode'),'safety_policy_changed')
        self.assertEqual(self.f.sender.safety(self.f.source)['usage']['minute'],0)
        self.assertFalse(any(call[0]=='POST' for call in self.f.calls))


class JournalFailureTests(unittest.TestCase):
    def setUp(self):
        self.f=fixtures.HookTests();self.f.setUp();self.addCleanup(self.f.doCleanups)

    def test_first_journal_write_failure_pauses_account_without_claiming_unknown_send(self):
        draft=self.f.sender.prepare(self.f.data)
        with closing(sqlite3.connect(self.f.sender.path)) as db:
            db.execute("CREATE TRIGGER synthetic_latch_failure BEFORE UPDATE OF status ON hook_drafts "
                "WHEN NEW.status='attempted' BEGIN SELECT RAISE(ABORT,'synthetic journal failure'); END")
            db.commit()
        with self.assertRaises(sqlite3.Error):self.f.sender.confirm(self.f.confirm_data(draft))
        status=self.f.sender.status(self.f.source)
        self.assertFalse(status['available'])
        self.assertTrue(status['safety']['paused'])
        self.assertEqual(status['safety']['reasonCode'],'journal_unavailable')
        self.assertEqual(status['safety']['unresolvedCount'],0)
        self.assertFalse(any(call[0]=='POST' for call in self.f.calls))
        with closing(sqlite3.connect(self.f.sender.path)) as db:
            db.execute('DROP TRIGGER synthetic_latch_failure');db.commit()
        self.f.sender.resume_safety(self.f.source,status['safety']['version'],True)
        self.assertEqual(self.f.sender.confirm(self.f.confirm_data(draft))['status'],'blocked')
        self.f.now+=31
        fresh=self.f.sender.prepare({**self.f.data,'idempotencyKey':'synthetic-after-journal-repair'})
        self.assertEqual(self.f.sender.confirm(self.f.confirm_data(fresh))['status'],'server_accepted')

    def test_post_dispatch_result_write_failure_immediately_pauses_as_unknown(self):
        draft=self.f.sender.prepare(self.f.data)
        with closing(sqlite3.connect(self.f.sender.path)) as db:
            db.execute("CREATE TRIGGER synthetic_result_failure BEFORE UPDATE OF status ON hook_drafts "
                "WHEN NEW.status='server_accepted' BEGIN SELECT RAISE(ABORT,'synthetic result write failure'); END")
            db.commit()
        with self.assertRaises(sqlite3.Error):self.f.sender.confirm(self.f.confirm_data(draft))
        status=self.f.sender.status(self.f.source)
        self.assertTrue(status['safety']['paused'])
        self.assertEqual(status['safety']['reasonCode'],'outcome_unknown')
        self.assertEqual(status['safety']['unresolvedCount'],1)
        self.assertEqual(self.f.sender.get(draft['draftId'],self.f.source)['status'],'unknown')
        self.assertEqual(sum(call[0]=='POST' for call in self.f.calls),1)
        with closing(sqlite3.connect(self.f.sender.path)) as db:
            db.execute('DROP TRIGGER synthetic_result_failure');db.commit()
        self.f.sender.resume_safety(self.f.source,status['safety']['version'],True)
        self.assertEqual(self.f.sender.confirm(self.f.confirm_data(draft))['status'],'unknown')
        self.assertEqual(sum(call[0]=='POST' for call in self.f.calls),1)


class NativeJournalFailureTests(unittest.TestCase):
    def fixture(self,kind):
        if kind=='text':
            import test_windows_hook_bridge as native
            f=native.RepeatableBridgeTests()
        else:
            import test_windows_hook_smoke as native
            f=native.SmokeTests()
        f.setUp();self.addCleanup(f.tearDown)
        return f

    def test_both_native_entry_points_pause_before_dispatch_on_initial_latch_failure(self):
        for kind,table in [('text','attempts'),('smoke','attempt')]:
            with self.subTest(entry=kind):
                f=self.fixture(kind)
                with closing(sqlite3.connect(f.bridge.path)) as db:
                    db.execute(f"CREATE TRIGGER synthetic_initial_failure BEFORE INSERT ON {table} "
                        "BEGIN SELECT RAISE(ABORT,'synthetic initial write failure'); END");db.commit()
                with self.assertRaises(sqlite3.Error):f.bridge.send(f.request())
                safety=f.bridge.safety.status(f.native.binding)
                self.assertTrue(safety['paused']);self.assertEqual(safety['reasonCode'],'journal_unavailable')
                self.assertEqual(safety['unresolvedCount'],0)
                self.assertEqual(f.native.calls if kind=='text' else f.native.submissions,[] if kind=='text' else 0)

    def test_both_native_entry_points_pause_as_unknown_on_final_result_write_failure(self):
        for kind,table in [('text','attempts'),('smoke','attempt')]:
            with self.subTest(entry=kind):
                f=self.fixture(kind)
                with closing(sqlite3.connect(f.bridge.path)) as db:
                    db.execute(f"CREATE TRIGGER synthetic_final_failure BEFORE UPDATE ON {table} "
                        "WHEN json_extract(NEW.response,'$.status')='submitted' "
                        "BEGIN SELECT RAISE(ABORT,'synthetic final write failure'); END");db.commit()
                with self.assertRaises(sqlite3.Error):f.bridge.send(f.request())
                safety=f.bridge.safety.status(f.native.binding)
                self.assertTrue(safety['paused']);self.assertEqual(safety['reasonCode'],'outcome_unknown')
                self.assertEqual(safety['unresolvedCount'],1)
                self.assertEqual(sum(call[0]=='submit' for call in f.native.calls) if kind=='text' else f.native.submissions,1)


if __name__=='__main__':unittest.main()
