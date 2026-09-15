# W0 本地现状与证据

日期：2026-09-14。工作包：spec v0.2 §11.1 W0。判定用语仅使用：通过当前限定场景 / 部分通过且有限制 / 未通过 / 未执行。

本文件固定 **HEAD = 固定提交** 与 **工作区未提交差异** 的对照。不把本地 pytest 回填成远端已验证结果，也不覆盖 `a9d7415` 验证文档中的 29 passed。

未打开真实聊天库、未取钥、未真实发送、未调用真实模型、未提交、未推送。

## 代码版本

| 项 | 值 |
|---|---|
| 仓库 | `D:\path\to\ZJ-AI-WXBot`（GitHub `JJ704sd/ZJ-AI-WXBot`） |
| 分支 | `main` tracking `origin/main` |
| 固定代码基线 / HEAD | `a9d7415e44b585457d5c5d0a5c47b12974cd32ac`（2026-09-14 11:43:37 +0800，`feat: add offline personal WeChat agent PoC`） |
| HEAD 之后的提交 | 无 |
| 工作区 | dirty；验收不能只写 commit，须附差异 |
| `poc/uv.lock` SHA-256 | `CFA2865C411B20B2BE29707CA81AEA59307F672B3701638409360FB6EC8678DE` |
| 包版本 | `wechat-agent-poc` 0.1.0；pytest 9.1.1；CPython 3.12.13；uv 0.12.2 |
| 解释器 | `poc/.venv` |

`dirty_diff_hash`（`git status --porcelain=v1` + `git diff HEAD`，UTF-8 SHA-256；未跟踪文件只计入路径名，不含其内容）：`96117758f74679a11afa5345d69830fc038b752c1848493a5c241726a7f635ab`

该哈希在写入本文件、以及把 spec v0.2 复制进 `specs/` **之前** 计算；复制 spec 后 porcelain 已含这两个未跟踪文件。后续若再改工作区，本哈希不再描述最新差异。

## 29 passed 与 32 passed（分开保留）

| 记录 | 计数 | 对应代码 | 来源 | 本版判定 |
|---|---|---|---|---|
| 固定提交验证文档 | **29 passed** | `a9d7415` 树；`poc/tests/` 当时无 `test_probe.py`、`test_r2_acks.py` | [`offline-verification.md` @ a9d7415](https://github.com/JJ704sd/ZJ-AI-WXBot/blob/a9d7415e44b585457d5c5d0a5c47b12974cd32ac/poc/evidence/offline-verification.md) | 通过当前限定场景（合成 / mock，固定快照） |
| 本机 W0 复测 | **32 passed** in 5.57s | `a9d7415` + 下列未提交测试与 CLI 探测改动 | 2026-09-14 于 `D:\path\to\ZJ-AI-WXBot\poc` 执行 `uv run pytest -o addopts= --tb=line` | 通过当前限定场景（合成 / mock，工作区） |

两份记录不是同一次执行。32 = 固定树既有 29 项意图 + 本机新增 3 项（`test_probe.py` 1 + `test_r2_acks.py` 2）。`test_cli.py` 仅追加断言，未增加用例数。

工作区 `poc/evidence/offline-verification.md` 曾把同一表格格子从 29 改成 32；**不以该改写替代固定提交记录**。阶段总表仍见该文件，计数以本表为准。

### 本机 32 项收集清单

`tests/test_archive_regressions.py` 5；`test_cli.py` 2；`test_probe.py` 1；`test_r2_acks.py` 2；`test_r3_golden.py` 2；`test_reader_cursors.py` 6；`test_review_sender.py` 8；`test_runner.py` 4；`test_store.py` 2。

## 未提交差异（对照 a9d7415）

### 已跟踪修改

| 路径 | 作用 | 是否改变 reader/sender 缺口 |
|---|---|---|
| `README.md` | 指向 R0 探测与 mock ACK 现状 | 否 |
| `poc/README.md` | 说明 `r0-check` 不列 wxid、不开库 | 否 |
| `poc/evidence/offline-verification.md` | 本地阶段表；计数见上节 | 否 |
| `poc/tests/test_cli.py` | `r0-check` 输出含 `machine` / `accounts_listed` | 否 |
| `poc/wechat_agent_poc/cli.py` | `r0-check` 调用 `probe_machine()` | 否 |

`poc/wechat_agent_poc/reader.py` 与 `sender.py` 的 git blob 与 `a9d7415` 相同（`fce0bb29…` / `aadf2398…`）。P0 缺口仍在固定代码路径上。

### 未跟踪（W0 核对时）

| 路径 | SHA-256 | 说明 |
|---|---|---|
| `poc/evidence/r0-machine.md` | `6AC4A7E8AE64D229C49D3C4FE895B8566183728794E6ACE9A915D992744A548D` | 本机文件版本探测；不开库 |
| `poc/wechat_agent_poc/probe.py` | `EF5810F83F893E94E2B8FFBA22FBB45F3BAA8D1D94B2721DE85ADFAB9406FF07` | 版本/路径/进程名探测 |
| `poc/tests/test_probe.py` | `9CA3C21FEF41FFE7C60BF90E6A959B4BD0ED9BF2F59F289C868665E8A3F5CF32` | 断言不开聊天库 |
| `poc/tests/test_r2_acks.py` | `F84E4D857FEDB6B7B6F482FB56C3A194D869E221C491420A32D5B92C74DA5863` | mock 三条 ACK + stub 拒发 |
| `specs/personal-wechat-agent-poc-v0.2.md` | `DBCE5E349C090C545ECA264E7E35D3E2AD0EFA83A8DB588893EBCB4257233C27` | 规范原文，43013 字节 |
| `specs/个微AI_Agent接入验证Spec_v0.2.docx` | `8E6292FD9C5794996675863B00EC7E7345029A33AC69B5FD872801A2A5BBF360` | 审阅稿，66324 字节；与 Markdown 同源交付 |

spec 文件从 `C:\Users\Example\Downloads\` 原样复制，源/目标 SHA-256 一致。

## R0 探测（环境，非开库）

来源：未提交的 `r0-machine.md` 与 `probe.py`。用户报告与该文件一致；W0 未重新测量客户端版本，沿用该探测记录。

| 检查 | 判定 | 证据类型 |
|---|---|---|
| Weixin 文件版本 4.1.13.65 | 通过当前限定场景（探测） | `source_kind` 不适用；无消息库访问 |
| 默认 `xwechat_files` 存在 | 通过当前限定场景（路径存在） | 存在 ≠ 可读 |
| 目标库可读 / 群定位 / 身份映射 | 未执行 | 无 wxid、无授权开库 |
| R0 总体 | 部分通过且有限制 | 仅 G0 环境探测部分 |

## R2 mock 三条 ACK

来源：未提交 `poc/tests/test_r2_acks.py`。W0 复测中 2 项通过。

| 用例 | 判定 | 证据分层 |
|---|---|---|
| `test_r2_three_numbered_acks_require_both_receivers` | 通过当前限定场景 | `source_kind=synthetic`，`model_kind=not_called`，`sender_kind=mock`，`receiver_kind=simulated` |
| `test_r2_desktop_stub_does_not_send` | 通过当前限定场景 | stub 抛 `WINDOW_MISMATCH`，草稿记 `failed`；**不是**真实窗口观测 |
| 真实企微 + 个微接收 | 未执行 | `sender_kind=not_called`（真发送），`receiver_kind=none` |

模拟 `verified` 只证明 mock 状态机，不进入真实发送通过数。

## 固定提交中仍存在的 P0 缺口（本地 reader/sender 未改）

| ID | 代码事实 | v0.2 要求 | 当前 |
|---|---|---|---|
| P0-READ | `SqlitePlainReader._fetch_rows` 全表 `SELECT`；首次把已有行转成 `is_historical` 事件入库 | 首次只建元数据基线；增量受限查询 | 未修复 |
| P0-READ | `SqlcipherReader` 在配置了密钥引用后仍拒绝开库 | 真实只读适配未完成；不得只删异常 | 未修复 |
| P0-WINDOW | `send_text` 在未传入 window 时调用 `_default_window(config)` | 真实模式禁止配置生成观测 | 未修复 |
| P0-SEND | `except HaltError` 一律 `failed` + `before_client` | 按实际提交阶段；无法证明未提交则 `uncertain` | 未修复 |
| P0-ONCE | 先查状态再 `set_draft_status(..., "sending")`，无跨进程占用 | 原子占用 `approved`；并发 CLI 互斥 | 未修复 |

## 准入门槛（W0 出口）

| 门槛 | 判定 | 说明 |
|---|---|---|
| G0 离线准备 | 部分通过且有限制 | 固定提交与本地差异已对照；离线 29/32 来源已分开；真实适配器仍为 stub/拒绝开库；`r0-check` 尚未按 G-READ/G-SEND/G-MODEL 分栏 |
| G-READ | 未执行 | 缺授权 wxid、路径、密钥引用与真实读取适配 |
| G-SEND | 未执行 | 缺真实窗口/发送适配与双端接收人 |
| G-MODEL | 未执行 | `model.provider=mock`，无授权凭据 |

spec §11.2 示例路径为 `D:\ZJ-AI-WXBOT\poc`；本机可运行目录是 `D:\path\to\ZJ-AI-WXBot\poc`。未按该错误路径执行命令。

## 本文件之后

W0 完成出口：每份证据已对应 `a9d7415` 或明确的工作区文件哈希；29/32 不合并。下一步是 **W1：修复实机前缺口**，仍保持 `offline`，不打开真实聊天库、不真发送。
