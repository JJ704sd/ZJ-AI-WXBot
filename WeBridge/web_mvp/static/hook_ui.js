'use strict';
let hookStatus=null,hookBusy='',hookDraft=null,hookAttempt=null,hookVersion=0,hookTimer=null,hookExpiryTimer=null,hookTargetsKey='';
const hookExpires=value=>typeof value==='number'?value*(value<1e12?1000:1):Date.parse(value||'');
const hookTargetAllowed=id=>(state.watchedGroups||[]).includes(id)&&(state.groups||[]).some(group=>group.id===id);
const hookContext=()=>({account:state.account,groupId:selected,targetId:selected,sourceId:state.runtime?.source?.id});
const hookSameContext=context=>context&&context.account===state.account&&context.groupId===selected&&context.sourceId===state.runtime?.source?.id&&hookTargetAllowed(context.groupId);
function hookReady(){return isDatabase()&&serviceAvailable&&online&&hookStatus?.available===true&&hookStatus?.bridgeConfigured===true&&!!hookStatus.clientVersion&&/^[a-f\d]{64}$/i.test(hookStatus.moduleSha256||'');}
function discardHookDraft(){++hookVersion;clearTimeout(hookExpiryTimer);hookDraft=null;$('hook-prepared').hidden=true;$('hook-confirmed').checked=false;$('hook-bound-text').textContent='';updateHookControls();}
function resetHookSender(){
 const uncertain=hookBusy==='confirm'||!!hookAttempt;discardHookDraft();clearTimeout(hookTimer);hookStatus=null;hookAttempt=null;$('hook-send-text').value='';
 $('hook-status-badge').textContent='尚未检查';$('hook-status-text').textContent='数据源身份已变化，请重新检查 Hook 模块与账号。';$('hook-module-facts').replaceChildren();
 $('hook-result').hidden=!uncertain;if(uncertain){$('hook-result-title').textContent='原账号的发送结果需核实';$('hook-result-detail').textContent='账号已变化，工作台已停止查询；请在原账号的微信中核对，勿直接重复发送。';$('hook-result-evidence').textContent='';$('hook-next').hidden=true;}
 updateHookControls();
}
function updateHookSender(){
 $('hook-sender-entry').hidden=!isDatabase();
 const groups=(state.groups||[]).filter(group=>hookTargetAllowed(group.id)),key=JSON.stringify([state.account,groups]);
 if(key!==hookTargetsKey){hookTargetsKey=key;const select=$('hook-target-select');select.replaceChildren();const placeholder=el('option','','请先选择已读取会话');placeholder.value='';select.append(placeholder);for(const group of groups){const option=el('option','',group.name+' · '+group.id);option.value=group.id;select.append(option);}}
 $('hook-target-select').value=hookTargetAllowed(selected)?selected:'';
 if(hookDraft&&!hookSameContext(hookDraft.context))discardHookDraft();
 if(hookAttempt&&!hookAttempt.stopped&&!hookTargetAllowed(hookAttempt.groupId)){clearTimeout(hookTimer);hookAttempt.stopped=true;hookAttempt.status='unknown';hookAttempt.issue='原目标已取消读取，已停止查询；请在微信核对。';renderHookAttempt();}
 updateHookControls();
}
function updateHookControls(){
 const busy=!!hookBusy,ready=hookReady(),target=hookTargetAllowed(selected),locked=!!hookDraft||!!hookAttempt;
 $('hook-check').disabled=busy||!serviceAvailable;$('hook-check').textContent=hookBusy==='status'?'正在检查…':'检查 Hook 状态';
 $('hook-target-select').disabled=busy||locked||!serviceAvailable||!online;$('hook-send-text').disabled=busy||locked;
 const reason=!serviceAvailable?'本机服务未连接。':!hookStatus?'请先检查 Hook 模块与账号。':!ready?(hookStatus.issue||'模块版本、摘要或账号尚未通过校验。'):databaseBusy?'正在更新数据库副本，完成后才能预检或确认发送。':!target?'请先在读取范围中选择会话，再选定发送目标。':groupLoadState!=='ready'?'当前会话资料尚未读完，请稍候或重新选择会话。':hookAttempt?'请先核对上一条消息的发送结果。':!$('hook-send-text').value.trim()?'输入文本后可进行预检。':'';
 $('hook-send-reason').textContent=reason;$('hook-prepare').disabled=busy||databaseBusy||locked||!ready||!target||groupLoadState!=='ready'||!$('hook-send-text').value.trim();$('hook-prepare').textContent=hookBusy==='prepare'?'正在预检…':'预检这条消息';
 $('hook-confirm').disabled=busy||databaseBusy||!ready||!hookDraft||!hookSameContext(hookDraft.context)||hookExpires(hookDraft?.expiresAt)<=Date.now()||!$('hook-confirmed').checked;
 $('hook-confirmed').disabled=busy;$('hook-cancel').disabled=busy;$('hook-next').disabled=busy;
}
function showHookIssue(title,detail){$('hook-result').hidden=false;$('hook-result-title').textContent=title;$('hook-result-detail').textContent=detail||'';$('hook-result-evidence').textContent='';$('hook-next').hidden=true;}
function renderHookStatus(data){
 hookStatus=data;const ready=hookReady(),unadapted=data.supported===false||!data.bridgeConfigured||data.issueCode==='unsupported_version';$('hook-status-badge').textContent=ready?'就绪':unadapted?'未适配':'待校验';
 $('hook-status-text').textContent=ready?'模块与账号检查通过；每次发送仍由服务端重新校验。':data.issue||'缺少可信模块版本或摘要，发送保持关闭。';
 const facts=$('hook-module-facts');facts.replaceChildren();
 for(const [label,value,full] of [['微信模块版本',data.clientVersion||'未知'],['架构',data.arch||'未知'],['模块文件',data.moduleName||'未知'],['模块 SHA-256',data.moduleSha256?data.moduleSha256.slice(0,16)+'…':'未知',data.moduleSha256],['进程',data.processId?String(data.processId):'未知'],['本机 Hook 桥接',data.bridgeConfigured?'已配置':'未配置']]){const row=el('div','database-source-fact');row.append(el('small','',label));const text=el('span','',value);if(full)text.title=full;row.append(text);facts.append(row);}
 updateHookControls();
}
$('hook-sender-entry').onclick=()=>{setView('environment');$('hook-sender-panel').scrollIntoView({behavior:'smooth',block:'start'});$('hook-check').focus({preventScroll:true});};
$('hook-check').onclick=async()=>{
 if(hookBusy)return;discardHookDraft();const version=hookVersion;hookStatus=null;hookBusy='status';$('hook-status-badge').textContent='检查中';updateHookControls();
 try{const data=await api('/api/windows/hook/status');if(version===hookVersion)renderHookStatus(data);}
 catch(error){if(version===hookVersion){$('hook-status-badge').textContent='检查失败';$('hook-status-text').textContent=error.message;}}
 finally{hookBusy='';updateHookControls();}
};
$('hook-target-select').onchange=async()=>{
 const id=$('hook-target-select').value;if(hookBusy||hookDraft||hookAttempt||!hookTargetAllowed(id))return;discardHookDraft();hookBusy='select';updateHookControls();
 try{await selectGroup(id);await poll();}finally{hookBusy='';updateHookSender();}
};
$('hook-send-text').oninput=()=>{if(hookBusy||hookAttempt)return;discardHookDraft();$('hook-result').hidden=true;updateHookControls();};
$('hook-send-form').onsubmit=async event=>{
 event.preventDefault();if(hookBusy||$('hook-prepare').disabled)return;
 const context=hookContext(),text=$('hook-send-text').value;discardHookDraft();const version=hookVersion;hookBusy='prepare';$('hook-result').hidden=true;updateHookControls();
 try{
  const data=await api('/api/windows/hook/prepare',{account:context.account,groupId:context.groupId,targetId:context.targetId,text,idempotencyKey:crypto.randomUUID()});
  if(version!==hookVersion||!hookSameContext(context))return;
  const expiry=hookExpires(data.expiresAt);
  if(data.status!=='prepared'||!data.draftId||!data.textHash||data.text!==text||data.targetId!==context.targetId||typeof data.targetName!=='string'||!data.targetName.trim()||!Number.isFinite(expiry)||expiry<=Date.now()){showHookIssue('预检未通过',data.issue||data.error||'目标、正文或有效期未能完成校验；未发送消息。');return;}
  hookDraft={...data,context};$('hook-bound-target').textContent='服务端绑定目标：'+data.targetName+'（'+data.targetId+'）';$('hook-bound-text').textContent=data.text;$('hook-expiry').textContent='确认有效至 '+stamp(expiry/1000,{hour:'2-digit',minute:'2-digit',second:'2-digit'})+'（上海时间）';$('hook-confirm-label').textContent='我已核对“'+data.targetName+'”和正文，确认发送一次';$('hook-prepared').hidden=false;$('hook-confirmed').checked=false;
  hookExpiryTimer=setTimeout(()=>{discardHookDraft();showHookIssue('确认已过期','未发送，请重新预检。');},Math.min(expiry-Date.now(),2147483647));
 }catch(error){if(version===hookVersion)showHookIssue('预检未完成',error.message);}
 finally{hookBusy='';updateHookControls();}
};
$('hook-confirmed').onchange=updateHookControls;$('hook-cancel').onclick=()=>{if(hookBusy)return;discardHookDraft();showHookIssue('已取消确认','未调用发送接口。');};
function renderHookAttempt(){
 const attempt=hookAttempt;if(!attempt)return;
 const titles={pending:'正在提交 · 等待确认',submitted_unconfirmed:'已调用 Hook · 等待记录核对',server_accepted:'服务器已接受 · 待记录核对',local_record_confirmed:'本机发送记录已核对',unknown:'结果未知 · 请在微信核对',blocked:'发送已阻止',expired:'确认已过期'};
 $('hook-result').hidden=false;$('hook-result-title').textContent=attempt.exhausted?'查询已达上限 · 结果待核实':titles[attempt.status]||titles.unknown;
 $('hook-result-detail').textContent='目标：'+attempt.targetName+'。'+(attempt.issue||'')+(attempt.exhausted?'已查询 10 次，停止自动查询；请在微信核对。':'');
 $('hook-result-evidence').textContent=attempt.status==='blocked'||attempt.status==='expired'?'服务端已阻止本次发送。':attempt.status==='local_record_confirmed'?'已在本人数据库中核对精确消息记录，不表示收件端已送达或已读。':'接口返回或服务器接受不代表收件端送达。工作台不会自动重发。';
 $('hook-next').hidden=!attempt.stopped;updateHookControls();
}
function applyHookAttempt(data,fromLookup=false){
 if(!hookAttempt)return;
 if(data.status==='local_record_confirmed'&&!fromLookup)data={...data,status:data.serverAccepted?'server_accepted':'submitted_unconfirmed'};
 const statuses=['submitted_unconfirmed','server_accepted','local_record_confirmed','unknown','blocked','expired'];
 if(data.draftId&&data.draftId!==hookAttempt.draftId||data.targetId&&data.targetId!==hookAttempt.groupId){hookAttempt.status='unknown';hookAttempt.issue='结果关联信息不一致，请在微信核对。';hookAttempt.stopped=true;}
 else{hookAttempt.status=statuses.includes(data.status)?data.status:'unknown';hookAttempt.issue=data.issue||data.error||'';hookAttempt.stopped=['local_record_confirmed','blocked','expired'].includes(hookAttempt.status);}
 if(!hookAttempt.stopped&&hookAttempt.queries>=10){hookAttempt.exhausted=true;hookAttempt.stopped=true;}
 renderHookAttempt();
 if(!hookAttempt.stopped){clearTimeout(hookTimer);hookTimer=setTimeout(queryHookAttempt,3000);}
}
async function queryHookAttempt(){
 const attempt=hookAttempt;if(!attempt||attempt.stopped)return;
 if(attempt.queries>=10){attempt.stopped=true;attempt.exhausted=true;renderHookAttempt();return;}
 attempt.queries++;
 try{const data=await api('/api/windows/hook/attempt?'+new URLSearchParams({draftId:attempt.draftId,account:attempt.account}));if(hookAttempt===attempt)applyHookAttempt(data,true);}
 catch(error){if(hookAttempt===attempt)applyHookAttempt({status:'unknown',issue:'结果查询未完成：'+error.message});}
}
$('hook-confirm').onclick=async()=>{
 if(hookBusy||$('hook-confirm').disabled||!hookDraft)return;
 const draft=hookDraft,context=draft.context;discardHookDraft();hookBusy='confirm';
 hookAttempt={draftId:draft.draftId,account:context.account,groupId:context.groupId,targetName:draft.targetName,status:'pending',queries:0,stopped:false};renderHookAttempt();updateHookControls();
 const attempt=hookAttempt;
 try{const data=await api('/api/windows/hook/confirm',{account:context.account,groupId:context.groupId,draftId:draft.draftId,textHash:draft.textHash,targetConfirmed:true});if(hookAttempt===attempt)applyHookAttempt(data);}
 catch(error){if(hookAttempt===attempt)applyHookAttempt({status:'unknown',issue:error.message});}
 finally{hookBusy='';updateHookControls();}
};
$('hook-next').onclick=()=>{if(hookBusy||!hookAttempt?.stopped)return;clearTimeout(hookTimer);hookAttempt=null;$('hook-send-text').value='';$('hook-result').hidden=true;updateHookControls();};
document.addEventListener('visibilitychange',()=>{if(document.hidden)discardHookDraft();});window.addEventListener('pagehide',()=>{discardHookDraft();clearTimeout(hookTimer);});
