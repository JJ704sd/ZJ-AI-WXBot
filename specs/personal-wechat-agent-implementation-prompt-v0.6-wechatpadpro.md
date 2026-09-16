# WeChatPadPro v0.6 分阶段实施提示词

> Windows 861 请使用[固定构建实现决策中的后续提示词](wechatpadpro-861-implementation-decision-2026-09-16.md)，不要直接执行本文 MAX 假设下的步骤。

配套：[技术研究](wechatpadpro-technical-research-2026-09-16.md)、[v0.6 方案](personal-wechat-agent-poc-v0.6-wechatpadpro.md)。以下是后续任务用的提示词，本轮未执行这些阶段。

## 下一轮：P0 契约补齐 + P1 离线实现

```text
在 D:\path\to\ZJ-AI-WXBot 基于以下文件推进 WeChatPadPro P0/P1：
specs/wechatpadpro-technical-research-2026-09-16.md
specs/personal-wechat-agent-poc-v0.6-wechatpadpro.md

先检查当前 AGENTS、Git 分支/暂存区/工作区及 api_channel、api_config、
api_runtime、observer_service 的相关实现，保留其他任务改动。

目标是可运行的独立 Pad 离线观察通道，不是接通真实微信。
优先补齐公开契约，明确 legacy/MAX，不能混用版本。
没有与实际构建匹配的 v2 schema/样本时，保持 unknown；不猜测真实 @、
历史标志、At 编码、Type 枚举、本人和在线响应。

允许读取公开文档和在项目内实现/测试；不登录维护者控制台，不生成授权码，
不下载或运行网关二进制/镜像，不采购，不扫码，不调用真实微信或付费模型，
不开放公网，不创建自启动，不 commit/push。

实现范围：
1. pad-provider-profile/1 与 pad-config/1，显式独立库路径、版本、凭据引用；
   未知字段拒绝，live 默认关闭。旧 api-config/1 和旧数据库保持兼容。
2. PadIngress：处理 envelope + Data.messages 批次，在同一事务持久化目标事件；
   跨群/私聊正文不落库；重复幂等、冲突暂停、坏项有逐项记录，失败不伪 ACK。
3. 独立只读 PadObserver，只持有只读 transport；不构造模型、发送 client、
   outbox 或定时任务；启停/到期/状态实际可验证。
4. v1 文档解码器输出现有 ApiMessageV1。身份、@或新旧状态证据不足时 unknown，
   不把文档样例当 observed。v2 不明确时明确拒绝/隔离。
5. 认证分开记录 metadata_signature_valid 与私有传输证据。
   文档 HMAC 不覆盖 Data，不允许仅通过该签名就获得业务触发权限。
   校验官方向量冲突，不能为了匹配错误示例修改标准 HMAC。
6. CLI check 默认不联网；status/stop 不构造网关或模型；实现真实 help/错误码。
   暂不提供真实发送入口，不删除 ApiRuntime.start 的 A1 live 拒绝，
   不放宽 GeWe agent_blockers。

测试使用本地 HTTP 桩、fake clock、独立临时 SQLite 和合成凭据，覆盖：
批内/跨重启重复与冲突、事务失败、部分坏消息、大整数 ID、schema 漂移、
未知 @/历史、正文篡改不改变元数据签名、无可信对端、跨群、停止竞态、
到期和重启不补发。文档夹具与实机样本分开标注。

先跑相关测试；代码修改后跑项目必要完整回归一次。
交付变更说明、真实命令、证据和缺口清单；旧 184 passed 不作本轮测试结果。
缺少真实构建不妨碍已知部分离线实现，但必须报告 P0 仍未闭合。
停在 P1，不自行进入 P2/P3。
```

## P2/P3 之前的具体输入

安装前需形成可检查的部署单：目标主机/系统、准确产品构建/哈希、运行依赖、许可费用、外部授权与数据路径、私有回调拓扑、内置动作关闭及读回方法。此时再确定安装和登录范围，不能仅凭“已读方案”启动环境。

真实只读任务必须写明：唯一测试账号/群的本地绑定引用，操作人扫码，最长30分钟，独立观察库，20条样本及 @/历史反例，零 API 发送/零模型调用。关闭内置自动化未证明时，要先解决网关自身动作边界。

## P4/P5/P6 的放行材料

- P4：固定构建、本人/群/成员映射、可靠来源、新鲜度和发送请求语义；ACK 与原生 @分别限量验收。
- P5：真实 @接收证据、ACK 接收证据、真实 Runtime/model 装配测试、10次模型/发送额度。
- P6：企微目标原生 @通过，明确1–2个目标及一次性模板；120秒、600秒、每人追加≤3，未回复不催促。

每阶段执行后保存实际运行版本、run_id、来源/接收/模型/提交/接收端时间、失败与未执行项；阶段通过只对该账号、群和版本有效。不要把离线通过、API accepted、客户端 verified 合并成一个“成功”。
