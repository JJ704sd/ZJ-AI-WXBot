# Linux ARM64 自建协议执行核查

执行日期：2026-09-21；环境：macOS ARM64 上的 Docker Desktop 4.83.0 / Linux ARM64 Engine 29.6.2。

**`nsky99/wechatclient` 能原样编译为 Linux ARM64 静态程序并获取二维码，但真实认证已被服务器拒绝。** 后续主线测试中，用户扫码确认得到 `status=2`，再调用 `secmanualauth` 返回 `ret=-106`，服务器明确提示“当前微信版本过低”。因此当前结论是：**构建、MMTLS 和扫码前置链路通过，账号认证受阻，不能作为可用收发方案**。原 Linux 微信客户端仍在线。该结果来自本任务主线的实际测试回报，本分支未再次扫码或重试认证。对照的 iwechat 原作者 Linux 发行包是 **AMD64 闭源程序**，并含远端注册/许可线索，暂不符合完整自主 ARM 核心的目标。

## 执行结果

| 核查项 | 实际结果 | 证据与边界 |
|---|---|---|
| 固定源码 | `nsky99/wechatclient`，提交 `e1344339139a8a8a0b961ad3ee04c156ec23d8fb`；源码未修改。 | [固定源码树](https://github.com/nsky99/wechatclient/tree/e1344339139a8a8a0b961ad3ee04c156ec23d8fb)；下载压缩包 SHA256 `ce04cacb6cc62fa9bcf1424e91c7cd7d3a2fce9968dbaa9d8e8afb084d9fe5bc`。 |
| Linux ARM64 编译 | **成功**。Go 1.26.5，`CGO_ENABLED=0`，`GOFLAGS=-mod=vendor`，`GOTOOLCHAIN=local`；`go build -o /out/wechatclient-linux-arm64 ./cmd`，退出码 0，约 12 秒。 | 使用已有官方 Go 镜像的 Google 镜像仓库副本；容器无网络、源码只读，不需要下载额外模块或闭源动态库。[构建参数与结果](../build/linux-protocol/build-go1.26.5.json)。 |
| 程序架构 | `file` 检查为 ELF 64-bit ARM aarch64、statically linked。 | 产物 [wechatclient-linux-arm64](../build/linux-protocol/wechatclient-linux-arm64)，25,129,887 字节，SHA256 `5293ba9ae7228f57d4bcecd5fd432d65e74da52552872a1dc577bbad2711bfb3`。 |
| HTTP 登录入口 | **成功启动**。无网络隔离容器内，二维码入口的无效 JSON、查二维码与授权入口的不存在会话都返回预期 HTTP 400。 | [本地入口请求结果](../build/linux-protocol/login-entry-probe.json)、[进程日志](../build/linux-protocol/login-entry-server.log)。它们只证明路由与处理器可运行。 |
| 当前微信协议握手 | **成功取得二维码响应**。2026-09-21 07:40:35 UTC，`POST /v1/login/getloginqrcode` 返回 HTTP 200、`Content-Type: image/png`，3,689 字节，PNG 文件签名正确；客户端请求约 0.31 秒。 | [在线前置探测结果](../build/linux-protocol/online-qr-probe.json)、[服务日志](../build/linux-protocol/online-qr-server.log)。源码按顺序完成长连接握手/Noop、短连接握手、二维码 CGI 请求后返回图像。二维码没有展示、扫码或保存为可登录凭据，临时容器已停止删除。 |
| 用户扫码确认 | 后续主线已实际获得 **`status=2`**。 | 只代表用户已确认二维码；源码此时尚未完成 `secmanualauth`。 |
| 账号认证 | **失败：`secmanualauth` 返回 `ret=-106`，提示“当前微信版本过低”。** | 当前旧协议不能继续到可用账号会话；HTTP 是否返回 200 不代表内部协议 ret 成功。未通过改常量或其他手段重试。 |
| 普通消息、持续同步、企微群与真实 @ | **未进入验证**。 | 被认证前置条件阻断，不作可用性推断。 |

构建镜像锁定为 `mirror.gcr.io/library/golang@sha256:0178a641fbb4858c5f1b48e34bdaabe0350a330a1b1149aabd498d0699ff5fb2`，镜像与产物元数据分别保存在 [builder-image.json](../build/linux-protocol/builder-image.json)、[source-build-manifest.json](../build/linux-protocol/source-build-manifest.json)。源码解包在 `/private/tmp/wechat-linux-protocol-execution/wechatclient-e1344339139a8a8a0b961ad3ee04c156ec23d8fb`。

## 登录前置探测的范围

代码使用配置中的 `szlong.weixin.qq.com:443` 与 `szshort.weixin.qq.com:80`；短连接传输的外层 HTTP 中承载的是源码实现的 MMTLS，不能把端口 80 等同于明文微信会话。连接、握手和封包由本地 Go 实现处理，所查入口没有商业 API 或第三方授权服务器。依据是 [用户会话构造](https://github.com/nsky99/wechatclient/blob/e1344339139a8a8a0b961ad3ee04c156ec23d8fb/pkg/wechat_sdk/userinfo.go#L51)、[连接配置](https://github.com/nsky99/wechatclient/blob/e1344339139a8a8a0b961ad3ee04c156ec23d8fb/pkg/wechat_sdk/config/wxclient_config.go#L18)、[MMTLS 服务初始化](https://github.com/nsky99/wechatclient/blob/e1344339139a8a8a0b961ad3ee04c156ec23d8fb/pkg/wechat_sdk/services/wx_service.go#L11) 和 [二维码请求](https://github.com/nsky99/wechatclient/blob/e1344339139a8a8a0b961ad3ee04c156ec23d8fb/manager/wx_client_mgr/wx_client/wx_client.go#L25)。本轮没有抓包核验每个实际 IP；上述目的地结论来自实际运行的固定源码。

探测使用独立随机设备值 `W6c11e4f6522e6f84`、设备类型 `Windows 10 x64`、名称 `IsolatedProtocolProbe`，没有复制真实设备标识。协议版本常量仍为原始 `0x6309092b`，没有改版本、伪造已登录会话或绕过服务器拒绝。设备类型是协议登录身份，宿主机确实运行 Linux ARM64。没有调用查扫码结果和认证 CGI。

在线探测用单独短生命周期容器，仅挂载产物，不导入账号目录、密钥、数据库或任何微信会话。现有测试微信容器没有被修改或重启。

## 距离业务目标仍缺的代码与验证

- **真实 @ 缺入口**：HTTP 发送参数只有 `ToId`、`Content`、`Type`、`ClientMsgId`；协议构造的 `MsgSource` 是固定 XML，没有 `AtWxIDList`、`atuserlist` 或成员 ID 列表。仅在内容拼 `@姓名` 不能满足需求。见 [HTTP 发送处理器](https://github.com/nsky99/wechatclient/blob/e1344339139a8a8a0b961ad3ee04c156ec23d8fb/controllers/controller_message.go#L23)、[协议发送结构](https://github.com/nsky99/wechatclient/blob/e1344339139a8a8a0b961ad3ee04c156ec23d8fb/pkg/wechat_sdk/mmscene/scene/net_scene_send_msg_new.go#L11)。
- **持续消息接收未接成服务**：已有 `WxClient.NewSync` 和协议解析，但路由只暴露 `newinit`、`sendmsgnew`、`sendimgmsg`；所查代码没有运行中的 NewSync 调度、回调/流式接口及同步游标更新闭环。`NewSync` 返回响应前未更新 `UserInfo.SyncKey`；当前看到的外部调用示例被整体注释。见 [路由](https://github.com/nsky99/wechatclient/blob/e1344339139a8a8a0b961ad3ee04c156ec23d8fb/routes/routes.go#L31)、[NewSync](https://github.com/nsky99/wechatclient/blob/e1344339139a8a8a0b961ad3ee04c156ec23d8fb/manager/wx_client_mgr/wx_client/wx_client.go#L432)。
- **企微群专项能力缺证据**：运行代码中未找到 `@openim`、`@im.chatroom` 处理或 `QW` 外部群专用入口。普通文本发送和联系人 protobuf 的存在不足以证明企微成员能正确枚举和 @。
- **认证版本已证实受阻**：手动授权含微信 Windows 3.9.9.43 的旧签名文本，真实扫码后服务器以 `ret=-106` 拒绝完整认证。需要实际适配当前协议，不能把改版本常量称为已完成适配。见 [手动授权实现](https://github.com/nsky99/wechatclient/blob/e1344339139a8a8a0b961ad3ee04c156ec23d8fb/pkg/wechat_sdk/mmscene/scene/net_scene_manual_auth.go#L50)。
- **错误处理较弱**：连接构造和二维码请求多处 `panic`；创建 MMTLS 服务失败会令用户信息构造返回 nil，而上层仍继续使用。成功场景本轮未触发这些错误，但正式测试需要先让超时与错误可诊断。

这份源码仍可保留作可重建的协议研究基线，但当前不能接入业务群。首先需要找到真实的当前版本认证适配；本轮不继续改版本号试登录。主线转向已正常登录的 Linux 客户端内部调用，公开协议分支保留编译与失败证据。

## 认证受阻后的限定分支核查

2026-09-21 追加核查，范围限于 nsky99 上游、公开 fork 的认证入口和少量相关 MMTLS 实现；没有修改源码版本、重新登录或改动运行服务。

- [上游分支接口](https://api.github.com/repos/nsky99/wechatclient/branches?per_page=100) 仅返回 `main`，仍指向实测提交 `e1344339139a8a8a0b961ad3ee04c156ec23d8fb`；[所有状态的 PR 接口](https://api.github.com/repos/nsky99/wechatclient/pulls?state=all&per_page=100) 返回空列表。没有可直接合入的上游认证更新。[本地快照](../build/linux-protocol/upstream-branch-check.json)
- [公开 fork 列表](https://api.github.com/repos/nsky99/wechatclient/forks?per_page=100&sort=newest) 本次返回 36 项。逐一下载其默认分支的 `wxclient_config.go` 和 `net_scene_manual_auth.go`，**35 个可读取 fork 的这两个文件 SHA256 全部与实测失败版本相同**，仍为 `WechatClientVersion = 0x6309092b` 和旧版认证结构。剩余 `123456789zws/wechatclient` 的两个文件均返回 404，不能算更新证据。比较覆盖关键认证文件，不等于审计每个 fork 的全部历史或所有非默认分支。[逐项比较结果](../build/linux-protocol/fork-auth-comparison.json)
- 限定检索中的 [duo/gommtls](https://github.com/duo/gommtls) 公开的是 MMTLS 传输实现，README 的 `0xF104` 是该层协议版本，**不是 Windows 微信 4.x 客户端适配证据**；其引用的 [anonymous5l/mmtls](https://github.com/anonymous5l/mmtls) 明确只实现与微信服务握手，不实现上层通讯内容。这两者没有提供能替换当前 `secmanualauth` 的完整 4.x 认证实现。
- 同次检索中声称支持 Windows 4.x 的 [wechat-automation-api](https://github.com/LAVARONG/wechat-automation-api) 和 [wechatauto-replica](https://github.com/fanyuantaier/wechatauto-replica) 分别采用 UI 自动化、数据库读取配合 UIA/OCR 发送，不属于本次需要的自建网络协议核心，不作为替代推荐。

**限定核查没有找到已验证的 Windows 4.x 公开协议适配替代。** 这不是宣称所有公开或商业实现都不存在，而是现有证据不支持继续以“换个 fork / 改常量即可登录”为计划。源码可编译和二维码可获取这两项成果保留；账号认证失败的结论也必须同时保留。

## iwechat 二进制静态对照

固定对象：[iwechatcom/iwechat 的 `myapp`](https://github.com/iwechatcom/iwechat/blob/6534f0ad9ce3e9ef21208555d815a2ae032d802a/myapp)，提交 `6534f0ad9ce3e9ef21208555d815a2ae032d802a`。文件 33,448,850 字节，SHA256 `24f1692c013039c59bd2eabe63068ebf79524e8f32114bd7a832afa9063dcffd`。

`file` 与 Go 构建元数据一致确认：**Linux AMD64 / x86-64，CGO_ENABLED=0，Go 1.24.2，静态链接**。主模块为 `xiawan/wx`，内部构建版本 `v0.0.0-20250520054711-2aa5bd26334a+dirty`。这不是原生 ARM64 产物；公共仓库未提供构建该核心所需源码。即使借助架构模拟运行，也不能获得源码自建和版本自主维护能力。[构建元数据](../build/linux-protocol/iwechat-buildinfo.txt)

静态字符串可见 `https://a.i-wechat.com/api`、`xiawan/wx/auth.RegisterDevice`、`generateMachineID`、许可状态查询和 `checkLicense`。这支持“包含远端注册与许可管理逻辑”的判断，**尚不能单靠字符串证明每次运行必需在线授权、离线时如何失败、或该域名承载协议核心**。未运行该二进制、未请求该域名，也未修改授权机制。[静态证据](../build/linux-protocol/iwechat-static-indicators.json)

其 Swagger 的企业群接口和 `AtWxIDList` 仍是它比 nsky99 更完整的接口声明，但本轮没有认证或运行该闭源发行；不能因为 nsky99 认证失败就把它自动升级为可用替代。它保留作接口行为的文档对照。

## 后续实例接手说明

以下保留认证测试前的接手说明，用于复现实验与理解接口；**最新结果已经是上述 `ret=-106`，不是继续扫码即可成功**。本分支没有再启动实例或改动运行服务。源码、构建产物和日志均保留；此前短生命周期探测容器的二维码已失效，不应给用户扫码。

```sh
docker run -d --name wechat-protocol-session \
  --read-only --cap-drop ALL --security-opt no-new-privileges \
  --memory 256m --cpus 1 \
  -p 127.0.0.1:18081:8080 \
  --mount type=bind,src=/Users/neo/Documents/by/WeChat_Agent/build/linux-protocol,dst=/audit,readonly \
  -e GIN_MODE=release \
  mirror.gcr.io/library/golang@sha256:0178a641fbb4858c5f1b48e34bdaabe0350a330a1b1149aabd498d0699ff5fb2 \
  /audit/wechatclient-linux-arm64
```

先确认本机端口未被占用，再使用新的 `sessionId` 和独立 `W` 加 16 位十六进制设备 ID。调用次序如下，各调用必须保持同一个进程及 `sessionId`：

1. `POST /v1/login/getloginqrcode?sessionId=...`，JSON 为 `deviceId`、`deviceType: "Windows 10 x64"`、`deviceName`。响应直接是 PNG，协议 UUID / NotifyKey 存在进程内，无需从 PNG 提取。
2. `POST /v1/login/checkloginqrcode?sessionId=...`，不需要 body。每次请求检查一次；没有自动轮询任务。返回 JSON 的 `status=2` 时，源码只把 `username`、`pwd` 保存在内存，**不会自动完成认证**。此接口的原始返回包含伪密码，接手程序只应向对话输出状态摘要。服务端非零 ret 目前被统一改写成 `qrcode time out`，不能据此区分过期和其他错误。
3. `POST /v1/login/secmanualauth?sessionId=...`，不需要 body。检查 `baseResponse.ret=0` 和 `unifyAuthSectFlag>0`，才会在本地保存会话密钥及账号信息。返回包含密钥，不应将整个 JSON 打印到对话。源码会保存 `AuthAutoKey`，但未实现自动认证或会话恢复流程。
4. `POST /v1/message/newinit?sessionId=...`，初始化同步游标。后续收消息需要补 NewSync 的对外入口。

会话通过 `manager/wx_client_mgr/wx_client_mgr.go` 的内存 `gmap` 保存，无磁盘持久化、无已接通的长连接收发任务；重启进程会丢失会话。HTTP 服务本身没有管理鉴权，中间实验只绑定本机 `127.0.0.1`。

最小补丁位置，供接手者实现，不代表本轮已经补完：

- `routes/routes.go:34` 增加 NewSync 路由；controller/service 可仿照现有 NewInit 的会话查找包装，调用 `manager/wx_client_mgr/wx_client/wx_client.go:432` 的 `NewSync(sceneId)`。成功后依据 `NewSyncResponse.Ret`、`ContinueFlag` 处理结果，并更新 `UserInfo.SyncKey = response.GetKeyBuf().GetBuffer()`；当前该函数没有做更新。消息正文仍需解析响应的 `CmdList`。
- @ 参数需贯穿 `controllers/controller_message.go:26`、`services/service_message.go:24`、`manager/wx_client_mgr/wx_client/wx_client.go:298`、`pkg/wechat_sdk/mmscene/scene/net_scene_send_msg_new.go:11`，最终替换第 32 行写死的 `MsgSource`。仅补可选成员 ID 列表还不能证明企微群使用相同消息 CGI 或能正确 @ `@openim` 成员，须在目标外部群验证。
