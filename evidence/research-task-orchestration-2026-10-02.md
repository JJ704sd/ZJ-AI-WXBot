# 会话任务编排层：一手资料与实现边界

核验日期：2026-10-02（北京时间）。本地产品基线：`626b123226f1c974b48a6dceaa1373fe81b724c4`。本轮只阅读官方／原作者公开文档并提出设计映射，没有安装、部署或运行 LangGraph、Agent Server、Temporal，没有调用模型、抓取真实会话或发送消息。

用户提供的分享正文是本次需求与设计方向输入。正文提及的框架行为、性能或能力仍需外部证据核验；不能因正文包含某个名称就当作已核实事实。本文件围绕“独立会话任务编排层”核验运行恢复、并发输入、持久等待与副作用边界。以下来源为访问时动态文档，没有宣称与某个已安装版本或固定 upstream commit 一致。

## 1. 核心判断

需要区分四类身份：原始消息 `event_id`、业务事项／任务 `task_id`、一次执行 `run_id`、发送意图 `send_intent_id`。群标识／框架 thread ID 都不能自动替代业务任务标识；同群可有多个事项，同一事项也可因为补充信息产生多次 run。

建议编排层先将新增消息归属事项、更新状态与输入版本，再判断是否已经具备启动条件；仅在需要业务推理时启动 Agent。选择 LangGraph 或 Temporal 是编排实现选择，不替代“何时信息足够、是否应接管、哪些结果仍有效”的业务契约。

上述属于本项目设计推论。下面逐项列出支持机制及不能外推的边界。

## 2. LangGraph：checkpoint 与 interrupt 的准确含义

### 已核验事实

- Checkpointer 保存 thread 范围的图状态，Store 保存跨 thread 的应用数据；二者职责不同。`MemorySaver`／`InMemorySaver` 只在 RAM 中，进程重启会丢失，生产恢复需持久 checkpointer。[Persistence](https://docs.langchain.com/oss/python/langgraph/persistence)
- `interrupt()` 需要 checkpointer、稳定 `thread_id` 与可序列化载荷；使用相同 thread ID 和 `Command(resume=...)` 恢复。恢复时从调用 interrupt 的**节点开头**重跑，interrupt 之前的代码会再次执行。[Interrupts](https://docs.langchain.com/oss/python/langgraph/interrupts)

### 对本项目的适用性（设计推论）

适合在“缺业务字段／等待人工／等待指定补充”时保存任务状态并恢复。应显式保存等待对象、待补字段、原消息引用、任务版本和截止时间，不能靠挂起的 Python 调用栈或全群长上下文作为唯一状态。

不要在 interrupt 之前执行不可重复的发送、创建无幂等键的工单或重复计费动作。建议节点拆为“计算／准备 → 等待 → 版本校验 → 提交发送意图”；即使发送位于 interrupt 之后，也仍需外部发送账本，因为其他重试或提交响应丢失并未消失。checkpoint 不是微信副作用事务。

业务新消息也不总是 approval resume：先验证其是否确实回答了相应 pending request，再给指定任务／interrupt 恢复值。无关消息不能直接恢复任务，旧审批不能批准新正文或新目标。

## 3. Agent Server Double Texting：不可写成 OSS 自带

[Double Texting 官方文档](https://docs.langchain.com/langsmith/double-texting) 明确：这是 LangSmith Deployment／Agent Server 的运行并发功能，**不属于 LangGraph OSS framework 的开箱能力**。当前文档默认策略是 enqueue。

| server 策略 | 文档语义 | 本项目映射建议 |
| --- | --- | --- |
| `enqueue` | 当前 run 完成后串行执行新请求 | 独立新任务可排队；但相同事项的碎片应先聚合，否则每条碎片都会产生不必要 run |
| `reject` | 已有 run 时拒绝新 run | 拒绝运行不应丢弃原始会话事件；保留输入并反馈调度状态 |
| `interrupt` | 停当前执行，保留已有进度，再处理新输入 | 适合同事项重要更正；需处理未完成工具调用和失效草稿 |
| `rollback` | 停当前执行，回退该 run 输入与图进度，再处理新输入 | 只用于计算状态可重建的路径；不能视为消息撤回或外部系统补偿 |

[Rollback Concurrent](https://docs.langchain.com/langsmith/rollback-concurrent) 还说明旧 run 会从服务数据库删除且无法重启。因此本项目独立事件账本与审计引用应保留，不能把 server run history 作为唯一业务记录。

这里的 Double Texting `interrupt`（新 run 竞争策略）与图节点 `interrupt()`（等待外部输入）是两种概念。把“选 interrupt 策略”当成自动完成业务等待／恢复状态机会漏掉关联、版本、权限与副作用检查。

## 4. Temporal：长期等待与任务命令的准确边界

| 能力 | 一手资料核验 | 对本项目的适用性／限制 |
| --- | --- | --- |
| Signal / Query / Update | Signal 是异步写；Query 为不阻塞的状态读；Update 是可追踪写，可等处理结果。[消息机制](https://docs.temporal.io/encyclopedia/workflow-message-passing) | 原始消息转任务事件可用 Signal；人工接管／状态变更需确认结果时可用 Update。Signal 提交不能当作业务处理已完成 |
| Update 状态 | 可等 Accepted 或 Completed，二者不同；Update-With-Start 还有独立兼容条件且文档明确并非原子。[发送消息](https://docs.temporal.io/sending-messages) | UI 区分已受理与已应用；初始化和更新仍需失败恢复，不能把一个 API 名称当作业务事务 |
| Handler 并发／去重 | 阻塞 handler 可与主流程及其他 handler 交错；Signal 业务去重需自带 key，Update ID 服务去重限单 Workflow run。[处理消息](https://docs.temporal.io/handling-messages) | 建议 handler 先入任务队列，主循环串行更新；跨 Continue-As-New 保留业务去重和版本。单线程不免除竞态 |
| 持久 Timer | Timer 在 Worker／服务中断后可恢复；到期执行受调度延迟影响，不应依赖亚秒精度。[Timers and Start Delays](https://docs.temporal.io/workflow-execution/timers-delays) | 用于等待回复、安静窗、截止／租约；重启恢复时复查任务版本与当前 deadline，不把到期等同准点完成 |
| 协作取消 | cancel 记录取消请求，流程代码可清理；terminate 不给流程清理机会。普通 Activity 的取消依赖心跳，Local Activity 有例外。[Python cancellation](https://docs.temporal.io/develop/python/workflows/cancellation) | 标记取消或 supersede 后先使旧结果失效；不能因为发出了 cancel 就认定外部模型调用已停止、费用已停止或微信提交已撤销 |

Temporal 可承载跨小时／天的等待、恢复和人工控制；并不负责判断中文消息是否属于同一事项，也不能证明采集完整性。引入前需比较服务运维、状态版本升级、工作流历史增长与团队熟悉度。首期可先用本地持久任务表完成同样业务契约，再由真实长等待与恢复需求决定是否升级编排运行时；无需在首期同时叠加多个编排平台。

## 5. EIP 和 outbox 对独立任务层的启发

[EIP Aggregator](https://www.enterpriseintegrationpatterns.com/patterns/messaging/Aggregator.html) 把聚合拆成关联规则、完成条件和聚合算法，并列出等待全部、超时、外部事件等完成方式。对本项目的设计映射：按 task/object 关联碎片，区分“安静一段时间”与“必需字段已齐”。安静窗结束仍缺字段时应继续等待、发起已批准澄清或转人工，而非直接判定 ready。

[EIP Process Manager](https://www.enterpriseintegrationpatterns.com/patterns/messaging/ProcessManager.html) 用中心状态控制后续步骤，也提醒中心控制可能成为瓶颈与过度设计。对本项目的设计映射：一个逻辑仲裁中心可按 `(account,conversation,task)` 分区；它管理状态和调度，不要求所有群同步通过同一个模型调用或单个全局锁。

[AWS Transactional Outbox](https://docs.aws.amazon.com/prescriptive-guidance/latest/cloud-design-patterns/transactional-outbox.html) 将业务表变更和待发布事件写入同一事务，再由发布端转发；文档仍要求处理重复和顺序。对本项目的设计映射：任务版本变更与 `SendIntent` 可同事务落盘，然后独立 Sender 领取。outbox 解决本地双写一致性，不保证微信 exactly-once；网络结果未知仍是 unknown，不能靠消息队列去重宣称对端只收到一次。

## 6. 最小对象与约束建议（尚未实现）

```text
Task:
  task_id, account_id, conversation_id, object_refs, task_type,
  evidence_event_ids, task_version, policy_version,
  required_fields, missing_fields, readiness, status,
  owner, handoff_lease, quiet_until, deadline

PendingReply:
  pending_id, task_id, expected_actor_ids, required_fields,
  prompt_event_or_send_intent_id, created_at, expires_at, status

Run:
  run_id, task_id, input_version, generation, status,
  started_at, cancel_requested_at, result_evidence_refs

SendIntent:
  intent_id, action_key, task_id, task_version, run_generation,
  target_id, text_hash, policy_version, status, attempt_id
```

建议不变量：

1. 接收事件先持久记录，运行竞争策略只影响调度，不能丢入站消息。
2. readiness 由必需信息、授权、来源健康、人工归属和等待条件共同决定；高置信度不替代这些门槛。
3. 每个任务最多一个有当前发送资格的 run。更正、人工接管、暂停或相关资料失效时递增 task_version／generation，使已在途旧结果无法提交。
4. 取消、超时和新消息竞争时，以持久状态与版本比较裁决。即使旧模型最终仍返回，也只能留作过期结果证据。
5. timer 事件包含期望版本与 deadline 标识；续期后到达的旧 timer 无效。人工接管解除、过期与恢复均有明确事件，不隐式抢回任务。
6. pending reply 依据引用链、目标对象、参与人和已知槽位关联；多项候选时不凭“最近一条待办”强制归属。
7. 本地状态更新和 outbox 行可事务提交；原生发送与对端回执各有独立状态。任务完成必须依据业务结果，不能直接由模型 run completed 推出。

## 7. 编排验收案例（设计，未执行）

| 案例 | 必须观察的行为 |
| --- | --- |
| 用户连发“查这个”“B 型”“今天这份” | 一个事项逐次补槽；达到 readiness 后启动一次必要 run，碎片全部可追溯 |
| 安静窗结束但缺对象 | 不因沉默直接 ready；进入明确等待／澄清／人工状态 |
| 同群两个品类交错回复 | 分到两个任务；无依据的“这个”维持歧义，不串任务 |
| 模型运行中收到“先别发，型号改了” | 新版本生效，旧 run 结果不可发送；取消请求是否真正完成另记 |
| interrupt 前副作用发生后重启／resume | 原副作用不重复，事件与发送账本保持；不能只检查最终文本 |
| Double Texting reject | 原始新消息仍在事件账本，调度拒绝可见；不静默漏掉业务更新 |
| rollback 前已提交发送 | 已有提交／unknown 证据仍保留；不宣称图回退等于撤回消息 |
| deadline 与最后补充同刻到达 | 明确顺序和版本，至多一个当前有效决策；不出现完成与超时同时发言 |
| 重启后旧 timer、重复 Signal、Continue-As-New 重投 | 依据业务 key 去重；仅当前 deadline／generation 有效 |
| 人工接管后模型晚返回 | 结果标过期，无新发送；恢复必须依据明确定义的状态变化 |
| outbox commit 后、发送提交后分别崩溃 | 前者可恢复领取；后者保持 unknown 并核查，不盲目重发 |

这些场景只定义应验证的性质。本轮没有框架实测、压力数据或中文任务归属准确率，不据公开功能列表给生产可用结论。
