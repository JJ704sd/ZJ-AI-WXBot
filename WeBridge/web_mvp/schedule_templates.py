"""Account-local text composition templates; no scheduling or sending side effects."""
from contextlib import closing
import json
import re
import sqlite3

from windows_hook_sender import validate_text


class TemplateConflict(ValueError):
    pass


class MissingTemplateValues(ValueError):
    def __init__(self, missing):
        self.missing = missing
        super().__init__('请填写变量：'+'、'.join(missing)+'。')


def _render_profile(payload, profile):
    text, values = profile['overrideText'], profile['values']
    if text is None:
        missing = [key for key in _variables(payload['text']) if key not in values or not values[key].strip()]
        if missing: raise MissingTemplateValues(missing)
        text = re.sub(r'\{\{([^{}]+)\}\}', lambda match:values[match.group(1)], payload['text'])
    validate_text(text)
    return text


def _variables(text):
    variables, position = [], 0
    while match := re.search(r'\{\{|\}\}', text[position:]):
        start = position+match.start()
        end = text.find('}}', start+2)
        if match.group()!='{{' or end<0:
            raise ValueError('占位符须使用完整的 {{变量名}}。')
        key = text[start+2:end]
        if not 1<=len(key)<=32 or not key.isidentifier():
            raise ValueError('变量名须为 1–32 字符的合法标识符，不支持表达式。')
        if key not in variables: variables.append(key)
        if len(variables)>20: raise ValueError('每个模板最多使用 20 个变量。')
        position = end+2
    return variables


def _identity(id):
    if not isinstance(id, str) or not re.fullmatch(r'[A-Za-z0-9_-]{16,100}', id):
        raise ValueError('模板标识无效。')


def _version(version, *, new=False):
    if type(version) is not int or version < (0 if new else 1):
        raise ValueError('模板版本无效，请重新加载。')


class ScheduleTemplates:
    def __init__(self, engine):
        self.engine = engine
        self.path = engine.store.path.parent/'schedule-templates.sqlite'
        with closing(self._db()) as db, db:
            db.execute('''CREATE TABLE IF NOT EXISTS templates (
                account TEXT NOT NULL, id TEXT NOT NULL, version INTEGER NOT NULL,
                payload TEXT NOT NULL, PRIMARY KEY(account,id))''')

    def _db(self):
        db = sqlite3.connect(self.path, timeout=10)
        db.row_factory = sqlite3.Row
        db.execute('PRAGMA synchronous=FULL')
        return db

    def _account(self, account):
        if not account or account!=self.engine.account:
            raise ValueError('账号已变化，请重新加载。')

    @staticmethod
    def _row(db, account, id, version=None):
        row = db.execute('SELECT * FROM templates WHERE account=? AND id=?', (account,id)).fetchone()
        if version is not None and (row is None or row['version']!=version):
            raise TemplateConflict('模板已更新或删除，请重新加载后核对。')
        if row is None: raise ValueError('当前账号下找不到此模板。')
        return row

    @staticmethod
    def _view(id, version, payload, groupId=''):
        variables = _variables(payload['text'])
        profile = payload['profiles'].get(groupId, {'values':{}, 'overrideText':None})
        return {'id':id, 'name':payload['name'], 'text':payload['text'], 'version':version,
            'variables':variables,
            'targets':[{'groupId':group,'targetName':profile['targetName']} for group,profile in payload['profiles'].items()],
            'groupId':groupId, 'profile':{'values':{key:value for key,value in profile['values'].items() if key in variables},
                'overrideText':profile['overrideText']}}

    def list(self, account):
        with self.engine.lock, closing(self._db()) as db:
            self._account(account)
            rows = db.execute('SELECT * FROM templates WHERE account=? ORDER BY rowid DESC', (account,)).fetchall()
            templates = []
            for row in rows:
                payload = json.loads(row['payload'])
                templates.append({'id':row['id'], 'name':payload['name'], 'version':row['version'],
                    'variables':_variables(payload['text']), 'targetCount':len(payload['profiles'])})
            return {'templates':templates}

    def item(self, account, id, groupId=''):
        _identity(id)
        with self.engine.lock, closing(self._db()) as db:
            self._account(account)
            row = self._row(db, account, id)
            payload = json.loads(row['payload'])
            if groupId: self._group(payload, groupId)
            elif groupId!='': raise ValueError('模板会话标识无效。')
            return self._view(id, row['version'], payload, groupId)

    def save(self, account, id, version, name, text):
        _identity(id)
        _version(version, new=True)
        if not isinstance(name, str) or not name.strip() or len(name)>80:
            raise ValueError('模板名称须为 1–80 字符。')
        validate_text(name)
        validate_text(text)
        _variables(text)
        name = name.strip()
        with self.engine.lock, closing(self._db()) as db, db:
            self._account(account)
            db.execute('BEGIN IMMEDIATE')
            row = db.execute('SELECT * FROM templates WHERE account=? AND id=?', (account,id)).fetchone()
            if row is not None:
                payload = json.loads(row['payload'])
                same = payload['name']==name and payload['text']==text
                if version==0 and row['version']==1 and same:
                    return self._view(id, row['version'], payload)
                if row['version']!=version: raise TemplateConflict('模板已更新，请重新加载后核对。')
                if same: return self._view(id, version, payload)
                payload.update(name=name, text=text)
                db.execute('UPDATE templates SET version=?,payload=? WHERE account=? AND id=?',
                    (version+1,json.dumps(payload,ensure_ascii=False),account,id))
            else:
                if version: raise TemplateConflict('模板已删除，请重新加载后核对。')
                if db.execute('SELECT count(*) FROM templates WHERE account=?', (account,)).fetchone()[0]>=100:
                    raise ValueError('当前账号最多保存 100 个模板。')
                payload = {'name':name, 'text':text, 'profiles':{}}
                db.execute('INSERT INTO templates VALUES (?,?,?,?)',
                    (account,id,1,json.dumps(payload,ensure_ascii=False)))
            return self._view(id, version+1, payload)

    def _group(self, payload, groupId):
        if not isinstance(groupId, str) or not groupId or len(groupId)>256:
            raise ValueError('模板会话标识无效。')
        known = next((group for group in self.engine.group_list if group['id']==groupId), None)
        if known is not None: return known['name']
        if groupId in payload['profiles']: return payload['profiles'][groupId]['targetName']
        raise ValueError('请从当前账号的已知会话中选择目标。')

    def _profile_data(self, payload, groupId, values, overrideText):
        target = self._group(payload, groupId)
        variables = _variables(payload['text'])
        if not isinstance(values, dict) or any(key not in variables for key in values):
            raise ValueError('变量值须只包含当前模板的变量名。')
        for value in values.values():
            validate_text(value, allow_empty=True)
            if len(value)>500: raise ValueError('每个变量值最多 500 字符。')
        if overrideText is not None: validate_text(overrideText, allow_empty=True)
        return {'targetName':target, 'values':values, 'overrideText':overrideText}

    def profile(self, account, id, version, groupId, values, overrideText):
        _identity(id)
        _version(version)
        with self.engine.lock, closing(self._db()) as db, db:
            self._account(account)
            db.execute('BEGIN IMMEDIATE')
            payload = json.loads(self._row(db, account, id, version)['payload'])
            profile = self._profile_data(payload, groupId, values, overrideText)
            if groupId not in payload['profiles'] and len(payload['profiles'])>=500:
                raise ValueError('每个模板最多保存 500 个会话配置。')
            payload['profiles'][groupId] = profile
            db.execute('UPDATE templates SET version=?,payload=? WHERE account=? AND id=?',
                (version+1,json.dumps(payload,ensure_ascii=False),account,id))
            return self._view(id, version+1, payload, groupId)

    def preview(self, account, id, version, groupId, values, overrideText):
        _identity(id)
        _version(version)
        with self.engine.lock, closing(self._db()) as db:
            self._account(account)
            payload = json.loads(self._row(db, account, id, version)['payload'])
            profile = self._profile_data(payload, groupId, values, overrideText)
            text = _render_profile(payload, profile)
            return {'id':id, 'version':version, 'groupId':groupId, 'templateName':payload['name'], 'text':text}

    def render_saved(self, account, id, version, groupIds):
        """Render a single saved template revision, preserving per-target errors."""
        _identity(id)
        _version(version)
        with self.engine.lock, closing(self._db()) as db:
            self._account(account)
            payload = json.loads(self._row(db, account, id, version)['payload'])
            variables = _variables(payload['text'])
            records = []
            for group in groupIds:
                saved = payload['profiles'].get(group, {'values':{}, 'overrideText':None})
                values = {key:value for key,value in saved['values'].items() if key in variables}
                record = {'groupId':group, 'text':'',
                    'contentSource':'override' if saved['overrideText'] is not None else 'template',
                    'error':'', 'missing':[]}
                try:
                    profile = self._profile_data(payload, group, values, saved['overrideText'])
                    record['text'] = _render_profile(payload, profile)
                except MissingTemplateValues as error:
                    record.update(error=str(error), missing=error.missing)
                except ValueError as error:
                    record['error'] = str(error)
                records.append(record)
            return payload['name'], records

    def delete(self, account, id, version):
        _identity(id)
        _version(version)
        with self.engine.lock, closing(self._db()) as db, db:
            self._account(account)
            db.execute('BEGIN IMMEDIATE')
            self._row(db, account, id, version)
            db.execute('DELETE FROM templates WHERE account=? AND id=?', (account,id))
            return {'deleted':True}
