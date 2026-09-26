// All APIs use synthetic fixtures. No real Hook service, native window or account is accessed.
async page=>{
 const checks=[],calls=[],errors=[];const check=(ok,name)=>{if(!ok)throw Error(name);checks.push(name);};const onError=e=>errors.push(e.message);
 const groups=[{id:'fixture-a',name:'合成会话甲'},{id:'fixture-b',name:'合成会话乙'},{id:'fixture-hidden',name:'未勾选会话'}];
 const source={id:'fixture-source',revision:'r1',status:'snapshot_ready',createdAt:'2026-09-26T06:00:00Z',updatePolicy:'manual'};
 const runtime={mode:'database',platform:'Windows',connected:true,source,databaseState:{busy:false,error:''},capabilities:{read:true,canSend:false,media:false,mentions:false}};
 const state={runtime,account:'fixture-account',csrfToken:'fixture',connection:{status:'snapshot_ready'},selected:'fixture-a',groups,watchedGroups:['fixture-a','fixture-b'],jobs:[],outbox:[]};
 let available=false,badTarget=false,confirmStatus='server_accepted',attemptStatus='local_record_confirmed',attemptCount=0,draftNumber=0,currentDraft=null;
 const handler=route=>{
  const req=route.request(),path=req.url().split('?')[0].split('/api/')[1],body=req.method()==='POST'?req.postDataJSON():null;calls.push({path,body,url:req.url()});
  if(path==='state')return route.fulfill({json:state});
  if(path==='environment')return route.fulfill({json:{...runtime,checks:[],limitations:[]}});
  if(path==='database')return route.fulfill({json:{mode:'database',configured:true,config:{sourceRoot:'D:\\Synthetic',autoRefresh:false},source,busy:false}});
  if(path==='select'){state.selected=body.groupId;return route.fulfill({json:{ok:true}});}
  if(path==='group'||path==='messages')return route.fulfill({json:{watching:true,members:[],messages:[],outbox:[],reply:{enabled:false}}});
  if(path==='windows/hook/status')return route.fulfill({json:{supported:true,available,bridgeConfigured:true,clientVersion:'4.1.fixture',arch:'x64',moduleName:'Synthetic.dll',moduleSha256:'1234567890abcdef'.repeat(4),processId:123,selfId:'fixture-self',issue:available?'':'合成模块版本未适配',issueCode:available?'':'unsupported_version'}});
  if(path==='windows/hook/prepare'){currentDraft={status:'prepared',draftId:'fixture-draft-'+(++draftNumber),textHash:'fixture-hash',text:body.text,targetId:badTarget?'unexpected-target':body.targetId,targetName:'服务端绑定·会话乙',expiresAt:new Date(Date.now()+300000).toISOString()};return route.fulfill({json:currentDraft});}
  if(path==='windows/hook/confirm')return route.fulfill({json:{...currentDraft,status:confirmStatus,serverAccepted:confirmStatus==='server_accepted',retryAllowed:false,delivered:false}});
  if(path==='windows/hook/attempt'){attemptCount++;return route.fulfill({json:{...currentDraft,status:attemptStatus,issue:'合成查询 '+attemptCount,localRecordConfirmed:attemptStatus==='local_record_confirmed',retryAllowed:false,delivered:false}});}
  return route.fulfill({status:409,json:{error:'Synthetic test blocks this API.'}});
 };
 const prepare=async text=>{await page.locator('#hook-send-text').fill(text);await page.locator('#hook-prepare').click();await page.waitForFunction(()=>!document.getElementById('hook-prepared').hidden);};
 await page.route('**/api/**',handler);page.on('pageerror',onError);await page.clock.install();await page.clock.pauseAt(new Date(Date.now()+1000));
 try{
  await page.setViewportSize({width:1440,height:1000});await page.reload();await page.waitForFunction(()=>!document.getElementById('hook-sender-entry').hidden&&document.getElementById('selected-name').textContent==='合成会话甲');
  await page.locator('#hook-sender-entry').click();await page.locator('#hook-send-text').fill('合成文本');
  check(await page.locator('#hook-prepare').isDisabled()&&!calls.some(c=>c.path.startsWith('windows/')),'hook_is_not_probed_or_enabled_implicitly');
  await page.locator('#hook-check').click();await page.waitForFunction(()=>document.getElementById('hook-status-text').textContent.includes('未适配'));
  check(await page.locator('#hook-prepare').isDisabled()&&(await page.locator('#hook-module-facts').innerText()).includes('1234567890abcdef')&&(await page.locator('#hook-module-facts').innerText()).includes('4.1.fixture'),'unapproved_version_stays_blocked_with_real_metadata_and_hash_summary');
  const values=await page.locator('#hook-target-select option').evaluateAll(options=>options.map(o=>o.value));
  check(values.includes('fixture-a')&&values.includes('fixture-b')&&!values.includes('fixture-hidden')&&!values.includes('filehelper'),'targets_only_include_current_account_watched_conversations');
  available=true;await page.locator('#hook-check').click();await page.waitForFunction(()=>document.getElementById('hook-status-badge').textContent==='就绪');await page.locator('#hook-target-select').selectOption('fixture-b');await page.waitForFunction(()=>document.getElementById('selected-name').textContent==='合成会话乙'&&!document.getElementById('hook-prepare').disabled);
  badTarget=true;await page.locator('#hook-prepare').click();await page.waitForFunction(()=>document.getElementById('hook-result-title').textContent==='预检未通过');
  check(await page.locator('#hook-prepared').isHidden()&&await page.locator('#hook-confirm').isDisabled(),'mismatched_server_target_cannot_create_confirmation');
  badTarget=false;await prepare('本次合成 Hook 消息');const request=calls.filter(c=>c.path==='windows/hook/prepare').pop().body;
  check(request.account==='fixture-account'&&request.groupId==='fixture-b'&&request.targetId==='fixture-b'&&!('sourceRoot'in request)&&!('endpoint'in request)&&!('token'in request),'prepare_uses_frozen_current_account_and_target_without_bridge_secrets');
  check((await page.locator('#hook-bound-target').innerText()).includes('服务端绑定·会话乙')&&await page.locator('#hook-confirm').isDisabled()&&await page.locator('#hook-target-select').isDisabled(),'prepared_text_and_server_target_require_explicit_confirmation');
  await page.locator('#hook-sender-panel').screenshot({path:'output/playwright/hook-sender-fixture.png'});
  await page.locator('#hook-confirmed').check();await page.evaluate(()=>{const b=document.getElementById('hook-confirm');b.click();b.click();});await page.waitForFunction(()=>document.getElementById('hook-result-title').textContent.includes('服务器已接受'));
  check(calls.filter(c=>c.path==='windows/hook/confirm').length===1&&!(await page.locator('#hook-result-title').innerText()).includes('本机发送记录'),'confirmation_is_single_use_and_server_ack_is_not_local_record_proof');
  await page.clock.runFor(3100);await page.waitForFunction(()=>document.getElementById('hook-result-title').textContent==='本机发送记录已核对');
  check(attemptCount===1&&(await page.locator('#hook-result-evidence').innerText()).includes('不表示收件端'),'only_attempt_readback_shows_local_record_confirmation_without_delivery_claim');
  await page.locator('#hook-next').click();confirmStatus='unknown';attemptStatus='unknown';attemptCount=0;await prepare('第二条合成消息');await page.locator('#hook-confirmed').check();await page.locator('#hook-confirm').click();await page.waitForFunction(()=>document.getElementById('hook-result-title').textContent.includes('结果未知'));
  for(let i=1;i<=10;i++){await page.clock.runFor(3100);await page.waitForFunction(n=>document.getElementById('hook-result-detail').textContent.includes('合成查询 '+n),i);}
  await page.clock.runFor(12000);
  check(attemptCount===10&&(await page.locator('#hook-result-title').innerText()).includes('上限')&&calls.filter(c=>c.path==='windows/hook/confirm').length===2,'unknown_result_stops_after_ten_read_only_queries_without_resend');
  await page.locator('#hook-next').click();await prepare('待失效的合成消息');state.watchedGroups=['fixture-a'];await page.clock.runFor(2500);await page.waitForFunction(()=>document.getElementById('hook-prepared').hidden);
  check(await page.locator('#hook-confirm').isDisabled(),'removing_target_from_watch_scope_invalidates_prepared_confirmation');
  await page.setViewportSize({width:390,height:844});
  check(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth)&&errors.length===0,'hook_form_fits_390px_and_has_no_javascript_errors');
  check(!calls.some(c=>c.path.startsWith('windows/send/')||c.path==='send'||c.path.startsWith('windows/preview')),'hook_ui_never_calls_visual_or_legacy_send_endpoints');
  return {checks,allApis:'synthetic',realHookProbeOrSend:false};
 }finally{page.off('pageerror',onError);await page.clock.resume();await page.unroute('**/api/**',handler);await page.setViewportSize({width:1440,height:1000});await page.reload();}
}
