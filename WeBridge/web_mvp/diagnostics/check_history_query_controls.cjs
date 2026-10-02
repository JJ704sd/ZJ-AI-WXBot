'use strict';
// Synthetic DOM and delayed API responses only; no browser, account or message access.
const fs=require('node:fs'),vm=require('node:vm'),assert=require('node:assert/strict'),path=require('node:path');
function element(tag='',cls='',text=''){
 return {tag,cls,textContent:text,value:'',children:[],listeners:{},open:false,disabled:false,hidden:false,
  append(...items){this.children.push(...items)},replaceChildren(...items){this.children=[...items]},
  addEventListener(name,callback){this.listeners[name]=callback},showModal(){this.open=true},
  close(){this.open=false;this.listeners.close?.()}};
}
const nodes=new Map(),$=id=>{if(!nodes.has(id))nodes.set(id,element());return nodes.get(id)};
$('history-limit').value='100';$('message-search').value=' 当前筛选 ';
$('message-text').value='未发送的实时草稿';$('reply-text').value='尚未保存的回复规则';
$('reply-enabled').checked=true;
const messageData=[{id:'realtime',text:'实时消息'}],requests=[];
const ctx=vm.createContext({$,el:element,emptyCard:(title,body)=>element('empty','',title+' '+body),
 state:{account:'a',runtime:{mode:'database',source:{id:'source-a',revision:'revision-1'}},watchedGroups:['g'],groups:[{id:'g'},{id:'other'}]},
 selected:'g',serviceAvailable:true,online:true,messageData,replyDirty:true,replyBusy:false,
 URLSearchParams,JSON,isDatabase:()=>ctx.state.runtime.mode==='database',groupName:id=>'会话 '+id,
 stamp:seconds=>'time '+seconds,
 api:url=>new Promise((resolve,reject)=>requests.push({url,resolve,reject}))});
const run=code=>vm.runInContext(code,ctx);
vm.runInContext(fs.readFileSync(path.join(__dirname,'../static/message_history_ui.js'),'utf8'),ctx);
const last=()=>requests[requests.length-1],parameters=()=>new URL(last().url,'http://localhost').searchParams;
const result=(id,next='')=>({messages:id?[{id,text:'历史正文 '+id,senderName:'合成发送者',timestamp:10}]:[],
 hasMore:!!next,nextCursor:next,limit:100,scanned:1,warnings:[],sourceRevision:ctx.state.runtime.source.revision});
async function settle(){await new Promise(resolve=>setImmediate(resolve))}
async function succeed(promise,data){last().resolve(data);await promise;await settle()}
async function fail(promise){last().reject(new Error('合成读取失败'));await promise;await settle()}
function untouched(){
 assert.equal(ctx.messageData,messageData);assert.deepEqual(messageData,[{id:'realtime',text:'实时消息'}]);
 assert.equal($('message-text').value,'未发送的实时草稿');assert.equal($('reply-text').value,'尚未保存的回复规则');
 assert.equal($('reply-enabled').checked,true);assert.equal(ctx.replyDirty,true);
}

(async()=>{
 run('updateMessageHistoryScope()');assert.equal($('open-message-history').disabled,false);
 $('open-message-history').onclick();assert.equal($('history-dialog').open,true);
 assert.equal($('history-query').value,'当前筛选');
 assert.equal(parameters().get('account'),'a');assert.equal(parameters().get('groupId'),'g');
 assert.equal(parameters().get('query'),'当前筛选');assert.equal(parameters().get('limit'),'100');
 assert.equal(parameters().get('cursor'),'');
 await succeed(undefined,result('first','cursor-1'));untouched();
 assert.equal(run('historyPage'),0);assert.equal($('history-prev').disabled,true);assert.equal($('history-next').disabled,false);
 const firstCard=$('history-results').children[0];

 // Navigation commits page/cursor state only on success; retry uses the same cursor.
 let pending=$('history-next').onclick();assert.equal(parameters().get('cursor'),'cursor-1');
 assert.equal($('history-next').disabled,true);await fail(pending);
 assert.equal(run('historyPage'),0);assert.equal($('history-results').children[0],firstCard);assert.equal($('history-next').disabled,false);
 pending=$('history-next').onclick();assert.equal(parameters().get('cursor'),'cursor-1');await succeed(pending,result('second','cursor-2'));
 assert.equal(run('historyPage'),1);assert.equal($('history-page').textContent,'第 2 页');
 assert.equal($('history-results').children.length,1,'history pages replace rather than accumulate DOM');
 pending=$('history-next').onclick();assert.equal(parameters().get('cursor'),'cursor-2');await succeed(pending,result('third'));
 assert.equal(run('historyPage'),2);assert.equal($('history-next').disabled,true);
 pending=$('history-prev').onclick();assert.equal(parameters().get('cursor'),'cursor-1');await fail(pending);
 assert.equal(run('historyPage'),2);assert.equal($('history-prev').disabled,false);
 pending=$('history-prev').onclick();await succeed(pending,result('second','cursor-2'));assert.equal(run('historyPage'),1);
 let prevented=false;$('history-form').onsubmit({preventDefault(){prevented=true}});assert.equal(prevented,true);
 assert.equal(parameters().get('cursor'),'');await fail(undefined);assert.equal(run('historyPage'),1);
 pending=run('loadMessageHistory(0)');await succeed(pending,result('refreshed','cursor-new'));assert.equal(run('historyPage'),0);
 untouched();

 // All local-history parameters belong to the query scope and are sent together.
 $('history-query').value='  文件名  ';$('history-start-date').value='2026-09-01';
 $('history-end-date').value='2026-10-02';$('history-limit').value='500';
 $('history-query').listeners.input();assert.equal($('history-results').children.length,0);assert.equal(run('historyNext'),'');
 pending=run('loadMessageHistory(0)');
 assert.equal(parameters().get('query'),'文件名');assert.equal(parameters().get('startDate'),'2026-09-01');
 assert.equal(parameters().get('endDate'),'2026-10-02');assert.equal(parameters().get('limit'),'500');
 await succeed(pending,{...result('date-result'),scanLimited:true,hasMore:true,nextCursor:'scan-next',warnings:[{message:'正在继续扫描'}]});
 assert.match($('history-status').textContent,/本批检索已达上限/);assert.match($('history-status').textContent,/正在继续扫描/);

 // A delayed request from a previous account, source, revision, group or query cannot
 // populate the new view, report an old error, or unlock the new in-flight request.
 const changes=[
  ()=>{ctx.state.account='b'},
  ()=>{ctx.state.runtime.source.id='source-b'},
  ()=>{ctx.state.runtime.source.revision='revision-2'},
  ()=>{ctx.state.watchedGroups=['g','other'];ctx.selected='other'},
  ()=>{$('history-query').value='另一关键词'},
  ()=>{$('history-limit').value='200'},
 ];
 for(const [index,change] of changes.entries()){
  const old=run('loadMessageHistory(0)'),oldRequest=last();change();run('updateMessageHistoryScope()');
  assert.equal($('history-results').children.length,0);
  const fresh=run('loadMessageHistory(0)'),freshRequest=last();assert.notEqual(oldRequest,freshRequest);
  if(index%2)oldRequest.reject(new Error('OLD_SCOPE_ERROR'));else oldRequest.resolve(result('OLD_SCOPE_SECRET'));
  await old;assert.equal($('history-results').children.length,0);assert.equal($('history-submit').disabled,true);
  assert.equal($('history-status').textContent,'正在查询本地副本…');
  await succeed(fresh,result('fresh-'+index));assert.equal(run('historyPage'),0);untouched();
 }

 // Revoking the selected conversation clears visible data immediately and refuses
 // new reads. Its delayed success must not restore authorized-earlier content.
 pending=run('loadMessageHistory(0)');const revokedRequest=last();ctx.state.watchedGroups=[];run('updateMessageHistoryScope()');
 assert.equal($('history-results').children.length,0);assert.equal($('history-submit').disabled,true);
 const beforeRevoked=requests.length;await run('loadMessageHistory(0)');assert.equal(requests.length,beforeRevoked);
 revokedRequest.resolve(result('REVOKED_SECRET'));await pending;assert.equal($('history-results').children.length,0);
 ctx.state.watchedGroups=['other'];run('updateMessageHistoryScope()');

 // Closing the dialog invalidates its response even if a new request starts after
 // reopening with exactly the same account, group and filters.
 pending=run('loadMessageHistory(0)');const closedRequest=last();$('history-dialog').close();
 closedRequest.resolve(result('CLOSED_SECRET'));await pending;assert.equal($('history-results').children.length,0);
 $('history-dialog').showModal();pending=run('loadMessageHistory(0)');const priorOpen=last();$('history-dialog').close();
 $('history-dialog').showModal();const reopened=run('loadMessageHistory(0)');
 priorOpen.reject(new Error('CLOSED_ERROR'));await pending;
 assert.equal($('history-submit').disabled,true);assert.equal($('history-status').textContent,'正在查询本地副本…');
 await succeed(reopened,result('reopened'));untouched();

 // Empty continuation pages remain navigable; unavailable sources cannot issue reads.
 pending=run('loadMessageHistory(0)');await succeed(pending,{...result(null,'remaining'),scanLimited:true});
 assert.equal($('history-results').children[0].tag,'empty');assert.equal($('history-next').disabled,false);
 const count=requests.length;ctx.serviceAvailable=false;run('historyButtons()');await run('loadMessageHistory(0)');
 assert.equal(requests.length,count);assert.equal($('history-submit').disabled,true);
 ctx.serviceAvailable=true;ctx.state.runtime.mode='demo';run('updateMessageHistoryScope()');await run('loadMessageHistory(0)');
 assert.equal(requests.length,count);assert.equal($('open-message-history').hidden,true);untouched();
 console.log('PASS: message-history parameters, pagination, failed-page retries, scope/dialog isolation and untouched live drafts (synthetic only)');
})().catch(error=>{console.error(error);process.exitCode=1});
