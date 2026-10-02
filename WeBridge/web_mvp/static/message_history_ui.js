'use strict';
let historyScope='',historyVersion=0,historyBusy=false,historyCursors=[''],historyPage=0,historyNext='';
function messageHistoryScope(){
 return JSON.stringify([state.account,state.runtime?.mode,state.runtime?.source?.id,state.runtime?.source?.revision,selected,
  [...(state.watchedGroups||[])].sort(),...(state.groups||[]).map(row=>row.id).sort(),
  $('history-query').value.trim(),$('history-start-date').value,$('history-end-date').value,$('history-limit').value]);
}
function messageHistoryAvailable(){return isDatabase()&&serviceAvailable&&online&&!!selected&&(state.watchedGroups||[]).includes(selected);}
function historyButtons(){
 const available=messageHistoryAvailable();
 $('open-message-history').hidden=!isDatabase();$('open-message-history').disabled=!available;
 $('history-submit').disabled=!available||historyBusy;
 $('history-prev').disabled=!available||historyBusy||historyPage===0;
 $('history-next').disabled=!available||historyBusy||!historyNext;
 $('history-page').textContent='第 '+(historyPage+1)+' 页';
}
function updateMessageHistoryScope(){
 const scope=messageHistoryScope();
 if(scope!==historyScope){
  historyScope=scope;++historyVersion;historyBusy=false;historyCursors=[''];historyPage=0;historyNext='';
  $('history-results').replaceChildren();
  $('history-status').textContent=messageHistoryAvailable()?'查询条件或副本已变化，点击查询读取当前副本。':'请先选择已勾选读取的会话。';
 }
 $('history-title').textContent=selected?groupName(selected)+' · 历史查询':'会话历史查询';
 historyButtons();
}
function renderMessageHistory(data){
 const list=$('history-results');list.replaceChildren();
 const rows=data.messages;
 if(!rows.length)list.append(emptyCard('本页没有匹配消息',data.hasMore?'还有更早的记录可查询，请点击下一页。':'当前副本中没有更多匹配记录。','search'));
 for(const row of [...rows].reverse()){
  const card=el('article','history-result'),meta=el('div','message-meta');
  meta.append(el('strong','',row.isSelf?'我':row.senderName||'未知成员'),el('time','',stamp(row.timestamp,{year:'numeric',month:'2-digit',day:'2-digit',hour:'2-digit',minute:'2-digit',second:'2-digit'})));
  if(row.mentionSelf)meta.append(el('span','mention-tag','@ 我'));
  card.append(meta,el('p','history-result-text',row.text||'无文字内容'));
  if(row.media?.filename)card.append(el('p','subtle',row.media.filename));
  if(row.textTruncated)card.append(el('p','subtle','长消息仅显示摘要；关键词已在完整文本中匹配。'));
  list.append(card);
 }
 const warnings=data.warnings.slice(0,3).map(row=>row.message);
 $('history-status').textContent='本页 '+rows.length+' 条 · 从新到旧'+(data.scanLimited||data.pageLimited?' · 本批检索已达上限，可继续下一页':data.hasMore?' · 可继续查看更早记录':' · 已查到末尾')+(warnings.length?' · '+warnings.join('；'):'');
 list.scrollTop=0;
}
async function loadMessageHistory(page=0){
 updateMessageHistoryScope();if(historyBusy||!messageHistoryAvailable()||!$('history-dialog').open)return;
 const cursor=page===0?'':historyCursors[page];if(page>0&&!cursor)return;
 const version=historyVersion,scope=historyScope;
 historyBusy=true;historyButtons();$('history-status').textContent='正在查询本地副本…';
 try{
  const params=new URLSearchParams({account:state.account,groupId:selected,query:$('history-query').value.trim(),startDate:$('history-start-date').value,endDate:$('history-end-date').value,limit:$('history-limit').value,cursor});
  const data=await api('/api/message-history?'+params);
  if(version!==historyVersion||scope!==messageHistoryScope()||!$('history-dialog').open)return;
  historyPage=page;historyCursors=historyCursors.slice(0,page+1);historyNext=data.nextCursor;
  if(historyNext)historyCursors[page+1]=historyNext;
  renderMessageHistory(data);
 }catch(error){
  if(version===historyVersion&&scope===messageHistoryScope()&&$('history-dialog').open)$('history-status').textContent='查询失败：'+error.message+' 可重新查询；现有结果尚未更新。';
 }finally{if(version===historyVersion){historyBusy=false;historyButtons();}}
}
$('open-message-history').onclick=()=>{
 $('history-query').value=$('message-search').value.trim();
 $('history-dialog').showModal();updateMessageHistoryScope();loadMessageHistory(0);
};
$('history-form').onsubmit=event=>{event.preventDefault();loadMessageHistory(0);};
for(const id of ['history-query','history-start-date','history-end-date','history-limit'])$(id).addEventListener('input',updateMessageHistoryScope);
$('history-prev').onclick=()=>loadMessageHistory(historyPage-1);
$('history-next').onclick=()=>loadMessageHistory(historyPage+1);
$('history-dialog').addEventListener('close',()=>{++historyVersion;historyBusy=false;historyButtons();});
