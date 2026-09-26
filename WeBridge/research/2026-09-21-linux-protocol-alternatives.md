# Linux 自建微信协议候选补查

核查日期：2026-09-21。目标是个人微信账号参与企微创建的混合外部群，持续收消息、主动发送、真实 @ 微信和企微两类成员、识别被 @ 后回复。这里只补查协议核心和原作者发行，不把 Agent、SDK 或远端商业 API 调用器算成自建核心。

**本轮没有找到可确认“当前能用、完整源码可重建、混合外部群全部能力已验证”的新增 Linux 实现。** 最有价值的新增是 `iwechatcom/iwechat`：实际提供 Linux 二进制，并且随包 Swagger 明确列出企业群接口和 @ 字段；但它是 2025 年的闭源发行，当前登录有效性、远端依赖和目标群完整链路均待实测。`nsky99/wechatclient` 适合协议研究，`WeProtocol` 则不能因新镜像的提交日期而升级判断。

## 核查表

| 候选 | 可验证的 Linux / 自建证据 | 核心、维护与外部依赖 | 混合群与真实 @ 证据 | 本轮判断 |
|---|---|---|---|---|
| **[iwechatcom/iwechat](https://github.com/iwechatcom/iwechat/tree/6534f0ad9ce3e9ef21208555d815a2ae032d802a)** | 原作者仓库有 Linux `myapp`、Mac `mac_myapp`、Windows `myapp.exe`；Dockerfile 使用 Ubuntu 22.04，把 `myapp` 复制进容器，安装本地 MariaDB、Redis、curl。README 提供 v2.6 Docker 镜像。 | 只有二进制和接口资料，没有协议核心源码。最新提交 **2025-05-29**，更新日志截至 2025-05-28；没有据此断言停服。README 声称免费、限 2 账号，当前有效性未验证。文档存在本地管理授权码接口，但这既不能证明需要厂商授权服务器，也不能证明完全离线自主。 | 随包 Swagger 有 `/qy/QWSyncChatRoom`、`/qy/QWGetChatRoomMember`、`/qy/QWAcceptChatRoom` 等企业群专用接口；通用 `/message/SendTextMessage` 的 `MessageItem.AtWxIDList` 是明确的 @ 用户列表；有 HTTP / WebSocket 消息同步。**没有两类成员的真实回调与发送结果、也没有企业群发送的端到端示例。** | 可进入小规模验收的**闭源 Linux 候选**；本轮不能称为当前可用方案，更不能称为公开源码可重建。 |
| **[nsky99/wechatclient](https://github.com/nsky99/wechatclient/tree/e1344339139a8a8a0b961ad3ee04c156ec23d8fb)** | 有真正的 Go `mmtls`、封包、登录、NewSync、发送消息代码；配置直指微信长短连接域名。不是单纯调用商业服务的 HTTP 外壳。 | 最新提交 **2025-05-13**，无发布产物。Go 1.21.3；登录代码仍写 Windows 微信 3.9.9.43 的签名文本。未做编译、运行或登录验证。所查运行代码未发现 `v08` 依赖；仓库 Windows `protoc.exe` / DLL 位于 protobuf **工具**目录，不能据此认定服务必须跑 Windows。也不能由此证明所有必要协议逻辑完整。 | 发送结构只有收件人、内容、类型、消息 ID，`MsgSource` 写死，没有 @ 列表入参。NewSync 提供协议同步请求，但所查接口未给出企微外部群 / `@openim` 的专项支持证明。 | **协议研究材料**，不是满足现有需求的现成 Linux 服务；当前登录和群能力要另行补齐验证。 |
| **[G5t4r/WeProtocol](https://github.com/G5t4r/WeProtocol/tree/a9b30f7b1b07e9cecae20d1eba380b4b3b779fc2)** 与 **[waud876/WeProtocol](https://github.com/waud876/WeProtocol/tree/3883d371a77396acd12ae978da85c5ee4c4dc22c)** | 旧仓库有 Go 协议代码、Linux 动态库加载器、`lib/libv08.so`；这表示有 Linux 路径，不代表纯源码可重建。 | G5t4r 最后提交 **2025-08-15**，依赖闭源 `v08` 二进制。waud876 虽在 **2026-08-21** 提交，但其 102 个文件中 **100 个在同路径的 Git blob SHA 与旧仓库完全一致**，仅 README / LICENSE 不同，且缺少旧仓库的 `main.go`、models 等完整结构。不能当作协议升级。 | 有企业联系人相关控制器；没有新增证据证明当前混合群完整收发和两类成员 @。 | 属于旧 `v08` 依赖路线的同质候选，**不增加优先级**；不把镜像更新当作核心维护。 |

## 有价值的新证据：iwechat 的企业群接口

[固定版本 Swagger](https://github.com/iwechatcom/iwechat/blob/6534f0ad9ce3e9ef21208555d815a2ae032d802a/static/swagger/swagger.json) 同时包含以下能力声明：

- `/qy/QWSyncChatRoom`：同步企业微信群；`/qy/QWGetChatRoomMember`：提取企业群全部成员；`/qy/QWAcceptChatRoom`：同意进企业群。
- `/message/SendTextMessage` → `SendMessageModel.MsgItem[]` → `MessageItem.AtWxIDList[]`：真实 @ 所需的结构化成员标识输入，区别于只拼接可见的 `@名字`。
- `/message/HttpSyncMsg` 与 `/ws/GetSyncMsg`：收消息接口；[README](https://github.com/iwechatcom/iwechat/blob/6534f0ad9ce3e9ef21208555d815a2ae032d802a/README.md) 还记录 HTTP 回调支持。

这些证据足以说明“值得验收”，仍不足以说明“验收会通过”。Swagger 的企业群成员参数还写着普通 `xxx@chatroom` 示例，未附 `@im.chatroom` / `@openim` 的真实请求与响应；通用发送接口是否能向目标企业群发送并正确 @ 两类成员，必须独立验证。回调是否全量、断线能否补齐、被 @ 元数据是否保留，同样尚未验证。

[Dockerfile](https://github.com/iwechatcom/iwechat/blob/6534f0ad9ce3e9ef21208555d815a2ae032d802a/Dockerfile) 只是封装作者现成二进制，没有从源码构建核心；“Docker 能部署”和“核心完全自主”是两个不同结论。原版公开资料不足以判定它是否联网注册、多久校验授权、是否调用远端协议组件。此处不采用第三方修改授权/账号限制的发行版作为证据或替代路径。

## 源码判断的依据

`nsky99/wechatclient` 的 [发送实现](https://github.com/nsky99/wechatclient/blob/e1344339139a8a8a0b961ad3ee04c156ec23d8fb/pkg/wechat_sdk/mmscene/scene/net_scene_send_msg_new.go#L11)、[同步实现](https://github.com/nsky99/wechatclient/blob/e1344339139a8a8a0b961ad3ee04c156ec23d8fb/pkg/wechat_sdk/mmscene/scene/net_scene_newsync.go#L10)、[微信连接配置](https://github.com/nsky99/wechatclient/blob/e1344339139a8a8a0b961ad3ee04c156ec23d8fb/pkg/wechat_sdk/config/wxclient_config.go#L18) 证明公开的是实际协议逻辑；[登录实现](https://github.com/nsky99/wechatclient/blob/e1344339139a8a8a0b961ad3ee04c156ec23d8fb/pkg/wechat_sdk/mmscene/scene/net_scene_manual_auth.go#L50) 也清楚暴露其旧版本假设。这些源码有研究价值，但不能替代当前微信服务器上的登录和消息验收。

`G5t4r/WeProtocol` 的 [v08 加载器](https://github.com/G5t4r/WeProtocol/blob/a9b30f7b1b07e9cecae20d1eba380b4b3b779fc2/clientsdk/v08/v08.go#L23) 只为 Windows / Linux 选择 DLL / SO，其他平台直接 panic；[Linux 实现](https://github.com/G5t4r/WeProtocol/blob/a9b30f7b1b07e9cecae20d1eba380b4b3b779fc2/clientsdk/dynlib/linux.go#L1) 使用 CGO / dlopen。`Model=MAC` 之类登录身份不能消除宿主机的动态库限制。镜像相同比较来自两仓库固定版本的完整 [G5t4r Git tree](https://api.github.com/repos/G5t4r/WeProtocol/git/trees/a9b30f7b1b07e9cecae20d1eba380b4b3b779fc2?recursive=1) 和 [waud876 Git tree](https://api.github.com/repos/waud876/WeProtocol/git/trees/3883d371a77396acd12ae978da85c5ee4c4dc22c?recursive=1)，不是根据项目名推断归属；本轮没有证明它们与其他同名核心的作者或授权关系。

## 后续筛选边界

如果需要继续一条新增协议路线，先只验收 iwechat 原作者能否提供**当前 Linux 版本和正常授权方式**。验收应包含测试个人号进入企微创建外部群、收取两类成员普通消息、主动发送、分别真实 @ 两类成员、识别被 @、断线恢复及消息补齐；再核对进程访问的域名与授权机制。全部通过后才讨论用于业务或购买源码。

Mac / Windows 的 Agent 都可以访问 Linux 节点的 HTTP / WebSocket 接口，这是应用端跨平台。iwechat 声明三种宿主机文件，但未公开明确 CPU 架构与可复现构建，**不能据此承诺 Apple Silicon 原生支持**。本轮未安装、构建、执行这些候选，也未登录微信、联系供应商或支付费用。
