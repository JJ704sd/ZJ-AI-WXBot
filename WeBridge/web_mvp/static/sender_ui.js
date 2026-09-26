'use strict';
// Retained for visual diagnostics only. The product send route now awaits Windows Hook.
let desktopSenderData=null,desktopSenderBusy='',desktopSenderVersion=0,desktopSenderPreview=null,desktopSenderDraft=null,desktopSenderExpiry=null,desktopSenderUnknown=false,desktopSenderTouched=false,desktopSenderPresent=false;
let desktopComposePoint=null,desktopSendPoint=null,desktopPointMode='compose',desktopImageReady=false;
let desktopTargetsKey='';
const senderSupported=()=>state.runtime?.capabilities?.visualSendDiagnostics===true;
const senderWindow=()=>desktopSenderData?.windows?.[Number($('desktop-sender-window').value)];
const senderTarget=()=>$('desktop-sender-target-select').value;
const senderTargetAllowed=id=>id==='filehelper'||(state.groups||[]).some(item=>item.id===id);
const senderTargetName=data=>typeof data?.targetName==='string'&&data.targetName.trim()?data.targetName:data?.targetId==='filehelper'?'文件传输助手':null;
const senderExpiry=value=>typeof value==='number'?value*(value<1e12?1000:1):Date.parse(value||'');
function renderDesktopTargets(){
 const options=[{id:'filehelper',name:'文件传输助手'},...(state.groups||[]).filter(item=>item.id&&item.id!=='filehelper')],key=JSON.stringify([state.account,options]);
 if(key===desktopTargetsKey)return;desktopTargetsKey=key;
 const select=$('desktop-sender-target-select'),previous=select.value||'filehelper',retained=options.some(item=>item.id===previous);
 if(!retained&&(desktopSenderPreview||desktopSenderDraft)){const touched=desktopSenderTouched;discardDesktopPending();desktopSenderUnknown=touched;senderResult('原目标已不在当前账号的会话列表中，本次确认已取消。'+(touched?'请在微信核对已填入的草稿。':''));}
 select.replaceChildren();for(const item of options){const option=el('option','',item.name+(item.id==='filehelper'?'':' · '+item.id));option.value=item.id;select.append(option);}select.value=retained?previous:'filehelper';
}
function senderResult(text){$('desktop-sender-result').textContent=text||'';$('desktop-sender-result').hidden=!text;}
function discardDesktopPending(){
 ++desktopSenderVersion;clearTimeout(desktopSenderExpiry);desktopSenderPreview=null;desktopSenderDraft=null;desktopComposePoint=null;desktopSendPoint=null;desktopImageReady=false;
 $('desktop-sender-prepared').hidden=true;$('desktop-sender-confirmed').checked=false;$('desktop-sender-confirm-text').textContent='';$('desktop-sender-visual').replaceChildren();$('desktop-sender-visual').hidden=true;
}
function resetDesktopSender(clearText=false){
 const uncertain=desktopSenderTouched||desktopSenderBusy==='stage'||desktopSenderBusy==='confirm'||desktopSenderUnknown;
 discardDesktopPending();desktopSenderData=null;desktopSenderUnknown=uncertain;
 $('desktop-sender-window').replaceChildren(el('option','','请重新检测发送能力'));
 if(clearText){$('desktop-sender-text').value='';$('desktop-sender-target-select').value='filehelper';}
 $('desktop-sender-badge').textContent='尚未检测';$('desktop-sender-status').textContent='窗口绑定与确认已清除，请重新检测。';
 senderResult(uncertain?'本次操作的后续结果未确认。请先在微信核对草稿与发送结果，工作台不会自动重试。':'');
 updateDesktopSenderControls();
}
function updateDesktopSender(){
 const present=senderSupported();$('desktop-sender-panel').hidden=!present;$('desktop-sender-entry').hidden=!present;
 if(desktopSenderPresent&&!present)resetDesktopSender();desktopSenderPresent=present;renderDesktopTargets();updateDesktopSenderControls();
}
function desktopReady(){
 const win=senderWindow();return senderSupported()&&serviceAvailable&&desktopSenderData?.supported!==false&&desktopSenderData?.available===true&&senderTargetAllowed(senderTarget())&&win&&!desktopSenderUnknown;
}
function updateDesktopSenderControls(){
 const busy=!!desktopSenderBusy,ready=desktopReady();
 $('desktop-sender-detect').disabled=busy||!serviceAvailable;
 $('desktop-sender-detect').textContent=desktopSenderBusy==='detect'?'正在检测…':desktopSenderUnknown?'已核对微信，重新检测':'检测发送能力';
 $('desktop-sender-window').disabled=busy||!desktopSenderData?.windows?.length||!!desktopSenderDraft;
 $('desktop-sender-target-select').disabled=busy||!!desktopSenderDraft;
 $('desktop-sender-text').disabled=busy||!senderSupported()||!!desktopSenderDraft;
 $('desktop-sender-prepare').disabled=busy||!ready||!$('desktop-sender-text').value.trim()||!!desktopSenderDraft;
 $('desktop-sender-prepare').textContent=desktopSenderBusy==='preview'?'正在获取窗口截图…':'获取窗口截图并选定位置';
 const stage=$('desktop-sender-stage');if(stage)stage.disabled=busy||!ready||!desktopSenderPreview||desktopSenderPreview.targetId!==senderTarget()||!desktopImageReady||!desktopComposePoint||!desktopSendPoint||!$('desktop-sender-target-check')?.checked||!$('desktop-sender-empty-check')?.checked;
 const expires=senderExpiry(desktopSenderDraft?.expiresAt);
 $('desktop-sender-confirm').disabled=busy||!ready||!desktopSenderDraft||desktopSenderDraft.targetId!==senderTarget()||!desktopImageReady||expires<=Date.now()||!$('desktop-sender-confirmed').checked;
 $('desktop-sender-confirmed').disabled=busy;$('desktop-sender-cancel').disabled=busy;
}
function armDesktopExpiry(data){
 clearTimeout(desktopSenderExpiry);const delay=senderExpiry(data.expiresAt)-Date.now();
 if(!Number.isFinite(delay)||delay<=0)return false;
 desktopSenderExpiry=setTimeout(()=>{const touched=desktopSenderTouched;discardDesktopPending();if(touched)desktopSenderUnknown=true;senderResult(touched?'确认已过期。微信中可能仍有已填入的草稿，请先核对再重新检测。':'截图已过期，请重新获取窗口截图。');updateDesktopSenderControls();},Math.min(delay,2147483647));return true;
}
function validSenderImage(data){return /^data:image\/(png|jpeg);base64,/.test(data.imageDataUrl||'')&&Number.isInteger(data.width)&&Number.isInteger(data.height)&&data.width>0&&data.height>0&&data.width<=10000&&data.height<=10000;}
function renderSenderImage(data,selectPoints){
 const area=$('desktop-sender-visual');area.replaceChildren();area.hidden=false;desktopImageReady=false;
 const targetName=senderTargetName(data);
 area.append(el('p','',selectPoints?'请核对截图中的账号与目标“'+targetName+'”（'+data.targetId+'），再点选空输入框与发送按钮。此处由你人工绑定窗口，会话 ID 未经窗口自动认证。':'这是向“'+targetName+'”填入草稿后的新截图。请再次核对目标、完整正文与输入框，尚未点击发送。'));
 let pointStatus;
 if(selectPoints){
  const modes=el('div','sender-point-modes');
  for(const [mode,label] of [['compose','① 点选输入框'],['send','② 点选发送按钮']]){const button=el('button','button secondary',label);button.type='button';button.dataset.pointMode=mode;button.setAttribute('aria-pressed',String(mode===desktopPointMode));button.onclick=()=>{if(desktopSenderBusy)return;desktopPointMode=mode;for(const other of modes.children)other.setAttribute('aria-pressed',String(other===button));};modes.append(button);}
  area.append(modes);pointStatus=el('p','sender-point-status','尚未选择输入框与发送按钮');area.append(pointStatus);
 }
 const wrap=el('div','sender-image-wrap'),img=el('img');img.alt=selectPoints?'所选微信窗口截图，待选择输入框与发送按钮':'所选微信窗口填入草稿后的截图';
 const version=desktopSenderVersion;
 img.onload=()=>{if(version!==desktopSenderVersion)return;desktopImageReady=img.naturalWidth===data.width&&img.naturalHeight===data.height;if(!desktopImageReady)senderResult('截图尺寸与预检信息不一致，请重新检测。');updateDesktopSenderControls();};
 img.onerror=()=>{if(version!==desktopSenderVersion)return;desktopImageReady=false;senderResult('截图未能显示，请重新检测；工作台不会继续发送。');updateDesktopSenderControls();};
 img.src=data.imageDataUrl;wrap.append(img);area.append(wrap);
 if(selectPoints){
  img.onclick=event=>{
   if(desktopSenderBusy||!desktopSenderPreview||!desktopImageReady)return;
   const rect=img.getBoundingClientRect(),width=img.clientWidth,height=img.clientHeight;
   const point=[Math.max(0,Math.min(data.width-1,Math.floor((event.clientX-rect.left-img.clientLeft)*data.width/width))),Math.max(0,Math.min(data.height-1,Math.floor((event.clientY-rect.top-img.clientTop)*data.height/height)))];
   if(desktopPointMode==='compose'){desktopComposePoint=point;desktopPointMode='send';}else desktopSendPoint=point;
   $('desktop-sender-target-check').checked=false;$('desktop-sender-empty-check').checked=false;
   wrap.querySelectorAll('.sender-point-marker').forEach(node=>node.remove());
   for(const [value,label] of [[desktopComposePoint,'①'],[desktopSendPoint,'②']])if(value){const mark=el('span','sender-point-marker',label);mark.style.left=(value[0]/data.width*100)+'%';mark.style.top=(value[1]/data.height*100)+'%';wrap.append(mark);}
   pointStatus.textContent='输入框：'+(desktopComposePoint?.join(', ')||'未选')+'；发送按钮：'+(desktopSendPoint?.join(', ')||'未选');
   area.querySelectorAll('[data-point-mode]').forEach(button=>button.setAttribute('aria-pressed',String(button.dataset.pointMode===desktopPointMode)));updateDesktopSenderControls();
  };
  for(const [id,label] of [['desktop-sender-target-check','我已在微信中打开并核对“'+targetName+'”及当前账号'],['desktop-sender-empty-check','“'+targetName+'”的输入框为空，没有文字草稿、附件或待发送内容']]){const row=el('label','sender-confirmation'),input=el('input');input.type='checkbox';input.id=id;input.onchange=updateDesktopSenderControls;row.append(input,el('span','',label));area.append(row);}
  const stage=el('button','button primary','仅填入草稿，暂不发送');stage.type='button';stage.id='desktop-sender-stage';stage.disabled=true;stage.onclick=stageDesktopDraft;area.append(stage);
 }
}
$('desktop-sender-entry').onclick=()=>{setView('environment');$('desktop-sender-panel').scrollIntoView({behavior:'smooth',block:'start'});$('desktop-sender-detect').focus({preventScroll:true});};
$('desktop-sender-detect').onclick=async()=>{
 if(desktopSenderBusy||!senderSupported())return;
 const hadDraft=desktopSenderTouched||desktopSenderUnknown;
 discardDesktopPending();desktopSenderData=null;desktopSenderUnknown=false;desktopSenderTouched=false;senderResult(hadDraft?'请核对微信输入框。上次填入的草稿不会被工作台自动清除。':'');
 const version=desktopSenderVersion;desktopSenderBusy='detect';$('desktop-sender-badge').textContent='检测中';updateDesktopSenderControls();
 try{
  const data=await api('/api/windows/sender');if(version!==desktopSenderVersion)return;desktopSenderData=data;
  const select=$('desktop-sender-window');select.replaceChildren();
  for(const [index,win] of (data.windows||[]).entries()){const option=el('option','',(win.title||'微信窗口')+(win.minimized?'（预检时恢复窗口）':win.visible===false?'（当前不可见）':''));option.value=index;select.append(option);}
  const preferred=(data.windows||[]).findIndex(win=>win.visible!==false&&!win.minimized);if(preferred>=0)select.value=String(preferred);
  if(!select.children.length)select.append(el('option','','未检测到可用窗口'));
  $('desktop-sender-badge').textContent=data.available?'可进行预检':'暂不可用';$('desktop-sender-status').textContent=data.issue||(data.available?'请选择窗口，输入文本，再获取截图。检测结果仅代表此刻状态。':'当前窗口未满足发送预检条件，请检查微信后重新检测。');
 }catch(error){if(version===desktopSenderVersion){$('desktop-sender-badge').textContent='检测失败';$('desktop-sender-status').textContent=error.message;}}
 finally{desktopSenderBusy='';updateDesktopSenderControls();}
};
function changeDesktopInput(){if(desktopSenderBusy)return;discardDesktopPending();senderResult('');updateDesktopSenderControls();}
$('desktop-sender-window').onchange=changeDesktopInput;$('desktop-sender-text').oninput=changeDesktopInput;
$('desktop-sender-target-select').onchange=changeDesktopInput;
$('desktop-sender-form').onsubmit=async event=>{
 event.preventDefault();if($('desktop-sender-prepare').disabled||desktopSenderBusy)return;
 const win=senderWindow(),targetId=senderTarget();discardDesktopPending();senderResult('');const version=desktopSenderVersion;desktopSenderBusy='preview';desktopPointMode='compose';updateDesktopSenderControls();
 try{
  const data=await api('/api/windows/send/preview',{pid:win.pid,hwnd:win.hwnd,targetId});if(version!==desktopSenderVersion||targetId!==senderTarget())return;
  if(data.status!=='preview'||data.targetId!==targetId||!senderTargetName(data)||!data.previewToken||!validSenderImage(data)||!armDesktopExpiry(data)){senderResult(data.issue||'未取得目标一致、可核对的有效截图，请重新检测。');return;}
  desktopSenderPreview=data;renderSenderImage(data,true);$('desktop-sender-badge').textContent='等待点选';
 }catch(error){if(version===desktopSenderVersion)senderResult('截图预检未完成，尚未填入或发送文本。'+error.message);}
 finally{desktopSenderBusy='';updateDesktopSenderControls();}
};
async function stageDesktopDraft(){
 if(desktopSenderBusy||$('desktop-sender-stage')?.disabled||!desktopSenderPreview)return;
 const preview=desktopSenderPreview,text=$('desktop-sender-text').value,version=desktopSenderVersion;
 desktopSenderBusy='stage';desktopSenderTouched=true;clearTimeout(desktopSenderExpiry);senderResult('正在填入微信草稿，请保持窗口可见且不要操作微信。尚未点击发送。');updateDesktopSenderControls();
 try{
  const data=await api('/api/windows/send/stage',{previewToken:preview.previewToken,composePoint:desktopComposePoint,sendPoint:desktopSendPoint,text,idempotencyKey:crypto.randomUUID(),targetConfirmed:true,emptyDraftConfirmed:true});
  if(version!==desktopSenderVersion)return;desktopSenderPreview=null;
  if(data.status!=='staged'||data.targetId!==preview.targetId||senderTargetName(data)!==senderTargetName(preview)||!data.draftId||!data.textHash||data.text!==text||!validSenderImage(data)||!armDesktopExpiry(data)){desktopSenderUnknown=true;discardDesktopPending();senderResult((data.issue||'草稿填入后未取得目标一致、可核对的新截图或确认信息。')+' 请在微信核对输入框，工作台未执行最终发送。');$('desktop-sender-badge').textContent='请核对微信';return;}
  desktopSenderDraft=data;renderSenderImage(data,false);$('desktop-sender-prepared').hidden=false;$('desktop-sender-target').textContent='目标：'+senderTargetName(data)+'（'+data.targetId+'） · 人工绑定窗口，未自动认证会话 ID';$('desktop-sender-confirmation-label').textContent='我已核对“'+senderTargetName(data)+'”和完整正文，确认只发送一次';$('desktop-sender-confirm-text').textContent=data.text;$('desktop-sender-expiry').textContent='本次确认有效至 '+stamp(senderExpiry(data.expiresAt)/1000,{hour:'2-digit',minute:'2-digit',second:'2-digit'})+'（上海时间）';$('desktop-sender-confirmed').checked=false;$('desktop-sender-badge').textContent='草稿待确认';senderResult('草稿已填入，尚未发送。请核对上方新截图与下方完整正文，再决定是否发送一次。');
 }catch(error){if(version===desktopSenderVersion){desktopSenderUnknown=true;discardDesktopPending();senderResult('草稿填入结果未确认。请在微信核对输入框；工作台不会重试或自动发送。'+error.message);}}
 finally{desktopSenderBusy='';updateDesktopSenderControls();}
}
$('desktop-sender-confirmed').onchange=updateDesktopSenderControls;
$('desktop-sender-cancel').onclick=()=>{if(desktopSenderBusy)return;const touched=desktopSenderTouched;discardDesktopPending();desktopSenderUnknown=touched;senderResult(touched?'已取消本次确认。微信中的草稿可能仍保留，请自行核对；工作台未点击发送按钮。':'已取消本次确认。');updateDesktopSenderControls();};
$('desktop-sender-confirm').onclick=async()=>{
 if(desktopSenderBusy||$('desktop-sender-confirm').disabled||!desktopSenderDraft)return;
 const draft=desktopSenderDraft,version=desktopSenderVersion;desktopSenderDraft=null;clearTimeout(desktopSenderExpiry);desktopSenderBusy='confirm';$('desktop-sender-prepared').hidden=true;senderResult('正在提交一次发送，请勿重复操作。');updateDesktopSenderControls();
 try{
  const data=await api('/api/windows/send/confirm',{draftId:draft.draftId,textHash:draft.textHash,targetConfirmed:true,textConfirmed:true});if(version!==desktopSenderVersion)return;
  desktopSenderUnknown=true;$('desktop-sender-badge').textContent=data.status==='submitted_unconfirmed'?'已提交 · 未确认送达':data.status==='blocked'?'操作被阻止':'结果未确认';
  senderResult((data.status==='submitted_unconfirmed'?'已提交一次发送，尚未确认送达。':data.status==='blocked'?'发送操作被阻止。':'发送结果未确认。')+(data.issue?' '+data.issue:'')+' 请在微信“'+senderTargetName(draft)+'”中核对，工作台不会自动重试，也不会记作已送达。');
 }catch(error){if(version===desktopSenderVersion){desktopSenderUnknown=true;$('desktop-sender-badge').textContent='结果未确认';senderResult('发送请求结果未确认，请在微信核对，勿直接重复发送。'+error.message);}}
 finally{desktopSenderBusy='';updateDesktopSenderControls();}
};
document.addEventListener('visibilitychange',()=>{if(document.hidden)resetDesktopSender();});window.addEventListener('pagehide',()=>resetDesktopSender());
