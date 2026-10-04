'use strict';
let scheduleBatchScope='',scheduleBatchGroups=new Set(),scheduleBatchTemplates=[],scheduleBatchPreview=null,scheduleBatchPreviewInput=null;
let scheduleBatchRequest=null,scheduleBatchRevision=0,scheduleBatchRequestId='',scheduleBatchInitialized=false,scheduleBatchEditingTemplate=false;
let scheduleBatchTargetScope='',scheduleBatchCandidateScope='';
const scheduleBatchAttempts=new Map();
function supportsScheduleBatches(){return isDatabase()&&state.runtime?.capabilities?.scheduleBatches===true;}
function scheduleBatchScopeKey(){return JSON.stringify([state.account,state.runtime?.mode,state.runtime?.source?.id,supportsScheduleBatches()]);}
function scheduleBatchTargetKey(){const known=new Map((state.groups||[]).map(group=>[group.id,group.name]));return JSON.stringify([...scheduleBatchGroups].sort().map(id=>[id,known.has(id),known.get(id),(state.watchedGroups||[]).includes(id)]));}
function scheduleBatchTargets(){return (state.groups||[]).filter(group=>(state.watchedGroups||[]).includes(group.id));}
function scheduleBatchAttempt(){return scheduleBatchAttempts.get(state.account);}
function invalidateScheduleBatch(){
 ++scheduleBatchRevision;scheduleBatchTargetScope=scheduleBatchTargetKey();scheduleBatchPreview=null;scheduleBatchPreviewInput=null;$('schedule-batch-results').replaceChildren();$('schedule-batch-summary').textContent='';
 if(scheduleBatchRequest?.kind==='preview')scheduleBatchRequest=null;
 scheduleBatchControls();
}
function updateScheduleBatchScope(){
 const scope=scheduleBatchScopeKey();
 if(scope!==scheduleBatchScope){
  if(scheduleBatchRequest?.kind==='create')scheduleBusy=false;
  scheduleBatchScope=scope;scheduleBatchRequest=null;scheduleBatchInitialized=false;scheduleBatchGroups.clear();scheduleBatchTemplates=[];scheduleBatchEditingTemplate=false;
  invalidateScheduleBatch();$('schedule-batch-dialog').close();$('schedule-batch-message').textContent='';
 }else if(scheduleBatchTargetKey()!==scheduleBatchTargetScope){
  if(scheduleBatchRequest?.kind==='create')scheduleBusy=false;
  scheduleBatchRequest=null;
  if(!scheduleBatchAttempt()){const eligible=new Set(scheduleBatchTargets().map(group=>group.id));scheduleBatchGroups=new Set([...scheduleBatchGroups].filter(id=>eligible.has(id)));}
  invalidateScheduleBatch();
  const attempt=scheduleBatchAttempt();
  if(attempt)renderScheduleBatchPreview(attempt.preview);
  $('schedule-batch-message').textContent=attempt?'所选会话的名称或读取范围已变化；本批已经提交过，保留原规格供核对结果。':'所选会话的名称或读取范围已变化；保留仍可用的选择，请核对后重新预览。';
 }
 const candidates=JSON.stringify([(state.groups||[]).map(group=>[group.id,group.name]),state.watchedGroups]);
 if(candidates!==scheduleBatchCandidateScope){scheduleBatchCandidateScope=candidates;if($('schedule-batch-dialog').open)renderScheduleBatchGroups();}
 $('schedule-batch-open').hidden=!supportsScheduleBatches();scheduleBatchControls();
}
function scheduleBatchControls(){
 const attempt=scheduleBatchAttempt(),frozen=!!attempt,busy=!!scheduleBatchRequest,blocked=scheduleBusy||!!schedulePauseRequest||scheduleActionsBusy.size>0;
 $('schedule-batch-open').disabled=!state.account||!serviceAvailable||blocked;
 for(const id of ['schedule-batch-template','schedule-batch-search','schedule-batch-select-visible','schedule-batch-clear','schedule-batch-mode','schedule-batch-at','schedule-batch-clock','schedule-batch-window','schedule-batch-reload'])$(id).disabled=busy||frozen||blocked;
 for(const input of $('schedule-batch-groups').querySelectorAll('input'))input.disabled=busy||frozen||blocked;
 for(const input of $('schedule-batch-weekdays').querySelectorAll('input'))input.disabled=busy||frozen||blocked;
 for(const button of $('schedule-batch-results').querySelectorAll('button'))button.disabled=busy||frozen||blocked;
 $('schedule-batch-preview').disabled=busy||frozen||blocked||!serviceAvailable||!$('schedule-batch-template').value||!scheduleBatchGroups.size;
 $('schedule-batch-create').disabled=busy||blocked||!serviceAvailable||(attempt?attempt.status!=='uncertain':!scheduleBatchPreview?.canCreate);
 $('schedule-batch-create').textContent=attempt?(attempt.status==='success'?'本批已创建':'重试核对本批结果'):'创建并启用 '+scheduleBatchGroups.size+' 条任务';
 $('schedule-batch-new').hidden=attempt?.status!=='success';$('schedule-batch-new').disabled=busy||blocked;
}
function scheduleBatchMode(){
 const mode=$('schedule-batch-mode').value;
 $('schedule-batch-at-field').hidden=mode!=='once';$('schedule-batch-clock-field').hidden=mode==='once';$('schedule-batch-weekdays-field').hidden=mode!=='weekly';
 $('schedule-batch-at').required=mode==='once';$('schedule-batch-clock').required=mode!=='once';
}
function renderScheduleBatchGroups(){
 const query=$('schedule-batch-search').value.trim().toLocaleLowerCase(),list=$('schedule-batch-groups');list.replaceChildren();
 const targets=scheduleBatchTargets(),visible=targets.filter(group=>(group.name+' '+group.id).toLocaleLowerCase().includes(query));
 for(const group of visible){
  const label=el('label','schedule-batch-target'),input=el('input');input.type='checkbox';input.checked=scheduleBatchGroups.has(group.id);
  input.onchange=()=>{if(input.checked)scheduleBatchGroups.add(group.id);else scheduleBatchGroups.delete(group.id);invalidateScheduleBatch();renderScheduleBatchGroups();};
  const description=el('span');description.append(el('strong','',group.name),el('small','',group.id));label.append(input,description);list.append(label);
 }
 $('schedule-batch-count').textContent='已选择 '+scheduleBatchGroups.size+' 个会话 · 当前显示 '+visible.length+' / '+targets.length+' · 每批最多 300 个';
 scheduleBatchControls();
}
function scheduleBatchInput(){
 const template=scheduleBatchTemplates.find(row=>row.id===$('schedule-batch-template').value),mode=$('schedule-batch-mode').value,windowMinutes=Number($('schedule-batch-window').value);
 if(!template)throw Error('请选择已保存的模板。');
 if(!scheduleBatchGroups.size||scheduleBatchGroups.size>300)throw Error('请选择 1 到 300 个会话。');
 if(!Number.isInteger(windowMinutes)||windowMinutes<1||windowMinutes>1439)throw Error('执行窗口请输入 1 到 1439 之间的整数分钟。');
 const weekdays=[...$('schedule-batch-weekdays').querySelectorAll('input')].filter(input=>input.checked).map(input=>Number(input.value));
 if(mode==='weekly'&&!weekdays.length)throw Error('请至少选择一个发送星期。');
 if(mode==='once'&&!$('schedule-batch-at').value||mode!=='once'&&!$('schedule-batch-clock').value)throw Error('请填写计划时间。');
 return {account:state.account,templateId:template.id,templateVersion:template.version,groupIds:[...scheduleBatchGroups].sort(),mode,clock:mode==='once'?'':$('schedule-batch-clock').value,at:mode==='once'?$('schedule-batch-at').value:'',...(mode==='weekly'?{weekdays}:{}),windowMinutes};
}
function scheduleBatchCurrent(request){return scheduleBatchRequest===request&&request.scope===scheduleBatchScopeKey();}
async function loadScheduleBatchTemplates(){
 if(scheduleBatchRequest||scheduleBatchAttempt()||!serviceAvailable)return;
 invalidateScheduleBatch();const selectedId=$('schedule-batch-template').value,request={kind:'templates',scope:scheduleBatchScopeKey()};scheduleBatchRequest=request;scheduleBatchControls();
 try{
  const data=await api('/api/schedule-templates?'+new URLSearchParams({account:state.account}));if(!scheduleBatchCurrent(request))return;
  scheduleBatchTemplates=data.templates;const select=$('schedule-batch-template');select.replaceChildren();const empty=el('option','','选择已保存模板');empty.value='';select.append(empty);
  for(const row of data.templates){const option=el('option','',row.name+' · 版本 '+row.version);option.value=row.id;select.append(option);}
  select.value=data.templates.some(row=>row.id===selectedId)?selectedId:'';
  $('schedule-batch-message').textContent=data.templates.length?'模板版本已读取；请生成整批预览。':'暂无已保存模板，请先在模板库中创建。';
 }catch(error){if(scheduleBatchCurrent(request))$('schedule-batch-message').textContent=error.message;}
 finally{if(scheduleBatchRequest===request){scheduleBatchRequest=null;scheduleBatchControls();}}
}
function renderScheduleBatchPreview(preview){
 const list=$('schedule-batch-results');list.replaceChildren();
 $('schedule-batch-summary').textContent='可用 '+preview.readyCount+' 条 / 问题 '+preview.invalidCount+' 条 · 当前账号已有 '+preview.existingCount+' 条记录 + 本批 '+preview.records.length+' 条 / 上限 '+preview.capacity+'（包含已结束和取消的记录）。'+(preview.canCreate?'整批核对完成后再创建。':'当前不能创建，不会跳过有问题的会话。');
 for(const issue of preview.issues)list.append(el('p','action-reason',issue));
 list.append(el('p','subtle','共同计划：'+({once:'指定日期一次',daily:'每天',weekly:'每周 '+preview.weekdays.map(day=>'一二三四五六日'[day-1]).join('、')}[preview.mode])+' · 北京时间 '+stamp(preview.nextRun,{year:'numeric',month:'2-digit',day:'2-digit',hour:'2-digit',minute:'2-digit'})+' · 首期提交截止 '+stamp(preview.deadline,{month:'2-digit',day:'2-digit',hour:'2-digit',minute:'2-digit'})+' · 窗口 '+preview.windowMinutes+' 分钟'));
 for(const record of preview.records){
  const card=el('article','schedule-batch-record');card.append(el('strong','',record.targetName),el('p','subtle',record.groupId+' · '+(record.contentSource==='override'?'本会话完整正文覆盖':'模板变量替换')));
  if(record.existingCount)card.append(el('p','subtle','此会话已有 '+record.existingCount+' 条任务记录；本次不会替换已有记录。'+(record.duplicate?'已有启用或暂停的相同计划，本次不能重复创建。':'')));
  if(record.error)card.append(el('p','action-reason',record.error+(record.missing.length?' 缺少：'+record.missing.join('、'):'')));
  if(record.text){const details=el('details');details.open=true;details.append(el('summary','','完整发送正文'),el('pre','schedule-batch-text',record.text));card.append(details);}
  const edit=el('button','button quiet','配置此会话模板');edit.type='button';edit.onclick=()=>editScheduleBatchTemplate(record.groupId);card.append(edit);list.append(card);
 }
 scheduleBatchControls();
}
async function openScheduleBatch(){
 updateScheduleBatchScope();if(!supportsScheduleBatches()||!state.account||!serviceAvailable||scheduleBusy||schedulePauseRequest||scheduleActionsBusy.size)return;
 if(!scheduleBatchInitialized){
  scheduleBatchInitialized=true;scheduleBatchRequestId=crypto.randomUUID();$('schedule-batch-search').value='';$('schedule-batch-template').replaceChildren();$('schedule-batch-mode').value='once';$('schedule-batch-clock').value='09:00';$('schedule-batch-window').value='2';$('schedule-batch-at').value=new Date(Date.now()+8*3600000+5*60000).toISOString().slice(0,16);
  for(const day of $('schedule-batch-weekdays').querySelectorAll('input'))day.checked=Number(day.value)<=5;
 }
 const attempt=scheduleBatchAttempt();
 if(attempt){
  const input=attempt.body;scheduleBatchRequestId=input.requestId;scheduleBatchGroups=new Set(input.groupIds);
  const option=el('option','',attempt.preview.templateName+' · 版本 '+input.templateVersion);option.value=input.templateId;$('schedule-batch-template').replaceChildren(option);$('schedule-batch-template').value=input.templateId;
  $('schedule-batch-mode').value=input.mode;$('schedule-batch-clock').value=input.clock;$('schedule-batch-at').value=input.at;$('schedule-batch-window').value=String(input.windowMinutes);
  for(const day of $('schedule-batch-weekdays').querySelectorAll('input'))day.checked=input.mode==='weekly'&&input.weekdays.includes(Number(day.value));
 }
 scheduleBatchTargetScope=scheduleBatchTargetKey();
 $('schedule-batch-dialog').showModal();scheduleBatchMode();renderScheduleBatchGroups();
 if(attempt){renderScheduleBatchPreview(attempt.preview);$('schedule-batch-message').textContent=attempt.status==='success'?'本批已创建 '+attempt.result.createdCount+' 条任务。任务可能已暂停或结束，请以任务列表状态为准。':'本批结果尚未确认。请使用原请求核对，不能改规格后重建。';scheduleBatchControls();}
 else if(!scheduleBatchTemplates.length)await loadScheduleBatchTemplates();
}
async function previewScheduleBatch(){
 if(scheduleBatchRequest||scheduleBatchAttempt()||scheduleBusy||schedulePauseRequest||scheduleActionsBusy.size||!serviceAvailable||!supportsScheduleBatches())return;
 let input;try{input=scheduleBatchInput();}catch(error){$('schedule-batch-message').textContent=error.message;return;}
 invalidateScheduleBatch();const request={kind:'preview',scope:scheduleBatchScopeKey(),revision:scheduleBatchRevision};scheduleBatchRequest=request;scheduleBatchControls();$('schedule-batch-message').textContent='正在生成各会话的完整正文…';
 try{
  const result=await api('/api/jobs/batch/preview',input);if(!scheduleBatchCurrent(request)||request.revision!==scheduleBatchRevision)return;
  scheduleBatchPreview=result;scheduleBatchPreviewInput=input;renderScheduleBatchPreview(result);$('schedule-batch-message').textContent='预览不会创建任务或发送消息。正文按本次快照冻结，日期变量不会自动更新。';
 }catch(error){if(scheduleBatchCurrent(request))$('schedule-batch-message').textContent=(error.status===409?'模板或计划已变化，请刷新模板版本后重新预览。':'')+error.message;}
 finally{if(scheduleBatchRequest===request){scheduleBatchRequest=null;scheduleBatchControls();}}
}
async function createScheduleBatch(){
 if(scheduleBatchRequest||scheduleBusy||schedulePauseRequest||scheduleActionsBusy.size||!serviceAvailable||!supportsScheduleBatches())return;
 let attempt=scheduleBatchAttempt();if(attempt&&attempt.status!=='uncertain')return;
 if(!attempt){if(!scheduleBatchPreview?.canCreate)return;attempt={body:{...scheduleBatchPreviewInput,requestId:scheduleBatchRequestId,previewDigest:scheduleBatchPreview.previewDigest},preview:scheduleBatchPreview,status:'uncertain',result:null};scheduleBatchAttempts.set(state.account,attempt);}
 const request={kind:'create',scope:scheduleBatchScopeKey()},account=state.account;scheduleBatchRequest=request;scheduleBusy=true;controls();renderSchedules();$('schedule-batch-message').textContent='正在创建整批任务；请保留此窗口等待结果。';
 try{
  const result=await api('/api/jobs/batch',attempt.body);attempt.status='success';attempt.result=result;if(!scheduleBatchCurrent(request))return;
  const ids=new Set(result.jobs.map(job=>job.id));state.jobs=[...(state.jobs||[]).filter(job=>!ids.has(job.id)),...result.jobs];
  $('schedule-batch-message').textContent=(result.reused?'已核对原批次：':'已创建：')+result.createdCount+' 条任务。不会重复创建或恢复已暂停任务；实际执行结果请看任务列表。';
 }catch(error){
  if(error.status===400||error.status===409){if(scheduleBatchCurrent(request)){scheduleBatchAttempts.delete(account);invalidateScheduleBatch();$('schedule-batch-message').textContent=error.message+' 请核对任务与模板，刷新模板版本后重新预览；本次请求标识保留。';}}
  else if(scheduleBatchCurrent(request))$('schedule-batch-message').textContent='未确认本批创建结果。原请求和规格已保留，请点击“重试核对本批结果”；不会自动重试。'+error.message;
 }finally{if(scheduleBatchRequest===request){scheduleBatchRequest=null;scheduleBusy=false;scheduleRenderKey='';controls();renderSchedules();}}
}
async function editScheduleBatchTemplate(groupId){
 if(scheduleBatchRequest||scheduleBatchAttempt()||!scheduleBatchPreview)return;
 const id=scheduleBatchPreview.templateId;invalidateScheduleBatch();scheduleBatchEditingTemplate=true;await openScheduleTemplates('manage',{id,groupId});
}
function scheduleBatchTemplateChanged(id){
 if(scheduleBatchInitialized&&!scheduleBatchAttempt()&&$('schedule-batch-template').value===id){scheduleBatchTemplates=[];invalidateScheduleBatch();$('schedule-batch-message').textContent='模板或会话配置已修改，请刷新模板版本后重新生成整批预览。';}
}
$('schedule-batch-open').onclick=openScheduleBatch;$('schedule-batch-preview').onclick=previewScheduleBatch;$('schedule-batch-create').onclick=createScheduleBatch;$('schedule-batch-reload').onclick=loadScheduleBatchTemplates;
$('schedule-batch-search').oninput=renderScheduleBatchGroups;
$('schedule-batch-select-visible').onclick=()=>{const query=$('schedule-batch-search').value.trim().toLocaleLowerCase();for(const group of scheduleBatchTargets())if((group.name+' '+group.id).toLocaleLowerCase().includes(query))scheduleBatchGroups.add(group.id);invalidateScheduleBatch();renderScheduleBatchGroups();};
$('schedule-batch-clear').onclick=()=>{scheduleBatchGroups.clear();invalidateScheduleBatch();renderScheduleBatchGroups();};
for(const id of ['schedule-batch-template','schedule-batch-at','schedule-batch-clock','schedule-batch-window'])$(id).oninput=invalidateScheduleBatch;
$('schedule-batch-mode').onchange=()=>{scheduleBatchMode();invalidateScheduleBatch();};
for(const day of $('schedule-batch-weekdays').querySelectorAll('input'))day.onchange=invalidateScheduleBatch;
$('schedule-batch-new').onclick=()=>{if(scheduleBatchAttempt()?.status!=='success')return;scheduleBatchAttempts.delete(state.account);scheduleBatchRequestId=crypto.randomUUID();return loadScheduleBatchTemplates();};
$('schedule-template-dialog').addEventListener('close',()=>{if(scheduleBatchEditingTemplate){scheduleBatchEditingTemplate=false;loadScheduleBatchTemplates();}});
$('schedule-batch-dialog').addEventListener('close',()=>{if(scheduleBatchRequest?.kind!=='create'){scheduleBatchRequest=null;++scheduleBatchRevision;scheduleBatchControls();}});
