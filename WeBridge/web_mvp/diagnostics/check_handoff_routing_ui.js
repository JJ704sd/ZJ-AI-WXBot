// playwright-cli run-code --filename web_mvp/diagnostics/check_handoff_routing_ui.js
// All APIs are synthetic. Never reads WeChat or uses a native sending interface.
async (page) => {
 const checks=[],errors=[],requests=[],gates=[];
 const check=(condition,name)=>{if(!condition)throw Error(name);checks.push(name);};
 const clone=value=>JSON.parse(JSON.stringify(value));
 const deferred=()=>{let resolve;const promise=new Promise(done=>resolve=done);const gate={promise,resolve};gates.push(gate);return gate;};
 const groupA={id:'route-alpha@chatroom',name:'同名业务群'},groupB={id:'route-beta@chatroom',name:'同名业务群'};
 const source={id:'routing-account-a',revision:'r1',status:'snapshot_ready',createdAt:'2026-10-03T01:00:00Z',updatePolicy:'on_change'};
 const state={account:source.id,selfId:'fixture-self',name:'合成分派账号',csrfToken:'synthetic',connection:{status:'snapshot_ready'},groups:[groupA,groupB],selected:groupA.id,watchedGroups:[groupA.id,groupB.id],jobs:[],outbox:[],runtime:{mode:'database',connected:true,platform:'Windows',source,capabilities:{read:true,canSend:false,hookSendInterface:false,groupSend:false,automaticReplies:true,scheduledSend:true,handoffRouting:true,mentions:true,media:false}}};
 const rule={enabled:true,text:'保留的固定文本',cooldown:30,mode:'handoff'};
 const task=(id,group,owner='')=>({id,groupId:group.id,groupName:group.name,trigger:{messageId:'m-'+id,serverId:id,senderId:'customer',senderName:'合成客户',timestamp:1790989210,text:'合成待办 '+id,textTruncated:false},reason:'群规则要求人工处理',owner,status:'pending',createdAt:1790989211,updatedAt:1790989211,version:1,note:'',revoked:false});
 const tasks=[task('existing-unassigned',groupA),task('historical-owner',groupB,'历史负责人')],beforeTasks=clone(tasks);
 const route=(group,owner='',version=0)=>({groupId:group.id,groupName:group.name,owner,version,updatedAt:version?1790989200:null});
 const routes=new Map([[groupA.id,route(groupA)],[groupB.id,route(groupB,'旧默认标签',1)]]);
 let forceConflict=false,writeGate=null;
 const handler=async response=>{
  const request=response.request(),raw=request.url(),path=raw.split('?')[0].replace(/^https?:\/\/[^/]+/,''),query=Object.fromEntries((raw.split('?')[1]||'').split('&').filter(Boolean).map(part=>{const [key,value='']=part.split('=');return [decodeURIComponent(key),decodeURIComponent(value.replace(/\+/g,' '))];}));
  const body=request.method()==='POST'?request.postDataJSON():null;requests.push({path,query,body,method:request.method()});
  if(path==='/api/state')return response.fulfill({json:state});
  if(path==='/api/database')return response.fulfill({json:{mode:'database',configured:true,busy:false,config:{sourceRoot:'D:\\Synthetic\\db',autoRefresh:true},source:state.runtime.source}});
  if(path==='/api/select')return response.fulfill({json:{ok:true}});
  if(path==='/api/group'||path==='/api/messages')return response.fulfill({json:{watching:true,members:[],messages:[],outbox:[],reply:rule}});
  if(path==='/api/windows/hook/status')return response.fulfill({json:{available:false,status:'disabled',issue:'合成测试未连接 Hook'}});
  if(path==='/api/handoffs/routing'){
   if(!body)return response.fulfill({json:{routes:[...routes.values()].filter(row=>state.watchedGroups.includes(row.groupId))}});
   const row=routes.get(body.groupId);
   if(forceConflict){forceConflict=false;row.version++;row.owner='并发更新负责人';return response.fulfill({status:409,json:{error:'配置已变化',code:'handoff_conflict'}});}
   if(body.version!==row.version)return response.fulfill({status:409,json:{error:'版本已变化',code:'handoff_conflict'}});
   const saved={...row,owner:body.owner,version:row.version+1,updatedAt:1790989300},held=writeGate;writeGate=null;
   if(held){held.started.resolve();await held.done.promise;}
   routes.set(row.groupId,saved);return response.fulfill({json:saved});
  }
  if(path==='/api/handoffs'){
   const visibleTasks=tasks.filter(row=>state.watchedGroups.includes(row.groupId));
   const scoped=visibleTasks.filter(row=>!query.groupId||row.groupId===query.groupId);
   const owners=[...new Set([...visibleTasks.map(row=>row.owner),...[...routes.values()].filter(row=>state.watchedGroups.includes(row.groupId)).map(row=>row.owner)].filter(Boolean))].sort();
   const filtered=scoped.filter(row=>(query.status==='all'||query.status==='open'&&row.status!=='completed'||row.status===query.status)&&(query.ownerFilter==='unassigned'?!row.owner:query.ownerFilter==='owner'?row.owner===query.owner:true));
   const offset=query.cursor?Number(query.cursor):0,records=filtered.slice(offset,offset+1),hasMore=offset+1<filtered.length;
   return response.fulfill({json:{records,owners,hasMore,nextCursor:hasMore?String(offset+1):'',limit:50}});
  }
  if(path==='/api/handoffs/detail'){const record=tasks.find(row=>row.id===query.id);return response.fulfill({json:{record,changes:[],historyTruncated:false}});}
  if(path==='/api/handoffs/action'){
   const row=tasks.find(item=>item.id===body.id);if(row.version!==body.version)return response.fulfill({status:409,json:{error:'待办已变化',code:'handoff_conflict'}});
   row.status={claim:'in_progress',release:'pending',complete:'completed',reopen:'pending'}[body.action];row.owner=body.action==='claim'?body.owner:['release','reopen'].includes(body.action)?'':row.owner;row.note=body.note;row.version++;
   return response.fulfill({json:row});
  }
  return response.fulfill({status:400,json:{error:'Synthetic test blocks this API.'}});
 };
 const onError=error=>errors.push(error.message);page.on('pageerror',onError);await page.route('**/api/**',handler);
 const refresh=async()=>{await page.waitForFunction(()=>!pollBusy);await page.evaluate(()=>poll());};
 const routingReady=()=>page.waitForFunction(()=>handoffRouteRequest===null&&handoffRoute!==null);
 const queueReady=()=>page.waitForFunction(()=>!handoffLoading);
 const closeRoute=async()=>{await page.locator('#handoff-routing-dialog .dialog-heading .close-dialog').click();await page.waitForFunction(()=>!document.getElementById('handoff-routing-dialog').open&&handoffRoute===null);};
 const visible=async(selector,name)=>{const locator=page.locator(selector);await locator.scrollIntoViewIfNeeded();const ok=await locator.evaluate(node=>{const r=node.getBoundingClientRect(),d=node.closest('dialog').getBoundingClientRect(),hit=document.elementFromPoint(r.left+r.width/2,r.top+r.height/2);return r.width>0&&r.height>0&&r.top>=Math.max(d.top,0)&&r.bottom<=Math.min(d.bottom,innerHeight)+1&&r.left>=0&&r.right<=innerWidth+1&&!!hit&&(hit===node||node.contains(hit));});check(ok,name);};
 try{
  await page.setViewportSize({width:1440,height:1020});await page.reload();await page.waitForFunction(()=>document.getElementById('selected-name').textContent.includes('同名业务群'));
  await page.locator('[data-view="handoffs"]').click();await queueReady();await page.locator('#handoff-routing-open').click();await routingReady();
  check((await page.locator('#handoff-route-group option').allTextContents()).every(text=>text.includes('@chatroom')),'same_name_groups_include_stable_ids');
  check((await page.locator('.handoff-routing-notice').innerText()).includes('不是微信身份')&&(await page.locator('.handoff-routing-notice').innerText()).includes('不会通知'),'local_label_and_no_notification_boundary_visible');
  await page.locator('#handoff-route-owner').fill('销售部 · 张明');await refresh();check(await page.locator('#handoff-route-owner').inputValue()==='销售部 · 张明','poll_preserves_unsaved_route_owner');
  await page.locator('#handoff-route-save').click();await routingReady();await queueReady();
  check(routes.get(groupA.id).owner==='销售部 · 张明'&&routes.get(groupA.id).version===1,'unconfigured_group_saves_with_version_zero');
  await page.locator('#handoff-route-group').selectOption(groupB.id);check(await page.locator('#handoff-route-owner').inputValue()==='旧默认标签','second_same_name_group_loads_distinct_owner');
  await page.locator('#handoff-route-owner').fill('售后部 · 李明');await page.locator('#handoff-route-save').click();await routingReady();await queueReady();
  check(routes.get(groupB.id).owner==='售后部 · 李明'&&routes.get(groupA.id).owner==='销售部 · 张明','two_group_defaults_remain_separate');
  check(JSON.stringify(tasks)===JSON.stringify(beforeTasks),'changing_routes_does_not_modify_existing_tasks');
  await page.screenshot({path:'output/playwright/handoff-routing-desktop.png',fullPage:true});
  await page.setViewportSize({width:390,height:844});check(await page.locator('#handoff-routing-dialog').evaluate(node=>node.scrollWidth<=node.clientWidth+1),'routing_dialog_no_mobile_horizontal_overflow');await visible('#handoff-route-owner','owner_input_reachable_on_mobile');await visible('#handoff-route-save','save_button_reachable_on_mobile');await page.screenshot({path:'output/playwright/handoff-routing-mobile.png',fullPage:true});await page.setViewportSize({width:1440,height:1020});
  await page.locator('#handoff-route-clear').click();await page.locator('#handoff-route-save').click();await routingReady();await queueReady();
  check(routes.get(groupB.id).owner===''&&routes.get(groupB.id).version===3,'clearing_route_persists_empty_owner_and_increments_version');
  await page.locator('#handoff-route-owner').fill('保留冲突草稿');forceConflict=true;await page.locator('#handoff-route-save').click();await page.waitForFunction(()=>handoffRouteRequest===null);
  check((await page.locator('#handoff-route-message').innerText()).includes('409')&&await page.locator('#handoff-route-owner').inputValue()==='保留冲突草稿'&&await page.locator('#handoff-route-save').isDisabled(),'cas_conflict_retains_draft_and_disables_resave');
  const reads=requests.filter(row=>row.path==='/api/handoffs/routing'&&!row.body).length;await refresh();check(requests.filter(row=>row.path==='/api/handoffs/routing'&&!row.body).length===reads&&await page.locator('#handoff-route-owner').inputValue()==='保留冲突草稿','conflict_does_not_automatically_reload_or_overwrite_draft');
  await page.locator('#handoff-route-reload').click();await routingReady();check(await page.locator('#handoff-route-owner').inputValue()==='并发更新负责人','explicit_reload_accepts_current_route');await closeRoute();

  tasks.unshift(task('assigned-one',groupA,routes.get(groupA.id).owner),task('assigned-two',groupA,routes.get(groupA.id).owner));await page.locator('#handoff-refresh').click();await queueReady();
  check((await page.locator('#handoff-list').innerText()).includes('已分派 · 待领取'),'new_owner_assigned_task_stays_pending');
  const owners=await page.locator('#handoff-owner-filter option').allTextContents();check(owners.includes('历史负责人')&&owners.includes('销售部 · 张明')&&owners.includes('并发更新负责人'),'filter_includes_historical_task_and_current_route_labels');
  await page.locator('#handoff-owner-filter').selectOption('owner:销售部 · 张明');await queueReady();
  const exact=requests.filter(row=>row.path==='/api/handoffs').at(-1).query;check(exact.ownerFilter==='owner'&&exact.owner==='销售部 · 张明'&&!exact.cursor,'owner_filter_restarts_first_page_with_exact_label');
  await page.locator('#handoff-next').click();await queueReady();const paged=requests.filter(row=>row.path==='/api/handoffs').at(-1).query;check(paged.owner==='销售部 · 张明'&&paged.cursor==='1'&&(await page.locator('#handoff-list').innerText()).includes('assigned-two'),'pagination_preserves_owner_filter');
  await refresh();check((await page.locator('#handoff-page').innerText())==='第 2 页','poll_preserves_filtered_history_page');
  await page.locator('#handoff-owner-filter').selectOption('unassigned');await queueReady();check((await page.locator('#handoff-list').innerText()).includes('existing-unassigned')&&(await page.locator('#handoff-page').innerText())==='第 1 页','unassigned_filter_returns_unclaimed_ownerless_task');
  await page.locator('#handoff-owner-filter').selectOption('owner:销售部 · 张明');await queueReady();await page.locator('#handoff-list button').click();await page.waitForFunction(()=>!handoffDetailLoading&&handoffDetail!==null);
  check(await page.locator('#handoff-owner').inputValue()==='销售部 · 张明'&&!await page.locator('#handoff-owner').isDisabled()&&(await page.locator('#handoff-detail-title').innerText()).includes('已分派'),'assigned_pending_prefills_editable_owner_and_requires_claim');
  await page.locator('#handoff-owner').fill('销售部 · 接班人');await page.locator('#handoff-claim').click();await page.waitForFunction(()=>!handoffActionBusy&&handoffDetail.status==='in_progress');check(tasks.find(row=>row.id==='assigned-one').owner==='销售部 · 接班人','explicit_claim_can_change_assigned_owner');
  await page.locator('#handoff-release').click();await page.waitForFunction(()=>!handoffActionBusy&&handoffDetail.status==='pending');check(tasks.find(row=>row.id==='assigned-one').owner===''&&await page.locator('#handoff-owner').inputValue()==='','release_returns_task_to_unassigned_queue');
  await page.locator('#handoff-dialog .dialog-heading .close-dialog').click();await page.locator('#handoff-owner-filter').selectOption('unassigned');await queueReady();check((await page.locator('#handoff-list').innerText()).includes('assigned-one'),'released_task_visible_in_unassigned_filter');
  await page.setViewportSize({width:390,height:844});check(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth+1),'owner_filters_no_mobile_horizontal_overflow');await page.screenshot({path:'output/playwright/handoff-owner-filter-mobile.png',fullPage:true});await page.setViewportSize({width:1440,height:1020});

  await page.locator('#handoff-routing-open').click();await routingReady();await page.locator('#handoff-route-owner').fill('迟到旧账号标签');const late={started:deferred(),done:deferred()};writeGate=late;await page.evaluate(()=>{window.__oldRouteSave=saveHandoffRouting();});await late.started.promise;
  state.account='routing-account-b';state.runtime.source={...source,id:state.account};await refresh();late.done.resolve();await page.evaluate(()=>window.__oldRouteSave);
  check(!await page.locator('#handoff-routing-dialog').isVisible()&&await page.locator('#handoff-route-owner').inputValue()==='','account_change_discards_late_route_response');
  state.runtime.capabilities.handoffRouting=false;await refresh();await page.locator('#handoff-refresh').click();await queueReady();
  check(await page.locator('#handoff-routing-open').isHidden()&&await page.locator('#handoff-owner-filter-field').isHidden()&&!Object.hasOwn(requests.filter(row=>row.path==='/api/handoffs').at(-1).query,'ownerFilter'),'old_service_hides_controls_and_omits_owner_filter');
  state.runtime={mode:'demo',platform:'Windows',capabilities:{canSend:true,handoffRouting:true}};state.connection={status:'logged_in'};await refresh();check(await page.locator('#handoff-routing-open').isHidden(),'demo_does_not_expose_routing');
  check(rule.mode==='handoff'&&rule.enabled&&rule.text==='保留的固定文本','routing_and_task_actions_preserve_group_rule');
  check(!requests.some(row=>row.method==='POST'&&!['/api/select','/api/handoffs/routing','/api/handoffs/action'].includes(row.path)),'no_message_hook_rule_or_schedule_mutation');
  check(errors.length===0,'no_browser_javascript_errors');return {checks,realBrowser:true,allApis:'synthetic',realWindowsReadOrSend:false};
 }finally{for(const gate of gates)gate.resolve();page.off('pageerror',onError);await page.unroute('**/api/**',handler);}
}
