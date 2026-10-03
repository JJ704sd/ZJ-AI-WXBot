// Synthetic DOM/API checks. Never reads WeChat or starts native sending.
'use strict';
const fs=require('node:fs'),path=require('node:path'),vm=require('node:vm'),assert=require('node:assert/strict');
const source=fs.readFileSync(path.join(__dirname,'../static/app.js'),'utf8');
function node(){return {children:[],value:'',textContent:'',disabled:false,hidden:false,get selectedOptions(){return this.children.filter(item=>item.value===this.value);},append(...items){this.children.push(...items);},replaceChildren(...items){this.children=[...items];}};}
const nodes=new Map(),$=id=>{if(!nodes.has(id))nodes.set(id,node());return nodes.get(id);};
$('schedule-filter').value='all';
const pending=[],calls=[],toasts=[];
const context=vm.createContext({$,el:(tag,className,text)=>Object.assign(node(),{textContent:text||''}),emptyCard:()=>node(),groupName:id=>id,
 stamp:()=> 'time',dateKey:()=> 'today',isDatabase:()=>context.state.runtime.mode==='database',supportsSchedules:()=>context.state.runtime.capabilities.scheduledSend,
 serviceAvailable:true,scheduleBusy:false,state:{account:'fixture',runtime:{mode:'database',capabilities:{scheduledSend:true}},jobs:[],groups:[],watchedGroups:[]},
 scheduleRenderKey:'',controls:()=>{},toast:(...args)=>toasts.push(args),poll:async()=>{},
 api:(url,body)=>{calls.push({url,body});return new Promise((resolve,reject)=>pending.push({resolve,reject}));}});
vm.runInContext(source.slice(source.indexOf('const scheduleActionsBusy='),source.indexOf('let environmentData=')),context);
vm.runInContext('function renderSchedules(){scheduleScope();renderWindowsSchedules();}',context);
const job=(id,group,enabled=true)=>({id,group_id:group,targetName:'会话 '+group,text:'提醒 '+id,state:enabled?'active':'paused',enabled,mode:'daily',clock:'09:00',runs:[],last_result:''});
const render=()=>vm.runInContext('renderWindowsSchedules()',context);
const pause=()=>vm.runInContext('pauseSchedules()',context);
const checks=[];
function check(name,body){body();checks.push(name);}
(async()=>{
 context.state.jobs=[job('a1','a'),job('a2','a'),job('b1','b'),job('b0','b',false)];render();
 check('all_saved_conversations_available_without_watch_or_online',()=>assert.deepEqual($('schedule-group-filter').children.map(n=>n.value),['','a','b']));
 check('all_enabled_count',()=>assert.match($('schedule-pause-scope').textContent,/3/));
 $('schedule-group-filter').value='a';$('schedule-search').value='missing';$('schedule-filter').value='inactive';render();
 check('batch_scope_ignores_search_and_status',()=>{assert.match($('schedule-pause-scope').textContent,/2/);assert.equal($('schedule-pause-all').textContent,'暂停本会话任务');assert.equal($('schedule-list').children.length,1);});
 const first=pause();await pause();
 check('one_account_group_request',()=>{assert.equal(calls.length,1);assert.equal(JSON.stringify(calls[0]),JSON.stringify({url:'/api/jobs/pause-all',body:{account:'fixture',groupId:'a'}}));assert.equal($('schedule-pause-all').disabled,true);});
 context.state.jobs=context.state.jobs.map(row=>row.group_id==='a'?{...row,enabled:false,state:'paused'}:row);
 pending.shift().resolve({pausedCount:2,jobs:context.state.jobs});await first;
 check('actual_count_and_account_jobs_applied',()=>{assert.match($('schedule-pause-feedback').textContent,/2/);assert.equal($('schedule-pause-all').disabled,true);});
 $('schedule-group-filter').value='b';render();const failed=pause();pending.shift().reject(Error('synthetic network failure'));await failed;
 check('uncertain_failure_no_auto_retry',()=>{assert.match($('schedule-pause-feedback').textContent,/未确认暂停结果，请刷新核对/);assert.equal(calls.length,2);assert.equal($('schedule-pause-all').disabled,false);});
 const retry=pause();pending.shift().resolve({pausedCount:0,jobs:context.state.jobs.map(row=>({...row,enabled:false,state:'paused'}))});await retry;
 check('explicit_retry_and_zero_result',()=>{assert.equal(calls.length,3);assert.match($('schedule-pause-feedback').textContent,/0/);});
 context.state.jobs=[job('old','a')];$('schedule-group-filter').value='';render();
 const old=pause(),oldPending=pending.shift();context.state={...context.state,account:'new-account',jobs:[job('new','b')]};render();
 const current=pause(),currentPending=pending.shift();oldPending.reject(Error('old account failure'));await old;
 check('stale_failure_does_not_unlock_new_request',()=>{assert.equal($('schedule-pause-all').disabled,true);assert.doesNotMatch($('schedule-pause-feedback').textContent,/未确认暂停结果/);});
 currentPending.resolve({pausedCount:1,jobs:[job('new','b',false)]});await current;
 check('new_account_result_survives_old_request',()=>assert.equal(context.state.jobs[0].id,'new'));
 context.state.jobs=[job('new2','b')];render();const stale=pause(),stalePending=pending.shift();
 context.state={...context.state,account:'third',jobs:[job('third','c')]};render();stalePending.resolve({pausedCount:99,jobs:[job('wrong','b',false)]});await stale;
 check('stale_success_does_not_replace_new_account',()=>{assert.equal(context.state.jobs[0].id,'third');assert.doesNotMatch($('schedule-pause-feedback').textContent,/99/);});
 context.scheduleBusy=true;render();const before=calls.length;await pause();
 check('existing_create_blocks_pause',()=>{assert.equal(calls.length,before);assert.equal($('schedule-pause-all').disabled,true);});context.scheduleBusy=false;
 $('schedule-search').value='';$('schedule-filter').value='all';render();
 const rowAction=$('schedule-list').children[0].children[3].children[0].onclick();const actionPending=pending.shift();await pause();
 check('existing_row_action_blocks_pause',()=>assert.equal(calls.length,before+1));actionPending.resolve({});await rowAction;
 const busy=pause(),busyPending=pending.shift();const action=$('schedule-list').children[0].children[3].children[0];await action.onclick();
 check('pause_blocks_row_actions',()=>{assert.equal(action.disabled,true);assert.equal(calls.length,before+2);});busyPending.resolve({pausedCount:1,jobs:[job('third','c',false)]});await busy;
 context.state.runtime.mode='demo';render();
 check('database_only_pause_controls',()=>{assert.equal($('schedule-pause-controls').hidden,true);assert.equal($('schedule-group-filter').hidden,true);});
 console.log('PASS: '+checks.length+' schedule pause checks (synthetic only)');
})().catch(error=>{console.error(error);process.exitCode=1;});
