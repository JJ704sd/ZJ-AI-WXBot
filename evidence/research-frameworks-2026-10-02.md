# OpenClaw / Hermes 框架增量研究证据（2026-10-02）

时点说明：本记录保留 2026-10-02 来源。F12 的 steering 检查点和 F5 的 Bot Chat 会话命令按 [2026-10-04 官方复核](research-framework-refresh-2026-10-04.md) 更新，旧固定提交的核查结果不改写为当前运行证明。

用途：为第二版 `specs/wecom-hook-agent-research-2026-10-02.md` 提供增量证据，重点核验 Agent 编排、静默介入、上下文成本和企微通道边界。访问日期为 2026-10-02（Asia/Shanghai）。本轮仅阅读官方文档和官方仓库，没有安装框架、执行上游代码、连接企业微信或发消息。

证据层级：**文档声明**不是实测；**固定提交源码静态检查**只证明所见代码路径；**设计推论**是本项目建议。以下“新增”指旧报告没有展开，不宣称功能在本日才发布。

## 1. 检索基线

通过 GitHub API `repos/{owner}/{repo}/commits/HEAD` 读取到的提交如下。后续源码读取使用完整 SHA；动态文档页不冒充与该 SHA 完全一致。

| 仓库 | 本轮 HEAD | 提交时间（UTC） | 用途 |
| --- | --- | --- | --- |
| openclaw/openclaw | `94cbbecd46cc2a0871da4f5f01d876dfd946000c` | 2026-10-02 13:03:08 | 元数据基线；能力描述来自在线官方文档 |
| NousResearch/hermes-agent | `0a374d167424cdc730ce9761368b62255b551e58` | 2026-10-02 12:10:06 | 固定源码与文档交叉检查 |
| WecomTeam/wecom-openclaw-plugin | `3b1cbe3e664352821758d99ae5907f5620fce26e` | 2026-08-17 07:45:28 | 固定源码与 README 交叉检查 |

接口访问经历 PowerShell TLS 失败、部分 raw 请求 429 / 超时；最终通过保留证书校验的 Python urllib、GitHub Contents API 和网页工具读取所引用材料。没有绕过身份验证。未保存全仓库副本。

## 2. 支持与反证

### F1：静默介入是明确的事件语义，不能等同于“无 @ 消息都让模型回答 NO_REPLY”

**文档声明。** OpenClaw 的 ambient room events 将未被提及的群消息作为安静的房间事件，消息工具调用才产生可见发送。当前支持名单为 Discord、Slack、Telegram；页面没有将 WeCom 列入。群需关闭 mention gating，并先通过群／发送者权限检查。[O1]

**设计推论。** 自有 Hook 适配器宜在事件层区分 `ambient_observation`、`direct_request`、`human_takeover`，再分别决定是否调用语义门禁、生成器或立即暂停。借鉴该语义不意味着现成 WeCom 插件已实现它；房间事件可以触发模型，静默不证明零 token。应分别统计“已采集”“已进入上下文”“已模型判定”“已发送”，避免把静默次数当节省调用数。

### F2：确定性路由、持久 Agent 和一次性子任务是三种不同机制

**文档声明。** OpenClaw agent 有独立工作区、状态与会话；但工作区只是默认目录，绝对路径仍可到达宿主其他位置，隔离须依赖 sandbox。插件自己的全局存储也不随新增 agent 自动拆分。[O2] 子 Agent 有单独 token 消耗；确有需要才 fork 父对话。[O3]

**设计推论。** 群／客户隔离先靠不可变 tenant/account/conversation 键、检索权限和资源沙箱，不靠 persona 名称。按需资料专家用短任务说明和消息证据；只需要固定字段抽取时不启动长期 agent。每个客户一个 session 可以复用少量 worker，不必每个群一个永久 persona。

### F3：企微插件的“动态 Agent”存在会话分裂条件

**固定源码静态检查。** `dynamic-routing.ts:76–99` 在 bindings 已命中时跳过动态路由；只有默认路由才生成账号、会话类型、会话 ID 对应的 agent/session。`dynamic-agent.ts:22–28` 默认关闭动态 agent；`:69–79` 的 adminUsers 绕过不区分私聊／群聊。[W1][W2]

**设计推论。** 若依赖动态 agent 隔离一个群，而群内业务员被列为 admin，客户发言可能进入群 agent，业务员插话却进入主 agent；同一事项可能不能在同一上下文识别人类已经接管。建议先显式绑定原群并将管理控制放入独立入口；采集账本和接管状态不得由路由出来的 agent 各自维护。

这不是已实测缺陷：尚未运行该组合；它是可直接构造的路由验收场景。显式 bindings 优先也意味着“启用动态 agent”不保证实际每群独立。

### F4：插件群策略控制的是准入，不证明非 @ 事件送达

**固定源码静态检查。** 官方企微插件 `group-policy.ts:122–163` 检查群与发送者名单；`monitor.ts:274–310` 构造的上下文包含群、发送人、账号和消息 ID，但此处未见原生 mention 证据字段。`:731–758` 进行准入，之后下载媒体并送到核心。[W3][W4]

**结论边界。** 这证明插件怎样处理已经收到的事件，不能证明平台会把原混合群中的全部非 @ 消息交给该 Bot。`groupPolicy: open` 只放行入口已有事件；不能创造上游没推送的消息。也不能用通用 groups 文档或正则昵称补齐原生 @ 身份。企业微信官方智能机器人文档链接本轮未成功展开，因此不把“原目标群可接收非 @”作为已核实事实。

### F5：Hermes 持久记忆的省 token 机制有明确刷新边界

**文档声明。** 内置记忆是有界文本：MEMORY.md 默认 2,200 字符，USER.md 默认 1,375 字符；会话开始时冻结到 system prompt，以保留前缀缓存。当前会话里的记忆写入会落盘，但新的 system snapshot 要等新会话。网关连续聊天可跨重启延续，同一 Hermes home 不应由多个 agent 进程共同写入。[H1]

**设计推论。** 把稳定风格／约束放长期记忆；价格有效性、订单状态、接管标志和待回复事项放版本化业务状态库，并在每次决定动作时读取。事项完成后按 case 切新 session，携带短的结构化交接与证据指针；不要对一个 300 群长会话无限压缩，也不要把 `/new` 当成安全清空未完成事项的方式。

### F6：Hermes 委派适合短上下文专家，但并非任意每任务选模型

**文档声明。** 委派子任务使用新的上下文，主要接收 goal/context；批次的 `delegation.model` 为共同配置，`delegate_task` 没有每个 task 的模型参数。超时设置是无进展时长，不是总运行时长。默认叶子任务不能继续分派。[H2]

**设计推论。** 首期只保留“决策 → 至多一个专家 → 仲裁”。专家需要不同成本／权限时，通过明确 profile 或独立 worker 服务解决；不要假设一个任务参数能同时选便宜抽取模型和昂贵复核模型。预算必须另外限制累计调用、输入／输出量、并发和总截止时间，不能把 inactivity timeout 当日预算。

### F7：禁止发送工具不等于子 Agent 没有外部副作用能力

**固定源码静态检查。** Hermes `delegate_tool_toolsets.py:14–21` 屏蔽 memory、send_message、cronjob_manage 等工具；`:77–85` 仍以父任务工具权限为基础继承。默认工具集合包含 terminal/file/web。[H3]

**设计推论。** 此机制支持“子任务只回结果”的组织方式，但业务专员仍应只持有范围受限的检索和状态只读工具。若保留终端、通用网络或广泛文件权限，仅删除 send_message 不是可靠的发送隔离；自有 Sender 仍是唯一持有提交凭据的服务。

### F8：Hermes 的 completed 不能直接作为业务结果通过标志

**固定源码静态检查。** `delegate_tool_child_run.py:437–476` 对结构化输出最多追加一次修正。`:535–594` 可返回 `status=completed` 且 `schema_valid=false`，也可在迭代预算耗尽时返回 `truncated=true`。结果同时提供 token、cost_usd 和 cost_status。[H4]

**设计推论。** 接入门槛要检查完成原因、是否截断、schema 校验、证据消息是否齐全、case_version 是否仍有效，最后再做动作权限检查。成本 unknown 不按 0 记账。模型选中了合法枚举值，也仍需证明业务含义正确。

### F9：Hermes WeCom 当前文档与固定源码的默认准入值不一致

**文档声明。** WeCom 页面配置表写 dm_policy / group_policy 默认 open。[H5]

**固定源码静态检查。** `plugins/platforms/wecom/adapter.py:123–134` 在配置和环境值均缺省时回退 pairing；`gateway/platforms/access_policy_mixin.py:65–69` 不转发 pairing 群事件。[H6][H7]

**结论。** 不能沿用页面默认值推断“零配置接收群消息”。PoC 应记录安装版本和有效配置，显式选择允许群与发送者，再用真实输入核验。这里只定位文档／代码差异；没有运行完整安装向导，不宣称向导最终一定写入哪种配置。

### F10：通道去重缓存不能替代持久采集账本

**固定源码静态检查。** Hermes WeCom `adapter.py:66,138,426–431` 使用最大 1,000 项的 MessageDeduplicator，先登记 ID 再继续处理；注释说明处理异常后的同 ID 重投仍可能在 TTL 内被丢弃。`helpers.py:20–43` 的默认 TTL 为 300 秒，存储是内存 dict；文件另有运行中适配器重建时转移缓存的函数。[H6][H8]

**设计推论。** 运行中重建去重并不等于崩溃后持久去重；先标记再处理也不等于任务成功。自有账本应将 ingest/dedup、模型消费和发送提交分别保存，并测试“异常后原 ID 重投”“过 TTL 重投”“超过缓存容量”“进程重启后重投”。不能据上游 auto-reconnect / dedup 功能宣称不会漏收或重复回复。

### F11：inbound debounce、运行中队列与业务任务合并不可混为一谈

**文档声明。** OpenClaw `messages.inbound` 把同一发送者的密集文字按安静窗合成 turn；媒体会立即冲刷，控制命令绕过等待。页面明确它只是启发式，不能保证长消息片段都落在同一 turn。`BodyForAgent` 与指令解析字段也分开。[O6]

**设计推论。** `message ≠ turn ≠ task`：例如“查库存”→“红色”→“刚才说错，是蓝色”，可对应三条消息、一次或多次模型 turn、一个被更新的业务任务；“另外查快递”可能是第二任务。安静窗只解决时间上的碎片，不能证明同一事项。独立编排层须先保留所有事件，再决定 `append / supersede / new_task / cancel / observe`，为任务维护引用证据、当前约束和版本号；不能将 debounce 文本拼接直接当任务归并结果。

### F12：queue 的运行时语义不能承担业务接管的全部职责

**文档声明。** OpenClaw 本日页面默认 `steer`，500ms 队列安静窗、cap=20、溢出 summarize；followup 排后续 turn，collect 合并兼容输入，interrupt 中止当前 run 再运行最新输入。同 session 只有一个 run；不同 session 可并行。[O5] steering 不抢占运行中的工具；会跳过尚未启动的串行尾部，已越过启动检查点的并行调用继续。不同 runtime 的读取边界不同。[O7]

**设计推论。** 用户更正可以 steer，业务员接管要先在独立状态库暂停任务并废弃旧提交权限，再尽力取消模型／工具。只发一条“停止”给模型，不能阻止已在途的发送；中断也不能撤销已完成的外部动作。每次提交都应重新检查任务版本与人工接管状态。通道全设 collect 还可能把同群多个客户事项合成一个 turn，需先做语义分流；同 session 串行也不等于同业务任务完整性。

### F13：OpenClaw 已有持久输入／通道入口机制，但不是通用任务恢复承诺

**文档声明。** `chat.send` 输入可在确认前落 per-agent 数据库；collect 合成 turn 与源输入消费同事务。进程停止后内存队列不重放，未进 transcript 的输入标为中断并需显式重发。[O5] durable ingress 是另一套通道机制：原始 envelope 先持久追加、再确认，按会话串行，完成后保留 tombstone；文档仍注明外部副作用存在至少一次执行的崩溃窗口。[O8]

**设计推论。** 不可简单写“OpenClaw 队列不持久化”，也不可写“OpenClaw 已保证业务任务恢复”。须记录适配器是否实际接入 durable ingress、何时算 turn adoption、任务是否完成、效果是否可重复。自有 Hook 无法当然要求微信服务器重投；本机 spool 只能保护它已成功接收之后的故障窗口。`task_id + revision + effect_id` 的幂等／未知结果核对仍由任务和 Sender 账本承担。

## 3. 建议取舍

保留自有 Hook Collector、事件账本、事项状态和唯一 Sender。首轮一个受限业务 Agent 配合确定性门禁，建立相同准确性要求下的成本基线；增加专家的条件是事项复杂度或权限确需拆分，且评测证明收益超过路由／上下文重复／摘要／复核的新增成本。

若未来重点是多通道 bindings、持久 persona 与明确通道策略，OpenClaw 值得单独试点；若重点是短上下文委派、skills 和有界个人记忆，Hermes 值得单独试点。二者都不作为企微原群全量采集能力的证据，首期不叠加两个编排框架。

日常链路建议保持至多一层委派。以下阈值应通过评测决定，不预置“多 Agent 一定省 token”的百分比：触发率、专家调用率、每项检索预算、case 输入上限、最大重试数、预算耗尽后的待人工比例。比较时固定同一事件集、相同采集完整性、相同介入召回和相同权限。

## 4. 最小反证测试（本轮未执行）

| 测试 | 要捕获的失效 | 可判定的证据 |
| --- | --- | --- |
| 原混合群：个微／企微成员分别发送真 @、非 @、文字假 @ | Bot 群支持被错误扩大为全部消息抓取 | 客户端编号分母、入口原始事件、原生 mention 字段对照 |
| 同一群普通成员发问 → adminUsers 成员人工接管 | 动态路由把同一事项拆到不同 agent | route agent/session 与共享接管版本 |
| 静默房间 100 条闲聊 | 静默被错误计为无模型调用 | 模型调用数、输入／输出量、可见发送数分表 |
| Hermes 配置不写准入值，再显式设群 allowlist | 文档默认值与安装版本行为不一致 | 版本、有效配置、入口接收／丢弃原因 |
| 子任务输出合法 JSON 但缺字段；耗尽迭代后仍返回摘要 | completed 被当成 validated | schema_valid、truncated、exit_reason、仲裁拒绝原因 |
| 接收后处理异常，重投同 ID；缓存超限／TTL 后重投；重启重投 | 暂存去重造成漏处理或重复执行 | 持久事件状态、消费确认、发送账本唯一性 |
| case 生成草稿时业务员插话、客户更正，再让子任务返回 | 过时专家结果被提交 | case_version 不匹配使旧草稿失效 |
| 两客户相似问题和共享插件存储／绝对路径探针 | persona 分开但数据和工具没隔离 | 检索授权拒绝、沙箱拒绝、无跨客户片段 |
| 一项任务碎片补充、否定更正、另一项任务交错 | collect/debounce 被当成语义任务合并 | 事件到 task_id 的人工标注对照、版本更新 |
| 正在读取／发送工具时插入 steer 与人工接管 | 运行中工具不受 steer 抢占，旧动作继续 | 实际工具启动时间、接管版本、提交前门禁 |
| chat.send 已确认后重启；channel durable append 后重启 | 持久输入、内存队列、入口重试混为一谈 | 分入口记录 pending/adopted/completed/effect 状态 |

## 5. 一手来源

所有链接本轮访问日期均为 2026-10-02。源码链接按上文固定 SHA；行号为从原文件第一行开始的编号。

| ID | URL | 证据类别 |
| --- | --- | --- |
| O1 | [OpenClaw Ambient room events](https://docs.openclaw.ai/channels/ambient-room-events) | 动态文档声明 |
| O2 | [OpenClaw Multi-agent routing](https://docs.openclaw.ai/concepts/multi-agent) | 动态文档声明 |
| O3 | [OpenClaw Sub-agents](https://docs.openclaw.ai/tools/subagents) | 动态文档声明 |
| O4 | [OpenClaw WeCom](https://docs.openclaw.ai/channels/wecom) | 外部官方团队插件身份、版本文档边界 |
| O5 | [OpenClaw Command queue](https://docs.openclaw.ai/concepts/queue) | 动态文档声明；Modes、Input durability、Lanes and scope |
| O6 | [OpenClaw Messages](https://docs.openclaw.ai/concepts/messages) | 动态文档声明；Inbound debouncing、Prompt bodies |
| O7 | [OpenClaw Steering queue](https://docs.openclaw.ai/concepts/queue-steering) | 动态文档声明；Runtime / Tool launch boundaries |
| O8 | [OpenClaw Durable channel ingress](https://docs.openclaw.ai/plugins/sdk-channel-plugins/durable-ingress) | 动态 SDK 文档声明；Durable ingress、At-least-once side effects |
| W1 | [WeCom dynamic-routing.ts](https://github.com/WecomTeam/wecom-openclaw-plugin/blob/3b1cbe3e664352821758d99ae5907f5620fce26e/src/dynamic-routing.ts#L76-L99) | 固定源码 |
| W2 | [WeCom dynamic-agent.ts](https://github.com/WecomTeam/wecom-openclaw-plugin/blob/3b1cbe3e664352821758d99ae5907f5620fce26e/src/dynamic-agent.ts#L22-L79) | 固定源码 |
| W3 | [WeCom group-policy.ts](https://github.com/WecomTeam/wecom-openclaw-plugin/blob/3b1cbe3e664352821758d99ae5907f5620fce26e/src/group-policy.ts#L122-L163) | 固定源码 |
| W4 | [WeCom monitor.ts](https://github.com/WecomTeam/wecom-openclaw-plugin/blob/3b1cbe3e664352821758d99ae5907f5620fce26e/src/monitor.ts#L274-L310) | 固定源码，另见 731–758 |
| H1 | [Hermes Persistent Memory](https://hermes-agent.nousresearch.com/docs/user-guide/features/memory/) | 动态文档声明 |
| H2 | [Hermes Subagent Delegation](https://hermes-agent.nousresearch.com/docs/user-guide/features/delegation/) | 动态文档声明 |
| H3 | [Hermes delegate_tool_toolsets.py](https://github.com/NousResearch/hermes-agent/blob/0a374d167424cdc730ce9761368b62255b551e58/tools/delegate_tool_toolsets.py#L14-L23) | 固定源码，另见 77–85 |
| H4 | [Hermes delegate_tool_child_run.py](https://github.com/NousResearch/hermes-agent/blob/0a374d167424cdc730ce9761368b62255b551e58/tools/delegate_tool_child_run.py#L508-L594) | 固定源码，另见 437–476、732–767 |
| H5 | [Hermes WeCom](https://hermes-agent.nousresearch.com/docs/user-guide/messaging/wecom/) | 动态文档声明 |
| H6 | [Hermes WeCom adapter.py](https://github.com/NousResearch/hermes-agent/blob/0a374d167424cdc730ce9761368b62255b551e58/plugins/platforms/wecom/adapter.py#L123-L143) | 固定源码，另见 426–431 |
| H7 | [Hermes access_policy_mixin.py](https://github.com/NousResearch/hermes-agent/blob/0a374d167424cdc730ce9761368b62255b551e58/gateway/platforms/access_policy_mixin.py#L51-L69) | 固定源码 |
| H8 | [Hermes helpers.py](https://github.com/NousResearch/hermes-agent/blob/0a374d167424cdc730ce9761368b62255b551e58/gateway/platforms/helpers.py#L20-L84) | 固定源码 |

补充核对：[企业微信团队插件 README](https://github.com/WecomTeam/wecom-openclaw-plugin) 描述 Bot 与 Agent 两种入口；[Hermes WeCom Callback](https://hermes-agent.nousresearch.com/docs/user-guide/messaging/wecom-callback/) 描述自建应用的 XML 回调和主动发送。二者均不足以证明员工客户端的原混合群全量观察能力。
