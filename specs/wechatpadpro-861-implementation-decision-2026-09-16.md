# Windows 861：需求、接口证据与下一步实现

日期：2026-09-16。适用构建 ios18.61-861 / 20250822_153444。本文件覆盖 v0.6 中涉及此 Windows 构建的 MAX 优先、Webhook 优先和部署假设；业务上限继续保留。状态：静态契约核验完成，真实微信能力尚未验收。

> 后续实测更新：见 [MCP与授权链路证据](../poc/evidence/pad-861-metadata-auth-2026-09-16.md)。匿名 MCP 已完成初始化并列出193个工具；HTTP管理鉴权对照通过；设备key生成返回授权服务不可用。下一优先级为闭合授权链路，暂未到扫码。下文“本轮没有启动”描述最初静态调查，不覆盖此次后续短时探针。

> 16:04补充：用户仅有ZIP，无另行取得的key，不再等待填写授权文件。独立公共DNS+定向TLS/现有代理对照已证明上游服务可响应；空JSON校验返回401安全字段缺失。尚未验证随机ADMIN_KEY能否取得设备key，也不能认定必须购买。下一步为有界正常出网授权测试，非直接采购或扫码。

> 16:11执行结果：用户已明确授权联网及ADMIN_KEY外发；单次出站开放试验仍返回Code300“授权服务暂时不可用”，未取得设备key。14.09秒后网关停止、端口释放、原出站Block恢复。正常出网试验已做，不应再把它列为未执行下一步；接下来需要固定构建的授权协议/维护者诊断证据，详见同一证据报告末节。

## 当前结论

**最新已取得明确上游响应**：[服务端数据库失败证据](../poc/evidence/pad-861-upstream-database-failure-2026-09-16.md)。定向TLS生成11.281秒后HTTP200、业务code1，说明自动注册管理员密钥时查询系统用户的上游数据库连接超时；无设备key。该次不再只是未知网络错误，需上游依赖恢复。旧未知请求保持未知，未提交Issue。

最新按教程原生重试：[17:00执行证据](../poc/evidence/pad-861-tutorial-native-retry-2026-09-16.md)。不经过自建转发层，一次Count1/Days1仍Code300授权服务不可用，无设备key；12.27秒清理完成，防火墙恢复、配置未变。用户明确不提交Issue，未对外联系。

最新网络对照：[15次健康检查结果](../poc/evidence/pad-861-network-matrix-2026-09-16.md)。curl两组及实际Python客户端均5/5成功；无独立公网直连证据，无理由据此替换客户端或代理。保留已完成修复，仍需核对未知生成结果才能推进授权及真机登录。

最新修复轮：[最小修复与实测](../poc/evidence/pad-861-minimal-repair-trial-2026-09-16.md)。分阶段错误与迟到响应收据已实现，37项相关测试通过。一次新生成在connect_or_response_headers阶段0.562秒URLError；仍无设备key。健康有成功也有失败，不能认定厂商拒绝授权。真机演示仍阻塞在授权传输/未知结果核对，不是Agent业务代码验收完成。

最新只读对账：两次GetAllDevices均本地设备0；真实健康200，但无上游设备查询。没有可恢复本地key，上游首次生成状态仍未知。已完成独立查询模式及34项相关回归；当前需要厂商侧核对或有效设备key，不能继续靠重复生成推进。脱敏维护者问题见 `../poc/evidence/pad-861-maintainer-query-2026-09-16.md`，尚未对外发送。

最新执行：固定目的地传输适配已完成并实测。健康200，生成POST等待4秒后超时；网关自动重试被一次性限制409拦截。本地仍Code300且无设备key，上游是否处理首次请求未知，不得自动重试。相关33项测试通过，网关停机且双向Block保留。当前待核实上游处理结果，不再把“实现传输适配”列为未完成；细节见下方代理对照报告。

最新网络诊断：[授权代理对照证据](../poc/evidence/pad-861-proxy-diagnosis-2026-09-16.md)。已定位授权客户端不使用环境代理；只转发真实上游 `/ping` 的本地通道复验得到200。此前“已设置代理”不能当作授权请求确实经过代理。未再次生成设备key，未登录；下一步聚焦授权传输适配及其有界验证，不能据当前错误要求购买授权。

该包有文本发送及原生 @ 的明确请求字段，值得继续验证。尚不能宣布能完成混合群自动回复：真实接收结构、历史边界、账号登录、混合群成员与送达均没有实测证据。本轮没有启动网关或改变防火墙，没有扫码和发送。

本轮脚本直接读取用户提供 ZIP，先核对 SHA-256，再提取 14 个相关接口及递归引用模型；不解压执行、不读取凭据、不访问网络。结果在 `../poc/evidence/pad-861-contract-audit-2026-09-16.json`。ZIP 摘要为 `4500ab14ac22b71146705ed2dc0046af4ee6ed555a617ba99430e1e1546d9430`，Swagger 摘要为 `b53cf8e7eae3f9240e27304d6944811a1a40792b4098b0198c757e816b04a2ed`。

公开项目当前标题已经宣传 v875，不能用网页新版本说明覆盖此 861 包：[项目一手页面](https://github.com/WeChatPadPro/WeChatPadPro)。

## 需求与能力矩阵

以下 documented 均指固定包内声明，不代表 observed 微信能力。

| 需求 | 当前证据 | 判定及必要验收 |
|---|---|---|
| 登录、本人在线 | GET /login/GetLoginStatus、/equipment/GetOnlineInfo；响应无 schema | documented；未证实本人身份、会话有效性 |
| 目标混合群与成员 | /qy/QWGetChatroomInfo、/qy/QWGetChatRoomMember；另有普通 /group 接口 | documented；必须用实际混合群映射，不按后缀猜企微身份 |
| 接收文本 | POST /message/HttpSyncMsg；SyncMessageModel.Count，0 表示全部；另有 WS、Redis、Webhook | documented；响应、游标、消费/重放行为 unknown |
| 真实 @本人 | 接收响应无 schema | unknown；不得将文本 @昵称或发送 AtWxIDList 当接收证据 |
| 排除历史 | /webhook/ResetConnection 描述重置连接时间戳 | documented；其副作用及保证 unknown，也不适用于推断 HTTP 轮询 |
| 文本和原生 @ | POST /message/SendTextMessage，MsgItem 数组；MessageItem 含 ToUserName、TextContent、MsgType=1、AtWxIDList | documented；必须分别检查个微和企微端的实际原生 @及送达 |
| 去重与提交回执 | 发送响应无 schema；请求模型未声明幂等字段 | unknown；本地 outbox 去重，超时标 unknown 并暂停，不自动重发 |
| 有界对话和定时 | 现有 ApiRuntime/ApiStore 已有路由、任务、预算、停止和恢复逻辑 | 本地可复用；不代表 861 已接入 |
| 内置自动化、MCP | 交接实测匿名 SSE 可握手；未测 tools/list/tools/call；HOST/MCP_PORT 未按配置控制监听 | 仍待核实；无需重复猜端口或把 Docker 当远程设备 |

文档缺陷：/webhook/Update 方法为 `t`；WebhookConfig.URL 引用了不存在的模型；选取接口缺少响应 schema。不得自动生成并启用 SDK，也不应把 GET 等同无副作用（例如 /webhook/Test）。

## 接口与部署决策

调用方需要明确的账号/群绑定、真实 @、新消息证据、稳定事件键，以及发送结果 `not_submitted / submitted / unknown`；HTTP 200 不升级为送达。外部网关细节应留在一个 861 adapter 内，复用现有 Channel 接口；SQLite、时钟及 outbox 沿用现有实现，不增加另一套 Agent。

| 方案 | 调用契约和示例 | 隐藏职责、代价与失败行为 |
|---|---|---|
| HTTP 轮询 adapter（首选调查） | 有界读取 → 规范化事件 → 现有 runtime；`channel.probe(binding)`、`channel.submit(command)` 复用现有接口 | 单一消费者内处理鉴权、限量、时间和身份；无回调入口，但若无法证明历史/消费语义则不得接自动回复 |
| Webhook adapter（备选） | loopback ingress → 持久化 → 应答 → 规范化事件 | 增加生命周期及来源验证；已有观察库可复用，但 861 配置/认证/回调 schema 需实际补齐，不能套 MAX HMAC |
| MCP 接管（不选） | Agent 经工具发现并调用厂商工具 | 工具面较大、鉴权未知，重复暴露管理和收发权限；与现有窄 Channel 契约不匹配，迁移和审计代价最高 |

首选只是调查顺序，不是已确认轮询可用。任何时刻只启用一种接收方式。保留 Windows EXE 和现有独立 MySQL/Redis；不升级到 latest、不切换 MAX，不改其它容器。MCP 不接给模型。网关是真正的外部依赖，其内置行为不受 Python 观察器的无发送约束覆盖。

已核对 ApiRuntime._pre_ignore_reason 对本人、身份、历史、基线、30 秒新鲜度和群范围进行过滤；_submit_tool 经过在线探针、outbox、预算、锁和结果记录。因此下一次实现主要补实际 adapter，而不是重写业务。迁移前仍需显式设计 Pad 启动契约；本轮不放宽 api-config/1、pad-config/1 或 live 开关。

## 实机验收顺序与停点

1. 无账号基础探针：核实独立远程入站边界；匿名 MCP initialize/tools/list 可单独研究，只读取工具元数据，不 tools/call。确认内置好友、推广、发送和恢复行为的配置来源及有效性。不因未找到开关宣称已禁用。
2. 指定测试号及一个混合测试群后，明确登录与只读样本授权。先验证本人、在线、群和成员；先不要调用全量联系人接口。原始数据只保存在 gitignored 本地目录，报告使用脱敏 ID。
3. 单路接收至少 20 条标注消息，覆盖真 @本人、昵称伪 @、引用 @、@他人、本人、历史、重复、重连及企微成员。历史与真 @缺任一可靠判据则只观察。轮询不得用空 body 或 Count=0 拉全量；Count 的实际限制及消费行为要先验证。
4. 单独批准固定文本发送及接收对象后，先人工触发一条固定 ACK，再各验证普通文字和原生 @。记录两个客户端观察、消息 ID、发生/接收/提交/显示时间；超时不重试。
5. 上述能力通过后才连接模型及自动任务。保留输入≤2000、输出≤300 字符，120 秒一次性任务，1–2 名目标各一次，会话≤600 秒、每人追加≤3 次、冷却10秒。来源超过30秒取消；错过首次10秒窗口取消，重启不补发。时延10次中9次≤15秒且全部≤30秒。

已从 gitignored `poc/.local/poc/live.toml` 与 `live-t4.toml` 找回同一测试号及群绑定，两份一致；用户本轮确认沿用此前对象。稳定内部键留在本地配置，不复制进版本库。该旧绑定是重新核对 861 映射的输入，不代表 861 已登录。仍缺真实样本、已验证的自动化关闭方式及远程入站结果，故停在离线契约阶段。采购、外部联系和扩大到其它群不在本轮操作范围。

## 可直接执行的后续提示词

继续 Windows 861，先读本文件与固定包审计 JSON。保留现有改动与基础依赖。优先完成无账号的 MCP 元数据鉴权和内置动作控制研究，短时启动前检查已有精确防火墙规则，使用 finally 停止自己启动的进程并核对端口。不要 tools/call、不猜禁用参数。拿到指定测试号/混合群和登录采样授权后，按上面20条验收表验证单路 HTTP 接收；若契约不成立，再调查 legacy Webhook，不套 MAX。取得真实响应后按现有 Channel/Runtime/Store 契约实现一个 861 adapter，补脱敏夹具与回归。实机通过之前不打开自动发送；不 commit/push。

## 本轮实现与验证记录

- 新增 `poc/scripts/audit_pad_861_contract.py`，固定包摘要不匹配即拒绝；已实际生成接口证据 JSON。
- 修正 Pad check：legacy 不计算 MAX HMAC；展示 profile 中的构建证据，并明确 check 不重新哈希、不证明 P0 完成。
- 新增针对上述误报的回归测试；17 项 Pad 相关测试通过。全量实际执行为 **205 passed, 1 skipped in 62.67s，退出0**；使用独立 `runtime/pad861-contract-full-20260916` basetemp。跳过不作通过计数。
- 最终实际 check 发现 p0_gaps 还有同类旧提示，已改为“产品及能力证据未齐”，不再否定已记录哈希。此最后文案修改后复验相关 **17 passed in 1.06s**，未再次运行全量。
