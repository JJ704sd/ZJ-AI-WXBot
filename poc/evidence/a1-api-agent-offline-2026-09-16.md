# A1 离线闭环报告（脱敏）

日期：2026-09-16。阶段：A0–A1。实机 A2–A4：**未执行**。未 commit / push。

## 阶段 / run_id / spec与配置版本 / 代码版本及差异

| 项 | 值 |
|---|---|
| 阶段 | A0 候选核验 + A1 本地 API Agent 闭环 |
| 离线 demo run_id | `fd5b0d966e454deeb385847cd8ac56e4`（fake channel，非实机） |
| spec | `specs/personal-wechat-agent-poc-v0.5.md`（poc-v0.5） |
| 配置契约 | `api-config/1`；示例 `poc/config.api.example.toml` |
| 代码基线 | `157eecf` `docs: define v0.5 API agent route`（其上未提交 A1 实现） |
| 工作树 | 新增 `api_*` / `agent_policy` 模块、独立 CLI、离线样例与测试；未改旧 mode 枚举、旧 Store、UIA/SendKeys/取钥路径 |

配置与 CLI：

```text
poc/.venv/Scripts/python.exe -m wechat_agent_poc.api_cli --config poc/config.api.example.toml api-check
poc/.venv/Scripts/python.exe poc/scripts/run_api_a1_offline.py
```

独立入口 `wechat-agent-api`（安装脚本后）。旧 CLI `wechat-agent-poc` 仍只接受旧 `mode` 配置。`api-observe` / `api-ack` / `api-mention-test` 在 A1 固定返回「未执行」。空账号/群/目标不能武装 live。

## 后端机制与准确客户端/SDK/API版本

| 项 | 判定 | 证据 |
|---|---|---|
| 本机 Weixin 文件版本 | **observed** `4.1.13.65` | 安装路径已脱敏；与 2026-09-12 文档基线相同 |
| 本机 WXWork 文件版本 | **observed** `5.0.11.6018` | `C:\Program Files (x86)\WXWork\WXWork.exe` |
| WCFerry 原版 | **documented** 已归档；release `v39.5.2` 配套微信 `3.9.12.51` | GitHub releases 2026-03-28 |
| 与当前 4.1.13.65 兼容 | **unsupported** / 无本机 4.x 证据 | 未安装、未注入、未降级客户端 |
| WCFerry `_send_request` | **documented** 超时隐式重试一次；异常可返回空 `Response()` | `clients/python/wcferry/client.py` `_retry` + `send_text` |
| `get_chatroom_members` | **documented** 先 `SELECT ... FROM Contact` 再读 `ChatRoom.RoomData` | 同文件；不满足「只查目标群最小元数据」 |
| GeWe API / Wechaty PadLocal | **documented / unknown** | 未购买、未部署、未登录；发送文字页原生 @字段仍未知 |
| A1 实际后端 | **fake** `fake/1` | 进程内渠道；写请求每个 `action_id` 一次、无重试 |

provider-profile 模板：`poc/provider-profile.example.json`。文档声明没有自动变成 observed。

## 实现检查、离线验证、实机分别判定

| 面 | 判定 | 说明 |
|---|---|---|
| 实现（模块/契约） | 通过当前限定场景 | `api-config/1`、`wechat-api-event/1`、`api_channel`、`api_store`、`api_runtime`、`agent_policy`、`api_cli`；独立 `.local/api-agent`；旧 UIA/DB 零引用 |
| 离线验证 | 通过当前限定场景 | fake channel + 模型桩 + FrozenClock + 真实临时 SQLite；项目 `.venv` pytest |
| API 通道实机 | 未执行 | 无已核验兼容后端；未扫码、未回调、未发送 |
| Agent 闭环实机 | 未执行 | 未调用真实 M3 / 微信 |
| 接收端证据 | 未执行 | 无企微/个微双端核验 |

## 输入、合格事件、忽略原因、模型调用、发送尝试、accepted、verified、unknown

离线 demo（单条合成仅@问答）：

| 计数 | 值 |
|---:|---|
| 回调受理 | 1 queued |
| 模型请求 | 1（mock） |
| 发送尝试 / accepted | 1 / 1（fake） |
| verified | 0（无接收端） |
| unknown | 0 |

A1 pytest 覆盖的忽略/失败分类：认证失败、字段缺失、跨群、本人、伪@、多对象@、@所有人、身份歧义、历史/基线前/过期/未来时钟、重复、正文冲突（暂停）、模型越权/非 JSON、发送 timeout/5xx/崩溃→unknown 全局暂停、业务拒绝→not_submitted、崩溃窗 submitting→unknown 且 reserved 取消不补发。

## 定时到期/实际提交/接收时刻及偏差

离线 A4 路径：启动后 120s 串行首次 `ask_target`（原生 @字段由 runtime 注入）；错过 10s 宽限则取消、不补发；重启不回放。无实机接收时刻，**时效未验证**。

## 各目标会话的字段完成度、追加次数、关闭原因

离线双会话隔离用例：目标 A 收齐 `receipt`/`willingness` 后 `completed`；目标 B 无关闲聊零插话，会话保持 `awaiting_reply`；停止指令可在模型返回前关闭会话，迟到模型结果不发送。无人回复到期无催促。实机会话：**未执行**。

## 身份/群范围、真实@、去重与额度检查

- 账号/群键仅 fake 合成值；未使用历史 DB 键或昵称作为发送地址。
- 被动触发要求结构化 `mention_keys` 恰为本人且非 @所有人；正文 `@某人` 不回退。
- `event_key` 不含 run_id；同 ID 同正文去重，同 ID 异正文 `event_conflict` 并暂停。
- 额度按 stage 封顶：A3 模型/发送各 10；A4 模型 30（被动≤10、主动≤20），发送 `10+4*N`。并发占用 SQLite `BEGIN IMMEDIATE`；已扣发送额度不回补。SDK/渠道写请求最多一次。

## 未执行项、失败、覆盖限制及具体所需条件

| 缺项 | 最晚确定点 | 不满足则 |
|---|---|---|
| 可用网关及 4.x 或服务型版本组合、费用、数据路径 | 安装/接入前 | 不部署、不购买；保留 fake |
| 回调认证、重放/ACK、混合群字段 | A2a | 不武装 |
| 当前测试号/混合群/企微目标的 API 身份映射 | A2 | 不以昵称或占位符代替 |
| 企微+个微接收核验安排 | A2b | 真实发送不启动 |
| 可验证的企微原生 @ | A4 前 | A3 文字回复可独立；A4 保持未执行 |
| 真实 M3 | A3 | A1 只用 mock |
| 周期任务 | 未来 | `recurring` 解析即拒绝 |

本轮未安装旧版微信、未注入、未登录、未购买、未接入第三方托管。UIA / SendKeys / WAL / 取钥路线未恢复。

## 停机读回结果、剩余 in-flight/unknown、证据位置及清理安排

- 离线 demo 已 `api`/`runtime.stop`；in-flight=0，unknown=0。
- 新状态库路径：`poc/.local/api-agent/`（gitignore）。旧 `.local/poc` 未迁移、未覆盖。
- 证据：本报告、`poc/provider-profile.example.json`、`poc/samples/api_a1_offline_events.json`。
- 清理：`.local/api-agent` 可按 7 天正文 / 30 天墓碑策略列清理项；本次无实机正文。
- pytest：相关 26 项通过后，完整回归 **153 passed**（项目 `.venv`，无真实 M3/微信）。

**结论：离线闭环通过。实机接入、发送、模型与接收核验均为未执行。A2–A4 未启动。**
