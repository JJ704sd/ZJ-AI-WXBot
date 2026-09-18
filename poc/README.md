# Offline personal-WeChat text AI Agent PoC

2026-09-18 最新状态见[综合报告 v1.4](../specs/agent-personal-wechat-mixed-group-feasibility-report-2026-09-16.md)与[pyweixin 迭代](../specs/research-iteration-review-2026-09-18.md)：临时状态下结构锚点与标题匹配已有证据，独立账号／群身份、读取、原生 @ 和发送未验收。下述 9 月 17 日说明及命令为历史入口，不据此启动真实动作。

2026-09-17 状态入口：[综合报告 v1.3](../specs/agent-personal-wechat-mixed-group-feasibility-report-2026-09-16.md)及[重大迭代证据](../specs/research-iteration-review-2026-09-17.md)。本目录已包含 API／861 离线适配和有界 UIA／Hook 诊断资产；下文是早期默认离线 CLI 用法，不代表全部路线现状。历史局部实机记录不等于原群自动回复完成，不应据研究文档直接启动真实动作。

This package is a **human-approved** text loop: read new synthetic events, draft, review one-by-one, send serially, then attach two-client evidence. It is not unattended auto-reply and not production-ready.

Live WeChat database open, process key extraction, debugger attach, and real sends are **not** started by the default commands below.

## Setup

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
