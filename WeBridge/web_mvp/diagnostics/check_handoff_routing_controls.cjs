// Synthetic DOM/API state checks; no real database, messages or native transport.
'use strict';
const fs=require('node:fs'),vm=require('node:vm'),assert=require('node:assert/strict'),path=require('node:path');
function node(tag='',cls='',text=''){return {tag,cls,textContent:text,value:'',children:[],hidden:false,disabled:false,open:false,events:{},append(...items){this.children.push(...items);},replaceChildren(){this.children=[];},addEventListener(event,callback){this.events[event]=callback;},showModal(){this.open=true;},close(){if(this.open){this.open=false;this.events.close?.();}}};}
const nodes=new Map(),$=id=>{if(!nodes.has(id))nodes.set(id,node());return nodes.get(id);};
const pending=[],calls=[],checks=[];let refreshed=0;
const ctx=vm.createContext({$,el:node,URLSearchParams,serviceAvailable:true,stamp:()=> 'time',handoffStatuses:{pending:'待领取',in_progress:'处理中',completed:'已完成'},
 state:{account:'a',runtime:{mode:'database',capabilities:{handoffRouting:true}},watchedGroups:['g1','g2']},
 isDatabase:()=>ctx.state.runtime.mode==='database',handoffScopeKey:()=>JSON.stringify([ctx.state.account,ctx.state.watchedGroups,ctx.state.runtime.mode,ctx.state.runtime.capabilities.handoffRouting]),
 resetHandoffPage:()=>{},loadHandoffs:async()=>{refreshed++;},api:(url,body)=>{calls.push({url,body});return new Promise((resolve,reject)=>pending.push({resolve,reject}));}});
const run=code=>vm.runInContext(code,ctx);run(fs.readFileSync(path.join(__dirname,'../static/handoff_routing_ui.js'),'utf8'));
const handoff=fs.readFileSync(path.join(__dirname,'../static/handoff_ui.js'),'utf8');run(handoff.slice(handoff.indexOf('function handoffStatus('),handoff.indexOf('function handoffPageControls(')));
const route=(groupId='g1',owner='',version=0)=>({groupId,groupName:'同名群',owner,version,updatedAt:version?100:null});
const routes=[route(),route('g2','历史负责人',3)];
function check(name,fn){fn();checks.push(name);}
async function open(rows=routes){const promise=run('openHandoffRouting()');pending.shift().resolve({routes:rows});await promise;}
(async()=>{
 await open();check('stable_ids_distinguish_same_name_groups',()=>assert.deepEqual($('handoff-route-group').children.map(item=>item.textContent),['同名群 · g1','同名群 · g2']));
 $('handoff-route-owner').value='销售部 · 张明';run('updateHandoffRoutingScope()');check('ordinary_scope_update_preserves_owner_draft',()=>assert.equal($('handoff-route-owner').value,'销售部 · 张明'));
 let saving=run('saveHandoffRouting()');check('save_uses_exact_group_and_cas_version',()=>assert.equal(JSON.stringify(calls.at(-1).body),JSON.stringify({account:'a',groupId:'g1',version:0,owner:'销售部 · 张明'})));
 pending.shift().resolve(route('g1','销售部 · 张明',1));await saving;check('saved_route_refreshes_owner_choices_without_claiming_tasks',()=>{assert.equal(refreshed,1);assert.match($('handoff-route-message').textContent,/仍需点击领取/);assert.match($('handoff-route-message').textContent,/未通知/);});
 $('handoff-route-clear').onclick();saving=run('saveHandoffRouting()');check('clear_posts_empty_label_with_latest_version',()=>{assert.equal(calls.at(-1).body.owner,'');assert.equal(calls.at(-1).body.version,1);});pending.shift().resolve(route('g1','',2));await saving;
 $('handoff-route-owner').value='保留冲突草稿';saving=run('saveHandoffRouting()');const before=calls.length;pending.shift().reject(Object.assign(Error('version changed'),{status:409}));await saving;
 check('conflict_retains_draft_without_automatic_reload',()=>{assert.equal(calls.length,before);assert.equal($('handoff-route-owner').value,'保留冲突草稿');assert.match($('handoff-route-message').textContent,/409/);assert.equal($('handoff-route-save').disabled,true);assert.equal($('handoff-route-reload').disabled,false);});
 let loading=run('loadHandoffRouting()');pending.shift().resolve({routes:[route('g1','外部更新',3),routes[1]]});await loading;check('explicit_reload_reads_current_owner_and_version',()=>{assert.equal($('handoff-route-owner').value,'外部更新');assert.equal(run('handoffRoute.version'),3);});
 loading=run('loadHandoffRouting()');const staleGroup=pending.shift();run('selectHandoffRoute("g2")');staleGroup.resolve({routes:[route('g1','迟到读取',4),route('g2','不应覆盖',4)]});await loading;
 check('late_read_does_not_replace_selected_group',()=>{assert.equal($('handoff-route-group').value,'g2');assert.equal($('handoff-route-owner').value,'历史负责人');});
 $('handoff-route-owner').value='x'.repeat(81);const count=calls.length;await run('saveHandoffRouting()');check('overlong_label_blocked_at_input_boundary',()=>assert.equal(calls.length,count));
 $('handoff-route-owner').value='旧账号保存';saving=run('saveHandoffRouting()');const staleSave=pending.shift();ctx.state.account='b';run('updateHandoffRoutingScope()');await open([route()]);$('handoff-route-owner').value='新账号草稿';const newSave=run('saveHandoffRouting()'),newPending=pending.shift();staleSave.resolve(route('g2','旧账号保存',4));await saving;
 check('old_account_response_does_not_unlock_or_overwrite_new_request',()=>{assert.equal($('handoff-route-save').disabled,true);assert.equal($('handoff-route-owner').value,'新账号草稿');});newPending.resolve(route('g1','新账号草稿',1));await newSave;
 loading=run('loadHandoffRouting()');const scopeLate=pending.shift();ctx.state.watchedGroups=[];run('updateHandoffRoutingScope()');scopeLate.resolve({routes});await loading;check('read_scope_change_closes_dialog_and_discards_late_data',()=>{assert.equal($('handoff-routing-dialog').open,false);assert.equal($('handoff-route-owner').value,'');});
 run('renderHandoffOwners(["旧标签","销售部 · 张明"])');$('handoff-owner-filter').value='owner:销售部 · 张明';check('owner_filter_uses_exact_label',()=>assert.equal(JSON.stringify(run('handoffOwnerQuery()')),JSON.stringify({ownerFilter:'owner',owner:'销售部 · 张明'})));
 run('renderHandoffOwners(["另一个标签"])');check('empty_page_does_not_silently_broaden_selected_owner',()=>{assert.equal($('handoff-owner-filter').value,'owner:销售部 · 张明');assert.ok($('handoff-owner-filter').children.some(item=>item.textContent==='销售部 · 张明'));});
 $('handoff-owner-filter').value='unassigned';check('unassigned_filter_has_no_owner_value',()=>assert.equal(JSON.stringify(run('handoffOwnerQuery()')),JSON.stringify({ownerFilter:'unassigned'})));
 check('assigned_pending_still_requires_explicit_claim',()=>{assert.equal(run('handoffStatus({status:"pending",owner:"甲"})'),'已分派 · 待领取');assert.equal(run('handoffStatus({status:"pending",owner:""})'),'待领取');});
 ctx.state.runtime.capabilities.handoffRouting=false;run('updateHandoffRoutingScope()');check('old_service_hides_controls_and_receives_no_owner_parameters',()=>{assert.equal($('handoff-routing-open').hidden,true);assert.equal($('handoff-owner-filter-field').hidden,true);assert.equal(JSON.stringify(run('handoffOwnerQuery()')),'{}');});
 ctx.state.runtime.capabilities.handoffRouting=true;ctx.state.runtime.mode='demo';run('updateHandoffRoutingScope()');check('demo_hides_routing',()=>assert.equal($('handoff-routing-open').hidden,true));
 check('all_mutations_remain_local_routing_only',()=>assert.ok(calls.every(call=>!call.body||call.url==='/api/handoffs/routing')));
 console.log('PASS: '+checks.length+' handoff routing controls checks (synthetic only)');
})().catch(error=>{console.error(error);process.exitCode=1;});
