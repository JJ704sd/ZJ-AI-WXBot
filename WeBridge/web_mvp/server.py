#!/usr/bin/env python3
"""Local-only Windows/Linux workbench with isolated demo and Docker live modes."""
import argparse
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
import json
import mimetypes
import os
from pathlib import Path
import secrets
import threading
import time
from urllib.parse import parse_qs, urlsplit, quote

from backend import Adapter, BridgeError, Engine, ROOT, Store
from demo_backend import DemoAdapter, prepare_demo
from media_host import MediaCache, byte_range
from runtime_support import ProcessLock, environment_report, runtime_summary


class LoginFlow:
    def __init__(self,engine):
        self.engine=engine;self.lock=threading.Lock();self.state={'type':'idle'};self.running=False

    def snapshot(self):
        with self.lock:return {**self.state,'running':self.running}

    def start(self):
        with self.lock:
            if self.engine.read_only:raise ValueError('数据库副本无需微信登录，也不操作客户端登录状态。')
            if self.running:return
            if getattr(self.engine.adapter,'mode','live')=='demo':
                self.engine.adapter.login();self.engine.refresh_connection(force=True)
                self.state={'type':'login_success','message':'演示会话已连接。'};return
            if self.engine.adapter.auth().get('status')=='logged_in':
                self.state={'type':'login_success'};return
            self.running=True;self.state={'type':'status','message':'正在准备微信登录…'}
        threading.Thread(target=self.run,daemon=True).start()

    def run(self):
        try:
            from websockets.sync.client import connect
            token=(ROOT/'.secrets/linux-token').read_text().strip()
            with connect('ws://127.0.0.1:16174/api/ws/login?timeoutMs=180000&newAccount=true',
                    additional_headers={'Authorization':'Bearer '+token},proxy=None,max_size=2*1024*1024) as ws:
                for message in ws:
                    event=json.loads(message)
                    # Only the QR image and user-facing state cross into the UI.
                    state={k:event[k] for k in ('type','qrDataUrl','message') if k in event}
                    if state.get('type')=='status':state['message']='正在连接微信并准备账号数据…'
                    if state.get('type')=='phone_confirm':state['message']='请在手机微信上确认登录。'
                    with self.lock:self.state=state
                    if event.get('type') in ('login_success','login_timeout','error'):break
            if self.state.get('type')=='login_success':self.engine.refresh_connection(force=True)
        except Exception:
            with self.lock:self.state={'type':'error','message':'登录连接中断，请检查客户端后重新获取二维码。'}
        finally:
            with self.lock:self.running=False


def make_handler(engine,login,csrf,port,media_cache=None,database_service=None,desktop_sender=None,hook_sender=None):
    allowed={f'127.0.0.1:{port}',f'localhost:{port}'}
    origins={'http://'+x for x in allowed}
    static=Path(__file__).parent/'static'
    media=media_cache or MediaCache(engine)

    def hook_binding():
        # Callers hold the source lock through validation and the send operation.
        if database_service is None or not database_service.config or not engine.account:
            raise ValueError('请先连接当前账号的数据库副本。')
        config=database_service.config
        if not config.get('selfId') or config['selfId']!=engine.self_id:
            raise ValueError('当前副本的本人微信标识尚未确认。')
        return {'account':engine.account,'sourceId':engine.account,
                'selfId':config['selfId'],'sourceRoot':config['sourceRoot']}

    def hook_target(data):
        account=data.get('account');group=data.get('groupId')
        engine.validate(account,group)
        if group!=engine.selected or group not in (engine.store.watched(account) or []):
            raise ValueError('请先选择并勾选当前要发送的会话。')
        if data.get('targetId',group)!=group:
            raise ValueError('发送目标与当前会话不一致。')
        target=next(row for row in engine.group_list if row['id']==group)
        return {'targetId':group,'targetName':target.get('name') or group}

    class Handler(BaseHTTPRequestHandler):
        def log_message(self,fmt,*args):pass

        def headers_common(self):
            self.send_header('Cache-Control','no-store')
            self.send_header('X-Content-Type-Options','nosniff')
            self.send_header('Referrer-Policy','no-referrer')
            self.send_header('Content-Security-Policy',"default-src 'self'; script-src 'self'; worker-src 'self'; style-src 'self' 'unsafe-inline'; img-src 'self' data:; media-src 'self'; connect-src 'self'; frame-src 'self'; frame-ancestors 'self'; base-uri 'self'; object-src 'none'")

        def respond(self,value,status=200):
            data=json.dumps(value,ensure_ascii=False).encode()
            self.send_response(status);self.headers_common()
            self.send_header('Content-Type','application/json; charset=utf-8');self.send_header('Content-Length',str(len(data)))
            self.end_headers();self.wfile.write(data)

        def check_host(self):
            if self.headers.get('Host') not in allowed:
                self.respond({'error':'Host rejected'},403);return False
            if self.headers.get('Sec-Fetch-Site')=='cross-site':
                self.respond({'error':'Cross-site access rejected'},403);return False
            return True

        def do_GET(self):
            if not self.check_host():return
            parsed=urlsplit(self.path);path=parsed.path;params={k:v[0] for k,v in parse_qs(parsed.query).items()}
            try:
                if path=='/api/state':
                    self.respond({**engine.snapshot(),'login':login.snapshot(),'csrfToken':csrf,'runtime':runtime_summary(engine)});return
                if path=='/api/environment':
                    self.respond(environment_report(engine));return
                if path=='/api/database':
                    if database_service is None:self.respond({'error':'请使用 Database 模式启动工作台。'},400);return
                    self.respond(database_service.snapshot());return
                if path=='/api/windows/hook/status':
                    if hook_sender is None or database_service is None:
                        self.respond({'available':False,'status':'unavailable','issue':'当前模式未启用 Windows Hook 发送。'});return
                    with database_service.lock:
                        binding=hook_binding() if database_service.config and engine.account else None
                        self.respond(hook_sender.status(binding));return
                if path=='/api/windows/hook/attempt':
                    if hook_sender is None or database_service is None:raise ValueError('当前模式未启用 Windows Hook 发送。')
                    with database_service.lock:
                        binding=hook_binding()
                        if params.get('account')!=binding['account']:raise ValueError('账号已变化，请刷新页面。')
                        draft_id=params.get('draftId')
                        result=hook_sender.get(draft_id,binding)
                        target=result.get('targetId')
                        engine.validate(binding['account'],target)
                        if target not in (engine.store.watched(binding['account']) or []):
                            raise ValueError('该会话已取消读取。')
                        if result.get('serverAccepted') and not result.get('localRecordConfirmed'):
                            messages=engine.adapter.call('messages',account=binding['account'],groupId=target)['messages']
                            result=hook_sender.reconcile(draft_id,messages,binding,target_id=target)
                        self.respond(result);return
                if path=='/api/windows/status':
                    from windows_client import status
                    self.respond(status());return
                if path=='/api/windows/sender':
                    from windows_client import status
                    info=status() if desktop_sender is not None else {'windows':[]}
                    windows=[row for row in info.get('windows',[]) if row.get('visible')]
                    ready=bool(database_service and database_service.config and engine.account)
                    self.respond({'supported':desktop_sender is not None,'available':bool(ready and windows),
                                  'status':'ready' if ready and windows else 'unavailable','windows':windows,
                                  'targetId':'filehelper','issue':('请先创建数据库副本。' if not ready else
                                  '选择当前微信窗口，核对文件传输助手后准备草稿。' if windows else '请打开本机微信主窗口。')});return
                if path=='/api/asset':
                    if engine.read_only:raise ValueError('数据库副本模式暂不提供附件读取。')
                    entry=media.get(params.get('id'),params.get('account'));info=entry['public'];size=info['size']
                    try:start,end=byte_range(self.headers.get('Range'),size)
                    except ValueError:self.respond({'error':'Range not satisfiable'},416);return
                    self.send_response(206 if self.headers.get('Range') else 200);self.headers_common()
                    mime=info['mime'];inline=mime.startswith(('image/','video/')) or mime in ('application/pdf','text/plain')
                    disposition='inline' if inline and params.get('download')!='1' else 'attachment'
                    self.send_header('Content-Type',mime+('; charset=utf-8' if mime=='text/plain' else ''))
                    self.send_header('Content-Disposition',f"{disposition}; filename*=UTF-8''{quote(info['filename'],safe='')}")
                    self.send_header('Accept-Ranges','bytes');self.send_header('Content-Length',str(end-start+1))
                    if self.headers.get('Range'):self.send_header('Content-Range',f'bytes {start}-{end}/{size}')
                    self.end_headers()
                    with entry['path'].open('rb') as file:
                        file.seek(start);remaining=end-start+1
                        while remaining:
                            chunk=file.read(min(65536,remaining))
                            if not chunk:break
                            self.wfile.write(chunk);remaining-=len(chunk)
                    return
                if path=='/api/group-info':
                    account=params.get('account');group=params.get('groupId');engine.validate(account,group)
                    self.respond(engine.adapter.call('group_info',account=account,groupId=group));return
                if path in ('/api/group','/api/messages'):
                    account=params.get('account');group=params.get('groupId');engine.validate(account,group)
                    watching=group in (engine.store.watched(account) or [])
                    if engine.read_only:
                        revision=engine.adapter.get_source_info().get('revision')
                        data=engine.adapter.call('messages',account=account,groupId=group) if watching else {'messages':[]}
                        result={**data,'reply':{'enabled':False,'text':'','cooldown':30},'outbox':[],'watching':watching}
                        if path=='/api/group':result.update(engine.adapter.call('members',account=account,groupId=group))
                        engine.validate(account,group)
                        if revision!=engine.adapter.get_source_info().get('revision'):raise ValueError('副本已更新，请刷新当前群聊。')
                        self.respond(result);return
                    rows=engine.store.rows('SELECT payload FROM messages WHERE account=? AND group_id=?',(account,group)) if watching else []
                    messages=sorted((json.loads(x['payload']) for x in rows),key=lambda x:(x['timestamp'],x['id']))[-200:]
                    result={'messages':messages,'reply':engine.store.reply(account,group),'outbox':engine.store.outbox(account,group),'watching':watching}
                    if path=='/api/group':result.update(engine.adapter.call('members',account=account,groupId=group))
                    self.respond(result);return
                names={'/':'index.html','/app.js':'app.js','/rich_ui.js':'rich_ui.js','/sender_ui.js':'sender_ui.js','/hook_ui.js':'hook_ui.js','/app.css':'app.css'}
                if path.startswith('/vendor/pdfjs/'):
                    folder=(static/'vendor/pdfjs').resolve();target=(static/path.lstrip('/')).resolve()
                    if not target.is_relative_to(folder) or not target.is_file() or target.suffix not in ('.mjs','.bcmap','.pfb','.ttf','.wasm'):
                        self.respond({'error':'Not found'},404);return
                elif path in names:target=static/names[path]
                else:self.respond({'error':'Not found'},404);return
                body=target.read_bytes()
                self.send_response(200);self.headers_common();self.send_header('Content-Type',(mimetypes.guess_type(target)[0] or 'text/plain')+'; charset=utf-8')
                self.send_header('Content-Length',str(len(body)));self.end_headers();self.wfile.write(body)
            except (ValueError,BridgeError) as exc:self.respond({'error':str(exc)},400)
            except Exception:self.respond({'error':'服务暂时不可用，请稍后刷新。'},500)

        def do_POST(self):
            if not self.check_host():return
            if self.headers.get('Origin') not in origins or self.headers.get('X-CSRF-Token')!=csrf:
                self.respond({'error':'页面凭证已失效，请刷新页面。'},403);return
            try:
                length=int(self.headers.get('Content-Length','0'))
                if length<2 or length>32768:raise ValueError('请求大小无效。')
                if not self.headers.get('Content-Type','').startswith('application/json'):raise ValueError('需要JSON请求。')
                data=json.loads(self.rfile.read(length));path=urlsplit(self.path).path
                if not isinstance(data,dict):raise ValueError('无效的JSON请求。')
                if path in ('/api/database/configure','/api/database/refresh'):
                    if database_service is None:raise ValueError('请使用 Database 模式启动工作台。')
                    self.respond(database_service.configure(data) if path.endswith('/configure') else database_service.refresh(),202);return
                if path in ('/api/windows/hook/prepare','/api/windows/hook/confirm'):
                    if hook_sender is None or database_service is None:raise ValueError('当前模式未启用 Windows Hook 发送。')
                    # The database source and selected target are frozen on the
                    # server. A stale tab may not silently send to a new account.
                    with database_service.lock,engine.lock:
                        if database_service.busy:raise ValueError('正在更新数据库副本，请完成后再操作。')
                        binding=hook_binding();target=hook_target(data)
                        payload={**data,**binding,**target}
                        if path.endswith('/confirm'):
                            draft=hook_sender.get(data.get('draftId'),binding)
                            if draft.get('targetId')!=target['targetId']:
                                raise ValueError('当前会话已变化，请重新准备发送内容。')
                            result=hook_sender.confirm(payload)
                        else:result=hook_sender.prepare(payload)
                        self.respond(result);return
                if path in ('/api/windows/send/preview','/api/windows/send/stage','/api/windows/send/confirm'):
                    if desktop_sender is None or database_service is None:raise ValueError('当前模式未启用本机可视发送。')
                    # Source fields come from the active server configuration,
                    # never from browser-provided account paths.
                    with database_service.lock:
                        if database_service.busy:raise ValueError('正在更新数据库副本，请完成后再操作。')
                        config=database_service.config
                        if not config or not engine.account:raise ValueError('请先连接数据库副本。')
                        payload={**data,'sourceRoot':config['sourceRoot'],'account':engine.account}
                        action=path.rsplit('/',1)[1]
                        self.respond(getattr(desktop_sender,action)(payload));return
                if path=='/api/windows/preview':
                    from windows_client import preview
                    self.respond(preview(data.get('pid'),data.get('hwnd')));return
                if path=='/api/windows/inspect':
                    from windows_client import inspect
                    self.respond(inspect(data.get('pid'),data.get('hwnd')));return
                if path=='/api/windows/ocr-preview':
                    from windows_reader import preview_ocr
                    self.respond(preview_ocr(data.get('pid'),data.get('hwnd')));return
                if engine.read_only and path in ('/api/login','/api/logout','/api/send','/api/reply','/api/jobs','/api/jobs/cancel','/api/media'):
                    raise ValueError('数据库副本为只读模式，不支持发送、定时、自动回复、附件或微信登录操作。')
                if path=='/api/login':login.start();self.respond(login.snapshot());return
                if path=='/api/refresh':engine.refresh_connection(force=True);self.respond(engine.snapshot());return
                account=data.get('account');group=data.get('groupId')
                if path=='/api/logout':
                    if login.running:raise ValueError('正在登录，请等待登录完成。')
                    self.respond(engine.logout(account));return
                if path=='/api/subscriptions':
                    self.respond({'watchedGroups':engine.set_watched(account,data.get('groupIds'))});return
                if path=='/api/jobs/cancel':
                    if account!=engine.account:raise ValueError('账号已变化。')
                    engine.store.cancel_job(account,data['id']);self.respond({'ok':True});return
                engine.validate(account,group)
                if path=='/api/media':
                    self.respond(media.resolve(account,group,data['messageId'],data.get('part','')));return
                if path=='/api/select':
                    with engine.lock:engine.selected=group
                    self.respond({'ok':True});return
                if path=='/api/send':
                    row=engine.store.enqueue(account,group,data.get('text',''),data.get('mentionIds',[]),id=data.get('requestId'))
                    self.respond({'id':row['id'],'status':row['status']},202);return
                if path=='/api/reply':
                    if not isinstance(data.get('enabled'),bool):raise ValueError('开关值无效。')
                    self.respond(engine.set_reply(account,group,data['enabled'],data.get('text',''),int(data.get('cooldown',30))));return
                if path=='/api/jobs':
                    mentions=data.get('mentionIds',[])
                    if not isinstance(mentions,list) or len(mentions)>20 or any(not isinstance(x,str) for x in mentions):raise ValueError('无效的@成员。')
                    id=engine.store.add_job(account,group,data.get('text',''),mentions,data.get('clock',''))
                    self.respond({'id':id},201);return
                self.respond({'error':'Not found'},404)
            except (ValueError,KeyError,TypeError,BridgeError) as exc:
                self.respond({'error':str(exc) if isinstance(exc,(ValueError,BridgeError)) else '请求字段无效。'},400)
            except Exception:self.respond({'error':'操作未完成，请刷新确认状态。'},500)

    return Handler


def main():
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--port',type=int,default=8787)
    parser.add_argument('--mode',choices=('database','demo','live'),default='database' if os.name=='nt' else 'live')
    parser.add_argument('--runtime-dir',type=Path,help='Local state, PID, lock and attachment directory')
    args=parser.parse_args()
    if not 1<=args.port<=65535:parser.error('--port must be between 1 and 65535')
    default_directory={'demo':'.runtime/web_mvp-demo','database':'.runtime/web_mvp-database','live':'.runtime/web_mvp'}[args.mode]
    directory=(args.runtime_dir or ROOT/default_directory).resolve()
    directory.mkdir(mode=0o700,parents=True,exist_ok=True)
    try:
        with ProcessLock(directory/'server.lock'):
            if args.mode=='database':
                from database_adapter import DatabaseAdapter
                from database_service import DatabaseService
                adapter=DatabaseAdapter()
            else:adapter=DemoAdapter() if args.mode=='demo' else Adapter()
            engine=Engine(Store(directory/('state-demo.sqlite' if args.mode=='demo' else 'state.sqlite')),adapter)
            if args.mode=='demo':prepare_demo(engine)
            database_service=DatabaseService(adapter,directory,engine) if args.mode=='database' else None
            engine.database_service=database_service
            desktop_sender=None
            # The selected Windows route uses a Hook sender. Visual input stays
            # as an unexposed diagnostic implementation, never an automatic fallback.
            engine.desktop_sender=desktop_sender
            hook_sender=None
            if args.mode=='database':
                from windows_hook_sender import WindowsHookSender
                hook_sender=WindowsHookSender.from_config(directory/'hook-send',directory/'hook-config.json')
            engine.hook_sender=hook_sender
            login=LoginFlow(engine)
            media=MediaCache(engine,directory/'media')
            server=ThreadingHTTPServer(('127.0.0.1',args.port),make_handler(engine,login,secrets.token_urlsafe(32),args.port,media,database_service,desktop_sender,hook_sender))
            engine.start()
            (directory/'server.pid').write_text(str(os.getpid()),encoding='ascii')
            print(f'WeBridge ({args.mode}): http://127.0.0.1:{args.port}',flush=True)
            try:server.serve_forever()
            except KeyboardInterrupt:pass
            finally:
                engine.stop.set();server.server_close()
                for thread in engine.threads:thread.join(timeout=2)
                (directory/'server.pid').unlink(missing_ok=True)
    except RuntimeError as exc:
        raise SystemExit(str(exc)) from None
    except OSError as exc:
        raise SystemExit(f'无法启动工作台，请检查端口 {args.port} 和运行目录：{exc}') from None


if __name__=='__main__':main()
