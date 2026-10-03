'use strict';
const fs=require('node:fs'),vm=require('node:vm'),assert=require('node:assert/strict'),path=require('node:path');
function element(tag='',cls='',text=''){
 return {tag,cls,textContent:text,children:[],value:'',hidden:false,disabled:false,open:false,listeners:{},
  append(...items){this.children.push(...items)},replaceChildren(...items){this.children=[...items]},
  addEventListener(name,callback){this.listeners[name]=callback},showModal(){this.open=true},close(){this.open=false}};
}
const nodes=new Map(),$=id=>{if(!nodes.has(id))nodes.set(id,element());return nodes.get(id)};
$('handoff-status').value='open';
let now=100000;
class Clock extends Date {static now(){return now}}
const requests=[],toasts=[];
const ctx=vm.createContext({$,el:element,emptyCard:(title,body)=>element('empty','',title+' '+body),
 state:{account:'a',watchedGroups:['g'],groups:[{id:'g',name:'合成群'}],runtime:{mode:'database',source:{id:'source-a'},capabilities:{automaticReplies:true}}},
 currentView:'handoffs',document:{hidden:false},serviceAvailable:true,Date:Clock,JSON,URLSearchParams,
 isDatabase:()=>ctx.state.runtime.mode==='database',stamp:()=> 'time',setView:()=>{},selectGroup:()=>{},toast:(...args)=>toasts.push(args),
 api:(url,body)=>new Promise((resolve,reject)=>requests.push({url,body,resolve,reject}))});
const run=code=>vm.runInContext(code,ctx);
vm.runInContext(fs.readFileSync(path.join(__dirname,'../static/handoff_ui.js'),'utf8'),ctx);
vm.runInContext(fs.readFileSync(path.join(__dirname,'../static/handoff_routing_ui.js'),'utf8'),ctx);
const record=(id='one',version=1,status='pending')=>({id,version,status,owner:status==='pending'?'':'旧负责人',note:'已有备注',groupId:'g',groupName:'合成群',reason:'真实 @ 本人',revoked:false,createdAt:1,updatedAt:2,trigger:{messageId:'m',serverId:'7',senderId:'p',senderName:'发起人',timestamp:1,text:'原始任务',textTruncated:false}});
const page=(rows=[record()],cursor='')=>({records:rows,hasMore:!!cursor,nextCursor:cursor,limit:50});
const detail=row=>({record:row,changes:[{version:row.version,action:'create',status:row.status,owner:row.owner,note:row.note,createdAt:1}],historyTruncated:false});
const last=()=>requests.at(-1),flush=()=>new Promise(resolve=>setImmediate(resolve));
async function succeed(promise,data){last().resolve(data);await promise}

(async()=>{
 ctx.state.account=null;await run('loadHandoffs(true)');assert.equal(requests.length,0,'no account must not issue a queue request');
 ctx.state.account='a';let pending=run('loadHandoffs(true)');const old=last();
 ctx.state.account='b';run('updateHandoffScope()');old.resolve(page([record('OLD_ACCOUNT')]));await pending;
 assert.equal(run('handoffRows.length'),0,'old account cannot fill current queue');
 ctx.state.account='a';pending=run('loadHandoffs(true)');await succeed(pending,page([record()],'cursor-2'));
 assert.equal(run('handoffRows[0].id'),'one');assert.match($('handoff-notice').textContent,/本机待办，未通知负责人/);
 pending=$('handoff-next').onclick();assert.match(last().url,/cursor=cursor-2/);await succeed(pending,page([record('older')]));
 const prior=requests.length;now+=11000;await run('loadHandoffs()');assert.equal(requests.length,prior,'poll leaves old page stationary');
 pending=run('openHandoffDetail("older")');await succeed(pending,detail(record('older')));
 $('handoff-owner').value='本机甲';$('handoff-owner').listeners.input();$('handoff-note').value='尚未提交备注';$('handoff-note').listeners.input();
 pending=run('submitHandoffAction("claim")');const claim=last();
 assert.equal(claim.url,'/api/handoffs/action');assert.equal(claim.body.version,1);assert.equal(claim.body.owner,'本机甲');
 const count=requests.length;await run('submitHandoffAction("claim")');assert.equal(requests.length,count,'one mutation at a time');
 claim.reject(Object.assign(new Error('记录已变化，请刷新'),{status:409}));await flush();
 assert.match(last().url,/\/api\/handoffs\/detail/);$('handoff-owner').value='仍在编辑';$('handoff-owner').listeners.input();
 last().resolve(detail(record('older',2,'in_progress')));await pending;
 assert.equal(run('handoffDetail.version'),2);assert.equal($('handoff-owner').value,'仍在编辑');assert.equal($('handoff-note').value,'尚未提交备注');
 assert.match($('handoff-detail-message').textContent,/409/);
 pending=run('submitHandoffAction("complete")');assert.equal(last().body.version,2);last().resolve(record('older',3,'completed'));await flush();
 last().resolve(detail(record('older',3,'completed')));await flush();last().resolve(page([record('older',3,'completed')]));await pending;
 assert.equal(run('handoffDetail.status'),'completed');assert.equal($('handoff-reopen').hidden,false);
 assert.ok(requests.every(request=>request.url.startsWith('/api/handoffs')),'task actions never call reply, Hook or send APIs');
 pending=run('loadHandoffDetail("older",true)');const previous=last();ctx.state.watchedGroups=[];run('updateHandoffScope()');previous.resolve(detail(record('SECRET',4)));await pending;
 assert.equal($('handoff-dialog').open,false);assert.equal(run('handoffDetail'),null);assert.equal($('handoff-owner').value,'');
 ctx.state.watchedGroups=['g'];pending=run('openHandoffDetail("older")');const revoked=record('older',4);revoked.revoked=true;revoked.trigger.text='MUST_NOT_RENDER';await succeed(pending,detail(revoked));
 assert.equal($('handoff-detail-text').textContent,'原消息已撤回，原文不再显示。');
 pending=run('loadHandoffDetail("older",true)');last().reject(new Error('副本暂不可读'));await pending;
 assert.equal($('handoff-detail-refresh').disabled,false,'failed detail can be refreshed');assert.equal($('handoff-complete').disabled,true,'failed freshness check blocks task actions');
 pending=$('handoff-detail-refresh').onclick();await succeed(pending,detail(revoked));assert.equal(run('handoffDetail.id'),'older');
 pending=run('submitHandoffAction("claim")');const closedAction=last();run('clearHandoffDetail()');const freshDetail=run('openHandoffDetail("one")');await succeed(freshDetail,detail(record()));
 const freshAction=run('submitHandoffAction("claim")');const newerAction=last();closedAction.resolve(record('older',5,'in_progress'));await pending;
 assert.equal(run('handoffActionBusy'),true,'a closed dialog mutation cannot unlock a newer mutation');
 newerAction.reject(new Error('连接中断'));await freshAction;
 ctx.document.hidden=true;const beforeHidden=requests.length;await run('loadHandoffs(true)');assert.equal(requests.length,beforeHidden);
 console.log('PASS: local-only handoff scopes, pagination, CAS conflicts, draft retention, stale-response isolation and revocation display');
})().catch(error=>{console.error(error);process.exitCode=1});
