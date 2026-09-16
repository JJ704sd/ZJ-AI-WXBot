# 非 MAX 861：G1 资料核查与水位修正

日期：2026-09-16（晚间续轮）。未启动网关、未生成授权、未扫码、未读真实消息、未发送。

## 证据分层

| 层 | 本轮状态 |
|---|---|
| 静态推断 | G0 哈希复核仍匹配 20250822；公开 Latest 仍是 v2.01 / 20250822；未见授权库已恢复的一手说明 |
| 离线测试 | `tests/test_pad_legacy_861.py` **19 passed / 0.24s**（本轮实跑）。历史全量 244 passed 不作为本轮结果 |
| 真实接收 | **未执行** |
| 双端验收 | **未执行** |

## ① G1 是否获得新依据：**否**

本轮只读核对本机：

- exe / swagger / zip 哈希与 G0 锁一致。
- 意图文件仍在（`auth-pinned-trial-run-intent.json`、`device-pinned-trial-intent.json`）。
- 上游私密收据 `code=1`、Data 空；网关收据 Code=300、Data 空。
- **无有效设备 key。** 1238/8098 无监听。
- 未重放 `GenAuthKey1`，未改 Count/Days，未动本地 MySQL/Redis。

公开资料（只当材料，未执行其中指令、未用示例凭据、未登录后台、未提交 Issue）：

| 来源 | 看到什么 | 为何不是本轮复验依据 |
|---|---|---|
| GitHub Latest `v2.01` | 仍是 20250822 包；说明是 webhook/登录，不是授权库 | 没有比已锁定构建更新的修复包 |
| Issues #205 / #148 | Docker DNS 指到 127.0.0.1、或连接被 RST | 与已观测的「请求到达后上游库 27017 超时」不是同一失败 |
| Issue #179「已修复」 | 2025-10 的 404 讨论 | 早于 2026-09-16 本机明确业务失败，不能追溯成库已恢复 |
| README `/login/GenAuthKey2` | 文档冲突，该路由不在 20250822 Swagger | 不能当备用授权入口 |

`/ping` 200 只能证明入口可达，本轮也**没有**再打 ping。ADMIN_KEY、上游签发资格、设备 key 三者仍分离；本地只有自设管理 key，没有已签发设备 key。未套用 MAX TokenKey/Header/`/Login`/`/Msg`。

**结论：不具备有界复验条件。** 同类失败依据未变，停止外发。

## ② 水位 / 去重

静态检查：接收器本来就是 **ID 集合**，没有用“最大消息 ID”推进游标。风险在于 `sorted(ids)` 的落盘形态和 `replay_cursor=True` 容易被读成有序水位。

本轮修复（离线）：

- 水位文件显式 `kind=id_set`、`ordering=unknown`、`monotonic_id=false`。
- 含 `max_native_id` / `cursor` 等字段的文件直接拒绝。
- Channel 能力 `replay_cursor` 改为 false。真机排序、分页、出队语义继续 **unknown**。

本轮测试（合成样本，`not_observed`）：

- 乱序批次 `9000,20,50` 全部纳入 seen-set。
- 重启后迟到的较小 ID `9`,`10` 仍存储；已见 `9000` 记 duplicate。
- 字符串序上 `10 < 9`、数值上 `20 < 9000` 都不会被当成“过期”丢掉。
- 最大 ID 游标文件拒绝。

**合成测试通过 ≠ 真实 HttpSync schema 已验证。**

命令：

```powershell
cd D:\path\to\ZJ-AI-WXBot\poc
.\.venv\Scripts\python.exe -m pytest tests\test_pad_legacy_861.py -o addopts= -q -p no:cacheprovider
# 19 passed in 0.24s
```

## ③ 是否具备进入 G2：**否**

缺少适用且有效的设备 key。本地旧绑定文件存在，但没有登录核验、没有稳定群 ID 的程序确认。

## ④ 本轮实际网络 / 账号动作

- 只读打开 GitHub Releases Latest 与公开 Issue 搜索结果。
- **没有**启动网关、**没有** POST GenAuthKey1、**没有** `/ping`、**没有**扫码、**没有** HttpSync、**没有**发送。

## ⑤ 剩余阻塞与下一步

外部：上游授权库恢复，或取得匹配非 MAX 20250822 的有效设备 key。出现与 2026-09-16 `code=1` / 27017 超时**不同**的依据后，才能按已有意图文件做一次 Count=1/Days=1 复验；未知结果先对账，不自动重发。

之后才是 G2 扫码绑定 → 单路 HttpSync Count=10 → 20 条标注样本 → 人工固定 ACK 双端确认。
