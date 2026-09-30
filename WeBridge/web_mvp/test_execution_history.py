"""Synthetic SQLite and HTTP checks; no credentials, native reads or sends."""
from contextlib import closing
from http.server import ThreadingHTTPServer
import http.client
import json
from pathlib import Path
import sqlite3
import tempfile
import threading
from types import SimpleNamespace
import unittest
from execution_history import history, read_rows
from backend import Engine, Store
from test_backend import FakeAdapter
from server import make_handler, LoginFlow


class HistoryTests(unittest.TestCase):
    def setUp(self):
        self.temp=tempfile.TemporaryDirectory();self.addCleanup(self.temp.cleanup)
        self.root=Path(self.temp.name)
        self.store=Store(self.root/'state.sqlite');self.store.set_watched('a',['g'])
        self.engine=SimpleNamespace(account='a',store=self.store,group_list=[{'id':'g','name':'合成群'},{'id':'hidden','name':'未勾选'}],read_only=True)
        self.hook=SimpleNamespace(path=self.root/'hook.sqlite')
        with closing(sqlite3.connect(self.hook.path)) as db, db:
            db.execute('CREATE TABLE hook_drafts(id,request,expires,status,result)')
        with closing(sqlite3.connect(self.root/'windows-auto-reply.sqlite')) as db, db:
            db.execute('CREATE TABLE events(id,account,group_id,created,status,result)')
        with closing(sqlite3.connect(self.root/'windows-schedules.sqlite')) as db, db:
            db.executescript('CREATE TABLE schedules(id,account,payload);CREATE TABLE runs(id,job_id,created,status,result);')

    def draft(self,id,account='a',target='g',key='manual',status='submitted_unconfirmed'):
        request=dict(account=account,targetId=target,text='合成正文',idempotencyKey=key,sourceRoot='PRIVATE_PATH',selfId='PRIVATE_SELF')
        with closing(sqlite3.connect(self.hook.path)) as db, db:
            db.execute('INSERT INTO hook_drafts VALUES(?,?,?,?,?)',(id,json.dumps(request),300,status,json.dumps({'submittedAtEpoch':200,'baselineMessageIds':['PRIVATE_ID']})))

    def test_account_scope_dedupe_and_public_fields(self):
        self.draft('m');self.draft('other',account='b');self.draft('hidden',target='hidden');self.draft('r',key='reply_event',status='local_record_observed')
        with closing(sqlite3.connect(self.root/'windows-auto-reply.sqlite')) as db, db:
            db.execute('INSERT INTO events VALUES(?,?,?,?,?,?)',('event','a','g',201,'submitted_unconfirmed',json.dumps({'draftId':'r'})))
        result=history(self.engine,self.hook)
        self.assertEqual(len(result['records']),2)
        self.assertEqual(result['records'][0]['source'],'reply')
        self.assertEqual(result['records'][0]['status'],'local_record_observed')
        self.assertTrue(all(row['pending'] and not row['delivered'] for row in result['records']))
        self.assertNotIn('PRIVATE',json.dumps(result))

    def test_schedule_and_missing_reply_snapshot(self):
        with closing(sqlite3.connect(self.root/'windows-schedules.sqlite')) as db, db:
            db.execute('INSERT INTO schedules VALUES(?,?,?)',('j','a',json.dumps({'group_id':'g','text':'原计划正文'})))
            db.execute('INSERT INTO runs VALUES(?,?,?,?,?)',('s','j',202,'missed','{}'))
        with closing(sqlite3.connect(self.root/'windows-auto-reply.sqlite')) as db, db:
            db.execute('INSERT INTO events VALUES(?,?,?,?,?,?)',('e','a','g',203,'blocked','{}'))
        rows=history(self.engine,self.hook)['records']
        self.assertTrue(rows[0]['textUnavailable']);self.assertEqual(rows[0]['text'],'')
        self.assertEqual(rows[1]['text'],'原计划正文');self.assertTrue(rows[1]['attention'])

    def test_bounded_history_and_scope_revocation(self):
        for i in range(205):self.draft(str(i))
        result=history(self.engine,self.hook)
        self.assertEqual(len(result['records']),200);self.assertTrue(result['truncated'])
        self.store.set_watched('a',[])
        self.assertEqual(history(self.engine,self.hook)['records'],[])

    def test_missing_file_is_not_created_and_readonly(self):
        absent=self.root/'absent.sqlite'
        self.assertEqual(read_rows(absent,'SELECT 1',()),[]);self.assertFalse(absent.exists())
        with self.assertRaises(sqlite3.OperationalError):read_rows(self.hook.path,'DELETE FROM hook_drafts',())

    def test_http_account_rejection_and_static_route(self):
        engine=Engine(self.store,FakeAdapter());engine.refresh_connection()
        server=ThreadingHTTPServer(('127.0.0.1',0),make_handler(engine,LoginFlow(engine),'fixture',0))
        # The handler validates the configured listening port.
        port=server.server_address[1]
        server.RequestHandlerClass=make_handler(engine,LoginFlow(engine),'fixture',port)
        thread=threading.Thread(target=server.serve_forever,daemon=True);thread.start()
        self.addCleanup(server.server_close);self.addCleanup(server.shutdown)
        connection=http.client.HTTPConnection('127.0.0.1',port);self.addCleanup(connection.close)
        connection.request('GET','/api/execution-history?account=wrong')
        response=connection.getresponse();self.assertEqual(response.status,400);response.read()
        connection.request('GET','/api/execution-history?account='+engine.account)
        response=connection.getresponse();self.assertEqual(response.status,200);self.assertIn('records',json.loads(response.read()))
        connection.request('GET','/execution_ui.js')
        response=connection.getresponse();self.assertEqual(response.status,200);self.assertIn(b'loadExecutionHistory',response.read())


if __name__=='__main__':unittest.main()
