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
const failed={available:false,bridgeConfigured:true,bridgeState:'failed',issueCode:'selected_account_changed',issue:'fixture account mismatch',targetIds:[]};
const ready={available:true,bridgeConfigured:true,bridgeState:'ready',issue:'',targetIds:['fixture-group']};
(async()=>{
 context.response=failed;run('renderHookStatus(response)');
 assert.equal($('hook-start').disabled,false);
 const retry=run("setHookConnection('start')");
 assert.equal($('hook-start').disabled,true);assert.equal($('hook-start').textContent,'正在连接…');
 assert.match($('hook-composer-status').textContent,/正在连接/,'an explicit retry must replace the previous failure while connecting');
 assert.doesNotMatch($('send-reason').textContent,/fixture account mismatch/);
 pending.shift().resolve(failed);await retry;
 assert.equal($('hook-start').disabled,false);assert.equal($('hook-start').textContent,'连接发送');
 assert.equal($('hook-composer-status').textContent,failed.issue);
 assert.equal(calls.length,1);assert.equal(calls[0].url,'/api/windows/hook/start');
 const connected=run("setHookConnection('start')");pending.shift().resolve(ready);await connected;
 assert.equal($('hook-start').hidden,true);assert.equal($('hook-stop').hidden,false);
 assert.equal($('hook-composer-status').textContent,'微信已连接');
 $('message-text').value='draft';run('updateHookControls()');assert.equal($('send-button').disabled,false);
 const disconnect=run("setHookConnection('stop')");
 assert.match($('hook-composer-status').textContent,/正在断开/);
 pending.shift().resolve({...failed,bridgeState:'stopped',issue:'fixture stopped'});await disconnect;
 assert.equal($('hook-start').disabled,false);assert.equal($('send-button').disabled,true);
 const rejected=run("setHookConnection('start')");pending.shift().reject(Error('fixture network failure'));await rejected;
 assert.equal($('hook-start').disabled,false);assert.equal($('hook-start').textContent,'连接发送');
 assert.match($('hook-result-detail').textContent,/fixture network failure/);
 assert.equal(calls.length,4);assert.ok(calls.every(call=>/hook\/(start|stop)$/.test(call.url)));
 console.log('PASS: Hook connection progress, failed retry, ready, disconnect and request failure (synthetic only; no sends)');
})().catch(error=>{console.error(error);process.exitCode=1;});
