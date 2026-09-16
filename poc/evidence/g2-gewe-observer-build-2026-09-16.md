# G2a GeWe 观察器服务构建证据（2026-09-16）

环境：Windows，Python 3.12 venv（`poc/.venv`），starlette 0.49.3，uvicorn 0.39.0。未调用真实 GeWe / M3，未修改系统信任库，未安装自启动。

## 本轮结果

| 范围 | 结果 |
|---|---|
| 相关 | `test_observer_service.py` + G1/GeWe/A1/config：**57 passed** |
| 全量回归 | **184 passed** |

不以旧 177 passed 代替本轮数字。`agent_blockers` 仍包含混合群原生 @ 接收与历史标志缺口。

## 已实现（G2a）

- 无 `--serve` 的 `api-observe start` 只校验，状态 `prepared`，不创建活动采样许可。
- `--serve --deployment-config` 走 `ObserverService`：进程锁、loopback 端口、失败回滚、心跳、单调时钟到期、跨进程 `request_stop`。
- 观察库 `PRAGMA user_version=2`，打开 v1 库时备份 `*.sqlite.v1.bak` 后 ALTER；不触碰 Agent 库。
- ASGI 先校验路径 secret 再读正文；Caddy 模板不注入 bridge token；`callback_bearer` 不升级 `vendor_verified`。
- `callbackTest:true` 仅合成夹具，不作厂商握手。

实际命令：

```text
wechat-agent-api --observer-config <observer-config/1> api-observe start
wechat-agent-api --observer-config <path> api-observe start --serve --deployment-config <observer-deploy/1>
wechat-agent-api --observer-config <path> api-status
wechat-agent-api --observer-config <path> api-stop
```

## G2b 未执行

本机 `Get-Command caddy` 为空。`poc/scripts/test_gewe_observer_tls.ps1` 退出码 2，输出 `G2b_SKIPPED: Caddy is not on PATH; HTTPS reverse-proxy chain was not executed.`

因此：Caddyfile 与启动脚本已交付，**不得把 loopback ASGI 测试写成 HTTPS 链路验收**。本地 TLS 合成时延/证书校验无数据。

## G2c / G3 最小外部条件

G2c：指定 Windows 主机、可安装 Caddy、测试或正式证书（不改系统 Root）、外部主机名；仍不绑定 GeWe 回调。
G3：厂商确认的 `https://` API 根、回调路径 secret 支持、操作人扫码、账号/群映射、30 分钟只读授权。完成后也不自动解除 `agent_blockers`。
