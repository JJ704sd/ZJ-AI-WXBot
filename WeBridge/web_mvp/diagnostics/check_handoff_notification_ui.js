// playwright-cli run-code --filename web_mvp/diagnostics/check_handoff_notification_ui.js
// Every API is synthetic. This script never reads WeChat or invokes Hook.
async (page) => {
 const checks=[],errors=[],requests=[],gates=[];
 const check=(condition,name)=>{if(!condition)throw Error(name);checks.push(name);};
 const clone=value=>JSON.parse(JSON.stringify(value));
 const deferred=()=>{let resolve;const promise=new Promise(done=>resolve=done);const gate={promise,resolve};gates.push(gate);return gate;};
 const groupA={id:'notify-alpha@chatroom',name:'同名业务群'},groupB={id:'notify-beta@chatroom',name:'同名业务群'},personA={id:'notify-person-alpha',name:'同名联系人'},personB={id:'notify-person-beta',name:'同名联系人'};
 const source={id:'notify-account-a',revision:'r1',status:'snapshot_ready',createdAt:'2026-10-03T01:00:00Z',updatePolicy:'on_change'};
 const state={account:source.id,selfId:'fixture-self',name:'合成通知账号',csrfToken:'synthetic',connection:{status:'snapshot_ready'},groups:[groupA,groupB,personA,personB],selected:groupA.id,watchedGroups:[groupA.id,groupB.id,personA.id,personB.id],jobs:[],outbox:[],runtime:{mode:'database',connected:true,platform:'Windows',source,capabilities:{read:true,canSend:false,hookSendInterface:false,groupSend:false,automaticReplies:true,scheduledSend:true,handoffRouting:true,handoffNotifications:true,mentions:true,media:false}}};
 const rule={enabled:true,text:'保留的固定文本',cooldown:30,mode:'handoff'};
 const notification=(status='not_configured')=>({status,issue:'',targetId:status==='not_configured'||status==='unassigned'?'':personB.id,targetName:status==='not_configured'||status==='unassigned'?'':personB.name,createdAt:status==='not_configured'||status==='unassigned'?null:1790989211,expiresAt:status==='not_configured'||status==='unassigned'?null:1790989811,draftId:['unknown','submitted_unconfirmed','server_accepted','local_record_observed','local_record_confirmed'].includes(status)?'synthetic-'+status:'',delivered:false,retryAllowed:false});
 const task=(id,status='not_configured')=>({id,groupId:groupA.id,groupName:groupA.name,trigger:{messageId:'m-'+id,serverId:id,senderId:'customer',senderName:'合成客户',timestamp:1790989210,text:'合成原文 '+id,textTruncated:false},reason:'群规则要求人工处理',owner:status==='unassigned'?'':'销售部 · 张明',status:'pending',createdAt:1790989211,updatedAt:1790989211,version:1,note:'',revoked:false,notification:notification(status)});
 const tasks=[task('existing-task')],originalTask=clone(tasks[0]);
 const config=(group,owner)=>({groupId:group.id,groupName:group.name,owner,routeVersion:1,version:0,enabled:false,targetId:'',targetName:'',issue:'',updatedAt:null});
 const configSets=new Map([[source.id,[config(groupA,'销售部 · 张明'),config(groupB,'售后部 · 李明')]],['notify-account-b',[config(groupA,'新账号负责人'),config(groupB,'新账号另一负责人')]]]);
 let forceConflict=false,writeGate=null,readGate=null;
 const handler=async response=>{
  const request=response.request(),raw=request.url(),path=raw.split('?')[0].replace(/^https?:\/\/[^/]+/,''),query=Object.fromEntries((raw.split('?')[1]||'').split('&').filter(Boolean).map(part=>{const [key,value='']=part.split('=');return [decodeURIComponent(key),decodeURIComponent(value.replace(/\+/g,' '))];}));
  const body=request.method()==='POST'?request.postDataJSON():null;requests.push({path,query,body,method:request.method()});
  if(path==='/api/state')return response.fulfill({json:state});
  if(path==='/api/database')return response.fulfill({json:{mode:'database',configured:true,busy:false,config:{sourceRoot:'D:\\Synthetic\\db',autoRefresh:true},source:state.runtime.source}});
  if(path==='/api/select')return response.fulfill({json:{ok:true}});
  if(path==='/api/group'||path==='/api/messages')return response.fulfill({json:{watching:true,members:[],messages:[],outbox:[],reply:rule}});
  if(path==='/api/windows/hook/status')return response.fulfill({json:{available:false,status:'disabled',issue:'合成测试未连接 Hook'}});
  if(path==='/api/handoffs/notifications'){
   const configs=configSets.get(body?body.account:query.account);
   if(!body){
    const data=clone({configs:configs.filter(row=>state.watchedGroups.includes(row.groupId)),recipients:[personA,personB].filter(row=>state.watchedGroups.includes(row.id))}),held=readGate;readGate=null;
    if(held){held.started.resolve();await held.done.promise;}
    return response.fulfill({json:data});
   }
   const row=configs.find(item=>item.groupId===body.groupId);
   if(forceConflict){forceConflict=false;row.owner='并发修改负责人';row.routeVersion++;row.version++;row.enabled=false;row.issue='负责人已变化，请重新核对';return response.fulfill({status:409,json:{error:'配置或负责人已变化',code:'handoff_conflict'}});}
   if(body.version!==row.version||body.routeVersion!==row.routeVersion)return response.fulfill({status:409,json:{error:'版本已变化',code:'handoff_conflict'}});
   const held=writeGate;writeGate=null;if(held){held.started.resolve();await held.done.promise;if(held.fail)return response.fulfill({status:503,json:{error:'旧账号合成保存失败'}});}
   Object.assign(row,{version:row.version+1,targetId:body.targetId,targetName:body.targetId?'同名联系人':'',enabled:body.enabled,issue:'',updatedAt:1790989300});
   if(!row.enabled)for(const item of tasks)if(item.groupId===row.groupId&&item.notification.status==='queued')item.notification={...item.notification,status:'cancelled',issue:'通知配置已关闭'};
   return response.fulfill({json:row});
  }
  if(path==='/api/handoffs'){
   const visible=tasks.filter(row=>state.watchedGroups.includes(row.groupId)),owners=[...new Set([...visible.map(row=>row.owner),...configSets.get(query.account).filter(row=>state.watchedGroups.includes(row.groupId)).map(row=>row.owner)].filter(Boolean))].sort();
   const records=visible.filter(row=>(!query.groupId||row.groupId===query.groupId)&&(query.status==='all'||query.status==='open'&&row.status!=='completed'||row.status===query.status));
   return response.fulfill({json:{records,owners,hasMore:false,nextCursor:'',limit:50}});
  }
  if(path==='/api/handoffs/detail'){const record=tasks.find(row=>row.id===query.id);return response.fulfill({json:{record,changes:[],historyTruncated:false}});}
  if(path==='/api/handoffs/action'){
   const row=tasks.find(item=>item.id===body.id);if(body.version!==row.version)return response.fulfill({status:409,json:{error:'待办已变化',code:'handoff_conflict'}});
   row.status={claim:'in_progress',release:'pending',complete:'completed',reopen:'pending'}[body.action];row.owner=body.action==='claim'?body.owner:['release','reopen'].includes(body.action)?'':row.owner;row.note=body.note;row.version++;
   if(row.notification.status==='queued')row.notification={...row.notification,status:'cancelled',issue:'待办已变化'};
   return response.fulfill({json:row});
  }
  return response.fulfill({status:400,json:{error:'Synthetic test blocks this API.'}});
 };
 const onError=error=>errors.push(error.message);page.on('pageerror',onError);await page.route('**/api/**',handler);
 const refresh=async()=>{await page.waitForFunction(()=>!pollBusy);await page.evaluate(()=>poll());};
 const ready=()=>page.waitForFunction(()=>handoffNotifyRequest===null&&handoffNotifyConfig!==null);
 const queueReady=()=>page.waitForFunction(()=>!handoffLoading);
 const open=async()=>{await page.locator('#handoff-notification-open').click();await ready();};
 const close=async()=>{await page.locator('#handoff-notification-dialog .dialog-heading .close-dialog').click();await page.waitForFunction(()=>!document.getElementById('handoff-notification-dialog').open&&handoffNotifyConfig===null);};
 const save=async()=>{await page.locator('#handoff-notify-save').click();await ready();await queueReady();};
 const visible=async(selector,name)=>{const locator=page.locator(selector);await locator.scrollIntoViewIfNeeded();const ok=await locator.evaluate(node=>{const r=node.getBoundingClientRect(),d=node.closest('dialog').getBoundingClientRect(),hit=document.elementFromPoint(r.left+r.width/2,r.top+r.height/2);return r.width>0&&r.height>0&&r.top>=Math.max(d.top,0)&&r.bottom<=Math.min(d.bottom,innerHeight)+1&&r.left>=0&&r.right<=innerWidth+1&&!!hit&&(hit===node||node.contains(hit));});check(ok,name);};
 try{
  await page.setViewportSize({width:1440,height:1020});await page.reload();await page.waitForFunction(()=>document.getElementById('selected-name').textContent.includes('同名业务群'));
  await page.locator('[data-view="handoffs"]').click();await queueReady();await open();
  check((await page.locator('#handoff-notify-group option').allTextContents()).every(text=>text.includes('@chatroom')),'same_name_source_groups_show_stable_ids');
  check((await page.locator('#handoff-notify-target option').allTextContents()).slice(1).every(text=>text.includes('notify-person-')),'same_name_private_recipients_show_stable_ids');
  check(await page.locator('#handoff-notify-target').inputValue()===''&&!await page.locator('#handoff-notify-enabled').isChecked()&&await page.locator('#handoff-notify-enabled').isDisabled(),'recipient_and_automatic_enable_are_never_inferred');
  await page.locator('#handoff-notify-target').selectOption(personB.id);check(!await page.locator('#handoff-notify-enabled').isChecked(),'selecting_recipient_does_not_enable_notification');await page.locator('#handoff-notify-enabled').check();await refresh();
  check(await page.locator('#handoff-notify-target').inputValue()===personB.id&&await page.locator('#handoff-notify-enabled').isChecked(),'ordinary_poll_preserves_configuration_draft');
  const example=await page.locator('#handoff-notify-example').innerText();check(example.includes(groupA.id)&&example.includes(personB.id)&&example.includes('销售部 · 张明')&&['发起人','时间','原因','待办编号','原消息','提醒不代表已领取或完成'].every(field=>example.includes(field)),'field_example_binds_group_label_and_recipient_identity');
  const policy=await page.locator('#handoff-notification-dialog').innerText();check(policy.includes('10 分钟')&&policy.includes('过期不补发')&&policy.includes('已开始处理的一条仍可能提交')&&policy.includes('结果未知不自动重试'),'expiry_inflight_and_unknown_boundaries_visible');
  await save();const firstWrite=requests.filter(row=>row.path==='/api/handoffs/notifications'&&row.body).at(-1).body;
  check(firstWrite.targetId===personB.id&&firstWrite.version===0&&firstWrite.routeVersion===1&&firstWrite.enabled,'explicit_save_binds_both_versions_and_exact_private_id');
  check(JSON.stringify(tasks[0])===JSON.stringify(originalTask)&&(await page.locator('#handoff-notify-message').innerText()).includes('不补发已有待办'),'enabling_does_not_backfill_or_modify_existing_task');
  await page.locator('#handoff-notify-group').selectOption(groupB.id);check(await page.locator('#handoff-notify-target').inputValue()===''&&!await page.locator('#handoff-notify-enabled').isChecked(),'same_name_second_group_does_not_inherit_recipient');
  await page.locator('#handoff-notify-target').selectOption(personA.id);await page.locator('#handoff-notify-enabled').check();await save();await page.locator('#handoff-notify-group').selectOption(groupA.id);
  check(await page.locator('#handoff-notify-target').inputValue()===personB.id&&await page.locator('#handoff-notify-enabled').isChecked(),'saved_groups_retain_separate_private_recipients');
  await visible('#handoff-notify-example','full_field_example_visible_on_desktop');await page.screenshot({path:'output/playwright/handoff-notification-desktop.png',fullPage:true});
  await page.setViewportSize({width:390,height:844});check(await page.locator('#handoff-notification-dialog').evaluate(node=>node.scrollWidth<=node.clientWidth+1),'configuration_has_no_mobile_horizontal_overflow');
  await visible('#handoff-notify-target','recipient_select_reachable_on_mobile');await visible('#handoff-notify-enabled','explicit_enable_reachable_on_mobile');await visible('#handoff-notify-example','full_field_example_visible_without_footer_cover_on_mobile');await page.screenshot({path:'output/playwright/handoff-notification-mobile.png',fullPage:true});await visible('#handoff-notify-save','save_button_reachable_on_mobile');await page.setViewportSize({width:1440,height:1020});
  await page.locator('#handoff-notify-target').selectOption(personA.id);check(!await page.locator('#handoff-notify-enabled').isChecked(),'recipient_change_requires_fresh_explicit_enable');await page.locator('#handoff-notify-enabled').check();forceConflict=true;await save();
  check((await page.locator('#handoff-notify-message').innerText()).includes('409')&&await page.locator('#handoff-notify-target').inputValue()===personA.id&&await page.locator('#handoff-notify-enabled').isChecked()&&await page.locator('#handoff-notify-save').isDisabled(),'route_conflict_preserves_draft_and_requires_explicit_reload');
  const reads=requests.filter(row=>row.path==='/api/handoffs/notifications'&&!row.body).length;await refresh();check(requests.filter(row=>row.path==='/api/handoffs/notifications'&&!row.body).length===reads&&await page.locator('#handoff-notify-target').inputValue()===personA.id,'conflict_draft_is_not_automatically_reloaded');
  await page.locator('#handoff-notify-reload').click();await ready();check(!await page.locator('#handoff-notify-enabled').isChecked()&&(await page.locator('#handoff-notify-owner').innerText()).includes('并发修改负责人')&&(await page.locator('#handoff-notify-current').innerText()).includes('负责人已变化'),'explicit_reload_exposes_changed_owner_and_disabled_policy');
  await page.locator('#handoff-notify-enabled').check();await save();await close();
  tasks.unshift(task('future-queued','queued'),task('future-unknown','unknown'));await page.locator('#handoff-refresh').click();await queueReady();
  check((await page.locator('#handoff-list').innerText()).includes('已分派 · 待领取')&&(await page.locator('#handoff-list').innerText()).includes('等待提交通知'),'new_notification_queue_does_not_claim_task');
  await open();await page.locator('#handoff-notify-enabled').uncheck();await save();
  check(tasks.find(row=>row.id==='future-queued').notification.status==='cancelled'&&tasks.find(row=>row.id==='future-unknown').notification.status==='unknown'&&(await page.locator('#handoff-notify-message').innerText()).includes('仍可能提交'),'disable_cancels_only_unattempted_notifications');
  await close();state.watchedGroups=state.watchedGroups.filter(id=>id!==personB.id);await refresh();await open();
  check(await page.locator('#handoff-notify-target').inputValue()===personB.id&&(await page.locator('#handoff-notify-target option:checked').innerText()).includes('已失效')&&await page.locator('#handoff-notify-enabled').isDisabled(),'removed_private_target_remains_visible_without_automatic_replacement');
  await save();check(requests.filter(row=>row.path==='/api/handoffs/notifications'&&row.body).at(-1).body.targetId===personB.id&&!configSets.get(source.id)[0].enabled,'disabled_config_can_preserve_unavailable_target_while_hook_offline');await close();
  state.watchedGroups.push(personB.id);await refresh();await open();
  const lateRead={started:deferred(),done:deferred()};readGate=lateRead;await page.evaluate(()=>{window.__oldNotifyRead=loadHandoffNotifications();});await lateRead.started.promise;await page.locator('#handoff-notify-group').selectOption(groupB.id);lateRead.done.resolve();await page.evaluate(()=>window.__oldNotifyRead);
  check(await page.locator('#handoff-notify-group').inputValue()===groupB.id&&await page.locator('#handoff-notify-target').inputValue()===personA.id,'late_reload_cannot_replace_new_group_selection');
  await close();

  const labels={unassigned:'未分派，未创建通知',not_configured:'未入通知队列',queued:'等待提交通知',cancelled:'通知已取消，未提交',expired:'通知已过期，不补发',blocked:'通知被阻止，未提交',unknown:'结果未知，不自动重试',submitted_unconfirmed:'已提交，收件端未确认',server_accepted:'服务器已接受，收件端未确认',local_record_observed:'观察到本机记录，收件端未确认',local_record_confirmed:'服务器回执匹配本机记录，收件端未确认'};
  for(const [status,label] of Object.entries(labels)){
   tasks[0].notification=notification(status);await page.evaluate(id=>openHandoffDetail(id),tasks[0].id);await page.waitForFunction(()=>!handoffDetailLoading&&handoffDetail!==null);
   const text=await page.locator('#handoff-notification-detail').innerText();check(text.includes(label)&&text.includes('不能证明负责人已收到')&&!text.includes('undefined'),'detail_distinguishes_'+status);
   if(status==='local_record_confirmed'){await page.setViewportSize({width:390,height:844});await visible('#handoff-notification-detail','full_notification_evidence_panel_visible_on_mobile');await page.screenshot({path:'output/playwright/handoff-notification-state-mobile.png',fullPage:true});await page.setViewportSize({width:1440,height:1020});}
   await page.locator('#handoff-dialog .dialog-heading .close-dialog').click();
  }
  tasks[0].notification=notification('queued');await page.evaluate(id=>openHandoffDetail(id),tasks[0].id);await page.waitForFunction(()=>!handoffDetailLoading&&handoffDetail!==null);await page.locator('#handoff-claim').click();await page.waitForFunction(()=>!handoffActionBusy&&handoffDetail.status==='in_progress');
  check((await page.locator('#handoff-notification-detail').innerText()).includes('通知已取消，未提交'),'explicit_claim_refreshes_cancelled_unattempted_notification');await page.locator('#handoff-dialog .dialog-heading .close-dialog').click();

  await open();await page.locator('#handoff-notify-target').selectOption(personA.id);await page.locator('#handoff-notify-enabled').check();const lateSave={started:deferred(),done:deferred()};writeGate=lateSave;await page.evaluate(()=>{window.__oldNotifySave=saveHandoffNotifications();});await lateSave.started.promise;
  check(await page.locator('#handoff-notify-group').isDisabled()&&await page.locator('#handoff-notify-target').isDisabled()&&await page.locator('#handoff-notify-reload').isDisabled(),'save_blocks_competing_configuration_actions');
  state.account='notify-account-b';state.runtime.source={...source,id:state.account};await refresh();await open();await page.locator('#handoff-notify-target').selectOption(personB.id);await page.locator('#handoff-notify-enabled').check();const newSave={started:deferred(),done:deferred()};writeGate=newSave;await page.evaluate(()=>{window.__newNotifySave=saveHandoffNotifications();});await newSave.started.promise;
  lateSave.done.resolve();await page.evaluate(()=>window.__oldNotifySave);check(await page.locator('#handoff-notify-target').inputValue()===personB.id&&await page.locator('#handoff-notify-save').isDisabled()&&(await page.locator('#handoff-notify-owner').innerText()).includes('新账号负责人'),'old_account_success_cannot_overwrite_or_unlock_new_save');newSave.done.resolve();await page.evaluate(()=>window.__newNotifySave);await ready();await close();
  await open();const lateFailure={started:deferred(),done:deferred(),fail:true};writeGate=lateFailure;await page.evaluate(()=>{window.__oldNotifyFailure=saveHandoffNotifications();});await lateFailure.started.promise;state.account=source.id;state.runtime.source={...source};await refresh();await open();lateFailure.done.resolve();await page.evaluate(()=>window.__oldNotifyFailure);
  check(!(await page.locator('#handoff-notify-message').innerText()).includes('旧账号合成保存失败')&&(await page.locator('#handoff-notify-owner').innerText()).includes('并发修改负责人'),'old_account_failure_cannot_pollute_new_configuration');
  const scopeRead={started:deferred(),done:deferred()};readGate=scopeRead;await page.evaluate(()=>{window.__scopeNotifyRead=loadHandoffNotifications();});await scopeRead.started.promise;state.watchedGroups=[groupA.id,personA.id];await refresh();scopeRead.done.resolve();await page.evaluate(()=>window.__scopeNotifyRead);
  check(!await page.locator('#handoff-notification-dialog').isVisible()&&await page.locator('#handoff-notify-target').inputValue()==='','read_scope_change_discards_late_recipient_response');
  state.runtime.capabilities.handoffNotifications=false;for(const row of tasks)delete row.notification;await refresh();await page.locator('#handoff-refresh').click();await queueReady();await page.locator('#handoff-list button').first().click();await page.waitForFunction(()=>!handoffDetailLoading&&handoffDetail!==null);
  check(await page.locator('#handoff-notification-open').isHidden()&&await page.locator('#handoff-notification-detail').isHidden()&&(await page.locator('#handoff-notice').innerText()).includes('未通知负责人'),'old_service_hides_notifications_and_accepts_legacy_task_dto');await page.locator('#handoff-dialog .dialog-heading .close-dialog').click();
  state.runtime={mode:'demo',platform:'Windows',capabilities:{canSend:true,handoffRouting:true,handoffNotifications:true}};state.connection={status:'logged_in'};await refresh();check(await page.locator('#handoff-notification-open').isHidden(),'demo_hides_notification_configuration');
  check(rule.enabled&&rule.mode==='handoff'&&rule.text==='保留的固定文本','notifications_and_task_actions_preserve_group_rule');
  check(!requests.some(row=>row.method==='POST'&&!['/api/select','/api/handoffs/notifications','/api/handoffs/action'].includes(row.path)),'no_hook_message_rule_or_schedule_mutation');
  check(errors.length===0,'no_browser_javascript_errors');return {checks,realBrowser:true,allApis:'synthetic',realWindowsReadOrSend:false};
 }finally{for(const gate of gates)gate.resolve();page.off('pageerror',onError);await page.unroute('**/api/**',handler);}
}
