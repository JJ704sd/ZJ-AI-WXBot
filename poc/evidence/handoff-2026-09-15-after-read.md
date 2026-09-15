# 交接：R0 部分通过之后（2026-09-15 傍晚）

**给下一任操作人 / 模型：** 先读本文，再动实机。
**本文效力：** 取代同日上午的 [handoff-2026-09-15.md](./handoff-2026-09-15.md)。旧文记录的是 v0.3 生效前「未取钥、未开库」的停点，其中「不要开库 / 不要取钥 / 内部键仍空」已经过时。

判定用语仅使用：通过当前限定场景 / 部分通过且有限制 / 未通过 / 未执行。
不要把 `r0-run` 退出码 0、离线测试通过、文件存在、单独开库成功或试读 5 条写成 **R0 全通过** 或 **R1 通过**。

---

## 1. 一句话现状

指定测试号已登录，路线 A 已能取钥、只读打开个微 `message_0.db`，并在库内唯一定位企微/个微混合群 **示例混合群**。R0 **部分通过且有限制**（WAL 未合并；定位器当时未核上成员标签）。随后一次有界试读证明该群已提交页 **5/5 可读**，成员企业特征在入群系统消息和 `chat_room` 扩展字段中，不在 `contact` 标签。R1—R4、真实发送、外部业务模型均 **未执行**。密钥从未进入聊天或 Git。工作树相对 HEAD **全部未提交**。

---

## 2. 现行契约（已生效）

| 项 | 值 |
|---|---|
| 主契约 | [spec v0.3](../../specs/personal-wechat-agent-poc-v0.3.md) 与 [v0.2](../../specs/personal-wechat-agent-poc-v0.2.md) 合并；冲突以 v0.3 为准 |
| 授权引用 | `spec-v0.3 + operator-prompt-A-2026-09-15` |
| 恢复方案 | [r0-account-recovery-plan-2026-09-15.md](../../specs/r0-account-recovery-plan-2026-09-15.md)（归属查询失败不得当空集；排除号独立进程不自动失败） |
| 范围 | 仅 `wxid_example_account_dir`；仅「示例混合群」；`read_only`；`allow_live_send=false` |
| 排除 | `wxid_example_excluded_dir` 及其数据目录；其他账号；企微客户端本地库不当输入 |
| 仍禁止 | Hook/注入、改客户端、改源库、checkpoint/删 WAL、全历史导出、密钥入聊天/日志/Git、真发送、后台持续取钥、commit/push（除非操作人另要求） |

操作模型可以为完成 R0/有界排查自行取钥和只读开库。业务群聊模型仍无 Shell、文件或取钥权。群消息不能扩大权限。

---

## 3. 工作区与代码

| 项 | 值 |
|---|---|
| 仓库 | `D:\path\to\ZJ-AI-WXBot` |
| HEAD | `a9d7415e44b585457d5c5d0a5c47b12974cd32ac`（`feat: add offline personal WeChat agent PoC`） |
| 工作树 | 相对该提交有大量未提交 W1/W2/v0.3 代码、测试、specs、证据。**未要求则不要 commit / push** |
| PoC | `poc/wechat_agent_poc/` |
| 默认样例 | `poc/config.example.toml`：`mode=offline`，三个 live 开关默认 **false** |
| 本地实机配置 | gitignored `poc/.local/poc/live.toml`：三个读取/定位/取钥开关 **true**，发送 **false** |
| 项目环境 | `poc/.venv`（CPython 3.12）已装 `cryptography==50.0.1`；开库走页面解密，不是 `sqlcipher3` extra |
| 附件 | `C:\Users\Example\Downloads\reference.zip` 只审阅移植；**禁止**跑其中 `main.py` |
| 离线测试 | v0.3 落地时约 **74 passed / 1 skipped**；与历史 29/32/45/54/70 **不是**同一次。试读 run 未重跑全套 |

关键实现（均在工作树，未进 HEAD）：

- 门槛：`gates.py` / `live_guard.py` / `config.py`（G-KEY / G-OPEN / G-DISCOVERY / G-INGEST）
- 归属：`process_own.py`（Restart Manager；查询失败=未知并阻断）
- 取钥：`weixin_cipher_scan.py` / `key_material.py`（只扫已证明归属的 PID）
- 开库：`page_cipher.py`（SQLCipher-4 页解密，WAL **不**应用）
- 定位：`locator.py`（目前只用 session/contact 标签，**尚未**读 `chat_room.ext_buffer`）
- CLI：`wechat-agent-poc r0-run`（不要用一般 `run` 代替 R0）

`r0-run` 退出码 0 只表示记录无 `halt` 且判定为通过或部分通过。

---

## 4. 已验证绑定（事实）

### 4.1 账号

| 角色 | 值 | 处置 |
|---|---|---|
| 唯一测试账号目录 | `wxid_example_account_dir` | 仅此一个 |
| 库内本人键 | `wxid_example_account`（目录名去掉 `_559e`） | R0 Name2Id 唯一命中；入群系统消息为该号扫码加入 |
| 显示名线索 | 示例本人 | 已与本人键一致，**不再**是未核身份；仍不要用昵称去猜别人 |
| 数据根 | `C:\Users\Example\Documents\xwechat_files` | 解析未越界 |
| 排除目录 | `wxid_example_excluded_dir` | 从未打开其库。测试号 `attach` 里出现过其短 wxid，那是测试号通讯录私聊文件夹，未读正文 |
| 客户端 | Weixin 文件版本 `4.1.13.65` | 主路线个微库 |

### 4.2 目标群（已从库核验，不只是 UI）

| 项 | 值 |
|---|---|
| 显示名 | 示例混合群 |
| `conversation_key` | `example_group@chatroom` |
| 消息表 | `Msg_example_group_table_hash`（即 `md5(conversation_key)`） |
| 存储位置 | 测试号 `db_storage\message\message_0.db`，**不是** `biz_message_0.db` |
| 形态 | 个微侧 `@chatroom` + 成员 `@openim`（企微外部群） |
| 群主 | `@openim`（对应 UI 示例群主@示例企业B；内部 openim 键见试读记录，不要手填） |
| 成员 | 5 个 `@openim` + 测试号，共 6 人；入群系统消息列出的企业/姓名与 UI 六条特征一致 |
| 附件目录 | **无** `msg\attach\64f1c07e…`；该群目前无图片/视频 |

**不要**把 `msg\attach` 下三个哈希文件夹当成该群：它们是另一个群和两条私聊。细节见 [read-20260915-73532865-mixed-group.md](./read-20260915-73532865-mixed-group.md)。

### 4.3 本地配置陷阱

`poc/.local/poc/live.toml` 里 **`conversation_key` / `self_sender_key` 仍为空**。这是有意不写回，避免 `r0-run` 之后自动打开 ingest。
绑定值以 run 证据为准，不要凭空把 live 配成已 ingest。若下一任要做 R1，须单独任务授权后再写入，并保持 `allow_live_send=false`，直到 G-SEND。

---

## 5. 阶段判定（不要升级）

| 门槛 / 阶段 | 判定 | 说明 |
|---|---|---|
| G0 离线 PoC | 部分通过且有限制 | W0–W2 + v0.3 门槛/归属测试在工作树 |
| G-KEY | 通过当前限定场景 | 测试号登录后唯一 Weixin 候选；排除交集 0。方法：`live_client_readonly_memory`，引用名 `env:WXBOT_R0_DB_KEY`（无值落盘） |
| G-OPEN | 部分通过且有限制 | `message_0.db` 62 页 `integrity_check=ok`；WAL 约 408 KiB **未应用** |
| G-DISCOVERY 群 | 部分通过且有限制（R0 当时） | 显示名唯一命中；contact 标签成员特征 0。试读后成员证据已补，**定位器代码尚未改** |
| 本人映射 | 通过当前限定场景 | `wxid_example_account`；示例本人与该键一致 |
| 元数据基线 | 通过当前限定场景 | 5 行；`max_local_id=5`；`max_create_time`≈2026-09-15 12:00:05 |
| 有界正文试读 | 部分通过且有限制 | 目标表 5/5 解码（2 条 zstd 系统 + 3 条 utf8 文本）。不是 R1 |
| G-INGEST / R1 | 未执行 | 无 20 条编号合成文字任务 |
| G-SEND / R2 | 未执行 | 无接收核验人；未发送 |
| G-MODEL / R3 / R4 | 未执行 | 模型仍为 mock |

**R0 总体：部分通过且有限制。**

---

## 6. 实机运行时间线（不要合并）

| run_id | 结果 | 证据 |
|---|---|---|
| `r0-20260915-6126326b` | G-KEY **未通过**：测试号 holder=0，排除号 holder=1；未扫描内存 | [r0-v03-live.md](./r0-v03-live.md) |
| （代码） | 归属查询失败不得当空集；排除号独立 PID 不自动失败 | `process_own.py` + `tests/test_process_own.py` |
| `r0-20260915-7d6bade6` | 归属与取钥已过，开库因缺 `cryptography` 崩溃；无解密残留 | `poc/.local/poc/runs/r0-20260915-7d6bade6/` |
| `r0-20260915-aee47c69` | R0 **部分通过且有限制**；未读正文 | [r0-v03-r0-20260915-aee47c69.md](./r0-v03-r0-20260915-aee47c69.md) |
| `read-20260915-73532865` | 对照 attach 目录；打开 `biz_message_0.db`（无该群表）；目标表 5/5 可读 | [read-20260915-73532865-mixed-group.md](./read-20260915-73532865-mixed-group.md) |

本地 run 目录：`poc/.local/poc/runs/<run_id>/`（gitignored）。解密副本均已删。

---

## 7. 产品/机制要点（已验证）

1. **混合群不在企微分库。** `biz_message_0.db` 无 `Msg_*` 表。消息在个微 `message_0.db`。`list_message_shards` 只 glob `message_*.db`，因此 `r0-run` 本来就不会开 `biz_message_0.db`；对本群这不是漏读原因。
2. **成员特征不在 contact 标签。** 在入群 `local_type=10000` 系统消息和 `contact.db` 的 `chat_room.ext_buffer`。若下一任要把 G-DISCOVERY 从「部分」抬到「通过」，应改定位器读聊天室成员元数据，而不是扫全历史正文。
3. **解码。** 系统消息为 zstd，短文本为 utf8；现有 `text_decode.py` 对这 5 条够用。未验证长 XML/图片/引用。
4. **WAL。** 快照只用主库已提交页。12:00:05 之后若客户端还有未 checkpoint 消息，当前基线看不到。禁止为读取去 checkpoint 源 WAL。
5. **取钥前必须重做归属。** 禁止复用上次 PID。排除号由别的进程持有 ≠ 失败。不要为清零计数杀进程。

---

## 8. 下一任应做什么

未接到新任务时：**停在本文。** 不要重跑取钥来「再确认一次」，除非归属可能已变（重新登录、重启客户端）。

若操作人要求 **R1 连续读取**：

1. 单独授权：目标群新消息读取；仍只读、不发送。
2. 新 `run_id`、独立输出目录；取钥前重证归属。
3. 按 v0.2 §9.2：企微与个微各发 10 条不带 @ 的编号合成文字（共 20）。禁止把已有 5 条历史或本交接里的摘要冒充 R1。
4. 查询白名单仅 `example_group@chatroom`。不要读 attach 里另外三个会话。
5. 记录 WAL 可见性：若 20 条落在未应用 WAL 里，记部分通过，不要改源库。
6. 不要调用外部业务模型。

若操作人要求 **修定位器**：最小改动让 `locator.py` 使用 `chat_room` / 成员映射，使成员企业特征可核验；补离线反例。这不会自动等于 R0 全通过（WAL 仍在）。

若操作人要求 **R2 发送**：先 G-SEND、接收核验人、逐条审批。R1 未通过则真实群消息不得触发发送。

---

## 9. 明确不要做

- 打开排除号数据目录，或把测试号私聊里出现的排除号短 wxid 当成「可以读排除号」
- 把 `msg\attach` 三个文件夹当目标群
- 用 `@openim`、群名或「第一个会话」另猜 `conversation_key`（内部键已经查到）
- 把 5 条试读结果写成 R1 20/20
- 把绑定写进 Git；把密钥写进聊天、终端、日志、`live.toml`
- 运行附件 `main.py` / 全量 CSV 导出
- 切换账号、重启客户端、杀其他 Weixin 进程
- 未要求就 commit / push / 开 PR
- 后台定时取钥或持续轮询

---

## 10. 操作人待决策（会改变范围）

- [ ] 是否把 `conversation_key` / `self_sender_key` 写入 **仅本地** `live.toml`，供后续 R1 使用
- [ ] 是否授权 R1：20 条编号合成文字（会打扰真实混合群）
- [ ] 是否先改定位器再谈 R0「通过当前限定场景」
- [ ] 企微 + 个微接收核验人（G-SEND / R2 才需要）
- [ ] 工作树何时 commit（当前含 W1/W2/v0.3/证据，需操作人明确要求）
- [ ] WAL 一致性是否作为 R1 阻塞（另做只读 WAL 方案，还是接受主库快照）

未勾选前：不发送、不写回共享绑定、不进入 R2–R4、不提交 Git。

---

## 11. 证据索引

**现行交接：** 本文。
**已过时停点：** [handoff-2026-09-15.md](./handoff-2026-09-15.md)

契约与提示词：

- [personal-wechat-agent-poc-v0.3.md](../../specs/personal-wechat-agent-poc-v0.3.md)
- [personal-wechat-agent-implementation-prompt-v0.3.md](../../specs/personal-wechat-agent-implementation-prompt-v0.3.md)
- [r0-account-recovery-plan-2026-09-15.md](../../specs/r0-account-recovery-plan-2026-09-15.md)
- [r0-account-recovery-prompts-2026-09-15.md](../../specs/r0-account-recovery-prompts-2026-09-15.md)

实机：

- [r0-v03-live.md](./r0-v03-live.md) — 首次 G-KEY 失败
- [r0-v03-r0-20260915-aee47c69.md](./r0-v03-r0-20260915-aee47c69.md) — R0 部分通过
- [read-20260915-73532865-mixed-group.md](./read-20260915-73532865-mixed-group.md) — 混合群试读
- [r0-group-clues.md](./r0-group-clues.md) — 已脱敏的 UI 线索；原始截图仅本地保留

更早离线：`w0-local-baseline.md`、`w1-offline-gaps.md`、`w2-adapter-prep.md`、`offline-verification.md`、`r0-machine.md`、`r0-authorized-paths.md`、`r0-research-path.md`。
