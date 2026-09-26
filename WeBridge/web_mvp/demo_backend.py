"""Synthetic local workbench data; this adapter never opens an external connection."""
import threading
import time

from backend import BridgeError


class DemoAdapter:
    mode = 'demo'
    account = 'demo-account'
    self_id = 'demo-self'

    def __init__(self):
        self.logged_in = True
        self.lock = threading.RLock()
        self.groups = [
            {'id': 'demo-project@chatroom', 'name': '项目协作群 · 演示'},
            {'id': 'demo-service@chatroom', 'name': '客户服务群 · 演示'},
            {'id': 'demo-notices@chatroom', 'name': '每日通知群 · 演示'},
        ]
        self.members = [
            {'id': self.self_id, 'name': '演示工作台', 'kind': '演示账号'},
            {'id': 'demo-xiaolin', 'name': '小林', 'kind': '演示成员'},
            {'id': 'demo-chen', 'name': '陈工', 'kind': '演示成员'},
            {'id': 'demo-xiaozhou', 'name': '小周', 'kind': '演示成员'},
        ]
        examples = [
            [('小林', 'demo-xiaolin', '欢迎来到 Windows 工作台。这些群聊与消息均为本地演示数据。', False),
             ('陈工', 'demo-chen', '@演示工作台 请整理今天的项目进度。', True),
             ('小周', 'demo-xiaozhou', '可以试试筛选 @ 我、选择成员、模拟发送和创建每日任务。', False)],
            [('小林', 'demo-xiaolin', '这里用于演示不同群聊的独立回复规则。', False),
             ('小周', 'demo-xiaozhou', '@演示工作台 工作台支持哪些功能？', True)],
            [('陈工', 'demo-chen', '每日任务按上海时间运行，重启后错过的任务不会补发。', False)],
        ]
        now = int(time.time())
        self.messages = {}
        for index, group in enumerate(self.groups):
            self.messages[group['id']] = [
                {'id': f'demo-{index}-{n}', 'serverId': f'demo-{index}-{n}',
                 'senderId': sender, 'senderName': name, 'timestamp': now - 180 + n * 35,
                 'kind': 'text', 'text': text, 'isSelf': False, 'mentionSelf': mention,
                 'mentionEveryone': False, 'source': 'demo'}
                for n, (name, sender, text, mention) in enumerate(examples[index])
            ]

    def auth(self):
        with self.lock:
            return {'status': 'logged_in', 'loggedInUser': self.account, 'demo': True} if self.logged_in else {'status': 'logged_out', 'demo': True}

    def login(self):
        with self.lock:
            self.logged_in = True

    def logout(self):
        with self.lock:
            self.logged_in = False
        return {'success': True, 'simulated': True}

    def call(self, action, **params):
        with self.lock:
            if not self.logged_in or params.get('account') != self.account:
                raise BridgeError('演示会话已退出，请重新连接演示。')
            if action == 'groups':
                return {'account': self.account, 'selfId': self.self_id, 'name': '演示工作台', 'groups': self.groups}
            group_id = params.get('groupId')
            if group_id not in self.messages:
                raise BridgeError('请选择有效的演示群聊。')
            if action == 'members':
                return {'members': self.members}
            if action == 'messages':
                return {'messages': self.messages[group_id]}
            if action == 'group_info':
                return {'id': group_id, 'name': next(g['name'] for g in self.groups if g['id'] == group_id),
                        'ownerId': 'demo-chen', 'ownerName': '陈工', 'notice': '本地合成示例，不连接微信。', 'members': self.members,
                        'memberCount': len(self.members)}
            if action == 'send':
                names = {m['id']: m['name'] for m in self.members}
                mentions = params.get('mentionIds', [])
                if any(member not in names or member == self.self_id for member in mentions):
                    raise BridgeError('请选择当前演示群的有效成员。')
                return {'status': 'sent', 'simulated': True,
                        'text': params['text'] + ''.join('  @' + names[member] for member in mentions)}
            if action == 'media':
                return {'status': 'unavailable', 'reason': '演示模式不包含真实微信附件。'}
            raise BridgeError('演示模式不支持此操作。')


def prepare_demo(engine):
    """Populate the synthetic account only; preserve subsequent user selections."""
    account = engine.adapter.account
    initial = engine.store.watched(account) is None
    engine.refresh_connection()
    if initial:
        engine.set_watched(account, [group['id'] for group in engine.group_list])
    for group in engine.store.watched(account) or []:
        engine.sync_group(account, group)
    engine.selected = next(iter(engine.store.watched(account) or []), None)
