'use strict';
let approvedReplyScope='',approvedReplyPolicy=null,approvedReplyCards=[],approvedReplyCardId='',approvedReplyRequest=null,approvedReplyRevision=0,approvedReplyConflict=false,approvedReplyPreview=null;
function supportsApprovedReplies(){return isDatabase()&&state.runtime?.capabilities?.approvedReplies===true;}
function approvedReplyGroup(){return (state.groups||[]).find(group=>group.id===selected);}
function approvedReplyScopeKey(){return JSON.stringify([state.account,selected,state.runtime?.mode,state.runtime?.source?.id,supportsApprovedReplies()]);}
function invalidateApprovedReplyPreview(){
 ++approvedReplyRevision;approvedReplyPreview=null;$('approved-preview-result').replaceChildren();
 if(approvedReplyRequest&&approvedReplyRequest.kind!=='write')approvedReplyRequest=null;
 approvedReplyControls();
}
function clearApprovedReply(){
 if(approvedReplyRequest?.kind==='write')replyBusy=false;
 approvedReplyRequest=null;approvedReplyPolicy=null;approvedReplyCards=[];approvedReplyCardId='';approvedReplyConflict=false;
 $('approved-card-select').replaceChildren();$('approved-cooldown').value='30';$('approved-preview-input').value='';$('approved-policy-state').textContent='';$('approved-message').textContent='';renderApprovedReplyCard();invalidateApprovedReplyPreview();
}
function updateApprovedReplyScope(){
 const scope=approvedReplyScopeKey();if(scope!==approvedReplyScope){approvedReplyScope=scope;clearApprovedReply();$('approved-reply-dialog').close();}
 $('reply-approved-option').hidden=!supportsApprovedReplies();$('reply-approved-option').disabled=!supportsApprovedReplies();approvedReplyControls();
}
function approvedReplyControls(){
 const busy=!!approvedReplyRequest,writing=approvedReplyRequest?.kind==='write',loaded=!!approvedReplyPolicy,card=approvedReplyCards.find(row=>row.id===approvedReplyCardId);
 for(const id of ['approved-card-select','approved-cooldown'])$(id).disabled=!loaded||writing;
 for(const id of ['approved-card-name','approved-source-title','approved-source-version','approved-source-text','approved-reply-text'])$(id).disabled=!card||writing;
 for(const input of $('approved-questions').querySelectorAll('textarea'))input.disabled=writing;
 for(const button of $('approved-questions').querySelectorAll('button'))button.disabled=writing||card.questions.length===1;
 $('approved-card-add').disabled=!loaded||writing||approvedReplyCards.length>=20;$('approved-card-remove').disabled=!card||writing;
 $('approved-question-add').disabled=!card||writing||card.questions.length>=5;
 $('approved-save-draft').disabled=!loaded||busy||approvedReplyConflict||!serviceAvailable;
 $('approved-enable').disabled=!loaded||busy||approvedReplyConflict||!serviceAvailable||!approvedReplyCards.length;
 $('approved-reload').disabled=busy||!serviceAvailable;
 $('approved-preview-button').disabled=!loaded||busy||approvedReplyConflict||!serviceAvailable;
 $('approved-preview-input').disabled=!loaded||writing;
 $('approved-card-count').textContent=approvedReplyCards.length+' / 20 张卡片';
}
function renderApprovedReplyCard(){
 const card=approvedReplyCards.find(row=>row.id===approvedReplyCardId);
 for(const [id,key] of [['approved-card-name','name'],['approved-source-title','sourceTitle'],['approved-source-version','sourceVersion'],['approved-source-text','sourceText'],['approved-reply-text','replyText']])$(id).value=card?card[key]:'';
 const questions=$('approved-questions');questions.replaceChildren();
 if(card)card.questions.forEach((question,index)=>{const row=el('div','approved-question'),label=el('label','','完整问法 '+(index+1)),input=el('textarea');input.rows=2;input.maxLength=500;input.value=question;input.oninput=()=>{card.questions[index]=input.value;invalidateApprovedReplyPreview();};label.append(input);const remove=el('button','button quiet','删除此问法');remove.type='button';remove.onclick=()=>{card.questions.splice(index,1);invalidateApprovedReplyPreview();renderApprovedReplyCard();};row.append(label,remove);questions.append(row);});
 approvedReplyControls();
}
function renderApprovedReplyCards(){
 const select=$('approved-card-select');select.replaceChildren();
 if(!approvedReplyCards.length){const empty=el('option','','暂无卡片，可新建或保存空草稿');empty.value='';select.append(empty);}
 for(const [index,card] of approvedReplyCards.entries()){const option=el('option','',(index+1)+'. '+(card.name||'未命名卡片'));option.value=card.id;select.append(option);}
 select.value=approvedReplyCardId;renderApprovedReplyCard();
}
function renderApprovedReplyPolicy(policy){
 approvedReplyPolicy=policy;approvedReplyCards=policy.cards.map(card=>({...card,questions:[...card.questions]}));approvedReplyConflict=false;
 approvedReplyCardId=approvedReplyCards.some(card=>card.id===approvedReplyCardId)?approvedReplyCardId:approvedReplyCards.length?approvedReplyCards[0].id:'';
 $('approved-cooldown').value=String(policy.cooldown);
 $('approved-policy-state').textContent='当前群：'+groupName(policy.groupId)+' · '+policy.groupId+' · 策略版本 '+policy.version+' · '+(policy.mode==='approved'?(policy.enabled?'批准问答已启用':'批准问答已关闭'):'当前使用'+(policy.mode==='handoff'?'人工待办':'固定文本回复')+'规则；保存草稿不改变该规则，批准启用会切换本群处理方式。')+(policy.sendingPaused?' · 自动发送已暂停，读取处理继续，符合条件的新消息转人工。':'')+(policy.issue?' · '+policy.issue:'');
 renderApprovedReplyCards();invalidateApprovedReplyPreview();
}
function approvedReplyCurrent(request){return approvedReplyRequest===request&&request.scope===approvedReplyScopeKey();}
async function loadApprovedReply(){
 if(!supportsApprovedReplies()||!serviceAvailable||approvedReplyRequest?.kind==='write')return;
 invalidateApprovedReplyPreview();const request={kind:'read',scope:approvedReplyScopeKey(),revision:approvedReplyRevision};approvedReplyRequest=request;approvedReplyControls();$('approved-message').textContent='正在读取本群批准问答…';
 try{const result=await api('/api/reply/policy?'+new URLSearchParams({account:state.account,groupId:selected}));if(!approvedReplyCurrent(request)||request.revision!==approvedReplyRevision)return;renderApprovedReplyPolicy(result);$('approved-message').textContent='已读取策略。编辑不会生效，需明确保存或批准启用。';}
 catch(error){if(approvedReplyCurrent(request))$('approved-message').textContent='读取失败，已有草稿保留：'+error.message;}
 finally{if(approvedReplyRequest===request){approvedReplyRequest=null;approvedReplyControls();}}
}
async function openApprovedReply(){
 updateApprovedReplyScope();if(!supportsApprovedReplies()||!state.account||approvedReplyGroup()?.conversationKind!=='group')return;
 $('approved-reply-dialog').showModal();if(!approvedReplyPolicy&&serviceAvailable)return loadApprovedReply();approvedReplyControls();
 if(!serviceAvailable)$('approved-message').textContent='本机服务未连接；可查看和编辑本页已有草稿，恢复连接后再保存。';
}
function addApprovedReplyCard(){
 if(!approvedReplyPolicy||approvedReplyRequest?.kind==='write'||approvedReplyCards.length>=20)return;
 const card={id:crypto.randomUUID(),name:'',questions:[''],sourceTitle:'',sourceVersion:'',sourceText:'',replyText:''};approvedReplyCards.push(card);approvedReplyCardId=card.id;invalidateApprovedReplyPreview();renderApprovedReplyCards();
}
async function saveApprovedReply(enabled){
 if(!approvedReplyPolicy||approvedReplyRequest||approvedReplyConflict||!serviceAvailable||!supportsApprovedReplies()||replyBusy)return;
 const cooldown=Number($('approved-cooldown').value);if(!Number.isInteger(cooldown)||cooldown<5||cooldown>3600){$('approved-message').textContent='回复间隔请输入 5 到 3600 之间的整数秒。';return;}
 invalidateApprovedReplyPreview();const request={kind:'write',scope:approvedReplyScopeKey()};approvedReplyRequest=request;replyBusy=true;controls();$('approved-message').textContent=enabled?'正在保存批准配置并启用…':'正在保存草稿或关闭批准问答…';
 try{
  const result=await api('/api/reply/policy',{account:state.account,groupId:selected,version:approvedReplyPolicy.version,enabled,cooldown,cards:approvedReplyCards});if(!approvedReplyCurrent(request))return;
  renderApprovedReplyPolicy(result);replyDirty=false;$('approved-message').textContent=enabled?'已批准并启用。本群后续符合条件的新消息按整条问法匹配；发送结果以执行记录为准。':'已保存草稿；批准问答已关闭，原固定回复或人工待办规则保持不变。';
 }catch(error){if(approvedReplyCurrent(request)){approvedReplyConflict=error.status===409;$('approved-message').textContent=approvedReplyConflict?'策略已变化（409），草稿已保留。请复制需要保留的内容，再点击“重新加载”核对；不会自动覆盖。':(error.status===400?'未保存，草稿已保留：':'未确认保存结果，草稿已保留，请重新加载核对。')+error.message;}}
 finally{if(approvedReplyRequest===request){approvedReplyRequest=null;replyBusy=false;controls();}}
}
async function previewApprovedReply(){
 if(!approvedReplyPolicy||approvedReplyRequest||approvedReplyConflict||!serviceAvailable||!supportsApprovedReplies())return;
 invalidateApprovedReplyPreview();const request={kind:'preview',scope:approvedReplyScopeKey(),revision:approvedReplyRevision};approvedReplyRequest=request;approvedReplyControls();
 try{
  const result=await api('/api/reply/policy/preview',{account:state.account,groupId:selected,version:approvedReplyPolicy.version,cards:approvedReplyCards,text:$('approved-preview-input').value});if(!approvedReplyCurrent(request)||request.revision!==approvedReplyRevision)return;
  approvedReplyPreview=result;const output=$('approved-preview-result');output.replaceChildren();output.append(el('strong','',result.decision==='reply'?'文本匹配到批准回复':'文本未采用批准回复，将转人工'),el('p','subtle',result.reason+' · '+result.reasonCode+' · 策略版本 '+result.policyVersion));
  if(result.matchedCard){output.append(el('p','subtle','卡片：'+result.matchedCard.name+' · 资料：'+result.matchedCard.sourceTitle+' / '+result.matchedCard.sourceVersion),el('pre','approved-full-text',result.replyText));}
  output.append(el('p','subtle','仅核对本次输入文本；没有验证真实 @，没有保存策略或发送消息。'));
 }catch(error){if(approvedReplyCurrent(request)){approvedReplyConflict=error.status===409;$('approved-message').textContent=(approvedReplyConflict?'策略已变化（409），草稿保留，请明确重新加载。':'预览失败：')+error.message;}}
 finally{if(approvedReplyRequest===request){approvedReplyRequest=null;approvedReplyControls();}}
}
$('approved-card-add').onclick=addApprovedReplyCard;
$('approved-card-select').onchange=()=>{approvedReplyCardId=$('approved-card-select').value;renderApprovedReplyCard();};
$('approved-card-remove').onclick=()=>{approvedReplyCards=approvedReplyCards.filter(card=>card.id!==approvedReplyCardId);approvedReplyCardId=approvedReplyCards.length?approvedReplyCards[0].id:'';invalidateApprovedReplyPreview();renderApprovedReplyCards();};
$('approved-question-add').onclick=()=>{const card=approvedReplyCards.find(row=>row.id===approvedReplyCardId);if(!card||card.questions.length>=5)return;card.questions.push('');invalidateApprovedReplyPreview();renderApprovedReplyCard();};
for(const [id,key] of [['approved-card-name','name'],['approved-source-title','sourceTitle'],['approved-source-version','sourceVersion'],['approved-source-text','sourceText'],['approved-reply-text','replyText']])$(id).oninput=()=>{const card=approvedReplyCards.find(row=>row.id===approvedReplyCardId);if(!card)return;card[key]=$(id).value;invalidateApprovedReplyPreview();if(key==='name'){for(const option of $('approved-card-select').children)if(option.value===card.id)option.textContent=(approvedReplyCards.indexOf(card)+1)+'. '+(card.name||'未命名卡片');}};
$('approved-cooldown').oninput=invalidateApprovedReplyPreview;$('approved-preview-input').oninput=invalidateApprovedReplyPreview;
$('approved-reload').onclick=loadApprovedReply;$('approved-save-draft').onclick=()=>saveApprovedReply(false);$('approved-enable').onclick=()=>saveApprovedReply(true);$('approved-preview-button').onclick=previewApprovedReply;
$('approved-reply-dialog').addEventListener('close',()=>{if(!$('approved-reply-dialog').open)invalidateApprovedReplyPreview();});
