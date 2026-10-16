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

from offline_chat import BEIJING, date_range
from offline_calendar import DatePicker
from offline_accounts import group_choices, identify_accounts, same_account_source
from offline_desktop import DesktopSession, safe_issue
from offline_widgets import MessageBrowser
import offline_startup as startup

GUI_RELEASE = 'v20'

FILTERS = {'业务阅读': 'business', '全部': None, '图片': 'image', '附件': 'file', '转发聊天': 'record', '引用': 'quote',
           '视频': 'video', '待补齐图片': 'missing_images', '表情': 'emoji', '待补齐媒体': 'missing_media'}
SHORTCUTS = ('全部', '图片', '附件', '转发聊天', '引用', '视频', '业务阅读', '待补齐图片', '表情')


class ChatApp:
    def __init__(self, root, session, *, check_report=None, check_chat=None,
                 open_chat=None, open_chat_name=None, open_result=None):
        self.root, self.session = root, session
        root.report_callback_exception = self.callback_error
        self.check_report, self.check_chat = check_report, check_chat
        self.open_request = {'chat_id': open_chat, 'chat_name': open_chat_name} if open_chat or open_chat_name else None
        self.open_result_path = Path(open_result).resolve() if open_result else None
        self.auto_parse_result = None
        if self.open_result_path:
            folder = (session.directory / 'requests').resolve()
            if (self.open_result_path.parent != folder or not folder.is_relative_to(session.directory)
                    or self.open_result_path.suffix != '.json'):
                raise ValueError('解析状态文件必须位于程序数据目录的 requests 子目录。')
            folder.mkdir(parents=True, exist_ok=True)
            with self.open_result_path.open('x', encoding='utf-8') as handle:
                json.dump({'state': 'starting', 'processId': os.getpid()}, handle)
        self.events = queue.Queue()
        self.busy = False
        self.closing = False
        self.destroyed = False
        self.groups = []
        self.active_chat = None
        self.parsed_chat = None
        self.pending_config = {}
        self.source_issue = ''
        self.source_dialog = None
        self.source_controls = []
        self.source_progress = None
        self.account_scan = {}
        self.account_choices_update = None
        self.page_offset = 0
        self.page_total = 0
        self.check_data = {'ok': False, 'nativeWindowCreated': True}
        self.client_title = ('企微' if session.client == 'wecom' else '个微') + '本地聊天解析 · 业务阅读 · ' + GUI_RELEASE
        root.title(self.client_title)
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
        style.configure('Treeview', rowheight=30, font=('Microsoft YaHei UI', 10))
        style.configure('Treeview.Heading', font=('Microsoft YaHei UI', 10))
        root.option_add('*Font', ('Microsoft YaHei UI', 10))
        self.search = tk.StringVar()
        self.start_date = tk.StringVar()
        self.end_date = tk.StringVar()
        self.copy_media = tk.BooleanVar(value=True)
        self.status = tk.StringVar(value='正在查找已有配置并准备本地副本…')
        self.subtitle = tk.StringVar(value='本机处理 · 输入目标群名 · 仅解析指定群')
        self.group_title = tk.StringVar(value='搜索目标群聊')
        self.account_text = tk.StringVar(value='确认账号 → 搜索目标群 → 解析此群')
        self.group_hint = tk.StringVar(value='配置账号后，输入要解析的群名。')
        self.chat_title = tk.StringVar(value='输入目标群名后按 Enter')
        self.result_text = tk.StringVar(value='')
        self.filter_kind = tk.StringVar(value='业务阅读')
        self.export_format = tk.StringVar(value='MD')
        self.page_size = tk.StringVar(value='300')
        self.message_search = tk.StringVar()
        self.page_text = tk.StringVar(value='')
        self._layout()
        for number, label in enumerate(SHORTCUTS, 1):
            root.bind(f'<Alt-Key-{number}>', lambda _event, label=label: self.choose_kind(label))
        root.bind('<Alt-o>', lambda _event: self.open_selected())
        root.bind('<Alt-v>', lambda _event: self.open_selected(image=True))
        root.bind('<Control-f>', lambda _event: self.search_entry.focus_set())
        self.search.trace_add('write', lambda *_: self.render_groups())
        root.after(80, self._drain)
        root.after(120, lambda: self.work('加载数据', session.bootstrap, self.ready))

    def publish_open(self, state, **fields):
        if not self.open_result_path:
            return
        value = {'state': state, 'processId': os.getpid(), **fields}
        if self.open_request:
            value['requestedChatName'] = self.open_request.get('chat_name')
        fd, temporary = tempfile.mkstemp(prefix='.open-', dir=self.open_result_path.parent)
        try:
            with os.fdopen(fd, 'w', encoding='utf-8') as handle:
                json.dump(value, handle, ensure_ascii=False, indent=2)
            os.replace(temporary, self.open_result_path)
        finally:
            if Path(temporary).exists():
                Path(temporary).unlink()

    def _layout(self):
        self.root.columnconfigure(0, weight=1)
        self.root.rowconfigure(2, weight=1)
        header = ttk.Frame(self.root, padding=(14, 10, 14, 6))
        header.grid(row=0, column=0, sticky='ew')
        ttk.Label(header, text='本地聊天解析', font=('Microsoft YaHei UI', 15, 'bold')).pack(side='left')
        client = '企业微信' if self.session.client == 'wecom' else '个人微信'
        ttk.Label(header, text=client + ' · ' + GUI_RELEASE, style='Sub.TLabel').pack(side='left', padx=12)
        self.scan_button = ttk.Menubutton(header, text='更多设置')
        menu = tk.Menu(self.scan_button, tearoff=False)
        menu.add_command(label='手动导入数据副本', command=lambda: self.source_settings(manual=True))
        menu.add_command(label='打开诊断日志', command=self.open_diagnostics)
        self.scan_button.configure(menu=menu)
        self.scan_button.pack(side='right')
        self.source_button = ttk.Button(header, text='账号设置', command=self.scan)
        self.source_button.pack(side='right', padx=8)
        self.refresh_button = ttk.Button(header, text='刷新此群与媒体', command=self.refresh)
        self.refresh_button.pack(side='right')
        info = ttk.Frame(self.root, padding=(14, 0, 14, 8))
        info.grid(row=1, column=0, sticky='ew')
        info.columnconfigure(0, weight=1)
        ttk.Label(info, textvariable=self.account_text, style='Sub.TLabel').grid(row=0, column=0, sticky='w')
        self.progress = ttk.Progressbar(info, mode='indeterminate', length=100)
        self.progress.grid(row=0, column=1, sticky='e', padx=(12, 0))
        pane = ttk.PanedWindow(self.root, orient='horizontal')
        pane.grid(row=2, column=0, sticky='nsew', padx=14)
        self.sidebar = ttk.Frame(pane, width=250, padding=(0, 8, 12, 0))
        self.sidebar.pack_propagate(False)
        right = ttk.Frame(pane, padding=(12, 8, 0, 0))
        pane.add(self.sidebar, weight=0)
        pane.add(right, weight=1)
        right.columnconfigure(0, weight=1)
        right.rowconfigure(3, weight=1)
        ttk.Label(self.sidebar, textvariable=self.group_title, font=('Microsoft YaHei UI', 11, 'bold')).pack(anchor='w', pady=(0, 8))
        self.search_entry = ttk.Entry(self.sidebar, textvariable=self.search)
        self.search_entry.pack(fill='x')
        self.search_entry.bind('<Return>', self.choose_search_result)
        self.parse_button = ttk.Button(self.sidebar, text='查找并解析目标群', command=self.choose_search_result)
        self.parse_button.pack(fill='x', pady=6)
        ttk.Label(self.sidebar, textvariable=self.group_hint, wraplength=230, style='Sub.TLabel').pack(fill='x', pady=(0, 8))
        tree_frame = ttk.Frame(self.sidebar)
        tree_frame.pack(fill='both', expand=True)
        self.tree = ttk.Treeview(tree_frame, columns=('name', 'count'), show='headings', selectmode='browse')
        self.tree.heading('name', text='群聊')
        self.tree.column('name', width=150, minwidth=120)
        self.tree.heading('count', text='记录')
        self.tree.column('count', width=62, minwidth=50, stretch=False, anchor='e')
        scroll = ttk.Scrollbar(tree_frame, orient='vertical', command=self.tree.yview)
        self.tree.configure(yscrollcommand=scroll.set)
        self.tree.pack(side='left', fill='both', expand=True)
        scroll.pack(side='right', fill='y')
        self.tree.bind('<<TreeviewSelect>>', self.selection)
        self.tree.bind('<Return>', lambda _event: self.export())
        self.tree.bind('<Double-1>', self.confirm_group)
        title = ttk.Frame(right)
        title.grid(row=0, column=0, sticky='ew', pady=(0, 10))
        ttk.Label(title, textvariable=self.chat_title, font=('Microsoft YaHei UI', 13, 'bold')).pack(side='left')
        reading = ttk.Frame(right)
        reading.grid(row=1, column=0, sticky='ew', pady=(0, 8))
        reading.columnconfigure(3, weight=1)
        ttk.Label(reading, text='消息').grid(row=0, column=0, padx=(0, 6))
        self.kind_choice = ttk.Combobox(reading, textvariable=self.filter_kind, values=list(FILTERS), state='readonly', width=9)
        self.kind_choice.grid(row=0, column=1)
        self.kind_choice.bind('<<ComboboxSelected>>', lambda _event: self.read_page())
        ttk.Label(reading, text='关键词').grid(row=0, column=2, padx=(12, 6))
        self.message_search_entry = ttk.Entry(reading, textvariable=self.message_search, width=12)
        self.message_search_entry.grid(row=0, column=3, sticky='ew')
        self.message_search_entry.bind('<Return>', lambda _event: self.read_page(0))
        self.message_search_button = ttk.Button(reading, text='筛选', width=5, command=lambda: self.read_page(0))
        self.message_search_button.grid(row=0, column=4, padx=(6, 4))
        self.message_clear_button = ttk.Button(reading, text='清除', width=5, command=self.clear_message_search)
        self.message_clear_button.grid(row=0, column=5)
        self.date_toggle_button = ttk.Button(reading, text='日期 / 媒体 ▾', command=self.toggle_date_filters)
        self.date_toggle_button.grid(row=0, column=6, padx=(12, 0))
        self.date_frame = ttk.LabelFrame(right, text='解析范围与媒体', padding=(10, 6, 10, 8))
        self.date_frame.grid(row=2, column=0, sticky='ew', pady=(0, 8))
        dates = ttk.Frame(self.date_frame)
        dates.pack(fill='x')
        self.date_controls = []
        for label, variable in (('开始', self.start_date), ('结束', self.end_date)):
            ttk.Label(dates, text=label).pack(side='left')
            entry = ttk.Entry(dates, textvariable=variable, width=10)
            entry.pack(side='left', padx=4)
            button = ttk.Button(dates, text='日历', width=4, command=lambda variable=variable, label=label: self.choose_date(variable, label))
            button.pack(side='left', padx=(0, 10))
            self.date_controls += [entry, button]
        self.apply_date_button = ttk.Button(dates, text='应用日期', command=self.apply_dates)
        self.apply_date_button.pack(side='left', padx=(0, 6))
        self.clear_date_button = ttk.Button(dates, text='清空', width=5, command=self.clear_dates)
        self.clear_date_button.pack(side='left')
        self.date_controls += [self.apply_date_button, self.clear_date_button]
        options = ttk.Frame(self.date_frame)
        options.pack(fill='x', pady=(6, 0))
        ttk.Checkbutton(options, text='包含本机缓存图片和附件', variable=self.copy_media).pack(side='left')
        ttk.Label(options, text='日期同时用于阅读与导出，结束日含当天。', style='Sub.TLabel').pack(side='left', padx=14)
        self.date_frame.grid_remove()
        self.browser = MessageBrowser(right, notify=self.status.set, show_source=self.show_image_source)
        self.browser.grid(row=3, column=0, sticky='nsew')
        pagination = ttk.Frame(right, padding=(0, 8, 0, 8))
        pagination.grid(row=4, column=0, sticky='ew')
        ttk.Label(pagination, textvariable=self.page_text, style='Sub.TLabel').pack(side='left')
        pager = ttk.Frame(pagination)
        pager.pack(side='right')
        self.first_button = ttk.Button(pager, text='首页', width=5, command=lambda: self.read_page(0))
        self.previous_button = ttk.Button(pager, text='上一页', width=6, command=lambda: self.read_page(max(0, self.page_offset - int(self.page_size.get()))))
        self.next_button = ttk.Button(pager, text='下一页', width=6, command=lambda: self.read_page(self.page_offset + int(self.page_size.get())))
        self.last_button = ttk.Button(pager, text='末页', width=5, command=lambda: self.read_page())
        for widget in (self.first_button, self.previous_button, self.next_button, self.last_button):
            widget.pack(side='left', padx=(0, 4))
        ttk.Label(pager, text='每页').pack(side='left', padx=(8, 4))
        self.page_size_choice = ttk.Combobox(pager, textvariable=self.page_size, values=('100','300','500'), width=4, state='readonly')
        self.page_size_choice.pack(side='left')
        self.page_size_choice.bind('<<ComboboxSelected>>', lambda _event: self.read_page())
        exports = ttk.Frame(right, padding=(0, 8, 0, 0))
        exports.grid(row=5, column=0, sticky='ew')
        ttk.Separator(exports).pack(fill='x', pady=(0, 8))
        self.export_button = ttk.Button(exports, text='解析此群并导出', command=self.export, state='disabled')
        self.export_button.pack(side='right')
        ttk.Label(exports, text='导出结果').pack(side='left', padx=(0, 8))
        self.export_format_picker = ttk.Combobox(exports, textvariable=self.export_format, values=('MD','JSON','JSONL'), width=6, state='disabled')
        self.export_format_picker.pack(side='left')
        self.format_button = ttk.Button(exports, text='查看文件', command=self.open_export_file, state='disabled')
        self.format_button.pack(side='left', padx=6)
        self.folder_button = ttk.Button(exports, text='打开导出目录', command=lambda: self.open_result(True), state='disabled')
        self.folder_button.pack(side='left')
        bottom = ttk.Frame(self.root, padding=(14, 10, 14, 10))
        bottom.grid(row=3, column=0, sticky='ew')
        bottom.columnconfigure(1, weight=1)
        ttk.Label(bottom, text='状态', style='Sub.TLabel').grid(row=0, column=0, padx=(0, 8))
        ttk.Entry(bottom, textvariable=self.status, state='readonly').grid(row=0, column=1, sticky='ew')
        self.open_button = ttk.Button(bottom, text='业务全文', command=lambda: self.open_result(False), state='disabled')
        self.open_button.grid(row=0, column=2, padx=(8, 4))
        self.image_page_button = ttk.Button(bottom, text='图片网页', command=self.open_image_page, state='disabled')
        self.image_page_button.grid(row=0, column=3)
        ttk.Label(bottom, text='文件', style='Sub.TLabel').grid(row=1, column=0, padx=(0, 8), pady=(5, 0))
        ttk.Entry(bottom, textvariable=self.result_text, state='readonly').grid(row=1, column=1, columnspan=3, sticky='ew', pady=(5, 0))

    def toggle_date_filters(self, show=None):
        visible = bool(self.date_frame.winfo_manager())
        show = not visible if show is None else show
        if show:
            self.date_frame.grid()
        else:
            self.date_frame.grid_remove()
        self.date_toggle_button.configure(text='日期 / 媒体 ▴' if show else '日期 / 媒体 ▾')

    def clear_message_search(self):
        self.message_search.set('')
        self.read_page(0)

    def work(self, label, function, callback):
        if self.busy or self.closing:
            return
        self.busy = True
        self.status.set(label + '，请稍候…')
        self.progress.start(12)
        if self.source_progress is not None:
            self.source_progress.start(12)
        self.update_buttons()
        def run():
            try:
                self.events.put((callback, function(), None))
            except Exception as error:
                self.events.put((callback, None, safe_issue(error)))
        threading.Thread(target=run, daemon=True, name='local-chat-reader').start()

    def callback_error(self, kind, value, tb):
        startup.error('ui_callback_error', kind, tb)
        self.status.set('界面操作未完成，可重试；请点“打开诊断日志”反馈错误。')

    def open_diagnostics(self):
        path = startup.path()
        if path and path.is_file():
            try: os.startfile(str(path))
            except OSError: messagebox.showinfo('诊断日志', str(path), parent=self.root)

    def _drain(self):
        try:
            callback, value, issue = self.events.get_nowait()
        except queue.Empty:
            pass
        else:
            self.busy = False
            self.progress.stop()
            if self.source_progress is not None:
                self.source_progress.stop()
            if self.closing:
                self.root.destroy()
                return
            if issue:
                self.status.set('未完成：' + issue)
                if self.open_request:
                    self.publish_open('needs_source' if self.source_dialog is not None else 'failed', error=issue)
                if self.check_report:
                    self.finish_check({'error': issue})
                    return
            else:
                try:
                    callback(value)
                except Exception as error:
                    self.callback_error(type(error), error, error.__traceback__)
                if self.destroyed:
                    return
            self.update_buttons()
        self.root.after(80, self._drain)

    def update_buttons(self):
        state = 'disabled' if self.busy or self.closing else 'normal'
        for widget, original_state in self.source_controls:
            widget.configure(state='disabled' if state == 'disabled' else original_state)
        for widget in (self.refresh_button, self.source_button, self.scan_button):
            widget.configure(state=state)
        for widget in self.date_controls:
            widget.configure(state=state)
        self.search_entry.configure(state=state)
        self.parse_button.configure(state=state if self.groups else 'disabled')
        self.tree.state(['disabled'] if self.busy or self.closing else ['!disabled'])
        readable = self.active_chat and self.parsed_chat == self.active_chat
        self.kind_choice.configure(state='readonly' if state == 'normal' and readable else 'disabled')
        self.previous_button.configure(state='normal' if state == 'normal' and readable and self.page_offset > 0 else 'disabled')
        self.next_button.configure(state='normal' if state == 'normal' and readable and self.page_offset + int(self.page_size.get()) < self.page_total else 'disabled')
        self.first_button.configure(state=self.previous_button.cget('state'))
        self.last_button.configure(state=self.next_button.cget('state'))
        self.message_search_entry.configure(state=state if readable else 'disabled')
        self.message_search_button.configure(state=state if readable else 'disabled')
        self.message_clear_button.configure(state=state if readable else 'disabled')
        self.page_size_choice.configure(state='readonly' if state == 'normal' else 'disabled')
        self.export_button.configure(state='normal' if state == 'normal' and self.active_chat else 'disabled')
        result_state = 'normal' if state == 'normal' and self.session.last_export else 'disabled'
        self.open_button.configure(state=result_state)
        self.folder_button.configure(state=result_state)
        self.image_page_button.configure(state=result_state)
        self.format_button.configure(state=result_state)
        self.export_format_picker.configure(state='readonly' if result_state == 'normal' else 'disabled')

    def ready(self, value):
        if value['status'] != 'ready':
            startup.record('waiting_for_account_configuration', automaticClose=False)
            self.status.set(value['message'])
            self.source_issue = value['message']
            self.pending_config = value.get('config', {})
            self.publish_open('needs_source', message=value['message'])
            if self.check_report:
                self.finish_check({'error': value['message']})
            elif self.source_dialog is None:
                self.root.after(100, self.scan)
            return
        self.close_source_settings(reason='validated')
        startup.record('account_configuration_validated')
        self.pending_config = {}
        self.source_issue = ''
        self.groups = value['groups']
        self.clear_chat()
        self.search.set((self.open_request or {}).get('chat_name') or '')
        source = Path(self.session.archive.media_config.get('sourceRoot', ''))
        label = source.parent.name if source.name in ('db_storage', 'Data') else source.name
        self.account_text.set('当前账号目录：' + label + ' · 搜索仅查询群索引 · 仅解析目标群')
        self.render_groups()
        stamp = datetime.fromisoformat(value['snapshotTime']).astimezone(BEIJING).strftime('%Y-%m-%d %H:%M:%S')
        self.subtitle.set(value['message'] + ' · 副本时间 ' + stamp + '（北京时间）')
        self.status.set('请输入目标群名并按 Enter；只解析确认的群。' + (' ' + value['notice'] if value.get('notice') else ''))
        self.result_text.set('本机工作目录：' + str(self.session.directory))
        self.check_data.update(groups=len(self.groups), sourceStatus=value['message'], snapshotTime=value['snapshotTime'])
        if self.open_request:
            try:
                chat = self.session.archive.select_chat(**self.open_request)
            except ValueError:
                self.status.set('指定群不存在或名称重复，请搜索并选中正确群，再点“解析此群并导出”。')
                self.publish_open('needs_chat', message=self.status.get())
                if self.check_report:
                    self.finish_check({'error': self.status.get()})
                return
            self.start_parse(chat['id'])
            return
        if self.check_chat:
            candidates = [group['id'] for group in self.groups if group['name'] == self.check_chat]
            if len(candidates) != 1:
                self.finish_check({'error': '检查会话不存在或名称不唯一。'})
                return
            self.start_parse(candidates[0])
        elif self.check_report:
            self.finish_check({'ok': True})
        else:
            self.search_entry.focus_set()

    def clear_chat(self):
        self.active_chat = self.parsed_chat = None
        self.session.last_export = None
        self.auto_parse_result = None
        self.chat_title.set('输入目标群名后按 Enter')
        self.root.title(self.client_title)
        self.browser.clear()
        self.page_text.set('')
        self.result_text.set('')
        self.page_offset = self.page_total = 0

    def render_groups(self):
        selected = self.active_chat
        for item in self.tree.get_children():
            self.tree.delete(item)
        query = self.search.get().strip()
        choices = group_choices(self.groups, query, self.session.settings.get('lastChat')) if query else []
        self.group_title.set(f'匹配群聊 · {len(choices)} 个' if query else '搜索目标群聊')
        self.group_hint.set('搜索只查群名和ID。双击目标群，或选中后点击“解析此群并导出”。' if choices else
                            ('没有匹配的群聊，请调整关键词。' if query else '输入群名或ID，按Enter查找并解析；不会解析其他群。'))
        for group in choices:
            name = ('上次查看 · ' if group['recent'] else '') + group['choiceLabel']
            count = group.get('localMessageCount', '有记录' if group.get('hasLocalMessages') else '暂无')
            self.tree.insert('', 'end', iid=group['id'], values=(name, count))
        if selected and self.tree.exists(selected):
            self.tree.selection_set(selected)
        elif selected:
            self.clear_chat()
        self.update_buttons()

    def choose_search_result(self, _event=None):
        if self.busy:
            return
        query = self.search.get().strip()
        if not query:
            self.group_hint.set('请先输入要解析的目标群名。')
            self.search_entry.focus_set()
            return
        choices = self.tree.get_children()
        exact = [row['id'] for row in self.groups if row['id'] in choices and
                 (row['name'] == query or row['id'] == query)]
        matches = exact or list(choices)
        if len(matches) == 1:
            self.start_parse(matches[0])
        elif choices:
            self.group_hint.set(f'找到 {len(choices)} 个群，请在列表中选择；重名群会显示实际会话 ID。')
            self.tree.focus_set()

    def confirm_group(self, event):
        item = self.tree.identify_row(event.y)
        if item and not self.busy:
            self.tree.selection_set(item)
            self.selection()
            self.export()
        return 'break'

    def selection(self, _event=None):
        if self.busy:
            if self.active_chat and self.tree.exists(self.active_chat) and self.tree.selection() != (self.active_chat,):
                self.tree.selection_set(self.active_chat)
            return
        selected = self.tree.selection()
        if not selected or selected[0] == self.active_chat:
            return
        self.clear_chat()
        self.active_chat = selected[0]
        group = next(group for group in self.groups if group['id'] == self.active_chat)
        self.chat_title.set(group['name'])
        self.root.title(self.client_title + ' — ' + group['name'])
        self.filter_kind.set('业务阅读')
        self.browser.clear()
        self.status.set('已选中目标群，尚未解析。点击“解析此群并导出”或双击该结果。')
        self.update_buttons()

    def start_parse(self, chat):
        if self.busy or self.closing:
            return
        start, end = self.start_date.get().strip() or None, self.end_date.get().strip() or None
        try:
            date_range(start, end)
        except ValueError as error:
            self.status.set(str(error))
            return
        if not self.tree.exists(chat):
            group = next(group for group in self.groups if group['id'] == chat)
            self.search.set(group['name'])
        self.clear_chat()
        self.active_chat = chat
        group = next(group for group in self.groups if group['id'] == chat)
        self.chat_title.set(group['name'])
        self.root.title(self.client_title + ' — ' + group['name'])
        self.tree.selection_set(chat)
        self.tree.see(chat)
        self.filter_kind.set('业务阅读')
        self.message_search.set('')
        self.publish_open('parsing', chatName=group['name'])
        media = self.copy_media.get()
        size = int(self.page_size.get())
        self.work('仅解析指定群并准备查看',
                  lambda: self.session.parse_and_open(chat_id=chat, start=start, end=end, copy_media=media, page_size=size), self.parsed_ready)

    def parsed_ready(self, value):
        self.auto_parse_result = value
        self.parsed_chat = value['chat']['id']
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
        if not self.active_chat or self.parsed_chat != self.active_chat or self.busy:
            return
        chat, kind = self.active_chat, FILTERS[self.filter_kind.get()]
        size, query = int(self.page_size.get()), self.message_search.get()
        self.work('读取当前群记录', lambda: self.session.preview(chat, offset, kind, page_size=size, query=query), self.preview_ready)

    def choose_date(self, variable, label):
        if not self.busy:
            return DatePicker(self.root, variable, '选择' + label + '日期（北京时间）')

    def clear_dates(self):
        self.start_date.set('')
        self.end_date.set('')
        self.status.set('已清空日期。点击“应用日期”后重新解析当前群全部本地时间范围。')

    def apply_dates(self):
        if self.active_chat:
            self.start_parse(self.active_chat)
        else:
            self.status.set('请先搜索并选中目标群；日期选择后用于该群阅读和三格式导出。')

    def choose_kind(self, label):
        if self.active_chat and self.parsed_chat == self.active_chat and not self.busy:
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
        if self.check_report and not self.open_request and self.auto_parse_result is None:
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
                            from offline_view import OPEN_EXTENSIONS
                            if Path(asset.get('path', '')).suffix.lower() not in OPEN_EXTENSIONS:
                                results['unsupportedOpenFormats'] = results.get('unsupportedOpenFormats', 0) + 1
                                continue
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
        self.start_parse(self.active_chat)

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
            target = self.active_chat
            def refreshed(value):
                self.ready(value)
                if target and any(group['id'] == target for group in self.groups):
                    self.start_parse(target)
            self.work('更新副本和目标群缓存', lambda: self.session.open_source(config), refreshed)
        else:
            self.source_settings()

    def scan(self):
        self.work('识别当前微信进程与账号数据库',
                  lambda: identify_accounts(self.session.scan(), getattr(self.session, 'client', 'wechat')), self.scan_ready)

    def scan_ready(self, value):
        self.account_scan = value
        active = value.get('activeAccountCount', 0)
        self.status.set(f'发现 {len(value["accounts"])} 个账号目录，确认 {active} 个被当前客户端占用。' +
                        ('已对应唯一运行账号，确认后点击“一键自动配置”。' if value.get('recommendedSourceRoot') else
                         '请选择账号；归属未确认时可手动选择副本。'))
        self.source_settings(value['accounts'])

    def source_settings(self, accounts=None, *, manual=False):
        if self.busy:
            return
        if self.source_dialog is not None:
            if accounts is not None and self.account_choices_update is not None:
                self.account_choices_update(accounts)
            if manual:
                self.source_tabs.select(self.source_manual_tab)
            self.source_dialog.lift()
            self.source_dialog.focus_set()
            return
        dialog = tk.Toplevel(self.root)
        self.source_dialog = dialog
        startup.record('configuration_dialog_opened', automaticClose=False)
        dialog.title('选择本地数据')
        dialog.transient(self.root)
        dialog.grab_set()
        dialog.resizable(False, False)
        dialog.protocol('WM_DELETE_WINDOW', self.close_source_settings)
        ttk.Label(dialog, text='此窗口不会计时关闭；完成配置或主动关闭前会保持打开。', padding=(20, 8), style='Sub.TLabel').pack(fill='x')
        ttk.Label(dialog, textvariable=self.status, wraplength=740, padding=(20, 12)).pack(fill='x')
        self.source_progress = ttk.Progressbar(dialog, mode='indeterminate')
        self.source_progress.pack(fill='x', padx=20)
        setup_tabs = ttk.Notebook(dialog)
        self.source_tabs = setup_tabs
        setup_tabs.pack(fill='both', expand=True, padx=10, pady=10)
        automatic_tab, manual_tab = ttk.Frame(setup_tabs), ttk.Frame(setup_tabs)
        self.source_manual_tab = manual_tab
        setup_tabs.add(automatic_tab, text=' 自动配置（推荐） ')
        setup_tabs.add(manual_tab, text=' 手动选择 / 离线副本 ')
        if manual:
            setup_tabs.select(manual_tab)
        automatic = ttk.Frame(automatic_tab, padding=20)
        automatic.pack(fill='x')
        client_label = '企微' if self.session.client == 'wecom' else '个微'
        ttk.Label(automatic, text=f'首次使用：登录本人{client_label}后，一键自动配置', font=('Microsoft YaHei UI', 12, 'bold')).pack(anchor='w')
        setup_hint = ('只读所选企微账号，尝试恢复并校验数据库密钥；图片附件通过缓存摘要匹配。配置与个微分开保存。'
                      if self.session.client == 'wecom' else '先复用并校验本机已有密钥；没有时，只读尝试从所选账号已登录微信恢复数据库和图片密钥。')
        ttk.Label(automatic, text=setup_hint,
                  wraplength=720, style='Sub.TLabel').pack(anchor='w', pady=(5, 8))
        if self.source_issue:
            ttk.Label(automatic, text=self.source_issue, foreground='#a15b00', wraplength=720).pack(anchor='w', pady=(0, 8))
        frame = ttk.Frame(manual_tab, padding=20)
        frame.pack(fill='both', expand=True)
        ttk.Label(frame, text='手动配置（已有密钥或离线副本）：也可在下方选择文件。原始数据只读。').grid(row=0, column=0, columnspan=3, sticky='w', pady=(0, 15))
        config = dict(self.pending_config or (self.session.archive.media_config if self.session.archive else self.session.settings.get('source', {})))
        accounts = accounts if accounts is not None else self.account_scan.get('accounts', [])
        if not config.get('sourceRoot'):
            preferred = self.account_scan.get('recommendedSourceRoot')
            if preferred and any(item['sourceRoot'] == preferred for item in accounts):
                config['sourceRoot'] = preferred
            elif len(accounts) == 1:
                config['sourceRoot'] = accounts[0]['sourceRoot']
        entries = {}
        fields = [('sourceRoot', '账号数据或明文副本目录', True), ('keyFile', '已有数据库密钥文件', False),
                  ('imageKeyFile', '图片密钥（组合文件可留空）', False), ('selfId', '本人微信 ID（可选，不填保持未知）', None)]
        hints = {'sourceRoot': '选单个账号的 db_storage 或它的上一级账号目录；里面有 message、contact 等库。',
                 'keyFile': '选此前准备的密钥 JSON，不是微信密码，也不是任意 JSON；已解密副本可留空。',
                 'imageKeyFile': '用于解开部分图片缓存；若上面的 JSON 已含图片密钥，此处留空即可。'}
        if self.session.client == 'wecom':
            fields = [('sourceRoot', '企微账号目录 / Data / 明文副本', True), ('keyFile', '已有企微数据库密钥（可留空）', False),
                      ('selfId', '本人企微 ID（可选）', None)]
            hints['sourceRoot'] = r'例如：文档\WXWork\账号目录；Data 内有 message.db、session.db、user.db。'
            hints['keyFile'] = '自动配置成功后无需找文件；离线密文需匹配的企微 wecomKeys JSON，不能使用个微密钥。'
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
        choices = {}
        selected = tk.StringVar()
        picker = ttk.Frame(automatic)
        picker.pack(fill='x', pady=(0, 8))
        ttk.Label(picker, text='选择要解析的账号').pack(anchor='w', pady=(0, 6))
        chooser = ttk.Combobox(picker, textvariable=selected, state='readonly', width=72)
        chooser.pack(fill='x')
        def select_account(_event=None):
            path = choices.get(selected.get())
            if path and not same_account_source(entries['sourceRoot'].get(), path, self.session.client):
                for key in ('keyFile', 'imageKeyFile', 'selfId'):
                    if key in entries:
                        entries[key].set('')
                entries['sourceRoot'].set(path)
        chooser.bind('<<ComboboxSelected>>', select_account)
        def update_accounts(items):
            choices.clear()
            states = {'active': '运行中，归属已确认', 'inactive': '未检测到占用',
                      'ambiguous': '多个进程占用', 'unavailable': '归属未确认'}
            for index, item in enumerate(items):
                state = states.get(item.get('processState'), '归属未确认')
                pids = ','.join(str(pid) for pid in item.get('processIds', []))
                label = f'{index + 1}. {item["directoryLabel"]} · {state}' + (' · PID ' + pids if pids else '')
                label += f' · {len(item.get("databases", []))}个数据库'
                choices[label] = item['sourceRoot']
            chooser.configure(values=list(choices))
            if not entries['sourceRoot'].get():
                preferred = self.account_scan.get('recommendedSourceRoot')
                if preferred and preferred in choices.values():
                    entries['sourceRoot'].set(preferred)
                elif len(choices) == 1:
                    entries['sourceRoot'].set(next(iter(choices.values())))
            selected.set('')
            for label, path in choices.items():
                if same_account_source(path, entries['sourceRoot'].get(), self.session.client):
                    selected.set(label)
                    break
        self.account_choices_update = update_accounts
        update_accounts(accounts)
        ttk.Label(automatic, text='对应数据库目录', style='Sub.TLabel').pack(anchor='w', pady=(3, 0))
        ttk.Label(automatic, textvariable=entries['sourceRoot'], wraplength=720).pack(anchor='w', pady=(3, 8))
        ttk.Button(automatic, text='重新识别运行账号', command=self.scan).pack(anchor='w', pady=(0, 10))
        include_media = tk.BooleanVar(value=config.get('includeMedia', True))
        include_voice = tk.BooleanVar(value=config.get('includeVoice', False))
        ttk.Checkbutton(frame, text='包含附件索引（需要对应数据库密钥）', variable=include_media).grid(row=10, column=0, columnspan=3, sticky='w', pady=(12, 5))
        if self.session.client == 'wechat':
            ttk.Checkbutton(frame, text='包含语音原件库（需要额外匹配密钥）', variable=include_voice).grid(row=11, column=0, columnspan=3, sticky='w')
        ttk.Label(frame, text='“匹配”指密钥能通过所选数据库的解密校验，改文件名不会产生密钥。只保存文件路径。', style='Sub.TLabel').grid(row=12, column=0, columnspan=3, sticky='w', pady=(8, 14))
        def form_value():
            value = {key: variable.get().strip() for key, variable in entries.items()}
            if config.get('sourceRoot') and not same_account_source(value['sourceRoot'], config['sourceRoot'], self.session.client):
                for key in ('keyFile', 'imageKeyFile', 'selfId'):
                    if value.get(key) == config.get(key):
                        value[key] = ''
            value.update(includeMedia=include_media.get(), includeVoice=include_voice.get())
            return value
        def load():
            value = form_value()
            self.pending_config = value
            self.work('创建并校验本地副本', lambda: self.session.open_source(value), self.ready)
        ttk.Button(frame, text='保存并加载', command=load).grid(row=13, column=2, sticky='e')
        def configure_automatically():
            value = form_value()
            if not value['sourceRoot']:
                self.status.set('请先选择一个账号；微信刚登录时可点击“重新识别运行账号”，已有副本可切到手动页。')
                return
            self.pending_config = value
            startup.record('automatic_configuration_requested')
            self.work('自动校验数据、匹配密钥并加载',
                      lambda: self.session.automatic_setup(value, allow_process_read=True), self.ready)
        ttk.Button(automatic, text='一键自动配置', command=configure_automatically).pack(anchor='w')
        ttk.Separator(automatic, orient='horizontal').pack(fill='x', pady=(12, 0))
        def choose_workbench():
            path = filedialog.askopenfilename(parent=dialog, title='选择已有工作台的 database-config.json', filetypes=[('JSON 文件', '*.json')])
            if path:
                self.work('加载已有工作台配置', lambda: self.session.open_workbench(path), self.ready)
        if self.session.client == 'wechat':
            ttk.Button(frame, text='使用已有工作台配置…', command=choose_workbench).grid(row=13, column=0, columnspan=2, sticky='w')
        def import_legacy():
            path = filedialog.askopenfilename(parent=dialog, title='选择本人旧版的 settings.local.json',
                                             filetypes=[('旧版账号配置', 'settings.local.json')])
            if path:
                self.work('校验并迁移所选旧配置', lambda: self.session.import_settings(path), self.ready)
        ttk.Button(frame, text='导入旧版配置…', command=import_legacy).grid(row=13, column=2, sticky='e')
        def recover():
            value = form_value()
            if not value['sourceRoot']:
                messagebox.showinfo('先选择数据', '请选择本人在本机已登录微信使用的实际账号数据目录；只有离线副本时请提供已有密钥。', parent=dialog)
                return
            self.pending_config = value
            def run_recovery():
                if self.session.client == 'wecom':
                    return self.session.automatic_setup(value, allow_process_read=True)
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
        ttk.Button(frame, text=f'没有密钥：从本机已登录{client_label}尝试恢复', command=recover).grid(row=14, column=0, columnspan=3, sticky='w', pady=(14, 0))
        def remember_controls(parent):
            for child in parent.winfo_children():
                if isinstance(child, (ttk.Button, ttk.Entry, ttk.Combobox, ttk.Checkbutton)):
                    self.source_controls.append((child, str(child.cget('state'))))
                remember_controls(child)
        remember_controls(dialog)

    def close_source_settings(self, reason='user'):
        if self.busy:
            self.status.set('正在处理本地配置，请等待完成后再关闭；当前窗口会保持打开。')
            return
        dialog = self.source_dialog
        self.source_dialog = None
        self.source_controls = []
        self.source_progress = None
        self.account_choices_update = None
        if dialog is not None:
            startup.record('configuration_dialog_closed', reason=reason)
            dialog.destroy()

    def open_export_file(self):
        if not self.session.last_export:
            return
        names = {'JSONL': 'messages.jsonl', 'JSON': 'messages.json', 'MD': 'messages.md'}
        name = names.get(self.export_format.get())
        if not name:
            return
        target = self.session.last_export / name
        if not target.is_file():
            messagebox.showinfo('此导出未包含该格式', '请点击“解析此群并导出”，会同时生成 JSONL、JSON 和 MD。', parent=self.root)
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
        startup.record('window_close_requested', busy=self.busy)
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
    parser.add_argument('--client', choices=('wechat', 'wecom'), default='wechat')
    parser.add_argument('--task-json', type=Path, help='执行本地 JSON 任务，无需打开窗口')
    parser.add_argument('--launch-desktop-json', type=Path, help=argparse.SUPPRESS)
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
    from offline_profiles import default_directory
    directory = args.data_dir or default_directory(args.client)
    if args.launch_desktop_json:
        if not args.result_json or args.task_json or args.open_chat or args.open_chat_name or args.check_launch:
            parser.error('Invalid desktop launch arguments.')
        from offline_launcher import launch
        return launch(args.launch_desktop_json, args.result_json, directory, args.client)
    if args.task_json or args.result_json:
        if not args.task_json or not args.result_json:
            parser.error('--task-json 和 --result-json 必须同时提供。')
        from offline_batch import run_file
        return run_file(args.task_json, args.result_json, directory, client=args.client)
    startup.begin(directory, args.client)
    startup.record('window_initializing', diagnosticAutoExit=bool(args.check_launch))
    root = tk.Tk()
    session = DesktopSession(directory, args.workbench if args.client == 'wechat' else None, client=args.client)
    ChatApp(root, session, check_report=args.check_launch, check_chat=args.check_export_chat,
            open_chat=args.open_chat, open_chat_name=args.open_chat_name, open_result=args.open_result_json)
    root.mainloop()
    startup.record('window_closed')
    return 0


if __name__ == '__main__':
    import multiprocessing
    multiprocessing.freeze_support()
    raise SystemExit(main())
