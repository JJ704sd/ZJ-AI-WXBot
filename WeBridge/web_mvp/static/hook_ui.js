'use strict';
let hookStatus=null,hookBusy='',hookDraft=null,hookAttempt=null,hookVersion=0,hookTimer=null,hookExpiryTimer=null,hookStatusTimer=null,hookNextStatusAt=0,hookScopeKey='';
const hookExpires=value=>typeof value==='number'?value*(value<1e12?1000:1):Date.parse(value||'');
const hookTargetWatched=id=>(state.watchedGroups||[]).includes(id)&&(state.groups||[]).some(group=>group.id===id);
const hookTargetAllowed=id=>hookTargetWatched(id)&&Array.isArray(hookStatus?.targetIds)&&hookStatus.targetIds.includes(id);
const hookContext=()=>({account:state.account,groupId:selected,targetId:selected,sourceId:state.runtime?.source?.id});
const hookSameContext=context=>context&&context.account===state.account&&context.groupId===selected&&context.sourceId===state.runtime?.source?.id&&hookTargetAllowed(context.groupId);
function hookReady(){return isDatabase()&&serviceAvailable&&online&&hookStatus?.available===true&&hookStatus?.bridgeConfigured===true;}
function discardHookDraft(){++hookVersion;clearTimeout(hookExpiryTimer);hookDraft=null;$('hook-prepared').hidden=true;$('hook-bound-text').textContent='';updateHookControls();}
function resetHookSender(){
 const uncertain=hookBusy==='confirm'||!!hookAttempt;discardHookDraft();clearTimeout(hookTimer);clearTimeout(hookStatusTimer);hookStatus=null;hookAttempt=null;hookNextStatusAt=0;
 $('hook-status-badge').textContent='尚未检查';$('hook-status-text').textContent='正在检查当前账号的发送连接。';$('hook-module-facts').replaceChildren();
 $('hook-result').hidden=!uncertain;if(uncertain){$('hook-result-title').textContent='原账号的发送结果需核实';$('hook-result-detail').textContent='账号已变化，请在原账号的微信中核对发送结果。';$('hook-result-evidence').textContent='';$('hook-next').hidden=true;}
 updateHookControls();
}
function updateHookSender(){
 $('hook-sender-entry').hidden=!isDatabase();
 const scopeKey=JSON.stringify([state.account,state.watchedGroups,(state.groups||[]).map(group=>group.id)]);if(scopeKey!==hookScopeKey){hookScopeKey=scopeKey;hookNextStatusAt=0;}
 if(hookDraft&&!hookSameContext(hookDraft.context))discardHookDraft();
 if(hookAttempt&&!hookAttempt.stopped&&!hookTargetWatched(hookAttempt.groupId)){clearTimeout(hookTimer);hookAttempt.stopped=true;hookAttempt.status='unknown';hookAttempt.issue='原目标已取消读取，请在微信核对结果。';renderHookAttempt();}
 updateHookControls();
 if(isDatabase()&&serviceAvailable&&!hookBusy&&Date.now()>=hookNextStatusAt){hookNextStatusAt=Date.now()+15000;checkHookStatus(false);}
}
function updateHookControls(){
 const busy=!!hookBusy,ready=hookReady(),target=hookTargetAllowed(selected),locked=!!hookDraft||!!hookAttempt,changing=['starting','stopping'].includes(hookStatus?.bridgeState);
 $('hook-check').disabled=busy||!serviceAvailable;$('hook-check').textContent=hookBusy==='status'?'正在检查…':'检查 Hook 状态';
 $('hook-start').hidden=ready;$('hook-stop').hidden=!ready;
 $('hook-start').disabled=busy||changing||!serviceAvailable||!online||databaseBusy;$('hook-stop').disabled=busy||changing||!!hookDraft||!!hookAttempt&&!hookAttempt.stopped;
 $('hook-start').textContent=hookBusy==='start'||hookStatus?.bridgeState==='starting'?'正在连接…':'连接发送';$('hook-stop').textContent=hookBusy==='stop'||hookStatus?.bridgeState==='stopping'?'正在断开…':'断开发送';
 $('hook-composer-status').textContent=ready?'微信已连接':hookStatus?.bridgeState==='starting'?'正在连接 Windows 微信…':hookStatus?.bridgeState==='stopping'?'正在断开发送…':hookStatus?.issue||'发送尚未连接';
 $('hook-composer-target').textContent=selected?'当前会话：'+groupName(selected)+' · '+(!hookTargetWatched(selected)?'请先勾选读取':!ready?'连接后检查发送能力':target?'可发送文本':'当前发送桥未开放此会话'):'选择左侧会话后编辑消息';
 $('hook-confirm').disabled=busy||databaseBusy||!ready||!hookDraft||!hookSameContext(hookDraft.context)||hookExpires(hookDraft?.expiresAt)<=Date.now();$('hook-cancel').disabled=busy;$('hook-next').disabled=busy;
 if(!isDatabase())return;
 const reason=!serviceAvailable?'本机服务未连接。':!online?'请先创建可读的数据库副本。':!selected?'选择左侧要收发消息的会话。':!hookTargetWatched(selected)?'请在“选择读取会话”中勾选当前会话。':!ready?(hookStatus?.issue||'点击“连接发送”连接这台电脑上的微信。'):!target?'当前发送桥未开放此会话，请在环境中重新检查连接能力。':databaseBusy?'正在更新数据库副本，请稍候。':groupLoadState!=='ready'?'正在读取当前会话，请稍候。':hookAttempt?'下方显示本次发送结果。':hookDraft?'核对下方目标和正文后确认发送。':!$('message-text').value.trim()?'输入文本后可核对并发送。':'';
 $('send-reason').textContent=reason;$('send-button').disabled=busy||changing||databaseBusy||locked||!ready||!target||groupLoadState!=='ready'||!$('message-text').value.trim();$('send-label').textContent=hookBusy==='prepare'?'正在准备…':'核对并发送';$('send-button').title=reason||'Ctrl + Enter 核对消息';$('message-text').disabled=busy&&hookBusy!=='status'||locked||!hookTargetWatched(selected)||ready&&!target;
}
function showHookIssue(title,detail){$('hook-result').hidden=false;$('hook-result-title').textContent=title;$('hook-result-detail').textContent=detail||'';$('hook-result-evidence').textContent='';$('hook-next').hidden=true;}
function renderHookStatus(data){
 hookStatus=data;const ready=hookReady();$('hook-status-badge').textContent=ready?'就绪':data.bridgeState==='starting'?'连接中':'未连接';
 $('hook-status-text').textContent=ready?'已连接当前账号；当前发送范围以工作台所选会话的状态为准。':data.issue||'到工作台点击“连接发送”以启用文本发送。';
 const facts=$('hook-module-facts');facts.replaceChildren();
 for(const [label,value,full] of [['微信模块版本',data.clientVersion||'未知'],['架构',data.arch||'未知'],['模块文件',data.moduleName||'未知'],['模块 SHA-256',data.moduleSha256?data.moduleSha256.slice(0,16)+'…':'未知',data.moduleSha256],['进程',data.processId?String(data.processId):'未知'],['本机 Hook 桥接',data.bridgeConfigured?'已配置':'未配置']]){const row=el('div','database-source-fact');row.append(el('small','',label));const text=el('span','',value);if(full)text.title=full;row.append(text);facts.append(row);}
 updateHookControls();clearTimeout(hookStatusTimer);
 if(['starting','stopping'].includes(data.bridgeState))hookStatusTimer=setTimeout(()=>checkHookStatus(false),1500);
}
async function checkHookStatus(manual=true){
 if(hookBusy)return;const version=hookVersion;hookBusy='status';updateHookControls();
 try{const data=await api('/api/windows/hook/status');if(version===hookVersion)renderHookStatus(data);}
 catch(error){if(version===hookVersion){hookStatus=null;$('hook-status-badge').textContent='检查失败';$('hook-status-text').textContent=error.message;if(manual)showHookIssue('连接检查未完成',error.message);}}
 finally{hookBusy='';hookNextStatusAt=Date.now()+15000;updateHookControls();}
}
async function setHookConnection(action){
 if(hookBusy||$(action==='start'?'hook-start':'hook-stop').disabled)return;discardHookDraft();const version=hookVersion,account=state.account;hookBusy=action;updateHookControls();
 try{const data=await api('/api/windows/hook/'+action,{account});if(version===hookVersion&&account===state.account)renderHookStatus(data);}
 catch(error){if(version===hookVersion){hookStatus=null;showHookIssue('连接操作未完成',error.message);hookStatusTimer=setTimeout(()=>checkHookStatus(false),1500);}}
 finally{hookBusy='';updateHookControls();}
}
$('hook-sender-entry').onclick=()=>{setView('workspace');$('composer-controls').scrollIntoView({behavior:'smooth',block:'start'});$('message-text').focus({preventScroll:true});};
$('hook-check').onclick=()=>checkHookStatus();$('hook-start').onclick=()=>setHookConnection('start');$('hook-stop').onclick=()=>setHookConnection('stop');
async function prepareHookMessage(){
 if(hookBusy||$('send-button').disabled)return;
 const context=hookContext(),text=$('message-text').value;discardHookDraft();const version=hookVersion;hookBusy='prepare';$('hook-result').hidden=true;updateHookControls();
 try{
  const data=await api('/api/windows/hook/prepare',{account:context.account,groupId:context.groupId,targetId:context.targetId,text,idempotencyKey:crypto.randomUUID()});
  if(version!==hookVersion||!hookSameContext(context))return;
  const expiry=hookExpires(data.expiresAt);
  if(data.status!=='prepared'||!data.draftId||!data.textHash||data.text!==text||data.targetId!==context.targetId||!Number.isFinite(expiry)||expiry<=Date.now()){showHookIssue('发送准备未完成',data.issue||data.error||'请重新核对目标和正文。');return;}
  hookDraft={...data,context};$('hook-bound-target').textContent='发送到：'+(data.targetName||groupName(context.groupId));$('hook-bound-text').textContent=data.text;$('hook-expiry').textContent='确认有效至 '+stamp(expiry/1000,{hour:'2-digit',minute:'2-digit',second:'2-digit'});$('hook-prepared').hidden=false;$('hook-confirm').focus();
  hookExpiryTimer=setTimeout(()=>{discardHookDraft();showHookIssue('确认已过期','请重新核对消息后发送。');},Math.min(expiry-Date.now(),2147483647));
 }catch(error){if(version===hookVersion)showHookIssue('发送准备未完成',error.message);}
 finally{hookBusy='';updateHookControls();}
}
$('hook-cancel').onclick=()=>{if(hookBusy)return;discardHookDraft();$('message-text').focus();};
function renderHookAttempt(){
 const attempt=hookAttempt;if(!attempt)return;
 const titles={pending:'正在提交',submitted_unconfirmed:'已提交 · 正在核对数据库',server_accepted:'服务器已接受 · 正在核对数据库',local_record_observed:'已发现新的本人消息',local_record_confirmed:'已核对精确发送记录',unknown:'结果待核实',blocked:'发送未执行',expired:'确认已过期'};
 $('hook-result').hidden=false;$('hook-result-title').textContent=attempt.exhausted?'尚未匹配到发送记录':titles[attempt.status]||titles.unknown;
 $('hook-result-detail').textContent='目标：'+attempt.targetName+'。'+(attempt.issue||'')+(attempt.exhausted?'请在微信核对后再继续。':'');
 $('hook-result-evidence').textContent=attempt.status==='blocked'||attempt.status==='expired'?'本次未发送。':attempt.status==='local_record_observed'?'数据库副本出现一条新增的本人同文本记录；未取得服务器回执。':attempt.status==='local_record_confirmed'?(attempt.serverAccepted?'服务器回执和本机数据库记录均已核对。':'已在本机数据库副本中匹配到新增的本人消息。')+' 此状态不代表收件端已读。':'正在等待新增数据库记录；工作台不会自动重发。';
 $('hook-next').hidden=!attempt.stopped;$('hook-next').textContent=['local_record_observed','local_record_confirmed'].includes(attempt.status)?'编辑下一条':'已核对微信，继续编辑';updateHookControls();
}
function applyHookAttempt(data,fromLookup=false){
 if(!hookAttempt)return;
 if(['local_record_observed','local_record_confirmed'].includes(data.status)&&!fromLookup)data={...data,status:data.serverAccepted?'server_accepted':'submitted_unconfirmed'};
 const statuses=['submitted_unconfirmed','server_accepted','local_record_observed','local_record_confirmed','unknown','blocked','expired'];
 if(data.draftId&&data.draftId!==hookAttempt.draftId||data.targetId&&data.targetId!==hookAttempt.groupId){hookAttempt.status='unknown';hookAttempt.issue='结果关联信息不一致，请在微信核对。';hookAttempt.stopped=true;}
 else{hookAttempt.status=statuses.includes(data.status)?data.status:'unknown';hookAttempt.serverAccepted=data.serverAccepted===true;hookAttempt.issue=data.issue||data.error||'';hookAttempt.stopped=['local_record_observed','local_record_confirmed','blocked','expired'].includes(hookAttempt.status);}
 if(!hookAttempt.stopped&&hookAttempt.queries>=10){hookAttempt.exhausted=true;hookAttempt.stopped=true;}
 renderHookAttempt();
 if(!hookAttempt.stopped){clearTimeout(hookTimer);hookTimer=setTimeout(queryHookAttempt,3000);}
 else if(['local_record_observed','local_record_confirmed'].includes(hookAttempt.status))poll();
}
async function queryHookAttempt(){
 const attempt=hookAttempt;if(!attempt||attempt.stopped)return;
 attempt.queries++;
 try{const data=await api('/api/windows/hook/attempt?'+new URLSearchParams({draftId:attempt.draftId,account:attempt.account}));if(hookAttempt===attempt)applyHookAttempt(data,true);}
 catch(error){if(hookAttempt===attempt)applyHookAttempt({status:'unknown',issue:'记录查询未完成：'+error.message});}
}
$('hook-confirm').onclick=async()=>{
 if(hookBusy||$('hook-confirm').disabled||!hookDraft)return;
 const draft=hookDraft,context=draft.context;discardHookDraft();hookBusy='confirm';
 hookAttempt={draftId:draft.draftId,account:context.account,groupId:context.groupId,targetName:draft.targetName||groupName(context.groupId),text:draft.text,status:'pending',queries:0,stopped:false};renderHookAttempt();updateHookControls();const attempt=hookAttempt;
 try{const data=await api('/api/windows/hook/confirm',{account:context.account,groupId:context.groupId,draftId:draft.draftId,textHash:draft.textHash,targetConfirmed:true});if(hookAttempt===attempt)applyHookAttempt(data);}
 catch(error){if(hookAttempt===attempt)applyHookAttempt({status:'unknown',issue:error.message});}
 finally{hookBusy='';updateHookControls();}
};
$('hook-next').onclick=()=>{if(hookBusy||!hookAttempt?.stopped)return;clearTimeout(hookTimer);if(hookAttempt.account===state.account&&hookAttempt.groupId===selected&&$('message-text').value===hookAttempt.text&&['local_record_observed','local_record_confirmed'].includes(hookAttempt.status)){$('message-text').value='';$('message-text').oninput();}hookAttempt=null;$('hook-result').hidden=true;updateHookControls();$('message-text').focus();};
document.addEventListener('visibilitychange',()=>{if(document.hidden)discardHookDraft();});window.addEventListener('pagehide',()=>{discardHookDraft();clearTimeout(hookTimer);clearTimeout(hookStatusTimer);});
