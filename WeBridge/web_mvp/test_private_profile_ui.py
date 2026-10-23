"""Synthetic user-facing profile review tests; no real account reads."""
import threading
import time
import tkinter as tk
import unittest


def candidate():
    return {'candidateId': 'synthetic-candidate', 'status': 'candidate',
        'identity': {'client': 'wechat', 'accountKey': 'synthetic-account', 'peerId': 'synthetic-peer'},
        'changes': [{'subject': 'peer', 'category': 'needs', 'basis': 'explicit', 'text': '希望书面沟通',
            'evidence': [{'sourceId': 'synthetic-source', 'ref': 17, 'messageId': 'synthetic-message',
                         'time': '2026-01-01T09:00:00+08:00', 'senderName': '合成联系人',
                         'direction': 'incoming', 'text': '请把方案发成文字。'}]}],
        'previous': [{'subject': 'self', 'category': 'communication', 'basis': 'observed',
                      'text': '合成本人历史观察', 'evidence': []}],
        'limitations': ['本批次仅为合成数据']}


class ProfileReviewUITests(unittest.TestCase):
    def setUp(self):
        self.root = tk.Tk()
        self.addCleanup(self.close_root)

    def close_root(self):
        try:
            self.root.destroy()
        except tk.TclError:
            pass
        self.root = None
        import gc
        gc.collect()

    def pump(self, predicate, timeout=4):
        end = time.monotonic() + timeout
        while not predicate():
            self.root.update()
            if time.monotonic() > end:
                self.fail('synthetic UI timed out')
            time.sleep(.01)

    def test_filtering_and_selected_original_evidence(self):
        from private_profile_ui import CandidatePanel
        panel = CandidatePanel(self.root, candidate())
        panel.pack(fill='both', expand=True)
        self.root.update()
        self.assertEqual(panel.panes.cget('orient'), 'horizontal')
        self.assertEqual(len(panel.panes.panes()), 2)
        self.assertEqual(len(panel.tree.get_children()), 1)
        panel.tree.selection_set(panel.tree.get_children()[0])
        panel.tree.event_generate('<<TreeviewSelect>>')
        self.root.update()
        self.assertIn('请把方案发成文字', panel.detail.get('1.0', 'end'))
        self.assertIn('#17', panel.detail.get('1.0', 'end'))
        panel.query.set('没有该词')
        self.root.update()
        self.assertEqual(len(panel.tree.get_children()), 0)
        panel.query.set('书面')
        self.root.update()
        self.assertEqual(len(panel.tree.get_children()), 1)
        panel.scope.set('历史观察')
        panel.query.set('')
        self.root.update()
        self.assertEqual(len(panel.tree.get_children()), 1)
        self.assertIn('合成数据', panel.limitations.get('1.0', 'end'))

    def test_confirm_is_explicit_and_slow_save_does_not_block_window(self):
        from private_profile_ui import ConfirmationControls
        release = threading.Event()
        entered = threading.Event()
        finished = []
        self.addCleanup(release.set)
        def save(note):
            entered.set()
            release.wait(3)
            return {'status': 'confirmed'}
        controls = ConfirmationControls(self.root, save, finished.append)
        controls.pack(fill='x')
        self.root.update()
        self.assertTrue(controls.confirm_button.instate(['disabled']))
        controls.confirm_button.invoke()
        self.assertFalse(entered.is_set())
        for variable in controls.checks:
            variable.set(True)
        controls.confirm_button.invoke()
        self.pump(entered.is_set)
        pulse = []
        self.root.after(20, lambda: pulse.append(True))
        self.pump(lambda: bool(pulse))
        self.assertFalse(finished)
        self.assertTrue(controls.confirm_button.instate(['disabled']))
        release.set()
        self.pump(lambda: bool(finished))
        self.assertEqual(finished[0]['status'], 'confirmed')

    def test_failed_save_keeps_note_and_requires_fresh_confirmation(self):
        from private_profile_ui import ConfirmationControls
        from private_profiles import ProfileError
        attempts, finished = [], []
        def save(note):
            attempts.append(note)
            if len(attempts) == 1:
                raise ProfileError('合成磁盘故障')
            return {'status': 'confirmed'}
        controls = ConfirmationControls(self.root, save, finished.append)
        controls.pack()
        controls.note.insert('1.0', '保留合成确认备注')
        for variable in controls.checks:
            variable.set(True)
        controls.confirm_button.invoke()
        self.pump(lambda: bool(attempts) and not controls.busy)
        self.assertIn('合成磁盘故障', controls.status.get())
        self.assertEqual(controls.note.get('1.0', 'end-1c'), '保留合成确认备注')
        self.assertTrue(all(not item.get() for item in controls.checks))
        self.assertTrue(controls.confirm_button.instate(['disabled']))
        self.assertFalse(finished)
        for variable in controls.checks:
            variable.set(True)
        controls.confirm_button.invoke()
        self.pump(lambda: bool(finished))
        self.assertEqual(attempts, ['保留合成确认备注'] * 2)

    def test_review_window_900x620_keeps_evidence_and_footer_visible(self):
        from private_profile_ui import review_window
        self.root.geometry('900x620')
        self.root.update_idletasks()
        measured = {}

        def inspect_window():
            windows = [item for item in self.root.winfo_children() if isinstance(item, tk.Toplevel)]
            self.assertEqual(len(windows), 1)
            window = windows[0]
            window.geometry('900x620')
            for _ in range(5):
                window.update_idletasks()
                window.update()
            panel = window.grid_slaves(row=0)[0]
            controls = window.grid_slaves(row=1)[0]
            checks_frame = controls.check_widgets[0].master
            measured.update({
                'treeHeight': panel.tree.winfo_height(),
                'detailHeight': panel.detail.winfo_height(),
                'checksVisible': all(widget.winfo_ismapped() for widget in controls.check_widgets),
                'confirmVisible': controls.confirm_button.winfo_ismapped(),
                'checksFit': all(
                    widget.winfo_width() >= widget.winfo_reqwidth() and
                    widget.winfo_x() + widget.winfo_width() <= checks_frame.winfo_width()
                    for widget in controls.check_widgets),
                'footerInside': all(
                    widget.winfo_rooty() + widget.winfo_height() <= window.winfo_rooty() + window.winfo_height()
                    for widget in (*controls.check_widgets, controls.confirm_button)),
            })
            window.destroy()

        self.root.after(100, inspect_window)
        review_window('合成画像复核', '', lambda _note: {'status': 'confirmed'},
                      parent=self.root, candidate=candidate())
        self.assertGreaterEqual(measured['treeHeight'], 150)
        self.assertGreaterEqual(measured['detailHeight'], 150)
        self.assertTrue(measured['checksVisible'])
        self.assertTrue(measured['confirmVisible'])
        self.assertTrue(measured['checksFit'])
        self.assertTrue(measured['footerInside'])


if __name__ == '__main__':
    unittest.main()
