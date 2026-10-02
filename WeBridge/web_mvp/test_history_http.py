"""HTTP history acceptance against invented SQLite data, never native WeChat."""
from contextlib import closing
from datetime import datetime, timedelta, timezone
import http.client
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
import json
from pathlib import Path
import sqlite3
import tempfile
import threading
from types import SimpleNamespace
import unittest
from unittest.mock import patch
from urllib.parse import urlencode

from backend import Engine, Store
from database_adapter import DatabaseAdapter
from execution_history import history
from media_host import MediaCache
from server import LoginFlow, make_handler
from test_database_adapter import create_metadata, create_shard, GROUP, MIXED


class HistoryHttpTests(unittest.TestCase):
    def setUp(self):
        temp=tempfile.TemporaryDirectory(prefix='webridge-synthetic-history-http-')
        self.addCleanup(temp.cleanup)
        self.root=Path(temp.name)
        snapshot=self.root/'snapshot'
        create_metadata(snapshot)
        self.stamp=int(datetime(2026,10,2,tzinfo=timezone(timedelta(hours=8))).timestamp())
        create_shard(snapshot,rows=[
            {'local':1,'server':1,'time':self.stamp+1,'text':'历史 Needle one'},
            {'local':2,'server':2,'time':self.stamp+2,'text':'历史 Needle two'},
            {'local':3,'server':3,'time':self.stamp+3,'text':'不同正文'},
            {'local':4,'server':4,'time':self.stamp+86400,'text':'历史 Needle tomorrow'},
        ])
        self.store=Store(self.root/'runtime/state.sqlite')
        self.adapter=DatabaseAdapter(snapshot)
        self.engine=Engine(self.store,self.adapter)
        self.engine.refresh_connection()
        self.account=self.engine.account
        self.engine.set_watched(self.account,[GROUP])
        self.hook=SimpleNamespace(path=self.store.path.parent/'hook.sqlite')
        with closing(sqlite3.connect(self.hook.path)) as db,db:
            db.execute('CREATE TABLE hook_drafts(id TEXT PRIMARY KEY,request,expires,status,result)')
        with closing(sqlite3.connect(self.store.path.parent/'windows-auto-reply.sqlite')) as db,db:
            db.execute('CREATE TABLE events(id TEXT PRIMARY KEY,account,group_id,created,status,result)')
        self.service=SimpleNamespace(lock=threading.RLock())
        self.server=ThreadingHTTPServer(('127.0.0.1',0),BaseHTTPRequestHandler)
        self.port=self.server.server_port
        self.server.RequestHandlerClass=make_handler(self.engine,LoginFlow(self.engine),'test-csrf',self.port,
            media_cache=MediaCache(self.engine,self.root/'media'),database_service=self.service,hook_sender=self.hook)
        self.thread=threading.Thread(target=self.server.serve_forever,daemon=True)
        self.thread.start()
        self.addCleanup(self.stop_server)

    def stop_server(self):
        self.server.shutdown()
        self.server.server_close()
        self.thread.join(timeout=5)
        self.assertFalse(self.thread.is_alive())

    def get(self,path,**params):
        if params:path+='?'+urlencode(params)
        with closing(http.client.HTTPConnection('127.0.0.1',self.port,timeout=5)) as connection:
            connection.request('GET',path)
            response=connection.getresponse()
            data=response.read()
            if 'application/json' in response.getheader('Content-Type',''):
                data=json.loads(data)
            return response.status,data

    def draft(self,id,*,created=None,text='历史 Needle',status='failed',key='manual',account=None,target=GROUP):
        stamp=self.stamp+10 if created is None else created
        request={'account':self.account if account is None else account,'targetId':target,
                 'text':text,'idempotencyKey':key,'sourceRoot':'PRIVATE_SOURCE_PATH'}
        result={'submittedAtEpoch':stamp,'baselineMessageIds':['PRIVATE_BASELINE_ID']}
        with closing(sqlite3.connect(self.hook.path)) as db,db:
            db.execute('INSERT INTO hook_drafts VALUES(?,?,?,?,?)',
                (id,json.dumps(request),stamp+120,status,json.dumps(result)))

    def execution(self,**params):
        return self.get('/api/execution-history',**({'account':self.account}|params))

    def messages(self,**params):
        return self.get('/api/message-history',**({'account':self.account,'groupId':GROUP}|params))

    def assert_history_locks(self):
        self.assertIsNot(self.engine.lock,self.engine.sync_lock)
        self.assertTrue(self.engine.sync_lock.locked())
        self.assertTrue(self.engine.lock._is_owned())
        self.assertTrue(self.service.lock._is_owned())

    def test_execution_filters_and_cursor_reach_real_sqlite_query(self):
        self.draft('wanted-new',created=self.stamp+10)
        self.draft('wanted-old',created=self.stamp+9)
        self.draft('wrong-query',created=self.stamp+20,text='不匹配正文')
        self.draft('wrong-status',created=self.stamp+30,status='prepared')
        self.draft('before',created=self.stamp-1)
        self.draft('after',created=self.stamp+86400)
        self.draft('wrong-account',account='another',created=self.stamp+50)
        self.draft('unwatched',target=MIXED,created=self.stamp+60)
        self.draft('reply-draft',key='reply_http',created=self.stamp+40)
        with closing(sqlite3.connect(self.store.path.parent/'windows-auto-reply.sqlite')) as db,db:
            db.execute('INSERT INTO events VALUES(?,?,?,?,?,?)',
                ('wrong-source',self.account,GROUP,self.stamp+40,'failed',json.dumps({'draftId':'reply-draft'})))
        filters={'query':'历史 NEEDLE','source':'manual','status':'attention','startDate':'2026-10-02','endDate':'2026-10-02','limit':1}
        def locked_query(*args,**kwargs):
            self.assert_history_locks()
            return history(*args,**kwargs)
        with patch('execution_history.history',side_effect=locked_query) as query,patch.object(self.adapter,'call',side_effect=AssertionError('execution queries must not call adapters')):
            status,first=self.execution(**filters)
            self.assertEqual(status,200)
            self.assertEqual([r['id'] for r in first['records']],['wanted-new'])
            self.assertTrue(first['hasMore']);self.assertTrue(first['nextCursor'])
            expected={**filters,'limit':'1'}
            query.assert_called_once_with(self.engine,self.hook,**expected)
            status,second=self.execution(**filters,cursor=first['nextCursor'])
            self.assertEqual(status,200)
            self.assertEqual([r['id'] for r in second['records']],['wanted-old'])
            self.assertFalse(second['hasMore']);self.assertEqual(second['nextCursor'],'')
            self.assertEqual(query.call_args.kwargs['cursor'],first['nextCursor'])
            self.assertNotIn('PRIVATE',json.dumps(first)+json.dumps(second))

    def test_execution_invalid_filters_are_400(self):
        for params in ({'query':'x'*201},{'source':'unknown'},{'status':'unknown'},
                       {'startDate':'2026-2-01'},{'endDate':'2026-02-30'},
                       {'startDate':'2026-10-03','endDate':'2026-10-02'},
                       {'cursor':'bad-cursor'},{'cursor':'x'*4097},{'limit':0},{'limit':2001}):
            with self.subTest(params=params):
                status,body=self.execution(**params)
                self.assertEqual(status,400);self.assertIn('error',body)

    def test_execution_account_and_revoked_cursor_are_rejected(self):
        self.draft('one');self.draft('two')
        status,page=self.execution(limit=1)
        self.assertEqual(status,200)
        self.assertTrue(page['nextCursor'])
        self.assertEqual(self.execution(account='wrong')[0],400)
        self.assertEqual(self.get('/api/execution-history')[0],400)
        self.engine.set_watched(self.account,[])
        self.assertEqual(self.execution(limit=1,cursor=page['nextCursor'])[0],400)
        status,current=self.execution()
        self.assertEqual(status,200);self.assertEqual(current['records'],[])

    def test_message_filters_cursor_and_locks_reach_real_snapshot_adapter(self):
        filters={'query':'NEEDLE','startDate':'2026-10-02','endDate':'2026-10-02','limit':1}
        original=self.adapter.call
        def locked_call(action,**params):
            self.assert_history_locks()
            return original(action,**params)
        with patch.object(self.adapter,'call',side_effect=locked_call) as call:
            status,first=self.messages(**filters)
            self.assertEqual(status,200)
            self.assertEqual([m['text'] for m in first['messages']],['历史 Needle two'])
            self.assertTrue(first['hasMore'])
            call.assert_called_once_with('message_history',account=self.account,groupId=GROUP,**(filters|{'limit':'1'}))
            status,second=self.messages(**filters,cursor=first['nextCursor'])
            self.assertEqual(status,200)
            self.assertEqual([m['text'] for m in second['messages']],['历史 Needle one'])
            self.assertFalse(second['hasMore'])
            self.assertEqual(call.call_args.kwargs['cursor'],first['nextCursor'])

    def test_message_invalid_filters_are_400(self):
        for params in ({'query':'x'*201},{'query':'two\nlines'},{'startDate':'2026-02-30'},
                       {'startDate':'2026-10-03','endDate':'2026-10-02'},
                       {'cursor':'bad-cursor'},{'limit':0},{'limit':2001},
                       {'limit':'01'},{'limit':'0001'},{'limit':'+1'},{'limit':'1.0'},{'limit':' 1 '}):
            with self.subTest(params=params):
                status,body=self.messages(**params)
                self.assertEqual(status,400);self.assertIn('error',body)

    def test_message_wrong_account_and_unwatched_target_never_call_adapter(self):
        with patch.object(self.adapter,'call',side_effect=AssertionError('scope must be checked before adapter')) as call:
            for params in ({'account':'wrong'},{'groupId':MIXED},{'groupId':'unknown'}):
                with self.subTest(params=params):self.assertEqual(self.messages(**params)[0],400)
            self.engine.set_watched(self.account,[])
            self.assertEqual(self.messages()[0],400)
            call.assert_not_called()

    def test_message_history_requires_database_mode_before_adapter_call(self):
        self.engine.read_only=False
        with patch.object(self.adapter,'call',side_effect=AssertionError('database-only endpoint')) as call:
            status,body=self.messages()
            self.assertEqual(status,400)
            self.assertIn('Windows',body['error'])
            call.assert_not_called()

    def test_history_scripts_and_entry_page_are_served(self):
        for path,marker in (('/execution_ui.js',b'loadExecutionPage'),
                            ('/message_history_ui.js',b'messageHistoryAvailable')):
            with self.subTest(path=path):
                status,body=self.get(path)
                self.assertEqual(status,200);self.assertIn(marker,body)
        status,body=self.get('/')
        self.assertEqual(status,200)
        self.assertIn(b'/message_history_ui.js',body)
        self.assertIn(b'execution-start-date',body)
        self.assertIn(b'history-dialog',body)


if __name__=='__main__':unittest.main()
