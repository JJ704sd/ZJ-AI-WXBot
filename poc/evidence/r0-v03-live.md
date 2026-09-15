# R0 v0.3 实机运行记录

日期：2026-09-15。适用契约：[spec v0.3](../../specs/personal-wechat-agent-poc-v0.3.md)（与 v0.2 合并；冲突处以 v0.3 为准）。
**run_id：** `r0-20260915-6126326b`
**授权引用：** `spec-v0.3 + operator-prompt-A-2026-09-15`
判定用语：通过当前限定场景 / 部分通过且有限制 / 未通过 / 未执行。

本文只记录脱敏事实。不含密钥值、内存转储、源库副本或聊天正文。

---

## 1. 一句话结论

门槛、只读工具和离线反例已落地；本机已对唯一测试账号执行有界 R0。**G-KEY 未通过**：当前 Weixin 进程未持有测试账号消息库，却持有已排除账号的 `message_0.db`。因此 **未取钥、未开库、未定位群、未绑定本人**。R0 总体 **未通过**。R1—R4 **未执行**。这是进程归属技术阻塞，不是缺少本轮授权。

不要把离线 70 项测试写成实机 R0 通过。

---

## 2. 代码与配置

| 项 | 值 |
|---|---|
| 仓库 | `D:\path\to\ZJ-AI-WXBot` |
| HEAD | `a9d7415e44b585457d5c5d0a5c47b12974cd32ac` |
| 工作树 | 相对该提交有未提交差异（含本次 v0.3 门槛/工具及既有 W1/W2）。未 commit / push |
| 离线测试 | `poc/` 下 **70 collected，1 skipped（symlink），其余 passed**。与历史 29 / 32 / 45 / 54 **不是**同一次运行 |
| 本地配置 | gitignored `poc/.local/poc/live.toml`：`mode=read_only`，`allow_live_read=true`，`allow_live_discovery=true`，`allow_key_material_from_live_client=true`，`allow_live_send=false` |
| 样例配置 | `config.example.toml` / `config.live.example.toml` 新开关默认 **false** |

---

## 3. 账号与客户端（本 run 复核）

| 项 | 结果 | 判定 |
|---|---|---|
| 唯一测试账号目录 | `wxid_example_account_dir`；解析未越界到排除账号 | 通过当前限定场景 |
| 排除账号 | `wxid_example_excluded_dir`：未开库、未取钥 | 通过当前限定场景 |
| Weixin 文件版本 | `4.1.13.65`（与配置及 2026-09-14 记录一致） | 通过当前限定场景 |
| 进程 | Weixin.exe 在运行，本机枚举到 6 个 PID | 部分通过且有限制 |
| `message_0.db` | 约 250 KiB；WAL 407,912；SHM 32,768；文件头非 `SQLite format 3` | 文件可见，**不等于可读** |
| 元数据文件名 | 同账号可见 `session.db`、`contact.db`（未打开） | 通过当前限定场景 |
| 进程归属 | 测试号消息库 **holder_pid_count=0**；排除号 `message_0.db` **excluded_holder_count=1** | **未通过** |

当前登录客户端更像在使用已排除账号。规范禁止切换账号，因此停止 G-KEY，不附加任一 Weixin 进程。

---

## 4. 阶段判定

| 门槛 / 阶段 | 判定 | 说明 |
|---|---|---|
| 开关与离线反例 | 通过当前限定场景 | G-KEY 不要求已有密钥；G-OPEN/G-DISCOVERY 不要求内部群键；G-INGEST 要求已验证绑定；关闭开关时底层取钥/解密不触发 |
| G-KEY 取钥 | **未通过** | `authorized_account_not_live`；`source` 未产生；无密钥引用值 |
| 取钥方式类别 | 未执行成功 | 设计类别为 `live_client_readonly_memory` + 引用名 `env:WXBOT_R0_DB_KEY`；本 run **未安装该 env、未扫描进程内存** |
| G-OPEN 开库 | 未执行 | 缺密钥材料；未生成解密副本 |
| WAL 一致性 | 未执行 | WAL 存在已记录；未应用、未 checkpoint 源 WAL |
| G-DISCOVERY 群定位 | 未执行 | 候选数未从数据库得出（仍仅有 UI 线索） |
| 本人映射 | 未执行 | 「示例本人」仍只是候选显示名 |
| 元数据基线 | 未执行 | |
| G-INGEST / R1—R4 | 未执行 | `allow_live_send=false`；无外部模型调用；无发送 |
| 临时文件清理 | 通过当前限定场景 | 本 run `decrypted_db_leftovers=[]`；未创建解密副本 |

---

## 5. 附件审阅（未运行聚合入口）

审阅了 `wechat.zip.temp` 中 `wx_csv/key_extractor.py`、`db_decrypt.py`、`main.py`、`chat_exporter.py`：无网络；`main.py` 选第一个账号并全量导出，**未运行**。已移植为项目内受控函数：只读 `OpenProcess`、全页 HMAC 校验、盐值仅匹配授权账号文件。本 run 因归属失败 **没有调用扫描器**。

---

## 6. 下一任最小下一步

授权已经存在：单测试号、单目标群、只读、允许操作模型自取钥/开库/定位（业务群聊模型仍无此权）。

仍未完成的技术能力：在 **测试号已登录且其 `message_0.db` 被 Weixin 持有、排除号库不被同一进程持有** 之前，不能合法取钥。不要为取钥切换到排除账号，也不要扫描全部 Weixin PID。

操作人若把个微客户端切到 `wxid_example_account_dir` 并保持登录，下一任用提示词 B 接续，生成新 `run_id`，不要复用本次失效的进程归属证据。
