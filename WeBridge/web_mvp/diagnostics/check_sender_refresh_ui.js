// Focused follow-up to check_sender_ui.js. All API and image data are synthetic.
async (page)=>{
 const checks=[],errors=[];const check=(ok,name)=>{if(!ok)throw Error(name);checks.push(name);};
 const onError=e=>errors.push(e.message);
 const imageDataUrl=await page.evaluate(()=>{const c=document.createElement('canvas');c.width=100;c.height=60;const x=c.getContext('2d');x.fillStyle='#e7efe9';x.fillRect(0,0,100,60);return c.toDataURL('image/png');});
 const source={id:'fixture-id',revision:'r1',status:'snapshot_ready',sourceRoot:'D:\\Synthetic\\db',createdAt:'2026-09-26T06:00:00Z',updatePolicy:'on_change'};
 const runtime={mode:'database',connected:true,platform:'Windows',source,databaseState:{busy:false,error:''},capabilities:{desktopSend:true,canSend:false,read:true,media:false}};
 const state={runtime,account:'fixture-account',csrfToken:'fixture',connection:{status:'snapshot_ready'},groups:[],selected:null,watchedGroups:[],jobs:[],outbox:[]};
 let refuseDetails=false;
 const image=()=>({imageDataUrl,width:100,height:60,targetId:'filehelper',expiresAt:new Date(Date.now()+60000).toISOString()});
 const handler=route=>{
  const req=route.request(),path=req.url().split('?')[0].split('/api/')[1];
  if(path==='state')return route.fulfill({json:state});
  if(path==='database')return route.fulfill(refuseDetails?{status:503,json:{error:'合成详情查询不可用'}}:{json:{mode:'database',configured:true,config:{sourceRoot:source.sourceRoot,autoRefresh:true},source,...runtime.databaseState}});
  if(path==='environment')return route.fulfill({json:{...runtime,checks:[],limitations:[]}});
  if(path==='windows/sender')return route.fulfill({json:{supported:true,available:true,targetId:'filehelper',windows:[{pid:1,hwnd:2,title:'合成窗口',visible:true}]}});
  if(path==='windows/send/preview')return route.fulfill({json:{status:'preview',previewToken:'fixture-preview',...image()}});
  if(path==='windows/send/stage')return route.fulfill({json:{status:'staged',draftId:'fixture-draft',textHash:'fixture-hash',text:req.postDataJSON().text,...image()}});
  return route.fulfill({status:409,json:{error:'This focused fixture prohibits confirmation and other APIs.'}});
 };
 await page.route('**/api/**',handler);page.on('pageerror',onError);
 try{
  await page.reload();await page.waitForFunction(()=>!document.getElementById('desktop-sender-entry').hidden);await page.locator('#desktop-sender-entry').click();await page.locator('#desktop-sender-detect').click();
  await page.waitForFunction(()=>document.getElementById('desktop-sender-badge').textContent==='可进行预检');await page.locator('#desktop-sender-text').fill('合成，不能发送');await page.locator('#desktop-sender-prepare').click();
  await page.waitForFunction(()=>document.querySelector('#desktop-sender-visual img')?.naturalWidth===100);
  await page.locator('#desktop-sender-visual img').click({position:{x:20,y:40}});await page.locator('#desktop-sender-visual img').click({position:{x:80,y:50}});await page.locator('#desktop-sender-target-check').check();await page.locator('#desktop-sender-empty-check').check();await page.locator('#desktop-sender-stage').click();
  await page.waitForFunction(()=>!document.getElementById('desktop-sender-prepared').hidden);source.revision='r2';
  await (await page.waitForResponse(r=>r.url().endsWith('/api/state'))).finished();await page.evaluate(()=>new Promise(requestAnimationFrame));
  check(await page.locator('#desktop-sender-prepared').isVisible()&&(await page.locator('#desktop-sender-confirm-text').innerText())==='合成，不能发送','normal_snapshot_revision_preserves_same_identity_staged_confirmation');
  source.id='fixture-next';state.account='fixture-next-account';await page.waitForFunction(()=>document.getElementById('desktop-sender-prepared').hidden);
  check(await page.locator('#desktop-sender-visual').isHidden()&&await page.locator('#desktop-sender-confirm').isDisabled(),'source_identity_change_clears_staged_confirmation_and_image');
  refuseDetails=true;runtime.databaseState.busy=true;await page.waitForFunction(()=>document.getElementById('database-source-root').disabled);
  check(await page.locator('#database-configure').isDisabled()&&await page.locator('#refresh-button').isDisabled(),'state_poll_alone_locks_source_controls_during_automatic_copy');
  runtime.databaseState.busy=false;runtime.databaseState.error='自动接收更新失败（合成）';await page.waitForFunction(()=>document.getElementById('global-error').textContent.includes('自动接收更新失败'));
  check((await page.locator('#database-source-summary').textContent()).includes('更新失败')&&!await page.locator('#database-source-root').isDisabled()&&errors.length===0,'state_poll_exposes_auto_receive_failure_when_database_details_fail');
  return {checks,allApis:'synthetic',realWindowsReadOrSend:false};
 }finally{page.off('pageerror',onError);await page.unroute('**/api/**',handler);await page.reload();}
}
