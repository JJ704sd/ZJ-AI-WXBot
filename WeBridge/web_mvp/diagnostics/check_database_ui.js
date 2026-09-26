// playwright-cli run-code --filename web_mvp/diagnostics/check_database_ui.js
// Every API uses synthetic fixtures; no local database or native WeChat data is read.
async (page) => {
  const checks=[];
  const check=(condition,name)=>{if(!condition)throw Error(name);checks.push(name);};
  const source={id:'fixture-source',revision:'r1',status:'snapshot_ready',sourceRoot:'D:\\Synthetic\\db',createdAt:'2026-09-26T06:00:00Z',readAt:'2026-09-26T06:00:01Z',dbCount:2,walCount:1,error:null};
  const group={id:'fixture-db-group',name:'数据库合成群'};
  const runtime={mode:'database',connected:true,platform:'Windows',capabilities:{read:true,canSend:false,liveSend:false,media:false,mentions:false},source};
  const state={runtime,connection:{status:'snapshot_ready'},account:'fixture-db-account',selfId:'',name:'数据库副本',csrfToken:'synthetic',selected:group.id,groups:[group],watchedGroups:[group.id],jobs:[],outbox:[]};
  const database={mode:'database',configured:true,busy:false,config:{sourceRoot:source.sourceRoot,selfId:'',keyFile:''},source,error:null};
  const requests=[],mutations=[],errors=[];
  let sourceMessage='来自第一版合成数据库副本';
  const onError=error=>errors.push(error.message);
  const handler=async route=>{
    const request=route.request(),url=request.url(),path=url.split('?')[0].split('/').pop();requests.push(url);
    if(path==='state')return route.fulfill({json:state});
    if(path==='database')return route.fulfill({json:database});
    if(path==='environment')return route.fulfill({json:{...runtime,checks:[],limitations:[]}});
    if(path==='select')return route.fulfill({json:{ok:true}});
    if(path==='configure'||path==='refresh'){
      mutations.push({path,url,body:request.postDataJSON()});
      if(path==='configure')database.config=request.postDataJSON();
      database.busy=true;database.error=null;
      return route.fulfill({json:{ok:true,...database}});
    }
    if(path==='group'||path==='messages')return route.fulfill({json:{watching:true,members:[{id:'fixture-member',name:'副本成员 '+runtime.source.revision,kind:'合成'}],messages:[
      {id:'fixture-message',kind:'text',text:sourceMessage,senderName:'合成联系人',timestamp:1},
      {id:'fixture-media',kind:'image',text:'合成附件记录',senderName:'合成联系人',timestamp:2,media:{kind:'image',filename:'fixture.png'}},
    ],outbox:[],reply:{enabled:false}}});
    return route.fulfill({status:404,json:{error:'Synthetic test blocks this API.'}});
  };
  page.on('pageerror',onError);
  await page.route('**/api/**',handler);
  try{
    await page.setViewportSize({width:1440,height:1000});
    await page.reload();
    await page.waitForFunction(()=>document.getElementById('message-list').textContent.includes('来自第一版合成数据库副本'));
    check((await page.locator('#connection-pill').innerText()).includes('副本可读')&&!(await page.locator('#runtime-title').innerText()).includes('演示'),'snapshot_ready_loads_groups_and_messages_without_wechat_login');
    check(await page.locator('#composer-controls').isHidden()&&await page.locator('[data-view="schedules"]').isHidden()&&await page.locator('#database-source-controls').isVisible(),'missing_send_capabilities_show_source_status_instead_of_send_controls');
    check(await page.locator('#filter-mentions').isDisabled()&&await page.locator('#mention-availability').isVisible(),'unknown_self_id_disables_mention_filter_with_explanation');
    check((await page.locator('.media-body').innerText()).includes('尚未接入附件')&&!requests.some(url=>/\/api\/(media|asset)/.test(url)),'unavailable_media_never_requests_original_attachments');
    await page.screenshot({path:'output/playwright/database-workspace-fixture.png',fullPage:true});
    await page.locator('#account-entry').click();
    await page.waitForFunction(()=>!document.getElementById('database-source-root').disabled);
    check(await page.locator('#database-panel').isVisible()&&await page.locator('#login-dialog').isHidden()&&mutations.length===0&&(await page.locator('#database-status-badge').innerText())==='副本已就绪','account_entry_opens_ready_database_settings_without_login_or_automatic_copy');
    await page.locator('#database-source-root').fill('D:\\Synthetic\\updated-db');
    await page.locator('#database-self-id').fill('fixture-self');
    await page.locator('#database-key-file').fill('D:\\Synthetic\\keys.json');
    await page.locator('#database-configure').click();
    await page.waitForFunction(()=>document.getElementById('database-status-badge').textContent==='创建中');
    check(await page.locator('#database-source-root').isDisabled()&&await page.locator('#database-configure').isDisabled()&&await page.locator('#database-refresh').isDisabled()&&await page.locator('#refresh-button').isDisabled(),'background_copy_locks_configuration_and_every_refresh_entry');
    check(mutations.length===1&&mutations[0].url.endsWith('/api/database/configure')&&mutations[0].body.keyFile==='D:\\Synthetic\\keys.json'&&mutations[0].body.selfId==='fixture-self','configuration_submits_source_and_optional_local_key_file_path_once');
    database.busy=false;database.source={...source,revision:'r2',status:'ready',sourceRoot:database.config.sourceRoot,createdAt:'2026-09-26T07:00:00Z'};
    runtime.source=database.source;runtime.capabilities.mentions=true;state.selfId='fixture-self';sourceMessage='来自第二版合成数据库副本';
    await page.waitForFunction(()=>!document.getElementById('database-configure').disabled&&document.getElementById('message-list').textContent.includes('来自第二版合成数据库副本'));
    await page.locator('#database-browse').click();
    check((await page.locator('#selected-name').innerText())===group.name&&!(await page.locator('#message-list').innerText()).includes('第一版')&&(await page.locator('#mention-options').textContent()).includes('副本成员 r2'),'revision_change_reloads_messages_and_members_while_preserving_selected_group');
    check(!await page.locator('#filter-mentions').isDisabled()&&(await page.locator('#last-sync').innerText()).includes('15:00:00'),'bound_self_id_enables_mentions_and_copy_time_is_not_poll_time');
    await page.locator('#refresh-button').click();
    await page.waitForFunction(()=>document.getElementById('refresh-button').disabled);
    database.busy=false;database.error='合成校验失败，源数据库未改动';
    await page.waitForFunction(()=>document.getElementById('runtime-detail').textContent.includes('更新未成功'));
    check((await page.locator('#message-list').innerText()).includes('第二版')&&(await page.locator('#database-source-summary').innerText()).includes('上次成功副本')&&mutations[1].url.endsWith('/api/database/refresh')&&mutations.length===2,'failed_manual_refresh_keeps_last_successful_source_and_messages');
    runtime.capabilities.desktopSend=true;runtime.capabilities.canSend=true;
    await page.waitForFunction(()=>!document.getElementById('desktop-sender-entry').hidden);
    check(await page.locator('#composer-controls').isHidden()&&await page.locator('#desktop-sender-entry').isVisible()&&await page.locator('[data-view="schedules"]').isHidden(),'desktop_send_capability_exposes_independent_entry_without_group_automation');
    runtime.capabilities.desktopSend=false;runtime.capabilities.canSend=false;runtime.connected=false;runtime.capabilities.read=false;runtime.source=null;state.groups=[];state.selected=null;state.account=null;
    database.source=null;database.configured=false;database.error=null;database.config={sourceRoot:'',selfId:'',keyFile:''};
    await page.reload();
    await page.waitForFunction(()=>document.getElementById('database-status-badge').textContent==='待配置');
    check(await page.locator('#environment-view').isVisible()&&await page.locator('#database-browse').isDisabled()&&await page.locator('#reading-button').isDisabled(),'unconfigured_database_starts_at_source_setup_and_cannot_read_unavailable_copy');
    await page.screenshot({path:'output/playwright/database-setup-fixture.png',fullPage:true});
    await page.setViewportSize({width:390,height:844});
    check(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth),'database_setup_fits_390px_without_horizontal_overflow');
    check(errors.length===0&&!requests.some(url=>/\/api\/(windows|send|reply|jobs|login|media|asset)(\/|\?|$)/.test(url)),'no_javascript_errors_native_reads_sends_or_media_requests');
    return {checks,allApis:'synthetic',realDatabaseRead:false,nativeReadOrSend:false};
  }finally{page.off('pageerror',onError);await page.unroute('**/api/**',handler);await page.setViewportSize({width:1440,height:1000});await page.reload();}
}
