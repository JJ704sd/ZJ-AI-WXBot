"""Cold WeCom setup through native widgets; only OS file ownership is replaced."""
import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest

from test_wecom_archive import fixture
from offline_desktop import DesktopSession


class WeComSetupFlowTests(unittest.TestCase):
    def test_saved_inactive_account_is_explicit_and_running_choice_only_edits_form(self):
        """Reproduce a saved source differing from the verified live source."""
        with tempfile.TemporaryDirectory(prefix='setup-saved-live-') as folder:
            base = Path(folder)
            from test_database_adapter import create_metadata, create_shard
            for client in ('wechat', 'wecom'):
                for name in ('saved', 'running'):
                    source = base / client / name
                    source.mkdir(parents=True)
                    if client == 'wecom':
                        fixture(source / 'Data')
                    else:
                        (source / 'db_storage').mkdir()
                        create_metadata(source / 'db_storage')
                        create_shard(source / 'db_storage', rows=[{'text': '账号选择合成记录'}])
                session = DesktopSession(base / client / 'profile', client=client)
                session._save({'sourceRoot': str(base / client / 'saved'), 'selfId': 'fixture-own',
                               'keyFile': str(base / client / 'saved-key.json')})
            project = Path(__file__).resolve().parents[1]
            env = os.environ.copy()
            env['PYTHONPATH'] = os.pathsep.join(str(project / p) for p in ('.runtime/offline-build-deps', 'web_mvp', 'scripts'))
            code = r'''
import sys,time,tkinter as tk
from pathlib import Path
from local_chat_app import ChatApp
from offline_desktop import DesktopSession
from offline_accounts import identify_accounts
from unittest.mock import patch
base=Path(sys.argv[1]).resolve()
def widgets(parent):
    for child in parent.winfo_children():
        yield child
        yield from widgets(child)
for client,child in [('wechat','db_storage'),('wecom','Data')]:
    session=DesktopSession(base/client/'profile',client=client)
    session.bootstrap=lambda:{'status':'needs_source','message':'测试账号设置'}
    saved=base/client/'saved';running=base/client/'running'
    discovery={'accounts':[{'sourceRoot':str(p/'db_storage' if client=='wechat' else p), 'directoryLabel':p.name,
        'databases':[{'path':'session.db' if client=='wecom' else 'session/session.db'}]} for p in (saved,running)]}
    # Only the Windows file-owner boundary is substituted.
    scan=identify_accounts(discovery,client,ownership=lambda paths,_: [(81,100)] if paths[0].is_relative_to(running) else [])
    for item in scan['accounts']:
        item['accountNickname']='合成昵称-'+item['directoryLabel']
        item['profileBasis']='configured_self_id:contact'
    session.scan=lambda:discovery
    boundary=patch('offline_accounts._windows_owners',lambda paths,_: [(81,100)] if paths[0].is_relative_to(running) else [])
    boundary.start()
    root=tk.Tk();app=ChatApp(root,session)
    try:
        deadline=time.monotonic()+10
        while app.source_dialog is None or app.busy:
            assert time.monotonic()<deadline
            root.update();time.sleep(.01)
        before=session.settings_path.read_bytes()
        app.scan_ready(scan);root.update()
        assert '保留已保存配置' in app.status.get(),app.status.get()
        assert '未检测到' in app.status.get(),app.status.get()
        dialog=app.source_dialog
        chooser=next(w for w in widgets(dialog) if w.winfo_class()=='TCombobox')
        assert '已保存配置' in chooser.get() and 'saved' in chooser.get(),chooser.get()
        assert '合成昵称-saved' in chooser.get(),chooser.get()
        select=next(w for w in widgets(dialog) if w.winfo_class()=='TButton' and w.cget('text')=='选择已确认的运行账号')
        assert 'disabled' not in select.state()
        select.invoke();root.update()
        assert 'running' in chooser.get() and '运行中' in chooser.get(),chooser.get()
        assert '合成昵称-running' in chooser.get() and '本地昵称/名称' in app.status.get()
        entries=[w for w in widgets(dialog) if w.winfo_class()=='TEntry']
        assert Path(entries[0].get())==(running/'db_storage' if client=='wechat' else running)
        assert all(not w.get() for w in entries[1:]),'old source key/identity reused across accounts'
        assert '尚未保存' in app.status.get(),app.status.get()
        assert session.settings_path.read_bytes()==before,'picking a source silently saved settings'
        assert not (session.directory/'exports').exists()
        app.update_buttons()
        assert 'disabled' in select.state(),'generic button refresh undid current source state'
        chooser.current(next(i for i,label in enumerate(chooser.cget('values')) if '已保存配置' in label))
        chooser.event_generate('<<ComboboxSelected>>');root.update()
        assert 'disabled' not in select.state()
        app.work('重新识别',lambda:scan,app.scan_ready)
        while app.busy:
            assert time.monotonic()<deadline
            root.update();time.sleep(.01)
        assert '已保存配置' in chooser.get() and 'disabled' not in select.state()
        assert dialog.winfo_height()<=root.winfo_screenheight(), 'source dialog exceeds screen height'
    finally:
        boundary.stop()
        root.destroy()
'''
            result = subprocess.run([sys.executable, '-c', code, str(base)], env=env, capture_output=True, timeout=35)
            self.assertEqual(result.returncode, 0, result.stderr.decode('utf8', errors='replace'))

    def test_new_profile_requires_confirmation_in_workspace_with_an_existing_workbench(self):
        from test_database_adapter import create_metadata, create_shard
        with tempfile.TemporaryDirectory(prefix='setup-startup-source-') as folder:
            base = Path(folder)
            workspace = base / 'workspace'
            workbench = workspace / '.runtime/web_mvp-database'
            snapshot = workbench / 'database-snapshots/snapshot-input'
            snapshot.mkdir(parents=True)
            create_metadata(snapshot)
            create_shard(snapshot, rows=[{'text': '显式导入工作台合成记录'}])
            config = workbench / 'database-config.json'
            config.write_text(json.dumps({'snapshotRoot': str(snapshot), 'config': {'sourceRoot': str(snapshot)}}), encoding='utf8')
            project = Path(__file__).resolve().parents[1]
            env = os.environ.copy()
            env['PYTHONPATH'] = os.pathsep.join(str(project / p) for p in ('.runtime/offline-build-deps', 'web_mvp', 'scripts'))
            for explicit in (False, True):
                profile = base / ('explicit-profile' if explicit else 'blank-profile')
                checked = base / ('explicit-check.json' if explicit else 'blank-check.json')
                command = [sys.executable, str(project / 'scripts/local_chat_app.py'), '--data-dir', str(profile), '--check-launch', str(checked)]
                if explicit:
                    command.extend(['--workbench', str(config)])
                run = subprocess.run(command, cwd=workspace, env=env, capture_output=True, timeout=25)
                self.assertEqual(run.returncode, 0, run.stderr.decode('utf8', errors='replace'))
                result = json.loads(checked.read_text(encoding='utf8'))
                if explicit:
                    self.assertTrue(result['ok'])
                else:
                    self.assertFalse(result['ok'], 'empty profile silently imported the workspace account')
                    self.assertIn('首次使用', result['error'])
                    self.assertFalse((profile / 'settings.local.json').exists())

    def test_same_account_root_alias_preserves_last_group_but_another_account_clears_it(self):
        with tempfile.TemporaryDirectory(prefix='setup-alias-') as folder:
            base = Path(folder)
            from test_database_adapter import create_metadata, create_shard, GROUP, SELF
            for client, child, chat, own in (('wechat', 'db_storage', GROUP, SELF), ('wecom', 'Data', 'R:synthetic', '11')):
                with self.subTest(client=client):
                    def make(account):
                        account.mkdir(parents=True)
                        if client == 'wecom':
                            fixture(account / child)
                        else:
                            (account / child).mkdir()
                            create_metadata(account / child)
                            create_shard(account / child, rows=[{'text': '目录别名合成记录'}])
                    account = base / client / 'first'
                    make(account)
                    session = DesktopSession(base / client / 'profile', client=client)
                    session.open_source({'sourceRoot': str(account / child), 'selfId': own})
                    session.preview(chat)
                    session.open_source({'sourceRoot': str(account), 'selfId': own})
                    self.assertEqual(session.settings.get('lastChat'), chat)
                    other = base / client / 'other'
                    make(other)
                    session.open_source({'sourceRoot': str(other)})
                    self.assertNotIn('lastChat', session.settings)

    def test_same_account_in_picker_does_not_clear_configured_key_or_identity(self):
        with tempfile.TemporaryDirectory(prefix='setup-picker-alias-') as folder:
            base = Path(folder)
            account = base / 'account'
            account.mkdir()
            fixture(account / 'Data')
            key = base / 'provided-key.json'
            key.write_text(json.dumps({'wecomKeys': [{'database': '*', 'key_hex': bytes(range(16)).hex()}]}))
            session = DesktopSession(base / 'profile', client='wecom')
            session.open_source({'sourceRoot': str(account / 'Data'), 'selfId': '11', 'keyFile': str(key)})
            session.preview('R:synthetic')
            project = Path(__file__).resolve().parents[1]
            env = os.environ.copy()
            env['PYTHONPATH'] = os.pathsep.join(str(project / p) for p in ('.runtime/offline-build-deps', 'web_mvp', 'scripts'))
            code = r'''
import json,sys,time,tkinter as tk
from pathlib import Path
from local_chat_app import ChatApp
from offline_desktop import DesktopSession
import offline_accounts
from wecom_snapshot import discover
base=Path(sys.argv[1]);profile=base/'profile'
session=DesktopSession(profile,client='wecom')
session.scan=lambda:discover([base/'account'])
offline_accounts._windows_owners=lambda *_:[(81,100)]
root=tk.Tk();app=ChatApp(root,session)
def pump(predicate):
    deadline=time.monotonic()+12
    while not predicate():
        assert time.monotonic()<deadline,'account picker timed out'
        root.update();time.sleep(.01)
def widgets(parent):
    for child in parent.winfo_children():
        yield child
        yield from widgets(child)
try:
    pump(lambda:app.groups and not app.busy)
    next(w for w in widgets(root) if w.winfo_class()=='TButton' and w.cget('text')=='账号设置').invoke()
    pump(lambda:app.source_dialog is not None and not app.busy)
    dialog=app.source_dialog
    chooser=next(w for w in widgets(dialog) if w.winfo_class()=='TCombobox')
    assert chooser.get(),'configured account was not selected when discovery used its parent path'
    chooser.current(0);chooser.event_generate('<<ComboboxSelected>>');root.update()
    entries=[w for w in widgets(dialog) if w.winfo_class()=='TEntry']
    assert entries[1].get()==str(base/'provided-key.json'),'same-account selection erased the supplied key'
    assert entries[2].get()=='11','same-account selection erased the own identity'
    next(w for w in widgets(dialog) if w.winfo_class()=='TButton' and w.cget('text')=='一键自动配置').invoke()
    pump(lambda:not dialog.winfo_exists() and not app.busy)
    settings=json.loads((profile/'settings.local.json').read_text(encoding='utf8'))
    assert settings['source']['selfId']=='11' and settings['source']['keyFile']==str(base/'provided-key.json')
    assert settings['lastChat']=='R:synthetic'
finally:
    root.destroy()
'''
            result = subprocess.run([sys.executable, '-c', code, str(base)], env=env, capture_output=True, timeout=35)
            self.assertEqual(result.returncode, 0, result.stderr.decode('utf8', errors='replace'))

    def test_running_account_recommendation_failure_retry_and_named_export(self):
        with tempfile.TemporaryDirectory(prefix='setup-flow-integration-') as folder:
            base = Path(folder)
            accounts, profile = base / 'accounts', base / 'profile'
            for name in ('old', 'running'):
                account = accounts / name
                account.mkdir(parents=True)
                fixture(account / 'Data')
            # A temporarily incomplete source must keep the same dialog alive.
            damaged = accounts / 'running/Data/session.db'
            original = damaged.read_bytes()
            (base / 'session-repair.bin').write_bytes(original)
            damaged.write_bytes(b'incomplete-source-copy')
            project = Path(__file__).resolve().parents[1]
            env = os.environ.copy()
            env['PYTHONPATH'] = os.pathsep.join(str(project / p) for p in ('.runtime/offline-build-deps', 'web_mvp', 'scripts'))
            code = r'''
import json,sys,time,tkinter as tk
from pathlib import Path
from local_chat_app import ChatApp
from offline_desktop import DesktopSession
import offline_accounts
from wecom_snapshot import discover

base=Path(sys.argv[1]).resolve();profile=base/'profile';running=base/'accounts/running'
# This is the sole substituted external boundary: selected-file OS ownership.
offline_accounts._windows_owners=lambda paths,client: [(81,100)] if paths[0].parent.parent==running else []
session=DesktopSession(profile,client='wecom')
session.scan=lambda:discover([base/'accounts'])
root=tk.Tk()
receipt=profile/'requests/cold.json'
app=ChatApp(root,session,open_chat_name='企微合成群',open_result=receipt)

def pump(predicate):
    deadline=time.monotonic()+15
    while not predicate():
        assert time.monotonic()<deadline,'native setup flow timed out'
        root.update();time.sleep(.01)

def widgets(parent):
    for child in parent.winfo_children():
        yield child
        yield from widgets(child)

def dialogs():return [w for w in root.winfo_children() if isinstance(w,tk.Toplevel)]

try:
    pump(lambda:bool(dialogs()) and not app.busy)
    dialog=dialogs()[0]
    entries=[w for w in widgets(dialog) if w.winfo_class()=='TEntry']
    chooser=next(w for w in widgets(dialog) if w.winfo_class()=='TCombobox')
    assert '运行中，归属已确认' in chooser.get(),'live account was not visibly recommended'
    assert Path(entries[0].get()).resolve()==running.resolve(),'wrong database account was selected'
    deadline=time.monotonic()+.4
    while time.monotonic()<deadline:root.update();time.sleep(.01)
    assert dialog.winfo_exists(),'idle first-use configuration disappeared'
    button=next(w for w in widgets(dialog) if w.winfo_class()=='TButton' and w.cget('text')=='一键自动配置')
    button.invoke()
    assert dialog.winfo_exists() and button.instate(['disabled']),'setup closed the dialog or allowed a duplicate'
    pump(lambda:not app.busy)
    assert dialogs()==[dialog],'failed source validation closed or replaced the dialog'
    assert json.loads(receipt.read_text(encoding='utf8'))['state']=='needs_source'
    assert button.instate(['!disabled']),'retry remained disabled'
    assert not (profile/'settings.local.json').exists(),'invalid source was saved'
    (running/'Data/session.db').write_bytes((base/'session-repair.bin').read_bytes())
    button.invoke()
    pump(lambda:json.loads(receipt.read_text(encoding='utf8')).get('state')=='awaiting_review')
    result=json.loads(receipt.read_text(encoding='utf8'))
    assert not dialog.winfo_exists(),'successful setup did not proceed to the chat'
    settings=json.loads((profile/'settings.local.json').read_text(encoding='utf8'))
    assert Path(settings['source']['sourceRoot']).resolve()==(running/'Data').resolve()
    assert settings['client']=='wecom' and result['exportedRows']==2
    assert 'exportFiles' not in result and not (profile/'exports').exists()
    assert (Path(result['viewRoot'])/'messages.jsonl').is_file()
    app.search.set('没有这样的群');root.update()
    assert not app.tree.get_children(),'unmatched search retained another group'
    app.search.set('企微合成');root.update()
    selected=app.tree.get_children()
    assert len(selected)==1 and str(app.tree.set(selected[0],'id'))=='R:synthetic'
    (base/'verified.json').write_text(json.dumps({'ok':True,'sameDialogAfterFailure':True,'reusedRecommendedAccount':True,'completed':True}),encoding='utf8')
finally:
    root.destroy()
'''
            result = subprocess.run([sys.executable, '-c', code, str(base)], env=env, capture_output=True, timeout=40)
            self.assertEqual(result.returncode, 0, result.stderr.decode('utf8', errors='replace'))
            self.assertTrue(json.loads((base / 'verified.json').read_text(encoding='utf8'))['ok'])


if __name__ == '__main__':
    unittest.main()
