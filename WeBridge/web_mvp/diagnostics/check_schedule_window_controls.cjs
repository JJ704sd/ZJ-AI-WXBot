// Synthetic DOM/API checks; no WeChat, native transport or real server.
'use strict';
const fs=require('node:fs'),path=require('node:path'),vm=require('node:vm'),assert=require('node:assert/strict');
const source=fs.readFileSync(path.join(__dirname,'../static/app.js'),'utf8');
function node(){return {value:'',checked:false,hidden:false,disabled:false,children:[],selectedOptions:[],append(...items){this.children.push(...items);},replaceChildren(){this.children=[];},showModal(){this.open=true;},close(){this.open=false;},focus(){this.focused=true;}};}
const nodes=new Map(),$=id=>{if(!nodes.has(id))nodes.set(id,node());return nodes.get(id);};
const weekdays=Array.from({length:7},(_,index)=>Object.assign(node(),{value:String(index+1)}));
let fail=false,sequence=0;const requests=[],messages=[],checks=[];
const context=vm.createContext({$,console,Date,crypto:{randomUUID:()=> 'fixture-request-'+(++sequence)},
 document:{querySelectorAll:selector=>selector.includes(':checked')?weekdays.filter(day=>day.checked):weekdays},
 isDatabase:()=>context.state.runtime.mode==='database',isDemo:()=>false,supportsSchedules:()=>true,online:true,
 state:{account:'fixture',runtime:{mode:'database',capabilities:{canSend:true,scheduledSend:true,scheduleWindows:true}},groups:[{id:'g',name:'Synthetic group'}],watchedGroups:['g']},selected:'g',scheduleRequestId:null,scheduleBusy:false,schedulePauseRequest:null,scheduleCreateRequest:null,scheduleRenderKey:'',
 toast:(message,error)=>messages.push({message,error}),api:async(path,body)=>{requests.push({path,body});if(fail)throw Error('Synthetic API failure');},
 poll:async()=>{},controls:()=>{$('create-schedule').disabled=context.scheduleBusy||!!context.schedulePauseRequest;},renderSchedules:()=>{},setView:()=>{},loadTimerMembers:()=>{},el:()=>node()});
vm.runInContext(source.slice(source.indexOf('function supportsSchedules()'),source.indexOf('function supportsReplies()')),context);
vm.runInContext(source.slice(source.indexOf('function scheduleMode()'),source.indexOf("$('group-search').oninput")),context);
vm.runInContext(source.slice(source.indexOf("$('schedule-form').onsubmit="),source.indexOf("$('schedule-group').onchange=")),context);
const submit=()=> $('schedule-form').onsubmit({preventDefault(){}});
function check(name,body){body();checks.push(name);}
(async()=>{
 vm.runInContext('openSchedule()',context);$('schedule-group').value='g';$('schedule-text').value='Window fixture';
 check('capability_enables_required_default_two_minutes',()=>{assert.equal($('schedule-window-field').hidden,false);assert.equal($('schedule-window-minutes').required,true);assert.equal(String($('schedule-window-minutes').value),'2');});
 const id=context.scheduleRequestId;
 for(const value of ['', '0','1440','1.5','nope']){$('schedule-window-minutes').value=value;await submit();}
 check('invalid_windows_do_not_submit_or_change_request_identity',()=>{assert.equal(requests.length,0);assert.equal(context.scheduleRequestId,id);assert.equal($('schedule-window-minutes').focused,true);});
 $('schedule-window-minutes').value='30';vm.runInContext('scheduleMode()',context);
 check('mode_refresh_preserves_draft_and_explains_window',()=>{assert.equal($('schedule-window-minutes').value,'30');assert.match($('schedule-policy').textContent,/跨午夜/);assert.match($('schedule-policy').textContent,/本机提交前/);assert.match($('schedule-policy').textContent,/不能撤回/);});
 fail=true;await submit();
 check('failed_request_keeps_window_and_identity',()=>{assert.equal(requests[0].body.windowMinutes,30);assert.equal(requests[0].body.requestId,id);assert.equal($('schedule-dialog').open,true);assert.equal($('schedule-window-minutes').value,'30');});
 fail=false;$('schedule-window-minutes').value='45';await submit();
 check('editing_failed_window_does_not_silently_replace_request_id',()=>{assert.equal(requests[1].body.windowMinutes,45);assert.equal(requests[1].body.requestId,id);});
 vm.runInContext('openSchedule()',context);
 check('new_dialog_resets_default_and_renews_identity',()=>{assert.equal(String($('schedule-window-minutes').value),'2');assert.notEqual(context.scheduleRequestId,id);});
 for(const value of ['1','1439']){$('schedule-window-minutes').value=value;await submit();assert.equal(requests.at(-1).body.windowMinutes,Number(value));}checks.push('both_window_bounds_submit_integer_payload');
 $('schedule-window-minutes').value='91';context.state.runtime.capabilities.scheduleWindows=false;vm.runInContext('scheduleMode()',context);
 check('capability_removal_hides_and_disables_validation_without_erasing_draft',()=>{assert.equal($('schedule-window-field').hidden,true);assert.equal($('schedule-window-minutes').required,false);assert.equal($('schedule-window-minutes').disabled,true);assert.equal($('schedule-window-minutes').value,'91');assert.match($('schedule-policy').textContent,/2 分钟/);});
 await submit();check('old_windows_service_receives_original_payload',()=>assert.equal(Object.hasOwn(requests.at(-1).body,'windowMinutes'),false));
 context.state.runtime.capabilities.scheduleWindows=true;vm.runInContext('scheduleMode()',context);check('capability_return_preserves_draft',()=>assert.equal($('schedule-window-minutes').value,'91'));
 context.state.runtime.mode='demo';vm.runInContext('scheduleMode()',context);await submit();
 check('non_database_ignores_windows_capability_and_omits_field',()=>{assert.equal($('schedule-window-field').hidden,true);assert.equal(Object.hasOwn(requests.at(-1).body,'windowMinutes'),false);assert.equal(Object.hasOwn(requests.at(-1).body,'mode'),false);});
 console.log('PASS: '+checks.length+' schedule window checks (synthetic only)');
})().catch(error=>{console.error(error);process.exitCode=1;});
