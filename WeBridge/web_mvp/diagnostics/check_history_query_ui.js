// playwright-cli run-code --filename web_mvp/diagnostics/check_history_query_ui.js
// A real browser with synthetic APIs only; no WeChat reads, mutations or sends.
async (page) => {
 const checks=[],errors=[],requests=[];
 const check=(ok,name)=>{if(!ok)throw Error(name);checks.push(name);};
 const source={id:'history-fixture-source',revision:'r1',status:'snapshot_ready',createdAt:'2026-10-02T01:00:00Z',updatePolicy:'manual'};
 const group={id:'history-fixture@chatroom',name:'本机历史查询 · 合成群'};
 const runtime={mode:'database',connected:true,platform:'Windows',source,capabilities:{read:true,canSend:true,hookSendInterface:true,automaticReplies:true,scheduledSend:true,mentions:true,media:false}};
 const state={runtime,account:source.id,selfId:'fixture-self',name:'合成账号',csrfToken:'fixture',connection:{status:'snapshot_ready'},groups:[group],selected:group.id,watchedGroups:[group.id],jobs:[],outbox:[]};
 let releaseHistory,historyStarted;
 const delayed=new Promise(resolve=>historyStarted=resolve);
 const message=(id,text)=>({id,kind:'text',text,senderName:'合成联系人',timestamp:1727740800,mentionSelf:false});
 const handler=async route=>{
  const request=route.request(),raw=request.url(),path=raw.split('?')[0].replace(/^https?:\/\/[^/]+/,''),query=Object.fromEntries((raw.split('?')[1]||'').split('&').filter(Boolean).map(part=>{const [key,value='']=part.split('=');return [decodeURIComponent(key),decodeURIComponent(value.replace(/\+/g,' '))];}));requests.push({path,method:request.method(),query});
  if(path==='/api/state')return route.fulfill({json:state});
  if(path==='/api/database')return route.fulfill({json:{mode:'database',configured:true,busy:false,config:{sourceRoot:'D:\\Synthetic\\db'},source}});
  if(path==='/api/select')return route.fulfill({json:{ok:true}});
  if(path==='/api/group'||path==='/api/messages')return route.fulfill({json:{watching:true,members:[],messages:[message('live','实时区合成消息')],outbox:[],reply:{enabled:false,text:'已保存规则',cooldown:30}}});
  if(path==='/api/windows/hook/status')return route.fulfill({json:{available:false,status:'disabled',issue:'合成测试不接入微信'}});
  if(path==='/api/message-history'){
   if(query.query==='DELAYED'){historyStarted();await new Promise(resolve=>releaseHistory=resolve);return route.fulfill({json:{messages:[message('late','OLD_REVISION_SECRET')],limit:100,hasMore:false,nextCursor:'',warnings:[]}});}
   const second=!!query.cursor;
   return route.fulfill({json:{messages:[message(second?'older':'newer',second?'更早采购单 · 合成历史第二页':'采购记录 · 合成历史第一页')],limit:100,hasMore:!second,nextCursor:second?'':'synthetic-history-cursor',warnings:[]}});
  }
  if(path==='/api/execution-history'){
   if(query.source==='reply')return route.fulfill({json:{records:[{id:'reply-fixture',source:'reply',targetId:group.id,targetName:group.name,text:'当次批准话术',createdAt:1727740800,status:'cooldown_skipped',label:'回复间隔内已跳过',timeBasis:'执行记录时间',pending:false,attention:false,decision:'cooldown_skipped',trigger:{messageId:'incoming',serverId:'123',senderId:'contact',senderName:'业务联系人',timestamp:1727740790,text:'请提供季度价格表',textTruncated:true}}],limit:200,hasMore:false,nextCursor:''}});
   const second=!!query.cursor;
   return route.fulfill({json:{records:[{id:second?'old-execution':'first-execution',source:'schedule',targetId:group.id,targetName:group.name,text:second?'旧采购计划执行':'新采购计划执行',createdAt:1727740800,status:'unknown',label:'结果未知，不自动重试',timeBasis:'执行记录时间',pending:true,attention:true}],limit:200,hasMore:!second,nextCursor:second?'':'synthetic-execution-cursor'}});
  }
  return route.fulfill({status:400,json:{error:'Synthetic test blocks this API.'}});
 };
 const onError=error=>errors.push(error.message);
 page.on('pageerror',onError);await page.route('**/api/**',handler);
 try{
  await page.setViewportSize({width:1440,height:1000});await page.reload();
  await page.waitForFunction(()=>document.getElementById('message-list').textContent.includes('实时区合成消息'));
  await page.locator('#message-text').fill('未提交的合成草稿');
  await page.locator('#reply-tab').click();await page.locator('#reply-text').fill('未保存的合成规则');
  await page.locator('#open-message-history').click();
  await page.waitForFunction(()=>document.getElementById('history-results').textContent.includes('历史第一页'));
  await page.locator('#history-query').fill('采购');await page.locator('#history-start-date').fill('2024-10-01');await page.locator('#history-end-date').fill('2024-10-02');await page.locator('#history-submit').click();
  await page.waitForFunction(()=>document.getElementById('history-results').textContent.includes('历史第一页'));
  const query=requests.filter(row=>row.path==='/api/message-history').at(-1).query;
  check(query.query==='采购'&&query.startDate==='2024-10-01'&&query.endDate==='2024-10-02','history_query_and_beijing_dates_reach_api');
  await page.locator('#history-next').click();await page.waitForFunction(()=>document.getElementById('history-page').textContent==='第 2 页');
  check((await page.locator('#history-results').innerText()).includes('更早采购单')&&await page.locator('#history-next').isDisabled(),'history_next_page_replaces_results_and_stops_at_end');
  await page.locator('#history-prev').click();await page.waitForFunction(()=>document.getElementById('history-page').textContent==='第 1 页');
  check((await page.locator('#history-results').innerText()).includes('历史第一页'),'history_previous_page');
  await page.screenshot({path:'output/playwright/history-query-desktop.png',fullPage:true});
  await page.setViewportSize({width:390,height:844});
  check(await page.locator('#history-dialog').evaluate(node=>node.scrollWidth<=node.clientWidth+1),'history_dialog_has_no_horizontal_overflow_on_mobile');
  await page.screenshot({path:'output/playwright/history-query-mobile.png',fullPage:true});await page.setViewportSize({width:1440,height:1000});
  await page.locator('#history-query').fill('DELAYED');await page.locator('#history-submit').click();await delayed;
  source.revision='r2';await page.evaluate(()=>poll());
  releaseHistory();await page.waitForFunction(()=>!document.getElementById('history-submit').disabled);
  check(!(await page.locator('#history-results').innerText()).includes('OLD_REVISION_SECRET'),'new_snapshot_discards_delayed_old_history');
  await page.locator('#history-dialog .close-dialog').click();
  check(await page.locator('#message-text').inputValue()==='未提交的合成草稿'&&await page.locator('#reply-text').inputValue()==='未保存的合成规则','history_preserves_draft_and_unsaved_reply');
  check((await page.locator('#message-list').innerText()).includes('实时区合成消息'),'history_does_not_replace_live_message_stream');
  await page.locator('[data-view="executions"]').click();await page.waitForFunction(()=>document.getElementById('execution-list').textContent.includes('新采购计划'));
  await page.locator('#execution-source').selectOption('schedule');await page.locator('#execution-status').selectOption('attention');await page.locator('#execution-search').fill('采购');await page.locator('#execution-start-date').fill('2024-10-01');await page.locator('#execution-end-date').fill('2024-10-02');
  await page.waitForFunction(()=>document.getElementById('execution-list').textContent.includes('新采购计划')&&!document.getElementById('execution-next').disabled);
  const executionQuery=requests.filter(row=>row.path==='/api/execution-history').at(-1).query;
  check(executionQuery.source==='schedule'&&executionQuery.status==='attention'&&executionQuery.query==='采购'&&executionQuery.startDate==='2024-10-01'&&executionQuery.endDate==='2024-10-02','execution_filters_reach_server');
  await page.locator('#execution-next').click();await page.waitForFunction(()=>document.getElementById('execution-page').textContent==='第 2 页');
  await page.evaluate(()=>poll());check((await page.locator('#execution-list').innerText()).includes('旧采购计划')&&(await page.locator('#execution-page').innerText())==='第 2 页','execution_poll_preserves_older_page');
  await page.screenshot({path:'output/playwright/execution-query-desktop.png',fullPage:true});
  await page.locator('#execution-prev').click();await page.waitForFunction(()=>document.getElementById('execution-page').textContent==='第 1 页');
  await page.setViewportSize({width:390,height:844});
  check(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth+1),'execution_page_has_no_horizontal_overflow_on_mobile');
  await page.screenshot({path:'output/playwright/execution-query-mobile.png',fullPage:true});
  await page.locator('#execution-source').selectOption('reply');await page.locator('#execution-status').selectOption('all');
  await page.waitForFunction(()=>document.querySelector('#execution-list .execution-trigger'));
  await page.locator('#execution-list .execution-trigger summary').click();
  check((await page.locator('#execution-list .execution-trigger').innerText()).includes('业务联系人')&&(await page.locator('#execution-list .execution-trigger').innerText()).includes('请提供季度价格表')&&(await page.locator('#execution-list .execution-trigger').innerText()).includes('2000'),'reply_audit_displays_trigger_sender_and_truncation');
  check((await page.locator('#execution-list').innerText()).includes('当次批准话术')&&(await page.locator('#execution-list').innerText()).includes('回复间隔内跳过'),'reply_audit_distinguishes_frozen_template_and_skip_decision');
  await page.screenshot({path:'output/playwright/reply-audit-mobile.png',fullPage:true});
  check(errors.length===0,'no_browser_javascript_errors');
  check(!requests.some(row=>row.method!=='GET'&&row.path!=='/api/select'),'no_send_or_configuration_mutations');
  return {checks,realBrowser:true,allApis:'synthetic',realWindowsReadOrSend:false};
 }finally{page.off('pageerror',onError);await page.unroute('**/api/**',handler);}
}
