"""Public GUI launch requests, using synthetic records and an owned Tk window."""
import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest

from test_database_adapter import create_metadata, create_shard


class NamedOpenTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix='offline-open-test-')
        self.addCleanup(self.temp.cleanup)
        self.base = Path(self.temp.name)
        self.source = self.base / 'source'
        self.source.mkdir()
        create_metadata(self.source)
        create_shard(self.source, rows=[{'text': '短句启动合成记录'}])
        self.directory = self.base / 'user-data'
        self.directory.mkdir()
        self.project = Path(__file__).resolve().parents[1]
        self.env = os.environ.copy()
        self.env['PYTHONPATH'] = os.pathsep.join(str(self.project / p) for p in ('.runtime/offline-build-deps', 'web_mvp', 'scripts'))

    def test_named_gui_request_exports_and_opens_the_same_result(self):
        (self.directory / 'settings.local.json').write_text(json.dumps({'version': 1, 'source': {'sourceRoot': str(self.source)}}), encoding='utf-8')
        receipt = self.directory / 'requests/open.json'
        check = self.base / 'check.json'
        process = subprocess.run([sys.executable, str(self.project / 'scripts/local_chat_app.py'),
            '--data-dir', str(self.directory), '--open-chat-name', '合成普通群',
            '--open-result-json', str(receipt), '--check-launch', str(check)],
            env=self.env, capture_output=True, timeout=30)
        self.assertEqual(process.returncode, 0, process.stderr.decode('utf-8', errors='replace'))
        result = json.loads(receipt.read_text(encoding='utf-8'))
        self.assertEqual(result['state'], 'completed')
        self.assertEqual(result['exportedRows'], 1)
        self.assertEqual(result['businessRows'], 1)
        self.assertEqual(result['viewRoot'], result['output'])
        self.assertEqual(set(result['exportFiles']), {'jsonl', 'json', 'md'})
        self.assertTrue(all(Path(value).is_file() for value in result['exportFiles'].values()))
        self.assertTrue((Path(result['output']) / '业务阅读.txt').is_file())
        self.assertTrue(json.loads(check.read_text(encoding='utf-8'))['parseAndOpen'])

    def test_first_setup_keeps_request_until_save_then_opens_without_a_second_prompt(self):
        # Exercise the actual data dialog's Save button in this owned synthetic UI.
        code = '''
import json,sys,tkinter as tk
from pathlib import Path
from local_chat_app import ChatApp
from offline_desktop import DesktopSession
root=tk.Tk()
base,source=map(Path,sys.argv[1:])
app=ChatApp(root,DesktopSession(base),open_chat_name='合成普通群',open_result=base/'requests/open.json')
def choose_data():
    dialogs=[w for w in root.winfo_children() if isinstance(w,tk.Toplevel)]
    if not dialogs:
        root.after(50,choose_data);return
    widgets=[]
    def walk(w):
        for child in w.winfo_children():widgets.append(child);walk(child)
    walk(dialogs[0])
    entry=next(w for w in widgets if w.winfo_class()=='TEntry')
    entry.delete(0,'end');entry.insert(0,str(source))
    next(w for w in widgets if w.winfo_class()=='TButton' and w.cget('text')=='保存并加载').invoke()
def done():
    path=base/'requests/open.json'
    if path.is_file() and json.loads(path.read_text(encoding='utf-8')).get('state')=='completed':root.destroy()
    else:root.after(50,done)
root.after(50,choose_data);root.after(50,done);root.after(20000,root.destroy)
root.mainloop()
'''
        process = subprocess.run([sys.executable, '-c', code, str(self.directory), str(self.source)],
            env=self.env, capture_output=True, timeout=25)
        self.assertEqual(process.returncode, 0, process.stderr.decode('utf-8', errors='replace'))
        result = json.loads((self.directory / 'requests/open.json').read_text(encoding='utf-8'))
        self.assertEqual(result['state'], 'completed')
        self.assertEqual(result['chatName'], '合成普通群')
        self.assertEqual(result['exportedRows'], 1)
        self.assertTrue((self.directory / 'settings.local.json').is_file())

    def test_completed_receipt_never_labels_files_or_emoji_as_images(self):
        create_shard(self.source, 'message/message_1.db', rows=[
            {'local': 2, 'type': 3, 'text': '<msg><img/></msg>'},
            {'local': 3, 'type': 49, 'text': '<msg><appmsg><type>6</type><title>absent.pdf</title></appmsg></msg>'},
            {'local': 4, 'type': 47, 'text': '<msg><emoji/></msg>'}])
        (self.directory / 'settings.local.json').write_text(json.dumps({'version': 1, 'source': {'sourceRoot': str(self.source)}}), encoding='utf-8')
        receipt = self.directory / 'requests/media.json'
        process = subprocess.run([sys.executable, str(self.project / 'scripts/local_chat_app.py'),
            '--data-dir', str(self.directory), '--open-chat-name', '合成普通群',
            '--open-result-json', str(receipt), '--check-launch', str(self.base / 'media-check.json')],
            env=self.env, capture_output=True, timeout=30)
        self.assertEqual(process.returncode, 0, process.stderr.decode('utf-8', errors='replace'))
        result = json.loads(receipt.read_text(encoding='utf-8'))
        self.assertEqual(result['state'], 'completed')
        self.assertEqual(result['mediaSummary']['images']['total'], 1)
        self.assertEqual(result['mediaSummary']['images']['missing'], 1)
        self.assertEqual(result['mediaSummary']['attachments']['total'], 1)
        self.assertEqual(result['mediaSummary']['emoji']['total'], 1)
        self.assertIn('图片引用 1 处', result['mediaSummaryText'])
        self.assertNotIn('mediaStatuses', result)
        reporting = result['reporting']
        self.assertEqual(Path(reporting['markdownFile']).read_text(encoding='utf-8'), reporting['replyMarkdown'])
        self.assertIn(result['mediaSummaryText'], reporting['replyMarkdown'])
        self.assertIn('附件类型（按引用）：.pdf 1处', reporting['replyMarkdown'])
        for path in result['exportFiles'].values():
            self.assertIn(path, reporting['presentation']['files'])
        self.assertTrue(all(Path(path).is_file() for path in reporting['presentation']['files']))

    def test_first_setup_autofills_unique_account_and_auto_button_continues_request(self):
        code = '''
import json,sys,tkinter as tk
from pathlib import Path
from local_chat_app import ChatApp
from offline_chat import discover
from offline_desktop import DesktopSession
root=tk.Tk()
base,source=map(Path,sys.argv[1:])
session=DesktopSession(base)
session.scan=lambda:discover([source.parent])
app=ChatApp(root,session,open_chat_name='合成普通群',open_result=base/'requests/auto.json')
def choose():
    dialogs=[w for w in root.winfo_children() if isinstance(w,tk.Toplevel)]
    if not dialogs:root.after(50,choose);return
    widgets=[]
    def walk(w):
        for child in w.winfo_children():widgets.append(child);walk(child)
    walk(dialogs[0])
    entry=next(w for w in widgets if w.winfo_class()=='TEntry')
    assert Path(entry.get()).resolve()==source.resolve()
    next(w for w in widgets if w.winfo_class()=='TButton' and w.cget('text')=='一键自动配置').invoke()
def done():
    path=base/'requests/auto.json'
    if path.is_file() and json.loads(path.read_text(encoding='utf-8')).get('state')=='completed':root.destroy()
    else:root.after(50,done)
root.after(50,choose);root.after(50,done);root.after(20000,root.destroy)
root.mainloop()
'''
        account = self.base / 'account/db_storage'
        account.mkdir(parents=True)
        create_metadata(account)
        create_shard(account, rows=[{'text': '首次自动配置记录'}])
        process = subprocess.run([sys.executable, '-c', code, str(self.directory), str(account)],
            env=self.env, capture_output=True, timeout=25)
        self.assertEqual(process.returncode, 0, process.stderr.decode('utf-8', errors='replace'))
        result = json.loads((self.directory / 'requests/auto.json').read_text(encoding='utf-8'))
        self.assertEqual(result['state'], 'completed')
        self.assertEqual(result['exportedRows'], 1)


if __name__ == '__main__':
    unittest.main()
