"""Selected Beijing weekdays with synthetic clocks and recording transport."""
from contextlib import closing
from datetime import datetime
import hashlib
import json
import sqlite3
import unittest

import test_windows_scheduler as fixtures
from windows_scheduler import BEIJING


class WeeklySchedulerTests(unittest.TestCase):
    def setUp(self):
        self.base = fixtures.SchedulerTests()
        self.base.setUp()
        self.addCleanup(self.base.doCleanups)
        self.f = self.base.f
        self.scheduler = self.base.scheduler

    def data(self, **changes):
        return self.base.data(**{'mode':'weekly', 'clock':'10:00', 'weekdays':[1, 3, 5], **changes})

    def job(self):
        return self.scheduler.list(self.f.account)[0]

    def runs(self):
        with closing(sqlite3.connect(self.scheduler.path)) as db:
            return db.execute('SELECT due,status FROM runs ORDER BY due').fetchall()

    def at(self, value):
        return datetime.fromisoformat(value).replace(tzinfo=BEIJING).timestamp()

    def test_selected_weekdays_skip_weekend_and_send_next_monday_once(self):
        self.f.now = self.at('2026-10-02T10:00')  # Friday, exactly at the requested clock.
        job = self.scheduler.create(self.data())
        self.assertEqual(job['weekdays'], [1, 3, 5])
        self.assertEqual(job['nextRun'], self.at('2026-10-05T10:00'))
        self.f.now = self.at('2026-10-04T10:00')
        self.scheduler.tick()
        self.assertEqual(self.job()['runs'], [])
        self.assertEqual(self.f.posts, [])
        self.f.now = job['nextRun']
        self.scheduler.tick()
        self.scheduler.tick()
        self.assertEqual(len(self.f.posts), 1)
        self.assertEqual(self.job()['nextRun'], self.at('2026-10-07T10:00'))

    def test_canonical_weekdays_preserve_request_identity_and_frozen_spec(self):
        job = self.scheduler.create(self.data(weekdays=[5, 1, 3]))
        self.assertEqual(job['weekdays'], [1, 3, 5])
        repeated = self.scheduler.create(self.data(weekdays=[3, 5, 1]))
        self.assertEqual(repeated['id'], job['id'])
        with self.assertRaises(ValueError):
            self.scheduler.create(self.data(weekdays=[1, 5]))
        with closing(sqlite3.connect(self.scheduler.path)) as db:
            payload = json.loads(db.execute('SELECT payload FROM schedules').fetchone()[0])
        self.assertEqual(payload['weekdays'], [1, 3, 5])
        self.assertEqual(payload['spec']['weekdays'], [1, 3, 5])
        self.assertEqual(len(self.scheduler.list(self.f.account)), 1)

    def test_weekday_input_is_validated_before_creating_a_task(self):
        for weekdays in (None, [], [True], [0], [8], [1.0], ['1'], [1, 1], (1, 3), {}):
            with self.subTest(weekdays=weekdays), self.assertRaises(ValueError):
                self.scheduler.create(self.data(weekdays=weekdays))
        for mode in ('once', 'daily'):
            with self.subTest(mode=mode), self.assertRaises(ValueError):
                self.scheduler.create(self.data(mode=mode, weekdays=None))
        self.assertEqual(self.scheduler.list(self.f.account), [])
        self.assertEqual(self.f.posts, [])

    def test_legacy_once_and_daily_payloads_keep_exact_request_spec(self):
        for mode, expected_days in (('once', []), ('daily', list(range(1, 8)))):
            data = self.base.data(mode=mode, clock='10:01', requestId='legacy-mode-request-'+mode)
            job = self.scheduler.create(data)
            self.assertEqual(job['weekdays'], expected_days)
            self.assertEqual(self.scheduler.create(data)['id'], job['id'])
            with closing(sqlite3.connect(self.scheduler.path)) as db:
                payload = json.loads(db.execute('SELECT payload FROM schedules WHERE id=?', (job['id'],)).fetchone()[0])
            self.assertNotIn('weekdays', payload)
            self.assertEqual(payload['spec'], {'groupId':self.f.group, 'text':data['text'], 'mode':mode,
                'clock':'10:01' if mode=='daily' else '', 'at':'2026-09-28T10:01' if mode=='once' else ''})

    def test_multiweek_gap_records_only_selected_dates_and_sends_final_120_second_occurrence(self):
        self.scheduler.create(self.data(clock='10:01'))
        self.f.now = self.at('2026-10-14T10:03')
        self.scheduler.tick()
        expected_dates = ('2026-09-28', '2026-09-30', '2026-10-02', '2026-10-05',
                          '2026-10-07', '2026-10-09', '2026-10-12')
        self.assertEqual(self.runs(), [(self.at(day+'T10:01'), 'missed') for day in expected_dates]+
                         [(self.at('2026-10-14T10:01'), 'submitted_unconfirmed')])
        self.assertEqual(len(self.f.posts), 1)
        self.assertEqual(self.job()['nextRun'], self.at('2026-10-16T10:01'))
        self.f.now = self.at('2026-10-15T10:01')  # Thursday creates no extra occurrence.
        self.scheduler.tick()
        self.assertEqual(len(self.runs()), 8)
        self.assertEqual(len(self.f.posts), 1)

    def test_nonselected_observation_date_records_prior_due_without_sending(self):
        self.scheduler.create(self.data(clock='10:01', weekdays=[1]))
        self.f.now = self.at('2026-10-06T10:01')  # Tuesday after two missed Mondays.
        self.scheduler.tick()
        self.assertEqual(self.runs(), [(self.at(day+'T10:01'), 'missed')
                                      for day in ('2026-09-28', '2026-10-05')])
        self.assertEqual(self.f.posts, [])
        self.assertEqual(self.job()['nextRun'], self.at('2026-10-12T10:01'))

    def test_121_seconds_is_missed_but_midnight_does_not_shorten_120_second_window(self):
        self.f.now = self.at('2026-10-02T23:58')
        job = self.scheduler.create(self.data(clock='23:59', weekdays=[5]))
        self.f.now = self.at('2026-10-03T00:01')
        self.scheduler.tick()
        # Weekdays apply to the due date, even when the 120-second window ends
        # after midnight on a day that has no scheduled occurrence of its own.
        self.assertEqual(self.runs(), [(job['nextRun'], 'submitted_unconfirmed')])
        self.assertEqual(len(self.f.posts), 1)
        self.assertEqual(self.job()['nextRun'], self.at('2026-10-09T23:59'))
        self.f.now = self.at('2026-10-10T00:01')+1
        self.scheduler.tick()
        self.assertEqual(self.runs()[-1], (self.at('2026-10-09T23:59'), 'missed'))
        self.assertEqual(len(self.f.posts), 1)

    def test_pause_and_restart_resume_from_strictly_future_selected_day(self):
        job = self.scheduler.create(self.data())
        self.scheduler.action(self.f.account, job['id'], 'pause')
        self.f.now = self.at('2026-10-02T10:00')
        resumed = self.scheduler.action(self.f.account, job['id'], 'resume')
        self.assertEqual(resumed['nextRun'], self.at('2026-10-05T10:00'))
        self.scheduler = self.base.new()
        self.assertFalse(self.job()['enabled'])
        self.f.now = self.at('2026-10-10T10:00')
        self.scheduler.tick()
        self.assertEqual(self.runs(), [])
        resumed = self.scheduler.action(self.f.account, job['id'], 'resume')
        self.assertEqual(resumed['nextRun'], self.at('2026-10-12T10:00'))
        self.f.now = resumed['nextRun']
        self.scheduler.tick()
        self.assertEqual(self.runs(), [(resumed['nextRun'], 'submitted_unconfirmed')])
        self.assertEqual(len(self.f.posts), 1)

    def test_unknown_result_resumes_only_future_selected_day(self):
        job = self.scheduler.create(self.data(clock='10:01', weekdays=[1]))
        self.f.now = job['nextRun']
        self.f.outcome = 'timeout'
        self.scheduler.tick()
        self.assertEqual(self.runs(), [(job['nextRun'], 'unknown')])
        resumed = self.scheduler.action(self.f.account, job['id'], 'resume')
        self.scheduler.tick()
        self.assertEqual(resumed['nextRun'], self.at('2026-10-05T10:01'))
        self.assertEqual(len(self.f.posts), 1)
        self.assertEqual(self.runs(), [(job['nextRun'], 'unknown')])

    def test_old_unknown_and_run_ids_survive_gap_reconciliation(self):
        job = self.scheduler.create(self.data(clock='10:01'))
        # A durable claim can predate a saved schedule checkpoint. Reconciliation
        # must retain that exact run ID and unknown outcome rather than retry it.
        run_id = hashlib.sha256((job['id']+'|'+str(int(job['nextRun']))).encode()).hexdigest()
        with closing(sqlite3.connect(self.scheduler.path)) as db, db:
            db.execute('INSERT INTO runs VALUES (?,?,?,?,?,?)',
                       (run_id, job['id'], job['nextRun'], self.f.now, 'unknown', '{}'))
        self.f.now = self.at('2026-10-07T10:01')
        self.scheduler.tick()
        self.assertEqual(self.runs(), [(self.at('2026-09-28T10:01'), 'unknown'),
            (self.at('2026-09-30T10:01'), 'missed'), (self.at('2026-10-02T10:01'), 'missed'),
            (self.at('2026-10-05T10:01'), 'missed'), (self.at('2026-10-07T10:01'), 'submitted_unconfirmed')])
        self.assertEqual(len(self.f.posts), 1)

    def test_existing_final_claim_is_not_submitted_again(self):
        job = self.scheduler.create(self.data(clock='10:01'))
        run_id = hashlib.sha256((job['id']+'|'+str(int(job['nextRun']))).encode()).hexdigest()
        with closing(sqlite3.connect(self.scheduler.path)) as db, db:
            db.execute('INSERT INTO runs VALUES (?,?,?,?,?,?)',
                       (run_id, job['id'], job['nextRun'], self.f.now, 'unknown', '{}'))
        self.f.now = job['nextRun']
        self.scheduler.tick()
        self.assertEqual(self.runs(), [(job['nextRun'], 'unknown')])
        self.assertFalse(self.job()['enabled'])
        self.assertEqual(self.f.posts, [])

    def test_final_claim_failure_rolls_back_all_missed_records_before_submission(self):
        self.scheduler.create(self.data(clock='10:01'))
        self.f.now = self.at('2026-10-07T10:01')
        with closing(sqlite3.connect(self.scheduler.path)) as db, db:
            db.executescript(f"""CREATE TRIGGER fail_final_claim BEFORE INSERT ON runs
                WHEN NEW.due={self.f.now}
                BEGIN SELECT RAISE(FAIL,'synthetic final claim failure'); END;""")
        with self.assertRaisesRegex(sqlite3.DatabaseError, 'synthetic final claim failure'):
            self.scheduler.tick()
        self.assertEqual(self.runs(), [])
        self.assertEqual(self.f.posts, [])

    def test_twenty_year_gap_has_only_selected_days_in_complete_ledger(self):
        self.scheduler.create(self.data(clock='10:01'))
        self.f.now = self.at('2046-09-28T10:01')
        self.scheduler.tick()
        runs = self.runs()
        # Inclusive Monday 2026-09-28 to Friday 2046-09-28 is 1043 full weeks
        # plus Mon-Fri: three selected days per full week and three at the end.
        self.assertEqual(len(runs), 3132)
        self.assertEqual(sum(status=='missed' for _, status in runs), 3131)
        self.assertEqual(runs[-1], (self.f.now, 'submitted_unconfirmed'))
        self.assertTrue(all(datetime.fromtimestamp(due, BEIJING).isoweekday() in (1, 3, 5) for due, _ in runs))
        self.assertEqual(len(self.f.posts), 1)


if __name__ == '__main__':
    unittest.main()
