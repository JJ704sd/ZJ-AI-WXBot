"""Exportable diagnostics must preserve causes without exporting user data."""
from pathlib import Path
import json
import tempfile
import unittest
import zipfile
from unittest.mock import patch

import offline_startup as startup


class Diagnostics50Tests(unittest.TestCase):
    def test_cli_export_does_not_load_or_create_account_profile(self):
        from local_chat_app import main
        with tempfile.TemporaryDirectory(prefix='synthetic-diag50-cli-') as temp:
            base=Path(temp);target=base/'cli.zip';profile=base/'not-created'
            with patch.object(startup,'_path',None),patch.dict('os.environ',{'LOCALAPPDATA':temp}):
                self.assertEqual(main(['--client','wecom','--data-dir',str(profile),'--export-diagnostics',str(target)]),0)
            self.assertFalse(profile.exists())
            with zipfile.ZipFile(target) as bundle:self.assertEqual(json.loads(bundle.read('diagnostics.json'))['current']['release'],'v52')

    def test_disk_logging_failure_preserves_in_memory_failure_for_export(self):
        with tempfile.TemporaryDirectory(prefix='synthetic-diag50-') as temp:
            base=Path(temp);blocked=base/'file';blocked.write_text('not a folder')
            with patch.object(startup,'_path',blocked/'events.jsonl'):
                startup.operation('parse')
                try:raise ValueError('secret-body')
                except ValueError as error:startup.failure(error)
                result=startup.export_bundle(base/'fallback.zip',{'release':'v50'})
                self.assertTrue(result['coverage']['diskWriteFailed'])
                with zipfile.ZipFile(base/'fallback.zip') as bundle:
                    text=bundle.read('events.jsonl').decode()
                    self.assertIn('ValueError',text);self.assertNotIn('secret-body',text)

    def test_legacy_logs_are_sanitized_and_damaged_lines_reported(self):
        with tempfile.TemporaryDirectory(prefix='synthetic-diag50-') as temp:
            base=Path(temp);log=base/'startup-old.jsonl'
            log.write_text(json.dumps({'event':'ui_callback_error','exceptionType':'KeyError',
                'message':'secret-old-message','password':'secret-old-password',
                'frames':[{'file':'C:/private-name/runtime.py','line':20,'function':'run','locals':'secret-locals'}]})+'\n{broken',encoding='utf8')
            with patch.object(startup,'_path',log):result=startup.export_bundle(base/'legacy.zip',{'release':'v50','account':'secret-account'})
            self.assertEqual(result['coverage']['malformedLines'],1)
            with zipfile.ZipFile(base/'legacy.zip') as bundle:
                text=''.join(bundle.read(n).decode() for n in bundle.namelist())
                for value in ['secret-old-message','secret-old-password','secret-locals','private-name','secret-account']:self.assertNotIn(value,text)
                self.assertIn('runtime.py',text)

    def test_threads_keep_their_own_stage_and_failure_position(self):
        import threading
        with tempfile.TemporaryDirectory(prefix='synthetic-diag50-') as temp:
            base=Path(temp);log=base/'startup-parallel.jsonl'
            barrier=threading.Barrier(2)
            def worker(position,stage):
                startup.operation('parse',position=position,total=2)
                startup.progress({'stage':stage,'processed':position})
                barrier.wait()
                try:raise RuntimeError('synthetic')
                except RuntimeError as error:startup.failure(error)
            with patch.object(startup,'_path',log):
                threads=[threading.Thread(target=worker,args=(1,'media_search')),threading.Thread(target=worker,args=(2,'saving'))]
                for t in threads:t.start()
                for t in threads:t.join(5);self.assertFalse(t.is_alive())
            rows=[json.loads(line) for line in log.read_text().splitlines()]
            errors=[r for r in rows if r['event']=='operation_failed']
            self.assertEqual({r['position']:r['stage'] for r in errors},{1:'media_search',2:'saving'})

    def test_export_keeps_failure_context_and_omits_exception_secrets(self):
        with tempfile.TemporaryDirectory(prefix='synthetic-diag50-') as temp:
            base=Path(temp)
            with patch.object(startup,'_path',None),patch.dict('os.environ',{'LOCALAPPDATA':temp}):
                startup.begin(None,'wecom')
                startup.operation('parse',target='synthetic-secret-group',position=3,total=10)
                startup.progress({'stage':'media_search','processed':25,'files':3909,'chatName':'secret-chat-body'})
                try:raise PermissionError(13,'password=secret-password C:/secret-user/private.db')
                except PermissionError as error:startup.failure(error)
                target=base/'diagnostics.zip'
                startup.export_bundle(target,{'release':'v50','client':'wecom','selected':10,'failed':1})
                with zipfile.ZipFile(target) as bundle:
                    events=[json.loads(line) for line in bundle.read('events.jsonl').decode().splitlines()]
                    failed=next(event for event in events if event['event']=='operation_failed')
                    self.assertEqual(failed['exceptionType'],'PermissionError')
                    self.assertEqual(failed['stage'],'media_search')
                    self.assertEqual(failed['processed'],25)
                    self.assertEqual(failed['position'],3)
                    self.assertEqual(failed['errno'],13)
                    self.assertTrue(failed['frames'])
                    text='\n'.join(bundle.read(n).decode('utf8') for n in bundle.namelist())
                    for secret in ['synthetic-secret-group','secret-chat-body','secret-password','secret-user','private.db']:
                        self.assertNotIn(secret,text)
                    self.assertIn('v50',text)
                    self.assertIsNone(bundle.testzip())


class DiagnosticsUI50Tests(unittest.TestCase):
    def test_top_button_exports_while_busy_without_changing_queue_and_cancel_is_noop(self):
        import tkinter as tk
        from local_chat_app import ChatApp
        from offline_desktop import DesktopSession
        with tempfile.TemporaryDirectory(prefix='synthetic-diag50-ui-') as temp:
            base=Path(temp);root=tk.Tk()
            try:
                app=ChatApp(root,DesktopSession(base/'profile',client='wecom'))
                for token in root.tk.call('after','info'):root.after_cancel(token)
                app.batch_running=app.busy=True;app.batch_queue=['synthetic-group'];app.batch_ids=['synthetic-group']
                app.batch_succeeded=[];app.batch_failed=[]
                app.update_buttons();root.geometry('1000x700');root.update()
                self.assertFalse(app.diagnostics_button.instate(['disabled']))
                self.assertTrue(app.diagnostics_button.winfo_ismapped())
                self.assertLessEqual(app.diagnostics_button.winfo_rootx()+app.diagnostics_button.winfo_width(),root.winfo_rootx()+root.winfo_width())
                with patch('local_chat_app.filedialog.asksaveasfilename',return_value=''):
                    app.diagnostics_button.invoke()
                self.assertEqual(list(base.glob('*.zip')),[])
                target=base/'logs.zip'
                with patch('local_chat_app.filedialog.asksaveasfilename',return_value=str(target)),patch('local_chat_app.messagebox.showinfo'):
                    app.diagnostics_button.invoke()
                with zipfile.ZipFile(target) as bundle:
                    info=json.loads(bundle.read('diagnostics.json'))
                    self.assertTrue(info['current']['busy']);self.assertEqual(info['current']['queued'],1)
                self.assertEqual(app.batch_queue,['synthetic-group']);self.assertTrue(app.busy)
            finally:
                for token in root.tk.call('after','info'):root.tk.call('after','cancel',token)
                root.destroy()

    def test_worker_failure_is_exported_with_identifier_and_stage(self):
        import time
        import tkinter as tk
        from local_chat_app import ChatApp
        from offline_desktop import DesktopSession
        with tempfile.TemporaryDirectory(prefix='synthetic-diag50-ui-') as temp:
            base=Path(temp);root=tk.Tk()
            try:
                app=ChatApp(root,DesktopSession(base/'profile',client='wecom'))
                for token in root.tk.call('after','info'):root.after_cancel(token)
                def fail():
                    app.report_operation_progress({'stage':'media_search','processed':42})
                    raise KeyError('secret-field')
                app.work('合成失败',fail,lambda _:None,diagnostic={'target':'secret-target','position':2,'total':3})
                deadline=time.monotonic()+5
                while app.events.empty() and time.monotonic()<deadline:time.sleep(.01)
                _,_,issue,_=app.events.get_nowait()
                self.assertIn('诊断编号',issue)
                target=base/'worker.zip';app.export_diagnostics_to(target)
                with zipfile.ZipFile(target) as bundle:
                    rows=[json.loads(line) for line in bundle.read('events.jsonl').decode().splitlines()]
                    row=next(r for r in reversed(rows) if r.get('exceptionType')=='KeyError' and r.get('position')==2)
                    self.assertEqual(row['stage'],'media_search');self.assertEqual(row['processed'],42)
                    self.assertIn(row['faultId'],issue)
                    self.assertNotIn('secret-field',bundle.read('events.jsonl').decode())
            finally:
                for token in root.tk.call('after','info'):root.tk.call('after','cancel',token)
                root.destroy()


if __name__=='__main__':unittest.main()
