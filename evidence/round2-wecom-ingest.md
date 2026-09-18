# 第二轮证据：企微本地采集与 WxJava 会话存档

评估日期：2026-09-12。目标限定为个人微信进入「企微与个微混合外部群」，持续接收普通群消息、分析并以该个人微信身份回复的最小 PoC。

审查固定版本：[Chat-Lab `67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2`](https://github.com/JJ704sd/Chat-Lab/tree/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2)。比较基线：`a42137baaed3e05acbf3863a257f43e1cb68e114`。本记录根据源代码静态审查和合成数据离线测试形成；未读取真实聊天、捕获客户端进程、运行服务、调用外部模型或发送消息。仓库文档中的操作提示没有作为执行授权。

## 1. 对本项目的结论

Chat-Lab 的企微侧提供两种可参考的**接收与分析入口**：Windows WXWork 客户端本地数据库快照，以及 WxJava 官方会话存档。它们都不能据此证明「个人微信身份发消息」已经实现。

| 能力 | 现有实现证据 | 对 PoC 的作用 |
| --- | --- | --- |
| 企微客户端取数 | `.db/-wal/-shm` 一致性读取、AES 解密、SQLite 完整性检查、Protobuf 解码、账号隔离与分析入库 | 当测试企微成员已在目标群且本机客户端实际落库时，可作为接收侧备选 |
| 官方会话存档取数 | WxJava 拉取与解密、通讯录补全、持久化 `seq`、统一 JSONL | 当企业已具备存档开通、可见范围与密钥条件时，可作为接收侧备选 |
| 个人微信身份发消息 | 本记录审查的两条企微链路均未实现 | 仍需独立的个微发送适配器与同群验收 |
| 跨企微／个微会话路由 | 本地企微、会话存档分别保留自己的原生 ID；未发现跨客户端 ID 映射实现 | 需要建立并核验映射，不能直接把 `roomid` 或 `R:...` 当成个微发送目标 |

首期若已选择「个微客户端收发」作为主路线，应优先抽取统一消息、证据保留和幂等处理的设计；无需为验证一次混合群收发，先引入第二个企微客户端或整套会话存档服务。

## 2. Windows `wecom-local` 技术链路

### 2.1 快照与 WAL

`capture_consistent_snapshot` 对数据库、WAL、SHM 重复读取，结合文件长度、修改时间和完整字节比较检测并发变化，默认最多 5 次、重试间隔 0.05 秒；返回数据库与 WAL 的 SHA-256。调用方保存快照及 `manifest.json`。见 [wecom_snapshot.py L113–190](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/sources/wecom_snapshot.py#L113-L190) 和 [wecom_pipeline.py L238–267](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/sources/wecom_pipeline.py#L238-L267)。

WAL 合并检查 magic、页大小、salt，并截取至最后一个 commit frame；合并到内存页映像，再处理内存反序列化所需的 journal 标记。解密入口拒绝 `is_consistent=False` 的快照，查询 `sqlite_master` 并执行 `PRAGMA integrity_check`。见 [wxsqlite3.py L99–160](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/sources/wxsqlite3.py#L99-L160) 和 [wecom_decrypter.py L41–159](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/sources/wecom_decrypter.py#L41-L159)。

边界：这是应用实现的重复读取与结构完整性验证。源码未计算 SQLite WAL 的滚动 checksum；四个库也依次读取，不能把结果表述为四库同一时刻的原子快照。SQLite 完整性通过能支持页结构可读，无法单独证明采集没有遗漏或联系人与消息完全同时更新。PoC 应用带编号的双向测试消息核验完整性，保留数据库及 WAL 指纹以便追查。

### 2.2 AES 与 Protobuf

企微路径使用 16 字节原始密钥、4096 字节页、逐页派生 AES 密钥及 IV，先验证第一页再解密数据库；同时兼容已解密 SQLite。它是特定格式的本地解析实现。见 [wxsqlite3.py L9–96](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/sources/wxsqlite3.py#L9-L96)。

`parse_wecom_content` 从 Protobuf 提取文字，保留 `parsed`、`unknown_format`、`unexpanded_forward` 等解析状态；区分合并转发和通话记录。递归转发保留父链与原始身份，能为 AI 提供可追溯上下文。见 [wecom_protobuf.py L488–538](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/sources/wecom_protobuf.py#L488-L538) 和 [wecom_parser.py L450–508](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/sources/wecom_parser.py#L450-L508)。

PoC 可先只处理解析成功的当前普通文本。历史转发里的原始消息可作上下文，但不能把每条转发子消息都当成刚收到的提问而主动回复。

### 2.3 主体与会话映射

企微本地解析加载 `user_table`、`wechat_contactV1`、企业资料表及 `conversation_table`。用户表用本地 ID 关联，群会话读取 `conversation_id`，群名缺失时可能展示为 `群聊_...`。这解释了它能分析混合群里企微和个微成员的路径，也限定了可见信息来自当前客户端的本地资料。见 [wecom_parser.py L272–356](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/sources/wecom_parser.py#L272-L356) 和 [L416–439](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/sources/wecom_parser.py#L416-L439)。

主体分类优先使用企业 ID 映射、联系人企业名和显示名后缀，正文中提及公司不会被当成发言者企业；冲突则返回 `unknown/identity_conflict`。该分类用于分析，不等价于发送授权或成员身份的安全认证。见 [wecom_subject.py L62–157](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/sources/wecom_subject.py#L62-L157)。

### 2.4 增量与去重的真实语义

| 实现 | 已有作用 | 自动回复接入时的注意点 |
| --- | --- | --- |
| `since_sequence` + `since_message_id` | 用发送时间和消息 ID 字符串作水位，过滤已读数据 | `sequence` 实际为原始发送时间；迟到、补同步的旧时间消息，或相同时间但 ID 小于当前水位的消息会被过滤 |
| 消息 `UNIQUE(account_id, source_database, message_id)` 与 UPSERT | 同账号同来源反复导入不增加重复数据库行；账号间隔离 | 这不是「每条消息只回复一次」；还需按群与机器人身份保存已处理／已发送记录 |
| `upsert_messages()` 的返回计数 | 每处理一条记录计数加一，包含已有记录的 UPDATE | `new_messages` 不能直接用作自动回复触发条件 |
| `conversation_name` 过滤或 `full_replay` | 从头重新读取，可补全历史资料 | 回放模式可能再次返回已有消息；还需明确首次启动的历史截断点 |

依据：[wecom_parser.py L388–411](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/sources/wecom_parser.py#L388-L411)、[wecom_storage.py L152–221](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/sources/wecom_storage.py#L152-L221)、[wecom_pipeline.py L275–303](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/sources/wecom_pipeline.py#L275-L303)。迟到漏读及触发风险为代码路径推论，本轮未在真实客户端复现。

`wecom-local watch` 默认完成一轮采集分析后再等待 **60 秒**，最低等待 5 秒；通用 `chatlog-assistant watch` 默认 600 秒，两者不能混用口径。现成命令适合轮询分析，尚无秒级回复时延的验收证据。见 [wecom_cli.py L57–60](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/sources/wecom_cli.py#L57-L60)、[L215–232](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/sources/wecom_cli.py#L215-L232)、[cli.py L57–60](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/cli.py#L57-L60)。

## 3. WxJava 官方会话存档链路

### 3.1 可复用机制

网关调用 `getChatRecords(seq, limit)` 与 `getChatRecordPlainText`，每轮 `finally` 释放线程本地 SDK。服务从持久化 `seq` 继续，遇到解密失败停止该轮；明文、统一 JSON、媒体任务和游标在同一数据库事务提交，随后导出 JSONL 给 Python。见 [WxJavaAuditGateway.java L19–42](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/collector-wxjava/src/main/java/chatlab/collector/audit/WxJavaAuditGateway.java#L19-L42)、[ChatIngestService.java L112–156](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/collector-wxjava/src/main/java/chatlab/collector/audit/ChatIngestService.java#L112-L156)、[CollectorStore.java L133–154](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/collector-wxjava/src/main/java/chatlab/collector/store/CollectorStore.java#L133-L154)。

该事务边界值得借鉴，但 JSONL 写入发生在数据库提交之后。根据代码推导：若导出失败，游标已推进而 Python inbox 尚未收到这批数据；需要可恢复导出任务或从 SQLite 补导机制，才能作为可靠的持续接收链路。不能把事务游标的可靠性扩大到整个 Java→JSONL→Python 流程。

当前默认 `live=false`、每次拉取 10 条、每轮完成后延迟 45 秒；服务并没有在每个定时任务内持续翻页直至追平。群较活跃时应在 PoC 单独测积压与时延。见 [application.yml L22–28](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/collector-wxjava/src/main/resources/application.yml#L22-L28) 和 [CollectorApplication.java L61–69](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/collector-wxjava/src/main/java/chatlab/collector/CollectorApplication.java#L61-L69)。

### 3.2 接入条件与身份边界

仓库说明列出 JDK 17、固定 WxJava 依赖、官方 Windows 会话存档 SDK、会话存档专用 Secret、RSA 私钥与出口 IP 白名单等条件，并要求核对开启存档的员工范围和同意状态。这里记录的是该项目的部署约定，本轮未登录企业管理后台验证现有企业是否满足条件。见 [collector-wxjava/README.md L15–68](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/collector-wxjava/README.md#L15-L68) 和 [L154–161](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/collector-wxjava/README.md#L154-L161)。

统一结构保留存档 `roomid` 与 `from`，有群 ID 时直接用作 `conversation_id`，私聊则由参与者排序构造 ID；联系人补全调用内部成员／外部联系人查询。见 [UnifiedMessageMapper.java L38–82](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/collector-wxjava/src/main/java/chatlab/collector/mapping/UnifiedMessageMapper.java#L38-L82) 和 [WxCpLiveContactClient.java L24–42](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/collector-wxjava/src/main/java/chatlab/collector/contact/WxCpLiveContactClient.java#L24-L42)。

这些 ID 属于存档／企微接口的命名空间。读取到群消息没有提供个人微信发送身份，也没有把存档 `roomid` 转换为个微群 ID。对接「企微读、个微发」至少需：

1. 同一目标混合群同时包含采集企微成员和发信个人微信账号，且两侧都能看到编号测试消息。
2. 人工确认并保存源账号、源群 ID、目标个微账号、目标群 ID／UI 会话绑定和校验依据；群名相同不能作为唯一映射依据。
3. 将机器人在源侧出现的发送者 ID 与目标个微账号对应，以排除自身发言；外部成员 ID、昵称和企业名缺失时保留未知状态。
4. 以双侧消息证据核验发送到了原群、双方可见，并验证重启重放不重复发送。若做成员 `@`，还需另行验证目标客户端可用的成员定位。

## 4. 相比旧版本的变化与 Windows 影响

`git diff a42137b..67bb1f1` 显示，本次涉及收集入口的变化主要是 Mac 目录发现、AES 平台分发，以及 `watch` 对永久阻断的退出处理。`wecom_snapshot.py`、`wecom_decrypter.py`、`wecom_parser.py`、`wecom_protobuf.py`、`wecom_subject.py` 和整个 `collector-wxjava` 与旧基线没有差异。因此，最新版增加了展示、业务流程和平台边界的证据，没有为这两条收集链路新增个人微信发送能力。

Mac 发现 `Profiles/<32位目录>/Messages1/Info.db`，返回 `capture_ready=False`；实际 capture 在创建分析库、快照或 KeyRing 前返回 `macos_capture_not_ready`。新 `crypto_native` 在 Windows 上继续调用 `crypto_win`，Mac 上接 CommonCrypto；发现目录与 AES 合成测试通过仍不能证明 Mac 原消息库密钥、表结构或真实采集可用。见 [wecom_macos.py L11–44](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/sources/wecom_macos.py#L11-L44)、[wecom_pipeline.py L203–223](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/sources/wecom_pipeline.py#L203-L223)、[crypto_native.py L23–32](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/sources/crypto_native.py#L23-L32)。

Windows 原默认根目录仍为示例用户目录，数据输出默认使用示例目录。本项目在其他用户与目录下复用时必须显式传入实际源目录和本项目输出目录，不能照搬这些默认值。见 [wecom_paths.py L8–13](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/sources/wecom_paths.py#L8-L13)。

## 5. 本轮离线验证

环境：Windows，Python 3.11。测试已先审查副作用，选用合成 SQLite、固定测试向量和模拟采集结果；临时目录全部重定向到项目 `.research/round2-wecom-temp`，未安装依赖或运行 Java 服务。

第一次按 `tests.test_*` 加载遇到 7 个 `ModuleNotFoundError`，未进入测试函数；将仓库 `tests` 和 `src` 同时加入 `PYTHONPATH` 后按模块名重试。最终 **11 个测试通过，0.649 秒**：

| 测试范围 | 数量 | 证据意义 |
| --- | --- | --- |
| `test_wecom_macos` | 5 | NIST AES-CBC 已知答案；合成多页 SQLite 解密与错钥拒绝；Mac／Windows 目录发现；Mac capture 提前阻断；watch 停止重试 |
| `test_live_sources.Wxsqlite3Tests` | 1 | 合成第一页加解密与密钥验证 |
| `test_wecom_local.TestWecomLocal` 两个选定用例 | 2 | 主体分类规则；多账号存储隔离与数据库去重 |
| `test_wecom_local.TestRecursiveEvidence` 三个选定用例 | 3 | 不一致快照拒绝；合并转发与通话区分；递归父链保留 |

复现命令（在固定 Chat-Lab 快照目录运行）：

```powershell
$env:PYTHONPATH=(Join-Path (Get-Location) 'src')+';'+(Join-Path (Get-Location) 'tests')
$env:PYTHONDONTWRITEBYTECODE='1'
$testScratch='.research/round2-wecom-temp'
New-Item -ItemType Directory -Path $testScratch -Force | Out-Null
$env:TEMP=$testScratch
$env:TMP=$testScratch
python -m unittest -v test_wecom_macos test_live_sources.Wxsqlite3Tests test_wecom_local.TestWecomLocal.test_subject_classification_rules test_wecom_local.TestWecomLocal.test_storage_multi_account_isolation_and_deduplication test_wecom_local.TestRecursiveEvidence.test_unstable_snapshot_cannot_be_decrypted_or_imported test_wecom_local.TestRecursiveEvidence.test_raw_forward_envelope_expands_and_call_type40_is_not_forward test_wecom_local.TestRecursiveEvidence.test_recursive_jsonl_retains_containers_identity_and_parent_chain
```

本轮没有对 WAL 并发／损坏、真实混合群完整接收、实际会话存档权限、Java SDK 兼容性、个人微信发送或持续运行时延作实测。测试通过只支持所列离线机制，不能升级为机器人闭环通过。

## 6. 最小复用建议

保留统一消息中的来源、账号、群 ID、原始消息 ID、发送者、原始时间、解析状态和证据引用；复用“同账号同来源消息去重”和身份冲突保留的思路。新建机器人处理／发送状态记录，显式排除自身消息、历史回放和转发子消息触发。若确有必要切换至企微读、个微发，再增加一张人工验证的跨客户端群／机器人身份映射表。

PoC 的决定性新增证据仍是：真实目标混合群里，两种成员的普通非 `@` 消息都被收到，个人微信自动回复原群且双方可见，重放与重启不会重复回复。现有企微解析能力能减少接收和分析侧工作，但不能替代这次验收。
