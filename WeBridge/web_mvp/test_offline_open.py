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
    def test_export_actions_remain_visible_at_small_window_and_high_scaling(self):
        code = '''
import sys,tkinter as tk
from pathlib import Path
from local_chat_app import ChatApp
from offline_desktop import DesktopSession
root=tk.Tk()
root.tk.call('tk','scaling',1.75)
session=DesktopSession(Path(sys.argv[1]))
app=ChatApp(root,session)
for token in root.tk.call('after','info'):root.after_cancel(token)
root.update()
root.deiconify()
root.update()
app.status.set('本地记录已解析。'*30)
app.result_text.set('已生成 JSONL / JSON / MD。保存位置：'+'example/'*25)
app.chat_title.set('合成的长群聊名称与业务信息查看'*5)
for geometry in ('1200x760','1000x700'):
 root.geometry(geometry)
 root.update()
 app.toggle_date_filters(False)
 root.update()
 assert not app.date_frame.winfo_ismapped()
 folded_height=app.browser.winfo_height()
 assert folded_height>=250,(geometry,folded_height)
 assert app.sidebar.winfo_width()<root.winfo_width()*.34
 app.date_toggle_button.invoke()
 root.update()
 assert app.date_frame.winfo_ismapped() and app.browser.winfo_height()<folded_height
 for widget in (app.export_button,app.review_button,app.batch_review_button,app.batch_folder_button,*app.export_file_buttons.values(),app.folder_button,*app.date_controls,app.first_button,app.last_button,app.message_search_button,app.search_clear_button,app.group_id_entry,app.copy_current_id_button,app.next_review_button,app.parse_button,app.reparse_button):
  x,y=widget.winfo_rootx()-root.winfo_rootx(),widget.winfo_rooty()-root.winfo_rooty()
  assert widget.winfo_ismapped() and 0<=x and 0<=y and x+widget.winfo_width()<=root.winfo_width() and y+widget.winfo_height()<=root.winfo_height(),(geometry,widget.cget('text') if 'text' in widget.keys() else 'format',x,y)
output=session.directory/'synthetic-export';output.mkdir(parents=True)
for name in ('messages.jsonl','messages.json','messages.md'):(output/name).write_text('synthetic',encoding='utf8')
session.last_export=output
app.update_buttons()
opened=[]
import local_chat_app
local_chat_app.os.startfile=opened.append
for label in ('JSONL','JSON','Markdown'):
 app.export_file_buttons[label].invoke()
assert [Path(p).name for p in opened]==['messages.jsonl','messages.json','messages.md']
app.folder_button.invoke()
assert Path(opened[-1])==output
# An absent association falls back to the built-in viewer for this exact file.
from unittest.mock import patch
with patch('local_chat_app.os.startfile',side_effect=OSError),patch('local_chat_app.subprocess.Popen') as launch:
 app.export_file_buttons['JSONL'].invoke()
 assert Path(launch.call_args.args[0][-1])==output/'messages.jsonl'
(output/'messages.json').unlink();app.update_buttons()
assert app.export_file_buttons['JSON'].instate(['disabled'])
assert app.export_file_buttons['JSONL'].instate(['!disabled'])
app.start_date.set('2026-10-10')
picker=app.choose_date(app.start_date,'开始')
picker.update()
next(w for w in picker.days.winfo_children() if 'text' in w.keys() and w.cget('text')=='15').invoke()
assert app.start_date.get()=='2026-10-15'
app.end_date.set('2026-10-16')
selected=[]
app.active_chat='synthetic'
app.start_parse=lambda chat:selected.append((chat,app.start_date.get(),app.end_date.get()))
app.apply_date_button.invoke()
assert selected==[('synthetic','2026-10-15','2026-10-16')]
app.clear_date_button.invoke()
assert not app.start_date.get() and not app.end_date.get()
root.destroy()
'''
        process = subprocess.run([sys.executable, '-c', code, str(self.directory)],
            env=self.env, capture_output=True, timeout=20)
        self.assertEqual(process.returncode, 0, process.stderr.decode('utf-8', errors='replace'))

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
        self.assertEqual(result['state'], 'awaiting_review')
        self.assertEqual(result['exportedRows'], 1)
        self.assertEqual(result['businessRows'], 1)
        self.assertNotIn('exportFiles', result)
        self.assertNotIn('output', result)
        self.assertTrue((Path(result['viewRoot']) / 'messages.jsonl').is_file())
        self.assertFalse((self.directory / 'exports').exists())
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
    if path.is_file() and json.loads(path.read_text(encoding='utf-8')).get('state')=='awaiting_review':root.destroy()
    else:root.after(50,done)
root.after(50,choose_data);root.after(50,done);root.after(20000,root.destroy)
root.mainloop()
'''
        process = subprocess.run([sys.executable, '-c', code, str(self.directory), str(self.source)],
            env=self.env, capture_output=True, timeout=25)
        self.assertEqual(process.returncode, 0, process.stderr.decode('utf-8', errors='replace'))
        result = json.loads((self.directory / 'requests/open.json').read_text(encoding='utf-8'))
        self.assertEqual(result['state'], 'awaiting_review')
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
        self.assertEqual(result['state'], 'awaiting_review')
        self.assertEqual(result['mediaSummary']['images']['total'], 1)
        self.assertEqual(result['mediaSummary']['images']['missing'], 1)
        self.assertEqual(result['mediaSummary']['attachments']['total'], 1)
        self.assertEqual(result['mediaSummary']['emoji']['total'], 1)
        self.assertIn('图片引用 1 处', result['mediaSummaryText'])
        self.assertNotIn('mediaStatuses', result)
        self.assertNotIn('reporting', result)
        self.assertNotIn('exportFiles', result)
        self.assertFalse((self.directory / 'exports').exists())
        self.assertTrue((Path(result['viewRoot']) / 'messages.jsonl').is_file())

    def test_setup_dialog_stays_open_during_work_and_failures_then_continues_request(self):
        code = '''
import json,sys,threading,time,tkinter as tk
from pathlib import Path
from local_chat_app import ChatApp
from offline_desktop import DesktopSession
root=tk.Tk()
base,source=map(Path,sys.argv[1:])
session=DesktopSession(base)
session.scan=lambda:{'accounts':[]}
original=session.automatic_setup
gate=threading.Event()
attempts=iter(['needs_source','exception','success'])
def setup(config,**kwargs):
    assert gate.wait(5),'test did not release setup'
    attempt=next(attempts)
    if attempt=='needs_source':
        return {'status':'needs_source','message':'合成校验未通过，请重试。','config':config}
    if attempt=='exception':raise PermissionError('private-error-sentinel')
    return original(config,**kwargs)
session.automatic_setup=setup
app=ChatApp(root,session,open_chat_name='合成普通群',open_result=base/'requests/persistent.json')
def pump_until(predicate):
    deadline=time.monotonic()+10
    while not predicate():
        assert time.monotonic()<deadline,'UI timed out'
        root.update();time.sleep(.01)
def dialogs():return [w for w in root.winfo_children() if isinstance(w,tk.Toplevel)]
def widgets(parent):
    result=[]
    for child in parent.winfo_children():result.append(child);result.extend(widgets(child))
    return result
def visible_text(parent):
    result=[]
    for w in widgets(parent):
        if 'text' in w.keys():result.append(str(w.cget('text')))
        if 'textvariable' in w.keys() and w.cget('textvariable'):
            result.append(str(root.getvar(w.cget('textvariable'))))
    return '\\n'.join(result)
try:
    pump_until(lambda:bool(dialogs()))
    dialog=dialogs()[0]
    deadline=time.monotonic()+.5
    while time.monotonic()<deadline:root.update();time.sleep(.01)
    assert dialogs()==[dialog],'idle configuration dialog closed itself'
    entry=next(w for w in widgets(dialog) if w.winfo_class()=='TEntry')
    entry.delete(0,'end');entry.insert(0,str(source))
    button=next(w for w in widgets(dialog) if w.winfo_class()=='TButton' and w.cget('text')=='一键自动配置')
    for expected in ('合成校验未通过','文件访问被系统拒绝'):
        gate.clear();button.invoke();root.update()
        assert dialog.winfo_exists(),'configuration dialog closed while setup was running'
        assert button.instate(['disabled']),'duplicate setup remained enabled'
        assert '请稍候' in visible_text(dialog),'setup progress missing from dialog'
        root.tk.call(dialog.protocol('WM_DELETE_WINDOW'))
        root.update()
        assert dialog.winfo_exists(),'close interrupted active setup'
        gate.set();pump_until(lambda:not app.busy);root.update()
        assert dialogs()==[dialog],'failed setup replaced or closed the configuration dialog'
        assert expected in visible_text(dialog),'failure was not shown inside configuration dialog'
        assert 'private-error-sentinel' not in visible_text(dialog),'raw error leaked into UI'
        assert entry.get()==str(source),'selected source was lost after failure'
        assert button.instate(['!disabled']),'retry stayed disabled'
        assert json.loads((base/'requests/persistent.json').read_text(encoding='utf-8'))['state']=='needs_source'
    button.invoke()
    receipt=base/'requests/persistent.json'
    pump_until(lambda:receipt.is_file() and json.loads(receipt.read_text(encoding='utf-8')).get('state')=='awaiting_review')
    assert not dialog.winfo_exists(),'successful setup did not close configuration dialog'
    assert (base/'settings.local.json').is_file()
finally:
    gate.set();root.destroy()
'''
        process = subprocess.run([sys.executable, '-c', code, str(self.directory), str(self.source)],
            env=self.env, capture_output=True, timeout=40)
        self.assertEqual(process.returncode, 0, process.stderr.decode('utf-8', errors='replace'))
        result = json.loads((self.directory / 'requests/persistent.json').read_text(encoding='utf-8'))
        self.assertEqual(result['state'], 'awaiting_review')
        self.assertEqual(result['exportedRows'], 1)

    def test_running_account_recommendation_group_search_and_account_switch(self):
        second = self.base / 'second-account'
        second.mkdir()
        create_metadata(second)
        create_shard(second, rows=[{'text': '另一个账号的合成记录'}])
        code = '''
import sys,time,tkinter as tk
from pathlib import Path
from unittest.mock import patch
from local_chat_app import ChatApp
from offline_desktop import DesktopSession
from test_database_adapter import GROUP,SELF
root=tk.Tk()
base,first,second=map(lambda p:Path(p).resolve(),sys.argv[1:])
session=DesktopSession(base)
session.scan=lambda:{'accounts':[{'directoryLabel':label,'sourceRoot':str(source),
    'databases':[{'path':'contact/contact.db'}]} for label,source in [('旧账号',first),('当前账号',second)]]}
def owner(paths,client):return [(81,100)] if paths[0].parent.parent==second else []
boundary=patch('offline_accounts._windows_owners',owner)
boundary.start()
app=ChatApp(root,session)
def pump(predicate):
    deadline=time.monotonic()+10
    while not predicate():
        assert time.monotonic()<deadline,'UI timed out'
        root.update();time.sleep(.01)
def widgets(parent):
    result=[]
    for child in parent.winfo_children():result.append(child);result.extend(widgets(child))
    return result
def button(parent,text):return next(w for w in widgets(parent) if w.winfo_class()=='TButton' and w.cget('text')==text)
try:
    pump(lambda:app.source_dialog is not None)
    dialog=app.source_dialog
    chooser=next(w for w in widgets(dialog) if w.winfo_class()=='TCombobox')
    entries=[w for w in widgets(dialog) if w.winfo_class()=='TEntry']
    assert Path(entries[0].get())==second,'unique running account was not selected'
    assert '运行中，归属已确认' in chooser.get()
    entries[-1].insert(0,SELF)
    button(dialog,'一键自动配置').invoke()
    pump(lambda:app.source_dialog is None and not app.busy)
    assert second.name in app.account_text.get()
    app.search.set('普通')
    root.update()
    assert app.tree.get_children()==(GROUP,)
    app.search_entry.focus_force();root.update()
    app.search_entry.event_generate('<Return>')
    root.update()
    assert app.active_chat==GROUP and not app.parsed_results and not app.busy,'search Enter unexpectedly parsed records'
    app.parse_button.invoke()
    pump(lambda:session.settings.get('lastChat')==GROUP and not app.busy)
    app.search.set('不存在的关键词');root.update()
    assert not app.tree.get_children()
    assert '没有匹配' in app.group_hint.get()
    button(root,'账号设置').invoke()
    pump(lambda:app.source_dialog is not None and not app.busy)
    dialog=app.source_dialog
    chooser=next(w for w in widgets(dialog) if w.winfo_class()=='TCombobox')
    chooser.current(next(i for i,label in enumerate(chooser.cget('values')) if '旧账号' in label))
    chooser.event_generate('<<ComboboxSelected>>');root.update()
    entries=[w for w in widgets(dialog) if w.winfo_class()=='TEntry']
    assert Path(entries[0].get())==first
    assert entries[-1].get()=='','previous account identity leaked into new selection'
    button(dialog,'一键自动配置').invoke()
    pump(lambda:app.source_dialog is None and not app.busy)
    assert first.name in app.account_text.get()
    assert app.search.get()==''
    assert 'lastChat' not in session.settings,'previous account group selection survived a switch'
    assert not app.tree.selection()
    assert app.tree.get_children(),'switching accounts should list local group IDs'
    assert session.pending_review is None
finally:
    boundary.stop();root.destroy()
'''
        process = subprocess.run([sys.executable, '-c', code, str(self.directory), str(self.source), str(second)],
            env=self.env, capture_output=True, timeout=40)
        self.assertEqual(process.returncode, 0, process.stderr.decode('utf-8', errors='replace'))

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
    if path.is_file() and json.loads(path.read_text(encoding='utf-8')).get('state')=='awaiting_review':root.destroy()
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
        self.assertEqual(result['state'], 'awaiting_review')
        self.assertEqual(result['exportedRows'], 1)


if __name__ == '__main__':
    unittest.main()
