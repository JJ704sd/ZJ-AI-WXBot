"""One-click native Windows UI. Python, Tcl/Tk and codecs are bundled in EXE."""
from __future__ import annotations

import argparse
from datetime import datetime
import json
import os
from pathlib import Path
import queue
import subprocess
import sys
import tempfile
import threading
import tkinter as tk
from tkinter import filedialog, messagebox, ttk

PROJECT = Path(__file__).resolve().parents[1]
if not getattr(sys, 'frozen', False):
    sys.path.insert(0, str(PROJECT / 'web_mvp'))

from local_chat import default_workbench
from offline_chat import BEIJING
from offline_desktop import DesktopSession, safe_issue
from offline_widgets import MessageBrowser

FILTERS = {'业务阅读': 'business', '全部': None, '图片': 'image', '附件': 'file', '转发聊天': 'record', '引用': 'quote',
           '视频': 'video', '待补齐图片': 'missing_images', '表情': 'emoji', '待补齐媒体': 'missing_media'}
SHORTCUTS = ('全部', '图片', '附件', '转发聊天', '引用', '视频', '业务阅读', '待补齐图片', '表情')


class ChatApp:
    def __init__(self, root, session, *, check_report=None, check_chat=None,
                 open_chat=None, open_chat_name=None, open_result=None):
        self.root, self.session = root, session
        self.check_report, self.check_chat = check_report, check_chat
        self.open_request = {'chat_id': open_chat, 'chat_name': open_chat_name} if open_chat or open_chat_name else None
        self.open_result = Path(open_result).resolve() if open_result else None
        self.auto_parse_result = None
        if self.open_result:
            folder = (session.directory / 'requests').resolve()
            if (self.open_result.parent != folder or not folder.is_relative_to(session.directory)
                    or self.open_result.suffix != '.json'):
                raise ValueError('解析状态文件必须位于程序数据目录的 requests 子目录。')
            folder.mkdir(parents=True, exist_ok=True)
            with self.open_result.open('x', encoding='utf-8') as handle:
                json.dump({'state': 'starting', 'processId': os.getpid()}, handle)
        self.events = queue.Queue()
        self.busy = False
        self.closing = False
        self.destroyed = False
        self.groups = []
        self.active_chat = None
        self.pending_config = {}
        self.source_issue = ''
        self.page_offset = 0
        self.page_total = 0
        self.check_data = {'ok': False, 'nativeWindowCreated': True}
        root.title('本地聊天解析 · 业务阅读')
        width, height = min(1220, root.winfo_screenwidth() - 60), min(820, root.winfo_screenheight() - 110)
        root.geometry(f'{width}x{height}+20+20')
        root.minsize(min(1000, width), min(700, height))
        root.protocol('WM_DELETE_WINDOW', self.close)
        style = ttk.Style(root)
        if 'vista' in style.theme_names():
            style.theme_use('vista')
        style.configure('Title.TLabel', font=('Microsoft YaHei UI', 20, 'bold'))
        style.configure('Sub.TLabel', foreground='#64748b', font=('Microsoft YaHei UI', 9))
        style.configure('Status.TLabel', font=('Microsoft YaHei UI', 10))
        style.configure('Treeview', rowheight=34, font=('Microsoft YaHei UI', 10))
        style.configure('Treeview.Heading', font=('Microsoft YaHei UI', 10))
        root.option_add('*Font', ('Microsoft YaHei UI', 10))
        self.search = tk.StringVar()
        self.start_date = tk.StringVar()
        self.end_date = tk.StringVar()
        self.copy_media = tk.BooleanVar(value=True)
        self.status = tk.StringVar(value='正在查找已有配置并准备本地副本…')
        self.subtitle = tk.StringVar(value='本机处理 · 双击启动 · 选择群后直接解析与导出')
        self.group_title = tk.StringVar(value='群聊')
        self.chat_title = tk.StringVar(value='选择左侧群聊')
        self.result_text = tk.StringVar(value='')
        self.filter_kind = tk.StringVar(value='业务阅读')
        self.export_format = tk.StringVar(value='MD')
        self.page_text = tk.StringVar(value='')
        self._layout()
        for number, label in enumerate(SHORTCUTS, 1):
            root.bind(f'<Alt-Key-{number}>', lambda _event, label=label: self.choose_kind(label))
        root.bind('<Alt-o>', lambda _event: self.open_selected())
        root.bind('<Alt-v>', lambda _event: self.open_selected(image=True))
        self.search.trace_add('write', lambda *_: self.render_groups())
        root.after(80, self._drain)
        root.after(120, lambda: self.work('加载数据', session.bootstrap, self.ready))

    def publish_open(self, state, **fields):
        if not self.open_result:
            return
        value = {'state': state, 'processId': os.getpid(), **fields}
        if self.open_request:
            value['requestedChatName'] = self.open_request.get('chat_name')
        fd, temporary = tempfile.mkstemp(prefix='.open-', dir=self.open_result.parent)
        try:
            with os.fdopen(fd, 'w', encoding='utf-8') as handle:
                json.dump(value, handle, ensure_ascii=False, indent=2)
            os.replace(temporary, self.open_result)
        finally:
            if Path(temporary).exists():
                Path(temporary).unlink()

    def _layout(self):
        top = ttk.Frame(self.root, padding=(24, 20, 24, 14))
        top.pack(fill='x')
        ttk.Label(top, text='本地聊天解析', style='Title.TLabel').pack(anchor='w')
        ttk.Label(top, textvariable=self.subtitle, style='Sub.TLabel').pack(anchor='w', pady=(6, 0))
        toolbar = ttk.Frame(self.root, padding=(24, 0, 24, 14))
        toolbar.pack(fill='x')
        self.refresh_button = ttk.Button(toolbar, text='更新本地记录', command=self.refresh)
        self.refresh_button.pack(side='left')
        self.source_button = ttk.Button(toolbar, text='数据设置', command=self.source_settings)
        self.source_button.pack(side='left', padx=8)
        self.scan_button = ttk.Button(toolbar, text='发现本机账号', command=self.scan)
        self.scan_button.pack(side='left')
        self.progress = ttk.Progressbar(toolbar, mode='indeterminate', length=150)
        self.progress.pack(side='right')
        pane = ttk.PanedWindow(self.root, orient='horizontal')
        pane.pack(fill='both', expand=True, padx=24)
        left = ttk.Frame(pane, padding=(0, 0, 14, 0))
        right = ttk.Frame(pane, padding=(14, 0, 0, 0))
        pane.add(left, weight=1)
        pane.add(right, weight=3)
        ttk.Label(left, textvariable=self.group_title, font=('Microsoft YaHei UI', 12, 'bold')).pack(anchor='w', pady=(0, 10))
        self.search_entry = ttk.Entry(left, textvariable=self.search)
        self.search_entry.pack(fill='x', pady=(0, 10))
        tree_frame = ttk.Frame(left)
        tree_frame.pack(fill='both', expand=True)
        self.tree = ttk.Treeview(tree_frame, columns=('name',), show='headings', selectmode='browse')
        self.tree.heading('name', text='搜索群名或群 ID')
        self.tree.column('name', width=270, minwidth=160)
        scroll = ttk.Scrollbar(tree_frame, orient='vertical', command=self.tree.yview)
        self.tree.configure(yscrollcommand=scroll.set)
        self.tree.pack(side='left', fill='both', expand=True)
        scroll.pack(side='right', fill='y')
        self.tree.bind('<<TreeviewSelect>>', self.selection)
        ttk.Label(right, textvariable=self.chat_title, font=('Microsoft YaHei UI', 13, 'bold')).pack(anchor='w')
        ttk.Label(right, text='Alt+2 图片 · Alt+3 附件 · Alt+4 转发聊天 · Alt+O 打开附件 · Alt+V 放大图片', style='Sub.TLabel').pack(anchor='w', pady=(5, 12))
        reading = ttk.Frame(right)
        reading.pack(fill='x', pady=(0, 8))
        self.kind_choice = ttk.Combobox(reading, textvariable=self.filter_kind, values=list(FILTERS), state='readonly', width=12)
        self.kind_choice.pack(side='left')
        self.kind_choice.bind('<<ComboboxSelected>>', lambda _event: self.read_page())
        ttk.Button(reading, text='图片总览', command=lambda: self.browser.tabs.select(self.browser.gallery)).pack(side='left', padx=(8, 0))
        self.previous_button = ttk.Button(reading, text='更早记录', command=lambda: self.read_page(max(0, self.page_offset - 100)))
        self.previous_button.pack(side='left', padx=(8, 0))
        self.next_button = ttk.Button(reading, text='更新记录', command=lambda: self.read_page(self.page_offset + 100))
        self.next_button.pack(side='left', padx=5)
        ttk.Label(reading, textvariable=self.page_text, style='Sub.TLabel').pack(side='right')
        filters = ttk.Frame(right)
        filters.pack(fill='x', pady=(0, 12))
        ttk.Label(filters, text='导出日期').pack(side='left')
        ttk.Entry(filters, textvariable=self.start_date, width=12).pack(side='left', padx=6)
        ttk.Label(filters, text='至').pack(side='left')
        ttk.Entry(filters, textvariable=self.end_date, width=12).pack(side='left', padx=6)
        ttk.Label(filters, text='YYYY-MM-DD，留空不限', style='Sub.TLabel').pack(side='left')
        self.browser = MessageBrowser(right, notify=self.status.set, show_source=self.show_image_source)
        self.browser.pack(fill='both', expand=True)
        actions = ttk.Frame(right, padding=(0, 12, 0, 0))
        actions.pack(fill='x')
        ttk.Checkbutton(actions, text='包含本机已缓存附件', variable=self.copy_media).pack(side='left')
        ttk.Label(actions, text='同时导出 JSONL / JSON / MD', style='Sub.TLabel').pack(side='left', padx=12)
        self.export_button = ttk.Button(actions, text='解析并导出', command=self.export, state='disabled')
        self.export_button.pack(side='right')
        bottom = ttk.Frame(self.root, padding=(24, 14, 24, 18))
        bottom.pack(fill='x')
        ttk.Label(bottom, textvariable=self.status, style='Status.TLabel', wraplength=1030).pack(anchor='w')
        ttk.Label(bottom, textvariable=self.result_text, style='Sub.TLabel', wraplength=1030).pack(anchor='w', pady=(5, 8))
        self.open_button = ttk.Button(bottom, text='打开业务阅读文件', command=lambda: self.open_result(False), state='disabled')
        self.open_button.pack(side='left')
        self.folder_button = ttk.Button(bottom, text='打开导出目录', command=lambda: self.open_result(True), state='disabled')
        self.folder_button.pack(side='left', padx=8)
        self.image_page_button = ttk.Button(bottom, text='打开离线图片总览', command=self.open_image_page, state='disabled')
        self.image_page_button.pack(side='left')
        self.export_format_picker = ttk.Combobox(bottom, textvariable=self.export_format,
            values=('MD', 'JSON', 'JSONL'), width=7, state='disabled')
        self.export_format_picker.pack(side='left', padx=(18, 6))
        self.format_button = ttk.Button(bottom, text='查看导出文件', command=self.open_export_file, state='disabled')
        self.format_button.pack(side='left')

    def work(self, label, function, callback):
        if self.busy or self.closing:
            return
        self.busy = True
        self.status.set(label + '，请稍候…')
        self.progress.start(12)
        self.update_buttons()
        def run():
            try:
                self.events.put((callback, function(), None))
            except Exception as error:
                self.events.put((callback, None, safe_issue(error)))
        threading.Thread(target=run, daemon=True, name='local-chat-reader').start()

    def _drain(self):
        try:
            callback, value, issue = self.events.get_nowait()
        except queue.Empty:
            pass
        else:
            self.busy = False
            self.progress.stop()
            if self.closing:
                self.root.destroy()
                return
            if issue:
                self.status.set('未完成：' + issue)
                if self.open_request:
                    self.publish_open('failed', error=issue)
                if self.check_report:
                    self.finish_check({'error': issue})
                    return
            else:
                callback(value)
                if self.destroyed:
                    return
            self.update_buttons()
        self.root.after(80, self._drain)

    def update_buttons(self):
        state = 'disabled' if self.busy or self.closing else 'normal'
        for widget in (self.refresh_button, self.source_button, self.scan_button):
            widget.configure(state=state)
        self.search_entry.configure(state=state)
        self.tree.state(['disabled'] if self.busy or self.closing else ['!disabled'])
        self.kind_choice.configure(state='readonly' if state == 'normal' and self.active_chat else 'disabled')
        self.previous_button.configure(state='normal' if state == 'normal' and self.active_chat and self.page_offset > 0 else 'disabled')
        self.next_button.configure(state='normal' if state == 'normal' and self.active_chat and self.page_offset + 100 < self.page_total else 'disabled')
        self.export_button.configure(state='normal' if state == 'normal' and self.active_chat else 'disabled')
        result_state = 'normal' if state == 'normal' and self.session.last_export else 'disabled'
        self.open_button.configure(state=result_state)
        self.folder_button.configure(state=result_state)
        self.image_page_button.configure(state=result_state)
        self.format_button.configure(state=result_state)
        self.export_format_picker.configure(state='readonly' if result_state == 'normal' else 'disabled')

    def ready(self, value):
        if value['status'] != 'ready':
            self.status.set(value['message'])
            self.source_issue = value['message']
            self.pending_config = value.get('config', {})
            self.publish_open('needs_source', message=value['message'])
            if self.check_report:
                self.finish_check({'error': value['message']})
            else:
                self.root.after(100, self.scan)
            return
        self.pending_config = {}
        self.source_issue = ''
        self.groups = value['groups']
        self.group_title.set(f'群聊 · {len(self.groups)} 个')
        self.active_chat = None
        self.chat_title.set('选择左侧群聊')
        self.browser.clear()
        self.page_text.set('')
        self.page_offset = self.page_total = 0
        self.render_groups()
        stamp = datetime.fromisoformat(value['snapshotTime']).astimezone(BEIJING).strftime('%Y-%m-%d %H:%M:%S')
        self.subtitle.set(value['message'] + ' · 副本时间 ' + stamp + '（北京时间）')
        self.status.set('已就绪，选择群聊后可预览、解析与导出。' + (' ' + value['notice'] if value.get('notice') else ''))
        self.result_text.set('本机工作目录：' + str(self.session.directory))
        self.check_data.update(groups=len(self.groups), sourceStatus=value['message'], snapshotTime=value['snapshotTime'])
        if self.open_request:
            try:
                chat = self.session.archive.select_chat(**self.open_request)
            except ValueError:
                self.status.set('指定群不存在或名称重复，请在左侧选择正确群，选择后将自动解析。')
                self.publish_open('needs_chat', message=self.status.get())
                if self.check_report:
                    self.finish_check({'error': self.status.get()})
                return
            self.start_parse(chat['id'])
            return
        remembered = self.session.settings.get('lastChat')
        if self.check_chat:
            candidates = [group['id'] for group in self.groups if group['name'] == self.check_chat]
            if len(candidates) != 1:
                self.finish_check({'error': '检查会话不存在或名称不唯一。'})
                return
            remembered = candidates[0]
        if remembered and self.tree.exists(remembered):
            self.tree.selection_set(remembered)
            self.tree.see(remembered)
        elif self.check_report:
            self.finish_check({'ok': True})

    def render_groups(self):
        selected = self.active_chat
        for item in self.tree.get_children():
            self.tree.delete(item)
        needle = self.search.get().strip().casefold()
        for group in self.groups:
            if not needle or needle in (group['name'] + ' ' + group['id']).casefold():
                self.tree.insert('', 'end', iid=group['id'], values=(group['name'],))
        if selected and self.tree.exists(selected):
            self.tree.selection_set(selected)
        elif selected:
            self.active_chat = None
            self.chat_title.set('选择左侧群聊')
            self.browser.clear()
            self.update_buttons()

    def selection(self, _event=None):
        if self.busy:
            if self.active_chat and self.tree.exists(self.active_chat) and self.tree.selection() != (self.active_chat,):
                self.tree.selection_set(self.active_chat)
            return
        selected = self.tree.selection()
        if not selected or selected[0] == self.active_chat:
            return
        self.active_chat = selected[0]
        group = next(group for group in self.groups if group['id'] == self.active_chat)
        self.chat_title.set(group['name'])
        self.root.title('本地聊天解析 · 业务阅读 — ' + group['name'])
        self.filter_kind.set('业务阅读')
        self.browser.clear()
        if self.open_request:
            self.start_parse(self.active_chat)
        else:
            self.read_page()

    def start_parse(self, chat):
        self.active_chat = chat
        group = next(group for group in self.groups if group['id'] == chat)
        self.chat_title.set(group['name'])
        self.root.title('本地聊天解析 · 业务阅读 — ' + group['name'])
        self.tree.selection_set(chat)
        self.tree.see(chat)
        self.filter_kind.set('业务阅读')
        self.publish_open('parsing', chatName=group['name'])
        self.work('解析指定群并准备查看', lambda: self.session.parse_and_open(chat_id=chat), self.parsed_ready)

    def parsed_ready(self, value):
        self.auto_parse_result = value
        self.preview_ready(value['view'])
        self.check_data['parseAndOpen'] = True
        self.publish_open('completed', ok=True, chatName=value['chat']['name'],
                          output=value['output'], viewRoot=value['view']['viewRoot'],
                          exportedRows=value['report']['exportedRows'], businessRows=value['report']['businessRows'],
                          exportFiles=value['exportFiles'],
                          reporting=value['reporting'],
                          groups=len(self.groups), mediaSummary=value['report']['mediaSummary'],
                          mediaSummaryText=value['report']['mediaSummaryText'])
        self.open_request = None
        if self.check_report and self.check_chat:
            self.root.after(50, self.verify_browser)
        else:
            self.export_ready(value)

    def read_page(self, offset=None):
        if not self.active_chat or self.busy:
            return
        chat, kind = self.active_chat, FILTERS[self.filter_kind.get()]
        self.work('读取记录、核对并匹配本机媒体', lambda: self.session.preview(chat, offset, kind), self.preview_ready)

    def choose_kind(self, label):
        if self.active_chat and not self.busy:
            self.filter_kind.set(label)
            self.read_page()

    def open_selected(self, image=False):
        if self.busy:
            return
        selection = self.browser.tree.selection()
        row = self.browser.rows.get(selection[0], {}) if selection else {}
        asset = row.get('asset', {})
        if asset.get('status') != 'ready' and row.get('record'):
            pending = list(reversed(row['record']['items']))
            while pending:
                child = pending.pop()
                candidate = child.get('asset', {})
                if candidate.get('status') == 'ready' and (candidate.get('mime', '').startswith('image/') if image else child['kind'] == 'file'):
                    asset = candidate
                    break
                pending.extend(reversed(child.get('record', {}).get('items', [])))
        if asset.get('status') == 'ready':
            if image and asset.get('mime', '').startswith('image/'):
                self.browser.image_window(asset)
            elif not image:
                self.browser.open_attachment(asset)

    def preview_ready(self, value):
        self.browser.load(value)
        self.browser.set_gallery(self.session.views[self.active_chat])
        self.page_offset, self.page_total = value['offset'], value['total']
        first = self.page_offset + 1 if self.page_total else 0
        self.page_text.set(f'{first}–{self.page_offset + len(value["messages"])} / {self.page_total} 条')
        self.status.set(f'业务阅读 {value["report"]["businessRows"]} 条（源记录 {value["report"]["exportedRows"]} 条）。'
                        + value['report']['mediaSummaryText'])
        search = value['report'].get('localMediaSearch', {})
        if search.get('status') == 'checked':
            self.result_text.set(f'本地补齐检查：{search["filesScanned"]} 个文件，新增补齐 {search["recoveredReferences"]} 项。'
                                 + f'已关联引用来源 {value["report"].get("quoteSourceStatuses", {}).get("linked_local_source", 0)} 条。'
                                 + ('扫描范围未全部完成，详见核查清单。' if search.get('limitReached') or search.get('unreadableFiles') or search.get('oversizeFiles') else '可筛选“待补齐图片”查看原因；重新检查时点击“更新本地记录”。'))
        self.check_data['previewRows'] = len(value['messages'])
        if self.check_report and not self.open_request:
            if self.check_chat:
                self.root.after(50, self.verify_browser)
            else:
                self.finish_check({'ok': True})

    def show_image_source(self, entry):
        if self.busy or not self.active_chat:
            return
        view = self.session.views[self.active_chat]
        def show(value):
            self.filter_kind.set('全部')
            self.preview_ready(value)
            self.browser.reveal(entry)
        self.work('定位图片所在的原始消息', lambda: view.page_for_message(entry['rootMessageId']), show)

    def open_image_page(self):
        if self.session.last_export:
            target = self.session.last_export / 'images.html'
            if target.is_file():
                try:
                    os.startfile(str(target))
                except OSError:
                    messagebox.showerror('无法打开图片总览', '请从导出目录手动打开 images.html。', parent=self.root)

    def verify_browser(self):
        """Exercise real Tk image/record widgets; replace only the OS open boundary."""
        view = self.session.views[self.active_chat]
        results = {'imagesShown': 0, 'nestedImagesShown': 0, 'recordNodesExpanded': 0,
                   'documentOpenCallbacks': 0, 'imageWindowsCreated': 0, 'errors': []}
        launched = []
        original_opener = self.browser.opener
        self.browser.opener = launched.append
        try:
            for kind in ('image', 'file', 'record', 'emoji'):
                offset = 0
                while True:
                    page = view.page(offset, kind)
                    self.browser.load(page)
                    for item, row in list(self.browser.rows.items()):
                        if row.get('record'):
                            self.browser.tree.item(item, open=True)
                            if len(self.browser.tree.get_children(item)) != len(row['record']['items']):
                                raise ValueError('转发树条目数量不一致。')
                            results['recordNodesExpanded'] += 1
                        asset = row.get('asset', {})
                        if asset.get('status') != 'ready':
                            continue
                        if asset.get('mime', '').startswith('image/'):
                            self.browser.tree.selection_set(item)
                            self.browser.selected()
                            if not self.browser.photos or not all(photo.width() > 0 and photo.height() > 0 for photo in self.browser.photos):
                                raise ValueError('图片未创建可显示的原生位图。')
                            results['imagesShown'] += 1
                            if '.' in row.get('part', ''):
                                results['nestedImagesShown'] += 1
                                window = self.browser.image_window(asset)
                                if window is None:
                                    raise ValueError('嵌套图片放大窗口未创建。')
                                window.update_idletasks()
                                window.destroy()
                                results['imageWindowsCreated'] += 1
                        elif row['kind'] == 'file':
                            if self.browser.open_attachment(asset) is None:
                                raise ValueError('附件未交给打开回调。')
                    offset += page['pageSize']
                    if offset >= page['total']:
                        break
            results['documentOpenCallbacks'] = len(launched)
            results['linkedQuoteSourcesShown'] = 0
            for offset in range(0, view.page(0, 'quote')['total'], 100):
                self.browser.load(view.page(offset, 'quote'))
                for item in self.browser.tree.get_children():
                    row = self.browser.rows[item]
                    if row.get('quote', {}).get('resolutionStatus') == 'linked_local_source':
                        self.browser.tree.item(item, open=True)
                        self.browser.tree.selection_set(item)
                        self.browser.selected()
                        if not self.browser.tree.get_children(item):
                            raise ValueError('引用来源未生成原生查看条目。')
                        results['linkedQuoteSourcesShown'] += 1
            results['missingMediaMessages'] = view.page(0, 'missing_media')['total']
            results['missingImageMessages'] = view.page(0, 'missing_images')['total']
            results['businessRows'] = view.page(0, 'business')['total']
            self.browser.set_gallery(view)
            self.browser.tabs.select(self.browser.gallery)
            self.root.update_idletasks()
            results['galleryImageReferences'] = len(view.image_index)
            results['galleryCounts'] = dict(view.image_counts)
            results['galleryPicturesShown'] = 0
            results['gallerySourceLinksChecked'] = 0
            for offset in range(0, len(view.image_index), 24):
                self.browser.gallery.load(offset)
                page = self.browser.gallery.page
                if self.browser.gallery.card_count != len(page['images']):
                    raise ValueError('图片总览卡片数量不一致。')
                ready = sum(entry['asset'].get('status') == 'ready' for entry in page['images'])
                if len(self.browser.gallery.photos) != ready:
                    raise ValueError('图片总览中有可用图片未显示。')
                results['galleryPicturesShown'] += ready
                for entry in page['images']:
                    self.browser.load(view.page_for_message(entry['rootMessageId']))
                    self.browser.reveal(entry)
                    chosen = self.browser.tree.selection()
                    if not chosen:
                        raise ValueError('图片未能定位原始消息。')
                    results['gallerySourceLinksChecked'] += 1
            self.check_data['nativeReading'] = results
        except Exception as error:
            results['errors'].append(str(error))
            self.finish_check({'error': str(error), 'nativeReading': results})
            return
        finally:
            self.browser.opener = original_opener
        if self.auto_parse_result is not None:
            self.root.after(50, lambda: self.export_ready(self.auto_parse_result))
        else:
            self.root.after(50, self.export)

    def export(self):
        if not self.active_chat or self.busy:
            return
        chat, start, end, media = self.active_chat, self.start_date.get().strip() or None, self.end_date.get().strip() or None, self.copy_media.get()
        self.work('解析全部记录并核对本机附件', lambda: self.session.export(chat, start, end, media), self.export_ready)

    def export_ready(self, value):
        report = value['report']
        self.status.set(f'导出完成：业务阅读 {report["businessRows"]} 条，原始记录 {report["exportedRows"]} 条。'
                        + report['mediaSummaryText'])
        self.result_text.set('已生成 JSONL / JSON / MD。保存位置：' + value['output'])
        if self.check_report:
            self.finish_check({'ok': True, 'exportedRows': report['exportedRows'],
                               'mediaStatuses': report['mediaStatuses'], 'decodeStatuses': report['decodeStatuses'],
                               'mediaSummary': report['mediaSummary'], 'mediaSummaryText': report['mediaSummaryText'],
                               'reporting': report['reporting'],
                               'localMediaSearch': report.get('localMediaSearch'),
                               'mediaRecoveryFile': report.get('mediaRecoveryFile'),
                               'businessReadingFile': report.get('businessReadingFile'),
                               'businessRows': report.get('businessRows'),
                               'businessMediaStatuses': report.get('businessMediaStatuses'),
                               'quoteSourceStatuses': report.get('quoteSourceStatuses'), 'output': value['output']})

    def refresh(self):
        config = self.session.archive.media_config if self.session.archive else self.session.settings.get('source')
        if config:
            self.work('更新副本', lambda: self.session.open_source(config), self.ready)
        else:
            self.source_settings()

    def scan(self):
        self.work('发现本机账号目录', self.session.scan, self.scan_ready)

    def scan_ready(self, value):
        self.status.set(f'发现 {len(value["accounts"])} 个账号目录；目录标签不代表已验证账号。')
        self.source_settings(value['accounts'])

    def source_settings(self, accounts=None):
        if self.busy:
            return
        dialog = tk.Toplevel(self.root)
        dialog.title('选择本地数据')
        dialog.transient(self.root)
        dialog.grab_set()
        dialog.resizable(False, False)
        setup_tabs = ttk.Notebook(dialog)
        setup_tabs.pack(fill='both', expand=True, padx=10, pady=10)
        automatic_tab, manual_tab = ttk.Frame(setup_tabs), ttk.Frame(setup_tabs)
        setup_tabs.add(automatic_tab, text=' 自动配置（推荐） ')
        setup_tabs.add(manual_tab, text=' 手动选择 / 离线副本 ')
        automatic = ttk.Frame(automatic_tab, padding=20)
        automatic.pack(fill='x')
        ttk.Label(automatic, text='首次使用：登录本人微信后，一键自动配置', font=('Microsoft YaHei UI', 12, 'bold')).pack(anchor='w')
        ttk.Label(automatic, text='先复用并校验本机已有密钥；没有时，只读尝试从所选账号已登录微信恢复数据库和图片密钥。',
                  wraplength=720, style='Sub.TLabel').pack(anchor='w', pady=(5, 8))
        if self.source_issue:
            ttk.Label(automatic, text=self.source_issue, foreground='#a15b00', wraplength=720).pack(anchor='w', pady=(0, 8))
        frame = ttk.Frame(manual_tab, padding=20)
        frame.pack(fill='both', expand=True)
        ttk.Label(frame, text='手动配置（已有密钥或离线副本）：也可在下方选择文件。原始数据只读。').grid(row=0, column=0, columnspan=3, sticky='w', pady=(0, 15))
        config = dict(self.pending_config or (self.session.archive.media_config if self.session.archive else self.session.settings.get('source', {})))
        if not config.get('sourceRoot') and accounts and len(accounts) == 1:
            config['sourceRoot'] = accounts[0]['sourceRoot']
        entries = {}
        fields = [('sourceRoot', '账号数据或明文副本目录', True), ('keyFile', '已有数据库密钥文件', False),
                  ('imageKeyFile', '图片密钥（组合文件可留空）', False), ('selfId', '本人微信 ID（可选，不填保持未知）', None)]
        hints = {'sourceRoot': '选单个账号的 db_storage 或它的上一级账号目录；里面有 message、contact 等库。',
                 'keyFile': '选此前准备的密钥 JSON，不是微信密码，也不是任意 JSON；已解密副本可留空。',
                 'imageKeyFile': '用于解开部分图片缓存；若上面的 JSON 已含图片密钥，此处留空即可。'}
        for index, (key, label, folder) in enumerate(fields):
            row = 1 + index * 2
            ttk.Label(frame, text=label).grid(row=row, column=0, sticky='w', padx=(0, 12), pady=7)
            variable = tk.StringVar(value=config.get(key, ''))
            entries[key] = variable
            ttk.Entry(frame, textvariable=variable, width=52).grid(row=row, column=1, sticky='ew')
            if folder is not None:
                def browse(variable=variable, folder=folder):
                    path = filedialog.askdirectory(parent=dialog) if folder else filedialog.askopenfilename(parent=dialog, filetypes=[('JSON 文件', '*.json'), ('所有文件', '*.*')])
                    if path:
                        variable.set(path)
                ttk.Button(frame, text='选择…', command=browse).grid(row=row, column=2, padx=(8, 0))
            if key in hints:
                ttk.Label(frame, text=hints[key], style='Sub.TLabel', wraplength=650).grid(row=row + 1, column=0, columnspan=3, sticky='w')
        if accounts:
            choices = {f'{index + 1}. {item["directoryLabel"]}': item['sourceRoot'] for index, item in enumerate(accounts)}
            selected = tk.StringVar()
            picker = ttk.Frame(automatic)
            picker.pack(fill='x', pady=(0, 8))
            ttk.Label(picker, text='发现的本机账号目录').pack(side='left', padx=(0, 12))
            chooser = ttk.Combobox(picker, textvariable=selected, values=list(choices), state='readonly', width=50)
            chooser.pack(side='left', fill='x', expand=True)
            chooser.bind('<<ComboboxSelected>>', lambda _event: entries['sourceRoot'].set(choices[selected.get()]))
            for label, path in choices.items():
                if Path(path).resolve() == Path(config.get('sourceRoot') or '.').resolve():
                    selected.set(label)
                    break
        include_media = tk.BooleanVar(value=config.get('includeMedia', True))
        include_voice = tk.BooleanVar(value=config.get('includeVoice', False))
        ttk.Checkbutton(frame, text='包含附件索引（需要对应数据库密钥）', variable=include_media).grid(row=10, column=0, columnspan=3, sticky='w', pady=(12, 5))
        ttk.Checkbutton(frame, text='包含语音原件库（需要额外匹配密钥）', variable=include_voice).grid(row=11, column=0, columnspan=3, sticky='w')
        ttk.Label(frame, text='“匹配”指密钥能通过所选数据库的解密校验，改文件名不会产生密钥。只保存文件路径。', style='Sub.TLabel').grid(row=12, column=0, columnspan=3, sticky='w', pady=(8, 14))
        def form_value():
            value = {key: variable.get().strip() for key, variable in entries.items()}
            if (config.get('sourceRoot') and value['sourceRoot'] != config['sourceRoot']
                    and value['selfId'] == config.get('selfId')):
                # A different selected source must not silently inherit the old
                # account's own identity. Senders still come from the new DB.
                value['selfId'] = ''
            value.update(includeMedia=include_media.get(), includeVoice=include_voice.get())
            return value
        def load():
            value = form_value()
            self.pending_config = value
            dialog.destroy()
            self.work('创建并校验本地副本', lambda: self.session.open_source(value), self.ready)
        ttk.Button(frame, text='保存并加载', command=load).grid(row=13, column=2, sticky='e')
        def configure_automatically():
            value = form_value()
            self.pending_config = value
            dialog.destroy()
            self.work('自动校验数据、匹配密钥并加载',
                      lambda: self.session.automatic_setup(value, allow_process_read=True), self.ready)
        ttk.Button(automatic, text='一键自动配置', command=configure_automatically).pack(anchor='w')
        ttk.Separator(automatic, orient='horizontal').pack(fill='x', pady=(12, 0))
        def choose_workbench():
            path = filedialog.askopenfilename(parent=dialog, title='选择已有工作台的 database-config.json', filetypes=[('JSON 文件', '*.json')])
            if path:
                dialog.destroy()
                self.work('加载已有工作台配置', lambda: self.session.open_workbench(path), self.ready)
        ttk.Button(frame, text='使用已有工作台配置…', command=choose_workbench).grid(row=13, column=0, columnspan=2, sticky='w')
        def recover():
            value = form_value()
            if not value['sourceRoot']:
                messagebox.showinfo('先选择数据', '请选择本人在本机已登录微信使用的实际账号数据目录；只有离线副本时请提供已有密钥。', parent=dialog)
                return
            dialog.destroy()
            def run_recovery():
                from portable_key_recovery import recover_key_file
                result = recover_key_file(value['sourceRoot'], self.session.directory,
                    allow_process_read=True, include_media=value['includeMedia'])
                value['keyFile'] = result['keyFile']
                if result['imageRecovery'] == 'verified_local_samples':
                    value['imageKeyFile'] = ''
                info = self.session.open_source(value)
                info['notice'] = '本机数据库密钥已恢复并通过副本校验。' + (
                    '图片密钥也已通过本地样本验证。' if result['imageRecovery'] == 'verified_local_samples'
                    else '图片密钥未恢复，保留已有图片密钥和可读媒体；其余缺口会明确标注。')
                return info
            self.work('只读访问所选账号的本机微信并校验密钥', run_recovery, self.ready)
        ttk.Button(frame, text='没有密钥：从本机已登录微信尝试恢复', command=recover).grid(row=14, column=0, columnspan=3, sticky='w', pady=(14, 0))

    def open_export_file(self):
        if not self.session.last_export:
            return
        names = {'JSONL': 'messages.jsonl', 'JSON': 'messages.json', 'MD': 'messages.md'}
        name = names.get(self.export_format.get())
        if not name:
            return
        target = self.session.last_export / name
        if not target.is_file():
            messagebox.showinfo('此导出未包含该格式', '请点击“解析并导出”，新版会同时生成 JSONL、JSON 和 MD。', parent=self.root)
            return
        try:
            os.startfile(str(target))
        except OSError:
            try:
                # A missing file association must not require installing an editor.
                notepad = Path(os.environ.get('SystemRoot', r'C:\Windows')) / 'System32/notepad.exe'
                subprocess.Popen([str(notepad), str(target)])
            except OSError:
                messagebox.showerror('无法打开文件', '文件已导出，请在导出目录用文本查看器打开。', parent=self.root)

    def open_result(self, folder):
        if not self.session.last_export:
            return
        target = self.session.last_export if folder else self.session.last_export / '业务阅读.txt'
        try:
            os.startfile(str(target))
        except OSError:
            messagebox.showerror('无法打开文件', '请从导出目录中手动打开结果。', parent=self.root)

    def finish_check(self, value):
        self.check_data.update(value)
        self.check_report.parent.mkdir(parents=True, exist_ok=True)
        self.check_report.write_text(json.dumps(self.check_data, ensure_ascii=False, indent=2), encoding='utf-8')
        self.destroyed = True
        self.root.destroy()

    def close(self):
        if self.busy:
            self.closing = True
            self.status.set('正在完成当前本地操作，完成后自动关闭…')
            self.update_buttons()
        else:
            self.root.destroy()


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--workbench', type=Path)
    parser.add_argument('--data-dir', type=Path)
    parser.add_argument('--task-json', type=Path, help='执行本地 JSON 任务，无需打开窗口')
    parser.add_argument('--result-json', type=Path, help='任务结果写入不存在的新 JSON 文件')
    selection = parser.add_mutually_exclusive_group()
    selection.add_argument('--open-chat', help='解析并打开指定会话ID；首次设置后自动继续')
    selection.add_argument('--open-chat-name', help='解析并打开名称唯一的群；首次设置后自动继续')
    parser.add_argument('--open-result-json', type=Path, help='在本机 requests 目录写入解析进度与完成结果')
    parser.add_argument('--check-launch', type=Path, help=argparse.SUPPRESS)
    parser.add_argument('--check-export-chat', help=argparse.SUPPRESS)
    args = parser.parse_args(argv)
    if args.open_result_json and not (args.open_chat or args.open_chat_name):
        parser.error('--open-result-json 需要指定待解析会话。')
    if (args.task_json or args.result_json) and (args.open_chat or args.open_chat_name):
        parser.error('批处理任务与解析查看入口不能同时指定。')
    base = Path(sys.executable).resolve().parent if getattr(sys, 'frozen', False) else PROJECT / '.runtime/local-chat-desktop'
    directory = args.data_dir or base / 'local-chat-data'
    if args.task_json or args.result_json:
        if not args.task_json or not args.result_json:
            parser.error('--task-json 和 --result-json 必须同时提供。')
        from offline_batch import run_file
        return run_file(args.task_json, args.result_json, directory)
    root = tk.Tk()
    session = DesktopSession(directory, args.workbench or default_workbench())
    ChatApp(root, session, check_report=args.check_launch, check_chat=args.check_export_chat,
            open_chat=args.open_chat, open_chat_name=args.open_chat_name, open_result=args.open_result_json)
    root.mainloop()
    return 0


if __name__ == '__main__':
    import multiprocessing
    multiprocessing.freeze_support()
    raise SystemExit(main())
