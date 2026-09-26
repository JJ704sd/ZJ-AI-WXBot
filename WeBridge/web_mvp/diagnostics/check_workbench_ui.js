// playwright-cli run-code --filename web_mvp/diagnostics/check_workbench_ui.js
// All API calls are synthetic fixtures: no native WeChat read or send is possible.
async (page) => {
  const checks = [];
  const check = (condition, name) => { if (!condition) throw Error(name); checks.push(name); };
  const now = Math.floor(Date.now() / 1000);
  const groups = [{ id: 'fixture-a', name: '合成群甲' }, { id: 'fixture-b', name: '合成群乙' }];
  const state = {
    csrfToken: 'synthetic-only', account: 'fixture-account', selfId: 'fixture-self', name: '合成账号',
    connection: { status: 'logged_in' }, runtime: { mode: 'demo', platform: 'Windows', capabilities: { canSend: true } },
    selected: groups[0].id, groups, watchedGroups: groups.map(group => group.id),
    jobs: [
      { id: 'enabled-job', group_id: groups[0].id, enabled: true, clock: '09:00', text: '合成启用任务', mentions: [], nextRun: now + 3600 },
      { id: 'disabled-job', group_id: groups[0].id, enabled: false, clock: '10:00', text: '合成停用任务', mentions: [], nextRun: now + 7200 },
    ],
    outbox: ['manual', 'reply', 'schedule'].map((origin, index) => ({ id: 'unknown-' + index, origin, status: 'unknown', created_at: now })),
  };
  let delayB = true, releaseB, startedB, finishedB;
  const requestedB = new Promise(resolve => { startedB = resolve; });
  const completedB = new Promise(resolve => { finishedB = resolve; });
  const replyFor = group => ({ enabled: true, text: group === 'fixture-a' ? '甲群原有规则' : '乙群原有规则', cooldown: 30 });
  const handler = async route => {
    const requestUrl = route.request().url(), path = requestUrl.split('?')[0].split('/').pop(), group = /[?&]groupId=([^&]+)/.exec(requestUrl)?.[1];
    if (path === 'state') return route.fulfill({ json: state });
    if (path === 'select' || path === 'refresh') return route.fulfill({ json: { ok: true } });
    if (path === 'group' || path === 'messages') {
      const delayed = path === 'group' && group === 'fixture-b' && delayB;
      if (delayed) {
        startedB();
        await new Promise(resolve => { releaseB = resolve; });
      }
      await route.fulfill({ json: {
        members: [{ id: 'fixture-self', name: '合成账号', kind: '合成' }, { id: group + '-member', name: group + '成员', kind: '合成' }],
        watching: true, messages: [], outbox: [], reply: replyFor(group),
      } });
      if (delayed) finishedB();
      return;
    }
    return route.fulfill({ status: 404, json: { error: 'Synthetic test does not allow this API.' } });
  };
  await page.route('**/api/**', handler);
  try {
    await page.reload();
    await page.waitForFunction(() => document.getElementById('reply-text')?.value === '甲群原有规则');
    await page.locator('#reply-tab').click();
    await page.getByRole('button', { name: /合成群乙/ }).click();
    await requestedB;
    check(await page.locator('#save-reply').isDisabled(), 'loading_group_cannot_overwrite_existing_reply_rule');
    await page.getByRole('button', { name: /合成群甲/ }).click();
    await page.waitForFunction(() => document.getElementById('reply-text').value === '甲群原有规则');
    const receivedB = page.waitForResponse(response => response.url().includes('/api/group?') && response.url().includes('fixture-b'));
    releaseB();
    delayB = false;
    await (await receivedB).finished();
    await page.evaluate(() => new Promise(requestAnimationFrame));
    check(await page.locator('#selected-name').innerText() === '合成群甲', 'late_group_response_cannot_change_selected_group');
    check(await page.locator('#reply-text').inputValue() === '甲群原有规则', 'late_group_response_cannot_replace_current_rule');
    await page.locator('[data-view="schedules"]').click();
    check(await page.locator('#unknown-count').innerText() === '1', 'schedule_unknown_count_excludes_manual_and_reply_records');
    check((await page.locator('#schedule-sent-label').innerText()).includes('最近记录'), 'daily_success_metric_discloses_recent_record_scope');
    check(!(await page.locator('.schedule-row').filter({ hasText: '合成停用任务' }).innerText()).includes('下次'), 'disabled_job_does_not_claim_a_next_execution');
    await page.locator('.schedule-stop').focus();
    await (await page.waitForResponse(response => response.url().includes('/api/messages?'))).finished();
    await page.evaluate(() => new Promise(requestAnimationFrame));
    check(await page.locator('.schedule-stop').evaluate(button => button === document.activeElement), 'unchanged_schedule_poll_preserves_keyboard_focus');
    return { checks, allApis: 'synthetic fixtures', nativeReadOrSend: false };
  } finally {
    if (releaseB) { releaseB(); await completedB; }
    await page.unroute('**/api/**', handler);
    await page.reload();
  }
}
