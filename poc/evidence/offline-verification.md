# 个微 AI Agent PoC 验证记录

日期：2026-09-14。判定用语仅使用：通过当前限定场景 / 部分通过且有限制 / 未通过 / 未执行。

本记录不是自动回复或生产可用结论。人工确认闭环 ≠ 无人值守。

## 证据分层

| 层级 | 本次是否执行 | 说明 |
|---|---|---|
| 模拟 / 合成 fixture | 是 | `uv run pytest`：29 passed（poc/.venv，CPython 3.12.13） |
| 单机观察（无真实微信） | 是 | 已核验 `status` / `r0-check` / `run --cycles 1` / `review list` / `evidence-list` |
| 真实模型 HTTP | 否 | `model.provider=mock`，无授权凭据 |
| 真实双端（企微+个微） | 否 | 测试账号、数据路径、接收端未配置 |

附件 `C:\Users\Administrator\Downloads\wechat.zip.temp` SHA-256 复核为 `51664D8F5A1D8DDF45D41DB66227280E89CA2C95AEB4DFB862B4CABD72D2E479`，与 spec §12 / archive-audit 一致。未运行附件 `main.py`、`key_extractor.py`、解密或随包数据库。

仓库无 AGENTS.md。未修改外部 Chat-Lab，未提交、未推送、未采购、未启动长期后台进程。

## 离线契约测试（模拟）

| 项目 | 判定 | 证据 |
|---|---|---|
| 多分库合并且不覆盖 | 通过当前限定场景 | `test_two_shards_merge_without_overwrite` |
| 同秒数值 ID 9 然后 10 | 通过当前限定场景 | `test_numeric_id_10_after_9_same_second` |
| 跨表迟到（绑定表仍可读） | 通过当前限定场景 | `test_late_smaller_table_after_start` |
| 启动后新 WAL 被发现 | 通过当前限定场景 | `test_new_wal_after_discovery_is_seen`（SQLite WAL 文件，非微信客户端） |
| 账号命名空间 | 通过当前限定场景 | `test_account_namespace_in_event_key` |
| 重放无新事件 | 通过当前限定场景 | `test_replay_does_not_create_new_event` |
| 首次历史只作基线 | 通过当前限定场景 | 首轮 `is_historical=True`；`test_historical_and_self_do_not_draft` |
| 有界回看 / 超出回看标历史 | 通过当前限定场景 | `test_lookback_accepts_late_row_but_not_beyond_window` |
| 事务：事件与水位同提交 | 通过当前限定场景 | `test_ingest_and_checkpoint_same_transaction` |
| `@openim` 白名单 / 非白名单 | 通过当前限定场景 | `test_openim_whitelist_kept_and_non_whitelist_dropped`（合成字符串，不证明真实外部群结构） |
| 相同正文两条 | 通过当前限定场景 | `test_same_body_two_native_ids` |
| 损坏压缩正文不可发送 | 通过当前限定场景 | `test_corrupt_zstd_is_not_sendable` |
| 不选 storages[0] | 通过当前限定场景 | `test_does_not_select_first_discovered_account` |
| 审批哈希/绑定/过期 | 通过当前限定场景 | `test_review_requires_exact_hash_and_binding`、`test_approval_expires_and_text_change` |
| 未知发送不重试 | 通过当前限定场景 | `test_unknown_send_does_not_retry` |
| 重启 sending→uncertain | 通过当前限定场景 | `test_restart_sending_becomes_uncertain` |
| 群名搜索不足 | 通过当前限定场景 | `test_name_search_only_is_rejected` |
| UI runtime ID 不能派发 | 通过当前限定场景 | `test_ambiguous_runtime_id_cannot_reply` |
| 越权指令不执行 | 通过当前限定场景 | `test_untrusted_instruction_has_no_tool_side_effect` |
| 限制提示注入即停 | 通过当前限定场景 | `test_pause_and_injected_restriction_stop`（模拟注入，未诱发真实风控） |
| R3 十二黄金样本 | 部分通过且有限制 | 12/12 在 **mock 模型** 上符合预置期望；真实模型未调用 |

页面解密模块未实现，故未增加坏页/缺页测试（符合 spec §12）。

## R0–R4

| 阶段 | 判定 | 原因 |
|---|---|---|
| R0 适配与绑定 | 未执行 | 缺 `account.wxid`、`account.data_root`、`wechat_version_recorded`、双端接收人。未打开真实库，未测当前微信版本。文档中的 4.1.13.65 只是 2026-09-12 基线。路线 A 因缺少授权输入而阻塞；路线 B 按 spec **未启动**（须等 A 的 R0 失败记录后才独立验证）。 |
| R1 连续读取 | 未执行 | 无授权测试群与双端各 10 条编号消息 |
| R1 边界（真实 WAL/身份） | 未执行 | 仅有合成复现，不能替代真实 WAL/身份 |
| R2 发送 ACK | 未执行 | 桌面发送器为 stub；mock 本地气泡不能标 verified |
| R3 AI | 部分通过且有限制 | mock 12/12；真实模型草稿与双端核验 **未执行** |
| R4 30 分钟观察 | 未执行 | 未做实机有界观察 |

## 能力 / 权限矩阵（实测栏）

| 能力 | 程序授予范围 | 实测 |
|---|---|---|
| 读取新文字 | 绑定账号+绑定群，sqlite_plain/mock | 合成通过当前限定场景；真实库未执行 |
| 查询上下文 | 同群最多 20 条 | 合成通过当前限定场景 |
| 本人/发送者 | 无依据则 unknown，不派发 | 合成通过当前限定场景 |
| 生成草稿 | mock 或可选 HTTP；无工具 | mock 部分通过且有限制；HTTP 未执行 |
| 审批 | 逐条哈希+绑定版本+5 分钟 | 合成通过当前限定场景 |
| 发送文字 | 仅批准记录中的目标与正文 | mock 发送状态机通过当前限定场景；真发送未执行 |
| 查看发送结果 | 必须双端证据才 verified | 合成通过当前限定场景 |
| 暂停 | 阻断读/模型/发送 | 合成通过当前限定场景 |
| 进程取钥/Hook/注入 | 不授予，无自动 fallback | 未执行（按授权拒绝） |

数据库密钥若将来授权使用：底层材料可能覆盖大于单群的库；程序仍只查询目标群表及 Name2Id 映射。业务状态库 `.local/poc/state.sqlite` 为明文，已在 `status` 输出注明。

## 实机最小待填项

1. 测试个微账号别名与 wxid  
2. 目标企微外部群 conversation_key、显示名、必要成员特征、绑定版本证据  
3. 已授权只读数据根路径；若走 SQLCipher，已授权密钥引用（不要从其他项目搜凭据）  
4. 企微与个微接收核验人  
5. 本机实际微信版本（不要沿用 4.1.13.65）  
6. 若要真实模型：endpoint、模型名、凭据来源（env:VAR）

在上述项提供前，继续使用 `offline` + mock。

## 命令核验（2026-09-14 于 poc/）

已实际运行且入口存在：

- `uv sync --extra dev`
- `uv run pytest` → 29 passed
- `uv run wechat-agent-poc --config config.example.toml status`
- `uv run wechat-agent-poc --config config.example.toml r0-check`
- `uv run wechat-agent-poc --config config.example.toml run --cycles 1 --seconds 5`
- `uv run wechat-agent-poc --config config.example.toml review list`
- `uv run wechat-agent-poc --config config.example.toml evidence-list --days 7`
