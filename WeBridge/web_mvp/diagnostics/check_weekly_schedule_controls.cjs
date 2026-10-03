// Synthetic schedule form checks; no browser, WeChat, or native interface.
'use strict';
const fs=require('node:fs'),vm=require('node:vm'),assert=require('node:assert/strict');
const source=fs.readFileSync(require('node:path').join(__dirname,'../static/app.js'),'utf8');
function node(){return {value:'',checked:false,hidden:false,disabled:false,children:[],selectedOptions:[],append(...items){this.children.push(...items);},replaceChildren(){this.children=[];},showModal(){this.open=true;},close(){this.open=false;},focus(){this.focused=true;}};}
const nodes=new Map(),$=id=>{if(!nodes.has(id))nodes.set(id,node());return nodes.get(id);};
const weekdays=Array.from({length:7},(_,index)=>Object.assign(node(),{value:String(index+1)}));
let database=true,hold=false,fail=false,release;
const requests=[],messages=[];
const context=vm.createContext({$,console,Date,crypto:{randomUUID:()=> 'fixture-request-id'},
 document:{querySelectorAll:selector=>selector.includes(':checked')?weekdays.filter(day=>day.checked):weekdays},
 isDatabase:()=>database,isDemo:()=>false,supportsSchedules:()=>true,online:true,
 state:{account:'fixture',runtime:{capabilities:{canSend:true}},groups:[{id:'g',name:'Synthetic group'}],watchedGroups:['g']},selected:'g',scheduleRequestId:null,scheduleBusy:false,schedulePauseRequest:null,scheduleCreateRequest:null,scheduleRenderKey:'',
 toast:(message,error)=>messages.push({message,error}),api:async(path,body)=>{requests.push({path,body});if(hold)await new Promise(resolve=>release=resolve);if(fail)throw Error('Synthetic API failure');},
 poll:async()=>{},controls:()=>{$('create-schedule').disabled=context.scheduleBusy||!!context.schedulePauseRequest;},renderSchedules:()=>{},setView:()=>{},loadTimerMembers:()=>{},el:()=>node()});
vm.runInContext(source.slice(source.indexOf('function scheduleMode()'),source.indexOf("$('group-search').oninput")),context);
vm.runInContext(source.slice(source.indexOf("$('schedule-form').onsubmit="),source.indexOf("$('schedule-group').onchange=")),context);
const event={preventDefault(){}};
const submit=()=> $('schedule-form').onsubmit(event);
(async()=>{
 $('message-text').value='Preserved manual draft';$('reply-text').value='Preserved automatic template';
 vm.runInContext('openSchedule()',context);
 assert.equal($('schedule-mode').value,'once');assert.equal($('schedule-weekdays-field').hidden,true);
 assert.equal($('schedule-clock').required,false);assert.equal($('schedule-at').required,true);
 assert.deepEqual(weekdays.filter(day=>day.checked).map(day=>Number(day.value)),[1,2,3,4,5]);
 $('schedule-mode').value='weekly';vm.runInContext('scheduleMode()',context);
 assert.equal($('schedule-weekdays-field').hidden,false);assert.equal($('schedule-at').required,false);
 assert.equal($('schedule-clock').required,true);assert.equal($('schedule-clock-label').textContent,'发送时间');
 weekdays.forEach(day=>day.checked=false);$('schedule-group').value='g';$('schedule-text').value='Weekly business reminder';$('schedule-clock').value='09:30';
 await submit();assert.equal(requests.length,0);assert.match(messages.at(-1).message,/至少选择/);assert.equal($('schedule-dialog').open,true);
 weekdays[0].checked=true;weekdays[6].checked=true;hold=true;fail=true;
 const first=submit();await submit();assert.equal(requests.length,1);assert.equal($('create-schedule').disabled,true);
 release();await first;assert.equal($('schedule-dialog').open,true);assert.equal($('create-schedule').disabled,false);
 assert.deepEqual(Array.from(requests[0].body.weekdays),[1,7]);assert.equal(requests[0].body.mode,'weekly');
 assert.equal(requests[0].body.requestId,'fixture-request-id');assert.equal($('schedule-text').value,'Weekly business reminder');
 hold=false;fail=false;await submit();assert.equal(requests.length,2);assert.equal(requests[1].body.requestId,requests[0].body.requestId);
 assert.equal($('schedule-dialog').open,false);assert.equal($('message-text').value,'Preserved manual draft');assert.equal($('reply-text').value,'Preserved automatic template');
 for(const mode of ['daily','once']){$('schedule-mode').value=mode;vm.runInContext('scheduleMode()',context);await submit();assert.equal(Object.hasOwn(requests.at(-1).body,'weekdays'),false);assert.equal($('schedule-weekdays-field').hidden,true);}
 database=false;$('schedule-mode').value='weekly';vm.runInContext('scheduleMode()',context);await submit();
 assert.equal($('schedule-mode-field').hidden,true);assert.equal($('schedule-weekdays-field').hidden,true);assert.equal(Object.hasOwn(requests.at(-1).body,'mode'),false);assert.equal(Object.hasOwn(requests.at(-1).body,'weekdays'),false);
 console.log('PASS: weekly visibility, selection validation, exact payload, duplicate guard, retry identity and preserved drafts (synthetic only)');
})().catch(error=>{console.error(error);process.exitCode=1;});
