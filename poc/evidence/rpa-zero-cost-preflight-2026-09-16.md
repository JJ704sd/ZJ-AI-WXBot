# 零费用 RPA API 路线只读预检

日期：2026-09-16。用户已允许本轮只读可行性预检；不包含安装、降级、部署或发消息。目标仍为原账号、原混合群，先真实 @、人工触发固定回复及双端送达，预算为零。

## 结论

WeChatAuto.SDK 社区版保留为优先候选，但尚未通过本机可用性门槛。不能将它写成已可替换 WeChatPadPro 的免费协议 API；它依赖桌面自动化，公开 Python 接入示例使用 WebSocket，REST 适配尚需实现。YoBot 需要激活码，当前没有可免费使用的资格证据，不进入部署阶段。

## 本机证据与缺口

- 本轮读取 Weixin.exe 文件版本：4.1.13.65。
- Computer Use 应用枚举确认微信正在运行且存在标题为“微信”的窗口。
- 随后获取该窗口及其文本状态的调用返回：`Computer Use was not approved to use 微信`。本轮没有取得 UI Tree，也未截图、点击、输入或发送消息。
- 该结果是工具应用访问权限阻断，不是 UIA 兼容性失败。2026-09-15 的单一渲染子窗口、读不到群名记录仅是历史证据，不能替代当前复测。
- 未通过其他控制方式绕过权限拒绝。用户的业务预检授权已具备，剩余需要工具允许访问微信窗口。

## 源码核查

1. 上游 README 声明 4.1.xx 使用 UI Tree + OCR，部分业务 API 为 VIP 专有；没有证明本机 4.1.13.65 及原混合群的完整免费能力。
2. `ChatHeader.HeaderRoot` 按 AutomationId、控件类型和类名查找 UIA 节点；`GetTitleCore` 在根节点缺失时直接返回空标题对象。所查标题实现没有 OCR 兜底，因此不能靠“启用 OCR”推定解决群身份识别。
3. `WeChatClient` 公开 `SendMessage(..., atUser, ...)` 接口，但接口存在不是混合群真实 @ 或双端送达的实测证据。
4. 客户端初始化包含导航切换和按配置初始化通讯录；不能直接把运行上游示例当成纯只读预检。
5. `MessageMonitor.cs` 是 partial 类的构造/释放部分，单独这个文件不足以证明社区版完整监听及新旧消息区分能力。

## 下一轮通过条件

先在工具访问恢复后只读复测：是否能取得当前会话标题、消息区域及发言人等必要信息。不得用空标题或模糊 OCR 匹配认定原群。如果仍只有渲染节点，则这条候选未通过门槛，停止部署投入。

界面门槛通过后，再核对社区版的接收、真实 @ 识别与发送实现及免费边界，形成最小本地接入方案；实际部署与发送不属于本次预检完成项。两天目标仍有现场证据依赖，当前不能承诺达成。

## 一手来源

- https://github.com/scottfly189/WeChatAuto.SDK
- https://raw.githubusercontent.com/scottfly189/WeChatAuto.SDK/master/MD/faq.md
- https://github.com/scottfly189/WeChatAuto.SDK/issues/3
- https://raw.githubusercontent.com/scottfly189/WeChatAuto.SDK/master/WeChatAuto4_X/WeChatAuto/Components/ChatHeader.cs
- https://raw.githubusercontent.com/scottfly189/WeChatAuto.SDK/master/WeChatAuto4_X/WeChatAuto/Components/WeChatClient.cs
- https://raw.githubusercontent.com/scottfly189/WeChatAuto.SDK/master/WeChatAuto4_X/WeChatAuto/Components/MessageMonitor.cs
- https://raw.githubusercontent.com/LeoMusk/wechat-rpa-bot-skill/main/README.md

本轮交付为预检记录；没有新增运行时、没有执行功能测试、没有提交 Git 或对外联系。

## 后续源码复核与决策

用户补充截图可确认目标群已打开；后续 Computer Use 重试返回窗口最小化，没有再次返回权限拒绝，也没有取得 UI Tree。不能继续把早先的权限错误当作已确认的当前唯一阻塞。Computer Use 是辅助工具，不是最终接入方案或验收的必备依赖。

源码复核结论：保留候选，但不直接运行上游示例或接通自动回复。

- 发送端：`Sender.cs` 的 `__AtUserList` 从 `chat_mention_list` 按名称选人，是实际成员选择机制；但未找到成员或弹窗失败时没有向调用方返回失败，外层仍粘贴正文并按 Enter。因此需要增加“全部目标成员确认成功才允许发送”的检查，不能将调用正常返回当成真实 @ 成功。
- 接收端：`MessageContext` 有 NewMessages / HistoryMessages，但字段存在不能证明实际分类可靠。`SimpleMessageBubble` 没有显式的被 @ 用户标识字段；不能用正文包含 @昵称 代替真实 @ 证据。
- 消息身份：`SimpleMessageBubble.GetFeature` 使用发言人、正文、分钟级时间和类型做相等比较。同一人同一分钟发送相同内容可能被判为相等；不是协议级唯一消息 ID。重复消息、重启回放必须单独验证。
- 历史读取：`MessageBubbleList.GetChatHistory` 会搜索会话、打开历史窗口并进行点击/滚动，不是无界面动作的读取探针。
- 免费边界：已看到相关源码，但尚无完整证据表明社区发布包包含原混合群所需的实时监听和真实 @ 识别。项目文件标识包版本为 2.0.2；尚未下载、构建或运行该包，不把源码版本当成已验证运行版本。

### 最小运行验证的具体判据（尚未执行）

1. 仅本机、仅目标群，只观察，不接发送器；禁用通讯录初始化及图片采集，避免直接运行会自动切换导航的示例。
2. 首次读取作为历史基线；由人工产生带不同编号的新文本、真实 @、普通文本 @昵称 三类样本，验证后两者能否区分。
3. 同一分钟重复正文、切换会话后返回、程序重启，核验漏报与回放；没有稳定证据时保持自动回复关闭。
4. 读取与身份判据通过后，才准备人工触发固定回复；发送端必须在选人失败时停止，并以双端收件证明送达。

当前授权仍为不安装、不部署、不发消息的预检，本轮已经完成可独立推进的源码核查。运行验证需要进入下一阶段，不能把上述未执行步骤报成验收通过。

补充来源：

- https://raw.githubusercontent.com/scottfly189/WeChatAuto.SDK/master/WeChatAuto4_X/WeChatAuto/Components/Sender.cs
- https://raw.githubusercontent.com/scottfly189/WeChatAuto.SDK/master/WeChatAuto4_X/WeChatAuto/Components/MessageBubbleList.cs
- https://raw.githubusercontent.com/scottfly189/WeChatAuto.SDK/master/WeChatAuto4_X/WeChatAuto/Models/MessageContext.cs
- https://raw.githubusercontent.com/scottfly189/WeChatAuto.SDK/master/WeChatAuto4_X/WeChatAuto/Models/SimpleMessageBubble.cs
- https://raw.githubusercontent.com/scottfly189/WeChatAuto.SDK/master/WeChatAuto4_X/WeChatAuto/WeChatAuto.csproj
- https://raw.githubusercontent.com/scottfly189/WeChatAuto.SDK/master/WeChatAuto4_X/WebSocketServer/Server/Program.cs

## 隔离准备与受阻运行

用户确认进入下载依赖和不发送消息的运行验证阶段。已下载 WeChatAuto4x.SDK 2.0.2，SHA256 为 EE096C37A971E63D1A8C93A579511482BB84A01D2769603130D14405BF03091D；包声明源码提交 cdb09cee80164153afb6318f7c339cc9fe25f1c6。已按该提交复核工厂源码，确认点击和头像保存副作用。

本机只有 .NET 8.0.6 运行时、无 SDK；微软便携 SDK 8.0.425 已下载并按官方元数据 SHA512 校验，解压于 .local 隔离目录。首次 dotnet 构建输出报告安装 ASP.NET Core HTTPS 开发证书，这是 CLI 首次运行副作用，未执行信任操作；未修改系统 .NET 安装。

新增 `poc/probes/wechatauto-readonly` 前置探针，使用 SDK 相同版本 FlaUI.Core/UIA3 5.0.0，避免初始化完整 SDK；不点击、聚焦、截图或输出消息正文，仅输出节点数量和目标标题匹配结果。构建 0 警告、0 错误。

沙箱内实际运行返回 windows=[]、退出码3，不能据此判定微信 UIA 不兼容。请求真实桌面执行时，自动审批拒绝，理由为：此前 Computer Use 访问受阻后使用 PowerShell/FlaUI 属于替代路径，当前用户未明确授权该方式。已停止，没有换入口重试。

当前结果：下载和构建完成；真实桌面读取未执行，SDK、真实 @、消息接收及发送均未验收。需要明确处理这个访问方式的授权后，才能重新送审；普通“继续”不应被误解为已消除审批约束。

## 明确授权后的首次桌面运行

用户在获知本地 FlaUI 直接读取微信的具体范围后明确回复“运行”。本次重新送审获准执行同一已编译探针，使用隐藏子进程并设置30秒上限。

结果：30秒内没有返回最终JSON，父进程终止探针，退出码124，输出 `PROBE_TIMEOUT`。这不是权限拒绝，也不能证明目标群结构不兼容。当前探针仅在完成全部遍历后输出结果，因此此次无法定位是桌面枚举还是后代节点查询阻塞。

未点击、截图、保存正文或发送消息。没有重试同一遍历。下一步应增加不含聊天内容的阶段诊断并收窄查询范围，再做一次有界读取；真实 @、消息读取和完整 SDK 验收仍未完成。

## 主窗口范围复验

2026-09-16 17:37–17:38（北京时间）：改为从 Weixin 进程的 MainWindowHandle 绑定窗口，不再对每个进程遍历桌面；增加即时刷新到标准错误的阶段JSON日志。构建通过，0警告、0错误。

v2实际桌面运行约0.1秒完成查询，退出码3：窗口类 Qt51514QWindowIcon，标题、消息列表、输入框节点均为0。改动消除了此次运行的超时，但未准确定位原版本具体阻塞调用。

补充元数据时发生 PropertyNotSupportedException；修复为可选字段失败返回null、不覆盖主查询结果。v4复验退出码3：IsOffscreen=false，三个节点仍为0，直接子控件类名读取不可用（null，不能解释为无子控件）。证据在 .local/wechatauto-readonly/readonly-v4-result.json 和 readonly-v4-stages.jsonl。

结论：当前UIA窗口可绑定且查询能完成，但社区SDK预期的三个节点未找到，前置门槛未通过。尚不能区分访问性树不可用和选择器不匹配，不直接宣称全部RPA不兼容。停止重复相同探测，不启动完整SDK、REST封装或发送功能；后续需要当前客户端可访问性/选择器的确切适配证据。

## Raw View 对照诊断

2026-09-16 17:41:54（北京时间）运行 v5：在同一真实微信主窗口上增加不依赖 AutomationId 的 Raw View 遍历，最多80个节点、深度6、每层最多20个兄弟节点，父进程30秒超时。只记录类名、控件类型、框架和目标名称相等布尔值，不记录节点名称、正文或截图。构建0警告0错误，实际运行退出码3。

返回3个节点且 pending=0：

| 深度 | 类名 | 类型 | 框架 |
|---|---|---|---|
| 0 | Qt51514QWindowIcon | Window | Win32 |
| 1 | MMUIRenderSubWindowHW | Pane | Win32 |
| 1 | 属性不可用 | TitleBar | 属性不可用 |

精确标题、消息列表和输入框仍为0，IsOffscreen=false。完整阶段记录位于 .local/wechatauto-readonly/readonly-v5-stages.jsonl，摘要位于 readonly-v5-result.json。

对照支持：当前主窗口没有向本次UIA Raw View查询暴露聊天内部语义控件；仅替换SDK的AutomationId不能解释或修复这一结果。尚未证明这是版本永久限制、可切换渲染模式，或其他访问性提供程序状态。未擅自重启、降级客户端或设置无依据的启动参数。

当前决策：WeChatAuto.SDK 的UIA前置门槛不通过，暂停其完整部署及REST适配。公开检索发现另一个项目自述4.1.12+自绘并采用数据库读取/OCR发送，但这只是候选作者声明，未安装、未读取数据库或提取密钥，也不能证明混合群真实@可用。后续路线必须能提供当前版本的读取机制证据，而不是重复同一选择器实验。

参考： https://github.com/fanyuantaier/wechatauto-replica/blob/main/README_pypi.md （候选声明，非本机验证）；https://github.com/scottfly189/WeChatAuto.SDK/issues/3 （上游UI Tree问题）。
