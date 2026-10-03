'use strict';
let handoffRouteScope='',handoffRoutes=[],handoffRoute=null,handoffRouteRequest=null,handoffRouteConflict=false;
function supportsHandoffRouting(){return isDatabase()&&state.runtime?.capabilities?.handoffRouting===true;}
function handoffOwnerQuery(){
 if(!supportsHandoffRouting())return {};
 const value=$('handoff-owner-filter').value;
 return value==='all'||value==='unassigned'?{ownerFilter:value}:{ownerFilter:'owner',owner:value.slice(6)};
}
function renderHandoffOwners(owners){
 const select=$('handoff-owner-filter'),chosen=select.value;select.replaceChildren();
 for(const [value,label] of [['all','全部负责人'],['unassigned','未分派']]){const option=el('option','',label);option.value=value;select.append(option);}
 const labels=owners.slice();if(chosen.startsWith('owner:')&&!labels.includes(chosen.slice(6)))labels.push(chosen.slice(6));
 for(const owner of labels){const option=el('option','',owner);option.value='owner:'+owner;select.append(option);}
 select.value=chosen||'all';
}
function clearHandoffRouting(){
 handoffRouteRequest=null;handoffRoutes=[];handoffRoute=null;handoffRouteConflict=false;
 $('handoff-route-owner').value='';$('handoff-route-current').textContent='';$('handoff-route-message').textContent='';$('handoff-route-group').replaceChildren();handoffRoutingControls();
}
function updateHandoffRoutingScope(){
 const scope=handoffScopeKey();
 if(scope!==handoffRouteScope){handoffRouteScope=scope;clearHandoffRouting();$('handoff-routing-dialog').close();$('handoff-owner-filter').value='all';renderHandoffOwners([]);}
 const visible=supportsHandoffRouting();$('handoff-routing-open').hidden=!visible;$('handoff-owner-filter-field').hidden=!visible;
 $('handoff-routing-open').disabled=!state.account||!serviceAvailable;
 handoffRoutingControls();
}
function handoffRoutingControls(){
 const busy=!!handoffRouteRequest;
 $('handoff-route-owner').disabled=!handoffRoute||busy;
 $('handoff-route-clear').disabled=!handoffRoute||busy||handoffRouteConflict;
 $('handoff-route-save').disabled=!handoffRoute||busy||handoffRouteConflict||!serviceAvailable;
 $('handoff-route-reload').disabled=busy||!serviceAvailable;
 $('handoff-route-group').disabled=!handoffRoutes.length||handoffRouteRequest?.kind==='write';
}
function selectHandoffRoute(groupId){
 handoffRouteRequest=null;handoffRoute=handoffRoutes.find(route=>route.groupId===groupId)||null;handoffRouteConflict=false;
 $('handoff-route-group').value=groupId;$('handoff-route-owner').value=handoffRoute?handoffRoute.owner:'';$('handoff-route-message').textContent='';
 $('handoff-route-current').textContent=handoffRoute?(handoffRoute.owner?'当前默认标签：'+handoffRoute.owner:'当前未配置负责人，新待办进入未分派队列')+' · 版本 '+handoffRoute.version+(handoffRoute.updatedAt!==null?' · 更新于 '+stamp(handoffRoute.updatedAt,{month:'2-digit',day:'2-digit',hour:'2-digit',minute:'2-digit'}):''):'';
 handoffRoutingControls();
}
function handoffRouteRequestCurrent(request){return handoffRouteRequest===request&&request.scope===handoffScopeKey()&&$('handoff-routing-dialog').open;}
async function loadHandoffRouting(){
 if(!supportsHandoffRouting()||!state.account||!serviceAvailable||handoffRouteRequest?.kind==='write')return;
 const groupId=$('handoff-route-group').value,request={kind:'read',scope:handoffScopeKey()};handoffRouteRequest=request;handoffRoutingControls();$('handoff-route-message').textContent='正在读取群负责人…';
 try{
  const data=await api('/api/handoffs/routing?'+new URLSearchParams({account:state.account}));if(!handoffRouteRequestCurrent(request))return;
  handoffRoutes=data.routes;const select=$('handoff-route-group');select.replaceChildren();
  for(const route of data.routes){const option=el('option','',route.groupName+' · '+route.groupId);option.value=route.groupId;select.append(option);}
  selectHandoffRoute(data.routes.some(route=>route.groupId===groupId)?groupId:data.routes.length?data.routes[0].groupId:'');
  if(!data.routes.length)$('handoff-route-message').textContent='当前没有已勾选读取的群，请先选择读取范围。';
 }catch(error){if(handoffRouteRequestCurrent(request))$('handoff-route-message').textContent='读取失败：'+error.message;}
 finally{if(handoffRouteRequest===request){handoffRouteRequest=null;handoffRoutingControls();}}
}
async function openHandoffRouting(){
 updateHandoffRoutingScope();if(!supportsHandoffRouting()||!state.account||!serviceAvailable)return;
 clearHandoffRouting();$('handoff-routing-dialog').showModal();return loadHandoffRouting();
}
async function saveHandoffRouting(){
 if(!handoffRoute||handoffRouteRequest||handoffRouteConflict||!supportsHandoffRouting()||!serviceAvailable)return;
 const owner=$('handoff-route-owner').value.trim();
 if(owner.length>80||/[\r\n\0]/.test(owner)){$('handoff-route-message').textContent='负责人标签请输入不超过 80 字符的单行文本。';return;}
 const route=handoffRoute,request={kind:'write',scope:handoffScopeKey()};handoffRouteRequest=request;handoffRoutingControls();$('handoff-route-message').textContent='正在保存本机负责人标签…';
 try{
  const result=await api('/api/handoffs/routing',{account:state.account,groupId:route.groupId,version:route.version,owner});if(!handoffRouteRequestCurrent(request))return;
  handoffRoutes=handoffRoutes.map(item=>item.groupId===result.groupId?result:item);selectHandoffRoute(result.groupId);
  $('handoff-route-message').textContent=result.owner?'默认负责人已保存，只分派后续新待办，仍需点击领取。未通知负责人。':'默认负责人已清除，后续新待办进入未分派队列。已有任务保持原样。';
  await loadHandoffs(true);
 }catch(error){if(handoffRouteRequestCurrent(request)){handoffRouteConflict=error.status===409;$('handoff-route-message').textContent=handoffRouteConflict?'配置已变化（409），草稿已保留。请先复制需要保留的内容，再点击“重新加载”读取最新配置。':error.message;}}
 finally{if(handoffRouteRequest===request){handoffRouteRequest=null;handoffRoutingControls();}}
}
$('handoff-routing-open').onclick=openHandoffRouting;
$('handoff-route-group').onchange=()=>selectHandoffRoute($('handoff-route-group').value);
$('handoff-route-save').onclick=saveHandoffRouting;$('handoff-route-reload').onclick=loadHandoffRouting;
$('handoff-route-clear').onclick=()=>{$('handoff-route-owner').value='';$('handoff-route-message').textContent='标签已清空，点击“保存默认负责人”后生效。';};
$('handoff-routing-dialog').addEventListener('close',clearHandoffRouting);
$('handoff-owner-filter').addEventListener('change',()=>{resetHandoffPage();loadHandoffs(true);});
