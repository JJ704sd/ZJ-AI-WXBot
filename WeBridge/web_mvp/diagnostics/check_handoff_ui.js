// playwright-cli run-code --filename web_mvp/diagnostics/check_handoff_ui.js
// Synthetic APIs only; never reads WeChat or calls a native sending interface.
async (page) => {
 const checks=[],errors=[],requests=[];
 const check=(condition,name)=>{if(!condition)throw Error(name);checks.push(name);};
 const source={id:'handoff-fixture-source',revision:'r1',status:'snapshot_ready',createdAt:'2026-10-03T01:00:00Z',updatePolicy:'on_change'};
 const group={id:'handoff-fixture@chatroom',name:'采购询价 · 合成群'};
 const state={account:source.id,selfId:'fixture-self',name:'合成账号',csrfToken:'synthetic',connection:{status:'snapshot_ready'},groups:[group],selected:group.id,watchedGroups:[group.id],jobs:[],outbox:[],runtime:{mode:'database',connected:true,platform:'Windows',source,capabilities:{read:true,canSend:false,hookSendInterface:false,groupSend:false,automaticReplies:true,scheduledSend:true,mentions:true,media:false}}};
 let rule={enabled:false,text:'既有固定话术',cooldown:30,mode:'reply'},conflict=true,detailFailure=false;
 let delayedDetail=false,releaseDetail,detailStarted;
 const detailStart=new Promise(resolve=>detailStarted=resolve);
 const task={id:'fixture-one',groupId:group.id,groupName:group.name,trigger:{messageId:'m1',serverId:'123',senderId:'customer',senderName:'采购客户',timestamp:1790989210,text:'@业务负责人 请确认 500 套配件的价格和交期。',textTruncated:false},reason:'群规则要求人工处理',owner:'',status:'pending',createdAt:1790989211,updatedAt:1790989211,version:1,note:'',revoked:false};
 const older={...task,id:'fixture-older',trigger:{...task.trigger,text:'上一批订单的报价仍待确认。'}};
 const changes=[{version:1,action:'created',status:'pending',owner:'',note:'',createdAt:task.createdAt}];
 const handler=async route=>{
  const request=route.request(),raw=request.url(),path=raw.split('?')[0].replace(/^https?:\/\/[^/]+/,''),query=Object.fromEntries((raw.split('?')[1]||'').split('&').filter(Boolean).map(part=>{const [key,value='']=part.split('=');return [decodeURIComponent(key),decodeURIComponent(value.replace(/\+/g,' '))];}));
  const body=request.method()==='POST'?request.postDataJSON():null;requests.push({path,method:request.method(),query,body});
  if(path==='/api/state')return route.fulfill({json:state});
  if(path==='/api/database')return route.fulfill({json:{mode:'database',configured:true,busy:false,config:{sourceRoot:'D:\\Synthetic\\db',autoRefresh:true},source}});
  if(path==='/api/select')return route.fulfill({json:{ok:true}});
  if(path==='/api/group'||path==='/api/messages')return route.fulfill({json:{watching:true,members:[],messages:[],outbox:[],reply:rule}});
  if(path==='/api/windows/hook/status')return route.fulfill({json:{available:false,status:'disabled',issue:'合成测试未连接 Hook'}});
  if(path==='/api/reply'){rule={...rule,...body};return route.fulfill({json:rule});}
  if(path==='/api/handoffs')return route.fulfill({json:{records:[query.cursor?older:task],limit:50,hasMore:!query.cursor,nextCursor:query.cursor?'':'synthetic-older-page'}});
  if(path==='/api/handoffs/detail'){
   if(delayedDetail){detailStarted();await new Promise(resolve=>releaseDetail=resolve);return route.fulfill({json:{record:{...task,trigger:{...task.trigger,text:'OLD_ACCOUNT_SECRET'}},changes,historyTruncated:false}});}
   if(detailFailure){detailFailure=false;return route.fulfill({status:400,json:{error:'副本暂不可读，请重试'}});}
   return route.fulfill({json:{record:query.id===older.id?older:task,changes,historyTruncated:false}});
  }
  if(path==='/api/handoffs/action'){
   if(conflict){conflict=false;Object.assign(task,{version:2,status:'in_progress',owner:'同事乙',revoked:true});task.trigger.text='MUST_NOT_RENDER_REVOKED_TEXT';return route.fulfill({status:409,json:{error:'记录已更新，请先核对',code:'handoff_conflict'}});}
   if(body.version!==task.version)return route.fulfill({status:409,json:{error:'版本不匹配',code:'handoff_conflict'}});
   Object.assign(task,{status:{claim:'in_progress',complete:'completed',release:'pending',reopen:'pending'}[body.action],owner:body.action==='claim'?body.owner:['release','reopen'].includes(body.action)?'':task.owner,note:body.note,version:task.version+1,updatedAt:1790989211+task.version});
   changes.unshift({version:task.version,action:body.action,status:task.status,owner:task.owner,note:task.note,createdAt:task.updatedAt});return route.fulfill({json:task});
  }
  return route.fulfill({status:400,json:{error:'Synthetic test blocks this API.'}});
 };
 const onError=error=>errors.push(error.message);page.on('pageerror',onError);await page.route('**/api/**',handler);
 try{
  await page.setViewportSize({width:1440,height:1000});await page.reload();
  await page.waitForFunction(()=>document.getElementById('selected-name').textContent.includes('采购询价')&&!document.getElementById('save-reply').disabled);
  check(await page.locator('#reply-form').isVisible()&&await page.locator('#send-tab').isHidden(),'handoff_rule_available_without_hook_interface');
  await page.locator('#reply-mode').selectOption('handoff');await page.locator('#reply-enabled').check();await page.evaluate(()=>poll());
  check(await page.locator('#reply-mode').inputValue()==='handoff'&&await page.locator('#reply-enabled').isChecked(),'poll_preserves_unsaved_mode_and_enable');
  check(await page.locator('#reply-text').isDisabled()&&await page.locator('#reply-cooldown').isDisabled(),'handoff_mode_disables_reply_only_fields');
  await page.locator('#save-reply').click();await page.waitForFunction(()=>document.getElementById('reply-saved-status').textContent.includes('人工待办已开启'));
  const saved=requests.find(row=>row.path==='/api/reply').body;
  check(saved.mode==='handoff'&&saved.enabled&&saved.text==='既有固定话术','rule_save_preserves_template_and_selects_handoff');
  await page.locator('[data-view="handoffs"]').click();await page.waitForFunction(()=>document.getElementById('handoff-list').textContent.includes('500 套配件'));
  check((await page.locator('#handoff-notice').innerText()).includes('本机待办，未通知负责人')&&(await page.locator('#handoff-notice').innerText()).includes('定时发送独立配置'),'queue_describes_local_notification_and_rule_boundaries');
  await page.locator('#handoff-status').selectOption('pending');await page.locator('#handoff-group').selectOption(group.id);await page.waitForFunction(()=>!document.getElementById('handoff-next').disabled);
  const query=requests.filter(row=>row.path==='/api/handoffs').at(-1).query;check(query.status==='pending'&&query.groupId===group.id&&query.limit==='50','status_and_group_filters_reach_api');
  await page.locator('#handoff-next').click();await page.waitForFunction(()=>document.getElementById('handoff-page').textContent==='第 2 页');await page.evaluate(()=>poll());
  check((await page.locator('#handoff-list').innerText()).includes('上一批订单')&&(await page.locator('#handoff-page').innerText())==='第 2 页','poll_keeps_older_page_stationary');
  await page.locator('#handoff-prev').click();await page.waitForFunction(()=>document.getElementById('handoff-list').textContent.includes('500 套配件'));
  await page.screenshot({path:'output/playwright/handoffs-desktop.png',fullPage:true});
  await page.locator('#handoff-list button').click();await page.waitForFunction(()=>document.getElementById('handoff-detail-text').textContent.includes('500 套配件'));
  await page.locator('#handoff-owner').fill('客服甲');await page.locator('#handoff-note').fill('已与采购联系，正在核对报价。');await page.locator('#handoff-claim').click();
  await page.waitForFunction(()=>document.getElementById('handoff-detail-meta').textContent.includes('版本 2')&&!document.getElementById('handoff-complete').disabled);
  check(await page.locator('#handoff-owner').inputValue()==='客服甲'&&await page.locator('#handoff-note').inputValue()==='已与采购联系，正在核对报价。','http_409_refreshes_detail_and_retains_unsaved_inputs');
  check((await page.locator('#handoff-detail-message').innerText()).includes('409')&&(await page.locator('#handoff-detail-meta').innerText()).includes('同事乙'),'conflict_displays_current_owner_and_version');
  check(await page.locator('#handoff-detail-text').innerText()==='原消息已撤回，原文不再显示。','revoked_content_is_masked_even_if_response_contains_text');
  await page.locator('#handoff-complete').click();await page.waitForFunction(()=>document.getElementById('handoff-detail-title').textContent.includes('已完成')&&!document.getElementById('handoff-reopen').disabled);
  check(requests.filter(row=>row.path==='/api/handoffs/action').at(-1).body.version===2,'complete_uses_refreshed_version');
  await page.locator('#handoff-reopen').click();await page.waitForFunction(()=>document.getElementById('handoff-detail-title').textContent.includes('待领取')&&!document.getElementById('handoff-owner').disabled);
  await page.locator('#handoff-owner').fill('客服甲');await page.locator('#handoff-claim').click();await page.waitForFunction(()=>document.getElementById('handoff-detail-title').textContent.includes('处理中')&&!document.getElementById('handoff-release').disabled);
  await page.locator('#handoff-release').click();await page.waitForFunction(()=>document.getElementById('handoff-detail-title').textContent.includes('待领取')&&!document.getElementById('handoff-owner').disabled);
  check(await page.locator('#handoff-owner').inputValue()===''&&rule.mode==='handoff'&&requests.filter(row=>row.path==='/api/reply').length===1,'task_lifecycle_does_not_restore_reply_rule');
  detailFailure=true;await page.locator('#handoff-detail-refresh').click();await page.waitForFunction(()=>document.getElementById('handoff-detail-message').textContent.includes('详情读取失败'));
  check(await page.locator('#handoff-detail-refresh').isEnabled()&&await page.locator('#handoff-claim').isDisabled(),'failed_detail_allows_retry_without_stale_actions');
  await page.locator('#handoff-detail-refresh').click();await page.waitForFunction(()=>!document.getElementById('handoff-owner').disabled);
  check(await page.locator('#handoff-detail-message').innerText()==='','successful_manual_retry_clears_old_error');
  await page.setViewportSize({width:390,height:844});
  check(await page.locator('#handoff-dialog').evaluate(node=>node.scrollWidth<=node.clientWidth+1),'handoff_dialog_has_no_mobile_horizontal_overflow');
  await page.screenshot({path:'output/playwright/handoff-detail-mobile.png',fullPage:true});
  await page.locator('#handoff-dialog .close-dialog').click();check(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth+1),'queue_has_no_mobile_horizontal_overflow');
  await page.screenshot({path:'output/playwright/handoffs-mobile.png',fullPage:true});await page.setViewportSize({width:1440,height:1000});
  delayedDetail=true;await page.locator('#handoff-list button').click();await detailStart;
  state.watchedGroups=[];await page.evaluate(()=>poll());releaseDetail();await page.waitForFunction(()=>!document.getElementById('handoff-dialog').open);
  check(!(await page.locator('#handoff-detail-text').innerText()).includes('OLD_ACCOUNT_SECRET')&&await page.locator('#handoff-owner').inputValue()==='','unwatch_closes_detail_and_discards_stale_response');
  check(!requests.some(row=>row.method==='POST'&&!['/api/select','/api/reply','/api/handoffs/action'].includes(row.path)),'no_wechat_or_hook_mutation_requests');
  check(errors.length===0,'no_browser_javascript_errors');
  return {checks,realBrowser:true,allApis:'synthetic',realWindowsReadOrSend:false};
 }finally{page.off('pageerror',onError);await page.unroute('**/api/**',handler);}
}
