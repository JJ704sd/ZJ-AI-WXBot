'use strict';
const fs=require('node:fs'),vm=require('node:vm'),assert=require('node:assert/strict'),path=require('node:path');
const source=fs.readFileSync(path.join(__dirname,'../static/app.js'),'utf8');
const fields={'message-history-limit':{value:'500'},'message-text':{value:'未提交草稿'},'reply-text':{value:'未保存规则'}};
let release,renders=0;
const ctx=vm.createContext({$:id=>fields[id],selected:'g',groupLoadState:'ready',groupVersion:0,state:{account:'a'},messageData:[],outboxData:[],groupQuery:()=>'/api/messages?limit=500',supportsComposer:()=>false,renderMessages:()=>renders++,toast:()=>{},api:()=>new Promise(resolve=>release=resolve)});
vm.runInContext(source.slice(source.indexOf("$('message-history-limit').onchange="),source.indexOf('function groupName(')),ctx);
(async()=>{
 const first=fields['message-history-limit'].onchange();
 release({messages:[{id:'old-record'}]});await first;
 assert.equal(ctx.messageData[0].id,'old-record');assert.equal(renders,1);
 assert.equal(fields['message-text'].value,'未提交草稿');assert.equal(fields['reply-text'].value,'未保存规则');
 const late=fields['message-history-limit'].onchange();ctx.selected='new';ctx.groupVersion++;
 release({messages:[{id:'wrong-group'}]});await late;
 assert.equal(ctx.messageData[0].id,'old-record');assert.equal(renders,1);
 console.log('PASS: message range preserves draft and unsaved reply; stale group response discarded (synthetic only)');
})().catch(error=>{console.error(error);process.exitCode=1});
