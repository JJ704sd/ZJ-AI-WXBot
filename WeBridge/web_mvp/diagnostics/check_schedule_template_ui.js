// playwright-cli run-code --filename web_mvp/diagnostics/check_schedule_template_ui.js
// All API requests are intercepted. No real database, Hook or message sending.
async (page) => {
 const checks=[],errors=[],requests=[],gates=[];
 const check=(value,name)=>{if(!value)throw Error(name);checks.push(name);};
 const clone=value=>JSON.parse(JSON.stringify(value));
 const deferred=()=>{let resolve;const promise=new Promise(done=>resolve=done);const result={promise,resolve};gates.push(result);return result;};
 const groupA={id:'template-alpha@chatroom',name:'同名客户群'},groupB={id:'template-beta@chatroom',name:'同名客户群'};
 const source={id:'template-account-a',revision:'r1',status:'snapshot_ready',createdAt:'2026-10-03T01:00:00Z',updatePolicy:'on_change'};
 const frozenJob={id:'existing-job',group_id:groupA.id,targetName:groupA.name,text:'已创建任务的固定正文',mode:'daily',clock:'09:00',windowMinutes:2,weekdays:[1,2,3,4,5,6,7],state:'paused',enabled:false,nextRun:null,runs:[],last_result:'',mentions:[]};
 const state={account:source.id,selfId:'fixture-self',name:'合成账号',csrfToken:'synthetic',connection:{status:'snapshot_ready'},groups:[groupA,groupB],selected:groupA.id,watchedGroups:[groupA.id,groupB.id],jobs:[frozenJob],outbox:[],runtime:{mode:'database',connected:true,platform:'Windows',source,capabilities:{read:true,canSend:true,hookSendInterface:true,groupSend:true,automaticReplies:true,scheduledSend:true,scheduleWindows:true,scheduleTemplates:true,mentions:true,media:false}}};
 const rule={enabled:false,text:'既有回复配置',cooldown:30,mode:'reply'};
 const template={id:'7313b1e7-67ba-4873-99c8-39a90fccf769',name:'客户提醒',text:'{{客户}}您好，请于{{日期}}反馈。',version:1,variables:['客户','日期'],profiles:{}};
 template.profiles[groupA.id]={values:{客户:'甲客户',日期:'周五'},overrideText:null};
 template.profiles[groupB.id]={values:{客户:'乙客户',日期:'周六'},overrideText:'乙组独立正文 {{不会替换}}'};
 const stores=new Map([[state.account,new Map([[template.id,template]])]]);
 let conflictNext=false,previewGate=null,itemGate=null;
 const summary=row=>({id:row.id,name:row.name,version:row.version,variables:row.variables,targetCount:Object.keys(row.profiles).length});
 const detail=(row,groupId='')=>clone({id:row.id,name:row.name,text:row.text,version:row.version,variables:row.variables,targets:Object.keys(row.profiles).map(id=>({groupId:id,targetName:id===groupA.id?groupA.name:groupB.name})),groupId,profile:row.profiles[groupId]||{values:{},overrideText:null}});
 const query=(url,key)=>decodeURIComponent((url.match(new RegExp('[?&]'+key+'=([^&]*)'))||['',''])[1].replace(/\+/g,' '));
 const handler=async route=>{
  const request=route.request(),url=request.url(),path=url.split('?')[0].replace(/^https?:\/\/[^/]+/,''),body=request.method()==='POST'?request.postDataJSON():null;
  requests.push({path,method:request.method(),body});
  if(path==='/api/state')return route.fulfill({json:state});
  if(path==='/api/database')return route.fulfill({json:{mode:'database',configured:true,busy:false,config:{sourceRoot:'D:\\Synthetic\\db',autoRefresh:true},source:state.runtime.source}});
  if(path==='/api/select')return route.fulfill({json:{ok:true}});
  if(path==='/api/group'||path==='/api/messages')return route.fulfill({json:{watching:true,members:[],messages:[],outbox:[],reply:rule}});
  if(path==='/api/windows/hook/status')return route.fulfill({json:{available:false,status:'disabled',issue:'合成测试未连接 Hook'}});
  if(path==='/api/jobs'){const row={...frozenJob,id:'created-job',text:body.text,group_id:body.groupId,state:'active',enabled:true,at:body.at,mode:body.mode,windowMinutes:body.windowMinutes};state.jobs.push(row);return route.fulfill({json:row});}
  if(path.startsWith('/api/schedule-templates')){
   const account=body?body.account:query(url,'account'),store=stores.get(account);
   if(path==='/api/schedule-templates')return route.fulfill({json:{templates:[...store.values()].map(summary)}});
   const id=body?body.id:query(url,'id'),row=store.get(id);
   if(path.endsWith('/item')){const result=detail(row,query(url,'groupId')),held=itemGate;itemGate=null;if(held){held.started.resolve();await held.done.promise;}return route.fulfill({json:result});}
   if(conflictNext){conflictNext=false;row.version++;return route.fulfill({status:409,json:{error:'合成外部更新',code:'template_conflict'}});}
   if((row?row.version:0)!==body.version)return route.fulfill({status:409,json:{error:'模板版本已变化',code:'template_conflict'}});
   if(path.endsWith('/save')){const saved={id,name:body.name,text:body.text,version:body.version+1,variables:[...new Set([...body.text.matchAll(/\{\{([^}]+)\}\}/g)].map(match=>match[1]))],profiles:row?row.profiles:{}};store.set(id,saved);return route.fulfill({json:detail(saved)});}
   if(path.endsWith('/delete')){store.delete(id);return route.fulfill({json:{deleted:true}});}
   if(path.endsWith('/profile')){row.profiles[body.groupId]=clone({values:body.values,overrideText:body.overrideText});row.version++;return route.fulfill({json:detail(row,body.groupId)});}
   if(path.endsWith('/preview')){
    let text=body.overrideText;
    if(text===null){if(row.variables.some(key=>!body.values[key]||!body.values[key].trim()))return route.fulfill({status:400,json:{error:'请填写全部变量'}});text=row.text.replace(/\{\{([^}]+)\}\}/g,(_,key)=>body.values[key]);}
    if(!text.trim())return route.fulfill({status:400,json:{error:'完整覆盖正文不能为空'}});
    const result={id,version:row.version,groupId:body.groupId,templateName:row.name,text},held=previewGate;previewGate=null;
    if(held){held.started.resolve();await held.done.promise;}
    return route.fulfill({json:result});
   }
  }
  return route.fulfill({status:400,json:{error:'Synthetic test blocks this API.'}});
 };
 const onError=error=>errors.push(error.message);page.on('pageerror',onError);await page.route('**/api/**',handler);
 const refresh=async()=>{await page.waitForFunction(()=>!pollBusy);await page.evaluate(()=>poll());};
 const settled=async()=>page.waitForFunction(()=>scheduleTemplateRequest===null);
 const ready=async()=>page.waitForFunction(()=>scheduleTemplateRequest===null&&scheduleTemplateDetail!==null);
 const closeTemplate=async()=>{await page.locator('#schedule-template-dialog .dialog-heading .close-dialog').click();await page.waitForFunction(()=>!document.getElementById('schedule-template-dialog').open&&scheduleTemplateDetail===null);};
 const variable=key=>page.locator('#schedule-template-values input[data-variable="'+key+'"]');
 const preview=async()=>{await page.locator('#schedule-template-preview').click();await settled();};
 const visibleInDialog=async(selector,name)=>{
  const locator=page.locator(selector);await locator.scrollIntoViewIfNeeded();
  const result=await locator.evaluate(node=>{
   const rect=node.getBoundingClientRect(),dialog=node.closest('dialog'),frame=dialog.getBoundingClientRect(),footer=dialog.querySelector(':scope > .dialog-actions').getBoundingClientRect();
   const bottom=node.id==='schedule-template-preview-text'?Math.min(frame.bottom,footer.top,innerHeight):Math.min(frame.bottom,innerHeight);
   const centerX=rect.left+rect.width/2,centerY=rect.top+rect.height/2,hit=document.elementFromPoint(centerX,centerY);
   return {visible:rect.width>0&&rect.height>0&&rect.top>=Math.max(0,frame.top)&&rect.bottom<=bottom+1&&rect.left>=Math.max(0,frame.left)&&rect.right<=Math.min(innerWidth,frame.right)+1&&!!hit&&(hit===node||node.contains(hit)),top:rect.top,bottom:rect.bottom,visibleBottom:bottom,text:node.textContent.trim()};
  });
  if(!result.visible||!result.text)throw Error(name+': '+JSON.stringify(result));checks.push(name);
 };
 try{
  await page.setViewportSize({width:1440,height:1050});await page.reload();await page.waitForFunction(()=>!document.getElementById('new-schedule').disabled);
  await page.locator('[data-view="schedules"]').click();state.runtime.connected=false;state.runtime.capabilities.read=false;await refresh();
  check(!await page.locator('#schedule-template-library').isDisabled()&&await page.locator('#new-schedule').isDisabled(),'template_library_available_with_offline_source');
  await page.locator('#schedule-template-library').click();await ready();
  check(await page.locator('#schedule-template-apply').isHidden(),'management_mode_does_not_offer_apply');
  const options=await page.locator('#schedule-template-target option').allTextContents();
  check(options.some(value=>value.includes(groupA.id))&&options.some(value=>value.includes(groupB.id)),'same_name_conversations_are_distinguished_by_id');
  await page.locator('#schedule-template-new').click();await page.locator('#schedule-template-name').fill('可删除的测试模板');await page.locator('#schedule-template-body').fill('{{客户}}测试');await page.locator('#schedule-template-save').click();await ready();
  const newId=await page.locator('#schedule-template-select').inputValue();
  check(stores.get(state.account).has(newId)&&requests.some(row=>row.path.endsWith('/save')&&row.body.id===newId&&row.body.version===0),'new_template_saved_with_explicit_uuid_and_version_zero');
  await page.locator('#schedule-template-delete').click();await settled();
  check(!stores.get(state.account).has(newId)&&!(await page.locator('#schedule-template-select option').allTextContents()).some(value=>value.includes('可删除')),'delete_removes_template_from_library');
  await page.locator('#schedule-template-select').selectOption(template.id);await ready();await page.locator('#schedule-template-target').selectOption(groupA.id);await ready();
  await variable('客户').fill('甲客户更新');await variable('日期').fill('10 月 8 日');await page.locator('#schedule-template-profile-save').click();await ready();
  check(stores.get(state.account).get(template.id).profiles[groupA.id].values.客户==='甲客户更新','target_variables_saved_by_id');
  await page.locator('#schedule-template-target').selectOption(groupB.id);await ready();
  check(await page.locator('#schedule-template-override').isChecked()&&await page.locator('#schedule-template-override-text').inputValue()==='乙组独立正文 {{不会替换}}','second_target_has_separate_literal_override');
  await preview();check(await page.locator('#schedule-template-preview-text').innerText()==='乙组独立正文 {{不会替换}}','override_bypasses_variable_substitution');
  await page.locator('#schedule-template-override-text').fill('');await preview();
  check((await page.locator('#schedule-template-message').innerText()).includes('不能为空')&&await page.locator('#schedule-template-apply').isDisabled(),'empty_override_preview_cannot_apply_or_fallback');
  await page.locator('#schedule-template-override-text').fill('乙组更新后的完整正文');await page.locator('#schedule-template-profile-save').click();await ready();await closeTemplate();
  state.runtime.connected=true;state.runtime.capabilities.read=true;await page.reload();await page.waitForFunction(()=>!document.getElementById('new-schedule').disabled);await page.locator('[data-view="schedules"]').click();await page.locator('#schedule-template-library').click();await ready();
  await page.locator('#schedule-template-target').selectOption(groupA.id);await ready();
  check(await variable('客户').inputValue()==='甲客户更新'&&!await page.locator('#schedule-template-override').isChecked(),'simulated_restart_reads_saved_target_values_without_other_override');
  await preview();check(await page.locator('#schedule-template-preview-text').innerText()==='甲客户更新您好，请于10 月 8 日反馈。','server_preview_uses_saved_variables');
  await page.locator('#schedule-template-name').fill('保留冲突草稿');conflictNext=true;await page.locator('#schedule-template-save').click();await settled();
  check((await page.locator('#schedule-template-message').innerText()).includes('409')&&await page.locator('#schedule-template-name').inputValue()==='保留冲突草稿'&&await page.locator('#schedule-template-save').isDisabled(),'conflict_retains_draft_and_requires_explicit_reload');
  await refresh();check(await page.locator('#schedule-template-name').inputValue()==='保留冲突草稿','ordinary_poll_does_not_replace_conflicted_draft');
  await page.locator('#schedule-template-reload').click();await ready();check(await page.locator('#schedule-template-name').inputValue()==='客户提醒','explicit_reload_reads_current_template');
  await page.screenshot({path:'output/playwright/schedule-template-desktop.png',fullPage:true});
  await page.setViewportSize({width:390,height:844});
  check(await page.locator('#schedule-template-dialog').evaluate(node=>node.scrollWidth<=node.clientWidth+1),'template_dialog_has_no_mobile_horizontal_overflow');
  await page.locator('#schedule-template-preview').scrollIntoViewIfNeeded();await preview();
  check((await page.locator('#schedule-template-preview-text').innerText()).includes('甲客户更新'),'preview_action_reachable_on_narrow_screen');
  await visibleInDialog('#schedule-template-preview-text','full_preview_visible_above_footer_on_narrow_screen');
  await page.screenshot({path:'output/playwright/schedule-template-mobile.png',fullPage:true});await page.setViewportSize({width:1440,height:1050});

  const lateDraft={started:deferred(),done:deferred()};previewGate=lateDraft;await page.evaluate(()=>{window.__lateTemplatePreview=previewScheduleTemplate();});await lateDraft.started.promise;
  await variable('客户').fill('较新的变量草稿');lateDraft.done.resolve();await page.evaluate(()=>window.__lateTemplatePreview);
  check(await page.locator('#schedule-template-preview-text').textContent()===''&&await variable('客户').inputValue()==='较新的变量草稿','late_preview_does_not_override_new_variable_draft');
  const lateTarget={started:deferred(),done:deferred()};itemGate=lateTarget;await page.evaluate(group=>{window.__lateTemplateItem=loadScheduleTemplate(scheduleTemplateDetail.id,group);},groupA.id);await lateTarget.started.promise;
  await page.locator('#schedule-template-target').selectOption(groupB.id);await ready();lateTarget.done.resolve();await page.evaluate(()=>window.__lateTemplateItem);
  check(await page.locator('#schedule-template-target').inputValue()===groupB.id&&await page.locator('#schedule-template-override-text').inputValue()==='乙组更新后的完整正文','late_target_read_does_not_replace_current_profile');
  await closeTemplate();await page.locator('#new-schedule').click();await page.locator('#schedule-group').selectOption(groupA.id);await page.locator('#schedule-text').fill('将由明确应用替换的草稿');
  await page.locator('#schedule-template-fill').click();await ready();check(await page.locator('#schedule-template-target').isDisabled()&&await page.locator('#schedule-template-target').inputValue()===groupA.id,'apply_dialog_pins_current_task_target');
  await preview();await page.setViewportSize({width:390,height:844});
  await visibleInDialog('#schedule-template-preview-text','apply_mode_full_preview_reachable_on_narrow_screen');
  await visibleInDialog('#schedule-template-apply','apply_button_reachable_on_narrow_screen');
  await page.screenshot({path:'output/playwright/schedule-template-apply-mobile.png',fullPage:true});
  const jobCount=requests.filter(row=>row.path==='/api/jobs').length;await page.locator('#schedule-template-apply').click();await page.waitForFunction(()=>!document.getElementById('schedule-template-dialog').open&&scheduleTemplateDetail===null);await page.setViewportSize({width:1440,height:1050});
  check(await page.locator('#schedule-text').inputValue()==='甲客户更新您好，请于10 月 8 日反馈。'&&requests.filter(row=>row.path==='/api/jobs').length===jobCount,'explicit_apply_only_copies_preview_text');
  await page.locator('#schedule-group').selectOption(groupB.id);check(await page.locator('#schedule-text').inputValue()===''&&(await page.locator('#schedule-template-source').innerText()).includes('会话已变化'),'changing_task_target_clears_unedited_template_text');
  await page.locator('#schedule-template-fill').click();await ready();await preview();await page.locator('#schedule-template-apply').click();await page.waitForFunction(()=>!document.getElementById('schedule-template-dialog').open&&scheduleTemplateDetail===null);
  check(await page.locator('#schedule-text').inputValue()==='乙组更新后的完整正文','second_task_target_applies_its_own_override');
  await page.locator('#schedule-text').fill('人工核对后的最终正文');await page.locator('#schedule-group').selectOption(groupA.id);
  check(await page.locator('#schedule-text').inputValue()==='人工核对后的最终正文','manually_edited_text_survives_target_change');
  await page.locator('#create-schedule').click();await page.waitForFunction(()=>!scheduleBusy&&!document.getElementById('schedule-dialog').open);
  const created=requests.filter(row=>row.path==='/api/jobs').at(-1).body;
  check(created.text==='人工核对后的最终正文'&&created.groupId===groupA.id&&!Object.keys(created).some(key=>/template|preview/i.test(key)),'created_task_contains_literal_text_without_template_reference');
  check(state.jobs[0].text==='已创建任务的固定正文','template_edits_do_not_change_existing_jobs');

  await page.locator('#schedule-template-library').click();await ready();await page.locator('#schedule-template-target').selectOption(groupA.id);await ready();
  const lateAccount={started:deferred(),done:deferred()};previewGate=lateAccount;await page.evaluate(()=>{window.__oldAccountPreview=previewScheduleTemplate();});await lateAccount.started.promise;
  state.account='template-account-b';state.runtime.source={...source,id:state.account};stores.set(state.account,new Map());state.jobs=[];await refresh();lateAccount.done.resolve();await page.evaluate(()=>window.__oldAccountPreview);
  check(!await page.locator('#schedule-template-dialog').isVisible()&&await page.locator('#schedule-template-preview-text').textContent()==='','account_switch_discards_late_preview');
  state.runtime.capabilities.scheduleTemplates=false;await refresh();check(await page.locator('#schedule-template-library').isHidden()&&await page.locator('#schedule-template-fill').isHidden(),'old_service_hides_template_entries');
  state.runtime={mode:'demo',platform:'Windows',capabilities:{canSend:true,scheduleTemplates:true}};state.connection={status:'logged_in'};await refresh();check(await page.locator('#schedule-template-library').isHidden(),'demo_hides_template_library_even_with_capability');
  check(!requests.some(row=>row.method==='POST'&&!['/api/select','/api/jobs','/api/schedule-templates/save','/api/schedule-templates/profile','/api/schedule-templates/preview','/api/schedule-templates/delete'].includes(row.path)),'no_native_hook_message_reply_or_handoff_requests');
  check(errors.length===0,'no_browser_javascript_errors');return {checks,realBrowser:true,allApis:'synthetic',realWindowsReadOrSend:false};
 }finally{for(const gate of gates)gate.resolve();page.off('pageerror',onError);await page.unroute('**/api/**',handler);}
}
