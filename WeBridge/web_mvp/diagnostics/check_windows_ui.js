// Run with playwright-cli run-code --filename web_mvp/diagnostics/check_windows_ui.js.
// Every Windows endpoint is intercepted. No native window or chat text is read.
async (page) => {
  const marker = 'SYNTHETIC-WINDOW-TEXT-FOR-PRIVACY-REGRESSION';
  const checks = [];
  const check = (condition, name) => {
    if (!condition) throw Error(name);
    checks.push(name);
  };
  const windows = [
    { hwnd: 101, pid: 201, title: 'Synthetic window A', visible: true, minimized: false },
    { hwnd: 102, pid: 202, title: 'Synthetic window B', visible: true, minimized: false },
  ];
  let delayPreview = false;
  let changedWindow = false;
  let networkFailure = false;
  let noWindows = false;
  const nativeRequests = [];
  let releasePreview;
  let signalPreview;
  let previewStarted = new Promise(resolve => { signalPreview = resolve; });
  const handler = async (route) => {
    nativeRequests.push({ url: route.request().url(), body: route.request().postDataJSON() });
    if (networkFailure && !route.request().url().endsWith('/status')) {
      await route.fulfill({ status: 503, json: { error: '合成测试：读取服务暂时不可用。' } });
      return;
    }
    if (delayPreview && !route.request().url().endsWith('/status')) {
      signalPreview();
      await new Promise(resolve => { releasePreview = resolve; });
    }
    const value = route.request().url().endsWith('/status')
      ? { supported: true, available: !noWindows, processCount: noWindows ? 0 : 2, windows: noWindows ? [] : windows }
      : changedWindow
        ? { ok: false, issueCode: 'window_changed', issue: '合成测试：窗口已变化，请重新检测。', texts: [], canSend: false, identityVerified: false }
        : { source: route.request().url().endsWith('/ocr-preview') ? 'windows-ocr' : 'windows-uia', title: windows[0].title, capturedAt: '2026-09-26T06:30:00Z', truncated: true, texts: [{ text: marker, controlType: 'Text' }], canSend: false, identityVerified: false };
    await route.fulfill({ json: value });
  };
  await page.route('**/api/windows/**', handler);
  try {
    await page.reload();
    await page.getByRole('button', { name: '环境诊断', exact: true }).click();
    await page.locator('.environment-check').first().waitFor();
    check(nativeRequests.length === 0, 'opening_diagnostics_does_not_read_or_detect_native_windows');
    await page.locator('#windows-detect').click();
    await page.locator('#windows-preview').waitFor({ state: 'visible' });
    await page.waitForFunction(() => !document.getElementById('windows-preview').disabled);
    await page.locator('#windows-preview').click();
    await page.getByText(marker, { exact: true }).waitFor();
    await page.locator('#windows-window').selectOption('1');
    check(!(await page.locator('#windows-preview-result').textContent()).includes(marker), 'changing_window_removes_previous_preview_text');
    await page.locator('#windows-preview').click();
    await page.getByText(marker, { exact: true }).waitFor();
    check(nativeRequests.at(-1).body.hwnd === 102 && nativeRequests.at(-1).body.pid === 202, 'preview_uses_explicitly_selected_window');
    await page.getByRole('button', { name: '群聊工作台', exact: true }).click();
    check(!(await page.locator('#windows-preview-result').textContent()).includes(marker), 'leaving_diagnostics_removes_preview_text_from_dom');
    await page.getByRole('button', { name: '环境诊断', exact: true }).click();
    await page.locator('#windows-detect').click();
    await page.waitForFunction(() => !document.getElementById('windows-preview').disabled);
    delayPreview = true;
    await page.locator('#windows-preview').click();
    await previewStarted;
    await page.getByRole('button', { name: '群聊工作台', exact: true }).click();
    releasePreview();
    await page.waitForFunction(() => !document.getElementById('windows-detect').disabled);
    check(!(await page.locator('#windows-preview-result').textContent()).includes(marker), 'late_preview_response_cannot_restore_cleared_text');
    delayPreview = false;
    changedWindow = true;
    await page.getByRole('button', { name: '环境诊断', exact: true }).click();
    await page.locator('#windows-detect').click();
    await page.waitForFunction(() => !document.getElementById('windows-preview').disabled);
    await page.locator('#windows-preview').click();
    await page.getByText('合成测试：窗口已变化，请重新检测。', { exact: true }).waitFor();
    check(await page.locator('#windows-preview').isDisabled(), 'changed_window_requires_new_detection_before_reading');
    changedWindow = false;
    await page.locator('#windows-detect').click();
    await page.waitForFunction(() => !document.getElementById('windows-preview').disabled);
    await page.locator('#windows-preview').click();
    await page.getByText(marker, { exact: true }).waitFor();
    check(await page.getByRole('button', { name: '清除预览', exact: true }).count() === 1, 'explicit_clear_preview_action_exists');
    await page.getByRole('button', { name: '清除预览', exact: true }).click();
    check(!(await page.locator('#windows-preview-result').textContent()).includes(marker), 'explicit_clear_removes_preview_text');
    await page.locator('#windows-preview').click();
    await page.getByText(marker, { exact: true }).waitFor();
    // Visibility is a browser boundary. Simulate its event without reading native UI.
    await page.evaluate(() => {
      Object.defineProperty(document, 'hidden', { configurable: true, get: () => true });
      document.dispatchEvent(new Event('visibilitychange'));
      delete document.hidden;
    });
    check(!(await page.locator('#windows-preview-result').textContent()).includes(marker), 'hidden_page_removes_preview_text');
    check(await page.locator('#windows-preview').isDisabled(), 'returning_to_page_requires_fresh_window_detection');
    check(await page.getByRole('button', { name: '本地屏幕识别', exact: true }).count() === 1, 'local_ocr_action_exists');
    check(await page.locator('#windows-ocr-preview').isDisabled(), 'ocr_requires_explicit_window_detection');
    await page.locator('#windows-detect').click();
    await page.waitForFunction(() => !document.getElementById('windows-ocr-preview').disabled);
    await page.locator('#windows-ocr-preview').click();
    await page.getByText(marker, { exact: true }).waitFor();
    const result = await page.locator('#windows-preview-result').innerText();
    check(result.includes('windows-ocr') && result.includes('可能误识别'), 'ocr_result_identifies_source_and_recognition_limits');
    check(result.includes('采集于') && result.includes('已截断'), 'ocr_result_exposes_capture_time_and_truncation');
    delayPreview = true;
    previewStarted = new Promise(resolve => { signalPreview = resolve; });
    await page.locator('#windows-ocr-preview').click();
    await previewStarted;
    check(await page.locator('#windows-preview').isDisabled() && await page.locator('#windows-ocr-preview').isDisabled(), 'native_reading_methods_are_mutually_exclusive');
    check(await page.locator('#windows-window').isDisabled(), 'window_selection_cannot_change_during_reading');
    await page.getByRole('button', { name: '清除预览', exact: true }).click();
    releasePreview();
    await page.waitForFunction(() => !document.getElementById('windows-detect').disabled);
    check(!(await page.locator('#windows-preview-result').textContent()).includes(marker), 'clearing_pending_ocr_discards_its_late_result');
    delayPreview = false;
    networkFailure = true;
    await page.locator('#windows-ocr-preview').click();
    await page.getByText('合成测试：读取服务暂时不可用。', { exact: true }).waitFor();
    check(await page.locator('#windows-preview').isDisabled() && await page.locator('#windows-ocr-preview').isDisabled(), 'failed_read_requires_fresh_detection');
    networkFailure = false;
    noWindows = true;
    await page.locator('#windows-detect').click();
    await page.waitForFunction(() => !document.getElementById('windows-detect').disabled);
    check(await page.locator('#windows-preview').isDisabled() && await page.locator('#windows-ocr-preview').isDisabled(), 'no_window_disables_both_reading_methods');
    check(await page.locator('#windows-window').isHidden(), 'failed_detection_removes_previous_window_choices');
    return { checks, windowsApi: 'synthetic fixtures only', nativePreviewInvoked: false };
  } finally {
    if (releasePreview) releasePreview();
    await page.unroute('**/api/windows/**', handler);
    await page.reload();
  }
}
