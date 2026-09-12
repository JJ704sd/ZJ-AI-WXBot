# 第二轮证据：Chat-Lab 个人微信读取链路

日期：2026-09-12。参考提交：[67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2](https://github.com/JJ704sd/Chat-Lab/tree/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2)。比较基线：[a42137baaed3e05acbf3863a257f43e1cb68e114](https://github.com/JJ704sd/Chat-Lab/tree/a42137baaed3e05acbf3863a257f43e1cb68e114)。

**判断：Chat-Lab 提供了可借鉴的个微本地读取代码，但当前实现还不能直接作为持续群聊机器人的可靠收件器。** 本轮新增合成实验复现了漏读、发现与提取不一致、账号命名空间丢失等限制；没有操作真实微信、读取用户数据库/密钥或向群发消息。

## 1. 已实现的机制及其边界

| 环节 | 固定提交源码证据 | 对本项目的含义 |
|---|---|---|
| 文件发现 | [discovery.py L68-L97](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/sources/discovery.py#L68-L97)：扫描指定根目录下 `xwechat_files/wxid_*/db_storage/message/message_N.db`，建立含账号和分库的 source key | 支持传入数据根目录；默认只是 Documents，不是自动发现任意盘符数据目录。发现成功不等于能够解密/提取。 |
| 运行中密钥定位 | [wechat_nt.py L130-L219](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/sources/wechat_nt.py#L130-L219)、[L221-L314](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/sources/wechat_nt.py#L221-L314)：在 `Weixin.exe` 中尝试配置对象/XOR、盐标记附近内存、口令派生及相邻候选 | 与客户端内部实现、进程访问权限有关；代码存在不能证明当前客户端能够取得密钥。 |
| 捕获备用路径 | [pe_locate.py L117-L164](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/sources/pe_locate.py#L117-L164)、[capture.py L271-L316](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/sources/capture.py#L271-L316)：在本机 DLL 中定位 `set_cipher_key`/`cipher_handle`，通过调试器硬件断点获取候选材料；可选 restart 会终止并重启客户端 | 不能把该路径称为全程无侵入只读；硬件断点需要调试附加和线程上下文操作。原有单测验证伪事件下不写客户端代码及异常时继续/脱离，并非真实客户端稳定性测试。 |
| 密钥验证 | [wechat_nt.py L60-L75](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/sources/wechat_nt.py#L60-L75)、[capture.py L154-L187](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/sources/capture.py#L154-L187)：部分路径先验证 4096 字节首页面 HMAC-SHA512，再实际查询 `sqlite_master`；其他路径通过数据库可读性验证 | 首页面/表结构验证比匹配到一段候选内存更有依据；仍不等于所有消息页和目标混合群可完整读取。`success` 是任一目标 verified，须检查目标 message 库状态，不能只看顶层布尔值。 |
| 本地密钥保管 | [secrets.py L74-L119](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/secrets.py#L74-L119)、[L139-L197](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/secrets.py#L139-L197)：Windows DPAPI 包装密钥负载，临时文件后原子替换，尽量清零 bytearray | 可复用密钥保管方式。DPAPI 保护的是 keyring；[storage.py L13-L32](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/storage.py#L13-L32) 的业务聊天库仍保存明文内容。 |
| 个微 DB/WAL 读取 | [wechat_nt.py L48-L57](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/sources/wechat_nt.py#L48-L57)、[L335-L359](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/sources/wechat_nt.py#L335-L359)：SQLCipher `mode=ro` 与 `query_only=ON` 直接打开正在使用的数据库，消息库和联系人库分别开连接 | 个微未使用企微的解密快照/WAL 合并实现。代码预期由 SQLCipher 连接处理在线读取；没有显式跨表/跨库一致快照、备份或恢复重放流程。该预期未在本轮用真实 SQLCipher/WAL 验证。 |
| 群与成员解析 | [wechat_messages.py L135-L182](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/sources/wechat_messages.py#L135-L182)、[L213-L259](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/sources/wechat_messages.py#L213-L259)：`Msg_<md5>` 配合 name2id 反查会话，real_sender_id 反查成员，硬编码 id=2 为本人 | 不要求正文含 `@`，但未专门实现/证明混合外部群 schema。缺映射时退回 `Msg_*`/`成员N`；实际调用没有传 `resource_conn`。自动回发前必须核对真实群 ID、双方成员和本人判定。 |
| 文本提取 | [wechat_messages.py L12-L26](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/sources/wechat_messages.py#L12-L26)、[L78-L104](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/sources/wechat_messages.py#L78-L104)：尝试 UTF-8、Zstandard、protobuf 字符串，并选最长字符串 | 属于启发式解析；不应宣称图片/语音/引用等均能可靠理解。Zstandard 模块未列入 [pyproject.toml L6-L10](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/pyproject.toml#L6-L10) 依赖，缺模块会原样返回压缩字节。 |

## 2. 新增合成实验：5 项限制复现，1 项映射观察

公开复现脚本：[verification/verify_wechat_read_assumptions.py](../verification/verify_wechat_read_assumptions.py)。它只导入本地参考源码，创建内存 SQLite 与临时合成文件，阻断网络连接、实际进程探测和实际 SQLCipher 打开；账号冲突实验仅把 SQLCipher 打开替换为内存 fixture，保留真实提取函数及存储调用。源码应使用上方固定提交。

```powershell
python verification/verify_wechat_read_assumptions.py --chat-lab .research/Chat-Lab
```

本轮 Python 3.11.2 实际输出 `all_recorded_observations_reproduced=true`、`reader_feasibility_pass=false`。**复现成立说明观察有依据，不表示机器人读取验收通过。**

| 探针 | 实测观察 | 源码解释与影响 |
|---|---|---|
| 同秒先到 local_id=9，再到 local_id=10 | 第二轮新增物理记录 1 条，返回 0 条 | [wechat_messages.py L187-L224](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/sources/wechat_messages.py#L187-L224) 用字符串 `Msg_demo:10 <= Msg_demo:9` 判断已读，导致漏读。 |
| 同秒先导入 Msg_z，再新增 Msg_a 记录 | 第二轮返回 0 条 | 游标跨整库所有 Msg 表统一取最大时间与字符串 ID；同秒较小表名的迟到消息也被跳过。单纯把轮询调快不能解决。 |
| 同时放置合成 message_0.db 与 message_1.db | 发现两库，只有 message_0 有可提取 target | [wechat_nt.py L30-L45](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/sources/wechat_nt.py#L30-L45) 只定位 message_0；[live.py L128-L153](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/sources/live.py#L128-L153) 按路径匹配，其他分库缺 target。目标群若落在其他分库，会直接阻塞。 |
| 发现时没有 WAL，随后仅新建 WAL | 使用原 source 列表观察，产生 0 个事件 | [discovery.py L81-L87](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/sources/discovery.py#L81-L87) 仅保留当时存在的文件；[monitor.py L36-L53](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/sources/monitor.py#L36-L53) 固定 source 列表且只在有变更事件时导入，默认间隔 600 秒。真实客户端是否同步改变其他被监听文件仍待测。 |
| 两个账号传入不同 source_key，包含相同 Msg 表及 local_id | 提取后两者 source 都是 `wechat`，入库仅剩后者 1 条 | [live.py L157-L165](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/sources/live.py#L157-L165) 传入含账号/分库的 source_key，但 [wechat_nt.py L335-L355](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/sources/wechat_nt.py#L335-L355) 没有使用它，实际写死 `source="wechat"`。[models.py L21-L24](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/models.py#L21-L24) 仅以 source 与表名:ID 计算主键。单账号单分库试验可限制触发面；扩展前需要补命名空间。 |
| 在 name2id 中显式提供合成 `@openim` 字符串、sender=9 与 sender=2 | 可还原提供的会话/成员字符串，并得到 inbound/outbound | 证明通用字符串反查没有 `@openim` 后缀过滤；该任意合成字符串不代表真实混合群 ID 格式，也不证明企微成员名称解析、真实本人 ID 或真实发送路由成立。 |

## 3. 原有离线单测与验证边界

经逐项静态检查，选择运行原仓库 **13 项离线单测：13 通过、0 失败、0 跳过**。包含配置对象 XOR 解码 1 项、DPAPI 合成密钥往返 1 项、群成员解析 1 项、现有去重样例 1 项、输出脱敏/不打印密钥 2 项、候选材料转换 1 项、内存缓冲区候选提取/清零 4 项、伪 Win32 调试事件正常与异常清理 2 项。来源：[test_live_sources.py](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/tests/test_live_sources.py)、[test_windows_memory.py](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/tests/test_windows_memory.py)、[test_windows_debug.py](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/tests/test_windows_debug.py)。原有去重样例没有覆盖上述同秒迟到边界。

本地日志位于忽略目录 `.research/round2-wechat-synthetic-run.log`；边界探针 JSON 为 `.research/round2-wechat-read-assumptions.json`，公开脚本可重新生成后者。运行环境未安装 `sqlcipher3`、`zstandard`、`zstd`；未运行实际 SQLCipher 首页面生成/HMAC 验证测试，以及读取已安装 DLL/EXE 的两项定位测试。没有进行真实进程读取、密钥获取、客户端重启、群内收发或模型调用。

证据层级：源码说明实现意图；离线单测验证限定函数行为；合成探针证明边界现象可复现。三者均不能替代真实混合群中双方非 `@` 消息到达、WAL 持续读取、群 ID 稳定、本人回声识别的实际验收。

## 4. 相对旧基线的变化与决策

执行 `git diff --name-only a42137b..HEAD --` 核对 discovery、wechat_nt、wechat_messages、live、monitor、capture、cipher_objects、windows_memory、windows_debug、secrets，输出为空：**上述个微读取主链路未变化**。此次 sources 中较大变化集中在企微业务与 macOS/native AES 适配；`wxsqlite3.py` 的后端 import 调整属于企微解密链路，不能据此宣称个微分库、WAL、增量和混合群支持已改善。

最小验证仍可采用“个人微信客户端本地读取 → 规则/Agent → 独立发送适配器”的工程路径。以 Chat-Lab 作为读取原型时，应先限定一个测试账号和目标群，确认群所在分库、schema 与 key 可用；补齐增量漏读/重新发现等实际触发限制；最后实测发送回原群、双方可见和自身回声去重。当前评估支持继续做可行性验证，尚不支持宣称 Chat-Lab 已提供可托管的群聊机器人。
