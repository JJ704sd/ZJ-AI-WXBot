# WeChatPadPro P0：可交付构建与契约取证

日期：2026-09-16。读者：产品/实施决策。状态：公开资料取证完成，**P0 仍未闭合**。未下载 zip/镜像、未登录维护者控制台、未生成授权码、未采购、未扫码、未启动网关。

配套：[技术研究](wechatpadpro-technical-research-2026-09-16.md)、[v0.6 方案](personal-wechat-agent-poc-v0.6-wechatpadpro.md)、[P1 离线证据](../poc/evidence/p1-wechatpadpro-offline-2026-09-16.md)。

## 执行摘要

当前阻塞不是 Agent 或发送功能，而是**没有一份“构建 ↔ 文档 ↔ 授权”对齐的交付物**。

公开网络上现在只有一类可核对待下载包：**GitHub Latest `v2.01` / 标题 `WeChatPadPro861-18.61v0.2.1`**，并带 GitHub 声明的 zip SHA-256。这是 **legacy 861 线**，不是 MAX。v0.6 推荐调查的 MAX（文档文件名 `wechatpadpromax08`、控制面 Token、`/Login` `/Msg`）**没有公开 zip、没有哈希、没有与该二进制绑定的文档导出**。README 另称 v868 在赞助群、首页下载表仍写 v860。这些标签不能合成一个版本。

因此：在操作人选定 MAX 或 legacy，并拿出该构建的本地哈希与配套接口导出之前，不能设计具体 P2 主机部署，也不能把真实 @、混合群、历史判据标成支持。

## 调研范围与证据

已检查（只读）：

- GitHub Releases API `releases/latest`（tag `v2.01`，资产名、size、digest）
- `version.txt` @ `5cf4fc76c5457691798079bd921e09f60cf5afd7`
- README 当前文案（v868 赞助群、v860 下载表、Swagger 指向 wx.knowhub.cloud）
- MAX 文档：快速开始、Webhook v1 响应体、Webhook 签名 v1、发送文本、同步消息、获取在线信息
- 仓库 `.env.example`（任务重试、`DISABLED_CMD_LIST`、MCP）
- 本地 `pad-provider-profile/1` 与 P1 离线测试；未重跑 184 passed 作为本轮结果

未访问：维护者控制台（`cloud.wechatpadpro.com` / `adminmax.knowhub.cloud`）、赞助群、套餐购买页实价、zip 本地字节、运行中的网关、真实微信。

文档页上的示例 Token / 默认管理员密钥只当作“页面存在该字段”的证据，不写入可运行配置，不使用。

## 1. 交付物：现在能锁什么、还缺什么

| 项 | MAX（v0.6 调查对象） | legacy GitHub Latest v2.01 |
|---|---|---|
| 产品族 | 已验证事实：文档标题 WeChatPadProMAX | 已验证事实：release 标题 WeChatPadPro861-18.61v0.2.1 |
| 准确版本 | 未验证：`wechatpadpromax08` 只是文档里的文件名；README 另写 v868 | 已验证事实：zip 名 `ios18.61-861` + `20250822`；`version.txt` 写 `20250822_153444` linux amd64 |
| 下载来源 | 未验证：公开 Releases 无此文件名 | 已验证事实：`https://github.com/WeChatPadPro/WeChatPadPro/releases/download/v2.01/wechatpadpro_vios18.61-861_20250822_<os-arch>.zip` |
| 构建哈希 | unknown | GitHub API 声明了各 zip 的 `digest`（见夹具）。**不是**本机对下载文件的 observed 哈希 |
| 许可费用 | 已验证事实：文档写后台有套餐/Key 上限。金额、账期 unknown（需登录购买页） | 未验证：README 有赞助/付费专业群；再分发权利未见 LICENSE |
| 配套文档导出 | unknown：在线 Apifox/KnowHub 页面会变，没有与 `wechatpadpromax08` 绑定的导出 SHA-256 | unknown：`static/swagger` 在 `5cf4fc76` 为 404；README 的 `WeChat849.apipost.v7.json` 不能当 861 包的匹配导出 |

候选 Linux 包（若产品改选 legacy，且操作人授权下载后本地复核）：

- 文件：`wechatpadpro_vios18.61-861_20250822_linux-amd64.zip`
- GitHub 声明：`sha256:9367619f6c882f691172c44acfab59581571c9c37b9f6e01db0138b2793bd048`（size 23976531）
- Windows 对照：`wechatpadpro_vios18.61-861_20250822_windows-amd64.zip` / `sha256:4500ab14ac22b71146705ed2dc0046af4ee6ed555a617ba99430e1e1546d9430`

夹具：`poc/fixtures/pad/github-v2.01-release-assets.json`（`kind=document_fixture`，`not_observed=true`）。

**推荐决策（待确认）：** 继续以 MAX 为业务目标，则必须由操作人从控制台或赞助渠道取得 **一份** `wechatpadpromax08`（或该渠道给出的准确文件名）、本地 SHA-256、以及**同一次导出**的 OpenAPI/Webhook 文档。不要用 v2.01 zip 去对接 MAX `/Msg/SendTxt`。若接受 861 公共包作为 PoC 网关，则单独走 legacy profile，文档只引用 GitHub 861 材料。

## 2. 运行边界：文档有线索，构建未读回

| 主题 | 已验证事实 | 合理推断 | 未验证 / P2 前置 |
|---|---|---|---|
| 会话与正文路径 | MAX 文档要求 `conf/app.conf` + Redis；legacy `.env.example` 含 MySQL 连接串、Redis、可选 MQ | MAX 可能不再需要公开 compose 里的 MySQL；不能把旧库硬套给 MAX | 选定构建后列出实际数据目录、重启后会话是否仍在、备份是否含凭据 |
| 外部授权 | MAX：Telegram/GitHub 登录后台 → TokenKey → `/Admin/GenAuthKey` → device token。文档还出现云端 Token 头 | 自建进程仍依赖外部授权服务；断网后能否收发 unknown | 记录授权主机、刷新、正文/会话是否出网；费用与 Key 上限从购买页抄录 |
| 内置自动化 | legacy `.env.example` 有 `DISABLED_CMD_LIST`（空）、`MCP_PORT`、`GH_WXID` 首次登录推广、`AUTO_AUTH_INTERVAL`、`AUTO_SYNC_INTERVAL_MINUTES` | 存在后台任务与推广入口，不能称“无发送能力网关” | 关闭好友/红包/群管理/转发/模型/自动回复的**具体命令名或开关**，以及读回方法；MAX 是否仍有这些项 |
| 发送内部重试 | `TASK_RETRY_COUNT=3`、`TASK_RETRY_INTERVAL=5`；Webhook 文档 `retryCount: 3` | 重试可能覆盖回调、内部任务或微信发送，范围不明 | 对固定构建抓日志或配置，区分回调重投与微信重发 |

P2 部署单在下列空格填齐之前不应开工：目标主机/OS、选定 flavor 的文件名与**本地** SHA-256、运行依赖（Redis/MySQL 以该构建为准）、许可费用、授权与数据路径、私有回调拓扑、内置动作关闭及读回。

## 3. 接口语义：文档可写清验收，不能提前标支持

以下仅对 **MAX 在线文档**成立，状态保持 `documented` 或 `unknown`，**不是 observed**。

| 语义 | 文档现状 | P0 可预先列出的验收 | 不得提前写成 |
|---|---|---|---|
| 消息 schema v1 | 顶层 `Wxid, MessageType, Timestamp, Signature, IsSelf, Data.messages`；条内 `newMsgId, createTime, fromUser, toUser, isSelf, msgType, text` 等。`msgType` 文档为数字（1 文本） | 固定构建上 20 条样本字段与文档一致或记录差异；v2 单独隔离 | “已支持 v1/v2 兼容” |
| 消息 schema v2 | `/Msg/Sync` 提到 `wechatpad.message.v2`、`reply_context`，响应示例 Data 为空 | 取得完整 schema 或明确拒绝 v2 | 用 v1 解析器吞 v2 |
| 本人 | 条内 `isSelf`；顶层 `IsSelf` 文档写明以条内为准 | 与独立身份探针对照，冲突则 unknown | 只信回调 body |
| 在线 | `GET /User/GetOnlineInfo` 成功示例 `Data: {}` | 映射表来自实机响应，HTTP 200 不够 | online=true |
| 混合群身份 | 群例 `fromUser` 为 `…@chatroom`；前缀规则把发送者从 `text` 拆出。文档未给企微/`@openim` 样本 | P3：绑定群精确匹配；企微与个微来源各 10 条；成员稳定键 | 凡 `@chatroom` 即本目标群 |
| 真实 @ | 无 @ 元数据字段；`pushContent`/`text` 不能当结构化 @ | P3 反例：仅 @本人 / @他人 / 伪 @ / 引用中的 @ | mention_status=structured |
| 历史判据 | 无 `isHistory`。`msgType=51` `lastMessage` 被写成游标线索；老用户指南另有历史风暴 | P3：同步完成/基线证据；时间新 ≠ 非历史 | history_status=false |
| 群前缀 | 文档正则：`fromUser` 以 `@chatroom` 结尾且 `text` 为 `{wxid}:\n正文` | 仅在该构建 observed 后拆一次并校验成员 | P1 已按未知处理，保持 |
| At / Type | `At` 为 string，`Type` 为 int64；当前发送页示例如 `Type: 1`（与更早页面 `Type: 0` 不一致） | 固定构建上 ACK 与原生 @ 分列验收 | 枚举已定义、企微原生 @ 可用 |
| HMAC | 公式不覆盖 Data。页面向量 `1757156304→df5f…c510`、`1757156307→54cd…2a80`；本地标准 HMAC 为 `699e…68aa` / `550a…0876`。页面称“已核对无误” | 对该构建用合成信封验证实际算法；业务触发仍靠私有通道 | 为迎合页面修改标准 HMAC；仅凭元数据签名授权自动回复 |

夹具：`poc/fixtures/pad/document_hmac_vectors.json` 已写入页面列值，并保持 `document_page_vectors_match_formula=false`。

## P3 预列验收（保持 unknown，不标支持）

绑定：唯一测试号、唯一混合测试群、操作人扫码、最长 30 分钟、独立观察库、零 API 发送、零模型调用。关闭内置自动化未证明前，先解决网关自身动作边界。

| ID | 项目 | 通过口径 |
|---|---|---|
| P3-01 | 个微来源 | 10/10 入观察库且不重入 |
| P3-02 | 企微来源 | 10/10 入观察库且不重入 |
| P3-03 | @本人 | 结构化或等价厂商字段证明仅 @本人 |
| P3-04 | @他人 | 不触发 |
| P3-05 | 伪 @ / 正文 @ | 不触发 |
| P3-06 | 引用中的 @ | 不触发 |
| P3-07 | 本人消息 | is_self 与探针一致 |
| P3-08 | 历史/重放 | 有正反例；不能把 unknown 改名为 false |
| P3-09 | 跨群/私聊 | 正文不落业务库 |

## 待决策项

1. **目标 flavor**：继续 MAX，或改用可哈希的 v2.01 861 包。最晚在任何下载/P2 设计前决定。默认建议：MAX，因业务接口文档在这一边；代价是必须走控制台/赞助渠道拿构建。
2. **谁去取得 MAX 包**：操作人登录后台或赞助群；本环境不登录、不生成授权码。
3. **是否接受 GitHub zip digest 作为下载前核对值**：可以写入部署单；闭合 P0 仍要求本机对文件做 SHA-256 并保存文档导出哈希。
4. **许可**：未看到公开价目。采购前把金额、有效期、Key 上限抄进 profile。

## 明确不做

不扩展 Agent、不增加发送入口、不设计具体 P2 主机、不把离线 P1 通过写成网关可用。更换构建会使旧 documented/observed 能力作废。
