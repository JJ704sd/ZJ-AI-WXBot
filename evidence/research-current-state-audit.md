# 调研报告本地现状续审

续审日期：2026-10-04（北京时间）。固定代码基线更新为 `bdafc8177a8600d110af2c0428af07be58f6450f`，已包含完整批量创建。早期 `edeb7a4`／`bfb073e` 的实验与复核保留在结构化证据历史项；下文按固定提交判断，不等于正在运行的服务已加载代码。

本次核对新增批量创建源码、业务需求、已有测试定义及提交内的执行记录；官方框架资料沿用当日上一轮复核。没有读取私有运行数据、真实聊天，未运行产品测试、模型、Hook 或消息发送。修改范围为报告、索引与研究证据；其他代码修改保留。

## 1. 当前可复用能力

下表文件相对 `WeBridge/web_mvp`，函数和行号指向固定基线。可用 `git show bdafc817:<路径>` 独立核对，避免套用后续工作树的行号。

| 能力 | 固定提交依据 | 尚不能推出的结论 |
| --- | --- | --- |
| 入站分页 | `inbound_messages.py:scan_inbound`，`windows_auto_reply.py:tick` | 120 秒自动触发窗口及事件去重不是全部消息的长期任务收件箱 |
| 历史查询／审计 | `message_history.py`、`execution_history.py`、自动回复触发快照 | 查询游标不是消费检查点，原始引用／完整提及仍缺字段 |
| 人工待办 | `human_handoffs.py:enqueue/action/revoke`；`server.py` 待办 API | 单条真 @ 待办、行版本 CAS 不是多人任务关联或所有出口暂停 |
| 默认负责人 | `human_handoffs.py` 路由保存与创建事务 | 标签是本机责任标识，不能按标签猜测通知收件人；默认修改只影响新任务 |
| 负责人通知 | `handoff_notifications.py:configure/_claim`；`windows_auto_reply.py:260–269` | 待办／通知意图同库入队；最终核对配置、负责人、任务及范围，不证明负责人接收端已收到 |
| 发送准入与回调 | `backend.py:send_lock`；`windows_hook_sender.py:425–439,472–480` | 四来源共享准入／Hook 文件锁；通知的 `before_submit` 只是部分业务仲裁，全任务版本／输入水位仍需补齐 |
| 执行日与窗口 | `windows_scheduler.py:_schedule_spec/_due_runs/tick` | once／daily／weekly，1–1439 分钟窗口；冻结配置和提交截止不是原生 @ 或实际投递证明 |
| 范围暂停 | `windows_scheduler.py:pause_scope` | 账号／会话定时暂停不覆盖自动回复与通知，正在处理的一条仍可能提交 |
| 模板与覆盖 | `schedule_templates.py:preview/profile/render_saved` | 纯文本替换；任务保存正文快照，日期不逐期重算，文字 @ 不是真实提及 |
| 批量创建 | `schedule_batches.py:preview/create/_receipt`；`server.py` batch 路由、`runtime_support.py` 能力 | 已有整批原子配置、摘要重验和持久回执；不是原子发送或全局业务每日一次 |

[入站](../WeBridge/execution/workbench-inbound-2026-10-02.md)、[历史查询](../WeBridge/execution/workbench-history-2026-10-02.md)、[人工待办](../WeBridge/execution/workbench-handoffs-2026-10-03.md)、[负责人配置](../WeBridge/execution/workbench-handoff-routing-2026-10-03.md)、[通知](../WeBridge/execution/workbench-handoff-notifications-2026-10-03.md)、[执行日](../WeBridge/execution/workbench-weekly-schedules-2026-10-03.md)、[窗口](../WeBridge/execution/workbench-schedule-windows-2026-10-03.md)、[暂停](../WeBridge/execution/workbench-schedule-pause-2026-10-03.md)、[模板](../WeBridge/execution/workbench-schedule-templates-2026-10-03.md)、[批量创建](../WeBridge/execution/workbench-schedule-batches-2026-10-04.md) 均保留各轮实际验证范围。

## 2. 运行与发送边界

数据库模式启动 poll loop 和独立负责人通知线程，不启动旧 Live／Demo 的发送、调度循环；`read_only=False` 不能作为启用 Agent 的开关。

手工、固定回复、定时、通知共享进程内准入和 Hook 文件锁；全局执行历史仍排除 `handoff_` 请求，只展示原三类，通知结果在待办详情。通知的最后授权核对已经有任务状态检查，但手工、固定回复和定时并没有统一读取业务任务的需求版本或人工接管状态。

通知默认有效期 10 分钟，版本变化或重启等会取消未开始提交的队列，unknown 不自动重试。持久领取之后的取消不承诺撤回在途请求；通知结果没有接收端确认。通知 I/O 已移出副本／订阅／Engine 锁，不能外推为全部发送路径也完成此改造。

当前模板、固定回复、定时和固定通知没有 LLM 调用，模型 token 为零。报告 A／B／C 比较的是未来同等语义能力的实现预算，不是相对当前模板的实测节省。

## 3. 已有验证记录

以下计数属于对应开发轮次，本次未复跑，也不将其当作当前整个工作树结果：

| 开发轮次 | 记录中的 Python 回归 | 验证边界 |
| --- | ---: | --- |
| 初始人工待办 | 373 项通过 | 临时 SQLite、替身与模拟业务 API |
| 每周／范围暂停／窗口 | 分别 389／399／424 项通过 | 合成时钟、锁竞争及截止反例 |
| 模板 | 441 项通过 | 正文替换、版本及界面输入保护 |
| 负责人配置 | 456 项通过 | 同名群按 ID 分派，未分派与旧任务保护 |
| 通知 | 493 项通过，最后提示修改后另有 18 项专项复验 | 模拟 Hook 和浏览器 API，未向真实负责人发送 |
| 批量创建 | 当轮 516 项 Python 回归通过，161 项模拟 API 浏览器检查 | 包含 300 个合成会话配置及写入故障；本次未复跑，不证明真实规模发送 |

真实混合群完整入站、原生 @、通知收件端、批准资料下语义质量和约 300 群容量仍按各自范围验收。上述产品缺口不阻碍本次报告与来源更新的交付。

## 4. 本次报告修改与后续重点

主报告本轮更新批量创建实况，删除过时的“只有内部预览”。保留九模块、四类输入和 M1–M5 顺序，新增 [批量事务与业务边界](research-batch-boundaries-2026-10-04.md)：本机创建核对与发送 unknown 分开、跨批次执行日防重、累计容量和共同窗口验收。已有待办、通知及日历／模板结论保持。

当日上一轮 [框架复核](research-framework-refresh-2026-10-04.md) 已修正 OpenClaw steering 首个／并行工具边界及 Hermes canonical Bot Chat 的 `/new` 语义；Jev 标价与中文限制仍成立，补入候选顺序置换评测。

本次检查包含本地链接与 Markdown 结构、JSON 及预算／概率算术、代码基线、历史报告保留、独立只读审查和精确发布范围。结果写入 [结构化证据](wecom-hook-agent-research-2026-10-02.json) 的 `document_validation`。Git 发布后另通过远端引用与本次提交文件清单核对，避免把推送成功等同于运行服务已更新。
