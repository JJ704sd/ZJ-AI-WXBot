"""Confirmed-profile desktop read path, with synthetic source and isolated store."""
import tkinter as tk
import json
import time
import unittest
from unittest.mock import patch

import test_private_profiles as fixtures


class SavedProfileTests(unittest.TestCase):
    setUp = fixtures.PrivateProfileFixture.setUp
    tearDown = fixtures.PrivateProfileFixture.tearDown
    candidate = fixtures.PrivateProfileFixture.candidate

    @staticmethod
    def close_root(root):
        for token in root.tk.call('after', 'info'):
            root.after_cancel(token)
        root.destroy()

    def test_export_identity_selects_only_confirmed_profile_and_account_overview(self):
        from private_chat import load_saved_profile
        request = self.store.prepare(self.export)
        candidate = self.candidate(request)
        candidate['observations'].append({**candidate['observations'][0],
            'subject': 'self', 'text': '合成本人观察', 'basis': 'uncertain'})
        staged = self.store.stage(request['requestId'], candidate)
        pending = load_saved_profile(self.store, self.export, bound_client='wechat')
        self.assertEqual(pending['observations'], [])
        self.assertIn('尚未', pending['emptyHint'])
        confirmed = self.store.confirm(staged['candidateId'], confirmed_by='synthetic_test')
        current = load_saved_profile(self.store, self.export, bound_client='wechat')
        self.assertEqual(current['revision'], confirmed['revision'])
        self.assertEqual(current['identity']['accountKey'], request['accountKey'])
        self.assertEqual(len(current['observations']), 2)
        overview = load_saved_profile(self.store, self.export, bound_client='wechat', overview=True)
        self.assertEqual([i['subject'] for i in overview['observations']], ['self'])
        self.assertEqual(overview['contacts'], [request['peerId']])
        self.assertTrue(overview['observations'][0]['evidence'])
        with self.assertRaises(ValueError):
            load_saved_profile(self.store, self.export, bound_client='wecom')

    def test_saved_window_is_read_only_and_evidence_is_accessible(self):
        from private_chat import load_saved_profile
        from private_profile_ui import show_saved_profile, ConfirmationControls
        request = self.store.prepare(self.export)
        staged = self.store.stage(request['requestId'], self.candidate(request))
        self.store.confirm(staged['candidateId'], confirmed_by='synthetic_test')
        value = load_saved_profile(self.store, self.export, bound_client='wechat')
        root = tk.Tk()
        self.addCleanup(self.close_root, root)
        window = show_saved_profile(value, parent=root)
        window.geometry('900x620')
        root.update()
        panel = window.profile_panel
        self.assertIn('已确认', panel.header_status.get())
        self.assertEqual(panel.scope.get(), '已确认观察')
        panel.tree.selection_set('0')
        panel.show_selected()
        self.assertIn('需要报价', panel.detail.get('1.0', 'end'))
        self.assertGreater(panel.detail.winfo_height(), 100)
        pending = [window]
        while pending:
            widget = pending.pop()
            self.assertNotIsInstance(widget, ConfirmationControls)
            pending.extend(widget.winfo_children())
        panel.query.set('找不到的合成内容')
        self.assertEqual(panel.tree.get_children(), ())

    def test_desktop_menu_loads_saved_views_in_background(self):
        from local_chat_app import ChatApp
        from offline_desktop import DesktopSession
        request = self.store.prepare(self.export)
        candidate = self.candidate(request)
        candidate['observations'][0].update(subject='self', basis='uncertain')
        staged = self.store.stage(request['requestId'], candidate)
        self.store.confirm(staged['candidateId'], confirmed_by='synthetic_test')
        root = tk.Tk()
        self.addCleanup(self.close_root, root)
        session = DesktopSession(self.base / 'desktop', conversation_mode='direct')
        app = ChatApp(root, session)
        for token in root.tk.call('after', 'info'):
            root.after_cancel(token)
        session.last_export = self.export
        menu = root.nametowidget(app.scan_button.cget('menu'))
        app._drain()
        with patch('private_chat.default_store', return_value=self.store.root):
            for label, overview in (('查看已确认画像', False), ('本人沟通总览', True)):
                menu.invoke(label)
                self.assertTrue(app.busy)
                deadline = time.monotonic() + 6
                while app.busy and time.monotonic() < deadline:
                    root.update()
                    time.sleep(.01)
                self.assertFalse(app.busy, app.status.get())
                windows = [w for w in root.winfo_children() if isinstance(w, tk.Toplevel)]
                self.assertEqual(len(windows), 1, app.status.get())
                panel = windows[0].profile_panel
                self.assertEqual(panel.value['overview'], overview)
                self.assertEqual(panel.value['identity']['accountKey'], request['accountKey'])
                self.assertEqual(len(panel.current), 1)
                windows[0].destroy()
            # A corrupted confirmed version must explain its validation failure,
            # finish the worker and allow retry after the original bytes are restored.
            identity = {key: request[key] for key in ('client', 'accountKey', 'peerId')}
            directory = self.store.root / 'profiles' / self.store._identity_key(identity)
            pointer = json.loads((directory / 'current.json').read_text(encoding='utf8'))
            profile_path = directory / pointer['profileFile']
            original = profile_path.read_bytes()
            profile_path.write_bytes(b'{}')
            menu.invoke('查看已确认画像')
            deadline = time.monotonic() + 6
            while app.busy and time.monotonic() < deadline:
                root.update()
                time.sleep(.01)
            self.assertFalse(app.busy)
            self.assertIn('摘要不一致', app.status.get())
            self.assertFalse([w for w in root.winfo_children() if isinstance(w, tk.Toplevel)])
            profile_path.write_bytes(original)
            menu.invoke('查看已确认画像')
            deadline = time.monotonic() + 6
            while app.busy and time.monotonic() < deadline:
                root.update()
                time.sleep(.01)
            self.assertFalse(app.busy)
            self.assertEqual(len([w for w in root.winfo_children() if isinstance(w, tk.Toplevel)]), 1)


if __name__ == '__main__':
    unittest.main()
