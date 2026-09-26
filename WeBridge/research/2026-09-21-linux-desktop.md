# Linux 微信容器、桌面与手机控制路线核查

核查日期：2026-09-21。目标是用个人微信账号进入既有的企微创建外部混合群，接收普通消息、主动发言、真实 @ 微信与企微成员，并把入站 @ 和引用回复交给 Agent。本次只读取作者文档与公开源码，未安装或运行这些软件，未登录账号或发送消息。

## 结论

Linux 并非只能运行旧版 Windows 微信，但“能把微信放进 Docker”与“已有可用消息连接器”必须区分：

| 路线 | 实际微信接入端 | 已确认能力 | 对本需求的判断 |
|---|---|---|---|
| Gloridust/WechatOnCloud（云微） | 原生 Linux 官方微信，Xvfb/KasmVNC 远程桌面 | amd64/arm64，浏览器共享桌面，实例管理、输入、文件和剪贴板 | 可作客户端托管底座；没有群消息事件、成员 ID、真实 @ 等语义化 Bot API |
| nickrunning/wechat-selkies | 原生 Linux 官方微信，Selkies 远程桌面 | amd64/arm64，官方安装包自动跟踪 | 与云微同类的桌面底座；浏览器访问不等于使用微信 Web 协议 |
| xiaoguiwucan/linux-wechat-agent | 原生 Linux 微信 + 本地数据库读取 + GUI 发送 | 普通群 Agent 已有源码；数据库轮询、引用解析、@ 候选操作 | 有借鉴价值，但源码明确遗漏 `@im.chatroom` 群识别，入站 @ 仍按昵称文本判断；不能作为已满足混合群需求的成品 |
| jwping/wxbot Docker | Wine 中运行 Windows 微信 3.9.8.25 | HTTP 发送、消息回调、`atlist` | 是旧版 Windows Hook/注入路线的 Linux 包装；当前登录、混合群、两类成员 @ 未证实 |
| danni-cool/wechatbot-webhook / UOS、Web 类 | Web 微信协议 | 普通消息 HTTP 桥接，历史上支持多架构 | 作者明确说明 Web 协议不支持企业消息；仓库已归档，不作为本需求主线 |
| Linux + 实体 Android + ADB/UIAutomator | Android 手机上的微信 | 跨平台控制手机 UI 的基础框架成熟 | 可自研备选；Linux 是控制层，手机才是接入端，并非纯 Linux 服务器连接器 |

表中依据见各节。**本轮没有确认一个开箱即用、可持续覆盖目标外部混合群且真实 @ 两种身份的 Linux 成品。值得继续验证的是“原生 Linux 微信 + 数据库接收 + UI 发送”的组合，但群类型与身份处理需要开发和实测。**

## 1. 云微 WechatOnCloud：远程桌面托管，不是现成消息 API

一手仓库是 [Gloridust/WechatOnCloud](https://github.com/Gloridust/WechatOnCloud)。核查固定在 [98b6495741601772d47c8d8939283b529b3b44e4](https://github.com/Gloridust/WechatOnCloud/commit/98b6495741601772d47c8d8939283b529b3b44e4)，最近提交时间为 2026-07-28。

- README 与安装脚本一致：每个实例运行虚拟显示、原生 Linux 微信及 KasmVNC；面板经 Docker socket 管理实例并代理桌面。微信运行文件是 `/config/wechat/opt/wechat/wechat`，安装时从腾讯 CDN 获取 Linux `.deb`，按 amd64/arm64 选包，不涉及 Wine。镜像本身不固定打包微信。[README](https://github.com/Gloridust/WechatOnCloud/blob/98b6495741601772d47c8d8939283b529b3b44e4/README.md)、[安装脚本](https://github.com/Gloridust/WechatOnCloud/blob/98b6495741601772d47c8d8939283b529b3b44e4/docker/wechat-ctl.sh#L11)
- 面板源码的 API 是账号权限、实例生命周期、文件、安装更新、协作控制锁、键盘与文本输入。其中 `/api/instances/:id/type` 和 `/key` 是桌面输入接口，不是“按群 ID 发消息”。本次读取的完整路由文件没有微信消息接收 webhook、会话列表/成员解析或语义化发消息接口。[路由源码](https://github.com/Gloridust/WechatOnCloud/blob/98b6495741601772d47c8d8939283b529b3b44e4/panel/server/src/index.ts#L390)、[文本与按键路由](https://github.com/Gloridust/WechatOnCloud/blob/98b6495741601772d47c8d8939283b529b3b44e4/panel/server/src/index.ts#L920)
- Mac/Windows 可以作为浏览器访问端，Linux amd64/arm64 是实际桌面运行环境。若在 Mac 的 Docker 内运行，运行的仍是 Linux 客户端；这不能证明与 Mac 原生微信自动化共用实现。普通收发与 @ 的上限首先由被托管客户端决定，自动读取、发言、成员定位都需另接实现。

因此云微解决的是“客户端常驻与远程操作”，没有独立解决“Agent 持续收到每条普通消息”。没有官方发布的精确微信适配矩阵；动态获取最新版也不等于其 GUI 自动化始终兼容。

## 2. linux-wechat-agent：较接近完整闭环，但存在明确的混合群缺口

作者仓库 [xiaoguiwucan/linux-wechat-agent](https://github.com/xiaoguiwucan/linux-wechat-agent)，本次固定 [58b2c43ff18597c6d0c9ec47270eb40e4fb0b2bb](https://github.com/xiaoguiwucan/linux-wechat-agent/commit/58b2c43ff18597c6d0c9ec47270eb40e4fb0b2bb)，2026-06-20 的 v0.4.2。以下结论来自实际控制、消息入库及 Agent 源码，不仅依据 README。

### 架构、版本与持续接收

Compose 的微信底座默认是 `ghcr.io/nickrunning/wechat-selkies:0.0.12-minimal`；作者声明整套镜像支持 `linux/amd64`、`linux/arm64`。微信数据库挂载给只读同步服务，后者默认每 5 秒扫描；发送由容器内 `xdotool`、`xclip` 操作微信窗口。它是一套数据库读、GUI 写的混合方案，不是纯截图监听，也不是 Web 微信协议。[Compose](https://github.com/xiaoguiwucan/linux-wechat-agent/blob/58b2c43ff18597c6d0c9ec47270eb40e4fb0b2bb/docker-compose.yml#L1)、[架构及多架构说明](https://github.com/xiaoguiwucan/linux-wechat-agent/blob/58b2c43ff18597c6d0c9ec47270eb40e4fb0b2bb/README.md)

数据库同步会检查数据库和 WAL 的状态变化，再解密更新副本并入库；它不以当前屏幕可见的消息气泡作为唯一接收来源。因此其接收方式在结构上比逐群刷窗口更适合“最好一直监控”。这只证明实现方式：实际覆盖仍受微信在线状态、客户端是否落库、密钥、数据库格式和同步错误影响，不代表零遗漏。首次部署还要求登录微信并让常用会话数据落地；没有已验证的外部混合群持续覆盖数据。[同步循环](https://github.com/xiaoguiwucan/linux-wechat-agent/blob/58b2c43ff18597c6d0c9ec47270eb40e4fb0b2bb/memory/sync_worker.py#L49)、[数据库/WAL 更新](https://github.com/xiaoguiwucan/linux-wechat-agent/blob/58b2c43ff18597c6d0c9ec47270eb40e4fb0b2bb/memory/decrypt_sync.py#L156)

**微信精确版本未确认。** 项目公开资料给出的是自身 v0.4.2 与 Selkies 镜像标签，没有核实到对应的 Linux 微信版本及兼容矩阵。上游 Selkies 当前自动跟踪文件在 2026-09-20 记录 amd64/arm64 均为微信 **4.1.13.23**；这是上游当前版本状态，不能倒推 v0.4.2 已测试该微信版本，也不能倒推默认旧镜像一定包含它。[上游版本状态](https://github.com/nickrunning/wechat-selkies/blob/master/versions/upstream.env)、[上游更新机制](https://github.com/nickrunning/wechat-selkies#更新微信qq版本)

### 外部混合群：明确的后缀判断缺口

消息入库仅将以 `@chatroom` 结尾的会话标记为群；`@im.chatroom` 不满足这个字符串条件。Agent 的自动回复候选查询只选择 `is_group=1`；成员身份映射也要求会话以 `@chatroom` 结尾。因此对于使用 `@im.chatroom` 标识的外部混合群，不仅“没找到测试说明”，而是源码存在可指出的漏识别路径。[入库群标记 L305](https://github.com/xiaoguiwucan/linux-wechat-agent/blob/58b2c43ff18597c6d0c9ec47270eb40e4fb0b2bb/memory/memory_ingest.py#L305)、[自动回复筛选 L8655](https://github.com/xiaoguiwucan/linux-wechat-agent/blob/58b2c43ff18597c6d0c9ec47270eb40e4fb0b2bb/agent_console/app.py#L8655)、[成员映射限制 L11417](https://github.com/xiaoguiwucan/linux-wechat-agent/blob/58b2c43ff18597c6d0c9ec47270eb40e4fb0b2bb/agent_console/app.py#L11417)

这不意味着底层 Linux 微信无法显示这些群，也不意味着所有原始消息一定完全未入库；准确含义是：**现成 Agent 的群路由和身份逻辑不能直接覆盖它们。** 修正后缀条件也只解决第一层问题，还要验证外部联系人存储、成员身份和发送候选。

### 出站真实 @：有选候选操作，但缺少身份级保证

`paste_mention_active` 的实际步骤是：激活窗口，输入 `@alias`，回车选择候选；失败时尝试四个相对坐标位置点击候选，然后输入正文。它确实尝试让微信形成真实 @，不是仅拼接一个普通文本前缀。[控制器 L375](https://github.com/xiaoguiwucan/linux-wechat-agent/blob/58b2c43ff18597c6d0c9ec47270eb40e4fb0b2bb/agent_console/wechat_controller.py#L375)

但选人使用 alias 或昵称中的拉丁词，而非可靠的成员 ID；成功校验是复制输入框后检查显示昵称出现、原始 alias 消失，未检查 @ 对象的底层身份或格式。中文昵称缺少可用 alias、重复昵称、alias 与显示名相同、弹窗布局变化，都需要单独测试。代码没有证明企微身份成员的候选搜索与微信成员一致，不能把普通群里一次蓝色 @ 成功推广为本需求已达成。[检索词选择 L3424](https://github.com/xiaoguiwucan/linux-wechat-agent/blob/58b2c43ff18597c6d0c9ec47270eb40e4fb0b2bb/agent_console/app.py#L3424)、[剪贴板校验 L225](https://github.com/xiaoguiwucan/linux-wechat-agent/blob/58b2c43ff18597c6d0c9ec47270eb40e4fb0b2bb/agent_console/wechat_controller.py#L225)

### 入站 @ 与引用回复：两者证据不同

`detect_bot_mention` 先在正文里查找 `@昵称/别名`，再执行宽松昵称命中；别名还包括配置名、个人备注/昵称及若干预置词。该路径没有读取原始 `atuserlist` 或等价身份字段，所以 `mentions_bot_explicit` 也只是文本匹配结果，不能证明对方使用了真正的 @。手打 `@昵称` 会与真 @ 混淆。[入站判断 L11635–11698](https://github.com/xiaoguiwucan/linux-wechat-agent/blob/58b2c43ff18597c6d0c9ec47270eb40e4fb0b2bb/agent_console/app.py#L11635)

引用回复则有独立 XML 解析：读取 `refermsg` 的发送者、内容和类型，生成结构化 `quote`。这是普通引用解析存在的证据，尚不证明外部群的全部引用变体正确。[引用解析](https://github.com/xiaoguiwucan/linux-wechat-agent/blob/58b2c43ff18597c6d0c9ec47270eb40e4fb0b2bb/memory/message_parse.py#L112)

维护判断：当前公开提交及更新日志集中到 2026-06-20。它可以作为原型参考，但本需求至少需要补齐外部群识别、两种身份映射、原始 @ 元数据和版本回归；本轮没有运行这些修改或验证它们的工作量。

## 3. Wine + jwping/wxbot：有消息接口，但客户端年代是主要障碍

固定源码 [41883983d53925b7ddd487e4bb0ccfda8ec26a53](https://github.com/jwping/wxbot/commit/41883983d53925b7ddd487e4bb0ccfda8ec26a53)，最近提交 2024-01-30。README 的当前免 DLL 注入实现只支持 Windows 微信 **3.9.8.25**，并明确“免注”不代表完全不注入。Dockerfile 安装 Wine/i386 支持，复制 Windows 微信和 `wxbot-sidecar.exe`；这是 Wine 运行 Windows 客户端，不能称为原生 Linux 微信 API。公开构建没有 ARM64 原生运行证据。[README](https://github.com/jwping/wxbot/blob/41883983d53925b7ddd487e4bb0ccfda8ec26a53/README.md#关于免注)、[Dockerfile](https://github.com/jwping/wxbot/blob/41883983d53925b7ddd487e4bb0ccfda8ec26a53/docker/Dockerfile)

接口层确有 `/api/sendtxtmsg`、群 `atlist` 和 HTTP/WebSocket 普通消息回调，回调还列出引用内容、消息 ID、原始扩展字段。然而示例围绕 `@chatroom`，未确认企微创建外部群及企微成员 @；也没有当前微信服务器仍允许这个旧版登录的实测。作者本人称 Docker 镜像测试时间短、稳定性未知。基础消息 API 比云微完整，但这些接口说明不能覆盖当前登录与目标群的前置条件。[发送字段](https://github.com/jwping/wxbot/blob/41883983d53925b7ddd487e4bb0ccfda8ec26a53/README.md#L326)、[消息回调](https://github.com/jwping/wxbot/blob/41883983d53925b7ddd487e4bb0ccfda8ec26a53/README.md#L712)

## 4. Web/UOS 类：不能因支持 Linux 就算符合需求

[danni-cool/wechatbot-webhook](https://github.com/danni-cool/wechatbot-webhook) 的 main 明确基于 Web 微信 API，依赖 Wechaty/Wechat4u，支持 Docker amd64/arm64。作者 README 提示周期性掉线；仓库已于 **2025-01-10 归档**。其 [issue #142 作者回复](https://github.com/danni-cool/wechatbot-webhook/issues/142) 明确指出 Web 协议不支持企业消息，并说明 UOS 对企微场景支持有限。Windows 分支作者当时也尚未测试企业外部群。因此这类路线不进入本需求优先验证列表。[依赖清单](https://github.com/danni-cool/wechatbot-webhook/blob/main/package.json)

需要避免名称误导：**WechatOnCloud / wechat-selkies 的“浏览器微信”是浏览器里的远程 Linux 桌面；这里的 Web/UOS 机器人则使用 Web 协议，两者不是同一个技术限制。**

## 5. Linux 控制实体 Android：可行的控制层，仍需微信专项实现

[Android 官方 ADB](https://developer.android.com/tools/adb) 支持与设备通信；[openatx/uiautomator2](https://github.com/openatx/uiautomator2) 提供 Android UI 查询、点击、文本输入等能力；[Appium UiAutomator2 Driver](https://github.com/appium/appium-uiautomator2-driver#requirements) 明确支持 Linux、macOS、Windows 主机及实体设备。实际微信运行在手机上，因此不依赖 Wine 和上述旧 Windows 客户端。

对本需求，理论上可通过手机群成员候选完成真正 @，也可读取当前聊天界面；但这些框架自身不提供微信全量消息订阅、跨群持续覆盖、两类成员身份解析或可靠引用结构。本轮未确认一个公开维护的微信专项实现已覆盖目标混合群，故只列作自研 UI 备选。后续验证需要一台可授权调试的实体 Android，持续接收还要处理界面切换、锁屏/后台状态及消息去重；不能把“Linux 能控制手机”写成“Linux 纯服务器已接入微信”。

## 建议验证顺序

1. 若继续 Linux，先用原生客户端确认目标外部群正常显示、普通收发及两类成员 @ 可人工完成，记录精确 Linux 微信版本与架构。
2. 对数据库读 + UI 写方案，先查目标群 ID、消息入库位置、企微成员 ID 与原始 @/引用字段。`linux-wechat-agent` 的现成过滤与文本识别必须先修正，才能评价其持续监听表现。
3. UI 发送应分别验证微信成员、企微成员、重复昵称、无微信号/中文昵称和目标群切换；以收件人实际收到 @ 为准，不能只看发送框文字颜色或 API 返回成功。
4. 云微/Selkies 可选作运行底座；Wine 旧版和 Web/UOS 不作为本次需求主线。实体 Android 保留为需要设备的备选。

本轮未发现上述 Linux 仓库必须购买商业订阅的明确一手依据；这并不等于部署与长期维护没有成本。未执行软件，因而报告中的“源码存在实现”均不等于“已在用户账号和目标群实测可用”。
