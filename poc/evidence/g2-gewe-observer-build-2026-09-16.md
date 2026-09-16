# G2 GeWe 观察器服务构建证据（2026-09-16）

环境：Windows，Python 3.12 venv（`poc/.venv`），starlette 0.49.3，uvicorn 0.39.0，cryptography 50.0.1。未调用真实 GeWe / M3，未修改系统信任库，未安装系统服务，未改全局 PATH，未扫码、未发送消息。未修改 `agent_blockers`（混合群原生 @ 接收与历史标志缺口仍在）。

## 本轮结果

| 范围 | 结果 |
|---|---|
| G2b 针对性 | `tests/test_g2b_https.py`：**5 passed**；`poc/scripts/test_gewe_observer_tls.ps1` 退出码 0 |
| 相关 | G2b + `test_observer_service.py` + `test_gewe_observer.py`：全部通过 |
| 全量回归 | **188 passed, 1 skipped**（包含本轮 5 项 HTTPS 测试） |

不以旧 184 / 177 passed 代替本轮数字。loopback ASGI HTTP（G2a）**不算**本轮 HTTPS 验收。

## Caddy 便携版核验

来源：Caddy 官方 GitHub Release [`v2.11.4`](https://github.com/caddyserver/caddy/releases/tag/v2.11.4)（`publishedAt=2026-06-03T06:52:22Z`）。下载 URL：

- `https://github.com/caddyserver/caddy/releases/download/v2.11.4/caddy_2.11.4_checksums.txt`（6769 字节）
- `https://github.com/caddyserver/caddy/releases/download/v2.11.4/caddy_2.11.4_windows_amd64.zip`（17559418 字节）

本地路径：`poc/.local/tools/caddy/`（`.local/` 与 `*.zip` 已在 `.gitignore`，二进制不进 Git）。未安装 Windows 服务。

| 对象 | 算法 | 值 |
|---|---|---|
| zip | 官方 `checksums.txt` SHA-512 | `cd5ccfd86a4b40732cf715890d0dca5bf3f63adefec5a7914de85adf240c60ce7e5d2791631b88ef9758e46b23bb1730e020b9c5d696889740b284ffd4788e35` |
| zip | 本机 SHA-512 | 与上项一致 |
| zip | 本机 SHA-256 | `1708333F79E274C7697285AFE6D592AB39314E0B131E9EC6BEA08AD27DF62EBF` |
| `caddy.exe` | 本机 SHA-256 | `5CB9AB71E5756CE72840B8234177A2F40C8B4AB47A806B8E841E2B784E9DF62B` |
| `caddy version` | — | `v2.11.4 h1:XKxkMTgNSizEvKG6QHue6cAsFOteU2qA61w2tKkCWi0=` |

官方 checksums 只提供 SHA-512；SHA-256 由本机对已通过 SHA-512 核验的 zip 计算。测试证书由 `cryptography` 生成到临时目录，仅测试客户端 `ssl.create_default_context(cafile=...)` 显式信任；`verify_mode=CERT_REQUIRED`，`check_hostname=True`。无 CA 的默认上下文访问失败。未把证书写入系统信任库。

## 已实现（G2a，仍有效）

- 无 `--serve` 的 `api-observe start` 只校验，状态 `prepared`，不创建活动采样许可。
- `--serve --deployment-config` 走 `ObserverService`：进程锁、loopback 端口、失败回滚、心跳、单调时钟到期、跨进程 `request_stop`。
- 观察库 `PRAGMA user_version=2`；不触碰 Agent 库。
- ASGI 先校验路径 secret 再读正文；`callback_bearer` 不升级 `vendor_verified`。
- `callbackTest:true` 仅合成夹具，不作厂商握手。

## 已实现（G2b）

拓扑（实测）：合成 HTTPS 客户端 → Caddy TLS 终止（`127.0.0.1` 非特权端口）→ loopback HTTP → Uvicorn → `PublicIngress.verify` → `GeweObserver` → 独立临时 `observe.sqlite`。

- Caddy 与观察器均只监听 `127.0.0.1`，端口 > 1024；`netstat` 未见 `0.0.0.0` / `[::]`。
- 模板 `poc/deploy/gewe-observer/Caddyfile.example`：`bind 127.0.0.1`、`https://127.0.0.1:18443`、`handle` 互斥反代、`header_up` 删除 bridge/source 头、`lb_retries 0`、日志删除 `request>uri` 与 `request>headers`。
- 测试脚本改为使用本地 `poc/.local/tools/caddy/caddy.exe`，不再依赖全局 PATH，缺二进制时退出 2。
- Caddy 不注入 bridge token，不改来源等级；伪造 `X-Wechat-Source-Level: vendor_verified` 后样本仍为 `callback_bearer`。
- 独立临时观察库、合成事件、测试凭据；`allow_network=false`；无厂商 HTTP。

本地合成回调时延（5 次合法 POST，秒）：`[0.0160, 0.0367, 0.0126, 0.0369, 0.0315]`，均值 **0.0267 s**，P95 **0.0315 s**，全部 < 3 s。该数字不能证明 SaaS 公网时延。

## G2b 实际通过

| 项 | 证据 |
|---|---|
| 合法回调 | HTTPS POST 真 secret → `200` `ok`，SQLite 写入，`source_level=callback_bearer` |
| TLS 校验开启 | 无测试 CA 的默认 SSL 上下文访问失败；测试客户端未跳过验证 |
| 错误 secret | `401` `denied` |
| 伪造内部头 | 带 `X-Wechat-Bridge-Token` / `X-Wechat-Source-Level: vendor_verified` 的合法路径仍入库为 `callback_bearer` |
| 重复事件 | 同一 `newMsgId` 再次 POST 仍 `200`，样本数不增加 |
| 请求限制 | `burst=1` 时第二条合成回调经 HTTPS 返回 `503` |
| 存储失败 | HTTPS→Caddy→观察器；`persist_sample` 抛 `OperationalError` → `503`，样本数 0（观察器在测试进程内，Caddy 为独立进程） |
| 停止竞态 | 双进程：慢正文期间 `api-stop`，事件 `6003` 未入库；进程内：撤销许可后再提交 persist，HTTPS 应答 `503` |
| 到期退出 | `max_seconds=2`，观察器进程自行退出，后端端口释放 |
| 故障日志不泄密 | Caddy/观察器 stdout·stderr·Caddy JSON 日志扫描测试 secret / bridge / API token，未命中 |
| 停止后进程与端口 | `api-stop` 后观察器进程退出，再停 Caddy；`127.0.0.1` 上 HTTPS 与 Uvicorn 端口均不再接受连接 |
| 非回调路径 | HTTPS GET `/` → Caddy `404` |

## G2b 失败项

无。本轮列出的 HTTPS 验收项均实际跑通。

## 未执行项

| 项 | 原因 |
|---|---|
| G2c 指定主机 / 公网 HTTPS | 未指定 Windows 主机、域名或正式证书；`tls_mode=acme` 仍保留拒绝 |
| G3 真实只读采样 | 未注册、未采购、未开放公网、未扫码、未调用真实 GeWe/M3、未发消息 |
| 系统证书信任库 / 系统服务 / 全局 PATH | 按约束明确不做 |
| 把 G2a 直接 ASGI HTTP 算作 HTTPS 验收 | 不计入；G2b 均经 Caddy TLS |
| `max_concurrent_requests` 信号量过载专测 | 本轮 HTTPS 请求限制走的是观察器 token-bucket；ASGI 信号量 503 仍由 G1/G2a 覆盖，未再单独打满 Caddy 并发 |

## G2c / G3 最小外部条件（仍缺）

G2c：指定 Windows 主机、可放置本便携 Caddy、测试或正式证书（不改系统 Root）、外部主机名；仍不绑定 GeWe 回调。
G3：厂商确认的 `https://` API 根、回调路径 secret 支持、操作人扫码、账号/群映射、30 分钟只读授权。完成后也不自动解除 `agent_blockers`。
