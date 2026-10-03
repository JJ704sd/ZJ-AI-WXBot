// playwright-cli run-code --filename web_mvp/diagnostics/check_schedule_window_ui.js
// All APIs are synthetic. Never reads WeChat or invokes a native transport.
async (page) => {
 const checks=[],errors=[],requests=[],identities=new Map();
 const check=(condition,name)=>{if(!condition)throw Error(name);checks.push(name);};
 const source={id:'window-fixture-source',revision:'r1',status:'snapshot_ready',createdAt:'2026-10-03T01:00:00Z',updatePolicy:'on_change'};
 const group={id:'window-fixture@chatroom',name:'跨午夜业务提醒 · 合成群'};
 const job=(id,windowMinutes=30)=>({id,group_id:group.id,targetId:group.id,targetName:group.name,text:'合成窗口任务 '+id,mentions:[],mode:'daily',clock:'23:50',weekdays:[1,2,3,4,5,6,7],windowMinutes,state:'active',enabled:true,nextRun:Date.parse('2026-10-03T23:50:00+08:00')/1000,runs:[],last_result:''});
 const state={account:source.id,selfId:'fixture-self',name:'合成窗口账号',csrfToken:'synthetic',connection:{status:'snapshot_ready'},groups:[group],selected:group.id,watchedGroups:[group.id],jobs:[job('cross-midnight'),job('default-window',2)],outbox:[],runtime:{mode:'database',connected:true,platform:'Windows',source,capabilities:{read:true,canSend:true,hookSendInterface:true,groupSend:true,automaticReplies:true,scheduledSend:true,scheduleWindows:true,mentions:true,media:false}}};
 const rule={enabled:false,text:'保留的回复配置',cooldown:30,mode:'reply'};
 let firstCreate=true;
 const creates=()=>requests.filter(row=>row.path==='/api/jobs');
 const handler=async route=>{
  const request=route.request(),path=request.url().split('?')[0].replace(/^https?:\/\/[^/]+/,''),body=request.method()==='POST'?request.postDataJSON():null;
  requests.push({path,method:request.method(),body});
  if(path==='/api/state')return route.fulfill({json:state});
  if(path==='/api/database')return route.fulfill({json:{mode:'database',configured:true,busy:false,config:{sourceRoot:'D:\\Synthetic\\db',autoRefresh:true},source}});
  if(path==='/api/select')return route.fulfill({json:{ok:true}});
  if(path==='/api/group'||path==='/api/messages')return route.fulfill({json:{watching:true,members:[],messages:[],outbox:[],reply:rule}});
  if(path==='/api/windows/hook/status')return route.fulfill({json:{available:false,status:'disabled',issue:'合成测试未连接 Hook'}});
  if(path==='/api/jobs'){
   if(body.requestId){
    const serialized=JSON.stringify(body);
    if(identities.has(body.requestId)&&identities.get(body.requestId)!==serialized)return route.fulfill({status:409,json:{error:'相同请求标识的内容不同；请关闭后重新新建任务。'}});
    identities.set(body.requestId,serialized);
   }
   if(firstCreate){firstCreate=false;return route.fulfill({status:503,json:{error:'合成提交失败，请核对后重试'}});}
   const created={...job('created-'+state.jobs.length,body.windowMinutes===undefined?2:body.windowMinutes),text:body.text,mode:body.mode||'daily',clock:body.clock,at:body.at,weekdays:body.mode==='weekly'?body.weekdays:[1,2,3,4,5,6,7]};
   state.jobs.push(created);return route.fulfill({json:created});
  }
  return route.fulfill({status:400,json:{error:'Synthetic test blocks this API.'}});
 };
 const onError=error=>errors.push(error.message);page.on('pageerror',onError);await page.route('**/api/**',handler);
 const refresh=async()=>{await page.waitForFunction(()=>!pollBusy);await page.evaluate(()=>poll());};
 const submitSettled=()=>page.waitForFunction(()=>!scheduleBusy);
 try{
  await page.setViewportSize({width:1440,height:1080});await page.reload();
  await page.waitForFunction(()=>document.getElementById('selected-name').textContent.includes('跨午夜业务提醒')&&!document.getElementById('new-schedule').disabled);
  await page.locator('#message-text').fill('保留的手动草稿');await page.locator('[data-view="schedules"]').click();
  const cross=page.locator('.schedule-row').filter({hasText:'合成窗口任务 cross-midnight'});
  check((await cross.innerText()).includes('计划时间起 30 分钟'),'configured_window_shown_in_card');
  check((await cross.innerText()).includes('窗口截止 10/04 00:20'),'cross_midnight_deadline_displays_next_beijing_date');
  check((await page.locator('#schedule-list-policy').innerText()).includes('各任务的执行窗口')&&!(await page.locator('#schedule-list-policy').innerText()).includes('超过 2 分钟'),'custom_capability_removes_fixed_two_minute_heading');
  await page.screenshot({path:'output/playwright/schedule-window-list-desktop.png',fullPage:true});
  await page.locator('#new-schedule').click();
  check(await page.locator('#schedule-window-field').isVisible()&&await page.locator('#schedule-window-minutes').inputValue()==='2','new_window_defaults_to_two');
  check(await page.locator('#schedule-window-minutes').evaluate(node=>node.required&&node.min==='1'&&node.max==='1439'&&node.step==='1'),'integer_input_has_exact_window_bounds');
  check((await page.locator('#schedule-policy').innerText()).includes('跨午夜')&&(await page.locator('#schedule-policy').innerText()).includes('下一期正常')&&(await page.locator('#schedule-policy').innerText()).includes('本机提交前')&&(await page.locator('#schedule-policy').innerText()).includes('不能撤回')&&(await page.locator('#schedule-policy').innerText()).includes('不保证实际送达'),'policy_explains_window_repetition_and_submission_boundary');
  await page.locator('#schedule-text').fill('配置 30 分钟执行窗口');
  const originalId=await page.evaluate(()=>scheduleRequestId);
  for(const value of ['', '0','1440','1.5']){await page.locator('#schedule-window-minutes').fill(value);await page.locator('#create-schedule').click();check(creates().length===0,'native_validation_blocks_'+(value||'blank'));}
  await page.evaluate(()=>document.getElementById('schedule-form').onsubmit({preventDefault(){}}));
  check(creates().length===0&&(await page.locator('#toast').innerText()).includes('整数分钟')&&await page.evaluate(()=>scheduleRequestId)===originalId,'submit_boundary_validates_without_replacing_request_identity');
  await page.locator('#schedule-window-minutes').fill('30');await page.locator('#schedule-mode').selectOption('weekly');
  check(await page.locator('#schedule-window-minutes').inputValue()==='30','mode_change_preserves_window_draft');
  await refresh();check(await page.locator('#schedule-window-minutes').inputValue()==='30'&&await page.locator('#schedule-text').inputValue()==='配置 30 分钟执行窗口','same_account_poll_preserves_form_draft');
  await page.screenshot({path:'output/playwright/schedule-window-form-desktop.png',fullPage:true});
  await page.setViewportSize({width:390,height:844});
  check(await page.locator('#schedule-dialog').evaluate(node=>node.scrollWidth<=node.clientWidth+1),'window_dialog_has_no_mobile_horizontal_overflow');
  await page.screenshot({path:'output/playwright/schedule-window-form-mobile.png',fullPage:true});
  await page.locator('#create-schedule').scrollIntoViewIfNeeded();
  check(await page.locator('#create-schedule').evaluate(node=>{const rect=node.getBoundingClientRect();return rect.top>=0&&rect.bottom<=innerHeight;}),'mobile_dialog_can_scroll_to_create_action');
  await page.screenshot({path:'output/playwright/schedule-window-form-mobile-actions.png',fullPage:true});await page.setViewportSize({width:1440,height:1080});
  await page.locator('#create-schedule').click();await submitSettled();
  check(creates().length===1&&creates()[0].body.windowMinutes===30&&creates()[0].body.requestId===originalId,'window_payload_is_integer_and_preserves_request_id');
  check(await page.locator('#schedule-dialog').isVisible()&&await page.locator('#schedule-window-minutes').inputValue()==='30'&&(await page.locator('#toast').innerText()).includes('合成提交失败'),'failed_submit_preserves_window_draft');
  await page.locator('#schedule-window-minutes').fill('45');await page.locator('#create-schedule').click();await submitSettled();
  check(creates().length===2&&creates()[1].body.requestId===originalId&&(await page.locator('#toast').innerText()).includes('重新新建'),'editing_failed_request_is_rejected_without_silent_new_identity');
  await page.locator('#schedule-window-minutes').fill('30');await page.locator('#create-schedule').click();await submitSettled();
  check(!await page.locator('#schedule-dialog').isVisible()&&creates()[2].body.requestId===originalId,'unchanged_retry_can_complete_with_original_identity');
  check((await page.locator('.schedule-row').filter({hasText:'配置 30 分钟执行窗口'}).innerText()).includes('计划时间起 30 分钟'),'created_card_uses_returned_window');
  await page.locator('#new-schedule').click();
  check(await page.locator('#schedule-window-minutes').inputValue()==='2'&&await page.evaluate(()=>scheduleRequestId)!==originalId,'new_dialog_resets_window_and_renews_request_identity');
  await page.locator('#schedule-text').fill('保留能力切换草稿');await page.locator('#schedule-window-minutes').fill('90');
  state.runtime.capabilities.scheduleWindows=false;await refresh();
  check(await page.locator('#schedule-window-field').isHidden()&&await page.locator('#schedule-window-minutes').evaluate(node=>!node.required&&node.disabled&&node.value==='90'),'capability_removal_hides_and_disables_input_preserving_draft');
  check((await page.locator('#schedule-policy').innerText()).includes('2 分钟')&&(await page.locator('#schedule-list-policy').innerText()).includes('2 分钟')&&(await cross.innerText()).includes('计划时间起 2 分钟'),'old_service_policy_and_cards_use_fixed_two_minutes');
  state.runtime.capabilities.scheduleWindows=true;await refresh();
  check(await page.locator('#schedule-window-field').isVisible()&&await page.locator('#schedule-window-minutes').inputValue()==='90','capability_return_restores_same_draft');
  state.runtime.capabilities.scheduleWindows=false;await refresh();await page.locator('#create-schedule').click();await submitSettled();
  check(!Object.hasOwn(creates().at(-1).body,'windowMinutes')&&!await page.locator('#schedule-dialog').isVisible(),'old_windows_service_receives_no_window_field');
  await page.locator('[data-view="workspace"]').click();check(await page.locator('#message-text').inputValue()==='保留的手动草稿','window_creation_preserves_manual_message_draft');
  state.runtime={mode:'demo',platform:'Windows',capabilities:{canSend:true,scheduleWindows:true}};state.connection={status:'logged_in'};state.jobs=[];await refresh();
  await page.locator('[data-view="schedules"]').click();await page.locator('#new-schedule').click();await page.locator('#schedule-text').fill('Demo compatibility fixture');
  check(await page.locator('#schedule-window-field').isHidden()&&(await page.locator('#schedule-policy').innerText()).includes('2 分钟'),'non_database_ignores_window_capability');
  await page.locator('#create-schedule').click();await submitSettled();
  check(!Object.hasOwn(creates().at(-1).body,'windowMinutes')&&!Object.hasOwn(creates().at(-1).body,'mode'),'demo_creation_preserves_legacy_payload');
  check(!requests.some(row=>row.method==='POST'&&!['/api/select','/api/jobs'].includes(row.path)),'no_hook_message_reply_or_handoff_mutation');
  check(errors.length===0,'no_browser_javascript_errors');
  return {checks,realBrowser:true,allApis:'synthetic',realWindowsReadOrSend:false};
 }finally{page.off('pageerror',onError);await page.unroute('**/api/**',handler);}
}
