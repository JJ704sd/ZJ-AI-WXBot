"""Small native date picker; only Python's bundled calendar and Tk are used."""
import calendar
from datetime import date
import tkinter as tk
from tkinter import ttk


class DatePicker(tk.Toplevel):
    def __init__(self, parent, variable, title='选择日期'):
        super().__init__(parent)
        self.variable = variable
        self.title(title)
        self.transient(parent)
        self.resizable(False, False)
        try:
            selected = date.fromisoformat(variable.get())
        except ValueError:
            selected = date.today()
        self.year, self.month = selected.year, selected.month
        controls = ttk.Frame(self, padding=10)
        controls.pack(fill='x')
        ttk.Button(controls, text='上月', command=lambda: self.move(-1)).pack(side='left')
        self.caption = ttk.Label(controls, width=18, anchor='center')
        self.caption.pack(side='left')
        ttk.Button(controls, text='下月', command=lambda: self.move(1)).pack(side='left')
        jump = ttk.Frame(self, padding=(10, 0, 10, 6))
        jump.pack(fill='x')
        self.year_value = tk.StringVar(value=str(self.year))
        self.month_value = tk.StringVar(value=str(self.month))
        ttk.Spinbox(jump, from_=1, to=9999, width=6, textvariable=self.year_value).pack(side='left')
        ttk.Label(jump, text='年').pack(side='left', padx=4)
        ttk.Combobox(jump, values=tuple(map(str,range(1,13))), width=4, state='readonly', textvariable=self.month_value).pack(side='left')
        ttk.Label(jump, text='月').pack(side='left', padx=4)
        ttk.Button(jump, text='跳转', command=self.jump).pack(side='right')
        self.days = ttk.Frame(self, padding=(10, 0, 10, 10))
        self.days.pack()
        bottom = ttk.Frame(self, padding=(10, 0, 10, 10))
        bottom.pack(fill='x')
        ttk.Button(bottom, text='今天', command=lambda: self.choose(date.today())).pack(side='left')
        ttk.Button(bottom, text='清空日期', command=lambda: self.choose(None)).pack(side='left', padx=8)
        ttk.Button(bottom, text='取消', command=self.destroy).pack(side='right')
        self.draw()
        self.bind('<Escape>', lambda _event: self.destroy())
        self.update_idletasks()
        self.geometry(f'+{parent.winfo_rootx()+80}+{parent.winfo_rooty()+80}')
        self.grab_set()

    def move(self, step):
        ordinal = self.year * 12 + self.month - 1 + step
        year, month = divmod(ordinal, 12)
        if 1 <= year <= 9999:
            self.year, self.month = year, month + 1
            self.draw()

    def draw(self):
        self.caption.configure(text=f'{self.year}年 {self.month}月')
        self.year_value.set(str(self.year))
        self.month_value.set(str(self.month))
        for child in self.days.winfo_children():
            child.destroy()
        for column, label in enumerate('一二三四五六日'):
            ttk.Label(self.days, text=label, anchor='center', width=5).grid(row=0, column=column)
        for row, week in enumerate(calendar.monthcalendar(self.year, self.month), 1):
            for column, day in enumerate(week):
                if day:
                    ttk.Button(self.days, text=str(day), width=5,
                        command=lambda day=day: self.choose(date(self.year, self.month, day))).grid(row=row, column=column, padx=1, pady=1)

    def jump(self):
        try:
            target = date(int(self.year_value.get()), int(self.month_value.get()), 1)
        except ValueError:
            return
        self.year, self.month = target.year, target.month
        self.draw()

    def choose(self, value):
        self.variable.set(value.isoformat() if value else '')
        self.destroy()
