# Offline personal-WeChat text AI Agent PoC

2026-09-21 当前状态见[报告 v1.13](../specs/agent-personal-wechat-mixed-group-feasibility-report-2026-09-16.md)：局部受控文本收发已有证据；限定编号恢复后可生成本地草稿，但原自动观察中断，真实 @、持续和规模业务未验收。下文旧日期说明是历史阶段，默认离线命令不开放真实操作。


2026-09-20 M3 图像验证：[实测与本地 OCR 对照](evidence/m3-ocr-2026-09-20.md)。2 次明确授权调用、729 tokens；实图两条编号文字 2/2 完整识别，合成图仍有 `Al/AI` 错误。独立入口 `python -m wechat_agent_poc.m3_ocr`，未接入默认读取循环或自动回复。

2026-09-20 编号续测：[两条编号文字 2/2 新增可见](evidence/uia-ocr-numbered-2026-09-20.md)。基线是真实截图后 OCR，发送后是完整实时调用；前后窗口尺寸不同，尚不证明持续监听／去重。`screen_region` 现按实际可见且无遮挡检查，不再无条件要求键盘焦点。41 项相关测试通过；真实 @ 和自动回复仍未验收。

2026-09-20 最新：[真机采集证据](evidence/uia-ocr-live-2026-09-20.md)。UIA 实际 2 节点、语义不可用；屏幕区域＋本地 RapidOCR 已取得真实窗口 6 行文字，其中两条正文文字经画面对照匹配。标题 `AI/Al` 仍不一致，状态 `REVIEW_REQUIRED`，账号／群身份、新消息、真实 @、发送未通过。运行见 [UIA＋OCR 方案](../specs/uia-ocr-hybrid-2026-09-20.md)；快照不进入 Agent 队列，原 UIA reader 与 API／861 保持原契约。

2026-09-18 历史状态见[综合报告 v1.6](../specs/agent-feasibility-v1.6-historical-2026-09-18.md)与[pyweixin 迭代](../specs/research-iteration-review-2026-09-18.md)：临时状态下结构锚点与标题匹配已有证据，独立账号／群身份、读取、原生 @ 和发送未验收。下述 9 月 17 日说明及命令为历史入口，不据此启动真实动作。

2026-09-17 状态入口：[综合报告 v1.3](../specs/agent-personal-wechat-mixed-group-feasibility-report-2026-09-16.md)及[重大迭代证据](../specs/research-iteration-review-2026-09-17.md)。本目录已包含 API／861 离线适配和有界 UIA／Hook 诊断资产；下文是早期默认离线 CLI 用法，不代表全部路线现状。历史局部实机记录不等于原群自动回复完成，不应据研究文档直接启动真实动作。

This package is a **human-approved** text loop: read new synthetic events, draft, review one-by-one, send serially, then attach two-client evidence. It is not unattended auto-reply and not production-ready.

Live WeChat database open, process key extraction, debugger attach, and real sends are **not** started by the default commands below.

## Setup

### 2026-09-20 受控 M3 回复

限定编号测试后续已人工恢复读取并生成一次 M3 本地草稿，未发送；已修复采集间窗口平移导致的中断。存在观察缺口，仍未通过连续自动触发验证。

后续限定编号自动草稿触发器已实现并通过相关离线检查；真机完成两次采集后因窗口隐藏/最小化停止，自动触发未通过，模型及发送次数均为 0。见 [触发验证记录](evidence/controlled-trigger-2026-09-20.md)。

一次 M3 回复已提交，本机目标群气泡可见，操作人已确认“收到”。这是单次受控回复验证，尚未完成原生 @ 自动触发或定时询问。详见 [验证记录](evidence/controlled-send-2026-09-20.md)。该 run 已写入 `submit.lock`，不要重新发送。

From `poc/`:

```powershell
uv sync --extra dev
uv run pytest
uv run wechat-agent-poc --config config.example.toml status
uv run wechat-agent-poc --config config.example.toml r0-check
```

Runtime state is written under `.local/poc/` (gitignored). The business SQLite file is **plaintext**. Do not put source WeChat DBs, keys, or tokens in this directory's logs.

## Modes

`offline` (default), `read_only`, `draft_only`, `manual_send`. There is no `auto_send`.

## Review and send (offline / mock)

```powershell
uv run wechat-agent-poc --config config.example.toml run --cycles 1 --seconds 5
uv run wechat-agent-poc --config config.example.toml review list
uv run wechat-agent-poc --config config.example.toml review show DRAFT_ID
uv run wechat-agent-poc --config config.example.toml review approve DRAFT_ID --text-hash sha256:... --binding-version bv-1 --operator alice
uv run wechat-agent-poc --config config.example.toml send-once APPROVAL_ID
uv run wechat-agent-poc --config config.example.toml verify DRAFT_ID --wecom --wechat --operator alice --note "both clients saw it"
uv run wechat-agent-poc --config config.example.toml pause
uv run wechat-agent-poc --config config.example.toml evidence-list --days 7
```

There is no approve-all. `verify` without both `--wecom` and `--wechat` leaves the task `uncertain` and pauses sending. Local bubbles are not `verified`.

## Live gaps (fill once, then continue offline work)

`r0-check` 会读取本机 Weixin/WXWork **文件版本**、默认数据目录是否存在、进程名是否在运行；**不会**列出 wxid、打开聊天库或读取进程内存。`sqlite_plain` 不能打开真实 `xwechat_files`。Live checklist: `config.live.example.toml`（复制到 `.local/`，不要提交密钥）。Do not copy credentials from other projects. Route B (desktop read+send) is not started until route A R0 is recorded as a database-threshold failure.

## Coverage limit

First start builds a **metadata baseline** only: existing message bodies are not decoded or stored. Messages older than `checkpoint minus lookback_seconds` (default 120) that appear later are a coverage gap and are not ingested. That gap needs a manual rescan.

## Third-party reuse

See `THIRD_PARTY_NOTICES.md`. Attachment parse ideas were reimplemented; Chat-Lab was not copied or modified.
