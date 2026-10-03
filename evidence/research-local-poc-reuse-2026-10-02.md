# 本地 PoC 与 WeBridge 可复用能力复核

复核日期：2026-10-02（北京时间）。范围为仓库源码、现有测试及已脱敏交付文档；没有读取运行配置、密钥或真实聊天，没有启动服务、调用模型、连接客户端或发送消息。本文件提供静态证据和建议，历史测试计数不作为本轮重跑结果。

## 结论

本项目已有 Windows 工作台、独立 PoC 模型入口、API 路线的持久状态机及离线反例测试。下一步应把已有接口和保护机制接到可持续消费的事件契约，再补多人任务关联、聚合、就绪判断及任务级接管。不能表述为“全仓没有模型／任务账本”，也不能把 API 离线实现直接称为 Windows 生产 Agent。

## 资产、边界与移植方式

| 本地资产 | 已存在的能力及源码位置 | 可复用方式与当前限制 |
|---|---|---|
| API 事件契约 | `poc/wechat_agent_poc/api_channel.py:33-53` 的 `ApiMessageV1` 含账号、会话、发送人、来源消息 ID、结构化 @、引用 ID、历史和解析状态；`:126-133` 定义 `Channel` | 可作为接入适配器的字段基线；WeBridge 字段须逐项映射并保留未知态、来源和稳定 ID，不能从显示昵称或正文补身份。现有 `Channel` 同时含入站与出站方法，研究首期可只启用影子消费端 |
| 持久任务与收件箱 | `api_store.py:28-149` 已有 runs、inbox、tasks、sessions、outbox、receipts、audit；session 有 version、slots、context，outbox 有唯一幂等键 | 复用表设计、事务领取和故障语义的测试；新增编排数据仍应独立建库／明确迁移，不能直接打开工作台或旧 PoC 库并假定表兼容 |
| 模型预算 | `api_store.py:434-447` 原子占用总量、主动、被动调用额度 | 现有的是调用次数预算；仍需另补每阶段输入／输出／缓存 token、实际模型版本、失败和重试成本，不能把 call count 称为 token 账本 |
| 轻语义接口 | `agent_policy.py:49-76` 的 `PolicyRequest`／`PolicyDecision`／`Completer`；`:113-144` 输入、上下文上限及结构化决策；`:147-214` 严格输出校验 | 可改造成可替换的 `DecisionProvider` 候选，当前任务类型及槽位仍是旧技术验收语义；需要新业务 schema，而不是照搬 receipt／willingness |
| 已有省上下文措施 | `agent_policy.py:129-144` 将最多 3 组上下文、已有槽位和目标注入；`responder.py:98-131` 限制同群上下文并验证草稿依据 | 为单模型公平基线保留已有压缩／裁剪机制，再量化按任务摘要和按批次唤醒的增量收益；不能用“每条消息全群历史”替代本地实际基线 |
| 非 @ 的待回复续接 | `api_runtime.py:430-440` 按目标成员找已有会话；`:498-578` 判断 related／unrelated／uncertain、更新槽位并限制后续追问 | 已有“正在等某人回复”的离线范式；`api_store.py:604-609` 是 `run_id + sender_key` 的单条会话查找，不支持同一人多个任务或多人共同任务的可靠关联，需要新增 task 候选集合、显式关联及歧义状态 |
| 旧结果失效 | `api_runtime.py:498-522` 记住调用前 session version，结果回来后重新校验；`api_store.py:611-617` 递增版本 | 可复用版本比较思想；仍需把 requirement revision、人工接管和所有出站入口放入统一提交检查，不能以一次旧结果检查替代完整竞态控制 |
| 发送保护 | `api_runtime.py:593-709` 限制运行、发送预算、提交与 unknown；`api_store.py:527-547` 将崩溃窗口 submitting 标为 unknown 并暂停，取消未提交记录 | 可复用“不确定不重试”的语义及反例；其 `SubmitResult` 仅 accepted／not_submitted／unknown（`api_channel.py:109-114`），不能无损表达 Windows 的 `submitted_unconfirmed`／`local_record_observed` 等更细证据，应保留原状态映射而非一律升级为 accepted |
| 人工审批 | `review.py:38-59` 校验草稿全文 hash、binding version 和群；`store.py:207-211` 有暂停恢复及 uncertain 阻断；WeBridge Hook 手工确认见 `windows_hook_sender.py:410-430` | 可复用一次动作审批与暂停；本次所查核心路径没有完整“请求／任务／群三级接管、负责人分派、通知成功、结案恢复”的业务账本。人工审批不等于人工接管闭环 |
| 真模型客户端 | 默认 PoC `responder.py:58-88,202-209` 已有可选 HTTP JSON chat-completions；`general_qa.py:16-55` 为独立 M3 请求入口 | 证明仓库已有真实模型客户端代码；没有证明接入 WeBridge 的固定回复链。两者输入输出与 `Completer` 不同，不能仅改配置就视为已经集成 |
| 当前 Windows 固定回复 | `WeBridge/web_mvp/windows_auto_reply.py:123-176` 结构化 @ 资格、持久领取、同群间隔、固定文本、异常暂停及不重试 | 为不调用模型的模板基线。把 Agent 结果直接塞入固定回复正文，会绕过任务关联、策略版本、草稿失效及人工接管，不是完整接入方案 |
| 当前 Windows 定时 | `windows_scheduler.py:87-121,156` 已有一次／每日任务，`:91` 明确拒绝 mentionIds；文档 `execution/windows-scheduled-send-2026-09-28.md:7-29` 说明持久领取、错过跳过、暂停恢复 | 每日模板发送不需要模型，可复用日历／领取思路；目前 Windows 仅普通文本，不能视为每日真正 @ 联系人索价已完成；后续只有一个调度器拥有同一任务的启动、暂停、补发权 |

### 不可忽略的 API 路线边界

- `api_config.py:17,258-268`：模型仅 mock，`once_after` 可用而 `recurring` 明确拒绝。`api_runtime.py:106-114` 的启动守卫只允许 fake channel + mock model。默认 PoC 的 HTTP model 是另一入口，不能从其存在反推出 API route 已经支持真实模型。
- `api_runtime.py:817-820` 只把结构化且 `mention_keys == (self_key,)` 视为被本人 @；同时 @ 本人和他人被拒绝。这是当前代码策略，需要由业务规则明确后改变，不能宣称所有有效真 @ 均已覆盖。
- `agent_policy.py:216-225` 仍是技术验收槽位及目标；`api_config.py:284-291` 限定 A4 和技术验收模板。不得沿用旧实验配置开放首期业务不需要的持续追问。
- `tasks.task_version`、`sessions.version` 是已有局部版本，不等价于报告所需、跨全部动作的 `requirement_revision`。现有模型锁也不是多人任务调度器。

## 测试资产如何用

| 现有测试位置 | 可作为新编排层保留的不变量 | 不能据此声称 |
|---|---|---|
| `poc/tests/test_api_a1.py:103-257` | 先持久化再 ACK、鉴权／缺字段拒绝、真假 @、重复冲突、历史过滤、模型越权拒绝、unknown 不重试、崩溃恢复 | 真企微字段可用、真实通道投递完成 |
| `test_api_a1.py:270-318` | 两个目标成员的会话上下文隔离、无关内容静默、无 @ 补答可继续已有会话 | 一个成员同时参与多个业务任务，或多人共同补全一个任务已解决 |
| `test_api_a1.py:344-379` | 阻塞模型时另一 worker 收到停止，迟到结果不得发出 | 任意在途工具可撤销，所有发送路径都已经统一仲裁 |
| `test_api_a1.py:382-446` | 并发预算、静默不催促、旧 live 路径与原手工发送保护保持隔离 | 规模性能、真实群长期可靠性 |
| `poc/tests/test_review_sender.py:30-123` | 精确 hash／绑定、过期审批、unknown 不重试和一事件一草稿 | 已有多消息一任务的草稿失效机制；一事件一草稿本身仍需升级 |
| `poc/tests/test_mention.py:18-136` | 只认结构化 @、拒绝文本昵称、引用嵌套 @ 不误触发、源字段解析 | Windows 发送原生 @ 已通过 |
| `WeBridge/web_mvp/test_windows_auto_reply.py`、`test_windows_scheduler.py` | 当前 Windows 规则、时间边界、幂等领取和异常暂停 | 模型语义质量，真实自动回复收件端确认或真实定时投递 |

本复核未运行以上测试。主报告若运行相关离线子集，应单列本轮命令、结果及其合成证据级别；历史“全量 239／257 项通过”不能标成这次复验。

## 当前 Windows 与历史验收应按环境分开

1. `WeBridge/execution/STATUS.md:3-20` 明确下方是 2026-09-21 Mac／Linux 历史环境；其无 UI 真实 @、定时和固定回复收件端提醒成功，不能移植成当前 Windows 的成绩。
2. `WeBridge/README.md:11-13,23-27` 的 Windows 好友／文件传输助手历史成绩，仍是特定版本、账号和范围；“群聊尚未实际发送”是较早说明，不宜覆盖之后 9 月 28 日自动回复记录。
3. `execution/windows-auto-reply-2026-09-28.md:35` 保留较早“启用后尚无新真 @”阶段；后续 `execution/windows-scheduled-send-2026-09-28.md:32` 补充了两次自动回复已核到新本人同文本记录，等级为 `local_record_observed`。应按同日后续记录合并解释为已有本机回读证据、无服务器或收件端确认；不能只摘前一份文件断言从未触发，也不能扩大为混合群最终验收。
4. `poc/evidence/controlled-trigger-2026-09-20.md:9-17` 与 `controlled-send-2026-09-20.md` 的 M3 草稿／受控发送属于独立试验；原生 @ 持续自动触发与最终业务仍未由这些记录证明。

## 结合当前项目的最小实施路径（建议，未实施）

1. **先做接入契约与影子账本。** 保留 Windows 数据库副本读侧和现有 Hook sender，复用 `ApiMessageV1` 的明确身份、@、历史和解析状态字段；新 consumer 使用持久游标、来源版本和覆盖缺口记录，写入独立任务库。不能把 UI 最近消息列表当完整入站流；也不能把旧自动回复的“新且 120 秒内、必须真 @”过滤器直接当语义上下文采集器。
2. **先用确定性规则和 scripted 决策复现业务事件序列。** 复用 API 状态／预算／outbox 反例，新增多成员、同人多任务、碎片聚合、引用、改需求、接管和歧义回放。草稿只落本地；新版业务槽位、作用域权限与持久待办明确后，再用一个可替换 `Completer`／`DecisionProvider` 评估模型。模型比较不得默认沿用旧实验密钥或真实聊天上传许可。
3. **先建立单 Agent 公平基线。** 保留当前规则过滤、有限上下文和版本检查，同样输入集比较“单业务 Agent”与“规则／轻判定 + 单业务 Agent”；每次调用记录 token、失败和有效任务完成，不能以 mock 调用预算推算真实成本收益。
4. **发送前统一动作归属。** 当前固定回复、定时和人工 Hook 入口已有各自状态；新增 Agent 只生成 action intent。后续接入唯一仲裁器，统一检查群／对象许可、最新需求版本、接管、预算和幂等后进入既有 sender，保留其证据等级；不能让旧自动回复和新 Agent 同时消费同条输入并各发一次。
5. **将原生 @ 与企微 Hook 保留独立门槛。** 现有 Windows 可先验证只读抓取、介入判断和本地草稿；每日真 @ 索价仍需原生 @ 发送实现及同群两类接收端验收。企微客户端 Hook 接收实验独立提供来源适配，达到字段／持续性／恢复验收后再替换 collector，不先重建整套业务 Agent。

首期需求见 `specs/mixed-group-business-requirements-2026-09-21.md:7-13,17-35`：约 300 个原混合群，每配置执行日一次模板真 @ 索价、批准场景回复及交原群业务员。追踪收齐、催收、自动报价、订单确认、时效承诺均不在首期；任务编排可以预留等待／版本接口，不等于把这些功能一并上线。

## 来源与许可边界

复用以上本仓库接口和测试不需要从外部框架复制整套实现。`poc/THIRD_PARTY_NOTICES.md:7-15` 已记录参考附件与 Chat-Lab 未声明项目许可证，当前 PoC 是重实现接口；不能因本地存在 `.research` 参考源码就当作可以直接商用复制。`WeBridge/UPSTREAM.md:5-17` 记录其内部来源及基线，但不是开源授权声明。此次非联网许可审查，不新增商业许可结论；后续引入外部组件时仍要按对应固定版本核对许可与依赖通知。
