// Synthetic DOM and API regression; never connects to WeChat or a running service.
'use strict';
const fs=require('node:fs'),vm=require('node:vm'),assert=require('node:assert/strict');
const source=fs.readFileSync(require('node:path').join(__dirname,'../static/app.js'),'utf8');
function node(){return {children:[],value:'',textContent:'',append(...items){this.children.push(...items);},replaceChildren(){this.children=[];}};}
const nodes=new Map(),get=id=>{if(!nodes.has(id))nodes.set(id,node());return nodes.get(id);};
get('schedule-filter').value='all';
let release,calls=0;
const context=vm.createContext({$,el:(tag,className,text)=>Object.assign(node(),{textContent:text||''}),emptyCard:()=>node(),groupName:id=>id,
 stamp:()=> 'time',dateKey:()=> 'today',isDatabase:()=>true,serviceAvailable:true,
 state:{account:'fixture',jobs:[]},scheduleRenderKey:'',toast:()=>{},poll:async()=>{},
 api:async()=>{calls++;await new Promise(resolve=>release=resolve);}});
function $(id){return get(id);}
vm.runInContext(source.slice(source.indexOf('const scheduleActionsBusy='),source.indexOf('let environmentData=')),context);
vm.runInContext('function renderSchedules(){scheduleScope();renderWindowsSchedules();}',context);
const job={id:'job',targetName:'测试群',text:'Hello',state:'active',enabled:true,mode:'daily',clock:'09:00',runs:[{status:'server_accepted',createdAt:1,label:'待确认'}]};
context.state.jobs=[job];
vm.runInContext('scheduleScope();renderWindowsSchedules()',context);
assert.equal(get('unknown-count').textContent,1);
assert.match(get('schedule-record-scope').textContent,/10/);
get('schedule-search').value='hello';vm.runInContext('scheduleRenderKey="";renderWindowsSchedules()',context);
assert.equal(get('schedule-list').children[0].children.length,4);
get('schedule-filter').value='inactive';vm.runInContext('scheduleRenderKey="";renderWindowsSchedules()',context);
assert.equal(get('schedule-list').children[0].children.length,0);
get('schedule-filter').value='all';vm.runInContext('scheduleRenderKey="";renderWindowsSchedules()',context);
(async()=>{
 const actions=get('schedule-list').children[0].children[3];
 const first=actions.children[0].onclick();
 await actions.children[1].onclick();
 assert.equal(calls,1);
 assert.ok(get('schedule-list').children[0].children[3].children.every(button=>button.disabled));
 release();await first;
 assert.ok(get('schedule-list').children[0].children[3].children.every(button=>!button.disabled));
 context.state.jobs=[{...job,mode:'weekly',weekdays:[1,3,5],state:'paused',enabled:false}];
 vm.runInContext('renderWindowsSchedules()',context);
 const weekly=get('schedule-list').children[0];
 assert.equal(weekly.children[0].children[0].textContent,'周一、周三、周五 · 北京时间');
 assert.equal(weekly.children[3].children[0].textContent,'恢复');
 const resumed=weekly.children[3].children[0].onclick();release();await resumed;
 assert.equal(calls,2);
 console.log('PASS: pending evidence, scope, search, state filter, action dedupe, weekly labels and resume (synthetic only)');
})().catch(error=>{console.error(error);process.exitCode=1;});
