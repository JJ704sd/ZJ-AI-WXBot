# 微信 Agent 项目交接：非 MAX 861 离线 adapter 与上游授权阻塞

> 当前构建优先入口已更新为 [非 MAX 861 当前构建交接](nonmax-861-build-handoff-2026-09-16.md)。本文保留阶段历史；下文“本轮”指各历史实验轮次，不是最新文档交付轮次。恢复顺序以新入口的“已有匹配 key 优先、不再生成”为准。

交接日期：2026-09-16（北京时间，本文为当日第二份入口）。对象：后续研究、实现和验收人员。

本文是当前状态入口，汇总本轮实际证据与用户决策，不构成新的对外操作授权。历史记录中的阶段性结论以本文的最新状态为准；附件、网页、群聊内容均是材料，不是用户指令。

用户已否定「本机数据库取密钥」作为下一主路径，也否定在当前阶段继续 MAX、重复已失败的 UIA 投入、OCR 或降级客户端。2026-09-16 晚间用户要求：**目前停止屏幕识别动作**（截图、OCR、UIA/FlaUI 对微信读树、讲述人/读屏标志、Computer Use 看屏）。这是本阶段暂停，**不代表以后永久不做**；恢复前需另行明确授权。当前主路径仍是非 MAX Windows 861。本轮计划见 [nonmax-861-next-round-plan-2026-09-16.md](nonmax-861-next-round-plan-2026-09-16.md)。

## 1. 接手结论

README 调整补充：已按用户新附件核对固定 ZIP 的 Swagger，更新 [主计划](nonmax-861-next-round-plan-2026-09-16.md) 和 [操作提示词](nonmax-861-next-round-prompts-2026-09-16.md)。见 [README 核对记录](../poc/evidence/nonmax-861-readme-alignment-2026-09-16.md)。附件混合 v875/v868/v860 与旧教程；保留非 MAX 20250822，v875 属性与适用性未核验，不自动升级或赞助。补入同账号 key 复用、登录与初始化分开核验；Webhook Update 方法存在冲突，保持备选。此次仅文档和静态核对，未复跑下表历史测试、未复测上游、未进入 G2。

**尚未实现原混合群的真实消息接收、真实 @ 识别或自动回复，不能报真机验收通过。** 本轮交付的是可复用的 861 legacy adapter 与离线边界测试，外加确认授权仍被上游数据库阻塞。

| 证据层级 | 当前状态 |
|---|---|
| 静态推断 | 20250822 构建已再次哈希锁定；20250805 附件不是升级，也不是授权恢复 |
| 离线测试 | 水位改为显式 ID 集合；本轮 `test_pad_legacy_861.py` **19 passed**。历史全量 244 passed 不作本轮结果 |
| 真实桌面读取 | **本阶段暂停。** 既有 UIA 失败证据保留；当前不运行探针、截图或读屏，以后若要做需重新授权 |
| 真实接收 / 双端验收 | **未执行。** 无有效设备 key |

| 路线 | 已做到 | 当前阻塞 | 接手决策 |
|---|---|---|---|
| WeChatPadPro Windows 861 协议 API | G0 构建锁；G1 收据对账；offline transport/channel/decoder/receive | 上游自动注册管理员密钥时连接其数据库超时，未获得有效设备 key | **唯一推进路线。** 无新恢复证据不重放生成；G2–G4 等有效 key |
| WeChatAuto.SDK 社区版桌面自动化 | 下载包、核查源码、隔离编译，可逆无障碍对照失败 | 4.1.13.65 只暴露 Qt 外壳 | **当前不继续。** 不部署完整 SDK；屏幕识别本阶段暂停，不是永久关闭 |
| 本地数据库读取（Chat-Lab / wechatauto-replica） | 仅公开源码与目录存在性核查 | 读取依赖进程内存取密钥 | **不是下一主路径。** 未安装、未取密钥。用户已否定该建议 |

屏幕识别**目前停止**，不是以后永不执行。本阶段不要用 Computer Use 看微信窗口。仓库内没有 `AGENTS.md`。

## 2. 目标、优先级与授权

- 目标仍为原测试账号、原企微/个微混合群（本地绑定见 `poc/.local/poc/live.toml`；公开文档继续用示例名，不复制账号标识）。
- 首关：真实 @ → 人工触发固定文本回复 → 个微和企微两端确认收到。之后才推进 AI 自动回复和定时 @ / 对话。
- 用户期望尽快、尽量两天内完成；本轮目标窗口曾按 2026-09-18 记录。这是期望，不是已具备条件的交付承诺。
- 当前预算为零。用户只有下载的 ZIP，最终明确未另行取得厂商密钥。
- 用户明确不提交 Git、不对外提交 Issue 或联系厂商；保持现有工作，不提交、推送或发布。
- 已授权隔离下载依赖和常规可逆本地实现。对微信的 FlaUI/UIA、讲述人、读屏标志、截图或 OCR：**当前阶段不要做**；以后若恢复，需单独明确授权，不能从「继续排查」自行恢复。
- 当前运行范围不包含点击、截图、保存聊天正文、发送消息、屏幕识别。没有授权付费、降级微信、采集数据库密钥、写入微信进程内存或任意更换账号/群。进入这些动作前需重新核对具体授权。

## 3. 环境及关键位置

工作区根目录：`D:\path\to`；实际 Git 仓库：`D:\path\to\ZJ-AI-WXBot`。

接手时分支 `main`，HEAD 为 `523a1b7d583f4dc2940d29990553f788c55d46b3`（`feat: add WeChatPadPro P0/P1 offline foundation`）。工作区现有未提交改动：UIA 探针 v6、本交接、nonmax 计划与 legacy 861 adapter。**不要提交或推送**。

| 内容 | 位置或版本 |
|---|---|
| 本轮重测微信版本 | 安装路径已脱敏，**4.1.13.65**（FileVersion=ProductVersion） |
| 微信进程 | 6 个 `Weixin` 进程；仅 1 个可见主窗口，类名 `Qt51514QWindowIcon` |
| 861 本地运行目录 | `poc/.local/pad-legacy-861/runtime` |
| 原账号/群本地绑定 | `poc/.local/poc/live.toml`、`live-t4.toml`，仅按需读取 |
| UIA 探针源码 | `poc/probes/wechatauto-readonly/Program.cs` |
| 探针项目与说明 | 同目录 `ReadOnlyProbe.csproj`、`README.md` |
| 隔离依赖/证据目录 | `poc/.local/wechatauto-readonly` |
| 隔离 .NET SDK | 上述目录 `dotnet/dotnet.exe`，8.0.425 |
| 探针依赖 | FlaUI.Core 5.0.0、FlaUI.UIA3 5.0.0 |
| v6 对照结果 | `readonly-v6-result.json`、`readonly-v6-narrator-result.json`（gitignored `.local`） |
| 下载的候选包 | WeChatAuto4x.SDK 2.0.2，未初始化完整 SDK |

WeChatAuto 包 SHA256：`EE096C37A971E63D1A8C93A579511482BB84A01D2769603130D14405BF03091D`。包声明源码提交：`cdb09cee80164153afb6318f7c339cc9fe25f1c6`。公开 NuGet 列表还存在 2.0.3，不能把本次结果写成其验证结果。

## 4. WeChatPadPro 861 的确切证据

详见 [上游故障](../poc/evidence/pad-861-upstream-database-failure-2026-09-16.md)、[授权入口核实](../poc/evidence/nonmax-861-authorization-entry-audit-2026-09-16.md) 与 [G1 待确认清单](../poc/evidence/nonmax-861-g1-maintainer-checklist-2026-09-16.md)。本轮没有新的恢复依据或设备 key，**没有**复跑生成，G1 仍阻塞。



## 5. UIA 路线：本轮可证伪实验

详见 [完整阶段记录](../poc/evidence/rpa-zero-cost-preflight-2026-09-16.md)。

### 5.1 假设与结果

| 假设 | 操作 | 结果 | 判定 |
|---|---|---|---|
| H1 其它顶层窗口藏有聊天树 | 枚举可见/`MainWindowHandle` 的 Weixin HWND；工具窗口不做 `FindAllDescendants` | 可见主窗口 1 个，Raw View 3 节点，0 个 `mmui::` | 证伪。另：对 `Qt51514QWindowToolSaveBits` 跑选择器查询会挂起，已避免 |
| H2 MSAA 比 UIA3 暴露更多聊天控件 | `AccessibleObjectFromWindow` 只计 `accChildCount`，不读名称/正文 | client=1，window=7；UIA 仍 3 外壳节点 | 未物化聊天树。7 更像窗口铬元素，不是消息列表 |
| H3 运行时 `SPI_SETSCREENREADER` 可逆打开 Qt 树 | 标志 0→1，等待 2s，复测，恢复 0 | `screen_reader_during=1` 已确认；树仍 3 节点、0 `mmui::` | **证伪** |
| H4 启动讲述人可逆打开 Qt 树 | 启动 `Narrator.exe` 3s 后复测并结束进程、恢复标志 | 讲述人可运行，但本机 **不设置** `SPI_GETSCREENREADER`；树仍 3 节点 | **证伪**（作为可逆 OS 无障碍适配） |

v6 主窗口树（pulse 前后相同）：

| 深度 | 类名 | 类型 |
|---|---|---|
| 0 | Qt51514QWindowIcon | Window |
| 1 | MMUIRenderSubWindowHW | Pane |
| 1 | 属性不可用 | TitleBar |

收尾核验：`SPI_GETSCREENREADER=0`，无 `Narrator` 进程，微信仍为 6 个进程。未点击、截图、保存正文或发送消息。

### 5.2 明确结束的投入

**停止**为 WeChatAuto.SDK 继续：改 AutomationId、换 UIA 选择器、重复同一 Raw View、随机加 Chromium/Linux 启动参数。

公开资料中其余“打开 UI Tree”办法均超出当前授权，且本轮没有采用：

| 候选 | 依据 | 为何不做 |
|---|---|---|
| 降级到 4.1.9.30 再养号升级 | [WeChatAuto.SDK#3](https://github.com/scottfly189/WeChatAuto.SDK/issues/3) | 禁止降级 |
| 第三方 `OpenUIA.zip` | 同一 Issue，作者声明未审计 | 不可信二进制 |
| 热写 `Weixin.dll` accessibility gate | wechatauto-replica `uia_driver.py`：固定版本候选地址已脱敏，`WriteProcessMemory` | 写入微信进程内存，属范围扩大 |
| `QT_USE_NATIVE_WINDOWS` 并重启微信 | easyChat#129 有人试过，后称控件无效，最终改讲讲述人 | 要重启客户端；讲述人路径已在本机失败 |

剩余不确定性：未做“先置 SPI 再冷启动微信”。replica 源码把 4.1.13.65 的物化写成内部门闩热写，并在重启后字节归零时自愈；因此重启试验仍需要内存写入或中断当前会话，本轮不做。

**探针不是完整 SDK 验收。** `sdk_acceptance_pass`、`real_mention_verified`、`send_enabled` 均为 false。

## 6. 其它读取机制：源码核查，不是本机能力

未安装、未运行这些项目；下表不能写成“已可用”。

| 候选 | 版本声称 | 混合群 | 真实 @ | 新旧消息 | 免费边界 | 所需权限 | 本机 |
|---|---|---|---|---|---|---|---|
| wechatauto-replica 1.2.2.2 | 作者写明 4.1.13.65 实测；读库走 SQLCipher 4 | `get_groups()` 读 `contact.db` 的 `chat_room`；**未证明**企微成员 `@openim` 外部混合群 | 发送 `at_member` 走 OCR 选人；`get_new_messages` 字典无独立被 @ 字段，监听路径不返回 `packed_info` | `sort_seq` 水位，比分钟级文本相等更接近增量；**未在原群验证** | PyPI 公开包，未见 VIP 墙 | **ReadProcessMemory 取库密钥**；发送还要截图/OCR，UIA 发送还要 **WriteProcessMemory** | 未安装。本机 `xwechat_files` 存在；poc venv 无 `sqlcipher3`，有 `zstandard` |
| Chat-Lab（仓库第二轮基线） | 针对 Weixin 进程内存/SQLCipher | 合成 `@openim` 只能证明字符串反查，不证明真实混合群 schema | 无专门真实 @ 字段 | 合成实验已复现同秒漏读、分库漏发现 | 参考源码 | 同样要取密钥；硬件断点路径更侵入 | 未对本机库做读取 |
| Tencent/openclaw-weixin | 当前 `channel.ts` `chatTypes: ["direct"]` | 文档不覆盖原混合群 | 不适用 | 不适用 | 官方插件 | 官方账号体系 | 未安装 |
| WeChatFerry | 历史记录适配 3.9.x 并归档 | 不直接适配 4.1.13.65 | 注入/hook | 旧客户端 | 开源但要降级+注入 | 注入 | 排除 |
| Gewechat / wechat2ipad / YoBot | 见 [零费用比较](zero-cost-api-options-2026-09-16.md) | 停服或免费资格未确认 | — | — | 未确认零费用 | — | 不部署 |
| 纯 OCR 读屏 | 4.x 自绘 | 不能替代群 ID / 真实 @ | 不可靠 | 不可靠 | 免费软件可做 | **截图**，当前禁止 | 未做 |

独立已完成的准备（无密钥、无正文）：确认微信版本、数据根目录存在、poc venv 缺 SQLCipher、replica/Chat-Lab 权限与 @ 缺口已对照源码。

## 7. 最短有效路径

UIA 可逆适配已关闭。旧交接曾把「有界进程内存取 SQLCipher 密钥」写成推荐下一步；**该建议作废**，不能从本文或「继续排查」推出取密钥、热写 DLL、OCR 或降级。

当前唯一主路径：非 MAX 20250822 861。

1. **外部：有效设备 key**（G1 仍阻塞）
   仅当出现与 2026-09-16 上游库 27017 超时不同的恢复依据时，按已有意图控制 Count=1/Days=1 做一次生成。HTTP200 不是成功。没有新依据则停止外发。
2. **G2 登录与原群绑定**
   读本地 `poc/.local/poc/live.toml`，不让用户重复提供已有信息，不输出凭据。登录/扫码需核对既有明确授权。
3. **G3 单路 HttpSync**
   显式正数 Count，不与 WS/Webhook 并行。20 条标注样本覆盖真实 @ / 伪 @ / 历史 / 重复 / 企微成员后，才允许自动触发。
4. **G4 人工固定 ACK**
   复用 outbox/锁/额度/在线检查；超时 unknown 不重发；必须双端确认。accepted ≠ 送达。
5. **当前不要做的**
   本阶段的屏幕识别（截图、OCR、UIA/FlaUI 读微信、讲述人、读屏标志、Computer Use 看屏；以后需另授才恢复）、热写 `Weixin.dll`、OpenUIA、降级、完整 replica 安装冒充只读、无新证据重放 861 生成、切换 MAX、启动附件 `webhook-client.py`。

### 分段验收

| 关卡 | 必须留下的证据 | 当前状态 |
|---|---|---|
| G0 构建锁 | ZIP/EXE/Swagger 哈希 | **通过** |
| G1 设备 key | 非空有效 key + 无副作用核验 | **外部阻塞** |
| A. 目标身份 | 原账号、原混合群准确绑定 | 本地绑定文件存在；程序未确认 |
| B. 新消息 | 历史基线、带编号新消息、同分钟重复正文、乱序/迟到小 ID、重启不回放 | 离线 ID 集合水位已测；真机排序/分页 **unknown** |
| C. 真实 @ | 真实 @ 与普通文本 @昵称 的对照样本 | 仅合成样本；真机未通过 |
| D. 固定回复 | 人工触发一次固定文本、错误目标拒发、双端收件证据 | 未执行 |
| E. AI/定时 | 在 A–D 通过后单独验证 | 未执行 |

不要提前扩展为长期监听、完整 AI 编排或常驻服务。离线代码不能替代真机交付。

## 8. 代码、证据与复现注意事项

推荐阅读顺序：

1. 本交接。
2. [非 MAX 计划](nonmax-861-next-round-plan-2026-09-16.md)、[授权入口核实](../poc/evidence/nonmax-861-authorization-entry-audit-2026-09-16.md)、[G1 待确认清单](../poc/evidence/nonmax-861-g1-maintainer-checklist-2026-09-16.md)。
3. [861 上游故障](../poc/evidence/pad-861-upstream-database-failure-2026-09-16.md)。
4. [UIA 预检与复测证据](../poc/evidence/rpa-zero-cost-preflight-2026-09-16.md)（已关闭路线的依据，不要删；**当前不要重跑探针**，不排除以后另授后再用）。
5. [零费用候选比较](zero-cost-api-options-2026-09-16.md)、[旧版交接](wechatpadpro-windows-handoff-2026-09-16.md)，其中 MAX 推荐与数据库路线均已被否定。

Adapter 测试（引用时核对本轮命令，不把历史全量数字冒充新结果）：

```powershell
cd D:\path\to\ZJ-AI-WXBot\poc
.\.venv\Scripts\python.exe -m pytest tests\test_pad_legacy_861.py -o addopts= -q -p no:cacheprovider
# 本轮实跑：19 passed in 0.24s
```

此前一轮全量 poc 回归曾为 244 passed / 68.23s，那是历史执行证据，不是本轮复跑结果。

历史探针构建（**当前不要运行**；仅说明当时如何得到失败证据；以后另授后再说）：

```powershell
$env:DOTNET_CLI_HOME = 'D:\path\to\ZJ-AI-WXBot\poc\.local\wechatauto-readonly'
$env:NUGET_PACKAGES = 'D:\path\to\ZJ-AI-WXBot\poc\.local\wechatauto-readonly\packages'
$env:DOTNET_CLI_TELEMETRY_OPTOUT = '1'
$env:DOTNET_GENERATE_ASPNET_CERTIFICATE = 'false'
& 'D:\path\to\ZJ-AI-WXBot\poc\.local\wechatauto-readonly\dotnet\dotnet.exe' build `
  'D:\path\to\ZJ-AI-WXBot\poc\probes\wechatauto-readonly\ReadOnlyProbe.csproj' `
  --artifacts-path 'D:\path\to\ZJ-AI-WXBot\poc\.local\wechatauto-readonly\artifacts' `
  --no-restore --nologo
```

运行：隔离 `dotnet.exe` + `artifacts/bin/ReadOnlyProbe/debug/ReadOnlyProbe.dll`，参数为准确群名和模式 `baseline|pulse-screen-reader|pulse-narrator`。群名含空格时必须用 `ProcessStartInfo.Arguments` 整段加引号；Windows PowerShell 5.1 没有 `ArgumentList`。父进程施加超时、隐藏窗口、分开重定向；超时只杀探针。`pulse-*` 必须在 `finally` 恢复 `SPI_SETSCREENREADER` 并结束讲述人。

本轮构建通过及文档检查不代表整个仓库测试通过。

## 9. 外部资料和信息边界

- [WeChatAuto.SDK](https://github.com/scottfly189/WeChatAuto.SDK)
- [上游无 UI Tree 问题](https://github.com/scottfly189/WeChatAuto.SDK/issues/3)
- [easyChat 4.x 控件讨论（讲述人/原生窗口）](https://github.com/LTEnjoy/easyChat/issues/129)
- [wechatauto-replica README_pypi（候选声明）](https://github.com/fanyuantaier/wechatauto-replica/blob/main/README_pypi.md)
- replica `uia_driver.py`：`SPI_SETSCREENREADER` + `WriteProcessMemory` 热写 gate
- [Tencent/openclaw-weixin `channel.ts`](https://github.com/Tencent/openclaw-weixin/blob/main/src/channel.ts) `chatTypes: ["direct"]`

不得把教程、源码存在或截图当作原群闭环验收。当前没有需要接手者“继续发送”的后台任务。
