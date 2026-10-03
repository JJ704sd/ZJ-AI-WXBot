'use strict';
let handoffRows=[],handoffScope='',handoffVersion=0,handoffLoading=false,handoffNextAt=0;
let handoffPage=0,handoffCursors=[''],handoffHasMore=false,handoffDetail=null,handoffDetailVersion=0,handoffDetailLoading=false,handoffActionBusy=false;
let handoffOwnerDirty=false,handoffNoteDirty=false,handoffDetailId='',handoffActionVersion=0;
const handoffStatuses={pending:'待领取',in_progress:'处理中',completed:'已完成'};
const handoffActions={created:'创建待办',claim:'领取',release:'释放',complete:'完成',reopen:'重新打开',revoked:'原消息撤回'};
function supportsHandoffs(){return isDatabase()&&state.runtime?.capabilities?.automaticReplies===true;}
function handoffScopeKey(){return JSON.stringify([state.account,state.runtime?.mode,state.runtime?.source?.id,[...new Set(state.watchedGroups||[])].sort(),(state.groups||[]).map(group=>group.id).sort()]);}
function handoffPageControls(){
 $('handoff-prev').disabled=handoffLoading||!serviceAvailable||handoffPage===0;
 $('handoff-next').disabled=handoffLoading||!serviceAvailable||!handoffHasMore;
 $('handoff-refresh').disabled=handoffLoading||!serviceAvailable||!state.account;
 $('handoff-page').textContent='第 '+(handoffPage+1)+' 页';
}
function resetHandoffPage(){
 ++handoffVersion;handoffLoading=false;handoffNextAt=0;handoffRows=[];handoffPage=0;handoffCursors=[''];handoffHasMore=false;
 $('handoff-list').replaceChildren();$('handoff-message').textContent='';handoffPageControls();
}
function clearHandoffDetail(){
 ++handoffDetailVersion;++handoffActionVersion;handoffDetail=null;handoffDetailId='';handoffDetailLoading=false;handoffActionBusy=false;handoffOwnerDirty=false;handoffNoteDirty=false;
 $('handoff-detail-title').textContent='人工待办';$('handoff-history-note').textContent='';
 $('handoff-owner').value='';$('handoff-note').value='';$('handoff-detail-text').textContent='';$('handoff-detail-meta').textContent='';$('handoff-changes').replaceChildren();$('handoff-detail-message').textContent='';
}
function updateHandoffScope(){
 const scope=handoffScopeKey();
 if(scope!==handoffScope){
  handoffScope=scope;resetHandoffPage();clearHandoffDetail();$('handoff-dialog').close();
  const select=$('handoff-group'),chosen=select.value;select.replaceChildren();const all=el('option','','全部已读取群');all.value='';select.append(all);
  for(const group of state.groups||[])if((state.watchedGroups||[]).includes(group.id)&&group.id.endsWith('@chatroom')){const option=el('option','',group.name);option.value=group.id;select.append(option);}
  select.value=(state.groups||[]).some(group=>group.id===chosen&&(state.watchedGroups||[]).includes(chosen))?chosen:'';
 }
 $('handoff-notice').textContent='本机待办，未通知负责人。列表为已保存摘要；打开详情时核对最新副本中的撤回记录。任务操作不改变群规则，定时发送独立配置。';
 handoffPageControls();handoffDetailControls();
}
function handoffText(record){return record.revoked?'原消息已撤回，原文不再显示。':record.trigger.text;}
function renderHandoffs(){
 const list=$('handoff-list');list.replaceChildren();
 if(!handoffRows.length){list.append(emptyCard('暂无匹配的人工待办','在群规则中选择“转人工待办”并启用，后续真实 @ 本人的新消息会进入本机队列。','reply'));return;}
 for(const row of handoffRows){
  const card=el('article','handoff-row'),heading=el('div','execution-heading');
  heading.append(el('strong','',row.groupName),el('span','status-chip'+(row.status==='pending'?' off':''),handoffStatuses[row.status]));
  if(row.revoked)heading.append(el('span','label-badge','已撤回'));
  card.append(heading,el('p','subtle',row.trigger.senderName+' · '+stamp(row.trigger.timestamp,{month:'2-digit',day:'2-digit',hour:'2-digit',minute:'2-digit',second:'2-digit'})),el('p','handoff-preview',handoffText(row)),el('p','subtle',row.reason+' · 负责人：'+(row.owner||'未分配')));
  const open=el('button','button secondary','查看 / 处理');open.type='button';open.onclick=()=>openHandoffDetail(row.id);card.append(open);list.append(card);
 }
}
async function loadHandoffPage(page,force=false){
 updateHandoffScope();
 if(handoffLoading||document.hidden||!serviceAvailable||!state.account||!supportsHandoffs()||currentView!=='handoffs'||!(page in handoffCursors)||(!force&&Date.now()<handoffNextAt))return;
 const version=++handoffVersion,scope=handoffScope,cursor=handoffCursors[page];handoffLoading=true;handoffNextAt=Date.now()+10000;handoffPageControls();
 try{
  const data=await api('/api/handoffs?'+new URLSearchParams({account:state.account,status:$('handoff-status').value,groupId:$('handoff-group').value,limit:'50',...(cursor?{cursor}:{})}));
  if(version!==handoffVersion||scope!==handoffScopeKey())return;
  handoffPage=page;handoffCursors=handoffCursors.slice(0,page+1);handoffHasMore=data.hasMore;if(data.hasMore)handoffCursors[page+1]=data.nextCursor;
  handoffRows=data.records;renderHandoffs();$('handoff-message').textContent='本页 '+handoffRows.length+' 条 · '+(handoffHasMore?'可查看下一页':'已到结果末尾')+(page?' · 历史页保持不动，刷新返回第一页':' · 第一页每 10 秒更新');
 }catch(error){if(version===handoffVersion&&scope===handoffScopeKey())$('handoff-message').textContent='待办读取失败：'+error.message+' 可重试刷新或翻页。';}
 finally{if(version===handoffVersion){handoffLoading=false;handoffPageControls();}}
}
function loadHandoffs(force=false){updateHandoffScope();if(!force&&handoffPage!==0)return;return loadHandoffPage(0,force);}
function handoffDetailControls(){
 const status=handoffDetail?.status,busy=handoffActionBusy||handoffDetailLoading||!serviceAvailable||!handoffDetail;
 for(const [action,visible] of Object.entries({claim:status==='pending',release:status==='in_progress',complete:status==='in_progress',reopen:status==='completed'})){$('handoff-'+action).hidden=!visible;$('handoff-'+action).disabled=busy;}
 $('handoff-claim').disabled=busy||!$('handoff-owner').value.trim();$('handoff-owner').disabled=busy||status!=='pending';$('handoff-note').disabled=busy;
 $('handoff-detail-refresh').disabled=handoffActionBusy||handoffDetailLoading||!serviceAvailable||!handoffDetailId;
}
function renderHandoffDetail(data,preserveDraft){
 const row=data.record;handoffDetail=row;
 $('handoff-detail-title').textContent=row.groupName+' · '+handoffStatuses[row.status];
 $('handoff-detail-meta').textContent='发起人：'+row.trigger.senderName+' · '+stamp(row.trigger.timestamp,{year:'numeric',month:'2-digit',day:'2-digit',hour:'2-digit',minute:'2-digit',second:'2-digit'})+' · '+row.reason+' · 负责人：'+(row.owner||'未分配')+' · 版本 '+row.version;
 $('handoff-detail-text').textContent=handoffText(row);$('handoff-truncated').hidden=row.revoked||!row.trigger.textTruncated;
 if(!preserveDraft||!handoffOwnerDirty){$('handoff-owner').value=row.owner;handoffOwnerDirty=false;}
 if(!preserveDraft||!handoffNoteDirty){$('handoff-note').value=row.note;handoffNoteDirty=false;}
 const changes=$('handoff-changes');changes.replaceChildren();
 for(const change of data.changes){const entry=el('li','',stamp(change.createdAt,{month:'2-digit',day:'2-digit',hour:'2-digit',minute:'2-digit',second:'2-digit'})+' · '+(handoffActions[change.action]||change.action)+' · '+handoffStatuses[change.status]+' · '+(change.owner||'未分配'));if(change.note)entry.append(el('p','handoff-change-note',change.note));changes.append(entry);}
 $('handoff-history-note').textContent=data.historyTruncated?'仅展示最近 100 次变更。':'已展示全部变更。';handoffDetailControls();
}
async function loadHandoffDetail(id,preserveDraft=false){
 updateHandoffScope();const version=++handoffDetailVersion,scope=handoffScope;handoffDetailId=id;handoffDetailLoading=true;handoffDetailControls();
 try{
  const data=await api('/api/handoffs/detail?'+new URLSearchParams({account:state.account,id}));
  if(version!==handoffDetailVersion||scope!==handoffScopeKey())return;
  renderHandoffDetail(data,preserveDraft);
 }catch(error){if(version===handoffDetailVersion&&scope===handoffScopeKey()){$('handoff-detail-message').textContent='详情读取失败：'+error.message;handoffDetail=null;}}
 finally{if(version===handoffDetailVersion){handoffDetailLoading=false;handoffDetailControls();}}
}
async function openHandoffDetail(id){
 updateHandoffScope();if(!state.account||!serviceAvailable||!supportsHandoffs())return;
 clearHandoffDetail();$('handoff-detail-title').textContent='正在核对待办…';$('handoff-dialog').showModal();return loadHandoffDetail(id);
}
async function submitHandoffAction(action){
 if(handoffActionBusy||handoffDetailLoading||!handoffDetail||!serviceAvailable)return;
 const row=handoffDetail,scope=handoffScope,account=state.account,version=handoffDetailVersion,actionVersion=++handoffActionVersion;
 handoffActionBusy=true;handoffDetailControls();$('handoff-detail-message').textContent='正在保存本机处理状态…';
 try{
  const record=await api('/api/handoffs/action',{account,id:row.id,version:row.version,action,owner:$('handoff-owner').value.trim(),note:$('handoff-note').value});
  if(scope!==handoffScopeKey()||version!==handoffDetailVersion)return;
  handoffDetail=record;handoffOwnerDirty=false;handoffNoteDirty=false;$('handoff-detail-message').textContent='本机状态已保存；未发送消息，群规则未改变。';
  await loadHandoffDetail(row.id);if(scope===handoffScopeKey())await loadHandoffs(true);
 }catch(error){
  if(scope!==handoffScopeKey()||version!==handoffDetailVersion)return;
  $('handoff-detail-message').textContent=error.message;
  if(error.status===409){$('handoff-detail-message').textContent='记录已变化（409）：'+error.message+' 已重新核对详情，请确认后再操作。';await loadHandoffDetail(row.id,true);}
 }finally{if(scope===handoffScopeKey()&&actionVersion===handoffActionVersion){handoffActionBusy=false;handoffDetailControls();}}
}
$('handoff-refresh').onclick=()=>loadHandoffs(true);
$('handoff-prev').onclick=()=>loadHandoffPage(handoffPage-1,true);
$('handoff-next').onclick=()=>loadHandoffPage(handoffPage+1,true);
for(const id of ['handoff-status','handoff-group'])$(id).addEventListener('change',()=>{resetHandoffPage();loadHandoffs(true);});
$('handoff-owner').addEventListener('input',()=>{handoffOwnerDirty=true;handoffDetailControls();});
$('handoff-note').addEventListener('input',()=>{handoffNoteDirty=true;});
for(const action of ['claim','release','complete','reopen'])$('handoff-'+action).onclick=()=>submitHandoffAction(action);
$('handoff-detail-refresh').onclick=()=>{$('handoff-detail-message').textContent='';return loadHandoffDetail(handoffDetailId,true);};
$('handoff-dialog').addEventListener('close',clearHandoffDetail);
