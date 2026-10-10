"""Scoped schedule pauses against synthetic state and recording transport."""
from contextlib import closing
import json
import sqlite3
import threading
import unittest
from unittest.mock import patch

import test_windows_scheduler as fixtures


class ObservedLock:
    """Expose a worker's attempt to enter the source lock without timing sleeps."""
    def __init__(self, lock, arrivals, gates=None):
        self.lock, self.arrivals, self.gates = lock, arrivals, gates or {}

    def __enter__(self):
        name = threading.current_thread().name
        if name in self.arrivals:
            self.arrivals[name].set()
        if name in self.gates and not self.gates[name].wait(5):
            raise TimeoutError('synthetic source-lock gate was not released')
        return self.lock.__enter__()

    def __exit__(self, *args):
        return self.lock.__exit__(*args)


class SchedulePauseTests(unittest.TestCase):
    def setUp(self):
        self.f = fixtures.SchedulerTests()
        self.f.setUp()
        self.addCleanup(self.f.doCleanups)
        self.scheduler, self.state = self.f.scheduler, self.f.f

    def create(self, index, **changes):
        return self.scheduler.create(self.f.data(requestId=f'synthetic-bulk-pause-{index:03d}', **changes))

    def worker(self, name, action):
        results, errors = [], []
        def run():
            try: results.append(action())
            except Exception as error: errors.append(error)
        thread = threading.Thread(target=run, name=name)
        thread.start()
        return thread, results, errors

    def join(self, thread):
        thread.join(5)
        self.assertFalse(thread.is_alive(), 'synthetic worker failed to finish')

    def saved(self):
        with closing(sqlite3.connect(self.scheduler.path)) as db:
            return (db.execute('SELECT rowid,id,account,payload FROM schedules ORDER BY rowid').fetchall(),
                    db.execute('SELECT * FROM runs ORDER BY id').fetchall())

    def test_account_pause_needs_no_source_or_hook_and_can_resume_individually(self):
        first = self.create(1)
        second = self.create(2, mode='daily', clock='10:01')
        source_config = self.state.source.config
        self.state.source.config = None
        self.state.source.busy = True
        self.state.source.error = 'synthetic disconnected source'
        with patch.object(self.scheduler, 'sender_factory', side_effect=AssertionError('pause must not probe Hook')):
            result = self.scheduler.pause_scope(self.state.account)
        self.assertEqual(result['pausedCount'], 2)
        self.assertEqual({job['id'] for job in result['jobs']}, {first['id'], second['id']})
        self.assertTrue(all(not job['enabled'] and job['state']=='paused' for job in result['jobs']))
        self.assertTrue(all(job['issue']=='已手动批量暂停。' for job in result['jobs']))
        self.assertEqual(self.scheduler.pause_scope(self.state.account)['pausedCount'], 0)
        self.assertEqual(self.state.posts, [])
        self.state.source.config = source_config
        self.state.source.busy = False
        self.state.source.error = ''
        self.assertTrue(self.scheduler.action(self.state.account, first['id'], 'resume')['enabled'])
        self.assertTrue(self.create(3)['enabled'])

    def test_group_pause_waits_for_current_daily_then_prevents_next_job(self):
        current = self.create(1, mode='daily', clock='10:01')
        queued = self.create(2)
        self.state.engine.group_list.append({'id':'filehelper', 'name':'文件传输助手'})
        self.state.engine.store.set_watched(self.state.account, [self.state.group, 'filehelper'])
        other = self.create(3, groupId='filehelper')
        self.state.now = current['nextRun']
        entered, release, pause_waiting = threading.Event(), threading.Event(), threading.Event()
        self.state.source.lock = ObservedLock(self.state.source.lock, {'pause':pause_waiting})
        send = self.state.sender.send_automatic
        def blocked_send(*args, **kwargs):
            entered.set()
            if not release.wait(5): raise TimeoutError('synthetic send was not released')
            return send(*args, **kwargs)
        with patch.object(self.state.sender, 'send_automatic', side_effect=blocked_send):
            ticker, _, tick_errors = self.worker('tick', self.scheduler.tick)
            try:
                self.assertTrue(entered.wait(5))
                pauser, results, pause_errors = self.worker('pause',
                    lambda:self.scheduler.pause_scope(self.state.account, self.state.group))
                self.assertTrue(pause_waiting.wait(5))
            finally:
                release.set()
                self.join(ticker)
            self.join(pauser)
        self.assertEqual(tick_errors+pause_errors, [])
        self.assertEqual(len(self.state.posts), 1)
        self.assertEqual(results[0]['pausedCount'], 2)
        jobs = {job['id']:job for job in results[0]['jobs']}
        self.assertFalse(jobs[current['id']]['enabled'])
        self.assertFalse(jobs[queued['id']]['enabled'])
        self.assertTrue(jobs[other['id']]['enabled'])
        self.state.now += 5
        self.scheduler.tick()
        self.assertEqual([post['targetId'] for post in self.state.posts], [self.state.group, 'filehelper'])

    def test_account_pause_does_not_count_inflight_once_that_finishes(self):
        current = self.create(1)
        queued = self.create(2)
        self.state.now = current['nextRun']
        entered, release, pause_waiting = threading.Event(), threading.Event(), threading.Event()
        self.state.source.lock = ObservedLock(self.state.source.lock, {'pause':pause_waiting})
        send = self.state.sender.send_automatic
        def blocked_send(*args, **kwargs):
            entered.set()
            if not release.wait(5): raise TimeoutError('synthetic send was not released')
            return send(*args, **kwargs)
        with patch.object(self.state.sender, 'send_automatic', side_effect=blocked_send):
            ticker, _, tick_errors = self.worker('tick', self.scheduler.tick)
            try:
                self.assertTrue(entered.wait(5))
                pauser, results, pause_errors = self.worker('pause',lambda:self.scheduler.pause_scope(self.state.account))
                self.assertTrue(pause_waiting.wait(5))
            finally:
                release.set()
                self.join(ticker)
            self.join(pauser)
        self.assertEqual(tick_errors+pause_errors, [])
        self.assertEqual(len(self.state.posts), 1)
        self.assertEqual(results[0]['pausedCount'], 1)
        jobs = {job['id']:job for job in results[0]['jobs']}
        self.assertEqual(jobs[current['id']]['state'], 'finished')
        self.assertEqual(jobs[queued['id']]['state'], 'paused')

    def test_scope_changes_only_enabled_jobs_and_preserves_payload_order_and_runs(self):
        self.state.engine.group_list.append({'id':'filehelper', 'name':'文件传输助手'})
        self.state.engine.store.set_watched(self.state.account, [self.state.group, 'filehelper'])
        jobs = [self.create(1), self.create(2, groupId='filehelper')]
        jobs += [self.create(index) for index in range(3,8)]
        with closing(sqlite3.connect(self.scheduler.path)) as db, db:
            for job,state in zip(jobs[2:6], ('paused','cancelled','finished','paused')):
                db.execute("""UPDATE schedules SET payload=json_set(payload,'$.enabled',json('false'),
                    '$.state',?,'$.issue','existing issue') WHERE id=?""", (state,job['id']))
            db.execute("""UPDATE schedules SET account='database:other',
                payload=json_set(payload,'$.account','database:other') WHERE id=?""", (jobs[6]['id'],))
            db.execute('INSERT INTO runs VALUES (?,?,?,?,?,?)',
                ('existing-unknown',jobs[5]['id'],jobs[5]['nextRun'],self.state.now,'unknown','{"issue":"existing unknown"}'))
        before, runs = self.saved()
        # Pausing a saved target remains available after it leaves the reading scope.
        self.state.engine.store.set_watched(self.state.account, ['filehelper'])
        result = self.scheduler.pause_scope(self.state.account, self.state.group)
        self.assertEqual(result['pausedCount'], 1)
        after, after_runs = self.saved()
        self.assertEqual(after_runs, runs)
        self.assertEqual(after[1:], before[1:])
        self.assertEqual(after[0][:3], before[0][:3])
        changed = json.loads(before[0][3])
        changed.update(enabled=False, state='paused', issue='已手动批量暂停。')
        self.assertEqual(json.loads(after[0][3]), changed)
        self.assertEqual([job['id'] for job in result['jobs']], [job['id'] for job in reversed(jobs[:6])])
        self.assertEqual(self.scheduler.pause_scope(self.state.account)['pausedCount'], 1)
        self.assertEqual(self.saved()[0][-1], before[-1])

    def test_invalid_request_changes_nothing_and_does_not_leave_pause_pending(self):
        job = self.create(1)
        before = self.saved()
        for group in (None, [], 10, 'x'*257):
            with self.subTest(group=group), self.assertRaises(ValueError):
                self.scheduler.pause_scope(self.state.account, group)
        for account in (None, '', 'database:other'):
            with self.subTest(account=account), self.assertRaises(ValueError):
                self.scheduler.pause_scope(account)
        self.assertEqual(self.saved(), before)
        self.state.now = job['nextRun']
        self.scheduler.tick()
        self.assertEqual(len(self.state.posts), 1)

    def test_database_failure_rolls_back_whole_batch_and_releases_pause(self):
        first, second = self.create(1), self.create(2,text='另一独立计划正文')
        before = self.saved()
        with closing(sqlite3.connect(self.scheduler.path)) as db, db:
            db.executescript(f"""CREATE TRIGGER fail_bulk_pause BEFORE UPDATE ON schedules
                WHEN NEW.id='{second['id']}'
                BEGIN SELECT RAISE(FAIL,'synthetic bulk pause failure'); END;""")
        with self.assertRaisesRegex(sqlite3.DatabaseError, 'synthetic bulk pause failure'):
            self.scheduler.pause_scope(self.state.account)
        self.assertEqual(self.saved(), before)
        with closing(sqlite3.connect(self.scheduler.path)) as db, db:
            db.execute('DROP TRIGGER fail_bulk_pause')
        self.state.now = first['nextRun']
        original = self.state.transport
        def spaced_transport(method,path,payload=None):
            result=original(method,path,payload)
            if method=='POST':self.state.now+=5
            return result
        with patch.object(self.state.sender,'transport',side_effect=spaced_transport):self.scheduler.tick()
        self.assertEqual(len(self.state.posts), 2)

    def test_account_change_during_wait_rejects_only_that_request(self):
        first = self.create(1)
        self.state.engine.group_list.append({'id':'filehelper', 'name':'文件传输助手'})
        self.state.engine.store.set_watched(self.state.account, [self.state.group, 'filehelper'])
        other = self.create(2, groupId='filehelper')
        self.state.now = first['nextRun']
        before = self.saved()
        first_waiting, second_waiting, release_second = threading.Event(), threading.Event(), threading.Event()
        source_lock = self.state.source.lock
        self.state.source.lock = ObservedLock(source_lock,
            {'pause-first':first_waiting, 'pause-second':second_waiting}, {'pause-second':release_second})
        try:
            with source_lock:
                first_thread, _, first_errors = self.worker('pause-first',
                    lambda:self.scheduler.pause_scope(self.state.account))
                self.assertTrue(first_waiting.wait(5))
                second_thread, results, second_errors = self.worker('pause-second',
                    lambda:self.scheduler.pause_scope(self.state.account, 'filehelper'))
                self.assertTrue(second_waiting.wait(5))
                with self.state.engine.lock:
                    self.state.engine.account = 'database:changed-while-waiting'
            self.join(first_thread)
            self.assertEqual(len(first_errors), 1)
            self.assertIsInstance(first_errors[0], ValueError)
            self.assertIn('账号已变化', str(first_errors[0]))
            self.assertEqual(self.saved(), before)
            with self.state.engine.lock:
                self.state.engine.account = self.state.account
            # The first request's finally must not erase the second pending request.
            self.scheduler.tick()
            self.assertEqual(self.state.posts, [])
        finally:
            release_second.set()
            self.join(second_thread)
        self.assertEqual(second_errors, [])
        self.assertEqual(results[0]['pausedCount'], 1)
        jobs = {job['id']:job for job in results[0]['jobs']}
        self.assertFalse(jobs[other['id']]['enabled'])
        self.assertTrue(jobs[first['id']]['enabled'])
        self.scheduler.tick()
        self.assertEqual([post['targetId'] for post in self.state.posts], [self.state.group])


if __name__ == '__main__':
    unittest.main()
