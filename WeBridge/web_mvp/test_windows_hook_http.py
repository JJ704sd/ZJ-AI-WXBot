"""HTTP source/target boundaries, using invented SQLite and a recording sender."""
import http.client
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
import json
from pathlib import Path
import tempfile
import threading
import unittest
from unittest.mock import Mock

from backend import Engine, Store
from database_adapter import DatabaseAdapter
from database_service import DatabaseService
from server import LoginFlow, make_handler
from test_database_service import make_source


class HookHttpTests(unittest.TestCase):
    def setUp(self):
        self.temp=tempfile.TemporaryDirectory()
        self.root=Path(self.temp.name)
        make_source(self.root/'source')
        self.engine=Engine(Store(self.root/'state.sqlite'),DatabaseAdapter())
        self.database=DatabaseService(self.engine.adapter,self.root/'runtime',self.engine)
        self.database.configure({'sourceRoot':str(self.root/'source'),'selfId':'fixture-self'})
        self.database.worker.join(10)
        self.assertFalse(self.database.error)
        self.account=self.engine.account
        self.target='fixture@chatroom'
        self.engine.set_watched(self.account,[self.target])
        self.engine.selected=self.target
        self.sender=Mock()
        self.sender.prepare.return_value={'draftId':'test-draft','targetId':self.target,'status':'prepared'}
        self.sender.confirm.return_value={'targetId':self.target,'status':'submitted_unconfirmed'}
        self.sender.get.return_value={'targetId':self.target,'status':'prepared'}
        self.sender.status.return_value={'available':False,'status':'unsupported_version'}
        self.server=ThreadingHTTPServer(('127.0.0.1',0),BaseHTTPRequestHandler)
        self.port=self.server.server_port
        self.server.RequestHandlerClass=make_handler(self.engine,LoginFlow(self.engine),'csrf',self.port,
                                                    database_service=self.database,hook_sender=self.sender)
        self.thread=threading.Thread(target=self.server.serve_forever,daemon=True)
        self.thread.start()

    def tearDown(self):
        self.server.shutdown();self.server.server_close();self.thread.join()
        self.temp.cleanup()

    def request(self,method,path,body=None,**overrides):
        headers={'Origin':f'http://127.0.0.1:{self.port}','Content-Type':'application/json','X-CSRF-Token':'csrf'}
        headers.update(overrides)
        conn=http.client.HTTPConnection('127.0.0.1',self.port,timeout=5)
        try:
            conn.request(method,path,json.dumps(body) if body is not None else None,headers)
            response=conn.getresponse()
            return response.status,json.loads(response.read())
        finally:conn.close()

    def payload(self):
        return {'account':self.account,'groupId':self.target,'targetId':self.target,
                'text':'synthetic test','draftId':'test-draft','textHash':'fixture','targetConfirmed':True}

    def test_current_source_overwrites_browser_identity(self):
        body={**self.payload(),'selfId':'attacker','sourceId':'old-source','sourceRoot':'X:/wrong','targetName':'wrong'}
        code,_=self.request('POST','/api/windows/hook/prepare',body)
        self.assertEqual(code,200)
        actual=self.sender.prepare.call_args.args[0]
        self.assertEqual(actual['selfId'],'fixture-self')
        self.assertEqual(actual['sourceId'],self.account)
        self.assertEqual(actual['sourceRoot'],str(self.root/'source'))
        self.assertNotEqual(actual['targetName'],'wrong')
        self.assertEqual(self.engine.store.outbox(self.account),[])
        self.assertTrue(self.engine.read_only)

    def test_csrf_account_and_target_changes_never_submit(self):
        for route in ('prepare','confirm'):
            path='/api/windows/hook/'+route
            self.assertEqual(self.request('POST',path,self.payload(),**{'X-CSRF-Token':''})[0],403)
            for bad in ({'account':'old-account'},{'groupId':'wrong'},{'targetId':'wrong'}):
                self.assertEqual(self.request('POST',path,{**self.payload(),**bad})[0],400)
        self.sender.prepare.assert_not_called();self.sender.confirm.assert_not_called()

    def test_unselected_or_unwatched_target_and_busy_snapshot_block_send(self):
        self.engine.selected=None
        self.assertEqual(self.request('POST','/api/windows/hook/prepare',self.payload())[0],400)
        self.engine.selected=self.target
        self.engine.set_watched(self.account,[])
        self.assertEqual(self.request('POST','/api/windows/hook/prepare',self.payload())[0],400)
        self.engine.set_watched(self.account,[self.target])
        self.database.busy=True
        self.assertEqual(self.request('POST','/api/windows/hook/confirm',self.payload())[0],400)
        self.sender.prepare.assert_not_called();self.sender.confirm.assert_not_called()

    def test_draft_from_other_target_cannot_confirm(self):
        self.sender.get.return_value={'targetId':'other@chatroom'}
        self.assertEqual(self.request('POST','/api/windows/hook/confirm',self.payload())[0],400)
        self.sender.confirm.assert_not_called()

    def test_result_read_scoped_to_source_and_reconciles_only_server_ack(self):
        path='/api/windows/hook/attempt?draftId=test-draft&account='+self.account
        self.assertEqual(self.request('GET',path.replace(self.account,'old-account'))[0],400)
        self.sender.get.assert_not_called()
        self.assertEqual(self.request('GET',path)[0],200)
        self.sender.reconcile.assert_not_called()
        self.sender.get.return_value={'targetId':self.target,'serverAccepted':True,'localRecordConfirmed':False}
        self.sender.reconcile.return_value={'targetId':self.target,'status':'local_record_confirmed','delivered':False}
        code,result=self.request('GET',path)
        self.assertEqual(code,200);self.assertFalse(result['delivered'])
        args=self.sender.reconcile.call_args
        self.assertEqual(args.kwargs['target_id'],self.target)
        self.assertEqual(args.args[1][0]['serverId'],'9001')
        self.assertEqual(args.args[2]['account'],self.account)

    def test_status_host_boundary_and_source_binding(self):
        self.assertEqual(self.request('GET','/api/windows/hook/status',Host='external.invalid')[0],403)
        self.sender.status.assert_not_called()
        code,result=self.request('GET','/api/windows/hook/status')
        self.assertEqual(code,200);self.assertFalse(result['available'])
        self.assertEqual(self.sender.status.call_args.args[0]['selfId'],'fixture-self')


if __name__=='__main__':unittest.main()
