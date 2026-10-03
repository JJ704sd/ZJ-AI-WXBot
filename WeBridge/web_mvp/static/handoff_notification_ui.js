'use strict';
let handoffNotifyScope='',handoffNotifyConfigs=[],handoffNotifyRecipients=[],handoffNotifyConfig=null,handoffNotifyRequest=null,handoffNotifyConflict=false;
function supportsHandoffNotifications(){return isDatabase()&&state.runtime?.capabilities?.handoffNotifications===true;}
function clearHandoffNotificationConfig(){
 handoffNotifyRequest=null;handoffNotifyConfigs=[];handoffNotifyRecipients=[];handoffNotifyConfig=null;handoffNotifyConflict=false;
 $('handoff-notify-group').replaceChildren();$('handoff-notify-target').replaceChildren();$('handoff-notify-enabled').checked=false;
 $('handoff-notify-owner').textContent='';$('handoff-notify-current').textContent='';$('handoff-notify-message').textContent='';$('handoff-notify-example').textContent='';handoffNotificationControls();
}
function updateHandoffNotificationScope(){
 const scope=handoffScopeKey();if(scope!==handoffNotifyScope){handoffNotifyScope=scope;clearHandoffNotificationConfig();$('handoff-notification-dialog').close();}
 $('handoff-notification-open').hidden=!supportsHandoffNotifications();$('handoff-notification-open').disabled=!state.account||!serviceAvailable;
 handoffNotificationControls();
}
function handoffNotificationControls(){
 const busy=!!handoffNotifyRequest,eligible=handoffNotifyRecipients.some(target=>target.id===$('handoff-notify-target').value);
 $('handoff-notify-group').disabled=!handoffNotifyConfigs.length||handoffNotifyRequest?.kind==='write';
 $('handoff-notify-target').disabled=!handoffNotifyConfig||busy;
 $('handoff-notify-enabled').disabled=!handoffNotifyConfig||busy||handoffNotifyConflict||(!$('handoff-notify-enabled').checked&&(!handoffNotifyConfig.owner||!eligible));
 $('handoff-notify-save').disabled=!handoffNotifyConfig||busy||handoffNotifyConflict||!serviceAvailable;
 $('handoff-notify-reload').disabled=busy||!serviceAvailable;
}
function renderHandoffNotificationExample(){
 if(!handoffNotifyConfig){$('handoff-notify-example').textContent='';return;}
 const target=handoffNotifyRecipients.find(item=>item.id===$('handoff-notify-target').value);
 $('handoff-notify-example').textContent='接收私聊：'+(target?target.name+' · '+target.id:'尚未选择有效私聊')+'\n\n【新人工待办】\n群：'+handoffNotifyConfig.groupName+' · '+handoffNotifyConfig.groupId+'\n负责人：'+(handoffNotifyConfig.owner||'尚未配置')+'\n发起人：[新消息发送者姓名 · 账号 ID]\n时间：[新消息的北京时间]\n原因：[待办原因]\n待办编号：[新生成的编号]\n原消息：[新待办的原消息摘要，超长会标记截断]\n请在本机工作台核对并领取。提醒不代表已领取或完成。';
}
function selectHandoffNotificationConfig(groupId){
 handoffNotifyRequest=null;handoffNotifyConfig=handoffNotifyConfigs.find(config=>config.groupId===groupId)||null;handoffNotifyConflict=false;
 $('handoff-notify-group').value=groupId;$('handoff-notify-message').textContent='';
 const select=$('handoff-notify-target');select.replaceChildren();const empty=el('option','','选择已读取的接收私聊');empty.value='';select.append(empty);
 for(const recipient of handoffNotifyRecipients){const option=el('option','',recipient.name+' · '+recipient.id);option.value=recipient.id;select.append(option);}
 if(handoffNotifyConfig){
  const config=handoffNotifyConfig;
  if(config.targetId&&!handoffNotifyRecipients.some(target=>target.id===config.targetId)){const removed=el('option','','已失效：'+config.targetName+' · '+config.targetId);removed.value=config.targetId;removed.disabled=true;select.append(removed);}
  select.value=config.targetId;$('handoff-notify-enabled').checked=config.enabled;
  $('handoff-notify-owner').textContent='本机负责人标签：'+(config.owner||'未配置，请先设置群负责人')+' · 标签版本 '+config.routeVersion;
  $('handoff-notify-current').textContent=(config.enabled?'自动通知已开启，仅处理新待办':'自动通知已关闭')+' · 配置版本 '+config.version+(config.issue?' · '+config.issue:'');
 }else{select.value='';$('handoff-notify-enabled').checked=false;$('handoff-notify-owner').textContent='';$('handoff-notify-current').textContent='';}
 renderHandoffNotificationExample();handoffNotificationControls();
}
function handoffNotifyRequestCurrent(request){return handoffNotifyRequest===request&&request.scope===handoffScopeKey()&&$('handoff-notification-dialog').open;}
async function loadHandoffNotifications(){
 if(!supportsHandoffNotifications()||!state.account||!serviceAvailable||handoffNotifyRequest?.kind==='write')return;
 const groupId=$('handoff-notify-group').value,request={kind:'read',scope:handoffScopeKey()};handoffNotifyRequest=request;handoffNotificationControls();$('handoff-notify-message').textContent='正在读取通知配置…';
 try{
  const data=await api('/api/handoffs/notifications?'+new URLSearchParams({account:state.account}));if(!handoffNotifyRequestCurrent(request))return;
  handoffNotifyConfigs=data.configs;handoffNotifyRecipients=data.recipients;const select=$('handoff-notify-group');select.replaceChildren();
  for(const config of data.configs){const option=el('option','',config.groupName+' · '+config.groupId);option.value=config.groupId;select.append(option);}
  selectHandoffNotificationConfig(data.configs.some(config=>config.groupId===groupId)?groupId:data.configs.length?data.configs[0].groupId:'');
  if(!data.configs.length)$('handoff-notify-message').textContent='当前没有已读取群，请先选择读取范围。';
 }catch(error){if(handoffNotifyRequestCurrent(request))$('handoff-notify-message').textContent='读取失败：'+error.message;}
 finally{if(handoffNotifyRequest===request){handoffNotifyRequest=null;handoffNotificationControls();}}
}
async function openHandoffNotifications(){
 updateHandoffNotificationScope();if(!supportsHandoffNotifications()||!state.account||!serviceAvailable)return;
 clearHandoffNotificationConfig();$('handoff-notification-dialog').showModal();return loadHandoffNotifications();
}
async function saveHandoffNotifications(){
 if(!handoffNotifyConfig||handoffNotifyRequest||handoffNotifyConflict||!supportsHandoffNotifications()||!serviceAvailable)return;
 const config=handoffNotifyConfig,targetId=$('handoff-notify-target').value,enabled=$('handoff-notify-enabled').checked;
 if(enabled&&(!config.owner||!handoffNotifyRecipients.some(target=>target.id===targetId))){$('handoff-notify-message').textContent='启用前请配置群负责人，并明确选择当前已读取的接收私聊。';return;}
 const request={kind:'write',scope:handoffScopeKey()};handoffNotifyRequest=request;handoffNotificationControls();$('handoff-notify-message').textContent='正在保存通知设置…';
 try{
  const result=await api('/api/handoffs/notifications',{account:state.account,groupId:config.groupId,version:config.version,routeVersion:config.routeVersion,targetId,enabled});if(!handoffNotifyRequestCurrent(request))return;
  handoffNotifyConfigs=handoffNotifyConfigs.map(item=>item.groupId===result.groupId?result:item);selectHandoffNotificationConfig(result.groupId);
  $('handoff-notify-message').textContent=result.enabled?'已开启：仅后续新待办进入通知队列，不补发已有待办。':'已关闭：取消尚未尝试的通知，已开始处理的一条仍可能提交。';
  await loadHandoffs(true);
 }catch(error){if(handoffNotifyRequestCurrent(request)){handoffNotifyConflict=error.status===409;$('handoff-notify-message').textContent=handoffNotifyConflict?'配置或群负责人已变化（409），草稿已保留。请先记下当前选择，再点击“重新加载”，核对标签与私聊后重新启用。':error.message;}}
 finally{if(handoffNotifyRequest===request){handoffNotifyRequest=null;handoffNotificationControls();}}
}
$('handoff-notification-open').onclick=openHandoffNotifications;
$('handoff-notify-group').onchange=()=>selectHandoffNotificationConfig($('handoff-notify-group').value);
$('handoff-notify-target').onchange=()=>{$('handoff-notify-enabled').checked=false;renderHandoffNotificationExample();handoffNotificationControls();};
$('handoff-notify-enabled').onchange=handoffNotificationControls;
$('handoff-notify-save').onclick=saveHandoffNotifications;$('handoff-notify-reload').onclick=loadHandoffNotifications;
$('handoff-notification-dialog').addEventListener('close',clearHandoffNotificationConfig);
const handoffNotificationLabels={unassigned:'未分派，未创建通知',not_configured:'未入通知队列',queued:'等待提交通知',cancelled:'通知已取消，未提交',expired:'通知已过期，不补发',blocked:'通知被阻止，未提交',unknown:'结果未知，不自动重试',submitted_unconfirmed:'已提交，收件端未确认',server_accepted:'服务器已接受，收件端未确认',local_record_observed:'观察到本机记录，收件端未确认',local_record_confirmed:'服务器回执匹配本机记录，收件端未确认'};
function handoffNotificationSummary(notification){return '负责人通知：'+handoffNotificationLabels[notification.status];}
function renderHandoffNotificationDetail(record){
 const panel=$('handoff-notification-detail');panel.replaceChildren();panel.hidden=!supportsHandoffNotifications();if(panel.hidden)return;
 const notification=record.notification;panel.append(el('strong','',handoffNotificationSummary(notification)));
 if(notification.targetId)panel.append(el('p','',notification.targetName+' · '+notification.targetId));
 if(notification.issue)panel.append(el('p','',notification.issue));
 if(notification.createdAt!==null)panel.append(el('p','subtle','通知创建于 '+stamp(notification.createdAt,{month:'2-digit',day:'2-digit',hour:'2-digit',minute:'2-digit',second:'2-digit'})));
 if(notification.expiresAt!==null)panel.append(el('p','subtle','提交截止 '+stamp(notification.expiresAt,{month:'2-digit',day:'2-digit',hour:'2-digit',minute:'2-digit',second:'2-digit'})));
 if(notification.draftId)panel.append(el('p','subtle','本机发送记录编号：'+notification.draftId));
 panel.append(el('p','subtle','提交、服务器回执和本机记录均不能证明负责人已收到。结果未知时请自行核对，不会自动重试。'));
}
