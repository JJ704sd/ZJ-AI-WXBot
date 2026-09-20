# 编号文字真机对照：2/2 新增可见

## 结论

2026-09-20（Asia/Shanghai），发送后的完整实时 UIA＋屏幕区域＋RapidOCR 调用成功，状态 `REVIEW_REQUIRED`，退出码 0。与发送前基线对照，操作人安排的两条编号文字均从未出现变为完整可见。

| 测试文字 | 基线编号次数 | 发送后编号次数 | 完整文字匹配次数 | 新增可见 |
| --- | ---: | ---: | ---: | --- |
| UIA-READ-001 测试消息一 | 0 | 1 | 1 | 是 |
| UIA-READ-002 测试消息二 | 0 | 1 | 1 | 是 |

编号使用字面匹配；完整行仅规范化汉字旁空白，不做错字纠正、模糊匹配或跨行拼接。对照结果 `expected_strings_newly_visible=true`。

**通过范围：本次受控编号文字新增可见性。** 这不是连续无损读取、消息身份、真实 @ 或自动回复验收。

## 实际过程与限制

1. 操作人先确认准备好，尚未发送。建立当前目标群真实窗口截图，截图尺寸 824×538，并随后进行本地 OCR，两个编号均不存在。基线 JSON 明确为 `capture_kind=offline_image`，不伪装成一次完整实时调用。
2. 提示基线完成后，操作人确认“已发送”。助手没有发送消息。
3. 窗口在测试过程中移动、最小化及调整尺寸，造成多次前置失败；这些失败没有记为成功读取。
4. 发送后重新取得 824×622 的真实画面，人工可见两条编号消息；重新标定消息区后，完整实时调用输出 `capture_kind=live_window`、7 行可见文字。
5. UIA 仍为 `semantic_unavailable`、2 节点。标题仍有 `AI/Al` 差异，`target_label_match=false`。账号、群内部身份及发送者内部键仍未确认。
6. 前后窗口尺寸和视口不一致，不能作为连续视口／去重稳定性证据。本轮未测滚动、重复消息、断线恢复、漏读率或真实 @。截图上的显示姓名只作为文字，不绑定消息来源身份。
7. 成功调用耗时约 6.2 秒，是本次 CLI 执行时间，不是消息从发送到被读取的端到端延迟。

## 本轮修复

`screen_region` 从桌面 DC 复制实际可见像素。键盘焦点不决定这些像素是否有效，因此移除该模式的无条件前台要求，改为每次实际检查可见、非最小化、未被上层应用遮挡、窗口归属／矩形／DPI 一致。原 `window` 模式仍要求前台。

现有工具光标层的精确例外保持不变，不新增通用“忽略遮挡”。worker 继承实际采集方式，避免父进程允许可见后台、子进程却强制前台。错误报告补充变化字段名，减少重复猜测。

新增 `wechat_agent_poc.numbered_read_check`，只生成文字对照报告。即使匹配通过，`new_messages_verified`、`native_mentions_verified`、`account_verified`、`group_verified`、`send_enabled` 均为 false，不写 Agent 队列。

## 证据

原始材料在 Git 忽略目录 `poc/.local/hybrid-numbered-20260920/`：

| 文件 | SHA-256 |
| --- | --- |
| calibration.png | 公开版不记录哈希 |
| baseline-image-ocr.json | 公开版不记录哈希 |
| after-frame.png | 公开版不记录哈希 |
| after-live.json | 公开版不记录哈希 |
| comparison.json | 公开版不记录哈希 |

在 `poc/` 运行对照命令（输出文件须为新文件）：

```powershell
.\.venv\Scripts\python.exe -X utf8 -m wechat_agent_poc.numbered_read_check --before .local/hybrid-numbered-20260920/baseline-image-ocr.json --after .local/hybrid-numbered-20260920/after-live.json --expect 'UIA-READ-001 测试消息一' --expect 'UIA-READ-002 测试消息二' --output .local/hybrid-numbered-20260920/comparison.json
```

本轮相关测试 **41 passed，0.21 秒，退出码 0**；新增 4 个必要对照案例，覆盖已有编号、重复出现和错误正文不冒充新增完整匹配。未重复全量回归。

没有助手发送、数据库取钥、进程内存修改或 M3 调用；原始截图与快照未提交。

## 下一门槛

优先固定窗口及视口完成有限次数的重复采集，评估 OCR 抖动与候选重复；再独立设计目标账号／群确认和真实 @ 的证据。两条编号可读不能直接打开自动回复或主动询问。
