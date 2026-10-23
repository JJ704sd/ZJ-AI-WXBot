"""Native controls for recovery settings, using synthetic sources only."""
from pathlib import Path
import tempfile
import tkinter as tk
from tkinter import ttk
from types import SimpleNamespace
import unittest

from offline_content_ui import open_content_settings
from offline_desktop import DesktopSession
from test_offline_multiselect import multi_group_fixture


class ContentUI47Tests(unittest.TestCase):
    def test_overview_switches_scope_and_keeps_unparsed_groups_visible(self):
        from offline_completeness import open_overview
        root=tk.Tk();root.geometry('1000x700');root.update()
        try:
            app=SimpleNamespace(root=root,closing=False,active_chat='synthetic-a',selected_chats={'synthetic-a','synthetic-b'},
                parsed_results={'synthetic-a':{'report':{'exportedRows':100,'chat':{'name':'合成群'}}}},
                session=SimpleNamespace(review_status=lambda _: '待复核'))
            dialog=open_overview(app);root.update()
            def descendants(w):
                for child in w.winfo_children():
                    yield child
                    yield from descendants(child)
            controls=list(descendants(dialog))
            scope=next(w for w in controls if isinstance(w,ttk.Combobox))
            scope.set('所选群');scope.event_generate('<<ComboboxSelected>>');root.update()
            texts=[str(w.cget('text')) for w in controls if isinstance(w,tk.Label)]
            self.assertTrue(any('未解析 1' in t for t in texts))
            self.assertIn('待核查',texts)
            for button in [w for w in controls if isinstance(w,ttk.Button)]:
                self.assertLessEqual(button.winfo_rooty()+button.winfo_height(),dialog.winfo_rooty()+dialog.winfo_height())
            dialog.destroy()
        finally:root.destroy()

    def test_save_and_cancel_preserve_current_review_without_export(self):
        with tempfile.TemporaryDirectory(prefix='synthetic-content-ui47-') as temporary:
            base=Path(temporary).resolve()
            for client in ('wechat','wecom'):
                source=base/(client+'-source');chats=multi_group_fixture(source,client)
                session=DesktopSession(base/(client+'-profile'),client=client)
                session.open_source({'sourceRoot':str(source)})
                session.prepare_review(chats[0],copy_media=False);pending=session.pending_review
                root=tk.Tk();root.geometry("900x700");root.update()
                try:
                    app=SimpleNamespace(root=root,session=session,busy=False,read_busy=False,batch_running=False,closing=False,status=tk.StringVar(root))
                    before=session.settings_path.read_bytes()
                    open_content_settings(app)
                    dialog=next(w for w in root.winfo_children() if isinstance(w,tk.Toplevel));dialog.destroy()
                    self.assertEqual(session.settings_path.read_bytes(),before)
                    open_content_settings(app);root.update()
                    dialog=next(w for w in root.winfo_children() if isinstance(w,tk.Toplevel))
                    def descendants(w):
                        for child in w.winfo_children():
                            yield child
                            yield from descendants(child)
                    controls=list(descendants(dialog))
                    toggles=[w for w in controls if isinstance(w,ttk.Checkbutton)]
                    self.assertEqual(len(toggles),2)
                    toggles[0].invoke()
                    save=next(w for w in controls if isinstance(w,ttk.Button) and w.cget('text')=='保存补齐设置')
                    self.assertLessEqual(save.winfo_rooty()+save.winfo_height(),dialog.winfo_rooty()+dialog.winfo_height())
                    save.invoke();root.update()
                    self.assertTrue(session.settings['source']['ocrEnabled'])
                    self.assertFalse(session.settings['source']['ocrImages'])
                    self.assertIs(session.pending_review,pending)
                    self.assertIn('重新解析',app.status.get())
                    self.assertFalse(session.last_export)
                finally:root.destroy()


if __name__=='__main__':unittest.main()
