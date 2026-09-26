// Synthetic API exercise for the workspace composer. No real account or Hook is contacted.
async page=>{
 const checks=[],calls=[],errors=[];const check=(ok,name)=>{if(!ok)throw Error(name);checks.push(name);};const onError=error=>errors.push(error.message);
 const groups=[{id:'filehelper',name:'文件传输助手'},{id:'fixture-group@chatroom',name:'合成项目群'},{id:'fixture-readonly',name:'未读取好友'},{id:'fixture-scopedout',name:'桥未开放会话'}],source={id:'fixture-source',revision:'r1',status:'snapshot_ready',createdAt:'2026-09-26T06:00:00Z',updatePolicy:'on_change'};
 const runtime={mode:'database',platform:'Windows',connected:true,source,databaseState:{busy:false,error:''},capabilities:{read:true,canSend:false,hookSendInterface:true,media:false,mentions:false}};
 const state={runtime,account:'fixture-account',csrfToken:'fixture',connection:{status:'snapshot_ready'},selected:'filehelper',groups,watchedGroups:['filehelper','fixture-group@chatroom','fixture-scopedout'],jobs:[],outbox:[]};
 let bridgeState='stopped',draftNumber=0,currentDraft=null;const status=()=>({supported:true,available:bridgeState==='ready',bridgeConfigured:bridgeState==='ready',bridgeState,targetIds:bridgeState==='ready'?['filehelper','fixture-group@chatroom']:[],clientVersion:'4.1.fixture',arch:'x64',moduleName:'Synthetic.dll',moduleSha256:'1234567890abcdef'.repeat(4),processId:123,issue:bridgeState==='stopped'?'点击连接发送':''});
 const handler=route=>{const req=route.request(),path=req.url().split('?')[0].split('/api/')[1],body=req.method()==='POST'?req.postDataJSON():null;calls.push({path,body});
  if(path==='state')return route.fulfill({json:state});
  if(path==='environment')return route.fulfill({json:{...runtime,checks:[],limitations:[]}});
  if(path==='database')return route.fulfill({json:{mode:'database',configured:true,config:{sourceRoot:'D:\\Synthetic',autoRefresh:true},source,busy:false}});
  if(path==='select'){state.selected=body.groupId;return route.fulfill({json:{ok:true}});}
  if(path==='group'||path==='messages')return route.fulfill({json:{watching:true,members:[],messages:[],outbox:[],reply:{enabled:false}}});
  if(path==='windows/hook/status'){const data=status();if(bridgeState==='starting')bridgeState='ready';return route.fulfill({json:data});}
  if(path==='windows/hook/start'){bridgeState='starting';return route.fulfill({json:status()});}
  if(path==='windows/hook/stop'){bridgeState='stopped';return route.fulfill({json:status()});}
  if(path==='windows/hook/prepare'){currentDraft={status:'prepared',draftId:'fixture-'+(++draftNumber),textHash:'fixture-hash',text:body.text,targetId:body.targetId,targetName:groups.find(group=>group.id===body.targetId)?.name,expiresAt:Date.now()+120000};return route.fulfill({json:currentDraft});}
  if(path==='windows/hook/confirm')return route.fulfill({json:{...currentDraft,status:'submitted_unconfirmed',serverAccepted:false,localRecordConfirmed:false}});
  if(path==='windows/hook/attempt')return route.fulfill({json:{...currentDraft,status:'local_record_observed',serverAccepted:false,localRecordObserved:true,localRecordConfirmed:false}});
  return route.fulfill({status:409,json:{error:'Synthetic fixture does not implement this API.'}});
 };
 await page.route('**/api/**',handler);page.on('pageerror',onError);
 try{
  await page.setViewportSize({width:1440,height:1000});await page.goto('http://127.0.0.1:8787/');await page.waitForFunction(()=>document.getElementById('selected-name').textContent==='文件传输助手'&&!document.getElementById('hook-start').disabled);
  check(await page.locator('#composer-controls').isVisible()&&await page.locator('#send-button').isDisabled()&&!calls.some(c=>c.path==='windows/hook/start'),'ordinary_composer_starts_disconnected_without_implicit_attach');
  await page.locator('#hook-start').click();await page.waitForFunction(()=>document.getElementById('hook-start').textContent==='正在连接…');await page.waitForFunction(()=>document.getElementById('hook-composer-status').textContent==='微信已连接');
  for(const [targetId,targetName,text] of [['filehelper','文件传输助手','中文收发验证😀\n第一条'],['fixture-group@chatroom','合成项目群','项目群合成发送内容']]){
   await page.locator('.group-item').filter({hasText:targetName}).click();await page.waitForFunction(name=>document.getElementById('selected-name').textContent===name,targetName);
   await page.locator('#message-text').fill(text);await page.locator('#send-button').click();await page.waitForFunction(()=>!document.getElementById('hook-prepared').hidden);
   check(await page.locator('#hook-bound-text').innerText()===text&&(await page.locator('#hook-bound-target').innerText()).includes(targetName)&&calls.filter(call=>call.path==='windows/hook/prepare').at(-1).body.targetId===targetId,'preview_binds_selected_target_and_text_'+draftNumber);
   if(draftNumber===1){
    const selectsBefore=calls.filter(call=>call.path==='select').length;source.revision='r2';state.selected='fixture-scopedout';
    await page.evaluate(()=>poll());await page.waitForFunction(()=>state.runtime.source.revision==='r2'&&!pollBusy);
    check(await page.locator('#hook-prepared').isVisible()&&await page.locator('#message-text').inputValue()===text&&await page.locator('#selected-name').innerText()===targetName&&!await page.locator('#hook-confirm').isDisabled()&&calls.filter(call=>call.path==='select').length===selectsBefore,'same_source_snapshot_preserves_target_draft_confirmation_without_selection_post');
   }
   await page.locator('#hook-confirm').click();await page.waitForFunction(()=>document.getElementById('hook-result-title').textContent==='已提交 · 正在核对数据库');await page.waitForFunction(()=>document.getElementById('hook-result-title').textContent==='已发现新的本人消息');
   check((await page.locator('#hook-result-evidence').innerText()).includes('未取得服务器回执'),'database_observation_does_not_claim_ack_'+draftNumber);
   await page.locator('#hook-next').click();check(await page.locator('#message-text').inputValue()==='','next_message_editor_is_cleared_'+draftNumber);
  }
  check(calls.filter(c=>c.path==='windows/hook/confirm').length===2&&!calls.some(c=>c.path==='send'||c.path.startsWith('windows/send/')),'two_user_confirmations_make_exactly_two_hook_requests');
  await page.locator('#message-text').fill('切换会话后取消的草稿');await page.locator('#send-button').click();await page.waitForFunction(()=>!document.getElementById('hook-prepared').hidden);
  await page.locator('.group-item').filter({hasText:'未读取好友'}).click();await page.waitForFunction(()=>document.getElementById('selected-name').textContent==='未读取好友');check(await page.locator('#hook-prepared').isHidden()&&await page.locator('#hook-confirm').isDisabled(),'switching_conversation_cancels_previous_confirmation');check(await page.locator('#message-text').isDisabled()&&await page.locator('#send-button').isDisabled()&&(await page.locator('#send-reason').innerText()).includes('勾选当前会话'),'unwatched_conversation_requires_read_scope');
  await page.locator('.group-item').filter({hasText:'桥未开放会话'}).click();await page.waitForFunction(()=>document.getElementById('selected-name').textContent==='桥未开放会话');check(await page.locator('#message-text').isDisabled()&&await page.locator('#send-button').isDisabled()&&(await page.locator('#hook-composer-target').innerText()).includes('未开放此会话'),'bridge_target_scope_is_not_assumed_from_connection');
  await page.locator('.group-item').filter({hasText:'文件传输助手'}).click();await page.locator('#hook-stop').click();await page.waitForFunction(()=>!document.getElementById('hook-start').hidden);check(calls.filter(c=>c.path==='windows/hook/stop').length===1,'bridge_can_be_disconnected_from_workspace');
  await page.setViewportSize({width:390,height:844});check(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth)&&errors.length===0,'390px_layout_has_no_overflow_or_javascript_errors');
  await page.locator('#composer-controls').screenshot({path:'output/playwright/hook-composer-fixture.png'});
  return {checks,allApis:'synthetic',realHookProbeOrSend:false};
 }catch(error){throw Error(error.message+'; completed='+checks.join(',')+'; browserErrors='+errors.join(','));}finally{await page.goto('about:blank');page.off('pageerror',onError);await page.unroute('**/api/**',handler);}
}
