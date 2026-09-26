// Run against the real, unconfigured database server. Blocks every write/native/chat API.
async (page) => {
  const checks=[],errors=[],blocked=[];
  const onError=error=>errors.push(error.message);
  const guard=route=>{
    const request=route.request(),path=request.url().split('?')[0].split('/').pop();
    if(request.method()==='GET'&&['state','environment','database'].includes(path))return route.continue();
    blocked.push(path);return route.fulfill({status:409,json:{error:'Entry check blocks writes and chat/native access.'}});
  };
  await page.route('**/api/**',guard);page.on('pageerror',onError);
  try{
    await page.setViewportSize({width:1440,height:1000});
    await page.goto('http://127.0.0.1:8787/');
    await page.waitForFunction(()=>document.getElementById('database-status-badge').textContent==='待配置');
    if(!await page.locator('#environment-view').isVisible()||!(await page.locator('#runtime-title').innerText()).includes('数据库'))throw Error('Database setup is not the initial view.');
    checks.push('real_database_server_opens_unconfigured_setup');
    if(await page.locator('#database-source-root').inputValue()||await page.locator('#database-key-file').inputValue()||!await page.locator('#database-browse').isDisabled())throw Error('Unexpected configured source.');
    checks.push('no_source_or_key_filled_and_no_unavailable_read_entry');
    await page.screenshot({path:'output/playwright/database-setup-real-entry.png',fullPage:true});
    await page.setViewportSize({width:390,height:844});
    if(!await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth)||errors.length||blocked.length)throw Error('Overflow, JavaScript error or unexpected write/native/chat request.');
    checks.push('390px_without_overflow_errors_or_write_native_chat_requests');
    return {checks,realPage:true,databaseConfigured:false,realChatReadOrSend:false};
  }finally{page.off('pageerror',onError);await page.goto('http://127.0.0.1:8797/');await page.unroute('**/api/**',guard);await page.setViewportSize({width:1440,height:1000});}
}
