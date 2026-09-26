'use strict';
const mediaStates=new Map();
let pdfCleanup=null;
async function previewPdf(url,area){
 const host=el('div','pdf-viewer'),status=el('p','subtle','正在打开 PDF…');host.append(status);area.append(host);
 let task=null,document=null,disposed=false,page=1,busy=false;
 pdfCleanup=()=>{disposed=true;if(task)task.destroy();};
 try{
  const pdfjs=await import('/vendor/pdfjs/pdf.min.mjs');if(disposed)return;
  pdfjs.GlobalWorkerOptions.workerSrc='/vendor/pdfjs/pdf.worker.min.mjs';
  task=pdfjs.getDocument({url,isEvalSupported:false,disableAutoFetch:true,cMapUrl:'/vendor/pdfjs/cmaps/',cMapPacked:true,standardFontDataUrl:'/vendor/pdfjs/standard_fonts/',wasmUrl:'/vendor/pdfjs/wasm/'});
  document=await task.promise;if(disposed)return;
  const toolbar=el('div','pdf-toolbar'),prev=el('button','button secondary','上一页'),next=el('button','button secondary','下一页'),label=el('span','subtle'),canvas=el('canvas');
  prev.type=next.type='button';toolbar.append(prev,label,next);host.replaceChildren(toolbar,canvas,status);
  async function render(){
   if(disposed||busy)return;busy=true;prev.disabled=next.disabled=true;status.textContent='正在渲染…';
   try{const current=await document.getPage(page);if(disposed)return;const initial=current.getViewport({scale:1}),width=Math.min(host.clientWidth||800,1000),ratio=Math.min(window.devicePixelRatio||1,2),viewport=current.getViewport({scale:width/initial.width});canvas.width=Math.floor(viewport.width*ratio);canvas.height=Math.floor(viewport.height*ratio);canvas.style.width=viewport.width+'px';canvas.style.height=viewport.height+'px';await current.render({canvasContext:canvas.getContext('2d'),viewport,transform:ratio===1?null:[ratio,0,0,ratio,0,0]}).promise;label.textContent=page+' / '+document.numPages+' 页';canvas.setAttribute('aria-label','PDF 第 '+page+' 页');status.textContent='';}
   catch(error){if(!disposed)status.textContent='本页暂时无法预览，可下载原文件查看。';}
   finally{busy=false;prev.disabled=page<=1;next.disabled=page>=document.numPages;}
  }
  prev.onclick=()=>{if(page>1&&!busy){page--;render();}};next.onclick=()=>{if(page<document.numPages&&!busy){page++;render();}};await render();
 }catch(error){if(!disposed)status.textContent='PDF 暂时无法预览，可下载原文件查看。';}
}
function sizeLabel(bytes){if(!bytes)return '';return bytes<1024*1024?(bytes/1024).toFixed(1)+' KB':(bytes/1024/1024).toFixed(1)+' MB';}
function assetUrl(asset,account,download=false){return '/api/asset?'+new URLSearchParams({id:asset.assetId,account,...(download?{download:'1'}:{})});}
function showMedia(asset,account){
 if(asset.kind==='video'&&asset.previewOnly){toast('目前只有视频封面，请先下载完整视频。',true);return;}
 $('media-title').textContent=asset.filename;const area=$('media-preview');area.replaceChildren();const url=assetUrl(asset,account);
 if(asset.mime.startsWith('image/')){const img=el('img');img.src=url;img.alt=asset.filename;area.append(img);}
 else if(asset.mime.startsWith('video/')){const video=el('video');video.src=url;video.controls=true;video.preload='metadata';area.append(video);}
 else if(asset.mime==='application/pdf'){previewPdf(url,area);}
 else if(asset.mime==='text/plain'){const frame=el('iframe');frame.src=url;frame.title=asset.filename;frame.setAttribute('sandbox','allow-same-origin');area.append(frame);}
 else area.append(el('p','empty compact','此格式暂不支持浏览器预览，可下载后打开。'));
 const download=el('a','button secondary','下载文件');download.href=assetUrl(asset,account,true);download.download=asset.filename;area.append(download);$('media-dialog').showModal();
}
function mediaCard(message,group,account,description=message.media){
 const part=description.part||'',key=[account,group,message.id,part].join('|'),source=sourceSignature(state);const wrapper=el('div','media-card');
 const title=el('strong','media-filename',description.filename||message.text),detail=el('small','subtle',[description.duration?description.duration+' 秒':'',sizeLabel(description.size)].filter(Boolean).join(' · '));wrapper.append(title,detail);
 const area=el('div','media-body');wrapper.append(area);
 if(state.runtime?.capabilities?.media===false){area.append(el('p','media-pending',isDatabase()?'当前仅接入数据库消息记录，尚未接入附件文件。':'当前运行模式不提供附件读取。'));return wrapper;}
 function paint(){
  const value=mediaStates.get(key);area.replaceChildren();
  if(value?.status==='loading'){area.append(el('div','media-pending',description.kind==='video'?'正在获取完整视频…':'正在读取附件…'));return;}
  if(value?.status==='ready'){
   if(value.kind==='video'&&value.previewOnly){
    const poster=el('img','video-poster');poster.src=assetUrl(value,account);poster.alt='视频封面（尚未取得完整视频）';area.append(poster,el('p','media-pending',value.reason||'当前仅有封面，尚未取得可播放的视频。'));
    const retry=el('button','button secondary','下载并播放视频');retry.type='button';retry.onclick=loadMedia;area.append(retry);return;
   }
   if(value.mime.startsWith('image/')){const button=el('button','image-preview');button.type='button';const image=el('img');image.src=assetUrl(value,account);image.alt=value.filename;image.loading='lazy';button.append(image);button.onclick=()=>showMedia(value,account);area.append(button);if(value.previewOnly){area.append(el('p','subtle',value.kind==='video'?'当前仅有视频封面，完整视频尚未下载。':'当前显示缩略图。'));const retry=el('button','button secondary','重新读取完整附件');retry.type='button';retry.onclick=loadMedia;area.append(retry);}}
   else if(value.mime.startsWith('video/')){const video=el('video','inline-video');video.src=assetUrl(value,account);video.controls=true;video.preload='metadata';area.append(video);}
   const actions=el('div','media-actions');const open=el('button','button quiet',value.kind==='image'?'查看大图':'打开预览');open.type='button';open.onclick=()=>showMedia(value,account);const download=el('a','button quiet','下载');download.href=assetUrl(value,account,true);download.download=value.filename;actions.append(open,download);area.append(actions);return;
  }
  if(value?.reason)area.append(el('p','media-pending',value.reason));
  const load=el('button','button secondary',value?'重试读取':description.kind==='video'?'加载视频':description.kind==='file'?'查看文件':'查看图片');load.type='button';load.onclick=loadMedia;area.append(load);
 }
 async function loadMedia(){
  if(state.account!==account||sourceSignature(state)!==source||mediaStates.get(key)?.status==='loading')return;
  mediaStates.set(key,{status:'loading'});paint();
  try{const value=await api('/api/media',{account,groupId:group,messageId:message.id,part});if(state.account!==account||sourceSignature(state)!==source)return;mediaStates.set(key,value);paint();}
  catch(error){if(state.account!==account||sourceSignature(state)!==source)return;mediaStates.set(key,{status:'pending',reason:error.message});paint();}
 }
 paint();
 if(['image','emoji'].includes(description.kind)&&!mediaStates.has(key)){
  const observer=new IntersectionObserver(entries=>{if(entries.some(x=>x.isIntersecting)){observer.disconnect();loadMedia();}},{root:$('message-list'),rootMargin:'100px'});observer.observe(wrapper);
 }
 return wrapper;
}
function showRecord(record,message,group,account){
 $('record-title').textContent=record.title||'聊天记录';const area=$('record-content');area.replaceChildren();
 function appendRecord(data,parent,depth=0){
  if(data.error){parent.append(el('p','media-pending',data.error));return;}
  for(const item of data.items||[]){
   const row=el('article','record-item'),meta=el('div','message-meta');meta.append(el('strong','',item.sender),el('time','',item.time));row.append(meta);
   if(item.media)row.append(mediaCard(message,group,account,item.media));
   else if(item.record&&depth<5){const nested=el('details','nested-record');nested.append(el('summary','',item.record.title||'嵌套聊天记录'));appendRecord(item.record,nested,depth+1);row.append(nested);}
   else row.append(el('div','record-text',item.text));parent.append(row);
  }
  if(data.truncated)parent.append(el('p','subtle','本版最多展开每层 200 条记录。'));
 }
 appendRecord(record,area);$('record-dialog').showModal();
}
function messageContent(message,group,account){
 if(message.media)return mediaCard(message,group,account);
 if(message.kind==='record'){
  const card=el('button','record-card');card.type='button';card.append(el('span','record-label','合并聊天记录'),el('strong','',message.text||message.record.title));
  for(const item of (message.record.items||[]).slice(0,3))card.append(el('span','record-excerpt',item.sender+'：'+(item.text||item.media?.filename||'附件')));
  card.append(el('small','',`${message.record.count||0} 条记录 · 点击展开`));card.onclick=()=>showRecord(message.record,message,group,account);return card;
 }
 const bubble=el('div','message-bubble');bubble.append(el('div','',message.text));
 if(message.quote?.text){const quote=el('div','quoted-message');quote.append(el('strong','',message.quote.sender),el('span','',message.quote.text));bubble.append(quote);}
 if(message.description)bubble.append(el('p','subtle',message.description));return bubble;
}
function openReading(){
 if(!online){if(isDatabase()){openDatabaseSettings();return;}renderLogin();$('login-dialog').showModal();return;}
 const list=$('scope-options');list.replaceChildren();const watching=new Set(state.watchedGroups||[]);
 for(const group of state.groups||[]){const row=el('label','scope-row'),input=el('input');input.type='checkbox';input.value=group.id;input.checked=watching.has(group.id);input.onchange=scopeCount;row.append(input,el('span','',group.name));list.append(row);}
 scopeCount();$('reading-dialog').showModal();
}
function scopeCount(){$('scope-count').textContent='已选 '+$('scope-options').querySelectorAll('input:checked').length+' / '+(state.groups||[]).length+' 个群';}
$('reading-button').onclick=openReading;
$('read-all').onclick=()=>{$('scope-options').querySelectorAll('input').forEach(x=>x.checked=true);scopeCount();};
$('read-none').onclick=()=>{$('scope-options').querySelectorAll('input').forEach(x=>x.checked=false);scopeCount();};
$('save-reading').onclick=async()=>{
 const account=state.account,groups=[...$('scope-options').querySelectorAll('input:checked')].map(x=>x.value);$('save-reading').disabled=true;
 try{const result=await api('/api/subscriptions',{account,groupIds:groups});if(state.account!==account)return;state.watchedGroups=result.watchedGroups;$('reading-dialog').close();toast('已保存读取范围');renderGroups();if(!selected&&groups.length)await selectGroup(groups[0]);else if(selected)await selectGroup(selected);await poll();}
 catch(error){toast(error.message,true);}finally{$('save-reading').disabled=false;}
};
$('account-entry').onclick=openAccount;
$('logout-button').onclick=async()=>{
 if(isDatabase())return;
 const account=state.account;$('logout-button').disabled=true;$('login-action').disabled=true;$('login-content').replaceChildren(el('h3','','正在退出微信…'),el('p','','正在完成已提交操作，并停止当前账号的自动回复。'));
 try{await api('/api/logout',{account});mediaStates.clear();messageNodes.clear();$('media-dialog').close();$('record-dialog').close();await poll();renderLogin();toast('已退出账号，请扫码重新登录');}
 catch(error){toast(error.message,true);await poll();renderLogin();}finally{$('logout-button').disabled=false;}
};
$('group-info-button').onclick=async()=>{
 if(!selected||!online)return;const group=selected,account=state.account,source=sourceSignature(state);const area=$('group-info-content');area.replaceChildren(el('p','subtle','正在读取群资料…'));$('group-info-dialog').showModal();
 try{const info=await api(groupQuery('/api/group-info',group));if(state.account!==account||selected!==group||sourceSignature(state)!==source)return;area.replaceChildren(el('h3','',info.name),el('p','subtle','群主：'+(info.ownerName||(isDatabase()?'副本未提供':'未知'))),el('p','subtle','群 ID：'+info.id),el('h3','',(info.memberCount??info.members?.length??0)+(isDatabase()?' 条副本成员记录':' 位成员')));for(const member of info.members||[]){const row=el('div','member-info');row.append(el('span','',member.name),el('small','subtle',member.kind));area.append(row);}}
 catch(error){if(state.account===account&&selected===group&&sourceSignature(state)===source)area.replaceChildren(el('p','media-pending',error.message));}
};
$('media-dialog').addEventListener('close',()=>{if(pdfCleanup){pdfCleanup();pdfCleanup=null;}$('media-preview').replaceChildren();});
