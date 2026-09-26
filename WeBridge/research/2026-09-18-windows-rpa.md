# Windows 微信 RPA / GUI 备选路线核验

核验日期：2026-09-18。约束：优先 Mac/Windows 共用；无法共用时优先 Windows；RPA 仍为备选。目标保持为个人微信参加企微创建的外部混合群，读取普通消息，主动发言，真实 @ 微信与企微两种成员，并识别真实 @ 和引用回复；用户希望“最好一直监控”，将其单独评估为持续覆盖期望，不擅自提升为零漏消息的硬性要求。仅查作者文档、公开源码与作者发布包，没有运行软件或操作微信。

## 结论

**这些库都不是 Mac/Windows 原生通用库。Windows 11 x64 是更合适的验证环境，但目前没有一个项目的一手资料证明完整满足目标混合群需求。** 最值得做小范围验证的是公开源码较完整的 `Hello-Mr-Crab/pywechat` 中的 **pyweixin**；有购买意向时才考虑 wxautox4 Plus。WeChatAuto4x.SDK 可列第二梯队，需要作者先说明监听实现和社区版/VIP 边界。

需分成两层判断：**基础双向收发有公开实现支持，值得做目标群 PoC；持续监控能做轮询，但覆盖受窗口、UI 树、群静音和消息突发影响。** 后者的局限不自动否决前者，也不能把前者跑通宣传为已经实现稳定全量监听。最终按用户能接受的持续覆盖水平选择投入。

Mac 上的 Agent、业务逻辑与存储可以共用，微信 GUI 执行放在 Windows 工作机，通过自己定义的接口连接。这是可设计的跨机器架构，不等于这些库能直接操作 Mac 微信；Windows ARM 虚拟机的依赖与 UI 行为本次未验证，不应直接当作 x64 Windows 的等价替代。

| 项目 | 当前微信 4.x 支持证据 | Windows / Mac / ARM | 监听与发送 | 对目标的判断 |
|---|---|---|---|---|
| wxauto4 / wxautox4 Plus | 作者文档：免费版到 4.1.8.107，产品适配 4.1；原 `cluic/wxauto4` 仓库已停止更新 | 作者明确 Windows-only；当前 PyPI 分发均为 `win_amd64`，无原生 ARM64/macOS 包 | 免费版有当前窗口读写；当前文档的 AddListenChat、GetSubWindow 等属于 Plus；发送有 `at` | 有现成 API，但 UI 可见区限制导致不能承诺全量；混合群两类真实 @ 未证明 |
| Hello-Mr-Crab/pywechat → pyweixin | README 明确 4.1.6+；公开源码 2026-09-10 更新 | QuickStart 要求 Windows 10/11 64 位；无原生 macOS 支持或 ARM 明确承诺 | 提供独立窗口监听；@ 实现真正选择成员弹窗；可引用回复 | 最适合作为可审计的 RPA 备选 PoC；首先检查账号 UI 树能否读取 |
| scottfly189/WeChatAuto.SDK → WeChatAuto4x.SDK | 作者列 4.1.11.xx 等 4.1 系列，UI Tree + OCR；源码 2026-09-18 更新 | 明确 Windows-only；.NET Windows targets；ARM 未确认 | 公开 @ 与引用实现可读；公开 MessageMonitor 文件是骨架，不能确认完整监听 | 保留比较，未确认是免费可完整运行的收发底座 |

表中“一手支持”是作者声明或静态代码证据，不是本机实测。作者自己也不能通过一句“支持最新微信”证明未来全部小版本持续兼容。具体依据见下文。

## 1. wxauto：把旧开源仓库、当前免费包、Plus 分开

`cluic/wxauto` 当前 README 标为 2021–2025 并转向作者网站；`cluic/wxauto4` 的主分支目前只剩“停止更新”。不能用 fork 保存的旧 README、教程中的旧接口，推断原作者仍维护同等开源功能。[wxauto 原仓库](https://github.com/cluic/wxauto)、[wxauto4 原仓库](https://github.com/cluic/wxauto4)

作者当前安装文档将免费 `wxauto4` 与商业 `wxautox4` 区分，免费版客户端兼容范围截至 **4.1.8.107**，`✨` 标记的方法为 Plus 专用。当前 `WeChat` 文档中，`AddListenChat`、`GetSubWindow`、`GetAllSubWindow`、监听启停均有该标记；`Chat.GetAllMessage` 是当前聊天窗口消息读取，`SendMsg` 列出 `at` 参数。不能把付费监听样例作为免费版现有能力。[安装与版本范围](https://docs.wxauto.org/docs/install.html)、[WeChat 类](https://docs.wxauto.org/docs/class/WeChat.html)、[Chat 类](https://docs.wxauto.org/docs/class/Chat.html)

**监听结构与全量限制：**作者解释 `Chat` 通过独立聊天子窗口，避免主窗口换聊天后丢失控件；其 4.x 适配说明明确：仅进入可见区域的消息才生成 UI 对象，消息挤出屏幕后对象会销毁。窗口太小或消息瞬间过多，可能把新消息判断锚点顶出可见区域，导致监听失效。扩大窗口只能缓解，不构成不漏消息保证。`GetNextNewMessage` 还有回调期间对象失效、不能在获取历史的回调里直接发送或引用等限制。[子窗口说明](https://docs.wxauto.org/docs/class/Chat.html)、[作者的 4.x 适配说明](https://docs.wxauto.org/blog/A9dYFme8.html)

**@ 与引用：**发送接口有 `at`，消息类型有 `QuoteMessage`，后者给出被引用正文与显示昵称。但当前文档未提供目标混合群两种身份分别真实 @ 的验证记录，也未列出可靠的入站 `is_at_me` / 结构化被 @ 成员 ID 字段。因此“能获取文字中的 @名字”不能写成“能识别真实 @”。FAQ 的“不支持企业微信”指未适配企业微信软件，不能单独用于否定个人微信客户端里显示的混合群；反过来，普通群的功能也不能自动推广到混合群。[消息文档](https://docs.wxauto.org/docs/class/Message.html)、[FAQ](https://docs.wxauto.org/docs/issues.html)

**系统与分发核验：**作者 FAQ 明确不支持 Linux/Mac。2026-09-18 查 PyPI：`wxauto4==41.1.7`（9 月 1 日发布）与 `wxautox4==41.1.1.post1`（8 月 3 日发布）的当前文件均为 CPython `win_amd64` wheel，没有 macOS 或 `win_arm64` 文件。Windows ARM 上使用 x64 仿真不在这些发布记录证明范围内。免费包实际有 cp313 wheel，但文档仍写 Python 3.9–3.12，说明发布元数据与文档有差异；初试可选二者都明确覆盖的 Python 3.11。[免费包元数据](https://pypi.org/pypi/wxauto4/json)、[Plus 包元数据](https://pypi.org/pypi/wxautox4/json)、[系统 FAQ](https://docs.wxauto.org/docs/issues.html)

**费用边界：**作者 FAQ 规定单机激活，不可解绑；激活后一年更新，更新到期后已取得版本可继续用。未核实当前结算价，不列价格。是否支持用户当前 Windows 微信精确版本、混合群、实际连续监听，仍须在购买前由演示或试用样本证明。Plus 的 PyPI 长描述还残留 4.0.5 Beta 字样，与当前网站 4.1 文档不一致，不据此判断确切兼容版本。[授权和更新 FAQ](https://docs.wxauto.org/docs/issues.html)、[Plus 发布元数据](https://pypi.org/pypi/wxautox4/json)

## 2. Hello-Mr-Crab 的 pyweixin：公开实现更利于验证

这里的仓库名是 `pywechat`，但当前 4.1 适配包叫 **pyweixin**；旧 `pywechat` 适配 3.9。QuickStart 给出 Windows 10/11 64 位、Python >=3.10，README 写 4.1.6+。本次固定检查提交 `ebe8d4be9347816d221c38843e5b9e5e480bd8fb`，提交日期 2026-09-10，包含消息拉取稳定性修改。源码公开，根 LICENSE 为 LGPL-2.1；本次未见为下述核心功能设商业激活门槛。[作者仓库](https://github.com/Hello-Mr-Crab/pywechat)、[QuickStart](https://github.com/Hello-Mr-Crab/pywechat/blob/ebe8d4be9347816d221c38843e5b9e5e480bd8fb/QuickStart.md)、[固定提交](https://github.com/Hello-Mr-Crab/pywechat/commit/ebe8d4be9347816d221c38843e5b9e5e480bd8fb)、[许可证](https://github.com/Hello-Mr-Crab/pywechat/blob/ebe8d4be9347816d221c38843e5b9e5e480bd8fb/LICENSE)

**首先有 UI 可读性门槛。** 作者最新《微信4.1+ UI自动化说明》称原先靠讲述人开启 UI 树的做法已失效，部分账号可读、部分新账号不可读；其列出的替代方向是已有可读账号或 OCR。本文只采纳“作者承认并非所有账号都能读 UI 树”这一可行性限制，不采纳文档里对平台策略、安全性或修复概率的推测。不能仅安装 Python 库就认为完成接入。[作者说明](https://github.com/Hello-Mr-Crab/pywechat/blob/ebe8d4be9347816d221c38843e5b9e5e480bd8fb/Weixin4.0.md)

**真实 @ 的实现是积极证据，但未证明混合群。** `utils.At`（284–323 行）会先检查群聊，键入 `@` 与名字，打开 mention 候选列表，选择完整匹配的群昵称后回车。这确实有生成客户端真实 mention 的路径，区别于直接发送普通 `@张三` 字符串。源码仅按显示昵称匹配，没有区分微信和企微身份的成员 ID 模型；同名、企业后缀、群昵称改变或混合群弹窗差异均需实测。[At 源码](https://github.com/Hello-Mr-Crab/pywechat/blob/ebe8d4be9347816d221c38843e5b9e5e480bd8fb/src/pyweixin/utils.py#L284)

**监听不是服务器订阅，也没有不漏保证。** `Monitor.listen_on_chat`（4267 行起）接收主聊天窗或独立子窗，反复读取聊天列表的 CheckBox UI 节点，以 runtime_id 差分判断新消息。作者注明窗口可最小化但不可关闭，涉及键鼠的选项在并发时要关闭；这个最小化行为仅为作者说明，不能跨版本推定。群发送人由传入的 `groupMembers` 显示名匹配，没传则只返回文本。该函数到 duration 结束才返回汇总字典；要实时逐条对接 Agent，需自建持续事件队列/回调，不能直接将它当作现成实时 Webhook。[监听实现](https://github.com/Hello-Mr-Crab/pywechat/blob/ebe8d4be9347816d221c38843e5b9e5e480bd8fb/src/pyweixin/WeChatAuto.py#L4267)

另一个 `listen_on_newMessages` 依赖会话列表红点计数：默认只看顶部可见范围，按页滚动需配置 `maxPages`，源码还会排除消息免打扰会话；结束后才逐个拉取消息。因此它尤其不能作为“所有群的全量实时监听”。[会话列表监听源码](https://github.com/Hello-Mr-Crab/pywechat/blob/ebe8d4be9347816d221c38843e5b9e5e480bd8fb/src/pyweixin/WeChatAuto.py#L4539)

`Messages.reply_with_quote` 支持找到正文后执行引用回复，属于有用能力；但按正文定位不是稳定消息 ID，重复正文会有歧义。当前监听结果主要是文本及从显示名推导的 sender，未发现可直接证明“真实 @ 我”或区分群成员身份的结构字段。作者有企业微信联系人读取方法，但联系人可读不能证明混合群全链路可用。[引用回复源码](https://github.com/Hello-Mr-Crab/pywechat/blob/ebe8d4be9347816d221c38843e5b9e5e480bd8fb/src/pyweixin/WeChatAuto.py#L3410)

## 3. WeChatAuto.SDK：公开发送实现可读，监听证据不足

作者项目区分旧 3.9 的纯 UI Tree .NET 库与新版 **WeChatAuto4x.SDK**，新版本使用 UI Tree + OCR，提供 .NET 与 Python 接口。作者称核心公开、约 20% 业务 API 为 VIP 专属；不是“整个 4.x 全部开源”。README 明确不支持 Linux/macOS；4.x csproj 为 Windows 目标，未列 ARM 支持。本次核查提交 `49a2c00e9c3d5578b5168cbbb1cba0873cbb4c1d`，提交日期 2026-09-18。[作者 README](https://github.com/scottfly189/WeChatAuto.SDK)、[固定提交](https://github.com/scottfly189/WeChatAuto.SDK/commit/49a2c00e9c3d5578b5168cbbb1cba0873cbb4c1d)、[项目目标](https://github.com/scottfly189/WeChatAuto.SDK/blob/49a2c00e9c3d5578b5168cbbb1cba0873cbb4c1d/WeChatAuto4_X/WeChatAuto/WeChatAuto.csproj)

公开 `Sender.__AtUserList`（960 行起）输入 @、读取 `chat_mention_list`、按名字寻找并点击成员，具备真实 mention 的实现路径；发送也支持引用。仍没有目标混合群的专项证据。特别注意其 `OuterGroup` 类注释是“他有群管理”，和 `OwnerGroup`“自有群”配对；这里的“外部群”不能解释成企业微信产品中的“外部客户混合群”。[发送源码](https://github.com/scottfly189/WeChatAuto.SDK/blob/49a2c00e9c3d5578b5168cbbb1cba0873cbb4c1d/WeChatAuto4_X/WeChatAuto/Components/Sender.cs#L960)、[OuterGroup](https://github.com/scottfly189/WeChatAuto.SDK/blob/49a2c00e9c3d5578b5168cbbb1cba0873cbb4c1d/WeChatAuto4_X/WeChatAuto/Components/OuterGroup.cs#L35)

当前公开 `MessageMonitor.cs` 只有字段、构造函数和空 Dispose；`MessageMonitorOptions` 虽提到弹窗/非弹窗监听，但不是完整算法。不能由 README“支持消息监听”推定公开社区版本已经提供可审计、可独立运行的完整监听能力，也不能据此断言全部缺失代码一定属于 VIP。必须让作者提供精确版本、最小示例、对应公开/付费接口清单以及连续收取样本。[公开 MessageMonitor](https://github.com/scottfly189/WeChatAuto.SDK/blob/49a2c00e9c3d5578b5168cbbb1cba0873cbb4c1d/WeChatAuto4_X/WeChatAuto/Components/MessageMonitor.cs)、[监听选项](https://github.com/scottfly189/WeChatAuto.SDK/blob/49a2c00e9c3d5578b5168cbbb1cba0873cbb4c1d/WeChatAuto4_X/WeChatAuto/Options/MessageMonitorOptions.cs)

作者关于键鼠模拟器“降低风控”的说法未附可复核对照数据，本报告不将其当作稳定性或账户安全保证；无需因为这种营销描述先购置硬件。当前 VIP 具体价格未核实。

## 4. 同名项目必须区分

| 名称 | 作者与路径 | 技术路线 | 本报告处理 |
|---|---|---|---|
| pywechat / pyweixin | Hello-Mr-Crab/pywechat | pywinauto / UI Automation | Windows GUI 备选主体 |
| “新版本 pywechat” | miloira/wxhook README 引导的另一个分发产品 | 原作者明确 wxhook 基于 DLL 注入；公开老版为特定 3.9 客户端，README 另宣传新产品 | 归入 Hook 分支，不能拿它的版本/功能给前者背书 |
| wxauto4 fork | fly000001、FreeWisdom 等第三方 fork | 各自保存或修改的 UIA 实现 | 不能当作 cluic 原作者最新承诺；本次未纳入优先清单 |

miloira/wxhook 作者 README 本身清楚区分旧开源 wxhook / wxhelper 与新发布 pywechat，故没有必要仅凭 pip 名称或中文文章判断是否 RPA。[miloira 作者仓库](https://github.com/miloira/wxhook)、[Hello-Mr-Crab 作者仓库](https://github.com/Hello-Mr-Crab/pywechat)

## 5. RPA 备选的验收顺序

1. **环境可读性：**在用户 Windows 测试机记录精确客户端版本、CPU 架构和账号；先只读检查目标混合群消息与 @ 候选 UI 是否能访问。失败就不先购 Plus/VIP。
2. **同一混合群端到端验证：**普通微信成员、企微成员分别发送普通文字、真实 @、只含 `@名字` 的普通文本、引用回复。验证接收方身份、引用对象和真实 @ 的区别，不能拿普通微信群替代。
3. **真实发送验证：**获授权的测试消息分别 @ 微信成员和企微成员，用另一端确认是否产生真实提醒及正确目标；同名、改群昵称也应验证。
4. **丢失条件验证：**群静音、主窗切换、子窗最小化、窗口被遮挡、锁屏/远程会话中断、消息突发、客户端断线重连。以参与方的完整发送序列核对是否漏读或重复，不能只凭“运行没报错”。
5. **成本决定：**只有测试数据证明适配目标，才决定自建 pyweixin 适配层，还是为 Plus/VIP 的明确缺失能力付费。若只能读显示文字、无法可靠判定真实 @，需把这项记为未满足，不能用字符串判断替代验收。

如果最终采用 Windows 工作机，建议将 GUI 操作串行排队，监听和 Agent 推理解耦，先存事件再交给模型；失去窗口、定位不唯一或发送回执不确定时停止自动发送。这是针对本任务的工程建议，并非以上项目已经具备的能力。

## 证据等级与未完成事项

- 已确认：作者当前版本声明、发布架构、商业/免费文档界线、公开 @ 与监听实现、wxauto4 原仓库停止更新状态。
- 待实测：任何一个库在指定企微外部混合群的完整工作情况；微信/企微两种身份真实 @ 的往返；长期零漏消息；Windows ARM。
- 未进行：软件安装、第三方登录、商业购买、群消息发送、账户风险规避实验。
- 本报告不采信“纯 RPA 等于零封号”或“有 OCR 等于全量可读”的推断。wxauto 作者 FAQ 也明确不保证不会发生账号限制。[作者 FAQ](https://docs.wxauto.org/docs/issues.html)
