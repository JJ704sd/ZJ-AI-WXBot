'use strict';
const $=id=>document.getElementById(id);
const paths={chat:'M21 11.5a8.3 8.3 0 0 1-.9 3.8 8.4 8.4 0 0 1-7.6 4.7 8.3 8.3 0 0 1-3.8-.9L3 21l1.9-5.7a8.3 8.3 0 0 1-.9-3.8 8.4 8.4 0 0 1 4.7-7.6 8.3 8.3 0 0 1 3.8-.9h.5a8.4 8.4 0 0 1 8 8v.5Z',clock:'M12 8v4l3 2 M22 12a10 10 0 1 1-20 0 10 10 0 0 1 20 0',send:'m22 2-7 20-4-9-9-4 20-7ZM22 2 11 13',reply:'m9 10-5-5 5-5 M4 5h10a6 6 0 0 1 6 6v7',refresh:'M20 7v5h-5 M4 17v-5h5 M6 7a7 7 0 0 1 12-2l2 3 M4 16l2 3a7 7 0 0 0 12-2',chevron:'m9 5 7 7-7 7',search:'m21 21-5-5 M18 10a8 8 0 1 1-16 0 8 8 0 0 1 16 0',at:'M16 8v5a3 3 0 1 0 6 0v-1a10 10 0 1 0-4 8 M16 12a4 4 0 1 1-8 0 4 4 0 0 1 8 0',shield:'m12 3 8 3v6c0 5-8 9-8 9s-8-4-8-9V6l8-3Z m-4 9 3 3 5-6',info:'M12 11v6 M12 7h.01 M22 12a10 10 0 1 1-20 0 10 10 0 0 1 20 0',plus:'M12 5v14 M5 12h14',settings:'M4 7h16 M4 17h16 M8 4v6 M16 14v6',copy:'M8 8h12v13H8z M4 16V3h12'};
function icon(name){const svg=document.createElementNS('http://www.w3.org/2000/svg','svg');svg.setAttribute('viewBox','0 0 24 24');svg.classList.add('icon');svg.setAttribute('aria-hidden','true');const path=document.createElementNS(svg.namespaceURI,'path');path.setAttribute('d',paths[name]||paths.chat);svg.append(path);return svg;}
document.querySelectorAll('[data-icon]').forEach(el=>el.append(icon(el.dataset.icon)));
function el(tag,className,text){const node=document.createElement(tag);if(className)node.className=className;if(text!==undefined)node.textContent=text;return node;}
let state={},csrf='',selected=null,people=[],messageData=[],outboxData=[],mentionIds=new Set(),filter='all',online=false,groupVersion=0,toastTimer,renderKey='',pollBusy=false;
const memberCache=new Map();
let groupRenderKey='',scheduleRenderKey='',groupLoadState='idle';
let serviceAvailable=false,serviceError='',groupFilter='all',currentView='workspace',sendBusy=false,replyBusy=false,scheduleBusy=false;
let environmentData=null,environmentBusy=false,environmentError='',environmentTime=null;
const draftMemory=new Map();
let databaseData=null,databaseBusy=false,databaseLoading=false,databaseOperation=false,databaseDirty=false,databaseFormLoaded=false,databaseFetchVersion=0,databaseTimer=null,initialModeSeen=false;
function isDatabase(){return state.runtime?.mode==='database';}
function databaseAuto(){return state.runtime?.source?.updatePolicy==='on_change'||(!state.runtime?.source?.id&&databaseData?.config?.autoRefresh===true);}
function databasePolicy(){return databaseAuto()?'自动检查源文件变化，完成副本复制与校验后更新消息。':'查看新增消息需手动更新副本。';}
function supportsComposer(){return !isDatabase()||state.runtime?.capabilities?.hookSendInterface===true||state.runtime?.capabilities?.groupSend===true;}
function supportsSchedules(){return !isDatabase()||state.runtime?.capabilities?.scheduledSend===true;}
function supportsReplies(){return !isDatabase()||state.runtime?.capabilities?.automaticReplies===true;}
function sourceSignature(value){return JSON.stringify([value.runtime?.mode,value.runtime?.source?.id]);}
function sourceTime(value){const date=typeof value==='number'?value*1000:Date.parse(value||'');return Number.isFinite(date)?stamp(date/1000,{month:'2-digit',day:'2-digit',hour:'2-digit',minute:'2-digit',second:'2-digit'}):'尚无记录';}

function isDemo(){return state.runtime?.mode==='demo';}
function draftKey(account=state.account,group=selected){return 'webridge:draft:'+account+'|'+group;}
function saveDraft(account=state.account,group=selected){
 if(!account||!group)return;
 const data={text:$('message-text').value,mentions:[...mentionIds]},key=draftKey(account,group);
 draftMemory.set(key,data);try{if(data.text||data.mentions.length)sessionStorage.setItem(key,JSON.stringify(data));else sessionStorage.removeItem(key);}catch{}
 $('draft-status').textContent=data.text?'草稿已保留 · 仅本次浏览器会话':'';
}
function restoreDraft(){
 const key=draftKey();let data=draftMemory.get(key);
 if(!data){try{data=JSON.parse(sessionStorage.getItem(key)||'null');}catch{}}
 $('message-text').value=data?.text||'';mentionIds=new Set(data?.mentions||[]);
 $('text-count').textContent=$('message-text').value.length+' / 2000';
 $('draft-status').textContent=data?.text?'已恢复当前会话草稿':'';
}
function emptyCard(title,detail,iconName='chat'){
 const empty=el('div','empty'),art=el('span');art.append(icon(iconName));empty.append(art,el('h3','',title),el('p','',detail));return empty;
}

const labels={queued:'等待发送',sending:'发送中…',sent:'已送达微信服务器',failed:'发送失败',unknown:'结果未知，请查看会话',cancelled:'已取消'};
const originLabels={manual:'手动',reply:'自动回复',schedule:'定时任务'};
function toast(text,error=false){$('toast').textContent=text;$('toast').classList.toggle('error',error);$('toast').hidden=false;clearTimeout(toastTimer);toastTimer=setTimeout(()=>$('toast').hidden=true,error?6500:3500);}
async function api(path,body){
 const controller=new AbortController(),timeout=setTimeout(()=>controller.abort(),path==='/api/media'?90000:path==='/api/windows/ocr-preview'||path.startsWith('/api/windows/send/')||path==='/api/windows/hook/start'?60000:20000);
 const options={signal:controller.signal,cache:'no-store',...(body===undefined?{}:{method:'POST',headers:{'Content-Type':'application/json','X-CSRF-Token':csrf},body:JSON.stringify(body)})};
 try{
  const response=await fetch(path,options);let result;
  try{result=await response.json();}catch{throw Error('服务返回了无法识别的响应，请在环境诊断中检查服务。');}
  if(!response.ok)throw Error(result.error||'操作失败（HTTP '+response.status+'），请重试。');return result;
 }catch(error){
  if(error.name==='AbortError'&&path.startsWith('/api/windows/hook/'))throw Error('发送连接请求超时，请先查询发送状态。');
  if(error.name==='AbortError'&&path.startsWith('/api/windows/send/'))throw Error('本机操作请求超时，请核对微信中的当前状态。');
  if(error.name==='AbortError'&&path.startsWith('/api/windows/'))throw Error('本机窗口检测或读取超时，请调整微信窗口后重新检测。');
  if(error.name==='AbortError')throw Error(body===undefined?'读取超时，请检查服务连接。':'请求超时，操作结果尚不确定，请先刷新核对结果，避免重复操作。');
  if(error instanceof TypeError)throw Error('无法连接本机服务，请确认启动窗口仍在运行。');throw error;
 }finally{clearTimeout(timeout);}
}
function groupQuery(path,group=selected){return path+'?'+new URLSearchParams({account:state.account||'',groupId:group||''});}
function groupName(id){return (state.groups||[]).find(x=>x.id===id)?.name||'未知会话';}
function nameFor(id,list=people){return list.find(x=>x.id===id)?.name||id;}
function stamp(seconds,options={hour:'2-digit',minute:'2-digit'}){return new Intl.DateTimeFormat('zh-CN',{timeZone:'Asia/Shanghai',...options}).format(new Date(seconds*1000));}
function dateKey(seconds){return stamp(seconds,{year:'numeric',month:'2-digit',day:'2-digit'});}
function controls(){
 const database=isDatabase();
 $('composer-controls').hidden=!supportsComposer();$('mention-picker-label').hidden=database;$('mention-picker').hidden=database;$('mention-chips').hidden=database;$('hook-composer-feedback').hidden=!database;$('hook-composer-connection').hidden=!database;$('database-source-controls').hidden=!database||supportsComposer();$('database-panel').hidden=!database;document.querySelector('[data-view="schedules"]').hidden=!supportsSchedules();$('reply-tab').hidden=!supportsReplies();$('schedule-from-message').hidden=!supportsSchedules();
 $('hook-sender-panel').hidden=!database;
 if(!supportsReplies()&&!$('reply-form').hidden){$('reply-form').hidden=true;$('send-form').hidden=false;$('send-tab').classList.add('active');$('reply-tab').classList.remove('active');}
 $('connection-guide').hidden=database;
 if(database&&$('login-dialog').open)$('login-dialog').close();
 $('windows-section-label').textContent=database?'可选辅助工具 · Windows 窗口':'WINDOWS · 本机微信';
 $('reading-description').textContent=database?'选择要在工作台查看的会话。这里只读取校验后的副本；'+databasePolicy():'勾选的群会持续同步消息。取消读取会关闭该群自动回复；手动发送与定时任务独立配置。';
 document.querySelector('.groups-panel .panel-foot').lastChild.textContent=database?(databaseAuto()?' 源文件变化后自动更新副本':' 固定副本 · 新消息需手动更新'):' 仅持续读取已勾选的群';
 const mentionsAvailable=!database||state.runtime?.capabilities?.mentions===true;
 $('filter-mentions').disabled=!mentionsAvailable;$('filter-mentions').title=mentionsAvailable?'只显示直接 @ 当前账号的消息':'未绑定本人账号 ID，暂不能识别 @ 我的消息';
 $('mention-availability').hidden=mentionsAvailable;$('mention-availability').textContent='尚未绑定本人账号 ID；可在数据源设置中填写后启用“@ 我的”。';
 if(!mentionsAvailable&&filter==='mentions'){filter='all';$('filter-all').classList.add('active');$('filter-mentions').classList.remove('active');renderMessages(true);}
 const available=serviceAvailable&&online&&!state.loggingOut,canSend=state.runtime?.capabilities?.canSend!==false;
 const usable=available&&!!selected&&canSend&&groupLoadState==='ready';
 const reason=!serviceAvailable?'本机服务未连接，请检查服务。':database&&!supportsComposer()?'数据库访问只读，当前尚未接入独立发送能力。':!online?(database?'请先创建可读的数据库副本。':'请先在“账号 / 登录”中连接微信。'):!selected?'请先选择左侧会话。':state.loggingOut?'正在退出账号，请稍候。':groupLoadState==='loading'?'正在读取当前会话资料，请稍候。':groupLoadState!=='ready'?'当前会话资料读取失败，请点击刷新重试。':!canSend?'当前连接不具备发送能力，请查看环境诊断。':'';
 $('send-button').disabled=!usable||sendBusy||!$('message-text').value.trim();
 $('send-label').textContent=sendBusy?'正在提交…':isDemo()?'模拟发送':'立即发送';
 $('send-reason').textContent=reason||(!$('message-text').value.trim()?'输入消息后即可'+(isDemo()?'模拟发送。':'发送。'):'');
 $('send-button').title=reason||'Ctrl + Enter 发送';
 $('message-text').disabled=!selected;
 $('schedule-from-message').disabled=!usable||scheduleBusy||!$('message-text').value.trim();
 $('save-reply').disabled=!supportsReplies()||!usable||replyBusy||!(state.watchedGroups||[]).includes(selected);
 $('reply-reason').textContent=reason||(!(state.watchedGroups||[]).includes(selected)?'先在“选择读取会话”中启用当前群，再保存规则。':'');
 $('reply-enabled').disabled=!usable; $('reply-text').disabled=!selected;
 $('new-schedule').disabled=!available||!canSend||!(state.groups||[]).length;
 $('group-info-button').disabled=!available||!selected;
 $('reading-button').disabled=!serviceAvailable||!online;
 $('send-target').textContent=selected?'发送到：'+groupName(selected):'选择会话后编辑消息；草稿在本次浏览器会话中保留。';
 $('send-mode-badge').textContent=database?'Windows 微信':isDemo()?'本机模拟':'手动发送';
 $('send-shortcut').textContent=database?'Ctrl + Enter 核对消息':'Ctrl + Enter 发送';
 $('composer-note-title').textContent=database?'收发进度可见':'范围由你决定';$('composer-note').textContent=database?'接收读取本地数据库副本；发送后自动核对新增的本人消息记录。':'会话、提及成员与回复规则都独立配置。发送结果可在消息流中查看。';
 $('reply-description').textContent=isDemo()?'演示规则仅在本机运行，用于体验配置流程，不会回复真实微信。':'收到直接 @ 你的新消息时，@ 发送者并回复固定话术。';
 $('schedule-mode-note').textContent=isDemo()?'仅本机模拟执行':'每天按时执行';
 $('schedule-sent-label').textContent=isDemo()?'最近记录中的今日模拟成功':'最近记录中的今日成功';
 $('footer-mode').textContent=database?'真实微信 · 数据库副本接收 / Windows Hook 发送 · '+(databaseAuto()?'自动检查变化':'手动更新'):isDemo()?'演示数据 · 所有操作仅在本机模拟':'上海时间 UTC+8 · 服务和桥接需保持在线';
 if(database){renderDatabaseSource();updateDatabaseControls();}else{$('refresh-button').title='刷新账号与当前群消息';$('refresh-button').querySelector('span:last-child').textContent='刷新';}
 updateViewTitle();
 updateDesktopSender();
 updateHookSender();
}
function setConnection(){
 const database=isDatabase(),source=state.runtime?.source||{};
 online=serviceAvailable&&(database?state.runtime?.connected===true&&state.runtime?.capabilities?.read===true:state.connection?.status==='logged_in');
 const connectionLabel=!serviceAvailable?'本机服务未连接':database?(online?'数据库副本可读':databaseBusy?'正在创建副本':source.sourceRoot?'数据库副本不可读':'等待配置数据库'):isDemo()?'演示会话':online?'微信已连接':state.connection?.status==='loading'?'正在连接微信':'微信未连接';
 $('connection-pill').classList.toggle('online',online&&!isDemo()&&!database);$('connection-pill').classList.toggle('demo',serviceAvailable&&isDemo());$('connection-pill').classList.toggle('database',serviceAvailable&&database);
 $('connection-pill').querySelector('span').textContent=connectionLabel;
 $('account-name').textContent=database?(state.name||'当前微信账号'):online?(state.name||'当前账号'):!serviceAvailable?'服务未连接':'未登录';
 $('account-avatar').textContent=database?(state.name||'微').slice(0,1):online?(state.name||'微').slice(0,1):'微';
 $('account-status').textContent=database?(online?'当前账号 · 消息已接入':'点击设置数据源'):isDemo()?'本机演示 · 无真实发送':online?'个人微信 · 已连接':!serviceAvailable?'请检查启动窗口':'点击连接个人微信';
 $('account-entry').textContent=database?'数据源设置':isDemo()?'演示账号':'账号 / 登录';
 const error=serviceError||(database?(state.runtime?.databaseState?.error||databaseData?.error):'')||state.syncError||state.connection?.error||'';
 $('global-error').hidden=!error;$('global-error').textContent=error;
 $('runtime-banner').hidden=!state.runtime;$('runtime-banner').classList.toggle('live',!isDemo()&&!database);$('runtime-banner').classList.toggle('database',database);
 $('runtime-title').textContent=database?'真实微信 · 数据库副本接收 / Windows Hook 发送':isDemo()?'演示模式 · 可放心体验本机操作':'真实接入模式';
 $('runtime-detail').textContent=database?(databaseBusy?'正在创建或更新只读副本；已有成功副本仍可查看。':databaseData?.error&&online?'更新未成功，当前显示上次成功副本。请到数据源设置查看原因。':online?'接收：'+databasePolicy()+'发送：在右侧连接 Windows 微信，向已选择读取的会话发送文本。':'配置源数据库目录后创建只读副本，开始查看会话和消息。'):isDemo()?'当前会话和消息均为演示数据；发送、定时与自动回复只在本机模拟，不连接真实微信。':online?'当前操作将发送到真实微信，请确认目标会话与内容。':'请先完成环境配置并连接微信，再读取会话与发送消息。';
 $('runtime-details').textContent=database?'设置数据源':'查看环境';
 $('platform-label').textContent=(state.runtime?.platform||'本机').toUpperCase()+' · WORKSPACE';
 $('stream-dot').classList.toggle('active',online&&(state.watchedGroups||[]).includes(selected));
 if(database){$('sync-status').textContent=online?(databaseAuto()?'自动检查源变化':'读取固定副本'):'等待副本';$('stream-hint').textContent=online?(databaseAuto()?'变化后更新 · 当前为已校验副本':'读取固定副本 · 手动更新'):'配置数据源并创建只读副本';$('last-sync').textContent=online?'副本创建于 '+sourceTime(source.createdAt):'';}
 else if(!online){$('sync-status').textContent='同步已暂停';$('stream-hint').textContent=serviceAvailable?'连接微信后同步消息':'服务连接中断，自动重试中';}
 controls();
}
function renderGroups(){
 const list=$('group-list');const term=$('group-search').value.trim().toLowerCase(),watched=new Set(state.watchedGroups||[]);
 const groups=(state.groups||[]).filter(x=>x.name.toLowerCase().includes(term)&&(groupFilter==='all'||watched.has(x.id)));
 $('group-count').textContent=(state.groups||[]).length;$('reading-count').textContent=watched.size;
 const key=JSON.stringify([state.account,groups,[...watched],selected,online,term,groupFilter]);if(key===groupRenderKey)return;groupRenderKey=key;list.replaceChildren();
 if(!groups.length){list.append(el('div','empty compact',term?'没有匹配的会话，试试其他关键词。':groupFilter==='watched'?'尚未勾选会话。点击“选择读取会话”开始。':online?(isDatabase()?'当前副本没有可显示的会话。':'暂未读取到会话，请点击刷新。'):(isDatabase()?'先设置数据源并创建只读副本。':'连接微信后，会话会显示在这里。')));return;}
 for(const group of groups){
  const button=el('button','group-item'+(group.id===selected?' active':''));button.append(el('span','avatar',group.name.slice(0,2)));
  const info=el('span','group-info');info.append(el('strong','',group.name),el('small','',watched.has(group.id)?(isDatabase()?'已选入读取范围':online?'已启用读取':'读取暂停')+(group.id===selected?' · 当前查看':''):'未读取 · 可勾选启用'));button.append(info);button.title=group.name;button.setAttribute('aria-pressed',String(group.id===selected));button.onclick=()=>selectGroup(group.id);list.append(button);
 }
}
async function selectGroup(id,{persistSelection=true}={}){
 saveDraft();const version=++groupVersion,account=state.account;selected=id;groupLoadState='loading';people=[];messageData=[];outboxData=[];renderKey='';restoreDraft();
 $('reply-enabled').checked=false;$('reply-text').value='';$('reply-saved-status').textContent='正在读取规则…';
 $('selected-name').textContent=groupName(id);$('selected-avatar').textContent=groupName(id).slice(0,2);$('member-search').value='';$('selected-meta').textContent='正在读取群成员…';$('sync-status').textContent='同步中';
 renderGroups();renderMembers();$('message-list').replaceChildren(emptyCard('正在读取群消息','请稍候…'));controls();
 try{
  if(persistSelection)await api('/api/select',{account,groupId:id});if(version!==groupVersion||account!==state.account)return;
  const data=await api(groupQuery('/api/group',id));if(version!==groupVersion||account!==state.account)return;
  people=data.members||[];memberCache.set(state.account+'|'+id,people);messageData=data.messages||[];outboxData=supportsComposer()?data.outbox||[]:[];
  mentionIds=new Set([...mentionIds].filter(member=>people.some(person=>person.id===member&&member!==state.selfId)));
  groupLoadState='ready';applyRule(data.reply||{});$('selected-meta').textContent=isDatabase()?'数据库副本 · '+(data.watching?'已选入读取范围':'尚未选入读取范围'):people.length+' 位成员 · '+(data.watching?'已启用读取':'尚未启用读取');
  renderMembers();renderMessages(true);setConnection();
 }catch(error){if(version===groupVersion&&account===state.account){groupLoadState='error';$('selected-meta').textContent='读取失败，可点击刷新重试';$('message-list').replaceChildren(emptyCard('暂时无法读取群消息',error.message,'info'));controls();toast(error.message,true);}}
}

function applyRule(rule){$('reply-enabled').checked=!!rule.enabled;$('reply-text').value=rule.text||'';$('reply-cooldown').value=String(rule.cooldown||30);$('reply-saved-status').textContent=rule.enabled?(isDemo()?'本机模拟规则已开启':'当前群自动回复已开启 · 回复时 @ 发送者'):'当前群自动回复已关闭';}
function renderMembers(){const container=$('mention-options');container.replaceChildren();const search=$('member-search').value.trim();for(const member of people.filter(x=>x.id!==state.selfId&&x.name.includes(search))){const label=el('label','member-option');const input=document.createElement('input');input.type='checkbox';input.checked=mentionIds.has(member.id);input.onchange=()=>{input.checked?mentionIds.add(member.id):mentionIds.delete(member.id);renderChips();saveDraft();};label.append(input,el('span','',member.name),el('small','',member.kind));container.append(label);}if(!container.children.length)container.append(el('div','empty compact','暂无可选成员'));renderChips();}
function renderChips(){$('mention-chips').replaceChildren();for(const id of mentionIds){const chip=el('span','chip','@'+nameFor(id));const remove=el('button','','×');remove.type='button';remove.setAttribute('aria-label','移除'+nameFor(id));remove.onclick=()=>{mentionIds.delete(id);renderMembers();saveDraft();};chip.append(remove);$('mention-chips').append(chip);}$('mention-label').textContent=mentionIds.size?'已选择 '+mentionIds.size+' 位成员':'选择要 @ 的成员';}
function emptyMessages(){
 if(isDatabase()&&!online){const empty=emptyCard('从本地数据库副本开始','设置源目录并创建只读副本，即可在这里查看会话消息。');const button=el('button','button primary','设置数据源');button.onclick=openDatabaseSettings;empty.append(button);return empty;}
 const query=$('message-search').value.trim();
 if(query)return emptyCard('没有找到匹配的消息','搜索范围为当前已加载的消息，可更换关键词或清除搜索。','search');
 if(filter==='mentions'&&selected)return emptyCard('暂时没有 @ 我的消息',isDatabase()?'当前副本中没有已识别的 @ 我的消息；'+databasePolicy():'收到直接 @ 当前账号的消息后，会显示在这里。','at');
 const empty=emptyCard(selected?'还没有可显示的消息':'从左侧选择一个会话',selected?((state.watchedGroups||[]).includes(selected)?(isDatabase()?'当前副本没有可显示的消息。'+databasePolicy():'收到群消息后，这里会自动更新。'):'点击“选择读取会话”勾选当前会话。'):(isDatabase()?'选择会话后查看校验后的副本消息。':'查看消息、保留草稿，并为每天的沟通安排计划。'));
 if(!online){const action=el('button','button secondary',isDemo()?'查看环境诊断':'连接微信');action.onclick=()=>{if(isDemo())setView('environment');else $('account-entry').click();};empty.append(action);}return empty;
}

const messageNodes=new Map();
function renderMessages(force=false){
 const list=$('message-list'),nearBottom=list.scrollHeight-list.scrollTop-list.clientHeight<100;
 const all=[...messageData],serverIds=new Set(messageData.map(x=>x.serverId));
 for(const row of outboxData){if(row.result.serverId&&serverIds.has(row.result.serverId))continue;const suffix=(row.mentions||[]).map(id=>'  @'+nameFor(id)).join('');all.push({id:'out:'+row.id,kind:'text',text:row.result.text||row.text+suffix,isSelf:true,senderName:state.name,timestamp:row.created_at,status:row.status,simulated:row.result.simulated,error:row.result.error,origin:row.origin,mentionSelf:false});}
 all.sort((a,b)=>a.timestamp-b.timestamp);
 const mentions=all.filter(x=>x.mentionSelf&&!x.isSelf&&x.kind!=='revoke');$('mention-count').textContent=mentions.length;$('message-count').textContent=all.length+' 条';
 const term=$('message-search').value.trim().toLocaleLowerCase(),subset=filter==='mentions'?mentions:all,visible=subset.filter(x=>!term||[x.text,x.senderName,x.media?.filename].some(value=>String(value||'').toLocaleLowerCase().includes(term))),key=JSON.stringify([selected,filter,term,visible]);$('message-count').textContent=(term?visible.length+' / '+all.length:all.length)+' 条';if(!force&&key===renderKey)return;renderKey=key;
 if(!visible.length){list.replaceChildren(emptyMessages());$('jump-latest').hidden=true;return;}
 const nodes=[];let day='';
 for(const message of visible){
  const date=dateKey(message.timestamp);if(date!==day){day=date;const cacheKey='day:'+selected+date;let dateNode=messageNodes.get(cacheKey);if(!dateNode){dateNode={node:el('div','date-separator',date)};messageNodes.set(cacheKey,dateNode);}nodes.push(dateNode.node);}
  const cacheKey=state.account+'|'+selected+'|'+message.id,signature=JSON.stringify(message);let saved=messageNodes.get(cacheKey);
  if(!saved||saved.signature!==signature){
   let row;
   if(['system','revoke'].includes(message.kind)){row=el('div','system-message '+message.kind);row.append(el('span','',message.kind==='revoke'?'↶ ':''),el('span','',message.text));}
   else{
    row=el('div','message-item'+(message.isSelf?' self':'')+(message.mentionSelf?' mentioned':''));row.append(el('span','avatar',(message.senderName||'群').slice(0,1)));
    const body=el('div','message-main'),meta=el('div','message-meta');meta.append(el('strong','',message.isSelf?'我':message.senderName),el('time','',stamp(message.timestamp)));
    if(message.mentionSelf)meta.append(el('span','mention-tag','@ 我'));if(message.origin&&message.origin!=='manual')meta.append(el('span','mention-tag',originLabels[message.origin]));
    body.append(meta,messageContent(message,selected,state.account));
    if(message.status){const status=el('div','send-state '+message.status,message.simulated&&message.status==='sent'?'模拟完成 · 未发送至微信':labels[message.status]||message.status);if(message.error)status.title=message.error;body.append(status);}row.append(body);
   }
   saved={signature,node:row};messageNodes.set(cacheKey,saved);
  }
  nodes.push(saved.node);
 }
 // Keep existing media nodes attached, so incoming messages do not restart video playback.
 const keep=new Set(nodes);for(const child of [...list.children])if(!keep.has(child))child.remove();
 nodes.forEach((node,index)=>{if(list.children[index]!==node)list.insertBefore(node,list.children[index]||null);});
 if(force||nearBottom)list.scrollTop=list.scrollHeight;updateJump();
}
function setView(view){
 if(!supportsSchedules()&&view==='schedules')view='workspace';
 if(currentView==='environment'&&view!=='environment'){resetWindowsPanel();resetDesktopSender();discardHookDraft();}
 currentView=view;document.querySelectorAll('[data-view]').forEach(button=>{button.classList.toggle('active',button.dataset.view===view);button.setAttribute('aria-current',button.dataset.view===view?'page':'false');});
 for(const name of ['workspace','schedules','environment'])$(name+'-view').hidden=view!==name;
 updateViewTitle();
 if(view==='schedules')renderSchedules();if(view==='environment'){loadEnvironment();if(isDatabase())loadDatabase();}
}
function updateViewTitle(){
 const titles={workspace:['会话工作台',isDatabase()?'查看本机微信消息，向已选择读取的会话发送文本。'+databasePolicy():'查看群消息，管理发送计划与自动回复。'],schedules:['定时任务','管理每天的发送计划，查看每次执行结果。'],environment:[isDatabase()?'数据源与环境':'环境诊断',isDatabase()?'创建本地只读副本，检查来源与更新结果。':'从运行环境到桥接连接，逐项了解当前状态。']};
 $('page-title').textContent=titles[currentView][0];$('page-subtitle').textContent=titles[currentView][1];
}

function renderSchedules(){const jobs=state.jobs||[],out=state.outbox||[];const active=jobs.filter(x=>x.enabled).length;$('job-count').textContent=active;$('active-jobs').textContent=active;$('today-sent').textContent=out.filter(x=>x.origin==='schedule'&&x.status==='sent'&&dateKey(x.created_at)===dateKey(Date.now()/1000)).length;$('unknown-count').textContent=out.filter(x=>x.origin==='schedule'&&x.status==='unknown').length;const key=JSON.stringify([state.account,isDemo(),online,serviceAvailable,!!state.loggingOut,state.runtime?.capabilities,state.groups,jobs,jobs.map(job=>memberCache.get(state.account+'|'+job.group_id)||[])]);if(key===scheduleRenderKey)return;scheduleRenderKey=key;const list=$('schedule-list');list.replaceChildren();if(!jobs.length){const empty=el('div','empty');const art=el('span');art.append(icon('clock'));empty.append(art,el('h3','','给每天的消息安排一个时间'),el('p','','创建任务，选择会话、成员与每日发送内容。'));list.append(empty);return;}
 for(const job of jobs){const row=el('article','schedule-row');const clock=el('div','schedule-time',job.clock);clock.append(el('small','','每天 · 上海时间'));const content=el('div','schedule-content');content.append(el('strong','',groupName(job.group_id)),el('p','',job.text));if(job.mentions.length){const members=memberCache.get(state.account+'|'+job.group_id)||[];content.append(el('p','',job.mentions.map(id=>'@'+nameFor(id,members)).join(' ')));}const info=el('div','schedule-info');info.append(el('span','status-chip'+(job.enabled?'':' off'),job.enabled?(isDemo()?'模拟已启用':'已启用'):'已停用'));if(job.enabled&&job.nextRun)info.append(el('div','','下次 '+stamp(job.nextRun,{month:'2-digit',day:'2-digit',hour:'2-digit',minute:'2-digit'})));if(job.last_result)info.append(el('div','',job.last_result));row.append(clock,content,info);if(job.enabled){const cancel=el('button','schedule-stop','停用');cancel.disabled=!serviceAvailable||!!state.loggingOut;cancel.title=!serviceAvailable?'本机服务未连接':state.loggingOut?'正在退出账号':'停用此每日任务';cancel.onclick=async()=>{try{await api('/api/jobs/cancel',{account:state.account,id:job.id});toast('任务已停用');await poll();}catch(error){toast(error.message,true);}};row.append(cancel);}list.append(row);}}
function renderLogin(){
 if(isDatabase()){openDatabaseSettings();return;}
 $('login-title').textContent=isDemo()?'本机演示账号':'连接你的微信';
 $('login-footnote').textContent=isDemo()?'演示会话与真实微信隔离。连接本机微信请查看环境诊断中的 Windows 微信检查。':'扫码后在手机授权。退出会关闭自动回复并取消等待发送的消息，保留本机配置。';
 const content=$('login-content');content.replaceChildren();const login=state.login||{};$('logout-button').hidden=true;if(isDemo()){content.append(el('div','login-symbol','演'),el('h3','','当前为本机演示会话'),el('p','','可体验消息、定时任务与回复规则，所有发送都只在本机模拟。真实 Windows 微信检测在环境诊断中进行。'));$('login-action').textContent='查看环境诊断';$('login-action').disabled=false;return;}if(!serviceAvailable){content.append(emptyCard('本机服务未连接','请检查启动窗口，恢复服务后自动重连。','info'));$('login-action').disabled=true;return;}if(online){content.append(el('div','login-symbol',state.name.slice(0,1)),el('h3','',state.name+' 已连接'),el('p','','可以选择会话，发送消息或配置自动回复。'));$('login-action').textContent='选择读取会话';$('login-action').disabled=!!state.loggingOut;$('logout-button').hidden=false;$('logout-button').disabled=!!state.loggingOut;return;}if(login.type==='qr'&&login.qrDataUrl?.startsWith('data:image/')){const image=el('img');image.src=login.qrDataUrl;image.alt='个人微信登录二维码';content.append(image,el('p','','请使用手机微信扫一扫，并确认登录。'));}else{content.append(el('div','login-symbol',login.type==='phone_confirm'?'↗':'微'),el('h3','',login.type==='phone_confirm'?'等待手机确认':'连接个人微信'),el('p','',login.type==='error'?login.message:login.type==='login_timeout'?'二维码已超时，请重新获取。':login.message||'在这里完成扫码，连接后即可管理你的会话。'));}$('login-action').textContent=login.running?'正在连接…':'扫码登录 / 刷新二维码';$('login-action').disabled=!!login.running;}
async function poll(){
 if(pollBusy)return;pollBusy=true;
 try{
  const previous=state.account,previousSelected=selected,previousMode=state.runtime?.mode,previousSource=sourceSignature(state),previousRevision=state.runtime?.source?.revision,next=await api('/api/state');
  const sourceChanged=next.runtime?.mode==='database'&&(previousMode!=='database'||previousSource!==sourceSignature(next));
  const snapshotChanged=next.runtime?.mode==='database'&&!sourceChanged&&previous===next.account&&previousRevision!==next.runtime?.source?.revision;
  const senderSourceChanged=previousMode!==next.runtime?.mode||previous!==next.account||state.runtime?.source?.id!==next.runtime?.source?.id;
  if(previous&&previous!==next.account)saveDraft(previous,selected);
  state=next;csrf=state.csrfToken;serviceAvailable=true;serviceError='';if(senderSourceChanged){resetDesktopSender(true);resetHookSender();}
  if((previous&&previous!==state.account)||sourceChanged){
   resetWindowsPanel();
   ++groupVersion;selected=null;groupLoadState='idle';people=[];messageData=[];outboxData=[];mentionIds.clear();memberCache.clear();messageNodes.clear();mediaStates.clear();
   for(const id of ['media-dialog','record-dialog','group-info-dialog','reading-dialog','schedule-dialog'])$(id).close();
   $('record-content').replaceChildren();$('group-info-content').replaceChildren();$('message-text').value='';$('reply-text').value='';$('reply-enabled').checked=false;$('draft-status').textContent='';$('text-count').textContent='0 / 2000';$('selected-name').textContent='选择一个会话';$('selected-meta').textContent='登录后选择读取范围';renderMessages(true);
  }
  if(snapshotChanged){memberCache.clear();messageNodes.clear();mediaStates.clear();renderKey='';}
  syncDatabaseRuntime();setConnection();renderGroups();renderSchedules();
  if(isDatabase()&&!databaseData&&!databaseLoading)loadDatabase();
  if(!initialModeSeen){initialModeSeen=true;if(isDatabase()&&!online)setView('environment');}
  if(!supportsSchedules()&&currentView==='schedules')setView('workspace');
  const groupToSelect=sourceChanged&&(state.groups||[]).some(group=>group.id===previousSelected)?previousSelected:state.selected;
  if(online&&!selected&&groupToSelect){await selectGroup(groupToSelect,{persistSelection:false});}else if(!selected&&isDatabase())renderMessages(true);
  else if(online&&selected){
   const version=groupVersion;
   try{
    const data=await api(groupQuery(snapshotChanged?'/api/group':'/api/messages'));if(version===groupVersion){
     if(snapshotChanged){people=data.members||[];memberCache.set(state.account+'|'+selected,people);renderMembers();$('selected-name').textContent=groupName(selected);$('selected-avatar').textContent=groupName(selected).slice(0,2);}
     messageData=data.messages||[];outboxData=supportsComposer()?data.outbox||[]:[];renderMessages();
     $('sync-status').textContent=isDatabase()?(databaseAuto()?'自动检查源变化':'读取固定副本'):state.syncError?'同步重试中':data.watching?'持续同步':'未启用读取';
     $('stream-hint').textContent=data.watching?(isDatabase()?(databaseAuto()?'变化后更新 · 当前为已校验副本':'读取固定副本 · 手动更新'):isDemo()?'本机演示消息':'已勾选群持续同步'):'请先勾选读取这个会话';
     $('last-sync').textContent=isDatabase()?'副本创建于 '+sourceTime(state.runtime?.source?.createdAt):state.lastSync?'更新于 '+stamp(state.lastSync):'';
    }
   }catch(error){$('global-error').hidden=false;$('global-error').textContent=error.message;$('stream-hint').textContent=isDatabase()?'副本读取失败，自动重试读取中':'当前群同步失败，自动重试中';$('stream-dot').classList.remove('active');}
  }
  if($('login-dialog').open)renderLogin();
 }catch(error){serviceAvailable=false;serviceError=error.message;setConnection();renderSchedules();if($('login-dialog').open)renderLogin();}
 finally{pollBusy=false;}
}

async function loadTimerMembers(){const group=$('schedule-group').value,account=state.account;$('schedule-members').replaceChildren();if(!group)return;try{let members=memberCache.get(account+'|'+group);if(!members){members=(await api(groupQuery('/api/group',group))).members;memberCache.set(account+'|'+group,members);}if(group!==$('schedule-group').value||account!==state.account)return;for(const member of members.filter(x=>x.id!==state.selfId)){const option=el('option','',member.name+' · '+member.kind);option.value=member.id;option.selected=group===selected&&mentionIds.has(member.id);$('schedule-members').append(option);}}catch(error){toast(error.message,true);}}
function openSchedule(copyText=false){if(!supportsSchedules())return;if(!online){$('login-dialog').showModal();renderLogin();return;}$('schedule-group').replaceChildren();for(const group of state.groups){const option=el('option','',group.name);option.value=group.id;option.selected=group.id===selected;$('schedule-group').append(option);}$('schedule-text').value=copyText?$('message-text').value:'';$('schedule-dialog-title').textContent=isDemo()?'新建每日模拟任务':'新建每日发送任务';$('schedule-dialog').showModal();loadTimerMembers();}
$('group-search').oninput=renderGroups;$('member-search').oninput=renderMembers;
$('message-text').oninput=()=>{$('text-count').textContent=$('message-text').value.length+' / 2000';saveDraft();controls();};
$('message-text').onkeydown=event=>{if(!event.isComposing&&event.key==='Enter'&&(event.metaKey||event.ctrlKey)){event.preventDefault();if(!$('send-button').disabled)$('send-form').requestSubmit();}};
$('send-form').onsubmit=async event=>{
 event.preventDefault();if(isDatabase()){await prepareHookMessage();return;}if(sendBusy||!online||!selected||groupLoadState!=='ready'||state.loggingOut||state.runtime?.capabilities?.canSend===false)return;
 const account=state.account,group=selected,text=$('message-text').value.trim(),original=$('message-text').value,mentions=[...mentionIds];if(!text)return;
 sendBusy=true;controls();
 try{
  await api('/api/send',{account,groupId:group,text,mentionIds:mentions,requestId:crypto.randomUUID()});
  if(selected===group&&state.account===account&&$('message-text').value===original){$('message-text').value='';$('text-count').textContent='0 / 2000';mentionIds.clear();renderMembers();saveDraft();}
  else{const key=draftKey(account,group),draft=draftMemory.get(key);if(draft?.text===original){draftMemory.delete(key);try{sessionStorage.removeItem(key);}catch{}}}
  toast(isDemo()?'已加入本机模拟队列，不会发送到真实微信':'已加入发送队列，结果会显示在消息流中');await poll();
 }catch(error){toast(error.message,true);}finally{sendBusy=false;controls();}
};

$('reply-form').onsubmit=async event=>{
 event.preventDefault();if(replyBusy||$('save-reply').disabled)return;replyBusy=true;controls();const group=selected,account=state.account;
 try{const rule=await api('/api/reply',{account,groupId:group,enabled:$('reply-enabled').checked,text:$('reply-text').value,cooldown:Number($('reply-cooldown').value)});if(group===selected&&account===state.account)applyRule(rule);toast(isDemo()?'本机模拟规则已保存':rule.enabled?'自动回复已开启，将 @ 发送者后回复':'规则已保存，自动回复关闭');}
 catch(error){toast(error.message,true);}finally{replyBusy=false;controls();}
};

$('schedule-form').onsubmit=async event=>{
 event.preventDefault();if(scheduleBusy||!supportsSchedules()||state.runtime?.capabilities?.canSend===false)return;scheduleBusy=true;$('create-schedule').disabled=true;
 try{await api('/api/jobs',{account:state.account,groupId:$('schedule-group').value,text:$('schedule-text').value,mentionIds:[...$('schedule-members').selectedOptions].map(x=>x.value),clock:$('schedule-clock').value});$('schedule-dialog').close();toast(isDemo()?'每日模拟任务已创建':'每日定时任务已创建');await poll();setView('schedules');}
 catch(error){toast(error.message,true);}finally{scheduleBusy=false;$('create-schedule').disabled=false;controls();}
};

$('schedule-group').onchange=loadTimerMembers;$('new-schedule').onclick=()=>openSchedule();$('schedule-from-message').onclick=()=>openSchedule(true);
$('filter-all').onclick=()=>{filter='all';$('filter-all').classList.add('active');$('filter-mentions').classList.remove('active');renderMessages(true);};
$('filter-mentions').onclick=()=>{if($('filter-mentions').disabled)return;filter='mentions';$('filter-mentions').classList.add('active');$('filter-all').classList.remove('active');renderMessages(true);};
for(const tab of ['send','reply'])$(tab+'-tab').onclick=()=>{for(const other of ['send','reply']){$(other+'-tab').classList.toggle('active',other===tab);$(other+'-form').hidden=other!==tab;}};
document.querySelectorAll('[data-view]').forEach(button=>button.onclick=()=>setView(button.dataset.view));document.querySelectorAll('.close-dialog').forEach(button=>button.onclick=()=>button.closest('dialog').close());
function openAccount(){if(isDatabase()){openDatabaseSettings();return;}renderLogin();$('login-dialog').showModal();}
$('account-button').onclick=openAccount;
$('login-action').onclick=async()=>{try{if(isDemo()){$('login-dialog').close();setView('environment');return;}if(online){$('login-dialog').close();openReading();return;}await api('/api/login',{});await poll();renderLogin();}catch(error){toast(error.message,true);}};
$('refresh-button').onclick=async()=>{if(isDatabase()){if(databaseData?.configured)await refreshDatabase();else openDatabaseSettings();return;}$('refresh-button').disabled=true;try{await poll();if(!serviceAvailable)throw Error(serviceError);await api('/api/refresh',{});await poll();if(selected)await selectGroup(selected);if(currentView==='environment')await loadEnvironment();toast(isDemo()?'已刷新本机演示数据':'已刷新账号和会话');}catch(error){toast(error.message,true);}finally{$('refresh-button').disabled=false;}};
async function cycle(){await poll();setTimeout(cycle,document.hidden?6000:2200);}window.addEventListener('DOMContentLoaded',cycle);


function updateJump(){const list=$('message-list');$('jump-latest').hidden=list.scrollHeight-list.scrollTop-list.clientHeight<100;}
$('message-list').addEventListener('scroll',updateJump,{passive:true});
$('jump-latest').onclick=()=>{$('message-list').scrollTo({top:$('message-list').scrollHeight,behavior:'smooth'});};
$('message-search').oninput=()=>{$('clear-message-search').hidden=!$('message-search').value;renderMessages(true);};
$('clear-message-search').onclick=()=>{$('message-search').value='';$('message-search').oninput();$('message-search').focus();};
for(const name of ['all','watched'])$('groups-'+name).onclick=()=>{groupFilter=name;for(const item of ['all','watched']){$('groups-'+item).classList.toggle('active',item===name);$('groups-'+item).setAttribute('aria-pressed',String(item===name));}renderGroups();};
$('runtime-details').onclick=()=>setView('environment');
window.addEventListener('pagehide',()=>saveDraft());
document.addEventListener('keydown',event=>{
 if((event.ctrlKey||event.metaKey)&&event.key.toLowerCase()==='k'&&!document.querySelector('dialog[open]')){event.preventDefault();setView('workspace');$('group-search').focus();$('group-search').select();}
});

function renderEnvironment(){
 const overview=$('environment-overview'),checks=$('environment-checks'),limits=$('environment-limitations');overview.replaceChildren();checks.replaceChildren();limits.replaceChildren();
 if(environmentError){overview.append(emptyCard('暂时无法获取环境诊断',environmentError,'info'));return;}
 if(!environmentData)return;
 const data=environmentData,items=[['运行模式',data.mode==='database'?'真实微信 · 本地接收与发送':data.mode==='demo'?'本机演示':'真实桥接'],['操作系统',data.platform||'未知'],['Python',data.pythonVersion||'未知'],['时区',data.timezone||'Asia/Shanghai']];
 for(const [label,value] of items){const card=el('div','environment-stat');card.append(el('small','',label),el('strong','',value));overview.append(card);}
 const statusLabels={ok:'正常',warning:'需留意',error:'待处理'},rows=data.checks||[];
 for(const item of rows){const row=el('article','environment-check '+item.status),mark=el('span','check-symbol',item.status==='ok'?'✓':item.status==='warning'?'!':'×'),body=el('div');body.append(el('strong','',item.label||item.id),el('p','',item.detail||''));row.append(mark,body,el('span','check-status',statusLabels[item.status]||item.status));checks.append(row);}
 if(data.runtimeDirectory){const path=el('div','runtime-directory');path.append(el('strong','','本机数据目录'),el('code','',data.runtimeDirectory));limits.append(path);}
 if(data.limitations?.length){limits.append(el('h3','','当前能力边界'));const list=el('ul');for(const item of data.limitations)list.append(el('li','',item));limits.append(list);}
 const count=rows.filter(item=>item.status==='error').length;$('environment-count').hidden=!count;$('environment-count').textContent=count;
 $('environment-time').textContent='检查于 '+new Intl.DateTimeFormat('zh-CN',{hour:'2-digit',minute:'2-digit',second:'2-digit'}).format(environmentTime);
 $('copy-environment').disabled=false;
}
async function loadEnvironment(){
 if(environmentBusy)return;environmentBusy=true;$('check-environment').disabled=true;environmentError='';
 try{environmentData=await api('/api/environment');environmentTime=new Date();renderEnvironment();}
 catch(error){environmentError=error.message;renderEnvironment();$('copy-environment').disabled=true;}
 finally{environmentBusy=false;$('check-environment').disabled=false;}
}
$('check-environment').onclick=loadEnvironment;
$('copy-environment').onclick=async()=>{
 if(!environmentData)return;
 const data=environmentData,text=['WeBridge 环境诊断','模式: '+data.mode,'系统: '+data.platform,'Python: '+data.pythonVersion,'时区: '+data.timezone,...(data.checks||[]).map(item=>'['+item.status+'] '+item.label+': '+item.detail),...(data.limitations||[])].join('\n');
 try{await navigator.clipboard.writeText(text);toast('诊断摘要已复制');}catch{toast('浏览器未允许写入剪贴板，请选中诊断内容后复制。',true);}
};
let windowsClients=[],windowsBusy=false,windowsVersion=0;
function clearWindowsPreview(){
 ++windowsVersion;
 const area=$('windows-preview-result');area.replaceChildren();area.hidden=true;
 $('windows-clear-preview').hidden=true;
 if(windowsBusy)$('windows-client-status').textContent='预览已清除，当前检测或读取结束后可再次操作。';
}
function resetWindowsSelection(message){
 windowsClients=[];$('windows-window').replaceChildren();$('windows-window').hidden=true;
 $('windows-client-status').textContent=message;
}
function resetWindowsPanel(){
 clearWindowsPreview();resetWindowsSelection(windowsBusy?'预览已清除，当前检测或读取结束后可重新检测。':'尚未检测。请打开微信窗口，重新检测后按需读取。');updateWindowsPreview();
}
function selectedWindowsClient(){return windowsClients[Number($('windows-window').value)];}
function updateWindowsPreview(){
 const target=selectedWindowsClient(),disabled=windowsBusy||!target||!target.visible||target.minimized;
 $('windows-preview').disabled=disabled;$('windows-ocr-preview').disabled=disabled;
 $('windows-detect').disabled=windowsBusy;$('windows-window').disabled=windowsBusy;
}
function finishWindowsRequest(version){
 windowsBusy=false;
 if(version!==windowsVersion)$('windows-client-status').textContent=windowsClients.length?'预览已清除。如需查看，请再次选择读取方式。':'尚未检测。请打开微信窗口，重新检测后按需读取。';
 updateWindowsPreview();
}
$('windows-window').onchange=()=>{clearWindowsPreview();updateWindowsPreview();};
$('windows-clear-preview').onclick=clearWindowsPreview;
document.addEventListener('visibilitychange',()=>{if(document.hidden)resetWindowsPanel();});
window.addEventListener('pagehide',resetWindowsPanel);
$('windows-detect').onclick=async()=>{
 if(windowsBusy)return;
 clearWindowsPreview();resetWindowsSelection('正在检测本机微信窗口…');
 const version=windowsVersion;windowsBusy=true;updateWindowsPreview();
 try{
  const data=await api('/api/windows/status');if(version!==windowsVersion)return;
  windowsClients=data.supported===false?[]:data.windows||[];
  const select=$('windows-window');
  windowsClients.forEach((win,index)=>{
   const option=el('option','',(win.title||'微信窗口')+(win.version?' · '+win.version:'')+(win.minimized?'（已最小化）':!win.visible?'（不可见）':''));
   option.value=index;select.append(option);
  });
  const preferred=windowsClients.findIndex(win=>win.visible&&!win.minimized),visible=windowsClients.findIndex(win=>win.visible||win.minimized);
  if(preferred>=0||visible>=0)select.value=String(preferred>=0?preferred:visible);
  select.hidden=!windowsClients.length;
  const summary=data.processCount?'检测到 '+data.processCount+' 个微信进程；可读取窗口 '+windowsClients.filter(win=>win.visible&&!win.minimized).length+' 个。':'';
  const issue=data.issue||(windowsClients.length?'请选择窗口后主动读取。':data.supported===false?'当前运行环境不支持 Windows 本机微信检测。':'未检测到可用微信窗口。请打开本机微信，恢复窗口后重新检测。');
  $('windows-client-status').textContent=summary+issue+(windowsClients.length?' 检测于 '+stamp(Date.now()/1000)+'，仅代表检测时状态。':'');
 }catch(error){if(version===windowsVersion)resetWindowsSelection(error.message);}
 finally{finishWindowsRequest(version);}
};
async function readWindowsPreview(method){
 const target=selectedWindowsClient();if(windowsBusy||!target||!target.visible||target.minimized)return;
 clearWindowsPreview();const version=windowsVersion,isOcr=method==='ocr';
 windowsBusy=true;updateWindowsPreview();
 const area=$('windows-preview-result');area.hidden=false;$('windows-clear-preview').hidden=false;
 area.replaceChildren(el('p','subtle',isOcr?'正在本机识别所选窗口…请保持微信可见且不被其他窗口遮挡。':'正在读取当前可见界面…'));
 try{
  const data=await api(isOcr?'/api/windows/ocr-preview':'/api/windows/preview',{hwnd:target.hwnd,pid:target.pid});
  if(version!==windowsVersion)return;
  area.replaceChildren();
  if(['window_changed','not_running','no_visible_window','window_occluded','window_outside_desktop','input_desktop_unavailable'].includes(data.issueCode))resetWindowsSelection('窗口状态已变化或不满足读取条件，请调整窗口后重新检测。');
  const texts=Array.isArray(data.texts)?data.texts.filter(item=>item.text):[];
  area.append(el('strong','',isOcr?'本地屏幕识别结果':'界面文字预览'),el('p','client-source','来源：'+(data.source||(isOcr?'windows-ocr':'windows-uia'))+' · 群身份未验证 · 不具备发送能力'));
  if(data.title)area.append(el('p','subtle','所选窗口：'+data.title));
  const captured=Date.parse(data.capturedAt||'');
  if(Number.isFinite(captured))area.append(el('p','subtle','采集于 '+stamp(captured/1000,{month:'2-digit',day:'2-digit',hour:'2-digit',minute:'2-digit',second:'2-digit'})+'（上海时间） · 单次快照'));
  if(data.issue)area.append(el('p','client-limits',data.issue));
  if(texts.length){
   const list=el('div','client-preview-texts');
   for(const item of texts){const row=el('div','client-preview-line');row.append(el('small','',item.controlType||(isOcr?'OCR':'文字')),el('span','',item.text));list.append(row);}
   area.append(list,el('p','subtle','显示 '+texts.length+' 项窗口文字，可能包含会话列表；'+(isOcr?'OCR 文字可能误识别；':'')+'不证明完整消息、群身份或真实 @。'));
  }else if(!data.issue){
   area.append(el('p','client-limits',isOcr?'未识别到文字。请保持微信窗口可见且未被遮挡，调整窗口后重新检测。':'窗口未公开可读取的文字。可保持微信可见且不被遮挡后，尝试“本地屏幕识别”。'));
  }
  if(data.truncated)area.append(el('p','client-limits','结果已截断，仅展示部分窗口文字。'));
 }catch(error){
  if(version===windowsVersion){resetWindowsSelection('读取未完成，请重新检测本机微信后重试。');area.replaceChildren(el('p','client-limits',error.message));}
 }finally{finishWindowsRequest(version);}
}
$('windows-preview').onclick=()=>readWindowsPreview('uia');
$('windows-ocr-preview').onclick=()=>readWindowsPreview('ocr');


function updateDatabaseControls(){
 const busy=databaseBusy||databaseOperation||(databaseLoading&&!databaseData);
 for(const id of ['database-source-root','database-self-id','database-key-file','database-auto-refresh'])$(id).disabled=busy;
 $('database-configure').disabled=busy||!serviceAvailable;
 $('database-refresh').disabled=busy||!databaseData?.configured||!serviceAvailable;
 $('database-refresh-workspace').disabled=busy||!databaseData?.configured||!serviceAvailable;
 $('database-browse').disabled=!online;
 $('database-configure').textContent=databaseBusy?'正在后台创建副本…':databaseOperation?'正在提交…':'保存配置并创建只读副本';
 if(isDatabase()){$('refresh-button').disabled=busy;$('refresh-button').title='手动创建或更新只读副本';$('refresh-button').querySelector('span:last-child').textContent='更新副本';}
}
function appendSourceFacts(parent,source){
 const facts=[['源数据库目录',source.sourceRoot||'尚未配置'],['副本创建时间',sourceTime(source.createdAt)],['最近读取时间',sourceTime(source.readAt)],['副本文件',(source.dbCount||0)+' 个数据库 · '+(source.walCount||0)+' 个 WAL']];
 for(const [label,value] of facts){const row=el('div','database-source-fact');row.append(el('small','',label),el('span','',value));parent.append(row);}
}
function renderDatabaseSource(){
 const source=state.runtime?.source||{},area=$('database-source-summary');area.replaceChildren();
 area.append(el('p','database-source-status',databaseBusy?'正在更新 · 当前保留上次成功副本':databaseData?.error&&online?'更新失败 · 当前为上次成功副本':online?(databaseAuto()?'自动检查变化 · 当前副本可读':'副本可读 · 手动更新'):'等待创建可用副本'));
 document.querySelector('#database-source-controls .small-card p').textContent='不修改源数据库。Hook 发送需独立检查模块与账号。'+databasePolicy();
 appendSourceFacts(area,source);
}
function renderDatabase(data){
 databaseData=data;databaseBusy=!!data.busy;
 if(!databaseFormLoaded||!databaseDirty){
  for(const [id,key] of [['database-source-root','sourceRoot'],['database-self-id','selfId'],['database-key-file','keyFile']])if($(id).value!==(data.config?.[key]||''))$(id).value=data.config?.[key]||'';
  $('database-auto-refresh').checked=data.config?.autoRefresh!==false;
 }
 databaseFormLoaded=true;
 const source=data.source||{},ready=['ready','snapshot_ready'].includes(source.status),error=data.error||source.error||'';
 $('database-error').hidden=!error;$('database-error').textContent=error;
 $('database-status-badge').textContent=databaseBusy?'创建中':error?'需处理':ready?'副本已就绪':data.configured?'待创建':'待配置';
 $('database-progress').textContent=databaseBusy?'正在后台复制并校验数据库及 WAL，完成后自动加载结果；已有成功副本仍可查看。':error&&ready?'更新未成功，当前保留上次成功副本。请检查错误原因后重试。':ready?'副本已就绪。'+databasePolicy():data.configured?'尚无可用副本，请检查配置并创建。':'填写源数据库目录，创建只读副本后即可查看会话。';
 const detail=$('database-source-detail');detail.replaceChildren();if(source.sourceRoot)appendSourceFacts(detail,source);
 setConnection();updateDatabaseControls();
}
function scheduleDatabaseMonitor(){
 clearTimeout(databaseTimer);
 if((databaseBusy||databaseAuto())&&isDatabase()&&!state.runtime?.databaseState)databaseTimer=setTimeout(()=>loadDatabase(),2000);
}
function syncDatabaseRuntime(){
 const status=state.runtime?.databaseState;if(!isDatabase()||!status)return;
 const completed=databaseBusy&&!status.busy;databaseBusy=!!status.busy;
 if(databaseData)renderDatabase({...databaseData,busy:databaseBusy,error:status.error||'',source:state.runtime?.source||databaseData.source});
 if(completed&&databaseData&&!databaseLoading)loadDatabase();
}
async function loadDatabase(){
 if(!isDatabase()||databaseLoading)return databaseData;
 databaseLoading=true;const version=databaseFetchVersion,wasBusy=databaseBusy;updateDatabaseControls();
 try{
  const data=await api('/api/database');if(version!==databaseFetchVersion||!isDatabase())return databaseData;
  renderDatabase(data);if(wasBusy&&!databaseBusy)await poll();return data;
 }catch(error){
  if(version===databaseFetchVersion){$('database-error').hidden=false;$('database-error').textContent=error.message;$('database-progress').textContent='无法读取数据源状态，请检查本机服务后重试。';}
 }finally{databaseLoading=false;updateDatabaseControls();scheduleDatabaseMonitor();}
}
async function changeDatabase(path,body){
 if(databaseBusy||databaseOperation||!isDatabase())return;
 databaseOperation=true;++databaseFetchVersion;updateDatabaseControls();$('database-error').hidden=true;
 try{
  const data=await api(path,body);databaseDirty=false;renderDatabase(data);await poll();
  if(!data.busy&&!data.error)toast('只读副本已就绪');
 }catch(error){const failure=error.message;await loadDatabase();$('database-error').hidden=false;$('database-error').textContent=failure;$('database-progress').textContent='请求未完成，请检查状态后重试。';}
 finally{databaseOperation=false;updateDatabaseControls();scheduleDatabaseMonitor();}
}
function openDatabaseSettings(){setView('environment');loadDatabase();}
async function refreshDatabase(){if(!databaseData?.configured){openDatabaseSettings();return;}await changeDatabase('/api/database/refresh',{});}
$('database-form').onsubmit=async event=>{event.preventDefault();await changeDatabase('/api/database/configure',{sourceRoot:$('database-source-root').value.trim(),selfId:$('database-self-id').value.trim(),keyFile:$('database-key-file').value.trim(),autoRefresh:$('database-auto-refresh').checked});};
for(const id of ['database-source-root','database-self-id','database-key-file','database-auto-refresh'])$(id).addEventListener('input',()=>databaseDirty=true);
$('database-refresh').onclick=refreshDatabase;$('database-refresh-workspace').onclick=refreshDatabase;
$('database-open-settings').onclick=openDatabaseSettings;$('database-browse').onclick=()=>setView('workspace');
