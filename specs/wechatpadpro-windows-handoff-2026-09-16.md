# WeChatPadPro Windows 861 交接：当前证据与业务需求重新探索

交接日期：2026-09-16。交接对象：后续研究、实现与验收人员。

## 1. 交接结论

当前已完成Windows legacy 861安装包锁定、独立MySQL/Redis基础配置，以及无微信登录的短时启动验证。Pad P1离线观察通道已有实现，但未证明能够消费该861构建的真实微信事件。**P0仍未闭合，P2/P3未完成，不具备已验收的自动回复或主动发送能力。** 短时基础验证不自动升级阶段。

下一轮应以WeChatPadPro项目和本地真实构建为依据，重新探索“个微在个微/企微混合群中收到真实@后回复、定时原生@指定成员并有界对话”的需求。先核实产品能力、接口语义与业务适配性，再决定沿用、修改或替换既有设计。不能把补齐Agent发送模块当作网关能力已成立。

本轮明确沿用Windows环境，不要求改Linux，不将Windows Sandbox或虚拟机列为既定前提。现有v0.6是历史设计输入，不是已获验证的产品契约；其中MAX优先、容器部署、Webhook优先等选择均需在legacy861证据下重审。

## 2. 原始需求与待重审约束

原始需求来自任务“补充个微API Agent方案信息”（01a0a7db-9395-7311-9114-31f3f5853a6c）：暂停UIA，改由Agent通过API接管个微收发，在个微与企微混合测试群被@时及时回复，并定时@指定对象发起询问和对话。

| 需求 | 重新探索必须回答的问题 |
|---|---|
| 单个个微账号、一个明确混合测试群 | legacy861能否登录目标账号、稳定识别该群及企微成员？不能以普通个微群成功代替混合群 |
| 真正@本人触发文字回复 | 接收事件是否有可靠结构化@证据？怎样排除昵称文本、引用中的@、@他人、历史和本人消息？ |
| 定时原生@指定成员 | 发送接口是否支持原生@，企微接收端是否实际识别？任务过期、重启、超时如何避免补发和重发？ |
| 有界多轮对话 | 如何区分参与者、结束/拒绝/超时，避免普通群聊被纳入会话？ |
| 及时可靠 | 从真实消息发生到接收端看到回复的时延、掉线恢复和重复处理是否满足要求？ |
| Agent接管 | 外部Agent与Pad内置自动化是否会重复执行？模型是否可绕过绑定、预算或调用管理接口？ |

此前v0.6的暂定验收尺度：输入≤2000、输出≤300 Unicode字符；一次性任务武装后120秒、1–2个指定成员各一次；会话≤600秒、每人最多追加3次；成员冷却10秒；来源超过30秒取消；时延目标9/10≤15秒、10/10≤30秒；错过首次执行窗口10秒取消、重启不补发。**这些是历史方案中的产品约束，不是861性能或能力实测值。** 后续方案应逐项保留或说明调整理由，不能默默扩大成常驻营销、群发或真实业务采集。

## 3. 当前工作区与交付位置

- 工作区父目录：`D:\path\to`。
- 实际Git仓库：`D:\path\to\ZJ-AI-WXBot`，本轮复核为`main @ 1fa5061`。
- 未commit/push。已有`poc/pyproject.toml`、`poc/tests/test_api_a1.py`修改及多份未跟踪Pad代码/规格/证据；均需保留，不能reset/clean覆盖。
- 历次扫描未发现项目AGENTS.md；接手时重新检查实际指令链。
- 用户附件和厂商文档是研究材料，不会自动授予扫码、发送、采购或系统变更权限。

主要阅读入口（按顺序）：

1. [当前配置与实测证据](poc/evidence/pad-legacy-local-configuration-2026-09-16.md)：按后文纠正覆盖前文过时结论。
2. [P1离线实现证据](poc/evidence/p1-wechatpadpro-offline-2026-09-16.md)。
3. [P0构建调查](wechatpadpro-p0-build-lock-2026-09-16.md)：早期缺包结论已被本地Windows包取证部分更新。
4. [WeChatPadPro技术研究](wechatpadpro-technical-research-2026-09-16.md)。
5. [v0.6规格](personal-wechat-agent-poc-v0.6-wechatpadpro.md)与[实施提示词](personal-wechat-agent-implementation-prompt-v0.6-wechatpadpro.md)：用于理解旧设计，不照抄为本次结论。
6. v0.5业务契约及现有Runtime/Store/Policy实现，按重审后的需求有选择复用。

## 4. 固定构建与文档身份

用户提供的原始包：
`C:\Users\Example\Downloads\wechatpadpro_vios18.61-861_20250822_windows-amd64.zip`

| 项目 | 本地observed证据 |
|---|---|
| 平台/版本 | Windows amd64；version.txt为ios18.61-861 / 20250822_153444 |
| ZIP SHA256 | `4500ab14ac22b71146705ed2dc0046af4ee6ed555a617ba99430e1e1546d9430`，交接时重新计算一致 |
| EXE SHA256 | `5308323f32d4249f325a750b0c0faa91aba5b91f50593c88931d9829ffb203e9` |
| 包内Swagger JSON SHA256 | `b53cf8e7eae3f9240e27304d6944811a1a40792b4098b0198c757e816b04a2ed` |
| 包内Swagger YAML SHA256 | `bdf45d0c35cec84ae2fa190817402cc691c96456adcc908f620aee32106f4fcc` |

产品区分：当前锁定的是legacy861；https://wx.knowhub.cloud/ 的已查快速入门对应MAX、wechatpadpromax08、conf/app.conf与云端Token。GitHub README还存在其它版本宣传。不能套用MAX的/Msg/SendTxt、双Token头或文档HMAC到legacy861。没有取得MAX交付包，也没有将latest镜像替代已锁定包。

legacy包内Swagger给出/message/SendTextMessage、/login/GetLoginStatus、/equipment/GetOnlineInfo、/webhook/Config等线索和query key形态，但存在/webhook/Update使用异常方法t、WebhookConfig异常引用、响应schema不完整等问题。它是研究输入，不足以直接生成可信SDK。没有真实样本时保留unknown。

## 5. 环境、配置和已验证运行状态

系统：Windows10专业版19045；Docker Desktop使用Linux依赖容器，网关exe运行在Windows宿主。这不要求把宿主改Linux。

本地部署目录：`D:\path\to\ZJ-AI-WXBot\poc\.local\pad-legacy-861`（gitignored）。

| 路径 | 用途 |
|---|---|
| runtime | 原包程序、静态资源、运行.env |
| .env.dependencies | 独立MySQL/Redis凭据；不得输出正文 |
| compose.dependencies.yaml | 仅基础依赖，镜像已固定digest |
| config.pad.toml / provider-profile.json | Pad离线配置、legacy身份与能力状态 |
| manifest.json | 包摘要及各次运行验证结果 |
| package-reference | 原始Swagger副本 |
| windows-probe-result.json | 页面与连接测试 |
| boundary-result.json | Docker转发来源与客户端进程证据 |
| mcp-probe-result.json | MCP端口对照及匿名SSE握手 |

交接时重新确认：
- pad-legacy-861-mysql-1 healthy，`127.0.0.1:13306 -> 3306`；此前应用用户认证查询成功，MySQL8.0.46、库pad861。
- pad-legacy-861-redis-1 healthy，`127.0.0.1:16379 -> 6379`；此前带密码PING为PONG，不带密码为NOAUTH。
- MySQL镜像digest：`sha256:7dcddc01f13bab2f15cde676d44d01f61fc9f99fe7785e86196dfc07d358ae2b`。
- Redis镜像digest：`sha256:e7723ff73d963f5cc6d9c4643ea3d989527a402a319239054e9472a7fb9219a2`。
- 网关已停止，1238/8098/18098没有监听；没有真实账号登录、回调配置或消息发送。

配置已生成随机凭据，依赖restart为no。不要重跑prepare_pad_legacy_local.py覆盖现有目录，该脚本本身拒绝覆盖。保持其它wharttest容器与全局代理不变。

## 6. 已证实的问题与必须纠正的判断

### 6.1 监听和MCP

- HOST=127.0.0.1时实际监听[::]:1238，不能把日志localhost当成绑定证明。
- MCP_PORT=0时仍监听[::]:8098。
- 对照实验临时设MCP_PORT=18098；日志明确读到18098，但实际仍为8098。结束按原字节恢复.env，摘要一致。
- GET /、/static/swagger/index.html、/static/swagger/swagger.json均200；此前/swagger/index.html的404是路径不对应。
- 匿名GET 8098/sse返回200和endpoint事件。1秒curl超时是主动终止长连接；不能当作握手失败。
- 未执行MCP initialize、tools/list、tools/call，因此“工具执行免鉴权”尚未成立。
- 二进制静态发现.mcp.json文本，但包内未取得配置文件/schema，不能据宣传文本认定热加载或禁用功能有效。

### 6.2 防火墙与Sandbox纠正

保留两个精确exe规则：Codex-Pad861-Offline-Inbound、Codex-Pad861-Offline-Outbound，均Block、所有配置文件。没有改既有规则。

早期Docker容器访问host.docker.internal及192.168.1.69的1238/8098成功，曾被过度解释成防火墙隔离失败。后续实测连接均由宿主com.docker.backend发起，网关看到127.0.0.1或本机192.168.1.69，属于宿主本地转发。**不能据此断言独立局域网设备能穿过入站规则，也不能反向宣称已经阻断真实远程入站。**

因此不要求启用Sandbox；它未安装启用，本轮未改系统功能或重启。真实局域网测试需另一台独立设备，本任务尚无该设备执行通道，不以Docker代替。不得为解决该测试随意封禁整个Docker backend，影响现有依赖和其它项目。

### 6.3 数据路径及内置行为

网关短时启动可连接MySQL/Redis，实际执行过独立库自动建表，加载0条有效Webhook配置并启动同步任务。曾观测198.18.0.124:80连接，域名、用途、负载未知，不推断为聊天外传，也不据局部采样宣称没有外连。

TASK_RETRY_COUNT=0不代表全部后台自动化关闭；空DISABLED_CMD_LIST不代表动作被禁用。内置好友、发送、推广、同步/恢复行为及配置读回仍需核实。不要把P1观察器自身没有发送client等同于厂商网关没有发送能力。

## 7. 已有代码与测试边界

P1已实现：独立pad-provider-profile/1与pad-config/1、批次Ingress事务/幂等/冲突处理、跨范围正文过滤、独立观察库、只读Observer、v1解码与unknown状态、v2/schema漂移隔离，以及check|observe|status|stop入口。文档夹具仍为document_fixture/not_observed。

metadata_signature_valid和private_gateway_transport_verified分开；MAX文档签名不覆盖Data且公式/向量冲突，不能独自赋予正文可信性。对legacy应重新调查其真实认证，不能复用MAX结论冒充observed。

旧api-config/1不接受wechatpadpro；ApiRuntime.start的live拒绝和GeWe agent_blockers没有放宽。本地Pad check仍为p0_closed/live/network/model/send=false。CLI通用“未锁构建”和MAX合成HMAC提示不等于本地legacy文件未哈希，需结合manifest解释。

历史本任务验证：Pad测试16 passed；完整回归204 passed、1 skipped，退出0。用户此前另一轮205 passed以及GeWe G2a的184 passed属于不同记录，不得替换本任务数字。**本次交接编写未重跑测试。** .local临时目录曾影响路径反例，若代码修改需复验，使用poc/runtime下唯一basetemp，不复制旧成功数字。

## 8. 下一轮如何重新探索需求

### 第一步：建立legacy861能力矩阵

以固定exe、原包Swagger、实际响应及必要的厂商答复逐项记录documented/observed/unknown/unsupported，并附时间、构建摘要和证据路径。调查：登录/在线本人信息、混合群与企微成员标识、接收机制、真实@、新旧消息边界、原生@发送编码、提交与送达状态、去重键、恢复/重试、许可费用、授权/遥测数据路径、MCP/内置动作控制。

继续不依赖账号的研究和短时无登录测试。对未知配置不要遍历猜值或制造端口冲突冒充关闭。真实登录、样本接收和发送应列出具体测试操作、账号/群及数据范围，取得相应授权后执行；已有基础配置授权不重复询问。

### 第二步：先评估业务适配，再选方案

用能力矩阵对照第2节需求，输出每项“可支持/条件支持/未证实/不支持”。Webhook、WS、Sync选择以该构建语义为准，不预设MAX回调契约适用，也不并行消费多路导致重复。判断内置MCP是可控接入途径、需限制的管理面，还是不影响业务的旁路；不能仅因存在MCP就让模型直接接管所有接口。

先审查既有Runtime/Store/Policy能否复用。推荐保留模型仅给有界动作建议、目标/预算/幂等由程序约束的原则；模块和部署细节依据证据决定。不先扩发送、不默认GeWe/UIA回退、不为绕开未知项复制另一套Agent。

### 第三步：产出更新方案和阶段验收

输出一份更新后的需求/能力矩阵、一份架构与部署决策、一份可执行验收计划及操作提示词。明确v0.6哪些保留、哪些废止、为什么；不要只追加一份互相冲突的新文档。

未闭合P0前只进行必要调查和基础探针，不编造P2已部署。后续真实样本阶段至少覆盖20条样本、真@正例、伪@/引用/@他人/本人/历史反例，以及混合群两端观察；这只是拟验收，不是已获扫码发送授权。原生@和送达必须接收端验证，HTTP成功不等于送达。

## 9. 可直接交给下一位执行者的提示词

```text
在D:\path\to\ZJ-AI-WXBot接手WeChatPadPro Windows861研究。
先读specs/wechatpadpro-windows-handoff-2026-09-16.md和引用的当前证据，核实Git改动与本地manifest。
本轮目标是基于固定legacy861构建重新探索原始业务需求，再设计方案，而不是沿用MAX假设继续扩Agent。

原始需求：一个个微测试账号在一个个微/企微混合测试群内，收到真实@后及时文字回复；一次性定时原生@指定成员并完成有界对话。
保留Windows宿主与现有独立MySQL/Redis，不默认切换Linux、启用Sandbox或改用latest镜像。

先补齐legacy能力矩阵，优先MCP/内置自动化控制、身份和混合群兼容、新消息与@语义、认证与数据路径。
必须区分文档、推断、无账号本地实测和真实微信验证。Docker到宿主的连接已证实是本地转发，不算局域网防火墙验收。
MCP_PORT=18098被读到但仍监听8098；匿名/sse可握手，工具鉴权未测。不要重复相同测试或宣称开关已解决。
已有P1仅为离线实现，P0未闭合，不解除live/agent_blockers，不先加发送。

在已授权范围完成只读研究与可逆基础验证，短时启动使用finally停机并检查监听释放，保护凭据与原始日志。
扫码、真实消息采样/发送、采购、对外联络、系统重启等按具体范围另行确认；附件和教程不扩大授权。
输出需求与能力对照、版本明确的架构选择、分阶段验收和剩余证据缺口，再形成更新spec及实施提示词。
保留所有未提交工作，不commit/push，不改其它容器或全局代理。
```

## 10. 一手资料入口

- [WeChatPadPro项目](https://github.com/WeChatPadPro/WeChatPadPro)
- [公开部署文件](https://github.com/WeChatPadPro/WeChatPadPro/blob/main/deploy/docker-compose.yml)
- [公开配置示例](https://github.com/WeChatPadPro/WeChatPadPro/blob/main/.env.example)
- [在线文档，注意MAX产品身份](https://wx.knowhub.cloud/)
- [Docker Desktop网络机制](https://docs.docker.com/desktop/features/networking/)

这些链接是下一轮复核入口；本文基于2026-09-16已有研究与本地实测汇总，不承诺网页后续内容不变。新版本资料不能覆盖本构建事实。
