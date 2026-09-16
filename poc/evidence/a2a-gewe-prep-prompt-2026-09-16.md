# A2a 准备清单与操作提示词（GeWe 只读观察器）

日期：2026-09-16。对应产品：**GeWe API v2**。
代码入口：独立观察器 `poc/wechat_agent_poc/gewe_observer.py`，配置 `observer-config/1`，CLI `wechat-agent-api --observer-config <path> api-observe`。
**不要**用 `ApiRuntime.start/tick` 或旧 `api-config/1` 的 `api-observe` 启动采样。旧命令在无 `--observer-config` 时仍返回「未执行」。

当前状态：G2a 本地服务构建完成；G2b 本地 HTTPS→Caddy→Uvicorn→SQLite 合成链路已验收（Caddy v2.11.4 便携版，见 `g2-gewe-observer-build-2026-09-16.md`）；G2c 主机未指定；G3 只读连通 **未启动**；自动回复 **仍阻断**。

## 实际命令（G2a）

无 `--serve` 只做校验，不建立采样许可：

```text
poc/.venv/Scripts/python.exe -m wechat_agent_poc.api_cli --observer-config .local/config.observer.toml api-observe start
```

合成监听（需 `observer-deploy/1`，不调用真实 GeWe）：

```text
poc/.venv/Scripts/python.exe -m wechat_agent_poc.api_cli --observer-config .local/config.observer.toml api-observe start --serve --deployment-config .local/config.observer.deploy.toml
poc/.venv/Scripts/python.exe -m wechat_agent_poc.api_cli --observer-config .local/config.observer.toml api-status
poc/.venv/Scripts/python.exe -m wechat_agent_poc.api_cli --observer-config .local/config.observer.toml api-stop
```

前台脚本：`poc/scripts/start_gewe_observer.ps1`（不安装自启动）。Caddy 模板：`poc/deploy/gewe-observer/Caddyfile.example`。反代不得注入 bridge token，不得把 `callback_bearer` 标成 `vendor_verified`。

无 `--observer-config` 的 `api-status`/`api-stop` 仍只操作 Agent 状态库。Agent 侧发送与 A3/A4 仍被 `agent_blockers`（含 @/历史缺口）挡住。

## 认证分层（修订）

- **公网**：`callback_bearer` = 请求者持有路径 secret（`POST /callbacks/gewe/<secret>`）。这只证明凭据持有者，**不是**供应商身份，**不得**标 `vendor_verified`。
- **内部**：公网入口去掉全部 `X-Wechat-Bridge-*` / 来源等级头后，注入独立的内部 bridge token。观察器只校验该 token。
- **禁止**把「反代统一加 `X-Wechat-Bridge-Token`」当作 GeWe 来源证明。
- `vendor_signature` / `vendor_mtls_or_private` 在协议未核验前为 **unsupported**，不能自造签名格式。
- `ingress.mode=none` 仅离线合成测试，禁止公网实机采样。

## 环境变量（不要写入 Git）

```text
WECHAT_GATEWAY_BASE_URL=          # 必须是厂商确认的 https:// 根；禁止直接使用 http://api.geweapi.com
WECHAT_GATEWAY_TOKEN=             # X-GEWE-TOKEN，只给只读客户端，不给公网入口
WECHAT_GATEWAY_APP_ID=            # 设备 appId，不是 observe_epoch
WECHAT_CALLBACK_SECRET=           # >=32 字节，只出现在回调 URL 路径，不进查询参数
WECHAT_CALLBACK_BRIDGE_TOKEN=     # 另一组 >=32 字节内部令牌，不得与 CALLBACK_SECRET 相同
```

复制 `poc/config.observer.example.toml` 到 `.local/config.observer.toml`：`enabled=true`、填账号/群键、`authorization_ref`、`store.path` 指向 `.local/gewe-observe/observe.sqlite`（不得指向 `api-agent/state.sqlite`）。合成监听用 `config.observer.deploy.example.toml`。G3 才改 `allow_network=true` 与 `mode=live_observe`。

## 登录、回调、停机

1. 扫码仍由操作人在 GeWe 控制台完成；本仓库不输出二维码。
2. 回调 URL 形态：`https://<host>/callbacks/gewe/<WECHAT_CALLBACK_SECRET>`。TLS 在入口终止；应用只监听 127.0.0.1。
3. 先确认账号 `getProfile.wxid` 与指定群成员详情，再采样该群正文。mention/history 可保持 unknown。
4. `api-stop` 撤销观察许可；进程重启不自动恢复监听。

## 可复制的 G3 提示词（仅在 G2 完成且用户明确授权后使用）

```text
请按 specs/gewe-a2a-observer-build-plan-2026-09-16.md 执行 G3，使用已实现的 GeweObserver，不要启动 ApiRuntime 或 A3/A4。
先读 poc/evidence/g2-gewe-observe-deploy-2026-09-16.md 与 poc/config.observer.example.toml。未完成主机/TLS/callback secret 时只列出缺口。
我授权最多 30 分钟、指定测试号与唯一混合测试群的只读采样。登录由操作人扫码。来源等级保持 callback_bearer，不得升级 vendor_verified。
凭据仅从环境变量读取。观察样本写入 .local/gewe-observe/observe.sqlite，不得进入 Agent inbox。mention/history 保持 unknown 除非出现结构化字段。
完成后 --observer-config api-stop，证明监听停止且发送/M3 为 0。不进入 G4/A2b，不commit/push。
```
