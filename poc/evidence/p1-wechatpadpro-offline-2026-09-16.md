# P1 WeChatPadPro 离线观察通道证据

日期：2026-09-16。阶段：P0 契约补齐（未闭合）+ P1 离线实现。未进入 P2/P3。未下载/运行网关，未扫码，未调用真实微信或付费模型，未 commit/push。

仓库：`D:\path\to\ZJ-AI-WXBot`。分支 `main` @ `1fa5061`（`docs: record G2 HTTPS acceptance evidence`）。工作区原先仅有三份未跟踪 v0.6 规格；本轮未改动那三份文件。仓库内没有 `AGENTS.md`。

## 本轮做了什么

独立 Pad 离线观察通道，不接通真实微信：

- `pad-provider-profile/1`：MAX 与 legacy 两份示例，显式 `api_flavor`，能力标 `documented/observed/unknown/unsupported`。未知字段拒绝。`p0_closed` 在缺构建哈希时不能为 true。
- `pad-config/1`：独立 `observation_store_path` / `agent_state_path`，live 默认 false。拒绝旧 `api-config/1`、GeWe 库路径、MAX/legacy 混用。旧 `api-config/1` 仍不接受 `wechatpadpro`。
- `PadIngress`：envelope + `Data.messages` 批次，同一事务入库；跨群/私聊正文不落库；重复幂等、冲突暂停、坏项逐项记录；写库失败不伪 ACK。
- `PadObserver`：只持有只读 transport；不构造模型、发送 client、outbox 或任务。启停/到期/状态可测。
- v1 解码输出 `ApiMessageV1`。`mention_status`/`history_status`/`identity_status` 在证据不足时为 `unknown`。v2 与 schema 漂移隔离。文档夹具标注 `document_fixture` / `not_observed`。
- HMAC 按文档公式计算元数据签名，不覆盖 Data；`metadata_signature_valid` 与 `private_gateway_transport_verified` 分列；仅 HMAC 不能触发业务。官方向量冲突保留，未改算法去迎合页面样例。
- CLI `wechat-agent-pad check|observe|status|stop|verify`。check 默认不联网；`--probe` 返回未执行；status/stop 只读 sqlite；verify/send 不提供真实发送。

未删除 `ApiRuntime.start()` 的 `A1 refuses live start`，未放宽 GeWe `agent_blockers`。

## 真实命令

工作目录：`D:\path\to\ZJ-AI-WXBot\poc`。

```text
.\.venv\Scripts\python.exe -m pytest tests/test_pad_p1.py -q
# 16 passed

.\.venv\Scripts\python.exe -m pytest -q
# 205 passed（本轮完整回归；旧 G2a 记录的 184 passed 不是本轮结果）

.\.venv\Scripts\python.exe -m wechat_agent_poc.pad_cli -h
.\.venv\Scripts\python.exe -m wechat_agent_poc.pad_cli --config config.pad.example.toml check
.\.venv\Scripts\python.exe -m wechat_agent_poc.pad_cli --config config.pad.example.toml check --probe
```

`check` 关键字段：`p0_closed=false`，`live=false`，`network=false`，`model=false`，`send=false`。`--probe.verdict=未执行`。

## P0 仍未闭合

缺少与实际构建匹配的二进制/镜像哈希、文档导出哈希、许可费用、数据路径、本人/在线响应、v2 schema、真实 @ 字段、历史标志、At 编码、Type 枚举、群前缀拆分、内置自动化关闭方法。HMAC 页面测试向量与公式冲突。因此 **P0 未闭合**；离线实现只覆盖已公开的 v1 信封形状和签名公式。

## 明确未做

P2 部署、P3 扫码观察、P4 发送、P5/P6 Agent、下载网关、开放公网、自启动、commit/push。
