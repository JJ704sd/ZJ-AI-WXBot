# Linux 微信接入方案专项探索

调研日期：2026-09-21。方法：一手文档、GitHub 发布元数据、源码及小型原生库文件头静态检查。未启动候选容器，未登录测试号，未发送微信消息。本文补充 [9 月 18 日总报告](2026-09-18-wechat-access.md)。

目标仍是：个人微信号参与企业微信创建的外部混合群，主动发消息、真实 @ 个人微信及企业微信成员、识别被 @ 并接收后续回复；持续接收普通消息是期望能力。用户仍偏好自建与协议/客户端接口，RPA 为备选。Linux 是新增候选，不自动取代此前“Mac/Windows 通用优先，否则 Windows 优先”的偏好。

## 结论

**有 Linux 路线，并且找到两个值得继续研究的原生 Linux 自建基础；尚未找到已经满足全部混合群要求、可直接部署交付的完整方案。**

这轮最有价值的新增是 `thisnick/agent-wechat` 和 `xiaoguiwucan/linux-wechat-agent`。两者都把原生 Linux 微信、本地数据库读取和界面发送组合起来；可以不依赖商业协议 SaaS 完成接入层的部分工作，但仍属混合自动化方案。已有代码暴露了具体缺口：外部群标识漏判、真实 @ 发送未实现或依赖昵称 UI 选择、入站 @ 的判断不一致。因此可以明确下一轮开发和实测范围，而无需先投入完整 Agent 后端。

无桌面的协议方案也存在 Linux 交付物，但当前登录可用性、闭源加密库、授权依赖和混合群专项能力仍是核心问题。把旧 Windows 微信放进 Wine 容器则没有解决客户端版本依赖，不列为优先验证路线。

| 路线 | 本轮最有用的候选 | 验证价值 | 当前不能承诺的部分 |
|---|---|---|---|
| 无桌面协议服务 | iwechat、WeChatPadPro | 有 Linux 交付，iwechat 还有企业群专项接口和 @ 列表字段 | 当前登录、完整私有化、实际混合群能力 |
| Linux 客户端 + 数据库 + UI | agent-wechat | 接口较清晰、入站提及读取原始字段，适合研究接入层 | 版本匹配、外部群分类、真实 @ 输出 |
| Linux 客户端 + 数据库 + UI | linux-wechat-agent | 有增量接收及实际 @ 候选操作 | 外部群过滤、入站真 @、同名/企业成员选择 |
| 纯桌面托管 | WechatOnCloud | 可提供浏览器中的原生 Linux 微信测试环境 | 不等于消息 API 或机器人 |
| Wine + Windows 微信 | jwping/wxbot | 曾提供 Linux 容器运行路径 | 固定旧客户端版本、当前登录、混合群专项能力 |

## 原生 Linux 微信 + 本地读取 + UI 发送

[微信 Linux 官方页面](https://linux.weixin.qq.com/)当前显示 **4.1.13**，提供 x86_64/arm64 的 deb、rpm、AppImage，另有 LoongArch deb。本轮只读到网页版本与下载入口，没有取得安装包内完整版本或 ELF BuildID；存在官方 Linux 客户端不等于提供个人号群消息 API。

### thisnick/agent-wechat：接口层较清晰，真实 @ 发送尚未实现

固定审阅提交：`da066f501adb8454514051520007117776081332`。

实现结构为：原生 Linux 微信在容器里运行；Frida 辅助获取数据库密钥及会话选择；SQLCipher 读本地聊天数据库；Xvfb/AT-SPI 等桌面组件完成界面操作；Rust 服务对外提供 API，另有 CLI 和 Wechaty 适配。其数据库读取不要求消息先 @ 机器人，因此有接收普通消息的实现基础。[项目说明](https://github.com/thisnick/agent-wechat)、[读取实现](https://github.com/thisnick/agent-wechat/blob/da066f501adb8454514051520007117776081332/packages/agent-server-rust/src/tools/wechat_messages.rs)

Dockerfile 与脚本有 amd64/arm64 构建路径，容器需要进程调试权限。但选会话功能只支持四个固定 ELF BuildID 前缀，其中两项注释为 4.1.0.16，另外两项只写 4.x；默认下载安装包却是官网滚动地址。**首个验证步骤是客户端 BuildID 匹配，当前不能确认官网 4.1.13 可直接使用。**也未找到项目 LICENSE，因此称为公开源码研究候选，不推定其修改/分发授权。[构建文件](https://github.com/thisnick/agent-wechat/blob/da066f501adb8454514051520007117776081332/docker/Dockerfile)、[版本配置及检查](https://github.com/thisnick/agent-wechat/blob/da066f501adb8454514051520007117776081332/docker/tools/chat-select.py)、[详细核查](2026-09-21-linux-native.md)

| 要求 | 已看到的实现 | 缺口 |
|---|---|---|
| 普通消息读取 | 查询本地数据库，保留消息及发送人字段 | 仅限客户端已同步的数据；忙群/断线覆盖未实测 |
| 主动发送 | 输入消息后触发发送 | 属于 UI 发送，不是无桌面协议调用 |
| 入站真实 @ | 从原始 XML 的 `atuserlist` 判断，部分引用消息补查 content | 判断只在代码认定为群时执行 |
| 企微外部群 | 可按聊天 ID 查数据的基础存在 | 群判定 `contains("@chatroom")` 不覆盖 `@im.chatroom`，影响群发送人/提及解析 |
| 发真实 @ | Wechaty 方法签名出现 mention 列表参数 | `_mentionIdList` 被忽略，实际只传 `chatId` 和文本；发送参数也没有 mention 列表，未见选 @ 候选操作 |

关键证据：[入站提及与群识别](https://github.com/thisnick/agent-wechat/blob/da066f501adb8454514051520007117776081332/packages/agent-server-rust/src/tools/wechat_messages.rs#L166)、[被忽略的提及列表](https://github.com/thisnick/agent-wechat/blob/da066f501adb8454514051520007117776081332/packages/wechaty-puppet/src/puppet-agent-wechat.ts#L505)、[发送流程](https://github.com/thisnick/agent-wechat/blob/da066f501adb8454514051520007117776081332/packages/agent-server-rust/src/plans/send_message.rs)。

定位：适合先验证 Linux 容器中的普通消息读写，再为目标外部群补齐类型处理与真实 @ 操作。不能仅修一个后缀就宣称混合群支持完成；成员身份、数据库实际格式及发送结果仍要实测。

### xiaoguiwucan/linux-wechat-agent：已有 @ 候选操作，入站识别需要改进

项目 v0.4.2（2026-06-20）组合 `wechat-selkies` 原生 Linux 微信桌面、本地数据库增量导入、记忆服务和 UI 自动回复。作者提供 amd64/arm64 部署路径；这比只在 Linux 上调用远程商业 API 更接近自建。[项目与更新说明](https://github.com/xiaoguiwucan/linux-wechat-agent)

本轮固定提交为 `58b2c43ff18597c6d0c9ec47270eb40e4fb0b2bb`。它没有可确认的精确微信版本兼容矩阵；上游 Selkies 当前跟踪到 4.1.13.23，并不能倒推该项目已对这一版本完成测试。

源码审阅发现三项直接影响需求的限制：

1. 导入层只把 `endswith("@chatroom")` 判为群，上层自动回复筛选 `is_group=1`，成员映射也限制该后缀。`@im.chatroom` 会漏出这些群逻辑。
2. “蓝色 @”有实际 UI 候选选择尝试：输入 `@alias` 后按回车或点击候选区域，再检查输入框内容变化；它不是单纯把 `@名字` 拼进字符串。但匹配依赖别名/昵称与界面位置，尚无稳定成员 ID、同名选择或企业微信成员的通过证据。
3. 入站 `detect_bot_mention` 依据文本昵称/别名判断，没有用原始 `atuserlist` 区分真正提及与普通同名文字。README 的“@ 必回”不能当成真实 @ 检测已经完成。

直接证据：[入库群标记](https://github.com/xiaoguiwucan/linux-wechat-agent/blob/58b2c43ff18597c6d0c9ec47270eb40e4fb0b2bb/memory/memory_ingest.py#L305)、[发送时选择候选](https://github.com/xiaoguiwucan/linux-wechat-agent/blob/58b2c43ff18597c6d0c9ec47270eb40e4fb0b2bb/agent_console/wechat_controller.py#L375)、[入站昵称判断](https://github.com/xiaoguiwucan/linux-wechat-agent/blob/58b2c43ff18597c6d0c9ec47270eb40e4fb0b2bb/agent_console/app.py#L11635)、[Selkies 上游版本跟踪](https://github.com/nickrunning/wechat-selkies/blob/master/versions/upstream.env)。

定位：可以借鉴其本地增量接收和发送时选 @ 候选的实现，但比 `agent-wechat` 更耦合完整 Agent/记忆产品。我们的任务可只研究接入相关部分；不需要先部署其完整 AI 功能。固定提交、源码行号与精确部署边界见 [Linux 桌面专项](2026-09-21-linux-desktop.md)。

## 无桌面的 Linux 协议服务

### iwechat：新增的企业群专项接口候选

[原作者 iwechatcom/iwechat](https://github.com/iwechatcom/iwechat/tree/6534f0ad9ce3e9ef21208555d815a2ae032d802a) 实际提供 Linux `myapp`、Mac `mac_myapp` 和 Windows `myapp.exe`，并有 Ubuntu Dockerfile。随包 Swagger 包含企业群同步、成员获取、同意入群的 `/qy/` 接口；文本发送有 `AtWxIDList` 数组，另有 HTTP/WebSocket 消息同步。这比只写“支持群聊”的候选有更强的专项验证价值。[Swagger](https://github.com/iwechatcom/iwechat/blob/6534f0ad9ce3e9ef21208555d815a2ae032d802a/static/swagger/swagger.json)

但这是**闭源二进制交付**，最后提交 2025-05-29；README 的免费限两账号不能作为今天的可用性证明。CPU 架构、当前登录、外部授权依赖和实际混合群双身份 @ 尚未确认。文档的企业群示例还使用普通 `@chatroom`，没有目标外部群的端到端样本。定位为“协议偏好下值得验收的新增候选”，不按已验证方案或已完成订阅替代处理。[Dockerfile](https://github.com/iwechatcom/iwechat/blob/6534f0ad9ce3e9ef21208555d815a2ae032d802a/Dockerfile)、[详细协议补查](2026-09-21-linux-protocol-alternatives.md)

### WeChatPadPro：有真实 Linux 发布物，核心仍不是完整公开源码

今日重新调用 GitHub API：main 仍为 `5cf4fc76c5457691798079bd921e09f60cf5afd7`（提交日期 2026-08-20）；latest public release 仍为 `v2.01`，发布于 **2025-08-22**。公开资产确实包括 `linux-amd64`、`linux-arm64`，不是仅有 Python/Node 客户端支持 Linux。其他公开架构包括 mips64/mips64le/ppc64/ppc64le。[发布页](https://github.com/WeChatPadPro/WeChatPadPro/releases/tag/v2.01)

同一提交的完整公共目录不包含协议核心构建入口；Compose 拉维护者预构建镜像，并使用 MySQL/Redis。README 的较新 v875 通过赞助群交付。公开旧包存在，不能证明它在今天能登录；ARM64 二进制存在，也不能证明某个 `latest` Docker tag 的 manifest 包含 ARM64。[固定目录](https://github.com/WeChatPadPro/WeChatPadPro/tree/5cf4fc76c5457691798079bd921e09f60cf5afd7)、[Compose](https://github.com/WeChatPadPro/WeChatPadPro/blob/5cf4fc76c5457691798079bd921e09f60cf5afd7/deploy/docker-compose.yml)、[作者说明](https://github.com/WeChatPadPro/WeChatPadPro)

定位：值得要求当前版本的 Linux 私有部署试用，但不能按“免费、完整开源、无后续依赖”立项。当前登录、远端授权依赖、混合群收发和双身份真实 @ 均待验证。

### Ipad860：确认 Linux 实现路径，也确认现成构建存在缺口

今日确认 main 仍为 `4d567bd6ee3206b5f112768225d7498abfc442b1`，最后提交日期 **2025-08-20**。

| 静态检查 | 结论与影响 |
|---|---|
| `clientsdk/v08/v08.go` 按 `runtime.GOOS` 选择 Windows DLL 或 Linux `libv08.so` | 服务端确有 Linux 分支；Darwin 主分支直接报 unsupported platform |
| `clientsdk/dynlib/linux.go` 使用 CGO、`dlopen/dlsym` | 不是只设置 `GOOS=linux` 就能得到无原生依赖的服务 |
| 仓库内 `lib/libv08.so` 文件头为 ELF64 x86-64 | 现有关键库明确覆盖 Linux x64；未取得 ARM64 对应库，不能默认在 Apple Silicon 的 ARM 容器运行 |
| `go.mod` 要求 Go 1.24，根 Dockerfile 却以 Go 1.15.4 为基础，并写了 `RUN ADD` | 现有 Dockerfile 不可直接视为可构建配置，需修订后另行验证 |
| HTTP/TCP Dockerfile 依赖 `protocol:1.0.1`，复制的 `conf/app-http.conf` / `conf/app-tcp.conf` 不在完整目录中 | 私有/外部基础镜像与缺文件进一步阻止原样复现 |
| Linux 加载的是裸库名 `libv08.so`，仓库文件位于 `lib/` | 部署还需正确安排动态库搜索路径 |

来源：[库加载](https://github.com/meteor-nb/Ipad860/blob/4d567bd6ee3206b5f112768225d7498abfc442b1/clientsdk/v08/v08.go)、[Linux 动态调用](https://github.com/meteor-nb/Ipad860/blob/4d567bd6ee3206b5f112768225d7498abfc442b1/clientsdk/dynlib/linux.go)、[库目录](https://github.com/meteor-nb/Ipad860/tree/4d567bd6ee3206b5f112768225d7498abfc442b1/lib)、[go.mod](https://github.com/meteor-nb/Ipad860/blob/4d567bd6ee3206b5f112768225d7498abfc442b1/go.mod)、[Dockerfile](https://github.com/meteor-nb/Ipad860/blob/4d567bd6ee3206b5f112768225d7498abfc442b1/Dockerfile)、[Dockerfile.http](https://github.com/meteor-nb/Ipad860/blob/4d567bd6ee3206b5f112768225d7498abfc442b1/Dockerfile.http)。

代码确实实现了发送时构造 `atuserlist`，以及同步 `AddMsg`、HTTP 回调、可选 RabbitMQ。这比只有 API 调用示例更接近实际协议实现。但发送路径固定到 `newsendmsg`，本次没有取得混合群专门收发的成功样本；企业联系人接口及“扫码进企业群”入口不能替代双向交互验收。[文本发送](https://github.com/meteor-nb/Ipad860/blob/4d567bd6ee3206b5f112768225d7498abfc442b1/models/Msg/SendNewMsg.go)、[消息同步](https://github.com/meteor-nb/Ipad860/blob/4d567bd6ee3206b5f112768225d7498abfc442b1/models/Msg/sync.go)、[回调工作器](https://github.com/meteor-nb/Ipad860/blob/4d567bd6ee3206b5f112768225d7498abfc442b1/srv/sync/syncmsg.go)

作者明确表示关键 v08 库源码不明。现有 Go 代码不能让整个加密链路独立构建或维护；本次目录也未见项目自身的 LICENSE。定位为 Linux x64 协议研究基础，需要先解决构建复现和当前登录，尚不是推荐直接部署的成品。[作者 README](https://github.com/meteor-nb/Ipad860)

上述 API 元数据、源码 blob 和文件头摘要已保存到 [静态核查记录](evidence/2026-09-21-linux-static-audit.json)。

另外检查了 nsky99/wechatclient 及 WeProtocol 的新镜像。前者确有协议源码，但带旧客户端登录假设且发送接口未接 @；后者虽然出现 2026 年提交，102 个文件中 100 个 blob 与旧版相同，还缺少入口结构，不能视为新的协议维护成果。它们不增加首轮候选数量。[核查依据](2026-09-21-linux-protocol-alternatives.md)

## 桌面底座、Wine 与其他备选

**WechatOnCloud（云微）**实际是原生 Linux 微信 + Xvfb/KasmVNC，支持 amd64/arm64。面板有实例管理、文件和键盘输入 API，但本轮查到的路由没有按群 ID 发消息、群成员解析或消息订阅。它能作为测试桌面底座，不能单独算微信机器人接入层。浏览器看到的是远程桌面，不是旧 Web 微信协议。[原作者仓库](https://github.com/Gloridust/WechatOnCloud)、[面板路由](https://github.com/Gloridust/WechatOnCloud/blob/98b6495741601772d47c8d8939283b529b3b44e4/panel/server/src/index.ts)

**jwping/wxbot**确实提供 Wine 容器、消息回调及 `atlist`，但固定的是 Windows 微信 **3.9.8.25**，仓库最后提交 2024-01-30。容器内仍是 Windows 微信与 exe；旧版当前能否登录，以及目标混合群是否支持，没有本轮实测证据。作者也说明 Docker 镜像稳定性尚未充分验证。因此不优先研究这一条。[作者说明](https://github.com/jwping/wxbot/blob/41883983d53925b7ddd487e4bb0ccfda8ec26a53/README.md)、[Dockerfile](https://github.com/jwping/wxbot/blob/41883983d53925b7ddd487e4bb0ccfda8ec26a53/docker/Dockerfile)

旧 Web/UOS 项目也不能仅凭 Linux 支持就列入主线；例如 wechatbot-webhook 作者明确说明 Web 协议不支持企业消息。Linux 控制实体 Android 手机则可保留为另一种 UI 备选，但实际微信接入端在手机，需要额外设备和微信专项实现。[作者回复](https://github.com/danni-cool/wechatbot-webhook/issues/142)、[Android 控制框架及详细边界](2026-09-21-linux-desktop.md)

## 系统选择与“跨平台”的实际含义

可把接入服务统一部署在一台自己的 Linux 机器，再让 Mac/Windows 上的业务程序调用 HTTP/WebSocket；这样只有一套微信接入环境需要维护。也可在 Mac/Windows 的 Linux 容器里分别部署，但要另外验证镜像架构、客户端版本和进程调试能力。Windows 可用 Docker 的 WSL 2 后端，Mac 有 Intel/Apple Silicon 对应安装版本；这只提供运行基础，并不保证具体微信项目在两端都通过验收。[Docker Windows 文档](https://docs.docker.com/desktop/setup/install/windows-install/)、[Docker Mac 文档](https://docs.docker.com/desktop/setup/install/mac-install/)

**工程建议：**若需要一台机器覆盖尽量多的候选，选 x86-64 Linux 测试机；Ipad860 当前关键库及旧 Wine 路线尤其受此限制。当前 Mac 是 ARM64，可以研究明确提供 ARM64 实现的原生 Linux 容器路线，不必先购买 Windows 机器。不能把 x86 容器模拟运行的可用性当作原生 ARM64 兼容性证明。

“不需要物理显示器”也分两种：协议服务确实无需微信 GUI；原生客户端容器仍在虚拟显示器中运行微信，需要保持客户端及桌面组件工作。数据库读取通常仅覆盖本地客户端已经同步并保存的数据，不自动提供手机上全部历史或无限离线补齐。

## 首轮验证范围

协议优先的偏好不变。应先拿当前 Linux 协议交付物证明混合群能力；公开旧包若不能完成构建或登录，不继续投入完整 Agent 开发。愿意使用 RPA 备选时，原生 Linux 容器与本地数据库组合值得另做一个小验证。

每条候选沿用同一个专用个人号与企微外部测试群，另加普通微信群对照：

1. 先记录运行环境、CPU 架构、镜像 digest、微信版本，确认测试号登录且客户端本身能看到目标群及两类成员。
2. 由个人微信成员与企业微信成员分别发送未 @ 的编号消息，检查接口返回的群、真实发送人、消息 ID 与原始内容；特别记录真实群 ID 形态。
3. 由程序主动发送一条编号消息，确认群内实际出现，不能只用 HTTP 200 判成功。
4. 分别真实 @ 两类成员；由接收方验证原生提及效果。仅拼接 `@昵称` 的文本不通过。
5. 两类成员分别真实 @ 测试号，并发送含相同昵称的普通文本作对照，检查入站识别是否可靠。
6. 基础双向交互通过后，再测同名成员、改名、断线恢复及一批编号消息的漏收/重复。只完成前五项时标记“基础交互通过”，不承诺持续全量。

对付费方案，先用同一组测试验收，再判断投入在哪里：本地 API/适配层可以自行实现；闭源库、远端授权或整套登录协议依赖要单独评估。Linux 发布包存在不是已经完成付费核心逆向，也不能据此承诺取消订阅后的可用性。
