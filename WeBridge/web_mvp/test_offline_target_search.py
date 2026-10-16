"""Search is metadata only; an explicit target action exports exactly one group."""
from contextlib import closing
import json
import os
from pathlib import Path
import sqlite3
import subprocess
import sys
import tempfile
import unittest

from test_wecom_archive import fixture, pb


class TargetSearchTests(unittest.TestCase):
    def test_recent_group_search_and_selection_do_not_parse_until_confirmed(self):
        with tempfile.TemporaryDirectory(prefix='target-search-') as folder:
            base = Path(folder)
            source = base / 'source'
            fixture(source)
            groups = [('R:similar', '企微合成群归档'), ('R:first', '同名业务群'),
                      ('R:second', '同名业务群'), ('R:other', '无关群')]
            with closing(sqlite3.connect(source / 'session.db')) as db, db:
                db.executemany('insert into conversation_table values(?,?,?,?)',
                               [(cid, name, '', 1700000000) for cid, name in groups])
            with closing(sqlite3.connect(source / 'message.db')) as db, db:
                for index, (cid, _) in enumerate(groups, 10):
                    body = pb(1, pb(1, 0) + pb(2, pb(1, '其他群消息 ' + cid)))
                    db.execute('insert into message_table values(?,?,?,?,?,?,?,?,?,?,?)',
                               (index, index, index, 11, cid, 2, 1700000000, 0, body, b'', b''))
            profile = base / 'profile'
            profile.mkdir()
            (profile / 'settings.local.json').write_text(json.dumps({
                'version': 1, 'client': 'wecom', 'source': {'sourceRoot': str(source)},
                'lastChat': 'R:other'}), encoding='utf8')
            project = Path(__file__).resolve().parents[1]
            env = os.environ.copy()
            env['PYTHONPATH'] = os.pathsep.join(str(project / p) for p in
                ('.runtime/offline-build-deps', 'web_mvp', 'scripts'))
            code = r'''
import json,os,sys,time,tkinter as tk
from pathlib import Path
from local_chat_app import ChatApp
from offline_desktop import DesktopSession
base=Path(sys.argv[1]).resolve();profile=base/'profile'
session=DesktopSession(profile,client='wecom')
root=tk.Tk();app=ChatApp(root,session)
def pump(predicate):
    deadline=time.monotonic()+12
    while not predicate():
        assert time.monotonic()<deadline,'target search timed out'
        root.update();time.sleep(.01)
def settle():
    deadline=time.monotonic()+.35
    while time.monotonic()<deadline:root.update();time.sleep(.01)
def outputs():
    return sorted(profile.glob('exports/*/manifest.json'))+sorted(profile.glob('views/*/manifest.json'))
def enter():
    app.search_entry.focus_force();root.update();app.search_entry.event_generate('<Return>')
try:
    pump(lambda:bool(app.groups) and not app.busy)
    settle()
    assert not outputs(),'restoring a recent group parsed it without a request'
    assert not app.tree.get_children(),'startup should ask for a target, not list every group'
    assert app.active_chat is None
    app.choose_kind('图片');settle()
    assert not outputs(),'a filter shortcut parsed an unconfirmed group'
    app.search.set('企微合成群');root.update()
    assert len(app.tree.get_children())==2
    app.tree.selection_set('R:similar');settle()
    assert not outputs(),'single selection should not parse the candidate'
    assert app.kind_choice.instate(['disabled'])
    app.choose_kind('图片');settle()
    assert not outputs(),'filter shortcut parsed a selected candidate'
    enter()
    pump(lambda:session.last_export is not None and not app.busy)
    assert app.active_chat=='R:synthetic','exact name must win over a longer partial match'
    assert len(outputs())==1,'one request should create one target result'
    target=Path(session.last_export)
    rows=json.loads((target/'messages.json').read_text(encoding='utf8'))
    assert len(rows)==2
    assert '其他群消息' not in (target/'messages.jsonl').read_text(encoding='utf8')
    assert rows==[json.loads(line) for line in (target/'messages.jsonl').read_text(encoding='utf8').splitlines()]
    assert (target/'messages.md').is_file()
    opened=[]
    os.startfile=lambda path:opened.append(Path(path))
    app.open_button.invoke()
    assert opened==[target/'业务阅读.txt'],'reading button did not open the current target result'
    app.search.set('同名业务群');root.update();enter();settle()
    assert len(outputs())==1,'duplicate group name was silently chosen'
    assert not app.tree.selection(),'a duplicate name should require a choice'
    assert session.last_export is None,'old result links survived a different target search'
    app.tree.selection_set('R:second');settle()
    assert len(outputs())==1,'selecting a duplicate candidate should wait for confirmation'
    app.export_button.invoke()
    pump(lambda:session.last_export is not None and not app.busy)
    assert len(outputs())==2
    rows=json.loads((session.last_export/'messages.json').read_text(encoding='utf8'))
    assert len(rows)==1 and rows[0]['text']=='其他群消息 R:second'
    app.search.set('不存在的群');root.update();enter();settle()
    assert len(outputs())==2 and not app.tree.get_children()
    assert session.last_export is None and app.open_button.instate(['disabled'])
    app.search.set('');root.update();enter();settle()
    assert not app.tree.get_children() and len(outputs())==2
finally:
    root.destroy()
'''
            result = subprocess.run([sys.executable, '-c', code, str(base)],
                                    env=env, capture_output=True, timeout=40)
            self.assertEqual(result.returncode, 0, result.stderr.decode('utf8', errors='replace'))


if __name__ == '__main__':
    unittest.main()
