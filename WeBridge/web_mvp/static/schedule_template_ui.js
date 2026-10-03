'use strict';
let scheduleTemplateScope='',scheduleTemplateMode='manage',scheduleTemplateRows=[],scheduleTemplateDetail=null;
let scheduleTemplateRequest=null,scheduleTemplateRevision=0,scheduleTemplateDirty=false,scheduleTemplateConflict=false,scheduleTemplatePreview=null;
let scheduleTemplateApplyContext=null,scheduleTemplateFilled=null;
function supportsScheduleTemplates(){return isDatabase()&&state.runtime?.capabilities?.scheduleTemplates===true;}
function scheduleTemplateScopeKey(){return JSON.stringify([state.account,state.runtime?.mode,state.runtime?.source?.id,supportsScheduleTemplates()]);}
function resetScheduleTemplateFill(){scheduleTemplateFilled=null;$('schedule-template-source').textContent='';}
function invalidateScheduleTemplatePreview(){
 ++scheduleTemplateRevision;scheduleTemplatePreview=null;$('schedule-template-preview-text').textContent='';
 if(scheduleTemplateRequest?.kind==='preview')scheduleTemplateRequest=null;
 scheduleTemplateControls();
}
function clearScheduleTemplateDialog(preserveContext=false){
 ++scheduleTemplateRevision;scheduleTemplateRequest=null;scheduleTemplateDetail=null;scheduleTemplatePreview=null;if(preserveContext!==true)scheduleTemplateApplyContext=null;scheduleTemplateDirty=false;scheduleTemplateConflict=false;
 $('schedule-template-name').value='';$('schedule-template-body').value='';$('schedule-template-values').replaceChildren();$('schedule-template-override').checked=false;$('schedule-template-override-text').value='';
 $('schedule-template-preview-text').textContent='';$('schedule-template-message').textContent='';scheduleTemplateControls();
}
function updateScheduleTemplateScope(){
 const scope=scheduleTemplateScopeKey();
 if(scope!==scheduleTemplateScope){scheduleTemplateScope=scope;scheduleTemplateRows=[];clearScheduleTemplateDialog();$('schedule-template-dialog').close();resetScheduleTemplateFill();}
 const visible=supportsScheduleTemplates();$('schedule-template-library').hidden=!visible;$('schedule-template-fill').hidden=!visible;
 $('schedule-template-library').disabled=!state.account||!serviceAvailable;
 $('schedule-template-fill').disabled=!state.account||!serviceAvailable||scheduleBusy||!!schedulePauseRequest;
 if($('schedule-template-dialog').open&&scheduleTemplateMode==='apply'&&scheduleTemplateApplyContext&&scheduleTemplateApplyContext.groupId!==$('schedule-group').value){$('schedule-template-dialog').close();}
 scheduleTemplateControls();
}
function scheduleTemplateControls(){
 const detail=scheduleTemplateDetail,busy=!!scheduleTemplateRequest,writing=busy&&scheduleTemplateRequest.kind==='write',saved=!!detail&&detail.version>0;
 const profileReady=saved&&!scheduleTemplateDirty&&!scheduleTemplateConflict&&!!$('schedule-template-target').value;
 for(const id of ['schedule-template-name','schedule-template-body'])$(id).disabled=!detail||writing;
 $('schedule-template-select').disabled=writing;$('schedule-template-new').disabled=writing||!serviceAvailable;
 $('schedule-template-target').disabled=writing||scheduleTemplateMode==='apply';
 $('schedule-template-save').disabled=!detail||busy||scheduleTemplateConflict||!serviceAvailable;
 $('schedule-template-delete').disabled=!saved||busy||scheduleTemplateConflict||!serviceAvailable;
 $('schedule-template-reload').disabled=!saved||busy||!serviceAvailable;
 $('schedule-template-profile-save').disabled=!profileReady||busy||!serviceAvailable;
 $('schedule-template-preview').disabled=!profileReady||busy||!serviceAvailable;
 $('schedule-template-override').disabled=!profileReady||writing;
 $('schedule-template-override-text').disabled=!profileReady||writing||!$('schedule-template-override').checked;
 $('schedule-template-override-text').hidden=!$('schedule-template-override').checked;
 for(const input of $('schedule-template-values').querySelectorAll('input'))input.disabled=!profileReady||writing||$('schedule-template-override').checked;
 $('schedule-template-apply').hidden=scheduleTemplateMode!=='apply';
 $('schedule-template-apply').disabled=!scheduleTemplatePreview||busy||scheduleTemplateConflict||!serviceAvailable;
}
function renderScheduleTemplateList(selectedId=''){
 const select=$('schedule-template-select');select.replaceChildren();
 const placeholder=el('option','',scheduleTemplateRows.length?'选择一个模板':'暂无模板，请新建');placeholder.value='';select.append(placeholder);
 for(const row of scheduleTemplateRows){const option=el('option','',row.name+' · '+row.targetCount+' 个会话');option.value=row.id;select.append(option);}
 select.value=selectedId;
}
function renderScheduleTemplateTargets(groupId){
 const groups=new Map((state.groups||[]).map(group=>[group.id,group.name]));
 if(scheduleTemplateDetail)for(const target of scheduleTemplateDetail.targets)if(!groups.has(target.groupId))groups.set(target.groupId,target.targetName);
 const select=$('schedule-template-target');select.replaceChildren();const placeholder=el('option','','选择会话');placeholder.value='';select.append(placeholder);
 for(const [id,name] of groups){const option=el('option','',name+' · '+id);option.value=id;select.append(option);}
 select.value=groupId;
}
function renderScheduleTemplateDetail(detail,profile=detail.profile){
 scheduleTemplateDetail=detail;scheduleTemplateDirty=false;scheduleTemplateConflict=false;
 $('schedule-template-name').value=detail.name;$('schedule-template-body').value=detail.text;
 renderScheduleTemplateTargets(detail.groupId);const values=$('schedule-template-values');values.replaceChildren();
 for(const key of detail.variables){const label=el('label','',key),input=el('input');input.type='text';input.maxLength=500;input.dataset.variable=key;input.value=Object.hasOwn(profile.values,key)?profile.values[key]:'';input.oninput=invalidateScheduleTemplatePreview;label.append(input);values.append(label);}
 if(!detail.variables.length)values.append(el('p','subtle','此模板没有变量，可直接预览。'));
 $('schedule-template-override').checked=profile.overrideText!==null;$('schedule-template-override-text').value=profile.overrideText===null?'':profile.overrideText;
 invalidateScheduleTemplatePreview();scheduleTemplateControls();
}
function scheduleTemplateProfile(){
 const values=Object.fromEntries([...$('schedule-template-values').querySelectorAll('input')].map(input=>[input.dataset.variable,input.value]));
 return {values,overrideText:$('schedule-template-override').checked?$('schedule-template-override-text').value:null};
}
function scheduleTemplateRequestCurrent(request){return scheduleTemplateRequest===request&&request.scope===scheduleTemplateScopeKey()&&$('schedule-template-dialog').open;}
function beginScheduleTemplateRequest(kind){const request={kind,scope:scheduleTemplateScopeKey(),revision:scheduleTemplateRevision};scheduleTemplateRequest=request;scheduleTemplateControls();return request;}
function scheduleTemplateFailure(error){
 scheduleTemplatePreview=null;$('schedule-template-preview-text').textContent='';
 scheduleTemplateConflict=error.status===409;
 $('schedule-template-message').textContent=scheduleTemplateConflict?'模板已变化（409），草稿已保留。请先复制需要保留的内容，再点击“重新加载”读取最新版本。':error.message;
}
async function loadScheduleTemplate(id,groupId=$('schedule-template-target').value){
 invalidateScheduleTemplatePreview();scheduleTemplateDetail=null;const request=beginScheduleTemplateRequest('read');$('schedule-template-message').textContent='正在读取模板…';
 try{const detail=await api('/api/schedule-templates/item?'+new URLSearchParams({account:state.account,id,groupId}));if(!scheduleTemplateRequestCurrent(request))return;renderScheduleTemplateDetail(detail);$('schedule-template-message').textContent='已读取模板。变量只作文本替换，日期不会自动更新。';}
 catch(error){if(scheduleTemplateRequestCurrent(request))scheduleTemplateFailure(error);}
 finally{if(scheduleTemplateRequest===request){scheduleTemplateRequest=null;scheduleTemplateControls();}}
}
async function openScheduleTemplates(mode='manage'){
 updateScheduleTemplateScope();if(!supportsScheduleTemplates()||!state.account||!serviceAvailable)return;
 if(mode==='apply'&&(scheduleBusy||schedulePauseRequest||!$('schedule-dialog').open||!$('schedule-group').value))return;
 clearScheduleTemplateDialog();scheduleTemplateMode=mode;
 scheduleTemplateApplyContext=mode==='apply'?{account:state.account,groupId:$('schedule-group').value,requestId:scheduleRequestId,text:$('schedule-text').value}:null;
 const groupId=scheduleTemplateApplyContext?scheduleTemplateApplyContext.groupId:'';renderScheduleTemplateTargets(groupId);renderScheduleTemplateList();
 $('schedule-template-dialog-title').textContent=mode==='apply'?'从模板填入当前任务':'定时消息模板库';$('schedule-template-dialog').showModal();
 const request=beginScheduleTemplateRequest('read');$('schedule-template-message').textContent='正在读取模板库…';
 try{
  const data=await api('/api/schedule-templates?'+new URLSearchParams({account:state.account}));if(!scheduleTemplateRequestCurrent(request))return;
  scheduleTemplateRows=data.templates;renderScheduleTemplateList();scheduleTemplateRequest=null;
  if(data.templates.length){$('schedule-template-select').value=data.templates[0].id;await loadScheduleTemplate(data.templates[0].id,groupId);}
  else{$('schedule-template-message').textContent='暂无模板，点击“新建模板”开始。';scheduleTemplateControls();}
 }catch(error){if(scheduleTemplateRequestCurrent(request))scheduleTemplateFailure(error);}
 finally{if(scheduleTemplateRequest===request){scheduleTemplateRequest=null;scheduleTemplateControls();}}
}
function newScheduleTemplate(){
 if(scheduleTemplateRequest?.kind==='write')return;
 scheduleTemplateRequest=null;const groupId=scheduleTemplateMode==='apply'?scheduleTemplateApplyContext.groupId:$('schedule-template-target').value;
 const detail={id:crypto.randomUUID(),name:'',text:'',version:0,variables:[],targets:[],groupId,profile:{values:{},overrideText:null}};
 renderScheduleTemplateList();renderScheduleTemplateDetail(detail);$('schedule-template-message').textContent='填写名称和正文后保存；用 {{客户}} 这样的变量填写会话内容。';$('schedule-template-name').focus();
}
async function mutateScheduleTemplate(action){
 if(!scheduleTemplateDetail||scheduleTemplateRequest||scheduleTemplateConflict||!serviceAvailable)return;
 const detail=scheduleTemplateDetail,groupId=$('schedule-template-target').value,profile=scheduleTemplateProfile();
 if(action!=='save'&&detail.version===0)return;
 if(action==='profile'&&(scheduleTemplateDirty||!groupId))return;
 invalidateScheduleTemplatePreview();const request=beginScheduleTemplateRequest('write');
 const body={account:state.account,id:detail.id,version:detail.version,...(action==='save'?{name:$('schedule-template-name').value,text:$('schedule-template-body').value}:action==='profile'?{groupId,...profile}:{})};
 try{
  const result=await api('/api/schedule-templates/'+action,body);if(!scheduleTemplateRequestCurrent(request))return;
  if(action==='delete'){scheduleTemplateRows=scheduleTemplateRows.filter(row=>row.id!==detail.id);renderScheduleTemplateList();clearScheduleTemplateDialog(true);$('schedule-template-message').textContent='模板已删除；已创建的定时任务保持原正文。';return;}
  const row={id:result.id,name:result.name,version:result.version,variables:result.variables,targetCount:result.targets.length};scheduleTemplateRows=scheduleTemplateRows.filter(item=>item.id!==row.id);scheduleTemplateRows.push(row);renderScheduleTemplateList(row.id);
  renderScheduleTemplateDetail(action==='save'?{...result,groupId}:result,action==='save'?profile:result.profile);
  $('schedule-template-message').textContent=action==='save'?'模板已保存。会话变量和覆盖正文需单独保存；已创建任务不随模板变化。':'会话配置已保存，可继续预览完整正文。';
 }catch(error){if(scheduleTemplateRequestCurrent(request))scheduleTemplateFailure(error);}
 finally{if(scheduleTemplateRequest===request){scheduleTemplateRequest=null;scheduleTemplateControls();}}
}
async function previewScheduleTemplate(){
 if(!scheduleTemplateDetail||scheduleTemplateDetail.version===0||scheduleTemplateDirty||scheduleTemplateConflict||scheduleTemplateRequest||!serviceAvailable||!$('schedule-template-target').value)return;
 invalidateScheduleTemplatePreview();const detail=scheduleTemplateDetail,groupId=$('schedule-template-target').value,request=beginScheduleTemplateRequest('preview');
 $('schedule-template-message').textContent='正在生成完整正文…';
 try{
  const result=await api('/api/schedule-templates/preview',{account:state.account,id:detail.id,version:detail.version,groupId,...scheduleTemplateProfile()});
  if(!scheduleTemplateRequestCurrent(request)||request.revision!==scheduleTemplateRevision)return;
  scheduleTemplatePreview=result;$('schedule-template-preview-text').textContent=result.text;$('schedule-template-message').textContent='预览完成。保存或预览不会创建任务，也不会发送消息。';
 }catch(error){if(scheduleTemplateRequestCurrent(request)&&request.revision===scheduleTemplateRevision)scheduleTemplateFailure(error);}
 finally{if(scheduleTemplateRequest===request){scheduleTemplateRequest=null;scheduleTemplateControls();}}
}
function applyScheduleTemplate(){
 const context=scheduleTemplateApplyContext,preview=scheduleTemplatePreview;
 if(!preview||scheduleTemplateMode!=='apply'||scheduleTemplateRequest||scheduleTemplateConflict||!context||!supportsScheduleTemplates()||!serviceAvailable)return;
 if(context.account!==state.account||context.groupId!==$('schedule-group').value||context.requestId!==scheduleRequestId||context.text!==$('schedule-text').value||preview.groupId!==context.groupId||!$('schedule-dialog').open){invalidateScheduleTemplatePreview();$('schedule-template-message').textContent='创建草稿或会话已变化，请关闭后重新从模板填入。';return;}
 $('schedule-text').value=preview.text;scheduleTemplateFilled={account:state.account,groupId:preview.groupId,text:preview.text};
 $('schedule-template-source').textContent='已填入“'+preview.templateName+'”的完整正文，可手动修改。新任务将保存这份正文。';$('schedule-template-dialog').close();
}
function scheduleTemplateTargetChanged(){
 if(scheduleTemplateFilled){if(scheduleTemplateFilled.account===state.account&&$('schedule-text').value===scheduleTemplateFilled.text)$('schedule-text').value='';scheduleTemplateFilled=null;$('schedule-template-source').textContent='发送会话已变化，请核对正文或重新从模板填入。';}
 if($('schedule-template-dialog').open&&scheduleTemplateMode==='apply')$('schedule-template-dialog').close();
}
$('schedule-template-library').onclick=()=>openScheduleTemplates();$('schedule-template-fill').onclick=()=>openScheduleTemplates('apply');
$('schedule-template-new').onclick=newScheduleTemplate;
$('schedule-template-select').onchange=()=>{const id=$('schedule-template-select').value;if(id)return loadScheduleTemplate(id);clearScheduleTemplateDialog(true);};
$('schedule-template-target').onchange=()=>{const id=$('schedule-template-select').value;if(id)return loadScheduleTemplate(id);invalidateScheduleTemplatePreview();};
for(const id of ['schedule-template-name','schedule-template-body'])$(id).oninput=()=>{scheduleTemplateDirty=true;invalidateScheduleTemplatePreview();if(!scheduleTemplateConflict)$('schedule-template-message').textContent='模板有未保存修改，请先保存模板，再配置会话或预览。';};
$('schedule-template-override').onchange=invalidateScheduleTemplatePreview;$('schedule-template-override-text').oninput=invalidateScheduleTemplatePreview;
for(const action of ['save','profile','delete'])$('schedule-template-'+(action==='profile'?'profile-save':action)).onclick=()=>mutateScheduleTemplate(action);
$('schedule-template-reload').onclick=()=>loadScheduleTemplate(scheduleTemplateDetail.id);
$('schedule-template-preview').onclick=previewScheduleTemplate;$('schedule-template-apply').onclick=applyScheduleTemplate;
$('schedule-template-dialog').addEventListener('close',clearScheduleTemplateDialog);
$('schedule-group').addEventListener('change',scheduleTemplateTargetChanged);
$('schedule-text').addEventListener('input',()=>{if(scheduleTemplateFilled){scheduleTemplateFilled=null;$('schedule-template-source').textContent='正文已手动修改，请按当前会话核对。';}if($('schedule-template-dialog').open&&scheduleTemplateMode==='apply')invalidateScheduleTemplatePreview();});
$('schedule-dialog').addEventListener('close',()=>{if(scheduleTemplateMode==='apply')$('schedule-template-dialog').close();resetScheduleTemplateFill();});
