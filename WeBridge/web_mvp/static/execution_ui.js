'use strict';
let executionRows=[],executionScope='',executionVersion=0,executionLoading=false,executionNextAt=0,executionRenderKey='';
let executionPage=0,executionCursors=[''],executionHasMore=false,executionSearchTimer=null;
function executionFilters(){return {limit:$('execution-limit').value,query:$('execution-search').value.trim(),source:$('execution-source').value,status:$('execution-status').value,startDate:$('execution-start-date').value,endDate:$('execution-end-date').value};}
function executionScopeKey(){return JSON.stringify([state.account,state.runtime?.mode,state.runtime?.source?.id,[...new Set(state.watchedGroups||[])].sort(),executionFilters()]);}
function executionPageControls(){
 $('execution-prev').disabled=executionLoading||!serviceAvailable||executionPage===0;
 $('execution-next').disabled=executionLoading||!serviceAvailable||!executionHasMore;
 $('execution-refresh').disabled=executionLoading||!serviceAvailable;
 $('execution-page').textContent='第 '+(executionPage+1)+' 页';
}
function updateExecutionScope(){
 const scope=executionScopeKey();
 if(scope!==executionScope){
  executionScope=scope;++executionVersion;executionLoading=false;executionNextAt=0;executionRows=[];executionRenderKey='';executionPage=0;executionCursors=[''];executionHasMore=false;
  if(executionSearchTimer!==null){clearTimeout(executionSearchTimer);executionSearchTimer=null;}
  $('execution-list').replaceChildren();$('execution-message').textContent='';$('execution-scope').textContent='当前账号 · 已勾选会话 · 筛选本机已有执行记录';
 }
 executionPageControls();
}
function renderExecutionHistory(){
 const rows=executionRows;
 const key=JSON.stringify([rows,executionScope]);if(key===executionRenderKey)return;executionRenderKey=key;
 const list=$('execution-list');list.replaceChildren();
 if(!rows.length){list.append(emptyCard('暂无匹配的执行记录','已在当前账号勾选会话的本机执行历史中查询，可调整关键词、日期或状态后重试。','info'));return;}
 for(const row of rows){
  const card=el('article','execution-row'),heading=el('div','execution-heading');
  heading.append(el('strong','',row.targetName),el('span','status-chip'+(row.attention?' off':''),row.label));
  const sources={manual:'手动发送',reply:'自动回复',schedule:'定时任务'};
  const body=el('p','execution-text',row.text|| (row.textUnavailable?'未保存本次回复正文快照':'无正文记录'));
  card.append(heading,el('p','subtle',(sources[row.source]||row.source)+' · '+stamp(row.createdAt,{year:'numeric',month:'2-digit',day:'2-digit',hour:'2-digit',minute:'2-digit',second:'2-digit'})+' · '+row.timeBasis),body);
  if(row.issue)card.append(el('p','execution-issue',row.issue));
  if(row.trigger){
   const trigger=row.trigger,context=el('details','execution-trigger');
   context.append(el('summary','',row.decision==='cooldown_skipped'?'触发消息 · 回复间隔内跳过':'触发消息 · 真实 @ 本人'));
   context.append(el('p','subtle',trigger.senderName+' · '+stamp(trigger.timestamp,{year:'numeric',month:'2-digit',day:'2-digit',hour:'2-digit',minute:'2-digit',second:'2-digit'})));
   context.append(el('p','execution-text',trigger.text));
   if(trigger.textTruncated)context.append(el('p','subtle','原消息较长，仅保留前 2000 字符。'));
   card.append(context);
  }
  const details=el('details'),summary=el('summary','', '记录标识');details.append(summary,el('code','',row.id));card.append(details);
  const open=el('button','button quiet','查看会话');open.type='button';open.onclick=()=>{if(!(state.watchedGroups||[]).includes(row.targetId))return;setView('workspace');selectGroup(row.targetId);};card.append(open);list.append(card);
 }
}
async function loadExecutionPage(page,force=false){
 updateExecutionScope();
 if(executionLoading||document.hidden||!serviceAvailable||!Number.isInteger(page)||page<0||!(page in executionCursors)||(!force&&(executionSearchTimer!==null||Date.now()<executionNextAt)))return;
 if(force&&executionSearchTimer!==null){clearTimeout(executionSearchTimer);executionSearchTimer=null;}
 const version=++executionVersion,scope=executionScope,account=state.account,cursor=executionCursors[page];executionLoading=true;executionPageControls();executionNextAt=Date.now()+10000;
 try{
  const data=await api('/api/execution-history?'+new URLSearchParams({account:account||'',...executionFilters(),...(cursor?{cursor}:{})}));
  if(version!==executionVersion||scope!==executionScopeKey())return;
  const count=data.records.length;
  // Commit page movement only after success; failures leave the current page retryable.
  executionPage=page;executionCursors=executionCursors.slice(0,page+1);
  executionHasMore=data.hasMore;
  if(executionHasMore)executionCursors[page+1]=data.nextCursor;
  executionRows=data.records;renderExecutionHistory();
  $('execution-scope').textContent='当前账号 · 已勾选会话 · 每页 '+data.limit+' 条 · 筛选覆盖本机已有执行历史 · 日期按北京时间'+(isDemo()?' · 本机模拟':'');
  $('execution-message').textContent='本页 '+count+' 条 · '+(executionHasMore?'可查看下一页':'已到查询结果末尾')+' · 更新于 '+stamp(Date.now()/1000)+(executionPage?' · 历史页保持不动，刷新返回第一页':' · 第一页每 10 秒检查更新')+' · 不自动重发';
 }catch(error){if(version===executionVersion&&scope===executionScopeKey()){$('execution-message').textContent='记录读取失败：'+error.message+(executionRows.length?' 当前页仍为上次读取结果，可重试翻页或刷新。':' 可调整条件或刷新重试。');}}
 finally{if(version===executionVersion){executionLoading=false;executionPageControls();}}
}
function loadExecutionHistory(force=false){
 updateExecutionScope();
 if(!force&&executionPage!==0)return;
 return loadExecutionPage(0,force);
}
$('execution-refresh').onclick=()=>loadExecutionHistory(true);
$('execution-prev').onclick=()=>loadExecutionPage(executionPage-1,true);
$('execution-next').onclick=()=>loadExecutionPage(executionPage+1,true);
$('execution-search').addEventListener('input',()=>{
 updateExecutionScope();
 if(executionSearchTimer!==null)clearTimeout(executionSearchTimer);
 executionSearchTimer=setTimeout(()=>{executionSearchTimer=null;loadExecutionHistory(true);},300);
});
for(const id of ['execution-source','execution-status','execution-start-date','execution-end-date'])$(id).addEventListener('change',()=>loadExecutionHistory(true));
$('execution-limit').onchange=()=>loadExecutionHistory(true);
