# Windows 861：MCP、HTTP 鉴权及设备授权实测

日期：2026-09-16，15:48–15:53（Asia/Shanghai）。固定 EXE SHA-256：`5308323f32d4249f325a750b0c0faa91aba5b91f50593c88931d9829ffb203e9`。

## 结论

无账号接口验证已向前推进，但设备凭据生成失败，尚未到扫码阶段。该构建不能按“配置一个随机 ADMIN_KEY 就能离线生成设备”理解；本地管理员鉴权和上游设备授权是不同证据。上游授权服务参与的静态线索、错误响应已取得，但服务连通性、当前 key 的授权资格、费用和有效性都未验证。不能把未知写成需要购买，也不能把此失败直接归因于 DNS 或防火墙。

原账号、群绑定已在本地找到，沿用此前对象；不在本文复制内部标识。未请求二维码，未登录、采集微信消息、调用模型或发送消息；MCP tools/call 未执行。没有修改防火墙、代理、DNS、系统服务或其它容器。

## 运行条件与清理

- 实际核对 `Codex-Pad861-Offline-Inbound/Outbound` 均 Enabled/Block，路径精确匹配 EXE。它们在所有本轮探针期间保持启用。
- MySQL、Redis healthy，绑定分别为 127.0.0.1:13306/16379。
- 每次运行前拒绝已有 1238/8098 监听；只停止本次启动的 PID，finally 校验端口释放和 .env 原始哈希。
- 最后一次 15:53:27 清理：gateway_stopped=true、remaining_listeners=0、config_unchanged=true。
- 这不是独立局域网设备的入站测试；未验证此项。

## 实测矩阵

| 操作 | 输入范围 | 结果 | 能证明什么 |
|---|---|---|---|
| SSE 建连 | 无鉴权 | HTTP 200，服务公布 localhost:8098 消息端点 | 匿名连接可建立 |
| initialize | 无鉴权，协议 2024-11-05 | POST 202，收到 result | 匿名协议初始化可完成 |
| tools/list | 无鉴权 | 193 个工具，无 nextCursor | 匿名工具元数据可见，不等于执行免鉴权 |
| GET /admin/GetAllDevices | 缺 key、错误 key | HTTP 200、业务 Code 300、Data null | 这两个负例被业务层拒绝 |
| 同一设备列表接口 | 已配置的本地 ADMIN_KEY | HTTP 200、Code 200、devices=[] | 本地管理员鉴权有效；准备前无设备 |
| GET /login/GetLoginStatus | 缺 key、错误 key | HTTP 200、Code -2 | 尚无有效账号状态证据；200不是成功 |
| GET /equipment/GetOnlineInfo、/webhook/Status | 缺 key | HTTP 200、Code -2 | 未取得在线或回调配置 |
| POST /admin/GenAuthKey1 | 已配置 ADMIN_KEY；Count=1、Days=1 | HTTP 200、Code 300、Data null；“生成授权码失败: 授权服务暂时不可用，请稍后再试” | 本次未取得设备 key；保留失败收据，不自动重试 |

工具列表包含发送、联系人和管理类工具，193 个工具参数均未列出 query key。启动日志宣称 SSE 连接 key/Authorization 用于授权；未调用工具，因此没有验证这项宣称。不能将工具列表当作无账号可操作微信的通道。

前两次元数据探针在端点校验时终止：服务返回 localhost，初版仅允许127.0.0.1。定位后仅把localhost:8098固定映射为127.0.0.1:8098；拒绝其它主机、端口、凭据和fragment，并禁用HTTP重定向。后续完整元数据探针通过。所有失败也已执行停机清理。

## 授权失败诊断

复现入口：`scripts/test_pad_861_metadata.ps1 -PrepareDevice`；它已保存尝试意图，再次执行会拒绝，避免超时或失败后盲目生成。不要删除意图记录后直接重试。

证据链：

1. 同一 ADMIN_KEY 能通过只读管理接口，故“本地管理员 key 未加载”与已观测结果不符。
2. 生成接口进入处理并返回授权服务错误；没有返回新设备凭据。该接口不是纯本地随机生成。
3. 固定 EXE 静态包含 `https://adminkeyservice.knowhub.cloud`。项目 [Issue 148](https://github.com/WeChatPadPro/WeChatPadPro/issues/148) 记录过同路径的上游授权校验；这是其它实例的故障记录，不是本机网络抓包。
4. 本机系统解析该域名得到 198.18.0.21，hosts 未匹配到该域名。本机存在代理环境；该地址本身不足以认定 DNS 错误。没有改 DNS、hosts 或代理。项目 [Issue 205](https://github.com/WeChatPadPro/WeChatPadPro/issues/205) 的回环解析原因不能套到本机。
5. 出站程序阻断仍启用，因此本次并未在正常出网条件下核实上游服务或授权。没有验证“解除阻断就能成功”；当前随机 ADMIN_KEY 也没有被验证为上游认可的授权。

结论是**授权链路未闭合**，不是已经证明某个单一根因。下一次受控实验应先确认该构建认可的授权方式，再决定指定授权服务的短时连通性验证；不测试公开默认密钥，不绕过授权校验，不直接放开所有出站后碰运气。

## 内置动作调查

项目公开[功能说明](https://raw.githubusercontent.com/WeChatPadPro/WeChatPadPro/main/微信功能使用说明.md) 描述了 A301 自动回复、A801 自动接受好友和其它行为的切换命令。文档说这些命令每次发送切换状态，并非只读状态查询。没有向文件传输助手或任何联系人发送它们，也没有把命令名猜填到 DISABLED_CMD_LIST。该文档未锁到本 EXE，默认状态与禁用有效性仍 unknown。

## 实现与测试

- `scripts/test_pad_861_metadata.ps1`：固定哈希、规则/端口前置检查、隐藏启动、finally停机、配置不变核验。
- `scripts/probe_pad_861_metadata.py`：匿名元数据三步、方法白名单、精确loopback、拒绝重定向、输出去会话端点。
- `scripts/probe_pad_861_http_auth.py`：只读对照，报告仅含响应字段名、业务码、数量；不输出key或设备内容。
- `scripts/prepare_pad_861_device.py`：一次设备凭据准备；本轮返回业务失败；私密原始收据及意图均在gitignored目录。
- 实际测试：`tests/test_pad_metadata_probe.py tests/test_pad_p1.py tests/test_pad_check_reporting.py`，**24 passed in 1.07s，退出0**。本轮没有改Agent生产逻辑，未重跑全量；上一轮205/1不是本轮结果。

本地结构化原始结果位于 `.local/pad-legacy-861/`：metadata-probe-result.json、http-auth-probe-result.json、device-preparation-result.json、metadata-cleanup-result.json。厂商日志会打印 ADMIN_KEY，原始日志只留gitignored目录；禁止直接分享。报告未包含密钥、会话端点或聊天正文。

## 下一步最小条件

先确认是否已有适用于该 Windows 861 的有效厂商授权/设备 key，以及该构建当前可用的授权服务。若已有，只通过本地文件配置，不粘贴到聊天；若没有，先核实获取方式与可用性，不能因本地运行成功而默认免费可用。授权链路闭合后仍须核实内置动作与网络边界，再进入原测试号扫码、单群只读样本阶段。未宣称 P0/P2/P3 完成。

## 用户补充后的准备

用户起初回复“已有，可通过本地文件配置”，随后明确纠正：**只是下载ZIP，没有另外取得任何密钥**。以此最新说明为准，不再等待填写凭据。已创建的 gitignored `.local/pad-legacy-861/license-input.json` 保持空白；没有导入厂商密钥。`credential_kind` 区分 admin_key/device_key，不能将两者互换。

新增 `scripts/apply_pad_861_license.py`：读取指定本地文件，核对产品/构建/字段、拒绝空凭据及换行注入，确认网关端口未占用；admin_key 仅替换 .env 中单一字段并保留原字节备份，device_key 使用独立私密文件；报告明确厂商授权尚未验证，无网络/登录/发送。它未执行应用，等待文件内容。

补充输入边界测试后最终相关回归为 **31 passed in 1.09s，退出0**，覆盖Pad原有测试、MCP端点限制和本地凭据校验。本轮全量仍未重跑。

## 16:04 授权服务网络对照与结论纠正

此轮网关保持停止。只用curl/公开DNS查询，不携带ADMIN_KEY、设备、账号或群数据，不改防火墙/代理/DNS。

| 对照 | 实际结果 |
|---|---|
| 本机系统DNS（含显式1.1.1.1查询） | 198.18.0.21；不能当作独立公共解析结果 |
| Google DNS-over-HTTPS | Status=0，A=154.211.22.209 |
| Cloudflare DNS-over-HTTPS | Status=0，A=154.211.22.209 |
| 本机默认路径curl HTTPS | 提升后的请求仍报TLS握手失败；首次沙箱连接失败单独不作服务证据 |
| curl --noproxy '*' --resolve 域名:443:154.211.22.209 | 保留证书验证，TLS成功，HEAD / 返回HTTP404、nginx |
| 经现有127.0.0.1:17891代理HEAD同域名 | CONNECT200，随后同样HTTP404 |
| 定向连接POST /api/v1/public/admin-keys/validate，仅空JSON {} | HTTP401，code401，“缺少必要的安全验证字段” |

这证明**授权服务的HTTPS及公开校验路由当前可响应**；根路径404不等于服务停运。该401不是“密钥无效”或“需要付费”，更不是成功取得授权。没有使用默认key或尝试绕过签名；空JSON只验证接口错误契约。

[官方.env.example](https://raw.githubusercontent.com/WeChatPadPro/WeChatPadPro/main/.env.example) 将ADMIN_KEY描述为建议使用复杂随机字符串的管理员密钥；公开资料与本地失败不足以判定用户一定要另购授权。当前正确下一步是：核实网关在正常出网路径下的实际授权响应，再根据明确响应区分网络、授权资格和服务协议问题。

可审阅的下一次试验范围：仅固定861 EXE、空设备库、原本地随机ADMIN_KEY；短时恢复该程序出站（原入站Block保留），子进程使用已经验证的本机代理，最多一次Count=1/Days=1的生成调用；响应/日志只留本地并脱敏；不请求二维码、不登录、不发消息，结束停止网关并恢复原出站规则。恢复出站会允许该闭源网关的启动外连，不能描述为只允许某一个URL。该网络策略变更本轮尚未执行，需明确授权；旧失败意图不得删除或自动重试。

## 用户允许联网后的执行准备与审批阻断

用户已回复“允许”上述联网测试。新增 `scripts/test_pad_861_authorization_network.ps1`，固定EXE摘要、原规则与空闲端口前置核验，子进程使用现有本机代理；单次生成调用在28秒进程等待预算内，finally停止本次进程并恢复出站Block，输出规则/端口/配置哈希清理结果。`prepare_pad_861_device.py --network-trial` 使用独立意图和私密收据，保留原离线失败记录，独占创建意图避免自动重复生成。PowerShell语法解析及Python编译检查通过；不代表实机运行通过。

启动命令被自动审批在创建进程前拒绝，原因：临时解除闭源网关出站阻断可能将本地ADMIN_KEY发送至外部授权服务；审批要求明确授权该凭据向具体目的地外发。未通过其它路径重试或绕过。已请求补充确认目的地 `https://adminkeyservice.knowhub.cloud` 及软件管理凭据外发范围；本次生成未执行。

## 16:11 明确凭据外发授权后的单次实测

用户进一步明确回复“允许”，授权本地ADMIN_KEY提交至上述授权服务。随后同一脚本获准执行，原审批阻断已解除；不是改用其它执行路径绕过。

实际命令：`scripts/test_pad_861_authorization_network.ps1`。原入站Block保持启用；仅在本次网关子进程运行期间停用其出站Block，并为该子进程设置已验证的本机HTTP/HTTPS代理。未修改全局代理、系统DNS、.env或其它容器。

- 前置设备列表通过空列表检查。
- 仅一次 POST /admin/GenAuthKey1，Count=1、Days=1。
- 实际返回 HTTP200、业务Code300、Data=null，错误文本仍为“生成授权码失败: 授权服务暂时不可用，请稍后再试”。没有取得设备key，不视作成功。
- 没有二维码、扫码、模型、消息采样或发送调用。
- 16:11:50 清理记录：elapsed_seconds=14.09；gateway_stopped=true；remaining_listeners=0；inbound_block_enabled=true；outbound_block_restored=true；config_unchanged=true。
- 脚本整体非零退出表示授权生成业务失败，不是清理失败。单次意图已留存；禁止自动重试。

证据文件（均gitignored）：device-network-trial-intent.json、device-network-trial-private.json、device-network-trial-result.json、network-trial-cleanup-result.json；厂商原始日志含管理凭据，仅留本地，不能直接分享。

结论更新：解除该程序出站阻断、提供可用代理后，网关仍返回相同泛化错误；这排除了“只需解除该条阻断就一定成功”的说法。但没有抓取到网关的上游HTTP状态/业务响应，不能证明网关使用了代理、请求了哪个完整路径，也不能判定随机ADMIN_KEY无效、必须付费或授权服务停运。独立curl的TLS和空JSON401只证明服务可响应，不证明此EXE的完整授权协议兼容。

下一项需要的有效证据是该固定构建的授权契约或厂商诊断：确认 GenAuthKey1 的实际服务地址、签名/版本要求、随机本地ADMIN_KEY是否可用、20250822构建是否仍受支持，以及不打印密钥的上游错误读取方式。在得到协议证据前不手工拼签名、不使用公开默认key、不另发生成请求，也不替换成其它版本后冒称本构建通过。未联系厂商或采购。

可发给维护者的脱敏问题（尚未发送）：

> Windows amd64 ios18.61-861 / 20250822_153444，EXE SHA256 5308323f32d4249f325a750b0c0faa91aba5b91f50593c88931d9829ffb203e9。已配置本地ADMIN_KEY，GetAllDevices业务Code200且devices为空；一次GenAuthKey1（Count1/Days1）返回Code300“授权服务暂时不可用”。域名定向TLS及通过本机代理HEAD均能获得HTTP响应，公开admin-keys/validate空JSON返回401“缺少必要的安全验证字段”。请确认此构建当前是否仍支持设备key生成、是否需要另行签发管理员授权、实际授权服务/签名要求，以及如何取得不泄露凭据的上游错误。尚未微信登录，未发送消息。
