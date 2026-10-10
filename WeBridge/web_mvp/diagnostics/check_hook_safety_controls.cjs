// Synthetic connection controls only; no browser, native client or real send.
'use strict';
const fs=require('node:fs'),path=require('node:path'),vm=require('node:vm'),assert=require('node:assert/strict');
const source=fs.readFileSync(path.join(__dirname,'../static/hook_ui.js'),'utf8');
function node(){return {value:'',textContent:'',disabled:false,hidden:false,children:[],append(...items){this.children.push(...items);},replaceChildren(...items){this.children=[...items];},focus(){},scrollIntoView(){}};}
const nodes=new Map(),$=id=>{if(!nodes.has(id))nodes.set(id,node());return nodes.get(id);};
const pending=[],calls=[],timers=new Map();let timerId=0;
const context=vm.createContext({$,el:(tag,className,text)=>Object.assign(node(),{textContent:text||''}),
 state:{account:'fixture-account',runtime:{mode:'database',source:{id:'fixture-source'}},watchedGroups:['fixture-group'],groups:[{id:'fixture-group'}]},
 selected:'fixture-group',serviceAvailable:true,online:true,databaseBusy:false,groupLoadState:'ready',
 isDatabase:()=>true,groupName:()=> 'fixture group',setView(){},stamp:()=> 'time',poll:async()=>{},
 document:{hidden:false,addEventListener(){}},window:{addEventListener(){}},
 setTimeout:(callback)=>{const id=++timerId;timers.set(id,callback);return id;},clearTimeout:id=>timers.delete(id),
 api:(url,body)=>{calls.push({url,body});return new Promise((resolve,reject)=>pending.push({resolve,reject}));}});
vm.runInContext(source,context);
const run=code=>vm.runInContext(code,context);
const safety={version:0,paused:false,limits:{minimumIntervalSeconds:5,perMinute:6,per24Hours:100,duplicateWindowSeconds:30},usage:{minute:0,last24Hours:0},unresolvedCount:0,retryAt:null};
const ready={available:true,bridgeConfigured:true,bridgeState:'ready',targetIds:['fixture-group'],safety};
(async()=>{
 context.response=ready;run('renderHookStatus(response)');$('message-text').value='synthetic text';run('updateHookControls()');
 assert.equal($('hook-safety').hidden,false);assert.equal($('send-button').disabled,false);
 $('hook-safety-interval').value='7';run('renderHookStatus(response)');assert.equal($('hook-safety-interval').value,'7','status polling must preserve unsaved limits');
 context.response={...ready,available:false,safety:{...safety,version:1,paused:true,unresolvedCount:1}};run('renderHookStatus(response)');
 assert.equal($('send-button').disabled,true);assert.equal($('hook-confirm').disabled,true);assert.equal($('hook-safety-resume').disabled,true);assert.equal($('hook-start').hidden,true);assert.equal($('hook-stop').hidden,false);
 await run("changeHookSafety('resume')");assert.equal(calls.length,0,'resume must not submit without acknowledgement');
 $('hook-safety-ack').checked=true;run('updateHookSafetyControls()');assert.equal($('hook-safety-resume').disabled,false);
 const recovery=run("changeHookSafety('resume')");assert.equal(calls[0].body.account,'fixture-account');assert.equal(calls[0].body.version,1);assert.equal(calls[0].body.acknowledged,true);
 pending.shift().resolve({...safety,version:2});await recovery;pending.shift().resolve({...ready,safety:{...safety,version:2}});await Promise.resolve();await Promise.resolve();
 assert.match($('hook-safety-feedback').textContent,/旧请求不会重发/);assert.equal(calls.filter(call=>call.url.endsWith('/resume')||call.url.endsWith('/confirm')).length,0);
 context.response={...ready,safety:{...safety,retryAt:Date.now()/1000+30}};run('renderHookStatus(response)');assert.equal($('send-button').disabled,true);
 context.response={...ready,available:false,safety:{...safety,version:3,paused:true,reasonCode:'journal_unavailable'}};run('renderHookStatus(response)');assert.match($('hook-safety-state').textContent,/账本写入失败/);assert.match($('hook-safety-ack-text').textContent,/修复本机存储/);assert.equal($('send-button').disabled,true);
 run('resetHookSender()');assert.equal($('hook-safety').hidden,true);assert.equal($('hook-safety-ack').checked,false);
 console.log('PASS: account safety budgets, paused composer, explicit scoped acknowledgement, no replay and source reset (synthetic only)');
})().catch(error=>{console.error(error);process.exitCode=1;});
