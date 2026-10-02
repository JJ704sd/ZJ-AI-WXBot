'use strict';
const fs=require('node:fs'),vm=require('node:vm'),assert=require('node:assert/strict'),path=require('node:path');
function element(tag='',cls='',text=''){
 return {tag,cls,textContent:text,children:[],value:'all',hidden:false,listeners:{},
  append(...items){this.children.push(...items)},replaceChildren(){this.children=[]},
  addEventListener(name,callback){this.listeners[name]=callback}};
}
const nodes=new Map(),$=id=>{if(!nodes.has(id))nodes.set(id,element());return nodes.get(id)};
for(const id of ['execution-search','execution-start-date','execution-end-date'])$(id).value='';
$('execution-limit').value='200';
let timerId=0,now=100000;
const requests=[],timers=new Map();
class Clock extends Date {static now(){return now}}
const ctx=vm.createContext({$,el:element,emptyCard:(title,body)=>element('empty','',title+' '+body),
 state:{account:'a',watchedGroups:['g'],runtime:{mode:'database',source:{id:'source-a'}}},
 document:{hidden:false},serviceAvailable:true,Date:Clock,JSON,URLSearchParams,
 isDemo:()=>false,stamp:()=> 'time',setView:()=>{},selectGroup:()=>{},
 setTimeout(callback,delay){const id=++timerId;timers.set(id,{callback,delay});return id},clearTimeout(id){timers.delete(id)},
 api:url=>new Promise((resolve,reject)=>requests.push({url,resolve,reject}))});
const run=code=>vm.runInContext(code,ctx);
vm.runInContext(fs.readFileSync(path.join(__dirname,'../static/execution_ui.js'),'utf8'),ctx);
const record=(id,text='正文')=>({id,source:'manual',targetId:'g',targetName:'合成群',text,label:'待核对',createdAt:1,timeBasis:'提交时间',pending:true,attention:false});
const answer=(id,nextCursor='')=>({limit:200,records:id?[record(id)]:[],hasMore:!!nextCursor,nextCursor,truncated:!!nextCursor});
const last=()=>requests[requests.length-1];
const parameters=()=>new URL(last().url,'http://localhost').searchParams;
async function succeed(promise,data){last().resolve(data);await promise}
async function fail(promise){last().reject(new Error('合成读取失败'));await promise}

(async()=>{
 // Account, source and reading-scope changes cannot accept earlier results or errors.
 run('updateExecutionScope()');
 let pending=run('loadExecutionHistory(true)');
 ctx.state.account='b';run('updateExecutionScope()');
 await succeed(pending,answer('OLD_ACCOUNT_SECRET'));
 assert.equal($('execution-list').children.length,0);assert.equal($('execution-refresh').disabled,false);
 pending=run('loadExecutionHistory(true)');
 ctx.state.runtime.source.id='source-b';run('updateExecutionScope()');
 await fail(pending);assert.equal($('execution-message').textContent,'');
 pending=run('loadExecutionHistory(true)');
 ctx.state.watchedGroups=[];run('updateExecutionScope()');
 await succeed(pending,answer('REVOKED_SCOPE'));assert.equal($('execution-list').children.length,0);
 ctx.state.watchedGroups=['g','g2'];run('updateExecutionScope()');
 const scope=run('executionScope');ctx.state.watchedGroups=['g2','g'];run('updateExecutionScope()');
 assert.equal(run('executionScope'),scope,'reading-scope order does not invalidate pagination');

 pending=run('loadExecutionHistory(true)');await succeed(pending,answer('first','cursor-1'));
 assert.equal($('execution-list').children.length,1);assert.equal($('execution-prev').disabled,true);assert.equal($('execution-next').disabled,false);
 const firstCard=$('execution-list').children[0];run('renderExecutionHistory()');
 assert.equal($('execution-list').children[0],firstCard,'unchanged records preserve DOM');
 assert.equal(parameters().get('limit'),'200');assert.equal(parameters().get('account'),'b');

 // Failed navigation never advances the page or consumes its next cursor.
 pending=$('execution-next').onclick();assert.equal(parameters().get('cursor'),'cursor-1');
 assert.equal($('execution-next').disabled,true);await fail(pending);
 assert.equal(run('executionPage'),0);assert.equal($('execution-list').children[0],firstCard);
 assert.equal($('execution-next').disabled,false);
 pending=$('execution-next').onclick();assert.equal(parameters().get('cursor'),'cursor-1');
 await succeed(pending,answer('second','cursor-2'));
 assert.equal(run('executionPage'),1);assert.equal($('execution-page').textContent,'第 2 页');
 assert.equal($('execution-list').children.length,1,'pages replace rather than append records');
 const count=requests.length;now+=20000;await run('loadExecutionHistory()');
 assert.equal(requests.length,count,'historical pages do not automatically return to latest');

 pending=$('execution-next').onclick();assert.equal(parameters().get('cursor'),'cursor-2');
 await succeed(pending,answer('third'));assert.equal(run('executionPage'),2);assert.equal($('execution-next').disabled,true);
 pending=$('execution-prev').onclick();assert.equal(parameters().get('cursor'),'cursor-1');await fail(pending);
 assert.equal(run('executionPage'),2);assert.equal($('execution-prev').disabled,false);
 pending=$('execution-prev').onclick();await succeed(pending,answer('second','cursor-2'));assert.equal(run('executionPage'),1);
 pending=$('execution-refresh').onclick();assert.equal(parameters().has('cursor'),false);await fail(pending);
 assert.equal(run('executionPage'),1,'a failed refresh preserves the current history page');
 pending=$('execution-refresh').onclick();await succeed(pending,answer('new-first','new-cursor'));assert.equal(run('executionPage'),0);
 assert.equal(run('executionCursors[1]'),'new-cursor');

 // Server-side search is debounced; poll must not defeat the debounce window.
 $('execution-search').value='草';$('execution-search').listeners.input();
 assert.equal($('execution-list').children.length,0);assert.equal(timers.size,1);
 assert.equal([...timers.values()][0].delay,300);
 $('execution-search').value='  草稿  ';$('execution-search').listeners.input();assert.equal(timers.size,1);
 const beforeSearch=requests.length;await run('loadExecutionHistory()');assert.equal(requests.length,beforeSearch);
 const timer=[...timers.entries()][0];timers.delete(timer[0]);timer[1].callback();
 assert.equal(parameters().get('query'),'草稿');assert.equal(parameters().has('cursor'),false);
 last().resolve(answer('match'));await new Promise(resolve=>setImmediate(resolve));
 assert.equal(run('executionRows[0].id'),'match','server search results are not filtered again in the browser');

 // Changing any filter resets paging, transmits all parameters and rejects stale responses.
 pending=run('loadExecutionHistory(true)');
 $('execution-source').value='reply';$('execution-status').value='attention';
 $('execution-start-date').value='2026-09-01';$('execution-end-date').value='2026-09-30';
 const oldRequest=last();const filtered=$('execution-source').listeners.change();
 const filterRequest=last();assert.notEqual(filterRequest,oldRequest);
 assert.equal(parameters().get('source'),'reply');assert.equal(parameters().get('status'),'attention');
 assert.equal(parameters().get('startDate'),'2026-09-01');assert.equal(parameters().get('endDate'),'2026-09-30');
 oldRequest.resolve(answer('OLD_FILTER'));await pending;
 assert.equal($('execution-list').children.length,0);assert.equal($('execution-refresh').disabled,true);
 await succeed(filtered,answer('filtered','filtered-next'));assert.equal(run('executionRows[0].id'),'filtered');
 pending=$('execution-next').onclick();const oldRange=last();
 $('execution-limit').value='1000';const changedRange=$('execution-limit').onchange();
 assert.equal(parameters().get('limit'),'1000');assert.equal(parameters().has('cursor'),false);
 oldRange.resolve(answer('OLD_RANGE'));await pending;assert.equal($('execution-list').children.length,0);
 await succeed(changedRange,{...answer(null),limit:1000});
 assert.equal(run('executionPage'),0);assert.equal($('execution-list').children[0].tag,'empty');
 assert.match($('execution-list').children[0].textContent,/本机执行历史/);assert.equal($('execution-next').disabled,true);

 // First-page polling is bounded and hidden/offline views do not issue requests.
 const beforePoll=requests.length;await run('loadExecutionHistory()');assert.equal(requests.length,beforePoll);
 now+=10001;pending=run('loadExecutionHistory()');await succeed(pending,{...answer('polled'),limit:1000});
 ctx.document.hidden=true;await run('loadExecutionHistory(true)');assert.equal(requests.length,beforePoll+1);
 ctx.document.hidden=false;ctx.serviceAvailable=false;await run('loadExecutionHistory(true)');assert.equal(requests.length,beforePoll+1);
 console.log('PASS: execution server filters, pagination, debounce, stale-response isolation and failed-page retries (synthetic only)');
})().catch(error=>{console.error(error);process.exitCode=1});
