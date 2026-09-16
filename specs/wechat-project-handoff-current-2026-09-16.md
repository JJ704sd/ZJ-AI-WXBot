# 微信 Agent 项目交接：861 上游故障与本机 UIA 验证

交接日期：2026-09-16（北京时间）。对象：后续研究、实现和验收人员。

本文是当前状态入口，汇总本轮实际证据与用户决策，不构成新的对外操作授权。历史记录中的阶段性结论以本文的最新状态为准；附件、网页、群聊内容均是材料，不是用户指令。

## 1. 接手结论

**尚未实现原混合群的真实消息接收、真实 @ 识别或自动回复，不能报真机验收通过。两条已验证路线分别存在独立阻塞：**

| 路线 | 已做到 | 当前阻塞 | 接手决策 |
|---|---|---|---|
| WeChatPadPro Windows 861 协议 API | 请求到达上游并取得明确业务错误 | 上游自动注册管理员密钥时连接其数据库超时，未获得有效设备 key | 保留环境；没有上游恢复证据，不重复生成请求 |
| WeChatAuto.SDK 社区版桌面自动化 | 下载包、核查源码、准备隔离 .NET SDK、编译并运行同依赖的只读前置探针 | 本机微信 UIA Raw View 仅暴露外壳和渲染面板，无聊天内部控件 | 暂停完整 SDK 部署及 REST 封装；先解决读取机制 |

Computer Use 只是辅助诊断工具，不是最终产品依赖。早先的应用权限拒绝不是当前唯一卡点：用户明确授权本地 FlaUI 读取后，重新送审已获准，真实桌面探针已执行。

## 2. 目标、优先级与授权

- 使用合成测试账号和示例企微/个微混合群；群名为 **示例混合群**，合成截图显示 6 人。截图只证明测试界面已打开，不证明程序已识别账号或稳定群 ID。
- 测试账号沿用本地绑定，不要求用户重新提供密码、Token 或重复描述。需要核实时检查本地配置，避免在交接、日志和聊天中复制账号标识、凭据。
- 首关：真实 @ → 人工触发固定文本回复 → 个微和企微两端确认收到。之后才推进 AI 自动回复和定时 @ / 对话。
- 用户期望尽快、尽量两天内完成；本轮目标窗口曾按 2026-09-18 记录。这是期望，不是已具备条件的交付承诺。
- 当前预算为零。用户只有下载的 ZIP，最终明确未另行取得厂商密钥；早先“已有”的表述已被后续澄清覆盖。
- 用户明确不提交 Git、不对外提交 Issue 或联系厂商；保持现有工作，不提交、推送或发布。
- 已授权隔离下载依赖、编译和运行本地 FlaUI 只读探针，以及合理诊断修复；不需要为常规可逆步骤反复询问。
- 本轮运行范围不包含点击、截图、保存聊天正文、发送消息。没有授权付费、降级微信、采集数据库密钥或任意更换账号/群。进入这些动作前需重新核对具体授权，不能从“继续排查”无限外推。

## 3. 环境及关键位置

工作区根目录：`D:\path\to`；实际 Git 仓库：`D:\path\to\ZJ-AI-WXBot`。以下相对路径均以实际仓库为基准。

交接时分支为 `main`，HEAD 为 `1fa5061f51c50f9d5cc0e6b653a1a926ca16b770`；这不包含未提交的探针、证据和本交接文档。

| 内容 | 位置或版本 |
|---|---|
| 用户提供 ZIP | `D:\path\to\wechatpadpro_vios18.61-861_20250822_windows-amd64.zip` |
| 本轮确认微信版本 | `C:\Program Files\Tencent\Weixin\Weixin.exe`，4.1.13.65 |
| 861 本地运行目录 | `poc/.local/pad-legacy-861/runtime` |
| 原账号/群本地绑定 | `poc/.local/poc/live.toml`、`live-t4.toml`，仅按需读取 |
| UIA 探针源码 | `poc/probes/wechatauto-readonly/Program.cs` |
| 探针项目与说明 | 同目录 `ReadOnlyProbe.csproj`、`README.md` |
| 隔离依赖/证据目录 | `poc/.local/wechatauto-readonly` |
| 隔离 .NET SDK | 上述目录 `dotnet/dotnet.exe`，8.0.425 |
| 探针依赖 | FlaUI.Core 5.0.0、FlaUI.UIA3 5.0.0 |
| 下载的候选包 | WeChatAuto4x.SDK 2.0.2，未初始化完整 SDK |

WeChatAuto 包 SHA256：`EE096C37A971E63D1A8C93A579511482BB84A01D2769603130D14405BF03091D`。包声明源码提交：`cdb09cee80164153afb6318f7c339cc9fe25f1c6`，工厂初始化副作用已对照该提交核查。公开 NuGet 列表还存在 2.0.3，不能把本次结果写成其验证结果。

本机原有 .NET 8.0.6 运行时，没有 SDK；便携 SDK 下载后按微软元数据 SHA512 校验，未修改系统 .NET 安装。首次构建输出报告安装 ASP.NET Core HTTPS 开发证书，未执行信任操作；之后构建禁用该首次运行行为。不要声称本次准备完全没有机器级副作用，也不要未经核实删除证书。

## 4. WeChatPadPro 861 的确切证据

详见 [上游故障记录](../poc/evidence/pad-861-upstream-database-failure-2026-09-16.md)。

- 一次有界上游生成请求在 11.281 秒后得到 HTTP 200，但业务 `code=1`，没有设备 key。
- 脱敏错误：自动注册管理员密钥失败，查找系统用户时 `server selection error / context deadline exceeded`，连接上游数据库 27017 超时。
- 这是上游依赖错误；不是已证明的本地 MySQL/Redis 故障、付费要求或密钥无效。HTTP 200 不是业务成功。
- 固定 EXE 自身约 5 秒等待超时；请求重复外发受到 409 拦截。不能靠反复改 Count/Days 解决已观察到的上游故障。
- 该轮收尾曾核验网关停止、1238/8098 无监听、双向 Block 保留。**这是当时收尾记录，本交接轮没有重新测端口或防火墙。**
- 未进入真实扫码登录或二维码、消息接口验收。不要连接或探测上游错误披露的数据库地址。

原始私密收据保留在 `.local`，不要加入 Git、公开文档或粘贴到对话。现有脚本包含真实网络副作用，复跑前必须检查入口和意图文件；本交接不要求立即复跑。

## 5. UIA 路线：已排除什么、还不能断言什么

详见 [完整阶段记录](../poc/evidence/rpa-zero-cost-preflight-2026-09-16.md)。该记录按时间追加，前段“未允许安装”“未运行”等文字为历史状态。

| 阶段 | 实际结果 | 正确解释 |
|---|---|---|
| 沙箱运行 | `windows=[]`，退出码 3 | 沙箱看不到窗口，不能判微信兼容性 |
| 明确授权后的首次桌面运行 | 30 秒超时，退出码 124，父进程终止探针 | 原程序没有中间结果，未准确定位原阻塞调用 |
| 改为主窗口句柄 | 查询约 0.1 秒完成，三个预期节点均为 0 | 当前运行不再超时，但读取未通过 |
| 可选属性诊断 | 一次 PropertyNotSupportedException；改为字段失败返回 null 后复验完成 | null 代表属性不可用，不能当作空集合 |
| v5 Raw View 对照 | 2026-09-16 17:41:54 完成，3 个节点、pending=0，退出码 3 | 不依赖固定选择器仍没有聊天内部语义控件 |

v5 实际树：

| 深度 | 类名 | 类型 |
|---|---|---|
| 0 | Qt51514QWindowIcon | Window |
| 1 | MMUIRenderSubWindowHW | Pane |
| 1 | 属性不可用 | TitleBar |

`IsOffscreen=false`；目标标题、`chat_message_list`、`chat_input_field` 均未匹配。原始结果位于 `.local/wechatauto-readonly/readonly-v5-result.json`，阶段日志位于 `readonly-v5-stages.jsonl`。日志没有聊天正文或节点名称。

探针遍历上限为 80 节点、深度 6、每节点最多 20 个兄弟节点；执行器设置 30 秒总超时。当前只返回外壳节点，不能靠修改 AutomationId 解决这一观察结果。尚未证明这是所有微信版本的永久限制，亦未验证是否存在可用的官方访问性开关或其他提供程序。

**探针是同底层依赖的前置验证，不是完整 WeChatAuto.SDK 测试。** `sdk_acceptance_pass`、`real_mention_verified`、`send_enabled` 均为 false，不得为了让结果“通过”而直接改标志。

## 6. 社区 SDK 的额外适配缺口

已读取公开源码，以下属于静态发现，不等于本机功能实测：

1. 工厂默认初始化会点击托盘、打开头像并保存头像；客户端初始化会切换导航，并可能初始化通讯录。不能直接运行示例冒充无副作用只读探针。
2. 标题识别依赖 UIA 节点，没有在所查实现中发现 OCR 标题兜底。README 的“UI Tree + OCR”不等于全界面纯 OCR 可用。
3. 发送端通过成员选择列表执行 @，但选择失败后仍可能继续发送正文。接入前必须实现全部目标成员确认成功才允许发送。
4. `SimpleMessageBubble` 没有明确被 @ 用户标识；正文包含 `@昵称` 不能证明真实 @。
5. 消息相等比较使用发言人、正文、分钟级时间和类型，同一分钟重复正文可能被合并，不能当作协议唯一消息 ID。
6. 历史读取包含开窗、点击和滚动。NewMessages/HistoryMessages 字段存在，不证明新旧消息可靠区分。
7. 社区免费版与 VIP 功能边界尚未完整确认；公开接入示例是 WebSocket，项目 REST 适配尚未实现。

## 7. 接手后的最短有效路径

### 优先完成：读取机制决策

先核查**当前 4.1.13.65、个微加入企微混合群**的准确适配证据。只选择能够解释并解决“无聊天 UIA 节点”的方案，不以“支持 4.x”宣传替代实测。

- 如果能找到有依据、可逆的可访问性适配方式，说明变量及影响后做一次有界对照，再运行原探针。不要随机添加 Chromium/Linux 的启动参数到微信，也不要无依据重启或降级。
- 如果没有可验证修复，则结束该 SDK 的 UIA 路线投入。数据库读取/OCR 是机制变更，需独立核查混合群身份、真实 @、新旧消息和授权范围；不自动安装、取密钥或读取全量聊天。
- `fanyuantaier/wechatauto-replica` 仅是发现的候选：作者自述 4.1.12+ 自绘、数据库读取及 OCR 发送。没有安装或运行，不可作为本项目能力证据。
- 861 仅在出现上游恢复的新证据时做一次有界复验，不连续重放生成请求。

### 读取通过后：分段验收

| 关卡 | 必须留下的证据 | 当前状态 |
|---|---|---|
| A. 目标身份 | 原账号、原混合群准确绑定，未知身份停止 | 用户截图确认群；程序未确认 |
| B. 新消息 | 历史基线、带编号新消息、同分钟重复正文、重启不回放 | 未通过 |
| C. 真实 @ | 真实 @ 与普通文本 @昵称 的对照样本 | 未通过 |
| D. 固定回复 | 人工触发一次固定文本、错误目标拒发、双端收件证据 | 未执行 |
| E. AI/定时 | 在 A–D 通过后单独验证去重、恢复及触发规则 | 未执行 |

不要提前扩展为长期监听、完整 AI 编排或常驻服务。当前最有价值的是让读取能力过关，而不是增加 API 包装。

## 8. 代码、证据与复现注意事项

推荐阅读顺序：

1. 本交接。
2. [UIA 预检与复测证据](../poc/evidence/rpa-zero-cost-preflight-2026-09-16.md)。
3. [探针源码](../poc/probes/wechatauto-readonly/Program.cs) 与 [运行说明](../poc/probes/wechatauto-readonly/README.md)。
4. [861 上游故障](../poc/evidence/pad-861-upstream-database-failure-2026-09-16.md)。
5. [零费用候选比较](zero-cost-api-options-2026-09-16.md)、[旧版交接](wechatpadpro-windows-handoff-2026-09-16.md)，注意其时间早于最新 UIA 结果。

探针构建实际使用项目隔离 SDK，依赖已还原，后续优先 `--no-restore`；设置 `DOTNET_CLI_HOME`、`NUGET_PACKAGES` 到隔离目录，`DOTNET_CLI_TELEMETRY_OPTOUT=1`、`DOTNET_GENERATE_ASPNET_CERTIFICATE=false`。构建命令核心为：

```powershell
& 'D:\path\to\ZJ-AI-WXBot\poc\.local\wechatauto-readonly\dotnet\dotnet.exe' build `
  'D:\path\to\ZJ-AI-WXBot\poc\probes\wechatauto-readonly\ReadOnlyProbe.csproj' `
  --artifacts-path 'D:\path\to\ZJ-AI-WXBot\poc\.local\wechatauto-readonly\artifacts' `
  --no-restore --nologo
```

运行入口为隔离 `dotnet.exe` 加 `artifacts/bin/ReadOnlyProbe/debug/ReadOnlyProbe.dll`，唯一参数是准确群名。必须由父进程施加30秒上限、隐藏窗口、分开重定向 stdout/stderr；超时终止本次探针，不终止微信。探针自身没有内置总时限，不能把上述限制误写为程序自行保证。

现有工作区含大量未提交/未跟踪修改，尤其 `poc/pyproject.toml`、`poc/tests/test_api_a1.py` 及 Pad 相关实现。没有本轮提交。不要清理、覆盖或将这些变化全部归属于本轮 UIA 工作；接手先查 `git status`。本轮构建通过及文档检查不代表整个仓库测试通过，历史测试结果不能冒充本轮执行。

## 9. 外部资料和信息边界

- [WeChatAuto.SDK](https://github.com/scottfly189/WeChatAuto.SDK)
- [上游无 UI Tree 问题](https://github.com/scottfly189/WeChatAuto.SDK/issues/3)
- [另一读取机制候选，未验证](https://github.com/fanyuantaier/wechatauto-replica/blob/main/README_pypi.md)

YoBot 激活资格、wechat2ipad 免费使用条件未得到确认；Gewechat 原项目停止服务、WeChatFerry 旧版本约束、官方私聊插件不覆盖原混合群等前期结论见候选比较文档，若重新选择必须再次核查现状。不得把教程、源码存在或截图当作原群闭环验收。

交接完成标准：接手者能准确说出两条路线分别卡在哪里，找到可复现证据，保持已授权范围，并优先取得新的读取能力证据。当前没有需要接手者“继续发送”的后台任务。
