# Mac 路线：已执行的静态适配前置验证

日期：2026-09-21。本轮已经读取安装包和应用磁盘文件、下载腾讯官方旧版 DMG、只读挂载、计算摘要，并用 LLDB 的文件目标作有限反汇编。没有启动下载的微信、附加运行进程、读取聊天数据、修改/重签现用应用或关闭 SIP。

**结论：旧版精确基线已取得；本机新版有可用的静态定位入口，可以继续适配，但目前还没有可运行的 4.1.13.10 Hook 配置。** 不需要为了开始研究而降级 `/Applications/WeChat.app`。

## 已确认的本机状态

| 项目 | 实测值 |
| --- | --- |
| 应用路径 | `/Applications/WeChat.app` |
| `WeChatBundleVersion` | `4.1.13.10` |
| `CFBundleShortVersionString` / build | `4.1.13` / `269578` |
| Bundle ID / 签名 TeamIdentifier | `com.tencent.xinWeChat` / `5A4RE8SF68` |
| 最低系统版本（Info.plist） | `12.0` |
| 主程序和核心架构 | universal：x86_64 + arm64；本轮分析 arm64 |
| 真正核心 | `Contents/Resources/wechat.dylib`；`Contents/MacOS/WeChat` 是 loader |
| 当前 ARM64 核心 SHA256 | `eaa877e144bd45e78098f88d8981f203ec52fba830c3bd79532e176dcafeb82c` |
| 当前 ARM64 核心 UUID | `07ee7cda-5f9b-38a2-9e0c-e4df83db22e4` |
| SIP | `enabled` |

完整输出见 [mac-current-probe.json](./mac-current-probe.json)。`nm` 对目标关键字的检查只找到 `_WeChatMain`、`_SetWeixinCallbackFunc`；没有可直接按名称解析的 `MMStartTask`、`Req2Buf`、`Buf2Resp`、`AutoBuffer` 实现符号。但核心保留了函数边界表（本轮解析到 374,291 个 `LC_FUNCTION_STARTS` 条目）以及 `MMStartTask`、`MMReq2Buf`、`MMBuf2Resp`、`Req2Buf`、`Buf2Resp` 等日志字符串，因此可以结合交叉引用和新旧函数对比定位。

`codesign --verify --deep --strict` 当前返回 `invalid signature ... In architecture: arm64`；读取 entitlement 也报告无效 blob。**刚从腾讯 CDN 下载并只读挂载的旧包在当前执行环境里出现相同校验失败。** 所以此处只记录校验原始失败，不能据此断言现用应用遭到修改。DMG 校验及其内部核心/主程序摘要另有独立证据；本轮没有尝试“修复签名”。原始输出分别在两个 probe JSON 中。

## 精确旧基线确实可取得

已从[腾讯官方 CDN](https://dldir1v6.qq.com/weixin/Universal/Mac/xWeChatMac_universal_4.1.11.53_41748.dmg)下载：

- 本地文件：[xWeChatMac_universal_4.1.11.53_41748.dmg](../downloads/mac/xWeChatMac_universal_4.1.11.53_41748.dmg)
- 大小：494,489,257 bytes（约 472 MiB）。SHA256：`ea80413fca0ea09eb4241e333a8f09862d33c6c967e6ab66244fd474e6ab4115`。
- `hdiutil verify`：DMG 各分区及总体 CRC32 校验通过，总体 `C0E2C78F`。
- **文件名的 `41748` 不是挂载后应用的当前内部 build。** 实际 Info.plist：`WeChatBundleVersion=4.1.11.53`、`CFBundleVersion=269109`。
- 主程序 SHA256：`b583a21419f798ff55e3a53560c508bde507365898db12a33028a8718f9f5352`；ARM64 核心 SHA256：`ca241e81235fde5ab37b985f6189afa3c2a8c092b1e54aeebeecec8f51508432`。两者都与 [Classic 固定目标清单](https://github.com/xiaoguiwucan/wechat-mac-hook-classic/blob/3180313e08c24bf8c38e788527360d1b8d911f3d/config/wechat_target.json)完全一致。

来源线索由 [X1a0He 项目维护者的历史原版链接列表](https://github.com/X1a0He/X1a0HeWeChatPlugin)提供，下载本身直连腾讯 CDN；未下载或运行该第三方项目的插件。另试探按内部 build 拼接的 `_269109.dmg` URL 返回 404，但不影响已取得的 `_41748.dmg` 内部恰好符合 Classic 清单。证明文件见 [mac-baseline-verification.json](./mac-baseline-verification.json)、[mac-old-probe.json](./mac-old-probe.json)。

旧基线取得的是**静态参考和未来隔离验证材料**，不证明旧客户端今天一定能登录。不能仅把同 Bundle ID 的 App 复制到另一个目录，就视为与现用账号/数据完全隔离。

## 本机新版的适配突破口

下列地址均为 ARM64 核心的静态 RVA/虚拟地址，未加运行时装载基址。**它们是分析线索，不是已授权注入或调用的配置。** 旧值来自 [wechat_chatter 固定配置](https://github.com/yincongcyincong/wechat_chatter/blob/04ae61400b9a5754431c10a1455e94c12c4b79e2/wechat_version/4_1_11_53_mac.json)。

| 对象 | 旧配置 | 新版静态候选 | 已有证据及缺口 |
| --- | --- | --- | --- |
| `sendFuncAddr` / `MMStartTask` | `0x5120fd8` | `0x5570260` | 新旧都引用 `MMStartTask` 与 `mmstn_manager.cc`，新版文件反汇编确认此函数从对象字段读取管理器并下调任务函数。可继续核对调用者/Task 结构；未验证运行时参数及发送。 |
| `buf2RespAddr` 指令点 | `0x3e7e670` | `0x42b7c54` | 旧点周围 10 段相互重叠的 20-byte 模式在新核心唯一命中；函数内相对位置均为 +900。反汇编确认此前把 buffer 指针置入 x20，调用下行写缓冲函数。仍需核查栈中 taskId 所在位置和实际消息类型。 |
| `autoBufferWriteFunc` | `0x3e7fa8c` | `0x42b9070` | 8 段相互重叠的模式唯一命中，且上述接收点之前确实调用此函数；函数体是扩容/复制/增加长度并返回长度。可继续对照 ABI。 |
| `req2bufEnterAddr` | `0x3e58e8c` | 未确认 | 旧点位于函数 `0x3e58e44` 内 +72；有限窗口没有唯一直接模式匹配。需要从旧函数的调用者、虚表和新写缓冲引用继续定位。 |
| `req2bufExitAddr` | `0x3e59de0` | 未确认 | 属于同一旧函数，偏移 +3996；不能把另一个仅带 `Req2Buf` 日志的函数当作等价 Hook 点。 |
| `blrX8Addr` | `0x3e58f0c` | 未确认 | 短窗口命中一个无关函数的局部模式，已拒绝采用。此旧配置位置本身也不是恰好 `BLR X8` 那条指令，因此不能只按名称或单条指令分类判断。 |

模式证据见 [mac-pattern-candidates.json](./mac-pattern-candidates.json)。该文件刻意保留了被拒绝的短模式结果，**不可作为地址配置直接载入**。反汇编证据：[任务入口及日志函数](./mac-current-disassembly.txt)、[旧版有限窗口](./mac-old-pattern-disassembly.txt)、[新版缓冲函数窗口](./mac-new-pattern-disassembly.txt)。本轮反汇编使用 LLDB file target，从未 `run`、`attach` 或发出进程控制命令。

现有 Hook 除函数地址外还依赖寄存器和对象/栈布局。例如发送入口实际 Hook 在 `sendFuncAddr + 0x10`；接收取 `x20`、`x0` 和 `sp + 0x140`。仅定位到同名功能函数还不足以安全替换旧配置。[发送 Hook 代码](https://github.com/yincongcyincong/wechat_chatter/blob/04ae61400b9a5754431c10a1455e94c12c4b79e2/onebot/script.js#L575-L706)、[接收 Hook 代码](https://github.com/yincongcyincong/wechat_chatter/blob/04ae61400b9a5754431c10a1455e94c12c4b79e2/onebot/script.js#L1132-L1187)

当前精确 ASCII 扫描发现 `@openim`，没有发现完整 `@im.chatroom` 或 `newsendmsg` CGI 字符串。这只描述本次字节扫描结果，受字符串编码、拼接或运行时生成影响；不能用于判断官方客户端是否支持外部混合群。公开 Hook 的群分类和外部群发送协议缺口仍保留，详见此前 [Mac 研究](../research/2026-09-18-mac-hook.md)。

## 已交付的只读扫描工具

[scripts/mac_probe.py](../scripts/mac_probe.py) 只读取指定 App 磁盘文件，输出版本、ARM64 SHA256、UUID、段/节信息、函数边界数量、有限字符串命中、可选 ADRP/ADD 交叉引用候选、旧地址处的原始指令以及系统签名检查原始输出。它不会导入目标 dylib、启动微信、附加 PID、打开账号目录或写回 App；唯一主动写入是 `--output` 指定的报告文件，脚本拒绝把报告写进被检查 App。

已实际对本机和旧版各运行一次，旧版 ARM64 摘要与 Classic 独立清单吻合，可作为解析器的实际核查。当前版复现命令：

```sh
python3 scripts/mac_probe.py --app /Applications/WeChat.app --xrefs --output execution/mac-current-probe.json
```

`--xrefs` 是有限静态模式扫描，不做完整寄存器数据流分析，结果全部标为 `unverified_static_candidate`，必须以反汇编复核。`--reference-config` 只读取旧配置，并展示这些旧地址在被检查文件里的字节，不会生成新 Hook 配置。

## 下一步的明确工作单

1. **继续适配本机 4.1.13.10（可立即静态执行）：**用上述精确旧基线对照 `0x3e58e44` 的调用链、虚表与新缓冲函数调用者，收敛 req2buf enter/exit/virtual-call 三个缺失点；核对所有选定点的函数边界、寄存器、对象字段和栈位置。先限定普通文本收发，媒体上传下载地址不在首轮范围。
2. **制作最小文本探针（在地址与布局审核后）：**把“仅接收原始帧”和“主动文本发送”分为可独立启停的模块，保留客户端版本/核心 SHA256 严格门槛；不执行 Classic 的现有安装脚本来覆盖现用应用。此时也不能以加一个群后缀判断就宣称支持混合群。
3. **建立真实隔离运行环境后才验收登录/Hook：**旧版基线最现实的用途是另一 macOS 测试用户/测试系统或独立 Mac 环境中的对照组；如果在当前用户启动同 Bundle ID 副本，存在复用现有应用容器和账号状态的可能，不能直接当独立测试。需要由总任务选择隔离方式并安排测试账号扫码。
4. **外部群验收：**同一个企微创建的混合测试群内，验证普通未 @ 消息、主动文本、真实 @ 微信成员、真实 @ 企微成员、本人被 @，保留原始会话/成员 ID 与提及元数据。只有这些验证通过，才能把研发候选升级为满足需求的方案。

本轮完成状态：官方旧包下载及精确基线校验完成；当前版静态入口定位部分完成；没有启动 Hook、没有宣称当前版收发成功。

后续静态复核见 [req2buf 与缓冲 ABI 报告](./mac-req2buf-abi.md)：发送入口和缓冲数据/长度的局部 ABI 相符，但旧 taskId 栈读取实际依赖调用者保存的 x24；新版消息序列化路径的对象和寄存器布局已变化。三个 req2buf 点不能以地址替换方式宣布完成适配。
