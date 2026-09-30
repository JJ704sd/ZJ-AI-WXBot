'use strict';
let executionRows=[],executionScope='',executionVersion=0,executionLoading=false,executionNextAt=0,executionRenderKey='';
function executionScopeKey(){return JSON.stringify([state.account,state.runtime?.mode,state.runtime?.source?.id,state.watchedGroups]);}
function updateExecutionScope(){
 const scope=executionScopeKey();
 if(scope!==executionScope){executionScope=scope;++executionVersion;executionLoading=false;executionNextAt=0;executionRows=[];executionRenderKey='';$('execution-list').replaceChildren();$('execution-message').textContent='';$('execution-refresh').disabled=false;}
}
function renderExecutionHistory(){
 const query=$('execution-search').value.trim().toLocaleLowerCase(),source=$('execution-source').value,status=$('execution-status').value;
 const rows=executionRows.filter(row=>(source==='all'||row.source===source)&&(status==='all'||(status==='pending'?row.pending:row.attention))&&(!query||[row.targetName,row.text,row.label,row.issue].filter(Boolean).join(' ').toLocaleLowerCase().includes(query)));
 const key=JSON.stringify([rows,executionScope]);if(key===executionRenderKey)return;executionRenderKey=key;
 const list=$('execution-list');list.replaceChildren();
 if(!rows.length){list.append(emptyCard('暂无匹配的执行记录','记录仅包含当前账号已勾选的会话，可调整筛选或刷新。','info'));return;}
 for(const row of rows){
  const card=el('article','execution-row'),heading=el('div','execution-heading');
  heading.append(el('strong','',row.targetName),el('span','status-chip'+(row.attention?' off':''),row.label));
  const sources={manual:'手动发送',reply:'自动回复',schedule:'定时任务'};
  const body=el('p','execution-text',row.text|| (row.textUnavailable?'未保存本次回复正文快照':'无正文记录'));
  card.append(heading,el('p','subtle',(sources[row.source]||row.source)+' · '+stamp(row.createdAt,{month:'2-digit',day:'2-digit',hour:'2-digit',minute:'2-digit',second:'2-digit'})+' · '+row.timeBasis),body);
  if(row.issue)card.append(el('p','execution-issue',row.issue));
  const details=el('details'),summary=el('summary','', '记录标识');details.append(summary,el('code','',row.id));card.append(details);
  const open=el('button','button quiet','查看会话');open.type='button';open.onclick=()=>{if(!(state.watchedGroups||[]).includes(row.targetId))return;setView('workspace');selectGroup(row.targetId);};card.append(open);list.append(card);
 }
}
async function loadExecutionHistory(force=false){
 updateExecutionScope();if(executionLoading||document.hidden||!serviceAvailable||(!force&&Date.now()<executionNextAt))return;
 const version=executionVersion,scope=executionScope,account=state.account;executionLoading=true;$('execution-refresh').disabled=true;executionNextAt=Date.now()+10000;
 try{
  const data=await api('/api/execution-history?'+new URLSearchParams({account:account||''}));
  if(version!==executionVersion||scope!==executionScopeKey())return;
  executionRows=data.records||[];renderExecutionHistory();
  $('execution-scope').textContent='当前账号 · 已勾选会话 · 最近 '+data.limit+' 条'+(isDemo()?' · 本机模拟':'');
  $('execution-message').textContent=(data.truncated?'仅展示最近记录，较早记录未加载。 ':'')+'已显示 '+executionRows.length+' 条 · 更新于 '+stamp(Date.now()/1000)+' · 不自动重发';
 }catch(error){if(version===executionVersion&&scope===executionScopeKey()){$('execution-message').textContent='记录刷新失败：'+error.message+' 当前列表为上次读取结果。';}}
 finally{if(version===executionVersion){executionLoading=false;$('execution-refresh').disabled=false;}}
}
$('execution-refresh').onclick=()=>loadExecutionHistory(true);
for(const id of ['execution-search','execution-source','execution-status'])$(id).addEventListener(id==='execution-search'?'input':'change',renderExecutionHistory);
