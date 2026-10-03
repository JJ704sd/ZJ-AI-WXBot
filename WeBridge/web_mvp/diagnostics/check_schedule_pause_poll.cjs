// Deferred synthetic API responses against the real poll and pause functions.
// No server, browser profile, WeChat data or native sender is accessed.
'use strict';
const fs=require('node:fs'),path=require('node:path'),vm=require('node:vm'),assert=require('node:assert/strict');
const source=fs.readFileSync(path.join(__dirname,'../static/app.js'),'utf8');
function node(){return {children:[],value:'',textContent:'',disabled:false,hidden:false,open:false,
 get selectedOptions(){return this.children.filter(item=>item.value===this.value);},
 append(...items){this.children.push(...items);},replaceChildren(...items){this.children=[...items];},close(){this.open=false;}};}
const job=(id,enabled=true)=>({id,group_id:'group',targetName:'Synthetic group',text:'Synthetic text',
 state:enabled?'active':'paused',enabled,mode:'daily',clock:'09:00',runs:[],last_result:''});
const snapshot=(account='fixture',jobs=[job('task')],mode='database')=>({account,name:'Original state',csrfToken:'synthetic-token',
 runtime:{mode,source:{id:'source-'+account,revision:'revision'},capabilities:{scheduledSend:true}},jobs,groups:[],watchedGroups:[]});
function fixture(){
 const nodes=new Map(),$=id=>{if(!nodes.has(id))nodes.set(id,node());return nodes.get(id);},requests=[],noop=()=>{};
 $('schedule-filter').value='all';
 const context=vm.createContext({$,el:(tag,className,text)=>Object.assign(node(),{textContent:text||''}),emptyCard:node,
  groupName:id=>id,stamp:()=>'',dateKey:()=>'',state:snapshot(),scheduleRenderKey:'',scheduleBusy:false,
  serviceAvailable:true,serviceError:'',pollBusy:false,selected:null,currentView:'schedules',online:false,databaseData:true,
  databaseLoading:false,initialModeSeen:true,groupVersion:0,mentionIds:new Set(),memberCache:new Map(),messageNodes:new Map(),mediaStates:new Map(),
  controls:noop,toast:noop,renderGroups:noop,syncDatabaseRuntime:noop,setConnection:noop,updateHandoffScope:noop,
  updateExecutionScope:noop,renderMessages:noop,renderLogin:noop,saveDraft:noop,resetWindowsPanel:noop,
  resetDesktopSender:noop,resetHookSender:noop,supportsHandoffs:()=>true,
  sourceSignature:value=>JSON.stringify([value.runtime?.mode,value.runtime?.source?.id]),
  api:(url,body)=>new Promise((resolve,reject)=>requests.push({url,body,resolve,reject}))});
 context.isDatabase=()=>context.state.runtime.mode==='database';context.supportsSchedules=()=>true;context.supportsScheduleWindows=()=>false;
 vm.runInContext(source.slice(source.indexOf('const scheduleActionsBusy='),source.indexOf('let environmentData=')),context);
 vm.runInContext('function renderSchedules(){renderWindowsSchedules();}',context);
 vm.runInContext(source.slice(source.indexOf('async function poll(){'),source.indexOf('async function loadTimerMembers()')),context);
 context.renderSchedules();
 return {context,$,request(url){const index=requests.findIndex(item=>item.url===url);assert.notEqual(index,-1,'Missing '+url);return requests.splice(index,1)[0];}};
}
async function pausedWhilePolling(f){
 const polling=f.context.poll(),old=f.request('/api/state'),pausing=f.context.pauseSchedules();
 f.request('/api/jobs/pause-all').resolve({pausedCount:1,jobs:[job('task',false)]});
 await pausing;
 assert.equal(f.context.state.jobs[0].state,'paused');
 return {polling,old};
}
(async()=>{
 const f=fixture(),{polling,old}=await pausedWhilePolling(f);
 old.resolve({...snapshot(),name:'Other snapshot fields still update'});await polling;
 assert.equal(f.context.state.jobs[0].state,'paused','An older GET must not undo the visible successful pause');
 assert.equal(f.context.serviceAvailable,true,f.context.serviceError);
 assert.equal(f.context.state.name,'Other snapshot fields still update');
 assert.match(f.$('schedule-pause-feedback').textContent,/本次暂停 1 个任务/);
 const next=f.context.poll();f.request('/api/state').resolve({...snapshot(),name:'Fresh response'});await next;
 assert.equal(f.context.state.jobs[0].state,'active','A later GET must reflect an explicit resume from another tab');
 assert.equal(f.context.state.name,'Fresh response');

 const changed=fixture(),account=await pausedWhilePolling(changed);
 account.old.resolve(snapshot('other-account',[job('other-account-task')]));await account.polling;
 assert.equal(changed.context.state.account,'other-account');
 assert.equal(changed.context.state.jobs[0].id,'other-account-task');
 assert.equal(changed.context.serviceAvailable,true,changed.context.serviceError);
 assert.equal(changed.$('schedule-pause-feedback').textContent,'');

 const modeChanged=fixture(),mode=await pausedWhilePolling(modeChanged);
 mode.old.resolve(snapshot('fixture',[job('demo-task')],'demo'));await mode.polling;
 assert.equal(modeChanged.context.state.runtime.mode,'demo');
 assert.equal(modeChanged.context.state.jobs[0].id,'demo-task');
 assert.equal(modeChanged.context.serviceAvailable,true,modeChanged.context.serviceError);
 assert.equal(modeChanged.$('schedule-pause-controls').hidden,true);

 const failed=fixture(),failedPoll=failed.context.poll(),failedGet=failed.request('/api/state');
 const failedPause=failed.context.pauseSchedules();failed.request('/api/jobs/pause-all').reject(Error('synthetic network failure'));await failedPause;
 failedGet.resolve(snapshot('fixture',[job('fresh-after-failure')]));await failedPoll;
 assert.equal(failed.context.state.jobs[0].id,'fresh-after-failure');
 assert.match(failed.$('schedule-pause-feedback').textContent,/未确认暂停结果/);
 console.log('PASS: 4 deferred schedule pause/poll cases (synthetic only)');
})().catch(error=>{console.error(error);process.exitCode=1;});
