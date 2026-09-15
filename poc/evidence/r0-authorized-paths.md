# R0 授权路径探测（用户指定账号目录）

日期：2026-09-15。操作人先给出两个账号目录，随后指定 **唯一测试账号**。路径与文件头探测 **未打开 SQLite、未查询消息表、未取钥、未发送。**

## 唯一测试账号（已指定）

| 项 | 值 |
|---|---|
| 操作人指定 | `wxid_example_account_dir` |
| 授权数据根 | `C:\Users\Example\Documents\xwechat_files` |
| 账号目录 | `C:\Users\Example\Documents\xwechat_files\wxid_example_account_dir` |
| 本轮范围 | **仅此一个账号** |

同机另一目录 `wxid_example_excluded_dir` **不在 PoC 范围**：不读取、不绑定、不用于发现目标群。程序不得因为同根下还有其他 `wxid_*` 而改选账号。

## 测试账号再探测（2026-09-15 11:12 左右，仍未开库）

| 文件 | 大小 | WAL / SHM | 文件头是否 SQLite 明文 |
|---|---:|---|---|
| `db_storage\message\message_0.db` | 172,032 | WAL 407,912；SHM 32,768 | 否（前 16 字节 `7D 5B C6 16 …`） |
| `message_fts.db` / `message_resource.db` | 存在 | — | 排除，不当消息分库 |

当前只看到一个 `message_N.db` 分库（`message_0`）。这不是“目标群一定在该分库”的证明。WAL/SHM 存在，客户端很可能正在使用这些文件。不得为读取方便 checkpoint 或删除 WAL。

## 先前两个目录对照（未再选用大库）

| 别名 | wxid 目录名 | 本轮角色 |
|---|---|---|
| account-A | `wxid_example_excluded_dir` | 排除 |
| account-B | `wxid_example_account_dir` | **唯一测试账号** |

两库文件头均不是 `SQLite format 3`。不能用 `sqlite_plain` 当实机读取器。

## 判定

| 检查 | 判定 |
|---|---|
| 操作人指定目录存在 | 通过当前限定场景 |
| 单测试账号绑定 | 通过当前限定场景（仅目录名；尚未验证消息表内自身份） |
| 消息分库文件可见（未开库） | 通过当前限定场景 |
| 明文 SQLite 可开 | 未通过 |
| 目标群定位 | 部分通过且有限制（仅 UI 显示名与成员；见 r0-group-clues.md；无 conversation_key） |
| SQLCipher / 授权密钥 | 未执行 |
| 消息表可读 / R0 开库 | 未执行 |
| `allow_live_read` | 仍为 false |

G-READ 仍未放行。指定 wxid 不等于允许开库。

## 仍缺（G-READ）

1. 目标群 UI 线索已记录（`示例混合群`）；内部 `conversation_key` 仍空（禁止用群名猜测，禁止全会话正文遍历）
2. 自身份：`self_sender_key`（`示例本人` 仅为显示名，不能直接当消息表发送者标识）
3. `authorized_key_ref`（仅 `env:VAR`）；禁止进程取钥
4. 显式 `allow_live_read = true` 且模式 `read_only` 之后，才允许对该 **一个** 账号做 SQLCipher 只读实验
5. `wechat_version_recorded`（实机实验记录）
