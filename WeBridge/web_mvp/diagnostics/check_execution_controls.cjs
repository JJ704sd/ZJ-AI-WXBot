'use strict';
const fs=require('node:fs'),vm=require('node:vm'),assert=require('node:assert/strict'),path=require('node:path');
function element(tag='',cls='',text=''){return {tag,cls,textContent:text,children:[],value:'all',hidden:false,append(...items){this.children.push(...items)},replaceChildren(){this.children=[]},addEventListener(){}};}
const nodes=new Map(),$=id=>{if(!nodes.has(id))nodes.set(id,element());return nodes.get(id)};
$('execution-search').value='';$('execution-limit').value='200';
let release;
const ctx=vm.createContext({$,el:element,emptyCard:()=>element('empty'),state:{account:'a',watchedGroups:['g'],runtime:{mode:'database'}},document:{hidden:false},serviceAvailable:true,Date,JSON,URLSearchParams,isDemo:()=>false,stamp:()=> 'time',setView:()=>{},selectGroup:()=>{},api:()=>new Promise(resolve=>release=resolve)});
vm.runInContext(fs.readFileSync(path.join(__dirname,'../static/execution_ui.js'),'utf8'),ctx);
(async()=>{
 vm.runInContext('updateExecutionScope()',ctx);
 const load=vm.runInContext('loadExecutionHistory(true)',ctx);
 ctx.state.account='b';vm.runInContext('updateExecutionScope()',ctx);
 release({limit:200,records:[{targetName:'OLD_ACCOUNT_SECRET'}]});await load;
 assert.equal($('execution-list').children.length,0);
 assert.equal($('execution-refresh').disabled,false);
 vm.runInContext(`executionRows=[{id:'1',source:'manual',targetId:'g',targetName:'群',text:'Hello',label:'待确认',createdAt:1,pending:true,attention:false},{id:'2',source:'reply',targetId:'g',targetName:'群',text:'Other',label:'阻止',createdAt:2,pending:false,attention:true}];renderExecutionHistory()`,ctx);
 assert.equal($('execution-list').children.length,2);
 $('execution-status').value='pending';vm.runInContext('renderExecutionHistory()',ctx);assert.equal($('execution-list').children.length,1);
 $('execution-source').value='reply';vm.runInContext('renderExecutionHistory()',ctx);assert.equal($('execution-list').children[0].tag,'empty');
 $('execution-source').value='all';$('execution-status').value='all';$('execution-search').value='HELLO';vm.runInContext('renderExecutionHistory()',ctx);assert.equal($('execution-list').children.length,1);
 const card=$('execution-list').children[0];vm.runInContext('renderExecutionHistory()',ctx);assert.equal($('execution-list').children[0],card);
 const rangeLoad=vm.runInContext('loadExecutionHistory(true)',ctx);
 $('execution-limit').value='1000';vm.runInContext('updateExecutionScope()',ctx);
 release({limit:200,records:[{targetName:'OLD_RANGE'}]});await rangeLoad;
 assert.equal($('execution-list').children.length,0);
 const failed=vm.runInContext('loadExecutionHistory(true)',ctx);release({limit:200,records:[]});await failed;
 console.log('PASS: stale account response discarded, filters, search, unchanged DOM preserved (synthetic only)');
})().catch(error=>{console.error(error);process.exitCode=1});
