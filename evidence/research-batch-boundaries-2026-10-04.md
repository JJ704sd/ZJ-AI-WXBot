# 批量定时创建的事务与业务边界

固定基线：`bdafc8177a8600d110af2c0428af07be58f6450f`，日期：2026-10-04（北京时间）。本次只读审查源码、测试定义及已提交执行记录，未复跑产品测试、启动服务、探测真实 Hook 或发送消息。旧报告基于 `bfb073e` 的“只有内部预览”已被本提交覆盖。

## 1. 已实现的配置契约

| 环节 | 固定提交中的依据 | 已确认边界 |
| --- | --- | --- |
| 入口与目标 | [server.py](../WeBridge/web_mvp/server.py) 的 batch 路由、[runtime_support.py](../WeBridge/web_mvp/runtime_support.py) 能力声明、[ScheduleBatches._request](../WeBridge/web_mvp/schedule_batches.py) | Windows database 模式；每批 1–300 个独立会话 ID，群及私聊均可入选 |
| 预览与摘要 | `ScheduleBatches._preview/_confirmed_preview` | 绑定来源、账号、模板版本、目标 ID／名称、正文、日历和首期时间；确认重新计算，失效则整批拒绝 |
| Hook 探测 | `ScheduleBatches.create` 的锁外探测阶段 | 每个首次尝试一次状态探测，无发送 POST；同请求并发可分别探测，不是批次永远只探测一次 |
| 原子创建 | `create` 的 `BEGIN IMMEDIATE` | 任务和批次回执在同一 SQLite 事务保存；写入失败或首期时间已过整批回滚，不涉及真实发送事务 |
| 回执与重放 | `_receipt/_result`、`(account,requestId)` 唯一键 | 同 ID 同规格返回原批次当前状态；不同规格冲突，重放不新建、不恢复暂停／取消任务 |
| 前端不确定结果 | [schedule_batch_ui.js](../WeBridge/web_mvp/static/schedule_batch_ui.js) 的 `scheduleBatchAttempts` 内存 Map | 同页面保留原请求并提供手工核对；刷新／关闭后的自动恢复未实现，持久回执在服务端 |
| 容量与重复 | `_preview` | 每账号累计最多 500 条记录，包括结束／取消；active／paused 的相同目标、全文和日历阻止整批，不同规格可并存 |

已成功创建的原请求可以在模板删除、Hook 离线或首期已过后核对，这是读取已保存回执及当前任务状态，不能解释为重新执行一次发送。批量任务沿用既有重启暂停、逐条明确恢复和逐期 unknown 核对。

## 2. 三类身份与恢复方式

| 对象 | 当前或建议标识 | 它解决的问题 |
| --- | --- | --- |
| 创建批次 | 已有 `requestId`、`batchId`、`previewDigest` | 用户确认了哪份冻结配置；创建响应丢失后核对本机保存结果 |
| 某次计划运行 | 已有任务 ID 与计划时刻派生的运行 ID，关联 Hook `draftId` | 同一计划期不能重复提交；unknown 保留原草稿核对，不换 key 重发 |
| 每日索价业务意图 | 建议 `source_id + group_id + inquiry_kind + planned_business_date` | 多个批次或不同正文仍可能代表同一次询价，需要跨计划业务防重 |

第三行是首期“每群每配置执行日一次索价”的建议契约，尚未实现。模板、正文或策略版本应存为该意图的元数据，不因修改版本就生成第二个同日询价意图。其他独立通知仍按自己的业务类型和批准范围区分，不能把所有同群消息强制合成一个任务。

后续 M5 建立 `business_intent → schedule_occurrence → draftId` 关联；`previewDigest` 证明配置未变，不代表业务输入水位、任务需求版本或外部送达。批量回执、逐期执行、本机观察和收件端确认分别统计。

## 3. 需要独立验收的三个反例

1. 同群同日两个批次正文不同或时刻不同：现有规格去重允许并存。业务层需识别它们是独立动作，还是同一次索价冲突；不能仅凭不同请求 ID 放行两次。
2. 创建成功后响应丢失，部分任务已暂停或取消：原请求核对返回当前状态，不能恢复这些任务；某一期发送结果 unknown 与本机创建回执丢失采用不同恢复规则。
3. 300 个任务共同到期且 Hook 较慢：现有调度串行推进并与入站轮询共享执行链；创建成功数量不能代替窗口内提交数量。按配置执行日列应执行、未到期、暂停、missed、unknown 及实际证据，另记入站滞后、锁占用和竞争延迟。

每账号 500 条累计记录也需进入运行规划：持久 daily／weekly 任务应逐期推进，不能每天重复创建同一套任务；结束／取消记录如何归档或释放容量尚无本次新增能力。不能通过删除审计或换请求 ID 绕过核对。

## 4. 证据等级与实施顺序

[批量执行记录](../WeBridge/execution/workbench-schedule-batches-2026-10-04.md) 记载当轮 516 项 Python 回归通过、13 组 Node 检查及 161 项全部使用模拟业务 API 的 Chrome 检查。本次核对了 [300 会话及故障测试定义](../WeBridge/web_mvp/test_schedule_batch_acceptance.py)、[HTTP 测试](../WeBridge/web_mvp/test_schedule_batch_http.py)、[重启／重放测试](../WeBridge/web_mvp/test_schedule_batches.py)，没有重跑，未将测试定义当作本次通过成绩。

300 会话试验验证的是配置和本机事务，运输替身阻止发送，不证明真实 300 群在共同窗口中完成执行，也不证明原生 @ 或收件端已收到。模板、批量配置和定时正文没有新增 LLM 调用；收益是减少配置工作和错误，模型 token 节省仍需 M4 同集 usage 评测。

M1–M5 顺序保持：批量创建完善现有配置，不补长期事件收件箱、多人任务归属、等待和模型判断。M3 复用预览／确认视图，M5 复用回执与幂等模式并补业务意图键及逐期仲裁。
