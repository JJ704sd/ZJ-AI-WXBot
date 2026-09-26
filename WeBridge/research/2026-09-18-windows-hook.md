# Windows 微信 Hook 接入调研

日期：2026-09-18。按最新偏好：能让 Mac/Windows 共用最好；做不到时优先 Windows。业务目标仍是**个人微信号**进入企微创建的外部混合群，持续接收未 @ 的普通消息、主动发送、真正 @ 微信和企微成员，以及可靠识别自己被 @。

## 结论与验证优先级

**本轮未发现能够据公开一手证据确认、开箱满足全部条件的 Windows 4.x 项目。** 最值得继续的只有两条：一条有可读的 4.x C++ 实现但功能缺口明确，另一条有较匹配的供应商能力宣称但核心与商业条款不公开。旧 wxhelper/WeChatFerry 可作技术参考，不应包装成当前 4.x 现成方案。

| 优先级 | 候选 | 已有依据 | 未解决项 | 下一步价值 |
|---|---|---|---|---|
| 1：自研基线 | `mosheng20205/WechatHook4.1.10.27`，连同上游 `aixed/WeChat-Hook` | 实际 C++ DLL 核心、微信 4.1.10.27 x64 收发/HTTP 代码；派生版有作者普通群真机记录 | 混合群识别缺失；发送 @ 未接通；回调没有被 @ 元数据；项目复用许可证未声明 | 最适合先做源码 PoC，不能直接当成最终机器人 |
| 2：功能可行性对照 | `miloira/wxhook` 作者提供的新版 **pywechat** | 作者宣称支持微信 4.x，并列有企业联系人、企业群、企业群成员、群 @ 接口 | 新版核心不在公开库；个人号外部群四项能力未经本次实测；收费方式/价格/授权未找到公开确认 | 要求针对同一测试外部群演示或试用，再决定是否采购或独立实现 |

跨平台可以在**上层接口**实现：把 Windows x64 微信接入端独立成服务，通过 HTTP/WebSocket 供 Mac 或 Windows 业务程序调用。它不等于同一份 Hook DLL 可以在 macOS 运行。Mac 原生 Hook 仍可作为单独适配器，见 [Mac 研究报告](2026-09-18-mac-hook.md)。

## 方法与证据等级

- **A：** 当前固定 commit 的公开源码、构建文件或 GitHub 仓库元数据。
- **B：** 作者 README/接口文档/真机验证记录中的宣称。本次没有复现。
- **C：** 从 A/B 推导的判断，尚需测试。

本轮只通过 GitHub API 和 raw 文本地址下载源码及文档到 `/private/tmp/wechat-windows-research/`。没有下载 DLL/EXE、运行下载代码、登录测试号或修改本机微信。两份 WCF `resource.h` 因源编码不是 UTF-8 未存入文本集，不影响本次收发与版本结论。用户尚未提供 Windows 具体设备和客户端 build，因此没有 Windows 动态验证。

固定审阅版本：

| 仓库/分支 | Commit |
|---|---|
| miloira/wxhook / master | [d6d1cec](https://github.com/miloira/wxhook/tree/d6d1cecd7c13f347b776a49442ecadadae55d5ec) |
| aixed/WeChat-Hook / main | [e905d07](https://github.com/aixed/WeChat-Hook/tree/e905d07ade50d2c6472e4eb3bd4f3fe19cf662c6) |
| mosheng20205/WechatHook4.1.10.27 / 默认分支 | [713ec7d](https://github.com/mosheng20205/WechatHook4.1.10.27/tree/713ec7d6f01d858e067a623c9bf2cda64d0d3e19) |
| ttttupup/wxhelper / dev-3.9.11.25 | [36ecd7e](https://github.com/ttttupup/wxhelper/tree/36ecd7e349df6954393f75e30e38e89710d399aa) |
| lich0821/WeChatFerry / 3.9.12.56 | [9081f0b](https://github.com/lich0821/WeChatFerry/tree/9081f0bbc5081eae1a6b7f65d5ae5b3db5d79431) |
| wukangcheng2944/WeChatFerry / main | [157bc6a](https://github.com/wukangcheng2944/WeChatFerry/tree/157bc6a00761ddac91669328f05243dd259cc6fb) |

## 1. 有公开核心的 Windows 4.x 路线

### aixed 与 mosheng 派生版是什么

**A/B：** aixed 当前公开项目是 Windows x64 的 `version.dll` 代理加载方式，目标微信 `4.1.10.27`；有 DLL 入口、代理导出、原生文本发送、XML 发送、数据库访问源码，而非只有 Python HTTP 包装。其 README 明确说当前 main 移除了 VMP、远程授权校验和若干 PB/CDN 相关处理。不能据这个说明推定完整版功能在公开版本中完整保留。来源：[aixed README](https://github.com/aixed/WeChat-Hook/blob/e905d07ade50d2c6472e4eb3bd4f3fe19cf662c6/README.md)、[构建工程](https://github.com/aixed/WeChat-Hook/blob/e905d07ade50d2c6472e4eb3bd4f3fe19cf662c6/x64_Version_dll.vcxproj)。

**A：** aixed 公开初始化流程主要启动 HTTP、设置撤回补丁和读取回调地址；这里没有一个完整实时消息分发的安装流程。不能把其更广的 ShowDoc API 列表直接当作这个 commit 已有全部功能。来源：[inline_weixin_dll_load.cpp 185–212](https://github.com/aixed/WeChat-Hook/blob/e905d07ade50d2c6472e4eb3bd4f3fe19cf662c6/src/inline_weixin_dll_load.cpp#L185-L212)。

**A/B：** mosheng 派生版补充了真实接收路径、异步回调、联系人查询、收发诊断及普通好友/群自动回复，保存了作者的逆向和真机测试记录。它因此更适合作为本轮源码研究起点。README 同时说明文本发送结果代表本地入队，不代表服务器或收件端已送达。来源：[派生版 README](https://github.com/mosheng20205/WechatHook4.1.10.27/blob/713ec7d6f01d858e067a623c9bf2cda64d0d3e19/README.md)、[接收说明](https://github.com/mosheng20205/WechatHook4.1.10.27/blob/713ec7d6f01d858e067a623c9bf2cda64d0d3e19/docs/RECEIVE_MESSAGE_NOTES_4.1.10.27.md)、[发送说明](https://github.com/mosheng20205/WechatHook4.1.10.27/blob/713ec7d6f01d858e067a623c9bf2cda64d0d3e19/docs/SEND_MESSAGE_NOTES_4.1.10.27.md)。

### 普通接收不要求 @，但外部群语义有缺口

**A：** 派生版通过已校验的 `micromsg.AddMsg` 结构提取 from/to/content/type，对普通收到的消息进行 webhook 分发，然后才单独判定是否自动回复；回调本身没有要求消息必须 @ 自己。来源：[inline_weixin_dll_load.cpp 3936–4017](https://github.com/mosheng20205/WechatHook4.1.10.27/blob/713ec7d6f01d858e067a623c9bf2cda64d0d3e19/src/inline_weixin_dll_load.cpp#L3936-L4017)。

**A：** `IsGroupWxid()` 仍只判断 `@chatroom`，`IsLikelyWxid()` 只容纳 `wxid_`、`@chatroom`、`filehelper`、`gh_`；群正文成员前缀拆分也调用后者。整个所读核心源码未找到 `@im.chatroom`/`@openim` 专用分支。来源：[inline_weixin_dll_load.cpp 3269–3310](https://github.com/mosheng20205/WechatHook4.1.10.27/blob/713ec7d6f01d858e067a623c9bf2cda64d0d3e19/src/inline_weixin_dll_load.cpp#L3269-L3310)。

**C：** 假如外部群 ID 是 `xxx@im.chatroom` 且消息进入当前 AddMsg 回调，它可能被输出但 `room` 为空、真实发送人无法按群提取；如果外部群使用另一消息路径，现有 Hook 可能完全收不到。不能只改群后缀判断就宣布兼容。`@openim` 成员即便进入正文，也不能假定当前成员识别与普通成员等价。

### 双身份真实 @ 和被 @ 识别没有闭环

**A：** `/SendTextMsg` 只读 `wxidorgid` 和 `msg`。底层结构声明 `atlist` 字段，但 `BuildTextMessage` 只设置目标、正文、长度和消息类型，调用 API 没有传入被 @ 用户列表。它目前不是一个已接通的真 @ API。来源：[SendTextMsg.cpp 30–51](https://github.com/mosheng20205/WechatHook4.1.10.27/blob/713ec7d6f01d858e067a623c9bf2cda64d0d3e19/src/SendTextMsg.cpp#L30-L51)、[wx_send.cpp 135–153](https://github.com/mosheng20205/WechatHook4.1.10.27/blob/713ec7d6f01d858e067a623c9bf2cda64d0d3e19/src/wx_send.cpp#L135-L153)、[437–455](https://github.com/mosheng20205/WechatHook4.1.10.27/blob/713ec7d6f01d858e067a623c9bf2cda64d0d3e19/src/wx_send.cpp#L437-L455)。

**A：** 实时 webhook 输出 msgtype/fromid/toid/room/sender/msg 等，没有 `msgsource`、`atuserlist` 或等价的真实 mention 字段；`msgsvrid` 还固定为 0，`time` 使用进程计时值。被 @ 判断和可靠去重不能直接建立在这份回调之上。来源：[inline_weixin_dll_load.cpp 3668–3701](https://github.com/mosheng20205/WechatHook4.1.10.27/blob/713ec7d6f01d858e067a623c9bf2cda64d0d3e19/src/inline_weixin_dll_load.cpp#L3668-L3701)。

**C：** 该项目“可研究”的意思是我们能审查和定位现有收发结构，在对应测试客户端补协议与字段；不是已经具备所需真 @ 的最终成品。仓库内复制的文档即便有“发送群 @”页面，也不能替代实际路由和参数实现。

### 版本、平台与复用授权

**A/B：** 这条公开代码路线锁定 `4.1.10.27`，使用 Windows x64 原生结构/偏移。没有找到 Windows ARM64 或 Apple Silicon 下 Windows ARM 虚拟机的验证证据。第一轮验证最好用原生 Intel/AMD Windows x64；ARM 环境即便能模拟运行 x64 程序，也需要单独确认目标微信确为相同 x64 二进制和 Hook 可用，不能默认兼容。来源：[上游版本/编译说明](https://github.com/aixed/WeChat-Hook/blob/e905d07ade50d2c6472e4eb3bd4f3fe19cf662c6/README.md)、[派生版构建工程](https://github.com/mosheng20205/WechatHook4.1.10.27/blob/713ec7d6f01d858e067a623c9bf2cda64d0d3e19/x64_Version_dll.vcxproj)。

**A：** 两个仓库的 GitHub `license` 元数据均为 null，文件树只发现第三方 MinHook 的 LICENSE，没有项目自身明确许可证。因此准确称谓是“公开可读核心源码”，不能凭 GitHub 可见就按 MIT/可自由商用项目复用。需确认作者授予的复用/修改/分发权限；这和本次静态阅读是不同层次。来源：[aixed 仓库元数据](https://api.github.com/repos/aixed/WeChat-Hook)、[mosheng 仓库元数据](https://api.github.com/repos/mosheng20205/WechatHook4.1.10.27)、上表固定 commit 文件树。

## 2. miloira 的新版 pywechat：适合验收，不足以判定可自建核心

**A：** 公开 `wxhook` Python 类把版本固定为 `3.9.5.81`，HTTP 包装调用 `/api/sendTextMsg` 和 `/api/hookSyncMsg`；启动依赖仓库中的 `wxhook.dll`、`start-wechat.exe`。公开文件树没有这些核心的 C/C++ 源码，也没有新版 `pywechat` 包实现。来源：[core.py 40–91](https://github.com/miloira/wxhook/blob/d6d1cecd7c13f347b776a49442ecadadae55d5ec/wxhook/core.py#L40-L91)、[119–164](https://github.com/miloira/wxhook/blob/d6d1cecd7c13f347b776a49442ecadadae55d5ec/wxhook/core.py#L119-L164)、[utils.py 10–20](https://github.com/miloira/wxhook/blob/d6d1cecd7c13f347b776a49442ecadadae55d5ec/wxhook/utils.py#L10-L20)、[文件树](https://github.com/miloira/wxhook/tree/d6d1cecd7c13f347b776a49442ecadadae55d5ec)。

**B：** 同一作者的 README 把旧开源版和需进群获取的新版 `pywechat` 分开，并宣称新版支持微信 3.x/4.x；接口表包含群 @、企业联系人、企业群、企业微信群成员。GitHub 仓库当前描述列至微信 `4.1.13.56`。这是与需求较贴近的供应商声明，但**不能证明个人微信登录后，在企微创建的外部群中可完成双身份 @ 和全量接收**；它同时宣传个人微信与企微客户端适配，更要明确演示使用的是哪一种登录身份。来源：[README 111–175](https://github.com/miloira/wxhook/blob/d6d1cecd7c13f347b776a49442ecadadae55d5ec/README.md#L111-L175)、[仓库当前描述](https://github.com/miloira/wxhook)。

名称消歧：本文 `pywechat` 专指 **miloira 在 wxhook README 中推广的 DLL Hook 产品**，不是同名的 UI/RPA Python 项目。

**A/B：** 公开旧库的许可证为 MIT；它不自动成为新版 pywechat 核心的授权条款。已查一手公开内容只给出获取渠道，未发现可确认的价目表、按月/按年订阅、永久许可、设备绑定或源码买断条款。因此“商业待确认/试用”比“已确定付费订阅可用”准确。来源：[旧库 LICENSE](https://github.com/miloira/wxhook/blob/d6d1cecd7c13f347b776a49442ecadadae55d5ec/LICENSE)、[新版获取说明](https://github.com/miloira/wxhook/blob/d6d1cecd7c13f347b776a49442ecadadae55d5ec/README.md#L111-L118)。

若考虑付费，最有价值的请求是一次有具体版本号和双身份外部群的演示/短期试用，并同时问清：是个人微信登录还是企微登录；是否需要联网授权；是否能完全在用户自己的 Windows 机器上运行；价目与更新策略；有没有可审查源码/SDK 以及独立实现所需的接口文档。核心未公开前，不能承诺通过阅读当前 Python 包装就能摆脱厂商依赖。

## 3. 为什么 wxhelper / WeChatFerry 暂不进入前两名

**A：wxhelper 未找到官方 4.x 活跃分支。** 当日 GitHub API 的完整分支列表中最高具名适配分支为 `dev-3.9.11.25`，没有 4.x 分支。该分支确有原生 `SendAtText`：向发送函数传入成员向量，收消息也输出原始 signature，具有研究价值。但它是旧版本结构，不能据此保证微信 4 或外部群可用。来源：[官方分支列表](https://github.com/ttttupup/wxhelper/branches/all)、[分支 API](https://api.github.com/repos/ttttupup/wxhelper/branches?per_page=100)、[SendAtText 717–761](https://github.com/ttttupup/wxhelper/blob/36ecd7e349df6954393f75e30e38e89710d399aa/app/wxhelper/src/wechat_service.cc#L717-L761)、[SyncMsgHook 23–61](https://github.com/ttttupup/wxhelper/blob/36ecd7e349df6954393f75e30e38e89710d399aa/app/wxhelper/src/sync_msg_hook.cc#L23-L61)。

**A/B：WeChatFerry 已归档，后继未证明覆盖 4.x。** 官方仓库页面注明 2026-07-10 归档。已检查的 `3.9.12.56` 分支明确迁回 x86；其接收代码也只用 `@chatroom` 判断群。虽然群邀请实现出现 `@im.chatroom`/OpenIM 注释，那只证明该操作有相关内部分流，不能推导消息接收和 @ 的闭环。来源：[官方仓库](https://github.com/lich0821/WeChatFerry)、[3.9.12.56 README](https://github.com/lich0821/WeChatFerry/blob/9081f0bbc5081eae1a6b7f65d5ae5b3db5d79431/README.MD#L231)、[offsets.h 5–6](https://github.com/lich0821/WeChatFerry/blob/9081f0bbc5081eae1a6b7f65d5ae5b3db5d79431/WeChatFerry/spy/offsets.h#L5-L6)、[接收判断 170–179](https://github.com/lich0821/WeChatFerry/blob/9081f0bbc5081eae1a6b7f65d5ae5b3db5d79431/WeChatFerry/spy/message_receiver.cpp#L170-L179)、[邀请实现](https://github.com/lich0821/WeChatFerry/blob/9081f0bbc5081eae1a6b7f65d5ae5b3db5d79431/WeChatFerry/spy/chatroom_manager.cpp#L154)。

**A：** 已查看的独立后继 `wukangcheng2944/WeChatFerry` 提供 VS2022 构建修复，但运行时仍硬性要求 `3.9.12.51`。它是维护旧客户端的参考，不是微信 4 的后继接入证明。来源：[后继 README 1–15](https://github.com/wukangcheng2944/WeChatFerry/blob/157bc6a00761ddac91669328f05243dd259cc6fb/README.MD#L1-L15)、[spy.h](https://github.com/wukangcheng2944/WeChatFerry/blob/157bc6a00761ddac91669328f05243dd259cc6fb/WeChatFerry/spy/spy.h#L9)。

旧源码可审查、可以编译、作者曾经登录成功，都不等于 2026-09-18 新装该旧微信一定能登录；本轮没有验证这些旧版的当前登录状态。

## 4. Windows 最小验证计划

1. 确认一台 Windows 机器的 CPU 架构、系统版本及微信完整四段版本；优先原生 x64。客户端版本必须和源码偏移/供应商版本对应。若只能使用更新的微信，应明确安排版本移植，不能只改显示版本绕过本地校验。
2. 先以测试个人微信号加入一个测试企微外部群，另备微信成员和企微成员。分别发送未 @ 文本、@ 测试号、普通回复。记录群标识、两类成员标识、稳定消息 ID、服务端时间与真实 mention 元数据。采用 mosheng 源码时，这一步主要验证接收路径并补输出字段。
3. 再测主动发普通文本、分别 @ 微信和企微成员。接收端须确认真实提醒，不能以可见 `@昵称` 或本地 API `ret=0` 代替。采用公开 4.x 源码时，@ 参数和外部群协议需要新增并验证；供应商试用也必须通过相同验收。
4. 通过以上功能后才做持续性测试：未 @ 消息持续流入、重复消息去重、重启/断网恢复和账号切换隔离。把 Windows 接入适配器输出为统一 HTTP/WebSocket 接口，供 Mac/Windows 上层代码共用。

对“能否逆向/自建”的当前回答：**已有公开的 Windows 4.x 核心足以展开独立实现研究，但没有证据可承诺低成本补齐外部群和双身份真 @。** 先做上述小范围 PoC 比先购买长期订阅更能降低不确定性；商业版可用作对照验证，而是否值得购买需以实际验收与明确条款决定。
