# OpenClaw Hermes 与 Jev 核心资料复核

核验日期：2026-10-04（北京时间）。只访问官方文档及固定官方源码，未安装框架、运行通道或调用模型。本记录更新 10 月 2 日资料中的两个解释：OpenClaw 的工具启动边界、Hermes Bot Chat 的会话命令。动态文档说明、固定源码静态核对与本项目实测分别对待。

## 本次需要修正的结论

| 主题 | 当前证据 | 对本项目的影响 |
| --- | --- | --- |
| OpenClaw steering | 同一条 assistant 消息首个可执行串行工具不先检查 steering，此后串行调用有检查点，已启动状态跨该消息的流式批次保留；并行批次不因 steering 跳过 | 每次外部动作独立核对任务版本、输入消费和接管；不能依赖 steering 防止首个或并行工具执行 |
| Hermes Bot Chat | canonical Bot Chat 的 `/new`、`/reset` 按 `/compact` 处理，保留同一永久聊天 | 任务到运行会话的映射由业务层实现，不能把普通 profile 的 `/new` 语义套给 Bot Chat |

OpenClaw 边界依据 [Steering queue](https://docs.openclaw.ai/concepts/queue-steering) 及 [固定文档源文件](https://github.com/openclaw/openclaw/blob/31a1705cca22f243ceac3065de5331d8f4fc5e26/docs/concepts/queue-steering.md#L19-L26)。固定 SHA 为 `31a1705cca22f243ceac3065de5331d8f4fc5e26`，固定的是文档源文件，不是本项目运行成绩。10 月 2 日记录 F12 的工具检查点解释保留历史时点，当前使用本记录。

Hermes 会话限定依据 [Bot Mode](https://hermes-agent.nousresearch.com/docs/user-guide/bot-mode/)。普通 profile session 的新建与 canonical Bot Chat 不同；记忆或 profile 隔离也不自动形成多人任务账本。

## 保持成立的结论

OpenClaw 的 `followup`、`collect`、`steer`、`interrupt` 分别处理运行中新输入；消息合并不识别业务任务，输入存盘也不意味着重启后自动重放内存队列。通道 durable ingress 是独立机制。[Queue](https://docs.openclaw.ai/concepts/queue)、[Messages](https://docs.openclaw.ai/concepts/messages)

Hermes 子任务依赖 goal／context，返回 `completed` 仍需检查结构有效性和截断。委派源码本次固定为 `8b66a51036c1e20920a17cdd049fdf55c968d683`。[Delegation](https://hermes-agent.nousresearch.com/docs/user-guide/features/delegation/)、[返回结果源码](https://github.com/NousResearch/hermes-agent/blob/8b66a51036c1e20920a17cdd049fdf55c968d683/tools/delegate_tool_child_run.py#L579-L635)

Hermes WeCom 文档仍称缺省 `open`，固定源码仍缺省 `pairing`，群 pairing 不放行。部署需显式设置并核对有效策略；AI Bot WebSocket 文档不证明员工身份原混合群的全部非 @ 投递。[WeCom 文档](https://hermes-agent.nousresearch.com/docs/user-guide/messaging/wecom/)、[适配器缺省](https://github.com/NousResearch/hermes-agent/blob/8b66a51036c1e20920a17cdd049fdf55c968d683/plugins/platforms/wecom/adapter.py#L129-L132)、[群准入](https://github.com/NousResearch/hermes-agent/blob/8b66a51036c1e20920a17cdd049fdf55c968d683/gateway/platforms/access_policy_mixin.py#L65-L69)

Jev 当前模型仍为 `jev-1.13.0`，公开标价每百万输入 token 0.042 美元、输出免费；英语效果最佳，CJK 须自测。它接收文本，不直接处理图片或音视频；本次没有账户核价或效果验证。[Models](https://docs.typesafe.ai/models)

Choice／Score／Noul 的输出与置信度语义未见影响本报告的变化；同请求问题相互独立，Noul 是 yes 概率，没有同样的 confidence。Choice confidence 依赖最高概率及选项数，不能跨候选数量或原语沿用业务阈值。[Primitives](https://docs.typesafe.ai/primitives)、[Confidence](https://docs.typesafe.ai/confidence)

官方还承认 Choice 的选项顺序可能影响选择并偏向首项。本项目应对相同任务候选做顺序置换，记录关联稳定性及高置信度错误；原“没有匹配／歧义”选项也需保留，不能为了省 token 强迫选一个任务。[已知边界](https://docs.typesafe.ai/model-jaggedness/jev-1.13)

## 核验范围

已重新核对三组核心事实；LangGraph、Temporal、EIP、Hook 基础设施等其他研究仍使用主报告所列的 2026-10-02 来源时点。上述核验支持设计取舍，不证明本项目通道接入、中文质量、实际账单或客户端兼容。主报告和预算 JSON 保持同一价格日期及假设口径。
