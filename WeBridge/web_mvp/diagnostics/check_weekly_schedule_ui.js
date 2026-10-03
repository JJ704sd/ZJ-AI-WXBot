// playwright-cli run-code --filename web_mvp/diagnostics/check_weekly_schedule_ui.js
// All APIs are synthetic. This does not read WeChat or invoke native sending.
async (page) => {
 const checks=[],errors=[],requests=[];
 const check=(condition,name)=>{if(!condition)throw Error(name);checks.push(name);};
 const source={id:'weekly-fixture-source',revision:'r1',status:'snapshot_ready',createdAt:'2026-10-03T01:00:00Z',updatePolicy:'on_change'};
 const group={id:'weekly-fixture@chatroom',name:'周报与业务提醒 · 合成群'};
 const priorRun={status:'unknown',createdAt:1790989211,label:'结果未知，不重试'};
 const paused={id:'paused-weekly',targetId:group.id,targetName:group.name,text:'既有周五业务提醒',mode:'weekly',weekdays:[5],clock:'17:30',state:'paused',enabled:false,nextRun:null,runs:[priorRun],last_result:priorRun.label};
 const state={account:source.id,selfId:'fixture-self',name:'合成账号',csrfToken:'synthetic',connection:{status:'snapshot_ready'},groups:[group],selected:group.id,watchedGroups:[group.id],jobs:[paused],outbox:[],runtime:{mode:'database',connected:true,platform:'Windows',source,capabilities:{read:true,canSend:true,hookSendInterface:true,groupSend:true,automaticReplies:true,scheduledSend:true,mentions:true,media:false}}};
 const rule={enabled:false,text:'既有自动回复话术',cooldown:30,mode:'reply'};
 let firstCreate=true,releaseCreate,createStarted;
 const createStart=new Promise(resolve=>createStarted=resolve);
 const handler=async route=>{
  const request=route.request(),path=request.url().split('?')[0].replace(/^https?:\/\/[^/]+/,''),body=request.method()==='POST'?request.postDataJSON():null;
  requests.push({path,method:request.method(),body});
  if(path==='/api/state')return route.fulfill({json:state});
  if(path==='/api/database')return route.fulfill({json:{mode:'database',configured:true,busy:false,config:{sourceRoot:'D:\\Synthetic\\db',autoRefresh:true},source}});
  if(path==='/api/select')return route.fulfill({json:{ok:true}});
  if(path==='/api/group'||path==='/api/messages')return route.fulfill({json:{watching:true,members:[],messages:[],outbox:[],reply:rule}});
  if(path==='/api/windows/hook/status')return route.fulfill({json:{available:false,status:'disabled',issue:'合成测试未连接 Hook'}});
  if(path==='/api/jobs'){
   if(firstCreate){firstCreate=false;createStarted();await new Promise(resolve=>releaseCreate=resolve);return route.fulfill({status:503,json:{error:'合成提交失败，请重试'}});}
   const nextRun=Date.parse((body.mode==='once'?body.at:'2026-10-04T'+body.clock)+':00+08:00')/1000;
   const job={id:'new-'+state.jobs.length,group_id:group.id,targetName:group.name,text:body.text,mode:body.mode,weekdays:body.mode==='weekly'?body.weekdays:body.mode==='daily'?[1,2,3,4,5,6,7]:[],clock:body.clock,at:body.at,state:'active',enabled:true,nextRun,runs:[],last_result:''};
   state.jobs.push(job);return route.fulfill({json:job});
  }
  if(path==='/api/jobs/resume'){paused.enabled=true;paused.state='active';paused.nextRun=Date.parse('2026-10-09T17:30:00+08:00')/1000;return route.fulfill({json:paused});}
  return route.fulfill({status:400,json:{error:'Synthetic test blocks this API.'}});
 };
 const onError=error=>errors.push(error.message);page.on('pageerror',onError);await page.route('**/api/**',handler);
 try{
  await page.setViewportSize({width:1440,height:1000});await page.reload();
  await page.waitForFunction(()=>document.getElementById('selected-name').textContent.includes('周报与业务提醒')&&!document.getElementById('save-reply').disabled&&document.getElementById('reply-text').value==='既有自动回复话术');
  await page.locator('#message-text').fill('保留的手动消息草稿');await page.locator('#reply-tab').click();
  check(await page.locator('#reply-text').inputValue()==='既有自动回复话术','saved_automatic_template_loaded');
  await page.locator('#reply-text').fill('尚未保存的回复调整');
  await page.locator('[data-view="schedules"]').click();
  check((await page.locator('#schedule-list').innerText()).includes('周五 · 北京时间'),'weekly_list_displays_selected_day_and_timezone');
  const oldRow=page.locator('.schedule-row').filter({hasText:'既有周五业务提醒'});
  await oldRow.getByRole('button',{name:'恢复',exact:true}).click();
  await page.waitForFunction(()=>document.getElementById('schedule-list').textContent.includes('下次'));
  check(requests.some(row=>row.path==='/api/jobs/resume'&&row.body.id===paused.id),'paused_weekly_with_unknown_history_can_resume');
  check((await oldRow.innerText()).includes('结果未知，不重试'),'resume_retains_historical_unknown_result');
  await page.locator('#new-schedule').click();
  check(await page.locator('#schedule-weekdays-field').isHidden()&&await page.locator('#schedule-at-field').isVisible(),'once_default_hides_weekdays');
  await page.locator('#schedule-mode').selectOption('weekly');
  check(await page.locator('#schedule-weekdays-field').isVisible()&&await page.locator('#schedule-at-field').isHidden(),'weekly_mode_displays_weekday_selection');
  check(JSON.stringify(await page.locator('#schedule-weekdays input:checked').evaluateAll(nodes=>nodes.map(node=>Number(node.value))))==='[1,2,3,4,5]','new_weekly_default_explicitly_checks_monday_through_friday');
  check((await page.locator('#schedule-policy').innerText()).includes('法定节假日不自动调整'),'weekly_policy_explains_calendar_semantics');
  await page.locator('#schedule-text').fill('周一和周日的业务提醒');await page.locator('#schedule-clock').fill('10:30');
  for(const checkbox of await page.locator('#schedule-weekdays input').all())await checkbox.uncheck();
  await page.locator('#create-schedule').click();
  check((await page.locator('#toast').innerText()).includes('至少选择')&&!requests.some(row=>row.path==='/api/jobs'),'empty_weekday_selection_blocks_creation');
  await page.locator('#schedule-weekdays input[value="1"]').check();await page.locator('#schedule-weekdays input[value="7"]').check();
  await page.evaluate(()=>poll());
  check(await page.locator('#schedule-text').inputValue()==='周一和周日的业务提醒'&&JSON.stringify(await page.locator('#schedule-weekdays input:checked').evaluateAll(nodes=>nodes.map(node=>Number(node.value))))==='[1,7]','poll_preserves_weekly_dialog_draft');
  await page.screenshot({path:'output/playwright/weekly-schedule-desktop.png',fullPage:true});
  await page.setViewportSize({width:390,height:844});
  check(await page.locator('#schedule-dialog').evaluate(node=>node.scrollWidth<=node.clientWidth+1),'weekly_dialog_has_no_mobile_horizontal_overflow');
  await page.screenshot({path:'output/playwright/weekly-schedule-mobile.png',fullPage:true});await page.setViewportSize({width:1440,height:1000});
  await page.locator('#create-schedule').click();await createStart;
  await page.evaluate(()=>document.getElementById('schedule-form').requestSubmit());
  check(requests.filter(row=>row.path==='/api/jobs').length===1&&await page.locator('#create-schedule').isDisabled(),'pending_create_deduplicates_submission');
  releaseCreate();await page.waitForFunction(()=>!document.getElementById('create-schedule').disabled&&document.getElementById('toast').textContent.includes('合成提交失败'));
  check(await page.locator('#schedule-dialog').isVisible(),'failed_creation_retains_editable_dialog');
  await page.locator('#create-schedule').click();await page.waitForFunction(()=>!document.getElementById('schedule-dialog').open&&document.getElementById('schedule-list').textContent.includes('周一和周日的业务提醒'));
  const creates=requests.filter(row=>row.path==='/api/jobs');
  check(creates.length===2&&creates[0].body.requestId===creates[1].body.requestId,'retry_preserves_request_id');
  check(creates[1].body.mode==='weekly'&&JSON.stringify(creates[1].body.weekdays)==='[1,7]'&&creates[1].body.clock==='10:30','weekly_request_contains_exact_selected_iso_days');
  check((await page.locator('.schedule-row').filter({hasText:'周一和周日的业务提醒'}).innerText()).includes('周一、周日 · 北京时间'),'created_weekly_summary_matches_selection');
  check((await page.locator('.schedule-row').filter({hasText:'周一和周日的业务提醒'}).innerText()).includes('10/04 10:30'),'weekly_next_run_displays_beijing_time');
  await page.locator('[data-view="workspace"]').click();await page.locator('#send-tab').click();
  check(await page.locator('#message-text').inputValue()==='保留的手动消息草稿','schedule_creation_preserves_manual_message_draft');
  await page.locator('#reply-tab').click();check(await page.locator('#reply-text').inputValue()==='尚未保存的回复调整','schedule_creation_preserves_unsaved_reply_draft');
  check(rule.text==='既有自动回复话术'&&!requests.some(row=>row.path==='/api/reply'),'schedule_creation_preserves_saved_rule');
  await page.locator('[data-view="schedules"]').click();
  for(const mode of ['daily','once']){
   await page.locator('#new-schedule').click();await page.locator('#schedule-mode').selectOption(mode);await page.locator('#schedule-text').fill(mode+' 合成兼容任务');
   check(await page.locator('#schedule-weekdays-field').isHidden(),mode+'_hides_weekdays');
   await page.locator('#create-schedule').click();await page.waitForFunction(()=>!document.getElementById('schedule-dialog').open);
   const request=requests.filter(row=>row.path==='/api/jobs').at(-1).body;check(request.mode===mode&&!Object.hasOwn(request,'weekdays'),mode+'_omits_weekdays_from_request');
  }
  await page.setViewportSize({width:390,height:844});check(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth+1),'weekly_list_has_no_mobile_horizontal_overflow');
  await page.screenshot({path:'output/playwright/weekly-schedules-mobile.png',fullPage:true});
  state.runtime={mode:'demo',platform:'Windows',capabilities:{canSend:true}};state.connection={status:'logged_in'};state.jobs=[];
  await page.reload();await page.waitForFunction(()=>!document.getElementById('new-schedule').disabled);await page.locator('[data-view="schedules"]').click();await page.locator('#new-schedule').click();
  check(await page.locator('#schedule-mode-field').isHidden()&&await page.locator('#schedule-weekdays-field').isHidden(),'non_database_schedule_does_not_offer_weekly');
  await page.locator('#schedule-dialog .dialog-heading .close-dialog').click();
  check(!requests.some(row=>row.method==='POST'&&!['/api/select','/api/jobs','/api/jobs/resume'].includes(row.path)),'no_hook_or_message_sending_requests');
  check(errors.length===0,'no_browser_javascript_errors');
  return {checks,realBrowser:true,allApis:'synthetic',realWindowsReadOrSend:false};
 }finally{if(releaseCreate)releaseCreate();page.off('pageerror',onError);await page.unroute('**/api/**',handler);}
}
