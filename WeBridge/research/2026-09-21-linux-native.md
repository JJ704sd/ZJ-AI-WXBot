# Linux 原生微信与自建接入核查

核查日期：2026-09-21。目标：个人微信账号加入企微创建的外部混合群，持续获取未被 @ 的普通消息、主动发送、真实 @ 微信及企微成员、识别自己被 @。仅查官方网页及公开源码；未运行项目、下载客户端二进制、登录账号或修改客户端。

证据等级：**A**＝官方页面或可定位源码直接支持；**B**＝作者文档/注释宣称；**C**＝由源码推断、尚需真实客户端验证。A 级源码证据不等于运行验证。

## 结论

Linux 确实有官方原生微信，也找到了有实际 Linux 收读与主动发送代码的 **thisnick/agent-wechat**。它是本轮新增、值得做隔离验证的自建候选，但属于“Frida + 本地数据库读取 + 虚拟桌面 RPA 发送”的混合方案，不能标为完整的纯协议方案。目前源码明确缺少主动真实 @，并且外部群识别存在缺口；没有证据表明它已满足本项目全部要求。**yincongcyincong/wechat_chatter 当前公开实现仍是 Mac arm64，不应因 linux.do、Mars 三端说法或 Go 交叉编译注释而算作 Linux 支持。**

## 1. 官方 Linux 客户端

**A：**[微信 Linux 官方下载页](https://linux.weixin.qq.com/)在核查时显示 **4.1.13**，提供 x86_64 与 arm64 的 deb、rpm、AppImage，以及 LoongArch 的 deb。网页标题是“微信 Linux 版”；这是官方原生 Linux 下载入口，不能与 Wine 跑 Windows 微信混同。本次取得官网 HTML，未下载安装包，因此没有核实包内更细版本号、ELF BuildID 或运行依赖下限。官方页面也没有给出面向个人号群消息的公开收发 API 或本需求验收证明。

架构事实的直接入口：[x86_64 deb](https://dldir1v6.qq.com/weixin/Universal/Linux/WeChatLinux_x86_64.deb)、[arm64 deb](https://dldir1v6.qq.com/weixin/Universal/Linux/WeChatLinux_arm64.deb)。链接为滚动下载地址，不是固定版本证据。

## 2. agent-wechat：有 Linux 实现，但是真实 @ 与外部群仍有缺口

审阅固定提交：[da066f501adb8454514051520007117776081332](https://github.com/thisnick/agent-wechat/tree/da066f501adb8454514051520007117776081332)。仓库可见源码包括 Rust 服务、Python/Frida 工具、Docker、TypeScript SDK/Wechaty/OpenClaw 适配；不是只公开客户端封装、把全部能力藏在未公开 DLL 中。

### 架构、版本与部署边界

- **A：**Docker 使用 `ubuntu:22.04`，安装 Xvfb、fluxbox、AT-SPI、xdotool、Frida、SQLCipher；`TARGETARCH` 选择官方 `arm64` / `x86_64` deb。发送发生在容器内原生微信的虚拟桌面，不是调用宿主机 Mac 或 Windows 微信。[Dockerfile](https://github.com/thisnick/agent-wechat/blob/da066f501adb8454514051520007117776081332/docker/Dockerfile#L34-L119)
- **A：**构建脚本有 `linux/amd64`、`linux/arm64` 两条路径。[build-images-local.sh](https://github.com/thisnick/agent-wechat/blob/da066f501adb8454514051520007117776081332/scripts/build-images-local.sh#L89-L104) 因此同一 Linux 服务可部署到适合架构的 Linux 主机/容器；Mac、Windows 可作为 HTTP 客户端。**C：**这比独立开发 Mac/Windows 两套 Hook 更容易共享上层，但本次没有验证各宿主机的 Docker/虚拟化兼容性。
- **A/B：**关键选会话工具只内置四个 ELF BuildID 前缀：`5233a112`（注释 Linux 4.1.0.16 aarch64）、`f8713825`（注释 Linux 4.1.0.16 x86_64）、`3eda8254`（注释 Linux 4.x aarch64）、`eba86b80`（注释 Linux 4.x x86_64）。后两项没有在源码中标出完整产品版本；未知 BuildID 直接返回错误，不能把“4.x”理解为任意 4.x 兼容。[配置](https://github.com/thisnick/agent-wechat/blob/da066f501adb8454514051520007117776081332/docker/tools/chat-select.py#L25-L79)、[版本检查](https://github.com/thisnick/agent-wechat/blob/da066f501adb8454514051520007117776081332/docker/tools/chat-select.py#L116-L150)
- **C：**Docker 默认下载官网滚动最新版，而 Hook 配置是固定 BuildID，存在明确的兼容性闸门。应先比对实际安装包 BuildID，再决定使用已支持基线或适配新构建；目前既不能断言最新 4.1.13 已匹配，也不能凭版本名断言它必然不匹配。本次未构建，不宣称构建已通过或发现编译失败。
- **A：**容器要求 `SYS_PTRACE`、`seccomp=unconfined`，示例另给 `NET_ADMIN`；不是普通受限 serverless 容器配置。[docker-compose.yml](https://github.com/thisnick/agent-wechat/blob/da066f501adb8454514051520007117776081332/docker-compose.yml#L7-L18) 这不要求关闭当前 Mac 的 SIP，因为目标微信进程在 Linux 环境；仍需有相应容器权限。

### 收普通消息及外部群识别

**A：**接收是本地读库路径：Frida 工具获取数据库访问材料，服务读取 `session.db`、`contact.db`、`message_*.db`。消息查询针对 `Msg_{MD5(chat_id)}`，选择正文、发送者、时间与 `source`，没有“必须 @ 本人”条件。[wechat_messages.rs](https://github.com/thisnick/agent-wechat/blob/da066f501adb8454514051520007117776081332/packages/agent-server-rust/src/tools/wechat_messages.rs#L180-L251) Wechaty 适配默认轮询，检查未读及已跟踪会话的新消息并发出事件，亦不要求被 @；但只列最近 50 个会话并有自己的游标/未读策略，持续全量接收仍应另做压力、断线与补读验收。[pollMessages](https://github.com/thisnick/agent-wechat/blob/da066f501adb8454514051520007117776081332/packages/wechaty-puppet/src/puppet-agent-wechat.ts#L257-L358)

**A：**`session.db` 查询没有按 `@im.chatroom` 显式排除会话，仅 `WHERE is_hidden = 0`；但是群分类只有 `username.contains("@chatroom")`。[wechat_chats.rs](https://github.com/thisnick/agent-wechat/blob/da066f501adb8454514051520007117776081332/packages/agent-server-rust/src/tools/wechat_chats.rs#L24-L78) 消息读取同样用 `chat_id.contains("@chatroom")` 判断群；`@im.chatroom` 不包含这个完整子串，会走非群分支。[wechat_messages.rs](https://github.com/thisnick/agent-wechat/blob/da066f501adb8454514051520007117776081332/packages/agent-server-rust/src/tools/wechat_messages.rs#L219-L227)

**C：**因此应精确描述为：外部群消息在满足相同数据库/表结构条件时可能仍被原样读到，但会被错分类，群正文处理与提及解析被跳过；尚不能断言“完全收不到”，也不能断言“已支持混合群”。联系人代码识别 `@openim` 和 `local_type == 5`，这仅证明企业联系人分类有实现，不证明企业群收发、双身份 @ 已实现。[wechat_contacts.rs](https://github.com/thisnick/agent-wechat/blob/da066f501adb8454514051520007117776081332/packages/agent-server-rust/src/tools/wechat_contacts.rs#L25-L67)

### 主动发送及真实 @

**A：**主动普通文本有端到端代码路径：打开会话、聚焦输入框、输入文本、按 Enter、确认发送按钮禁用。[send_message.rs](https://github.com/thisnick/agent-wechat/blob/da066f501adb8454514051520007117776081332/packages/agent-server-rust/src/plans/send_message.rs#L115-L261) 实际输入工具是 `xclip` 加 `Ctrl+V`，属于界面自动化。[input](https://github.com/thisnick/agent-wechat/blob/da066f501adb8454514051520007117776081332/docker/tools/input#L13-L24)

**A：真实 @ 缺口不是仅缺文档。**REST `SendParams` 只有 chatId/text/image/file，没有 mention IDs；发送 FSM 没有输入 `@` 后选择成员候选的步骤。尤其 Wechaty 标准方法虽然接收 `_mentionIdList?: string[]`，实现将它忽略，只转发 `{chatId, text}`。[REST 入参](https://github.com/thisnick/agent-wechat/blob/da066f501adb8454514051520007117776081332/packages/agent-server-rust/src/router/messages.rs#L143-L150)、[明确忽略 mentionIdList](https://github.com/thisnick/agent-wechat/blob/da066f501adb8454514051520007117776081332/packages/wechaty-puppet/src/puppet-agent-wechat.ts#L505-L515)

**C：**将“@某人”粘贴进正文不能作为真实提及完成的证据。若沿此路线研发，需要补成员身份与候选选择/可靠客户端调用，然后在收件侧确认提及元数据和通知。修复群后缀判断也不会自动补齐这项能力。

### 被 @ 识别

**A：**`isMentioned` 基于数据库原始 `source` XML 的 `<atuserlist>`，按逗号拆出 ID 后与当前账号目录前缀比较；type 49 消息还会查正文 XML。它不是靠昵称文本包含“@我”判断。[ID 检查](https://github.com/thisnick/agent-wechat/blob/da066f501adb8454514051520007117776081332/packages/agent-server-rust/src/tools/wechat_messages.rs#L166-L178)、[元数据解析](https://github.com/thisnick/agent-wechat/blob/da066f501adb8454514051520007117776081332/packages/agent-server-rust/src/tools/wechat_messages.rs#L344-L377)

**A/C：**上述逻辑仅在 `is_group` 为真时执行，故当前 `@im.chatroom` 分类缺口直接导致其跳过被 @ 识别。未知混合群消息来源、企业成员 ID 形式、`@所有人` 等需用真实样本验证，不能从普通群逻辑外推。

### 授权状态

**A：**审阅提交没有找到项目顶层或子包的 LICENSE/COPYING；GitHub 元数据 `license: null`，检查的 package.json / Cargo.toml 也没有项目许可字段。[仓库固定树](https://github.com/thisnick/agent-wechat/tree/da066f501adb8454514051520007117776081332)、[Cargo.toml](https://github.com/thisnick/agent-wechat/blob/da066f501adb8454514051520007117776081332/packages/agent-server-rust/Cargo.toml)、[CLI package.json](https://github.com/thisnick/agent-wechat/blob/da066f501adb8454514051520007117776081332/packages/cli/package.json) 因此暂称“公开源码可研究项目”，不能据此确认商用修改/分发授权；落地复用前需明确许可。本次没有确认必须付费才能自建运行。

## 3. wechat_chatter 不能算已有 Linux 适配

固定提交：[04ae61400b9a5754431c10a1455e94c12c4b79e2](https://github.com/yincongcyincong/wechat_chatter/tree/04ae61400b9a5754431c10a1455e94c12c4b79e2)。**A：**构建依赖明确写 `OS="macos"`、`ARCH="arm64"`，发布包名是 `onebot_mac_arm64.tar.gz`；全部 15 个版本配置是 `_mac.json`，最高名称为 `4_1_11_53_mac.json`。[setup_frida_and_build.sh](https://github.com/yincongcyincong/wechat_chatter/blob/04ae61400b9a5754431c10a1455e94c12c4b79e2/setup_frida_and_build.sh#L4-L9)、[版本配置目录](https://github.com/yincongcyincong/wechat_chatter/tree/04ae61400b9a5754431c10a1455e94c12c4b79e2/wechat_version)

`build.sh` 的注释提到可设置 `GOOS=linux`/`GOARCH=amd64`，但两行处于注释状态，代码仍使用 Mac 配置、Frida 调用地址/架构约定；这最多是 Go 编译提示，不是 Linux 微信适配。README 的 linux.do 是社区链接，“三端最底层”是对 Mars 层的作者描述，不能代替 Linux 版本配置与运行证据。[build.sh](https://github.com/yincongcyincong/wechat_chatter/blob/04ae61400b9a5754431c10a1455e94c12c4b79e2/build.sh#L6-L25)、[README](https://github.com/yincongcyincong/wechat_chatter/blob/04ae61400b9a5754431c10a1455e94c12c4b79e2/README.md)

此外，现有收包处理只判断 `@chatroom`，本次完整源码文本检索未见 `@im.chatroom` / `openim` 专用实现；普通群的发送 `atuserlist` 逻辑也不能证明外部群兼容。GPL-3.0 许可及 Mac 细节见此前 [Mac 报告](./2026-09-18-mac-hook.md)。Linux 端要重新定位 ELF/架构/版本相关调用点并验证消息路径，不是改 GOOS 就能使用。

## 4. 旧 Linux Hook 只作参考

[lmclmc/linux-wechat-hook](https://github.com/lmclmc/linux-wechat-hook/tree/2631a33cb48001f121f7d164c7ef3a6412f55a84) 是真实 Linux/x86_64 代码，但 README 固定 `wechat-beta_1.0.0.145_amd64.fixed.deb`，要求替换应用和 libX.so，定位为收消息 Hook。[README](https://github.com/lmclmc/linux-wechat-hook/blob/2631a33cb48001f121f7d164c7ef3a6412f55a84/README.md) 示例核心从 x86_64 寄存器指向内存打印字符串，并不是完成的群消息 API、主动发送或 @ 实现。[wechat_hook.cpp](https://github.com/lmclmc/linux-wechat-hook/blob/2631a33cb48001f121f7d164c7ef3a6412f55a84/demo/wechat_hook.cpp#L109-L151) 没有当前 4.1.13 适配、旧版仍能登录或外部群能力的证据，未找到项目级许可证；不列为优先落地候选。

## 建议的最小验证范围

如果接受界面发送作为备选，Linux 首选验证 agent-wechat，先做以下闸门，不把它当成现成完整解决方案：

1. 在隔离 Linux arm64/amd64 环境比对官方客户端完整版本及 ELF BuildID，并固定可复现安装包；验证登录、取库、选中会话与主动发普通文本。对未知构建先适配，不能盲用旧地址。
2. 用一个由企微创建、同时包含个人微信与企微身份的测试群，核对实际会话/成员 ID、数据库表及 source；分别收普通文本和真实 @ 样本，确认群分类、发送者与被 @ 元数据。补分类必须以样本为依据。
3. 补真实 @ 输出接口与实际成员选择/客户端调用，分别验证 @ 微信、@ 企微、同名成员、多成员，收件端确认真实提及而不是仅显示文本。之后再做断线重连和消息补读验证。

在这三步通过前，Linux 的准确结论是“有值得研发验证的自建混合方案”，不是“已存在满足全部需求的原生 Linux Hook 成品”。
