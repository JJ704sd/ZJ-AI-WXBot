# 后端适配准备 — 测试与差异（2026-09-16）

## 实际差异

- 新增 `geweapi` provider 与 `GeweChannel`；`fake` 仍为离线回归默认。
- 配置增加 `channel.app_id_ref`、`channel.callback_bridge_token_ref`。
- `api-status` / `api-stop` / `api-verify` 改为 status-only 通道，避免初始化真实 Adapter。
- `api-observe` / `api-ack` / `api-mention-test` 仍返回「未执行」，理由为 GeWe 专项缺项。
- `api-check --probe` 在 `geweapi` 下拒绝真实 `checkOnline`/`getProfile`。
- 未新增真实 HTTP 监听进程，未改旧 UIA/DB 路径，未 commit/push。

## 测试结果

项目 `poc/.venv`，无真实网络/微信/M3。

| 范围 | 命令 | 结果 |
|---|---|---|
| 相关 | `pytest tests/test_gewe_channel.py tests/test_api_config.py tests/test_api_a1.py -q` | 36 passed |
| 全量回归 | `pytest -q` | 163 passed |

不以 A1 的 153 passed 代替本轮结果。A2a–A4 **未执行**。

## 未验证项（保持 unknown / 未执行）

- GeWe 试用开通、真实 Token、扫码节点、公网回调
- 混合群 `@openim`、企微成员原生 @ 接收与发送
- 回调签名、历史标志、丢失窗口实测
- `newMsgId` 在真实 JSON 中的精度（OpenAPI 示例为整数，适配器拒绝 float）
- 私有化镜像与报价
- PadLocal Token
- 任何 4.1.13.65 Hook
