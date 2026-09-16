# WeChatPadPro 技术核查与业务适配评估

日期：2026-09-16。范围：公开仓库、仓库链接的维护方文档、现有项目接口及关联任务。未下载或运行网关二进制，未注册、购买、扫码、配置真实回调、收发消息或调用模型。

## 1. 结论

**可将 WeChatPadPro 作为下一轮自建协议网关的重点验证对象；目前不能认定它已解决混合群真实 @、历史消息隔离和当前账号可用性。** 推荐采用“自建网关 + 私有接入 + 现有 Python Agent”，先固定产品与构建，再做独立观察器。新路线见 [v0.6 方案](personal-wechat-agent-poc-v0.6-wechatpadpro.md)。

最重要的区别是：用户提供的 GitHub 仓库与其指向的在线文档，已经不是一个可以直接互换字段的版本集合。不能拿旧镜像搭配 MAX 新文档编码，也不能因接口名存在就解除现有自动回复阻断。

## 2. 证据范围与版本分叉

| 对象 | 本轮核实 | 工程含义 |
|---|---|---|
| GitHub `main` 文件树 | API 目录读取及 `git ls-remote` 复核 main SHA 为 `5cf4fc76c5457691798079bd921e09f60cf5afd7`；目录主要为 deploy、redis、static 和文档，没有协议核心 `.go`、`go.mod` 或服务端实现，也未见 LICENSE | 这是公开交付资料，不足以审计协议实现、编译复现或确认再分发权利；不把“Public”写成完整开源 |
| README | 首页称 v875，下载段仍列 v860 | 首页版本不能作为二进制版本锁 [S1] |
| `version.txt` | `ios18.61-861`，构建 `20250822_153444`，Linux amd64 | 只证明该文件的声明，不能证明运行镜像版本 [S2] |
| Releases | 页面 Latest 是 tag `v2.01`，标题 `WeChatPadPro861-18.61v0.2.1` | release tag、标题、协议号须分别记录；“修复 webhook”属于维护者声明 [S3] |
| 当前在线文档 | 标题 WeChatPadProMAX；快速开始提及 `wechatpadpromax08`、`conf/app.conf` 和云端 Token | MAX 文档是独立的待锁定契约，不代表公开旧包具备同样接口 [S6] |
| 当前根目录 `webhook_config.json` | 0 Bytes | 无可用默认配置；旧发布说明中的示例才是文档来源 [S3、S4] |

旧版 README 的 `/api/login/...`、旧 `.env`，与 MAX 的 `/Login/...`、`/Msg/...`、双 Token 不能拼接成一个“最新通用 API”。本轮没有取得与某个 MAX 二进制一一对应的 OpenAPI 导出和样本集。

核查方法：GitHub API 读取递归文件树，按 SHA 读取公开文件，Web 工具读取维护方链接。部分 PowerShell HTTPS 请求遇到 TLS/EOF，改用网页核对；没有把失败请求当成空文档。群成员详情页读取失败，未据导航标题编造字段。

## 3. 技术机制及可确认边界

协议网关独立维护微信设备会话，通过 HTTP 提交动作，通过 Webhook/消息流输出消息；它不是控制本机 PC 窗口的 UIA Sender。由此推断，新通道无需依赖本机微信 UI 元素或 PC Hook 偏移，但**手机/PC/Pad 是否能并存、具体账号是否能登录仍需实机验证**。

公开旧部署文件使用网关镜像、MySQL 8.0 和 Redis 6；网关镜像默认 `latest`，映射 8080/1238，数据库也映射宿主端口。Redis 启动命令未见 requirepass；网关卷只挂 `.env`，未挂根目录 webhook JSON。不能直接照搬到业务环境，也不能假设在仓库根修改 JSON 会进入容器。[S5]

MAX 快速开始只明确 Redis、Linux 二进制和云端 Token 管理，未证明仍需要旧 MySQL 拓扑。Token 申请/设备授权/登录初始化属于控制面；会话、正文是否经过外部服务及断开云端授权服务后的行为，本轮未知。自建进程不等于完全离线或数据绝不出网。[S6]

旧配置存在任务重试、自动认证、自动同步和 WebSocket 参数，但缺少对应源码，无法判断重试是否覆盖发送动作。**HTTP 客户端零重试不能证明网关内部零重发。** [S7]

## 4. MAX 接口核查表

以下只对当前在线文档成立，状态均为 `documented`，不是 `observed`。

| 能力 | 文档内容 | 仍须确认 |
|---|---|---|
| 登录 | 获取授权 → 二维码 → 检查 → 初始化；存在不同设备登录入口 | 固定构建的实际端点、鉴权、本人 ID、设备并存和重新登录行为；不自动轮换设备规避失败 [S6] |
| 发文本 | `POST /Msg/SendTxt`；`ToWxid, Content, Type, At`；示例含 `X-Access-Token`、`X-Cloud-Access-Token` | `Type` 实际文字值、At 单人编码及正文配合、企微成员有效性；不能把示例 `Type=0` 当枚举定义 [S8] |
| 发送结果 | 示例 `Code=0, Success=true`，含 `Data.new_msg_id, local_id, to_wxid, request_id` | 受理与送达分开；缺 ID、部分响应或非成功码执行语义均需验证 [S8] |
| 收消息 v1 | 顶层 `Wxid, MessageType, Timestamp, Signature, Data.messages`；逐条 `newMsgId, createTime, fromUser, toUser, isSelf, msgType, text` | 文档没有明确真实 @接收字段、历史标志；群例仅 `@chatroom` [S9] |
| 收消息 v2 | `/Msg/Sync` 提到 `wechatpad.message.v2`、`reply_context`，同步会同时投递 WS/Webhook | 未取得完整 v2 schema；不能用 v1 parser 自动兼容，更不能让 Sync 与 Webhook 重复触发业务 [S10] |
| 在线状态 | `GET /User/GetOnlineInfo`，响应示例 Data 为空 | 无法根据示例定义本人及 online 布尔映射；HTTP 200 不表示微信在线 [S11] |
| 群成员 | 导航有获取群成员详情、企业扫码进群等入口 | 详情读取失败；企业进群不证明本目标混合群、成员稳定键或原生 @可用 [S6] |
| Webhook 配置 | `POST /Webhook/Set`，`url,secret,messageTypes,includeSelfMessage,enabled,timeout,retryCount,enabledSet,retryCountSet` | 空值/零值覆盖及最终生效配置需读回；属于配置写操作 [S12] |
| WebSocket | 页面给 `/ws/sync`，标记开发中 | 认证、恢复游标、确认、丢失窗口未确认；不选首版主通道 [S13] |

不要复制网页中的示例 Token。本轮未调用这些业务接口。

## 5. 回调签名存在两个具体问题

维护方文档的签名输入是 `Wxid:MessageType:Timestamp`，使用 HMAC-SHA256，输出小写十六进制。[S14]

**问题一：该算法不覆盖 Data。** 持有一份仍在时间窗内的合法 envelope 者，若可访问接收入口，可修改内部正文、发送者或消息 ID 而不改变该签名。TLS 可以保护传输，但公开接收端不能只靠此签名证明整条消息完整性。该结论来自文档公式及合成复算，不是对真实服务的攻击验证。

**问题二：页面的两条测试向量与公式不符。** 使用公开示例 secret `your-signature-secret`，`Wxid=wxid_xxxxxxxxxxxxxxxx`，`MessageType=sync_message`，UTF-8 计算结果如下：

| Timestamp | 本地计算 HMAC-SHA256 |
|---|---|
| 1757156304 | `699e83ec24d08e47974a3b51c2d7d961cc584b2dccc26added40524d662e68aa` |
| 1757156307 | `550a69a5420c5e82000ad954e7f944fd11e729db04efd5cae763a4a1202a0876` |

二者均与页面列值不一致；可能是文档样例错误或实际算法不同，不能据此断言线上实现必错。离线修改 `Data.messages` 后按该公式签名保持一致，结果为 True。可复现：

```python
import hashlib, hmac
for timestamp in (1757156304, 1757156307):
    payload = f"wxid_xxxxxxxxxxxxxxxx:sync_message:{timestamp}".encode("utf-8")
    print(hmac.new(b"your-signature-secret", payload, hashlib.sha256).hexdigest())
```

新方案的安全依据应来自已验证的私有通道/明确的发送端身份，或提供方真正支持且覆盖完整负载的认证。不能发明供应商不会发送的签名字段，不能把反向代理统一加头等同于来源证明。仅验证现有 envelope 签名时单独记录 `metadata_signature_valid`，不升级为 `payload_integrity_verified`。

## 6. 业务适配性

目标沿用本地 v0.5：一个个微号、一个企微/个微混合群，文字问答，真实仅 @本人触发；一次性预设任务在 120 秒后 @1–2 个目标，每人最多 600 秒、追加 3 次，有界收集收到/愿意继续两项。定时与对话策略由本地 Agent 执行，不要求网关提供业务调度。

| 业务要求 | 适配判断 | 放行证据 |
|---|---|---|
| 收到群内 @后及时回复 | API 形态适合，关键语义未闭合 | 当前构建真实 @元数据、群内原始发送者、新消息判据、20/20 接收样本 |
| 定时 @企微成员 | 有 At 参数线索，尚不能承诺 | 单个企微目标客户端出现原生 @提醒，稳定目标键和准确请求编码 |
| 相关回复继续交流 | 现有本地运行器设计可复用 | 目标身份、会话关联、停止/无关输入测试；不需要开放任意网关 API 给模型 |
| 重启不补答历史 | 已知实质风险 | 官方老用户指南提示历史消息风暴；需要同步完成/基线证据，时间戳和 LRU 单独不充分 [S15] |
| 业务操作唯一出口 | 默认不能假定 | 旧功能文档包含好友自动回复、自动加好友、红包及群管理等动作；需确认所选构建全部关闭，不能盲发切换命令 [S16] |
| 长期稳定在线 | 未验证 | 30 分钟 PoC 不代表长期稳定性；协议维护和授权服务依赖须持续记录 |

收到普通文字并不等于能正确识别 @；发送 `@姓名` 并不等于企微端被原生 @。当前没有本测试号/群的 WeChatPadPro 实机证据。

## 7. 对现有工程的影响

本轮读取关联任务“补充个微API Agent方案信息”，并检查本地 `api_channel.py`、`api_config.py`、`api_runtime.py`、GeWe 通道及观察服务。实际情况：

- `Channel` 已具备认证、单消息 normalize、probe、成员解析和 submit 边界；可以扩展新 provider。
- 当前 provider 仅 fake/geweapi，模型配置仅 mock；`ApiRuntime.start()` 明确拒绝 live。**新增 Pad 适配器不是打开一个配置即可运行真实 Agent。**
- 现有观察服务仍直接依赖 GeWe 类，不能只换 base URL；需要 Pad 专用入口与批次接收器。
- G2a 证据记录 184 passed、G2b 缺 Caddy；本轮只读取该记录，未重跑、不继承为 Pad 验收。
- 工作区在研究期间有其他任务提交/编辑变化；最后读取 HEAD 为 `8a2191b279274a862223418646ada07310df43ca`，两份既有 GeWe 证据文件有未提交修改。本轮只新增独立方案文件。

## 8. 建议推进次序

先完成产品/构建与契约锁定，随后本地合成回调适配；再选择主机和授权方式，做真实只读采样，最后逐步开放固定 ACK、原生 @和有界 Agent。当前 GeWe 路径保留为已有资产；其公网 G2b 不再是 Pad 自建内网路线的前置条件，也不应继续把 GeWe 字段假设迁入新通道。

需向维护者核对的最小清单（本轮未发送）：MAX 与公开 release/镜像对应关系、交付哈希及使用条款/费用；完整 v2 schema 和真实 @字段；混合群及企微成员示例；新旧消息判据与重放语义；签名向量/负载覆盖；发送内部重试/幂等/查询；关闭内置动作的方法；云端授权与正文/会话数据路径；本人/在线/群成员的准确响应。

## 9. 一手来源

- S1 [GitHub README](https://github.com/WeChatPadPro/WeChatPadPro)。
- S2 [固定 SHA 的 version.txt](https://github.com/WeChatPadPro/WeChatPadPro/blob/5cf4fc76c5457691798079bd921e09f60cf5afd7/version.txt)。
- S3 [Releases](https://github.com/WeChatPadPro/WeChatPadPro/releases)。
- S4 [webhook_config.json](https://github.com/WeChatPadPro/WeChatPadPro/blob/5cf4fc76c5457691798079bd921e09f60cf5afd7/webhook_config.json)。
- S5 [部署 Compose](https://github.com/WeChatPadPro/WeChatPadPro/blob/5cf4fc76c5457691798079bd921e09f60cf5afd7/deploy/docker-compose.yml)。
- S6 [MAX 快速开始](https://wx.knowhub.cloud/)。
- S7 [旧配置示例](https://github.com/WeChatPadPro/WeChatPadPro/blob/5cf4fc76c5457691798079bd921e09f60cf5afd7/.env.example)。
- S8 [发送文本](https://wx.knowhub.cloud/356821064e0)。
- S9 [Webhook 消息 v1](https://wx.knowhub.cloud/7359730m0)。
- S10 [同步消息及 v2 声明](https://wx.knowhub.cloud/356821073e0)。
- S11 [在线信息](https://wx.knowhub.cloud/356821121e0)。
- S12 [设置 Webhook](https://wx.knowhub.cloud/356821136e0)。
- S13 [WebSocket](https://wx.knowhub.cloud/3675280w0)。
- S14 [签名算法](https://wx.knowhub.cloud/7359735m0)。
- S15 [历史同步说明](https://github.com/WeChatPadPro/WeChatPadPro/blob/5cf4fc76c5457691798079bd921e09f60cf5afd7/usage_guide_for_old_users.md)。
- S16 [内置功能说明](https://github.com/WeChatPadPro/WeChatPadPro/blob/5cf4fc76c5457691798079bd921e09f60cf5afd7/微信功能使用说明.md)。

以上为本日公开资料核查；服务端内部实现、二进制实际行为和真实业务适配均不在已验证范围。
