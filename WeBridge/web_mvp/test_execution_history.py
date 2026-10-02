"""Synthetic SQLite and HTTP checks; no credentials, native reads or sends."""
from contextlib import closing
from datetime import datetime, timedelta, timezone
import hashlib
from http.server import ThreadingHTTPServer
import http.client
import json
from pathlib import Path
import sqlite3
import tempfile
import threading
from types import SimpleNamespace
import unittest
from unittest.mock import patch
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

    def draft(self,id,account='a',target='g',key='manual',status='submitted_unconfirmed',text='合成正文',created=200,issue=''):
        request=dict(account=account,targetId=target,text=text,idempotencyKey=key,sourceRoot='PRIVATE_PATH',selfId='PRIVATE_SELF')
        with closing(sqlite3.connect(self.hook.path)) as db, db:
            db.execute('INSERT INTO hook_drafts VALUES(?,?,?,?,?)',(id,json.dumps(request),created+120,status,json.dumps({'submittedAtEpoch':created,'baselineMessageIds':['PRIVATE_ID'],'issue':issue})))

    def reply(self,id,created=200,status='submitted_unconfirmed',draft=None,target='g',account='a'):
        with closing(sqlite3.connect(self.root/'windows-auto-reply.sqlite')) as db, db:
            db.execute('INSERT INTO events VALUES(?,?,?,?,?,?)',
                (id,account,target,created,status,json.dumps({'draftId':draft} if draft else {})))

    def schedule(self,id,created=200,status='missed',draft=None,text='冻结计划正文'):
        with closing(sqlite3.connect(self.root/'windows-schedules.sqlite')) as db, db:
            db.execute('INSERT INTO schedules VALUES(?,?,?)',(id,'a',json.dumps({'group_id':'g','text':text})))
            db.execute('INSERT INTO runs VALUES(?,?,?,?,?)',
                (id,id,created,status,json.dumps({'draftId':draft} if draft else {})))

    def many_drafts(self,count=2105):
        request=json.dumps(dict(account='a',targetId='g',text='较新普通正文',idempotencyKey='manual'))
        with closing(sqlite3.connect(self.hook.path)) as db, db:
            db.executemany('INSERT INTO hook_drafts VALUES(?,?,?,?,?)',
                [('new-'+str(i),request,1000+i+120,'prepared',json.dumps({'submittedAtEpoch':1000+i})) for i in range(count)])

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

    def test_reply_trigger_projects_only_public_snapshot_fields(self):
        detail={'replyText':'执行时的话术','decision':'cooldown_skipped','sourceRoot':'PRIVATE_ROOT',
                'trigger':{'messageId':'incoming','serverId':'123','senderId':'contact',
                           'senderName':'业务联系人','timestamp':100,'text':'原业务请求','textTruncated':False,
                           'nativeBinding':'PRIVATE_BINDING'}}
        with closing(sqlite3.connect(self.root/'windows-auto-reply.sqlite')) as db, db:
            db.execute('INSERT INTO events VALUES(?,?,?,?,?,?)',('triggered','a','g',200,'cooldown_skipped',json.dumps(detail)))
        result=history(self.engine,self.hook,source='reply',query='原业务请求')
        self.assertEqual(len(result['records']),1)
        record=result['records'][0]
        self.assertEqual(record['text'],'执行时的话术');self.assertFalse(record['textUnavailable'])
        self.assertEqual(record['trigger']['senderName'],'业务联系人')
        self.assertIs(record['trigger']['textTruncated'],False)
        self.assertEqual(record['decision'],'cooldown_skipped')
        self.assertNotIn('PRIVATE',json.dumps(result))

    def test_bounded_history_and_scope_revocation(self):
        for i in range(205):self.draft(str(i))
        result=history(self.engine,self.hook)
        self.assertEqual(len(result['records']),200);self.assertTrue(result['truncated'])
        expanded=history(self.engine,self.hook,limit=500)
        self.assertEqual(len(expanded['records']),205);self.assertFalse(expanded['truncated'])
        self.assertEqual(len(history(self.engine,self.hook,limit=2000)['records']),205)
        self.store.set_watched('a',[])
        self.assertEqual(history(self.engine,self.hook)['records'],[])

    def test_history_limit_rejects_unbounded_or_invalid_values(self):
        for value in (0,-1,2001,'all','1.5',True):
            with self.assertRaises(ValueError):history(self.engine,self.hook,limit=value)

    def test_missing_file_is_not_created_and_readonly(self):
        absent=self.root/'absent.sqlite'
        self.assertEqual(read_rows(absent,'SELECT 1',()),[]);self.assertFalse(absent.exists())
        with self.assertRaises(sqlite3.OperationalError):read_rows(self.hook.path,'DELETE FROM hook_drafts',())

    def test_query_finds_history_older_than_2000_and_literal_casefold(self):
        self.many_drafts()
        self.draft('old-match',created=5,text='过去 STRASSE 100%_ 正文')
        rows=history(self.engine,self.hook,limit=1,query='straße 100%_')['records']
        self.assertEqual([r['id'] for r in rows],['old-match'])
        self.assertEqual(history(self.engine,self.hook,query='100%X')['records'],[])
        self.assertEqual(history(self.engine,self.hook,query="' OR 1=1 --")['records'],[])
        self.assertEqual(len(history(self.engine,self.hook,query='合成群',limit=2)['records']),2)

    def test_exact_old_draft_body_and_final_status_precede_filtering(self):
        self.many_drafts()
        self.draft('historic-reply',key='reply_historical',status='local_record_confirmed',text='历史回复正文',created=1,issue='历史回读结果')
        self.draft('historic-schedule',key='schedule_historical',status='failed',text='历史计划正文',created=2,issue='历史失败结果')
        self.reply('recent-reply',created=9000,status='blocked',draft='historic-reply')
        self.schedule('recent-schedule',created=8999,status='submitted_unconfirmed',draft='historic-schedule',text='当前任务正文')
        rows=history(self.engine,self.hook,limit=1,source='reply',status='pending',query='历史回复正文')['records']
        self.assertEqual([r['id'] for r in rows],['reply:recent-reply'])
        self.assertEqual(rows[0]['status'],'local_record_confirmed')
        self.assertEqual(rows[0]['issue'],'历史回读结果')
        self.assertEqual(history(self.engine,self.hook,source='reply',status='attention')['records'],[])
        rows=history(self.engine,self.hook,limit=1,source='schedule',status='attention',query='历史计划正文')['records']
        self.assertEqual([r['id'] for r in rows],['schedule:recent-schedule'])
        self.assertEqual(rows[0]['issue'],'历史失败结果')
        self.assertEqual(history(self.engine,self.hook,source='schedule',status='pending')['records'],[])

    def test_automatic_filters_search_beyond_recent_2000_records(self):
        self.draft('old-reply-draft',created=1,key='reply_old',text='稀有历史回复',status='failed')
        self.reply('old',created=1,draft='old-reply-draft')
        self.schedule('old',created=1,text='稀有历史计划',status='missed')
        with closing(sqlite3.connect(self.root/'windows-auto-reply.sqlite')) as db,db:
            db.executemany('INSERT INTO events VALUES(?,?,?,?,?,?)',
                [('new-'+str(i),'a','g',1000+i,'cooldown_skipped','{}') for i in range(2105)])
        with closing(sqlite3.connect(self.root/'windows-schedules.sqlite')) as db,db:
            db.execute('INSERT INTO schedules VALUES(?,?,?)',('new','a',json.dumps({'group_id':'g','text':'新计划'})))
            db.executemany('INSERT INTO runs VALUES(?,?,?,?,?)',
                [('new-'+str(i),'new',1000+i,'cancelled','{}') for i in range(2105)])
        for source,word in [('reply','稀有历史回复'),('schedule','稀有历史计划')]:
            with self.subTest(source=source):
                rows=history(self.engine,self.hook,source=source,status='attention',query=word,limit=1)['records']
                self.assertEqual([r['id'] for r in rows],[source+':old'])

    def test_cross_source_keyset_pages_same_second_and_newer_insert(self):
        for id in ('m1','m2'):self.draft(id)
        for id in ('r1','r2'):self.reply(id)
        for id in ('s1','s2'):self.schedule(id)
        expected=sorted(['m1','m2','reply:r1','reply:r2','schedule:s1','schedule:s2'],reverse=True)
        first=history(self.engine,self.hook,limit=2)
        self.assertTrue(first['hasMore']);self.assertTrue(first['nextCursor'])
        self.draft('concurrent-new',created=201)
        found=[r['id'] for r in first['records']]
        page=first
        for _ in range(5):
            if not page['hasMore']:break
            page=history(self.engine,self.hook,limit=2,cursor=page['nextCursor'])
            found.extend(r['id'] for r in page['records'])
        self.assertEqual(found,expected)
        self.assertFalse(page['hasMore']);self.assertFalse(page['truncated']);self.assertEqual(page['nextCursor'],'')

    def test_beijing_dates_include_both_days_and_exclude_following_midnight(self):
        stamp=datetime(2026,10,2,tzinfo=timezone(timedelta(hours=8))).timestamp()
        for id,created in [('before',stamp-0.01),('first',stamp),('last',stamp+86400-0.01),('next',stamp+86400)]:
            self.draft(id,created=created)
        rows=history(self.engine,self.hook,startDate='2026-10-02',endDate='2026-10-02')['records']
        self.assertEqual([r['id'] for r in rows],['last','first'])
        self.assertEqual([r['id'] for r in history(self.engine,self.hook,endDate='2026-10-01')['records']],['before'])
        self.assertEqual([r['id'] for r in history(self.engine,self.hook,startDate='2026-10-03')['records']],['next'])

    def test_cursor_rejects_query_account_and_read_scope_changes(self):
        self.draft('a');self.draft('b')
        cursor=history(self.engine,self.hook,limit=1)['nextCursor']
        for changed in ({'query':'正文'},{'source':'manual'},{'status':'pending'},
                        {'startDate':'1970-01-01'},{'endDate':'2026-10-02'},{'limit':2}):
            with self.subTest(changed=changed),self.assertRaises(ValueError):
                history(self.engine,self.hook,**({'limit':1,'cursor':cursor}|changed))
        self.engine.account='b'
        with self.assertRaises(ValueError):history(self.engine,self.hook,limit=1,cursor=cursor)
        self.engine.account='a'
        self.store.set_watched('a',[])
        with self.assertRaises(ValueError):history(self.engine,self.hook,limit=1,cursor=cursor)
        self.assertEqual(history(self.engine,self.hook)['records'],[])
        self.store.set_watched('a',['g'])
        with self.assertRaises(ValueError):history(self.engine,self.hook,limit=1,cursor=cursor)

    def test_invalid_queries_and_cursors(self):
        for fields in ({'query':'x'*201},{'query':None},{'source':'bad'},{'status':'bad'},
                       {'startDate':'2026-2-01'},{'endDate':'2026-02-30'},
                       {'startDate':'2026-10-03','endDate':'2026-10-02'},
                       {'cursor':'x'*4097},{'cursor':'not-a-cursor'},{'cursor':None}):
            with self.subTest(fields=fields),self.assertRaises(ValueError):history(self.engine,self.hook,**fields)
        self.draft('a');self.draft('b')
        cursor=history(self.engine,self.hook,limit=1)['nextCursor']
        damaged=cursor[:-1]+('0' if cursor[-1]!='0' else '1')
        with self.assertRaises(ValueError):history(self.engine,self.hook,limit=1,cursor=damaged)

    def test_auto_draft_join_cannot_cross_account_or_target(self):
        self.draft('other-account',account='b',key='reply_cross',text='PRIVATE_OTHER_ACCOUNT',status='failed')
        self.draft('other-target',target='hidden',key='reply_cross',text='PRIVATE_OTHER_TARGET',status='failed')
        self.reply('a',draft='other-account');self.reply('b',draft='other-target')
        result=history(self.engine,self.hook,source='reply')
        self.assertEqual(len(result['records']),2)
        self.assertTrue(all(r['textUnavailable'] and r['text']=='' and r['status']=='submitted_unconfirmed' for r in result['records']))
        self.assertNotIn('PRIVATE',json.dumps(result))

    def test_entire_query_is_read_only_and_does_not_use_sender_or_store_methods(self):
        self.draft('manual');self.reply('reply');self.schedule('schedule')
        before={p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in self.root.glob('*.sqlite')}
        original=sqlite3.connect
        def connect(database,*args,**kwargs):
            self.assertTrue(database==':memory:' or (database.startswith('file:') and database.endswith('?mode=ro')))
            return original(database,*args,**kwargs)
        with patch('execution_history.sqlite3.connect',side_effect=connect),patch.object(self.store,'rows',side_effect=AssertionError('write-capable store access')):
            self.assertEqual(len(history(self.engine,self.hook)['records']),3)
        after={p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in self.root.glob('*.sqlite')}
        self.assertEqual(before,after)
        missing=self.root/'never-created'
        engine=SimpleNamespace(account='a',store=SimpleNamespace(path=missing/'state.sqlite'),group_list=self.engine.group_list,read_only=True)
        self.assertEqual(history(engine,SimpleNamespace(path=missing/'hook.sqlite'))['records'],[])
        self.assertFalse(missing.exists())

    def test_non_windows_outbox_remains_filterable_and_scoped(self):
        self.engine.read_only=False
        self.store.enqueue('a','g','本机旧正文',[],origin='manual',id='old-item',now=100)
        self.store.enqueue('a','g','本机新正文',[],origin='reply',id='new-item',now=200)
        self.store.enqueue('b','g','PRIVATE_OTHER',[],id='hidden-item',now=300)
        rows=history(self.engine,query='旧正文',source='manual')['records']
        self.assertEqual([r['id'] for r in rows],['old-item'])

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
        for endpoint in ('/api/execution-history','/api/messages'):
            connection.request('GET',endpoint+'?account='+engine.account+'&limit=2001')
            response=connection.getresponse();self.assertEqual(response.status,400);response.read()
        connection.request('GET','/api/execution-history?account='+engine.account+'&limit=2000')
        response=connection.getresponse();self.assertEqual(response.status,200);self.assertEqual(json.loads(response.read())['limit'],2000)
        connection.request('GET','/execution_ui.js')
        response=connection.getresponse();self.assertEqual(response.status,200);self.assertIn(b'loadExecutionHistory',response.read())


if __name__=='__main__':unittest.main()
