// playwright-cli run-code --filename web_mvp/diagnostics/check_schedule_pause_ui.js
// All APIs are synthetic; no WeChat database, native Hook, or real message is used.
async (page) => {
 const checks=[],errors=[],requests=[],plans=[],held=[];
 const check=(condition,name)=>{if(!condition)throw Error(name);checks.push(name);};
 const deferred=()=>{let resolve;const promise=new Promise(done=>resolve=done);return {promise,resolve};};
 const groupA={id:'pause-a@chatroom',name:'每日业务提醒 · 合成群'},groupB={id:'pause-b@chatroom',name:'已取消读取的业务群 · 合成'};
 const job=(id,group,enabled=true)=>({id,group_id:group.id,targetId:group.id,targetName:group.name,text:'业务提醒 '+id,mode:'daily',clock:'09:00',weekdays:[1,2,3,4,5,6,7],state:enabled?'active':'paused',enabled,nextRun:enabled?1791075600:null,runs:[],last_result:''});
 const makeState=(account,jobs)=>({account,selfId:'fixture-self',name:'合成账号 '+account,csrfToken:'synthetic',connection:{status:'snapshot_ready'},groups:[groupA],selected:groupA.id,watchedGroups:[groupA.id],jobs,outbox:[],runtime:{mode:'database',connected:true,platform:'Windows',source:{id:account,revision:'r1',status:'snapshot_ready',createdAt:'2026-10-03T01:00:00Z',updatePolicy:'on_change'},capabilities:{read:true,canSend:true,hookSendInterface:true,groupSend:true,automaticReplies:true,scheduledSend:true,mentions:true,media:false}}});
 let state=makeState('pause-fixture-a',[job('A1',groupA),job('A2',groupA),job('B1',groupB),job('B0',groupB,false)]),stateHold=null;
 const accounts=new Map([[state.account,state]]),rule={enabled:false,text:'保留的回复配置',cooldown:30,mode:'reply'};
 const plan=(outcome='success',hold=false)=>{const entry={outcome,hold,started:deferred(),gate:deferred()};plans.push(entry);held.push(entry);return entry;};
 const countPause=()=>requests.filter(row=>row.path==='/api/jobs/pause-all').length;
 const handler=async route=>{
  const request=route.request(),path=request.url().split('?')[0].replace(/^https?:\/\/[^/]+/,''),body=request.method()==='POST'?request.postDataJSON():null;
  requests.push({path,method:request.method(),body});
  if(path==='/api/state'){
   const snapshot=JSON.parse(JSON.stringify(state)),entry=stateHold;stateHold=null;
   if(entry){entry.started.resolve();await entry.gate.promise;}
   return route.fulfill({json:snapshot});
  }
  if(path==='/api/database')return route.fulfill({json:{mode:'database',configured:true,busy:false,config:{sourceRoot:'D:\\Synthetic\\db',autoRefresh:true},source:state.runtime.source}});
  if(path==='/api/select')return route.fulfill({json:{ok:true}});
  if(path==='/api/group'||path==='/api/messages')return route.fulfill({json:{watching:true,members:[],messages:[],outbox:[],reply:rule}});
  if(path==='/api/windows/hook/status')return route.fulfill({json:{available:false,status:'disabled',issue:'合成测试未连接 Hook'}});
  if(path==='/api/jobs/pause-all'){
   const entry=plans.shift();if(!entry)throw Error('Unexpected pause request: '+JSON.stringify(body));
   const owner=accounts.get(body.account);entry.started.resolve(body);if(entry.hold)await entry.gate.promise;
   if(entry.outcome==='failure')return route.fulfill({status:503,json:{error:'合成连接中断'}});
   const matching=owner.jobs.filter(row=>row.enabled&&(!body.groupId||row.group_id===body.groupId));
   owner.jobs=owner.jobs.map(row=>matching.includes(row)?{...row,enabled:false,state:'paused',nextRun:null}:row);
   return route.fulfill({json:{pausedCount:entry.outcome==='zero'?0:matching.length,jobs:owner.jobs}});
  }
  if(path==='/api/jobs/pause'){
   const entry=plans.shift();if(!entry||entry.outcome!=='row')throw Error('Unexpected row action');
   entry.started.resolve(body);if(entry.hold)await entry.gate.promise;
   const owner=accounts.get(body.account),row=owner.jobs.find(item=>item.id===body.id);row.enabled=false;row.state='paused';row.nextRun=null;return route.fulfill({json:row});
  }
  if(path==='/api/jobs'){
   const entry=plans.shift();if(!entry||entry.outcome!=='create')throw Error('Unexpected create');
   entry.started.resolve(body);if(entry.hold)await entry.gate.promise;
   return route.fulfill({status:503,json:{error:'合成创建失败，保留草稿'}});
  }
  return route.fulfill({status:400,json:{error:'Synthetic test blocks this API.'}});
 };
 const onError=error=>errors.push(error.message);page.on('pageerror',onError);await page.route('**/api/**',handler);
 const refresh=async()=>{await page.waitForFunction(()=>!pollBusy);await page.evaluate(()=>poll());};
 const settled=async()=>page.waitForFunction(()=>schedulePauseRequest===null);
 const resetJobs=async jobs=>{state.jobs=jobs;await refresh();};
 const switchAccount=async(account,jobs)=>{state=makeState(account,jobs);accounts.set(account,state);await refresh();};
 try{
  await page.setViewportSize({width:1440,height:1050});await page.reload();
  await page.waitForFunction(()=>document.getElementById('selected-name').textContent.includes('每日业务提醒')&&!document.getElementById('new-schedule').disabled);
  await page.locator('[data-view="schedules"]').click();
  check(await page.locator('#schedule-pause-controls').isVisible(),'database_pause_controls_visible');
  check((await page.locator('#schedule-group-filter option').allTextContents()).includes(groupB.name),'saved_unwatched_conversation_missing_from_source_is_selectable');
  check((await page.locator('#schedule-pause-scope').innerText()).includes('3 个'),'initial_all_enabled_count');
  check((await page.locator('.schedule-pause-note').innerText()).includes('自动回复和人工待办独立')&&(await page.locator('.schedule-pause-note').innerText()).includes('已开始处理'),'scope_and_inflight_limit_explained');
  await page.locator('#schedule-group-filter').selectOption(groupA.id);
  check(await page.locator('.schedule-row').count()===2,'conversation_filter_limits_displayed_rows');
  await page.locator('#schedule-search').fill('missing_keyword');await page.locator('#schedule-filter').selectOption('inactive');
  check(await page.locator('.schedule-row').count()===0&&(await page.locator('#schedule-pause-scope').innerText()).includes('2 个'),'search_and_state_do_not_shrink_pause_scope');
  const scoped=plan('success');await page.locator('#schedule-pause-all').click();const scopedBody=await scoped.started.promise;await settled();
  check(scopedBody.account===state.account&&scopedBody.groupId===groupA.id&&Object.keys(scopedBody).length===2,'conversation_pause_posts_only_account_and_group');
  check((await page.locator('#schedule-pause-feedback').innerText()).includes('本次暂停 2 个'),'actual_scoped_pause_count_displayed');
  check(state.jobs.filter(row=>row.group_id===groupA.id).every(row=>!row.enabled)&&state.jobs.find(row=>row.id==='B1').enabled,'scoped_pause_preserves_other_conversation');
  await page.locator('#schedule-search').fill('');await page.locator('#schedule-filter').selectOption('all');await page.locator('#schedule-group-filter').selectOption('');
  check(await page.locator('.schedule-row').count()===4&&(await page.locator('#schedule-pause-all').innerText())==='暂停全部定时任务','all_conversation_view_and_label');
  await page.screenshot({path:'output/playwright/schedule-pause-desktop.png',fullPage:true});
  await page.setViewportSize({width:390,height:844});
  check(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth+1),'pause_controls_no_mobile_horizontal_overflow');
  await page.screenshot({path:'output/playwright/schedule-pause-mobile.png',fullPage:true});await page.setViewportSize({width:1440,height:1050});

  const all=plan('success',true);await page.locator('#schedule-pause-all').click();const allBody=await all.started.promise;
  check(allBody.groupId==='','all_pause_uses_empty_group');
  check(await page.locator('#schedule-pause-all').isDisabled()&&await page.locator('#schedule-group-filter').isDisabled(),'pending_pause_disables_scope_and_duplicate_request');
  check(await page.locator('#new-schedule').isDisabled()&&await page.locator('#schedule-from-message').isDisabled()&&await page.locator('#create-schedule').isDisabled(),'pending_pause_disables_creation_entrypoints');
  check(await page.locator('.schedule-actions button').evaluateAll(nodes=>nodes.every(node=>node.disabled)),'pending_pause_disables_all_row_actions');
  const beforeGuard=requests.length;
  await page.evaluate(async()=>{await pauseSchedules();await document.querySelector('.schedule-actions button').onclick();await document.getElementById('schedule-form').onsubmit({preventDefault(){}});openSchedule();});
  check(requests.length===beforeGuard&&!await page.locator('#schedule-dialog').isVisible(),'programmatic_competing_actions_are_blocked');
  all.gate.resolve();await settled();
  check(state.jobs.every(row=>!row.enabled)&&(await page.locator('#schedule-pause-feedback').innerText()).includes('本次暂停 1 个'),'all_pause_applies_full_jobs_result');

  await resetJobs([job('B-offline',groupB)]);state.runtime.connected=false;state.runtime.capabilities.read=false;state.runtime.source.status='snapshot_error';state.connection.status='snapshot_error';await refresh();
  check(await page.locator('#new-schedule').isDisabled()&&!await page.locator('#schedule-pause-all').isDisabled(),'offline_source_blocks_creation_but_allows_pause');
  await page.locator('#schedule-group-filter').selectOption(groupB.id);const offline=plan('success');await page.locator('#schedule-pause-all').click();await offline.started.promise;await settled();
  check(!state.jobs[0].enabled&&(await page.locator('#schedule-pause-feedback').innerText()).includes('本次暂停 1 个'),'offline_unwatched_conversation_can_pause');
  state.runtime.connected=true;state.runtime.capabilities.read=true;state.runtime.source.status='snapshot_ready';state.connection.status='snapshot_ready';
  await resetJobs([job('retry',groupA)]);await page.locator('#schedule-group-filter').selectOption('');
  const failure=plan('failure');await page.locator('#schedule-pause-all').click();await failure.started.promise;await settled();
  check((await page.locator('#schedule-pause-feedback').innerText()).includes('未确认暂停结果，请刷新核对'),'failure_explains_unconfirmed_result');
  const countAfterFailure=countPause();await refresh();await refresh();
  check(countPause()===countAfterFailure&&!await page.locator('#schedule-pause-all').isDisabled(),'poll_does_not_retry_failed_pause_and_explicit_retry_available');
  const zero=plan('zero');await page.locator('#schedule-pause-all').click();await zero.started.promise;await settled();
  check((await page.locator('#schedule-pause-feedback').innerText()).includes('本次暂停 0 个')&&await page.locator('#schedule-pause-all').isDisabled(),'zero_pause_result_is_success_and_applies_jobs');

  await resetJobs([job('stale-poll',groupA)]);await page.waitForFunction(()=>!pollBusy);
  const oldState={started:deferred(),gate:deferred()};held.push(oldState);stateHold=oldState;
  await page.evaluate(()=>{window.__oldStatePoll=poll();});await oldState.started.promise;
  const pauseDuringPoll=plan('success');await page.locator('#schedule-pause-all').click();await pauseDuringPoll.started.promise;await settled();
  oldState.gate.resolve();await page.evaluate(()=>window.__oldStatePoll);
  check((await page.locator('#active-jobs').innerText())==='0'&&(await page.locator('.schedule-row .status-chip').innerText())==='已暂停','older_poll_does_not_restore_enabled_jobs_after_pause');
  await resetJobs([job('fresh-poll',groupA)]);
  check((await page.locator('#active-jobs').innerText())==='1'&&(await page.locator('#schedule-list').innerText()).includes('fresh-poll'),'subsequent_fresh_poll_still_updates_jobs');

  await resetJobs([job('row-pending',groupA)]);const row=plan('row',true);
  await page.locator('.schedule-row').getByRole('button',{name:'暂停',exact:true}).click();await row.started.promise;
  const beforeRowPause=countPause();await page.evaluate(()=>pauseSchedules());
  check(await page.locator('#schedule-pause-all').isDisabled()&&countPause()===beforeRowPause,'existing_row_request_blocks_bulk_pause');
  row.gate.resolve();await page.waitForFunction(()=>scheduleActionsBusy.size===0);
  await resetJobs([job('create-pending',groupA)]);await page.locator('#new-schedule').click();await page.locator('#schedule-text').fill('合成待创建任务');
  const create=plan('create',true);await page.locator('#create-schedule').click();await create.started.promise;
  const beforeCreatePause=countPause();await page.evaluate(()=>pauseSchedules());
  check(await page.locator('#schedule-pause-all').isDisabled()&&countPause()===beforeCreatePause,'existing_create_request_blocks_bulk_pause');
  create.gate.resolve();await page.waitForFunction(()=>!scheduleBusy);await page.locator('#schedule-dialog .dialog-heading .close-dialog').click();

  for(const outcome of ['success','failure']){
   await switchAccount('old-'+outcome,[job('old-job-'+outcome,groupA)]);
   const old=plan(outcome,true);await page.evaluate(()=>{window.__oldPause=document.getElementById('schedule-pause-all').onclick();});await old.started.promise;
   await switchAccount('new-'+outcome,[job('new-job-'+outcome,groupB)]);
   check(await page.locator('#schedule-group-filter').inputValue()===''&&!await page.locator('#schedule-pause-all').isDisabled(),'account_switch_resets_pause_scope_'+outcome);
   const current=plan('success',true);await page.locator('#schedule-pause-all').click();await current.started.promise;
   old.gate.resolve();await page.evaluate(()=>window.__oldPause);
   check(await page.locator('#schedule-pause-all').isDisabled()&&(await page.locator('#schedule-pause-feedback').innerText()).includes('正在登记')&&(await page.locator('#schedule-list').innerText()).includes('new-job-'+outcome),'old_'+outcome+'_does_not_replace_new_jobs_feedback_or_unlock_new_request');
   current.gate.resolve();await settled();
   check((await page.locator('#schedule-pause-feedback').innerText()).includes('本次暂停 1 个')&&(await page.locator('#schedule-list').innerText()).includes('new-job-'+outcome),'new_account_result_applies_after_old_'+outcome);
  }
  state.runtime={mode:'demo',platform:'Windows',capabilities:{canSend:true}};state.connection={status:'logged_in'};state.jobs=[];await refresh();
  check(await page.locator('#schedule-pause-controls').isHidden()&&await page.locator('#schedule-group-filter').isHidden(),'demo_bulk_pause_and_conversation_filter_hidden');
  check(!requests.some(row=>row.method==='POST'&&!['/api/select','/api/jobs/pause-all','/api/jobs/pause','/api/jobs'].includes(row.path)),'no_message_hook_reply_or_handoff_mutation');
  check(rule.text==='保留的回复配置','saved_reply_unchanged');check(errors.length===0,'no_browser_javascript_errors');
  return {checks,realBrowser:true,allApis:'synthetic',realWindowsReadOrSend:false};
 }finally{for(const entry of held)entry.gate.resolve();page.off('pageerror',onError);await page.unroute('**/api/**',handler);}
}
