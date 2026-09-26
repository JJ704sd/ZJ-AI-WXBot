# 个人微信接入商业服务核查（2026-09-18）

范围：个人微信账号进入**企业微信创建的外部混合群**，持续接收群消息、主动发言、真实 @ 微信和企微成员、识别被 @ 并回复。用户优先本机/自建、减少供应商依赖；最新平台偏好为 **Mac 与 Windows 都能使用最好，若不能兼顾则优先 Windows**。现有本机为 macOS 26.6.2、Apple Silicon、微信 4.1.13。本文只查公开一手文档/源码，没有购买、联系供应商、扫码登录、执行外部程序或验证真实群消息。

**结论：尚未发现能据公开资料确认“当前可在本机独立部署、无供应商核心依赖、完整满足该混合群场景”的商业候选。** GeWe 当前文档是可验证的试用入口；PadLocal 的公开代码能证明部分企微 ID 处理和远程依赖，但当前令牌获取、服务在线和混合群闭环仍待验证。旧 Gewechat 已明确停止维护。HTTP SDK、MCP 外壳、登录设备类型中的 `mac` 均不能当成可在 Apple Silicon 自建协议核心的证据。

| 候选 | 当前证据与群能力 | Mac / 自建 / 供应商依赖 | 价格与试用 | 本需求判断 |
|---|---|---|---|---|
| **GeWe / GeWeAPI** | 2026-08/09 文档仍更新；文本发送有 `ats` 字段，企微联系人详情使用 `@openim`。公开群成员示例是普通 `@chatroom`；未找到企业微信创建外部群的完整样例或专项承诺。[文本发送](https://doc.geweapi.com/api-139908313)、[企微好友](https://doc.geweapi.com/api-176159097)、[群成员](https://doc.geweapi.com/api-139908300) | 本机可写 HTTP 客户端；供应商声称支持企业私有化，但未公开完整核心源码、离线授权方式、构建链或 macOS ARM 服务端包。`type: mac` 是登录接口参数，不能证明服务端在 Mac 执行。[部署说明](https://doc.geweapi.com/)、[登录接口](https://doc.geweapi.com/api-139908278) | 官方快速开始称注册自动获得 **7 天试用**。价格页仅公开按节点、在线时长、企业部署三种模式；**准确现价未核实**。[试用](https://doc.geweapi.com/doc-3146201)、[计费](https://www.geweapi.com/pricing) | 可作为短期对照实验，当前不能判已满足外部群或独立自建。 |
| **旧 Gewechat（Devo919）** | 当前 README 明确停止维护，历史运行服务、镜像和支持不再提供，保留 Java HTTP 调用示例。[官方仓库](https://github.com/Devo919/Gewechat) | 仓库没有完整服务端；历史 Docker 教程不等于可构建、可维护的开源核心。 | 旧“免费”不能当成现有免费服务。 | 排除为当前部署主线；只保留 API 结构参考价值。 |
| **Wechaty + PadLocal** | 官方代码区分 `@im.chatroom`、`@openim`，文本发送向服务端提交 `atList`，具有具体的互通 ID/提及建模；不能据此证明 2026 年外部群收发和真实 @ 可用。[ID 判断](https://github.com/wechaty/puppet-padlocal/blob/main/src/padlocal/utils/is-type.ts)、[客户端发送 API](https://github.com/padlocal/padlocal-client-ts/blob/master/src/PadLocalClientApi.ts) | 官方列出 macOS 客户端用法；PadLocal 的 Local 是本地转发微信网络流量。客户端启动用 Token 访问 `gateway.pad-local.com:31527` 获取核心服务地址，再建立 gRPC 连接；不是完整独立核心。[架构](https://wechaty.js.org/docs/puppet-providers/padlocal/)、[服务发现源码](https://github.com/padlocal/padlocal-client-ts/blob/master/src/utils/ServerInfo.ts)、[初始化源码](https://github.com/padlocal/padlocal-client-ts/blob/master/src/PadLocalClient.ts) | 旧官方 Wiki 写 7 天试用、付费 Token，但页面最后编辑于 2021 年；官网本次工具未能访问，**现价及能否实际取得令牌未核实**。[旧 Token 说明](https://github.com/wechaty/puppet-padlocal/wiki/How-to-Apply-Token) | 有研究价值，暂不宜把它当可直接采购/自建的确定方案。 |
| **RPAChat / Wechaty 商业 Token 路线** | Wechaty 支持库 2025-10-30 置顶公告把 Token 销售、维护、支持转交 RPAChat。供应商主页描述云端 RPA 和消息 API；未找到个人微信进入企微外部群的专项验收证据。[主体调整](https://github.com/wechaty/puppet-supports/issues/724)、[供应商官网](https://rpachat.com/) | 业务代码可本机运行，底层是供应商云端；公开页面没有可独立构建核心。不能把 Wechaty 框架开源等同于商业通道开源。 | 自助购买入口仍存在，但本次页面只返回空壳；**现价、实际在售通道和试用未核实**。[Token 控制台](https://token.rpachat.com/) | 用户将 RPA 限为备选，此路线优先级较低。公告也不能推出 PadLocal 已全部迁入此新主体。 |
| **QiWeAPI** | 官方文档描述企微账号的 iPad 云设备、联系人、群、消息和 Webhook。[平台介绍](https://doc.qiweapi.com/) | 可从 Mac 调 API；身份是企微账号，公开文档不能证明可自建核心。 | **现价、试用未核实**。 | 如果坚持“个人微信账号作为机器人”，它不是直接替代；只有允许切换企微身份时再研究。 |
| **wechat2ipad/wechat-ipad-protocol 商业交付** | 供应商仓库公开近期更新日志和源码/部署包销售；公开目录以 README 等材料为主，未提供可自行审计构建的协议核心。[供应商仓库](https://github.com/wechat2ipad/wechat-ipad-protocol) | 声称源码交付和私有化，尚未验证交付完整性、ARM 支持或授权/算法服务器依赖；更新日志中的“mac 直登”描述登录方案，不是 macOS ARM 构建保证。 | 本次 README 展示 **SaaS 200 元/号/月、部署包 5000 元、源码 10000 元、维护期后更新 800 元/次**，同时标注 2026-10-01 起调整，旧段落还有半年/3 个月维保冲突。只记录公开标价；**9 月 18 日准确有效报价未核实**。 | 可作为“购买完整交付”候选；未拿到源码、构建和外部群结果前，不可当成已确认方案。 |

## GeWe 与旧 Gewechat 不能混为一谈

旧仓库当前把 GeWeAPI 和 QiWeAPI 称为独立技术资料，并明确不表示 Gewechat 恢复维护。名称关联、API 路径相似和社区适配层只能说明历史生态联系，不能证明当前同一运营主体、原免费镜像仍可用，或私有化没有授权依赖。[Gewechat README](https://github.com/Devo919/Gewechat)

GeWe 当前明确有一般群接收 Webhook：Token 下在线账号收到消息后推送，接收端需公网可达且 3 秒内响应；接口发送消息不回调、手机发送会多端同步。这个行为意味着“完整消息记录”需要另存自己 API 发送的内容，还必须实测回调超时后的丢失/重放机制，不能直接承诺全量可靠。[Webhook 行为](https://doc.geweapi.com/doc-3146208)

GeWe 文档对真实 @ 给出 `ats` 和可见 `@姓名` 的组合，而不是只拼文本；但示例仅为普通群。企微好友接口证明存在 `@openim` 联系人支持，不自动证明 `@im.chatroom` 外部群、非好友企微成员映射和提及通知正确。[发送接口](https://doc.geweapi.com/api-139908313)、[企微详情](https://doc.geweapi.com/api-176159097)

所谓 AID 本地代理目前文档列 Windows、Linux x86_64/arm64 和 Android。它把出口放在用户设备上，在线期间仍需保持代理和供应商相关网络可达；Linux ARM 支持的是代理程序，不能移作 GeWe 核心支持 Apple Silicon 的证据。文档没有给 macOS 原生代理方案。[AID 说明](https://doc.geweapi.com/api-483017826)

## PadLocal 的供应链边界

Wechaty 是应用框架，`wechaty-puppet-padlocal` 是适配层，`padlocal-client-ts` 是客户端。公开代码能确认 Token → 服务发现 → gRPC 远端请求这一链路。更换 `PADLOCAL_ENDPOINT` 只能指定另一个已存在且兼容的服务，并不会生成缺失的服务实现。[适配层依赖](https://github.com/wechaty/puppet-padlocal/blob/main/package.json)、[服务发现](https://github.com/padlocal/padlocal-client-ts/blob/master/src/utils/ServerInfo.ts)

`isIMRoomId()` / `isIMContactId()` 是值得保留的正向证据；但还必须检查接收解析、联系人获取、群成员查询和发出提及是否使用同一套 ID，并实测服务端。在这次核查中没有把“工具函数存在”或 README 能力勾选升级成已验证兼容。

PadLocal 的近期 issue 有用户报告旧官网无法解析并申请试用，但这是使用者报告，不是维护者停服公告；本次网页访问失败也不足以单独判定供应商停服。应标“当前可取得令牌/可登录未证实”，不标“确定已关闭”。[2026-08-22 用户 issue](https://github.com/wechaty/puppet-padlocal/issues/382)

旧商业通道确有明确终止证据：Wechaty 的服务目录把 WXWork 和 Donut 列为 Deprecated，PadPlus 原仓库也给出旧服务停止/迁移公告。因此旧教程中的产品名称和购买入口需要逐项重验。[当前服务目录](https://wechaty.js.org/docs/puppet-services/tokens)、[PadPlus 终止公告](https://github.com/wechaty/wechaty-puppet-padplus)

## “逆向付费方案”能带来什么

以下是根据上述架构作出的工程判断：

- 对公开 HTTP/gRPC 客户端做代码分析，能重写业务 API 适配层、换语言、记录事件、解耦供应商和建立验收工具；这些通常不需要先购买。
- 仅观察 SaaS 请求/响应，无法据此恢复远端的微信登录、会话、协议编解码和版本维护实现。开源调用示例不等于协议源代码。
- 要减少核心依赖，更实际的候选是可审计的完整源码交付或真正包含协议核心的开源实现；供应商仍需回答能否自行编译、是否有远程鉴权/算法请求、维护停止后能否继续运行。
- 私有化部署、独立数据出口、源码交付、可离线授权是四项不同承诺。报价应逐项确认，不以一个“私有化”词替代完整检查。

## 最小实测与交付验收

1. **群类型和身份**：由企微账号新建外部群，至少放入一个机器人个人微信、另一个个人微信、同企业和可选异企业企微成员；另建普通微信群做对照。记录真实群 ID 及所有成员稳定 ID，避免把普通群测试冒充外部群测试。
2. **接收完整性**：所有成员分别发文本、图片、文件；含免打扰群、非当前聊天、断连后重连和服务重启场景。发出带序号样本，统计缺失、重复、顺序和延迟。回调保存后异步处理；自产消息独立记录。
3. **真实 @**：机器人分别 @ 微信成员与企微成员，由被提及方客户端确认提醒/跳转；对比单纯 `@姓名` 文本。双方 @ 机器人时只触发一次响应，非 @ 或同名文本不误触发。需要非好友、同名和昵称变更用例。
4. **平台边界**：先验证 Mac/Windows 上的 API 客户端；若要求协议核心在两个系统独立运行，分别验收 Darwin arm64 和 Windows 目标架构的构建与运行结果。若核心仅支持 Windows，则优先验证 Windows 接入节点，Agent 保留跨平台；Linux arm64 产物不算 Darwin arm64 产物。确认服务与日常桌面微信会话的共存关系。
5. **供应链独立性**：拿到交付清单后静态审查；在测试环境验证仅切断供应商域名、保留微信所需网络时是否仍能启动、登录、重连、收发。区分订阅到期限制、远端算法依赖与平台版本兼容问题。该实验只适用于已获交付和授权范围。

下一步需用户协助的最小集合：提供一个可用于测试的个人微信、一个可以创建外部群的企微账号、允许测试的成员，以及若选 SaaS 时自行领取的试用 Token。确认现有外部群场景前不建议购买年费或仅凭“支持群聊”付费。

## 补充：跨平台与 Windows 优先筛选

最新平台偏好改变了部署优先级，但没有改变“协议核心是否完整、企微外部群是否真正可用”的验收要求。这里的跨平台必须分为三种，不能混用：

| 类别 | 实际含义 | 本次核查结论 |
|---|---|---|
| **HTTP/gRPC 客户端跨平台** | Mac、Windows 上的 Agent 访问同一远端通道；核心仍由供应商运行。 | GeWe 的标准 HTTP API、PadLocal 的 Node 客户端属于这一层可讨论的兼容性。它解决业务代码的运行位置，不能证明微信接入节点也跨平台或摆脱订阅。[GeWe 接入](https://doc.geweapi.com/)、[PadLocal 平台用法](https://wechaty.js.org/docs/puppet-providers/padlocal/) |
| **完整协议核心跨平台构建** | 自己持有核心源代码和全部依赖，可分别构建并运行 Windows 与 Darwin arm64 接入端。 | 本报告候选尚无公开完整证据。应要求两平台构建脚本、依赖清单、产物及外部群实测；仅能构建 Linux 容器、仅有 `type=mac` 登录参数或源码交付宣传均不够。 |
| **Windows 接入节点 + 跨平台 Agent** | 微信相关依赖集中在可验证的 Windows 机器；Mac/Windows 业务侧通过自有 HTTP/WebSocket/gRPC 接口使用它。 | 这是符合新偏好的工程候选：若完整跨平台核心不可得，则优先此架构。它能让 Agent 跨平台，接入节点仍依赖 Windows，且必须先证实节点的目标微信版本、机器架构及外部群能力。此项是架构建议，不是某产品已经通过验收的宣称。 |

对 `wechat2ipad/wechat-ipad-protocol` 补做了一次限定范围的公开交付审查：

- GitHub Tree API 的当前快照为 `21e67106ca1797308312dbfbf421d8ceb8ce16e2`，`truncated=false`，仅 7 个文件：`.github/workflows/add.yaml`、`.gitignore`、`LICENSE`、三个 README 和 `long-tail-keywords`。没有公开协议实现、依赖锁定或各系统构建入口。[完整文件树 API](https://api.github.com/repos/wechat2ipad/wechat-ipad-protocol/git/trees/main?recursive=1)
- Release API 返回 0，GitHub Release 页也显示没有发布记录；因此本次**未见可核验的 Windows、Linux 或 Darwin 核心发行产物**。这不排除供应商私下交付，但不能把它算作已经取得和验证。[Release 页](https://github.com/wechat2ipad/wechat-ipad-protocol/releases)、[Release API](https://api.github.com/repos/wechat2ipad/wechat-ipad-protocol/releases)
- README 的 Windows/mac 相关日志谈的是登录能力。没有对应目标系统核心产物、构建链和运行记录时，不能推出支持在该操作系统部署。[供应商 README](https://github.com/wechat2ipad/wechat-ipad-protocol/blob/main/README.md)
- 核心并未公开，所以远程鉴权、算法服务、设备授权和更新服务的必需性仍属**未知**；没有观察到外部依赖不能写成“没有外部依赖”。该候选保持“待完整交付核验”，不提升为 Windows 或跨平台首选。

据此，后续验证顺序调整为：先筛真正具备完整核心与两平台证据的实现；未满足时优先 Windows 接入节点、自建跨平台 Agent；商业 SaaS 保留作混合群接口行为对照。GeWe/PadLocal 客户端能在 Mac 与 Windows 运行，不是推翻上述顺序的理由。
