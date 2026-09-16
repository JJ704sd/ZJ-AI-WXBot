# 真实微信接入后端核验与适配准备

日期：2026-09-16。访问日期均为 2026-09-16。承接 A0–A1 离线闭环。本轮**未**购买、注册、部署、扫码、注入、真实收发或调用 M3。

代码基线：`157eecf` + 未提交 A1/A2-prep 实现。本机只读复核：Weixin **4.1.13.65**（`C:\Program Files\Tencent\Weixin\Weixin.exe`，LastWrite 2026-09-11）、WXWork **5.0.11.6018**。未切换账号、未重启或降级客户端。

判定等级：`documented` / `code_checked` / `observed` / `unknown` / `unsupported`。没有实测不得标 observed。

## 1. 候选比较（最多三个有实质证据者）

### 候选 A — 本机 Hook/RPC（WCFerry 原版及其 4.x 邻近实现）

| 项 | 结论 | 来源 |
|---|---|---|
| 产品 | WeChatFerry 原版已归档；fork `wukangcheng2944/WeChatFerry` 仍写死 3.9.12.51 | [S10][S11][S13] |
| 当前 PC | 4.1.13.65 | 本机 FileVersion，observed |
| 3.9.12.51 发布 | v39.5.2 明确配套 3.9.12.51 | [S11] |
| 4.1.13.65 Hook | **未找到**维护者文档写明该准确版本 | 定向检索 2026-09-16 |
| 邻近 4.x | `navysoto/wxhook` 仅 4.1.11.52；`KJinze/WeChat-Hook` / `aixed/WeChat-Hook` 仅 4.1.10.27；`lyx102/WeChatHook` README 写到 4.1.8 | [S14][S15][S16] |
| 写重试 | 原 client `_retry` 超时再发一次；失败可返回空 Response | [S12] code_checked |
| 成员查询 | `get_chatroom_members` 先扫 Contact 再读 ChatRoom | [S12] |
| 混合群企微 @ | unknown | 无本账号样本 |

**判定：** 对当前客户端为 **unsupported 作为即装依赖**。把 3.9.x 或 4.1.10/11/8 文档套到 4.1.13.65 没有一手依据。降级微信本轮未授权。

### 候选 B — GeWe API（设备/协议服务）

| 项 | 结论 | 来源 |
|---|---|---|
| 产品 | GeWe 开放平台，HTTP API + Webhook，SaaS 与私有化声明 | [S2] |
| 登录 | 控制台扫码把个微接成执行节点；7 天试用 Token 声明 | [S3] documented；本项目未注册 |
| PC 4.x | **不依赖**本机 Weixin 版本；底层是设备节点，不是 PC Hook | [S2] documented |
| 会话位置 | SaaS「只转发不存正文」为声明；私有化镜像/版本/报价 | unknown |
| 发送 | `POST /gewe/v2/api/message/postText`，头 `X-GEWE-TOKEN`，字段 `appId,toWxid,content,ats` | [S9] 2026-09-16 已读到 OpenAPI |
| 原生 @发送 | `ats` 为 wxid 逗号分隔或 `notify@all`；正文必须带 `@` 标记 | [S9] documented；企微成员是否生效 unknown |
| 成功语义 | 示例 HTTP 200 且 `ret=200`，`data.newMsgId` | [S9]；其它 `ret` 未逐码核实 |
| 回调 | 公网 POST JSON，3 秒内响应否则丢弃；API 发送不回显 | [S4] |
| 回调 v2 | 扁平 `appid,wxid,fromUser,toUser,newMsgId,msgType,createTime,isSelf,content`；去重 `appid+newMsgId`；重启/历史/重试会重复 | [S5] |
| 回调签名 | 文档未列出可验证签名 | unknown |
| 结构化 @接收 | v2 文字节未给出 at 字段 | unknown |
| 历史标志 | 只提示可能同步历史，无独立字段 | unknown |
| 在线探针 | `POST /gewe/v2/api/login/checkOnline`，`data` true/false | [S17] |
| 本人资料 | `POST /gewe/v2/api/personal/getProfile` → `data.wxid`（示例含手机号，适配器不得记录） | [S18] |
| 群成员 | `getChatroomMemberDetail` 用 `chatroomId+memberWxids`，可限定查询 | [S19] |
| 混合群 `@openim` | 示例群为 `…@chatroom` | unknown |
| 费用 | 试用声明外无公开价目 | unknown |
| HTTP 客户端重试 | 官方 SDK 未引入；本地适配器禁止重试 | code_checked |

**判定：可进入适配开发。不可进入只读联调，更未完成实机验收。** 阻断性缺口是运营性的（账号/试用/扫码/回调可达/身份映射），不是「没有发送字段可写」。A3 被动仅@仍被「接收侧无结构化 @字段」挡住，直到 A2a 观察到真实字段。

### 候选 C — Wechaty PadLocal

| 项 | 结论 | 来源 |
|---|---|---|
| 能力表 | 文本收发、群成员、@群员 | [S6] documented |
| 协议 | iPad puppet；TOKEN 申请+审核；beta | [S6] |
| 架构 | 流量走 puppet 本机，服务端号称无业务正文 | [S6] |
| 本项目 | 需 Node 桥；Token 可用性、费用、混合群 `@openim` | unknown |
| 与当前 PC 4.x | 不套用 PC 兼容条件 | documented as protocol |

**判定：** 备选。本轮不引入 Node 依赖。

## 2. 推荐

**推荐对象：GeWe API v2（`provider=geweapi`）。**

适合当前项目的原因：

1. 不要求改动或降级本机 4.1.13.65，符合「不降级客户端」约束。
2. 官方 OpenAPI 已给出 Channel 所需的发送、在线、本人、按群按人查成员字段；可在不猜测的前提下写 Adapter。
3. 自建优先仍保留：私有化是文档选项，SaaS 为声明中的快速路径；二者都要操作人决定采购/注册。
4. 本地 Hook 路线在当前准确版本上没有可核验后端，不能为了交付强行选型。

| 状态 | 含义 |
|---|---|
| 可进入适配开发 | **本轮达到**：`GeweChannel` 映射已核对字段，传输可注入，不打真实端点 |
| 可进入只读联调 | **未达到**：缺试用/Token、扫码节点、回调入口、账号群键 |
| 已完成实机验收 | **未达到** |

阻断性缺口（A2a 前必须由操作人决定，适配器不能自行补）：

- 是否接受 GeWe 注册/7 天试用或付费，以及数据走 SaaS 还是私有化。
- 扫码由操作人在 `http://manager.geweapi.com` 完成；本仓库不输出二维码。
- SaaS 回调要求公网 URL；内网穿透文档标明丢消息风险。私有化能否纯内网 **unknown**。
- 厂商回调无文档签名 → 必须在受控入口加 `X-Wechat-Bridge-Token`，否则不能武装。
- 混合群与企微原生 @、历史标志、结构化 @接收：unknown，A3/A4 不得宣称已通过。

不要用通用 HTTP 客户端冒充已验收厂商通道。`fake` 仍用于回归。

## 3. 询证清单（供用户发给供应商，本轮未发送）

1. 当前可交付的 SaaS 基址与私有化安装包/镜像摘要、版本号、许可证与报价（含试用是否允许混合外部群）。
2. 执行节点实际设备类型、会话与正文落在哪些主机、PC 微信是否会被挤下线。
3. Webhook 是否有签名/IP 允许名单/重放游标；3 秒超时后是否会再投、如何区分历史同步。
4. 企微/个微混合群的 `toUser` 是否可能为 `@openim`；群消息 `content` 是否带 `wxid:` 前缀。
5. 文字回调中真实 @ 的字段名与样例 JSON（不要用正文 `@昵称` 代替）。
6. `ats` 对企微成员是否产生对方客户端的原生 @ 提醒。
7. `ret` 非 200 时是否保证未发送；是否有写入幂等或状态查询。
8. `newMsgId` 是否可能超过 2^53，JSON 是否按字符串输出。

## 4. 本轮代码

- `poc/wechat_agent_poc/gewe_channel.py`：`authenticate_callback` / `normalize` / `probe` / `resolve_members` / `submit`
- 配置增加 `app_id_ref`、`callback_bridge_token_ref`；`api-status`/`api-stop`/`api-verify` 不构造 GeWe 通道
- 真实 HTTP 默认关闭；测试使用 opener 桩
- `poc/config.api.gewe.example.toml`、`poc/provider-profile.gewe.example.json`

## 5. 一手来源

- [S2] https://doc.geweapi.com/ 平台介绍
- [S3] https://doc.geweapi.com/doc-3146201 快速开始（试用 Token、扫码节点）
- [S4] https://doc.geweapi.com/doc-3146208 Webhook（3s、公网、无 API 回显）
- [S5] https://doc.geweapi.com/doc-8680561 回调 v2.0
- [S6] https://wechaty.js.org/docs/puppet-providers/padlocal/ PadLocal
- [S9] https://doc.geweapi.com/api-139908313 发送文字 OpenAPI（本轮已读到）
- [S10] https://github.com/lich0821/WeChatFerry 归档原仓库
- [S11] https://github.com/lich0821/WeChatFerry/releases/tag/v39.5.2 配套 3.9.12.51
- [S12] https://github.com/lich0821/WeChatFerry/blob/master/clients/python/wcferry/client.py
- [S13] https://github.com/wukangcheng2944/WeChatFerry 仍为 3.9.12.51
- [S14] https://github.com/navysoto/wxhook 4.1.11.52
- [S15] https://github.com/KJinze/WeChat-Hook 4.1.10.27
- [S16] https://github.com/lyx102/WeChatHook README 至 4.1.8
- [S17] https://doc.geweapi.com/api-139908282 checkOnline
- [S18] https://doc.geweapi.com/api-139908355 getProfile
- [S19] https://doc.geweapi.com/api-139908301 getChatroomMemberDetail

## 6. 测试与未验证项

见同日 A2 准备记录。本轮不以 A1 的 153 passed 代替新结果。A2a–A4 **未执行**。
