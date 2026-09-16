# GeWe G2：HTTPS 入口与观察器服务构建方案

日期：2026-09-16。状态：设计交付，尚未实现本方案。

## 1. 下一步目标与边界

推荐先完成 G2 本地可部署构建：将 G1 的独立观察器包装成可启动、可停止、可核验的服务，通过本地 HTTPS 合成回调验收，再进入真实主机部署和 G3 只读采样。

G1 的 50 项相关测试、177 项回归是上一轮报告结果，本方案未重跑。G2 完成不代表 GeWe 已接入，更不代表自动回复可启用。原有 `agent_blockers`、真实 @、历史消息与发送结果核验要求继续有效。

本轮仅交付方案。不采购、注册、部署公网、扫码、联系供应商、发送消息、运行模型或 commit/push。

## 2. 推荐拓扑

```text
GeWe SaaS（G3 才接入） / 本地合成回调客户端（G2）
        │ HTTPS POST /callbacks/gewe/<secret>
        ▼
Caddy：TLS 终止、路由限制、请求限制、日志脱敏
        │ 同机 HTTP loopback，保留原始路径与请求正文
        ▼
Uvicorn：127.0.0.1:<固定端口>，单 worker，关闭 reload
        ▼
现有 PublicIngress.verify：校验 callback_bearer
        ▼
进程内 VerifiedIngress → GeweObserver → 独立 ObserveStore

本机 CLI → 服务生命周期控制 / status / stop / 脱敏 export
```

HTTPS 覆盖外部客户端到入口；入口到应用是同机 loopback HTTP。不是“HTTPS 全程”。原 G2 清单中的该措辞在实施时同步修正；跨主机转发需要另行设计 TLS 和双方认证。

| 方案 | 取舍 | 决策 |
|---|---|---|
| Caddy + 现有 Uvicorn，同机部署 | TLS 与业务分离，复用已验证 Python 环境 | 推荐 |
| Uvicorn 直接持有证书 | 组件少，但证书维护与应用进程耦合 | 本轮不选 |
| 临时公网隧道 | 依赖外部入口、URL 与日志策略，不能提供厂商身份认证 | 不作为默认验收路径 |

优先针对受控 Windows 主机交付，复用 G1 环境。主机尚未指定；Linux、容器与 Windows 服务安装不作为第一轮必要范围。先交付前台监督进程和可重复启动脚本，避免系统自启动绕过有界采样授权。

## 3. 必须先补齐的实现点

### 3.1 启动、监听与停止必须对应真实状态

当前 `api_cli.py` 在拒绝 `--serve` 前已调用 `observer.start()`；`status/stop` 返回的 `listening=false` 也不能证明实际套接字状态。新实现应调整为：

1. 先校验配置、运行模式、凭据引用和依赖；失败不创建活动 run。
2. 获取进程级独占锁并预留 loopback 端口；重复实例和端口冲突均明确失败。
3. 真实采样模式才注入 `ReadOnlyGeweClient`，执行已授权的身份探针；合成模式使用桩，禁止厂商网络请求。
4. 建立 run，启动 ASGI lifespan 和监听；确认就绪后记录 `serving`。
5. 任一步骤失败都撤销本次 permit、关闭本次套接字、释放锁并记录失败原因。

建议生命周期：`prepared → probing → serving → stopping → stopped`，失败进入 `failed`。持久化格式若增加字段，显式版本迁移；仅迁移观察库，先检验旧库兼容并备份，不触碰 Agent 库。

无 `--serve` 的 CLI start 改为仅准备/校验，明确 `prepared` 且不建立活动采样许可；这是可见行为变化，需要更新帮助、文档和回归测试。库层现有离线测试接口可保留。

`api-status` 输出 run_id、生命周期、PID、进程创建标识、心跳时间、采样计数、截止时间及停止原因。不输出带 secret 的 URL。心跳失效或无法确认进程归属时返回 `unknown/stale`，不能猜测 `listening=false`。

`api-stop` 先原子撤销采样许可，再通知监督循环关闭监听；返回时区分 `stop_requested` 和 `stopped_confirmed`。不得仅凭 PID 杀进程；进程锁、run_id 和随机 owner nonce 应共同防止 PID 复用及跨运行误停。

### 3.2 加入独立监督循环

新增 `observer_service.py`，封装监听、心跳、截止时间、探针调度和退出清理，CLI 只调用窄接口：`prepare/start/status/stop`。

- 截止时间采用单调时钟；即使没有收到回调，30 分钟上限仍生效。
- 每 500ms 检查停止标记和运行归属；心跳建议每秒写入，超过 5 秒标为 stale。
- 停止后立即禁止新样本提交；监听关闭目标为 5 秒内，进程退出目标为 10 秒内。超时必须如实报告，不能标为成功。
- 探针设置超时且与停止循环分离；不能让慢探针阻塞撤销许可。到达样本上限同样停止。
- 崩溃重启后只标记旧 run 中断；不得自动恢复旧许可、补采或重放。
- status/stop/export 不构造真实 API client，不触发网络请求。

### 3.3 公网认证复用现有 Python 边界

现有 `PublicIngress.verify` 已负责路径 secret 校验。Caddy 只做 TLS 和路由，不注入 bridge token，不改写掉 secret，不创建第二套“认证成功”头。

外来 `X-Wechat-Bridge-*`、来源等级等头在应用边界剥离或明确拒绝，并测试大小写、重复头。只有进程内部生成 `VerifiedIngress`。`callback_bearer` 永远只代表凭据持有者，不升级为 `vendor_verified`。

认证模式未知的厂商签名仍为 unsupported。当前 `callbackTest:true` 仅能作为合成测试夹具；未取得厂商协议前，不得把它当作真实 GeWe 握手格式。

### 3.4 限制请求资源并保证应答语义

当前 ASGI 路径先读正文再鉴权。改为先校验方法、路径、Content-Type 和请求头，再读取有上限的正文；无效 secret 不消费大正文。

- 正文上限、正文读取期限、并发数和队列深度有明确配置及保守默认值；不依赖无限线程池排队。
- 正常目标事件先持久化再返回 `ok`，不能提前成功应答。
- 去重事件可确认；存储失败、拥塞、超时应返回明确非成功响应，不能假报已保存。
- 持久化事务提交前再次检查 permit/epoch，覆盖停止与超时竞态。
- 本地验收目标：正常合成回调 P95 < 1 秒，所有成功应答 < 3 秒；该结果不能证明 SaaS 公网时延。
- 不设代理重试；上游可能自行重试，应用继续依赖事件去重。

## 4. 部署配置与文件交付

保留 `observer-config/1` 的业务含义；部署参数单独使用拟议的 `observer-deploy/1`，避免把“写了配置”当成 TLS 或真实身份已验证。

| 文件（拟新增） | 职责 |
|---|---|
| `poc/wechat_agent_poc/observer_service.py` | 有界服务生命周期与进程归属 |
| `poc/wechat_agent_poc/observer_deploy_config.py` | 部署配置解析、限制与预检 |
| `poc/config.observer.deploy.example.toml` | loopback 端口、外部主机名、TLS 模式、资源限制；不含密钥 |
| `poc/deploy/gewe-observer/Caddyfile.example` | TLS、仅回调路由、默认拒绝与日志策略 |
| `poc/scripts/start_gewe_observer.ps1` | 前台启动及预检，固定工作目录，不安装自启动 |
| `poc/scripts/test_gewe_observer_tls.ps1` | 本地 TLS 合成链路验收，无 GeWe/M3 |
| `poc/tests/test_observer_service.py` | 生命周期、隔离及失败恢复测试 |
| `poc/evidence/g2-gewe-observer-build-2026-09-16.md` | 环境、版本、实测结果、未执行项 |

推荐新增命令形式如下，**目前尚未实现，不能直接视作可运行命令**：

```text
wechat-agent-api --observer-config <path> api-observe start --serve --deployment-config <path>
wechat-agent-api --observer-config <path> api-status
wechat-agent-api --observer-config <path> api-stop
```

配置明确区分 `synthetic` 与 `live_observe`。合成模式必须 `allow_network=false`，使用独立测试数据库和测试凭据；不能仅凭一个部署模式字段解锁实机。

Caddy 模板要求：只代理指定回调 POST；其他路径默认拒绝；原始路径不重写；后端仅 loopback；不公开管理 API；不记录带 secret 的 URL、正文、Token。检查访问日志以外的错误日志、应用异常和 PowerShell transcript，故障时也不得泄露凭据。

本地 TLS 使用测试证书，并由测试客户端显式信任，不修改系统全局信任库。公共部署选择已有有效证书或 ACME；实际域名验证、DNS 修改和公网监听属于部署阶段，不是本地测试的一部分。

凭据继续通过环境变量引用注入，不写入 Git、命令行参数或证据报告。原始样本、SQLite/WAL 与日志目录设置仅运行账号和管理员可访问的 ACL；停止后再复制一致性备份，不能仅复制活动数据库主文件。

## 5. 分段交付与验收

| 阶段 | 可以做什么 | 完成判据 |
|---|---|---|
| G2a 本地构建 | CLI/监督进程/配置/模板/自动测试 | 无活动 run 残留；启动失败回滚；停止状态真实；不调用真实 API |
| G2b 本地 TLS | Caddy → loopback → SQLite 合成链路 | 认证、日志、时延、停止竞态、端口释放均有证据 |
| G2c 指定主机部署 | 已选主机与域名上的 HTTPS 合成检查 | 实际证书与可达性通过；尚未绑定 GeWe 回调 |
| G3 真实只读采样 | 操作人登录后，绑定目标群并有界采样 | 实机证据报告；不启用自动回复或发送 |

G2a/G2b 不需要采购、真实 Token、扫码或公网。G2c 才需要主机、域名和证书安排；G3 另需供应商确认 HTTPS API 根、回调路径支持、账号/群映射与采样授权。

至少覆盖这些测试：

1. 未授权模式、缺配置、端口占用、重复实例、探针失败均不能遗留活动许可。
2. 真 secret、错 secret、伪造内部头、重复头、大正文、慢正文、过载与存储失败。
3. 请求在途时停止、无回调到期、样本上限、进程崩溃、重启、PID 复用与 stale 心跳。
4. status/stop 不联网；写 API 调用数为 0；模型调用数为 0；旧 Agent 库无修改。
5. TLS 验证开启；完整链路故障日志中没有测试 secret/Token；停止后端口不再接收。
6. 先相关测试，再项目完整回归；记录实际数字，不预填上一轮的 177 为本轮结果。

## 6. 后续 Agent 接管顺序

G3 样本只能帮助验证真实 @、历史标志、群与成员键、长整数 ID 和丢失窗口。观察到某种字段不足以自动解除 Agent 阻断，必须更新契约和对应证据。

完成接收核验后，分别进入单次人工授权发送、混合群原生 @ 双端验收，再进入有界被动回复，最后验证一次性定时主动询问。保持既有 v0.5 的额度、超时 unknown 暂停、停止优先和不补发规则。周期任务不在本轮范围。

## 7. 可复制的下一轮实现提示词

```text
在 `D:\path\to\ZJ-AI-WXBot` 中，按
specs/gewe-g2-https-serve-build-plan-2026-09-16.md 完成 G2a 本地构建，
并在已具备本地 Caddy/测试证书工具的情况下完成 G2b 合成验收。

先读适用 AGENTS、G1 实现、G2 清单、当前配置和测试，检查 Git 差异并保留现有工作。
优先解决 --serve 拒绝后遗留活动 run、listening 硬编码、真实只读 client 缺少装配、
无回调时到期、跨进程停止和启动失败回滚。实现独立 observer_service 与部署配置；
复用 PublicIngress.verify，反代不注入 bridge token，不赋予 vendor_verified。

只使用合成数据、测试凭据和独立观察库。禁止真实 GeWe/M3 调用、发送、扫码、
注册、采购、公网部署、系统信任库修改及自启动安装。不 commit/push。
若缺少 Caddy 或证书工具，完成不依赖它们的代码、模板及测试，明确列出 G2b
未执行的具体原因，不将直接 ASGI 测试写成 HTTPS 链路验收。

新增参数和持久化字段显式版本化，说明兼容性。先运行针对性测试，再完整回归。
检查最终差异和日志脱敏，交付实际命令、测试数字、证据报告、未执行项以及
G2c/G3 的最小外部条件。即使 G2b 通过，agent_blockers 也保持不变。
```

## 8. 依据

- 当前仓库 G1 观察器、CLI 和 G2 部署清单：本轮只读核对。
- [Caddy reverse_proxy 官方文档](https://caddyserver.com/docs/caddyfile/directives/reverse_proxy)：反代、请求头处理与重试配置；最终模板需使用实际选定版本执行配置校验。
- [Caddy Automatic HTTPS 官方文档](https://caddyserver.com/docs/automatic-https)：公共与本地证书机制；具体域名和证书尚未选定。
