// playwright-cli run-code --filename web_mvp/diagnostics/check_sender_ui.js
// All API responses and both screenshots are synthetic. No native reads/writes occur.
async (page) => {
 const checks=[],calls=[],errors=[];
 const check=(value,name)=>{if(!value)throw Error(name);checks.push(name);};
 const onError=error=>errors.push(error.message);
 const images=await page.evaluate(()=>{const canvas=document.createElement('canvas');canvas.width=1000;canvas.height=600;const ctx=canvas.getContext('2d');ctx.fillStyle='#eef2f0';ctx.fillRect(0,0,1000,600);ctx.fillStyle='#345347';ctx.font='28px sans-serif';ctx.fillText('SYNTHETIC ONLY · 文件传输助手',40,55);ctx.fillStyle='white';ctx.fillRect(30,400,940,180);ctx.strokeStyle='#698a78';ctx.strokeRect(30,400,940,180);ctx.fillStyle='#2b8b69';ctx.fillRect(800,505,140,50);ctx.fillStyle='white';ctx.fillText('发送',840,540);const empty=canvas.toDataURL('image/png');ctx.fillStyle='#345347';ctx.fillText('本次合成文本，绝无真实发送',55,445);return {empty,staged:canvas.toDataURL('image/png')};});
 const source={id:'fixture-source',revision:'r1',status:'snapshot_ready',sourceRoot:'D:\\Synthetic\\db',createdAt:'2026-09-26T06:00:00Z',updatePolicy:'on_change',pollIntervalSeconds:5};
 const runtime={mode:'database',platform:'Windows',connected:true,source,capabilities:{desktopSend:true,canSend:false,read:true,media:false,mentions:false}};
 const state={runtime,connection:{status:'snapshot_ready'},account:'fixture-account',csrfToken:'fixture-csrf',groups:[],watchedGroups:[],jobs:[],outbox:[],selected:null};
 const database={mode:'database',configured:true,busy:false,config:{sourceRoot:source.sourceRoot,selfId:'',keyFile:'',autoRefresh:true},source,error:null};
 let available=false,delayPreview=false,releasePreview,finishPreview,stageImage=true,lastText='',expiryMs=60000;
 const completedPreview=()=>new Promise(resolve=>{finishPreview=resolve;});
 const responseImage=(staged=false)=>({imageDataUrl:staged?images.staged:images.empty,width:1000,height:600,expiresAt:new Date(Date.now()+expiryMs).toISOString()});
 const handler=async route=>{
  const request=route.request(),path=request.url().split('?')[0].split('/api/')[1],body=request.method()==='POST'?request.postDataJSON():null;calls.push({path,body});
  if(path==='state')return route.fulfill({json:state});
  if(path==='database')return route.fulfill({json:database});
  if(path==='environment')return route.fulfill({json:{...runtime,checks:[],limitations:[]}});
  if(path==='database/configure'){database.config=body;source.updatePolicy=body.autoRefresh?'on_change':'manual';return route.fulfill({json:{ok:true,...database}});}
  if(path==='windows/sender')return route.fulfill({json:{supported:true,available,status:available?'available':'blocked',issue:available?'':'合成窗口暂不具备可用性',targetId:'filehelper',windows:[{pid:101,hwnd:202,title:'合成微信窗口',visible:true,minimized:false}]}});
  if(path==='windows/send/preview'){
   if(delayPreview)await new Promise(resolve=>{releasePreview=resolve;});
   await route.fulfill({json:{status:'preview',previewToken:'fixture-preview',targetId:'filehelper',...responseImage()}});if(finishPreview)finishPreview();return;
  }
  if(path==='windows/send/stage'){lastText=body.text;return route.fulfill({json:{status:'staged',draftId:'fixture-draft',textHash:'fixture-hash',text:body.text,targetId:'filehelper',...responseImage(true),...(stageImage?{}:{imageDataUrl:undefined})}});}
  if(path==='windows/send/confirm')return route.fulfill({json:{status:'submitted_unconfirmed',issue:'合成提交，不代表真实发送'}});
  return route.fulfill({status:409,json:{error:'Synthetic fixture blocks this API.'}});
 };
 const detect=async()=>{await page.locator('#desktop-sender-detect').click();await page.waitForFunction(()=>document.getElementById('desktop-sender-badge').textContent==='可进行预检');};
 const preview=async()=>{await page.locator('#desktop-sender-prepare').click();await page.waitForFunction(()=>document.querySelector('#desktop-sender-visual img')?.complete&&document.querySelector('#desktop-sender-visual img')?.naturalWidth===1000);};
 const choose=async()=>{const img=page.locator('#desktop-sender-visual img'),box=await img.boundingBox();await img.click({position:{x:box.width*.2,y:box.height*.8}});await img.click({position:{x:box.width*.85,y:box.height*.88}});await page.locator('#desktop-sender-target-check').check();await page.locator('#desktop-sender-empty-check').check();};
 const stage=async()=>{await choose();await page.locator('#desktop-sender-stage').click();await page.waitForFunction(()=>!document.getElementById('desktop-sender-prepared').hidden);};
 await page.route('**/api/**',handler);page.on('pageerror',onError);
 try{
  await page.setViewportSize({width:1000,height:900});await page.reload();
  await page.waitForFunction(()=>!document.getElementById('desktop-sender-entry').hidden);
  check(await page.locator('#composer-controls').isHidden()&&!calls.some(call=>call.path.startsWith('windows/')),'module_capability_exposes_independent_entry_without_group_send_or_auto_probe');
  await page.locator('#desktop-sender-entry').click();await page.locator('#desktop-sender-detect').click();
  await page.waitForFunction(()=>document.getElementById('desktop-sender-badge').textContent==='暂不可用');await page.locator('#desktop-sender-text').fill('合成正文第一版');
  check(await page.locator('#desktop-sender-prepare').isDisabled(),'module_presence_does_not_override_actual_unavailability');
  available=true;await detect();await preview();
  check(await page.locator('#desktop-sender-stage').isDisabled()&&await page.locator('#desktop-sender-prepared').isHidden()&&!calls.some(call=>call.path.endsWith('/stage')||call.path.endsWith('/confirm')),'preview_is_read_only_and_requires_points_and_explicit_checks');
  await page.locator('#desktop-sender-text').fill('本次合成文本，绝无真实发送');
  check(await page.locator('#desktop-sender-visual').isHidden(),'editing_text_invalidates_the_previous_preview_token');
  await preview();await choose();await page.evaluate(()=>{const button=document.getElementById('desktop-sender-stage');button.click();button.click();});await page.waitForFunction(()=>!document.getElementById('desktop-sender-prepared').hidden);
  check(calls.filter(call=>call.path==='windows/send/stage').length===1,'rapid_stage_clicks_fill_the_draft_only_once');
  const sentStage=calls.find(call=>call.path==='windows/send/stage');
  check(Math.abs(sentStage.body.composePoint[0]-200)<=3&&Math.abs(sentStage.body.composePoint[1]-480)<=3&&Math.abs(sentStage.body.sendPoint[0]-850)<=3&&sentStage.body.targetConfirmed&&sentStage.body.emptyDraftConfirmed,'scaled_image_clicks_submit_original_pixel_coordinates_and_explicit_assertions');
  check(await page.locator('#desktop-sender-confirm').isDisabled()&&await page.locator('#desktop-sender-text').isDisabled()&&(await page.locator('#desktop-sender-confirm-text').innerText())===lastText,'staged_text_needs_new_confirmation_and_cannot_change_after_staging');
  await page.locator('#desktop-sender-panel').screenshot({path:'output/playwright/desktop-sender-fixture.png'});
  await page.locator('#desktop-sender-confirmed').check();
  await page.waitForFunction(()=>!document.getElementById('desktop-sender-confirm').disabled);
  await page.locator('#desktop-sender-confirm').click();
  await page.waitForFunction(()=>document.getElementById('desktop-sender-badge').textContent.includes('未确认送达'));
  await page.locator('#desktop-sender-confirm').dispatchEvent('click');
  check(calls.filter(call=>call.path==='windows/send/confirm').length===1&&await page.locator('#desktop-sender-prepare').isDisabled()&&(await page.locator('#desktop-sender-result').innerText()).includes('不会自动重试'),'confirmation_is_single_use_and_submitted_unconfirmed_never_claims_delivery');
  check(calls.filter(call=>call.path.startsWith('windows/send/')).every(call=>!('sourceRoot'in call.body)&&!('account'in call.body))&&calls.find(call=>call.path.endsWith('/confirm')).body.textConfirmed===true,'sender_requests_never_supply_database_identity_and_final_confirm_checks_text');
  await detect();expiryMs=300;await preview();await page.waitForFunction(()=>document.getElementById('desktop-sender-result').textContent.includes('截图已过期'));expiryMs=60000;
  check(await page.locator('#desktop-sender-visual').isHidden()&&await page.locator('#desktop-sender-confirm').isDisabled(),'expired_preview_cannot_stage_or_confirm');
  await preview();await stage();source.revision='r2';
  await (await page.waitForResponse(response=>response.url().endsWith('/api/state'))).finished();await page.evaluate(()=>new Promise(requestAnimationFrame));
  check(await page.locator('#desktop-sender-prepared').isVisible(),'automatic_snapshot_revision_keeps_the_same_identity_send_confirmation');
  source.id='fixture-source-two';state.account='fixture-account-two';
  await page.waitForFunction(()=>document.getElementById('desktop-sender-prepared').hidden&&document.getElementById('desktop-sender-badge').textContent==='尚未检测');
  check(await page.locator('#desktop-sender-confirm').isDisabled()&&await page.locator('#desktop-sender-visual').isHidden(),'source_identity_change_discards_staged_tokens_and_private_images');
  await detect();await page.locator('#desktop-sender-text').fill('合成缺少截图验证');await preview();await choose();stageImage=false;
  await page.locator('#desktop-sender-stage').click();await page.waitForFunction(()=>document.getElementById('desktop-sender-result').textContent.includes('新截图'));
  check(await page.locator('#desktop-sender-prepared').isHidden()&&await page.locator('#desktop-sender-confirm').isDisabled(),'missing_post_stage_image_blocks_final_confirmation');
  stageImage=true;await detect();delayPreview=true;const pending=completedPreview();await page.locator('#desktop-sender-prepare').click();
  await page.waitForFunction(()=>document.getElementById('desktop-sender-prepare').textContent.includes('正在获取'));
  await page.locator('[data-view="workspace"]').click();releasePreview();await pending;delayPreview=false;await page.locator('#desktop-sender-entry').click();
  check(await page.locator('#desktop-sender-visual').isHidden()&&await page.locator('#desktop-sender-prepare').isDisabled(),'late_preview_after_navigation_cannot_restore_window_binding_or_image');
  check(await page.locator('#database-auto-refresh').isChecked()&&(await page.locator('#runtime-detail').innerText()).includes('自动检查'),'automatic_database_receive_is_labeled_by_actual_update_policy');
  await page.locator('#database-auto-refresh').uncheck();await page.locator('#database-configure').click();await page.waitForFunction(()=>document.getElementById('runtime-detail').textContent.includes('手动'));
  check(calls.find(call=>call.path==='database/configure').body.autoRefresh===false,'automatic_receive_can_be_disabled_in_source_configuration');
  await page.setViewportSize({width:390,height:844});
  check(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth)&&errors.length===0,'sender_panel_has_no_390px_overflow_or_javascript_errors');
  return {checks,allApis:'synthetic',realWindowsReadOrSend:false};
 }finally{if(releasePreview)releasePreview();page.off('pageerror',onError);await page.unroute('**/api/**',handler);await page.setViewportSize({width:1440,height:1000});await page.reload();}
}
