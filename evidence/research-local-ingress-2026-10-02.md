# 本地数据库接入与语义契约核验

时点说明：本记录保留旧基线 `626b123` 的审查及实验；后续 `edeb7a4` 已更新入站分页、查询与审计，当前结论以 [本地续审](research-current-state-audit.md) 为准。下文旧源码行号及测试结果不改写为新版本成绩。

日期：2026-10-02（北京时间）。源码基线：`626b123226f1c974b48a6dceaa1373fe81b724c4`。本记录补充同日调研报告，只覆盖仓库源码、已有测试定义和临时合成 SQLite 数据；没有读取运行目录、真实聊天、密钥或登录状态，没有启动服务、注入客户端、联网或发送消息。未修改产品代码。

## 1. 应当保留的实现基础

| 当前代码与证据 | 可复用的能力 | 不应作出的推论 |
| --- | --- | --- |
| `WeBridge/web_mvp/database_snapshot.py:53–83,116–140,270–296` | 明确单账号目录，限定业务库与显式附件索引；复制前后文件清单与摘要复核；只在私有副本应用 WAL、校验 SQLite 并生成 manifest | 不是客户端 Hook 接收器，也不是逐条消息事件日志；完整复制一组数据库不等于只抓取勾选的群 |
| `WeBridge/web_mvp/database_wal.py:26–89` | 只应用连续有效前缀中最后已提交边界之前的页；拒绝不完整帧和校验错误；遇旧世代尾部停止 | WAL 提交边界不是群任务完整性判断，也不能据此宣称重连期间消息已补齐 |
| `WeBridge/web_mvp/database_service.py:108–121,148–217` | 变更检查、后台构建、校验后替换、失败保留旧副本；最多保留当前和上一代受管副本 | 5 秒是文件检查节流值，不是端到端接收 SLA；构建、轮询与重试都会增加延迟；两代快照不是持久事件保留策略 |
| `WeBridge/web_mvp/database_adapter.py:138–158,183–242,337–382,543–577` | 明确只读，`immutable` 查询，账号命名空间校验，单次读取和重配由锁保护，发现副本变更拒绝混读 | 不可通过修改 `read_only=False` 把数据库入口转换为 Bot 接收／发送循环 |
| `WeBridge/web_mvp/backend.py:273–301,304–337` | 账号变化清理旧选择；读取会话白名单按 account 保存；已有 connection/group generation 防过期查询覆盖新状态 | `engine.account` 在数据库模式下是来源命名空间，不是已经独立核验的客户端登录账号 |
| `WeBridge/web_mvp/server.py:219–232,277–293,330–337` | UI 读取显式勾选会话，跨读取复核 revision；Hook 草稿确认冻结来源和目标；取消读取暂停现有自动规则和计划 | UI 勾选、发送批准、语义分析授权是不同权限；现有 UI 检查不能自动保护将来新增的异步 Agent 结果 |

`DatabaseService` 的 source ID 由 `casefold(sourceRoot) + NUL + selfId` 计算，同来源刷新更换 `revision`，保持 source ID；改路径或 selfId 会改变 source ID（`database_service.py:161–166`）。Adapter 返回 `identityVerified=False`（`database_adapter.py:230–234`）。因此新增契约应同时保留稳定来源命名空间、已核验的账号绑定、快照世代与订阅世代，不能把一个字符串同时当账号身份、快照版本和业务需求版本。

目前 Database 模式不会把消息写入通用 Store 消息表：`Engine.sync_group()` 在 `read_only` 时立即返回（`backend.py:310–323`），轮询只为非只读路径调用它（`:371–385`）；数据库 HTTP 直接查询 Adapter（`server.py:224–232`）。已有合成 HTTP 测试明确断言读到消息后 Store 的 `messages` 表仍为空（`test_database_service.py:172–177`）。这意味着下一阶段需要新增事件持久化入口，不能假定 `Store.ingest()` 已经接管数据库模式。

## 2. 展示模型距离语义事件契约仍缺哪些字段

| 字段／行为 | 当前实际返回 | 编排层需要的补充 |
| --- | --- | --- |
| 事件身份 | `sourceId|相对分片路径|表名|localId`，另有 serverId、dbName、timestamp（`database_adapter.py:451–472`） | source namespace、account binding、groupId、shard/table/local ID 的结构化字段；区分 eventTime 和 observedAt；快照 revision 与内容 revision；不要靠拆 UI 字符串维持长期契约 |
| @ 对象 | `_mentions()` 解析完整集合，但消息只输出 mentionSelf/mentionEveryone/mentionStatus（`:460–471,497–527`） | 保留结构化 mentioned IDs 和字段来源；保留 unknown/invalid/self_unknown，不用可见 `@昵称` 伪造真实 @；成员缺失时不得编造身份 |
| 引用 | `quote` 仅 sender 显示名与 text（`rich_content.py:106–112`） | 在可用且可校验时保留被引用 server ID、发送者 ID、会话 ID、原始消息类型和解析状态；保留未解析关联，不能用相同正文直接认定引用同一任务 |
| 撤回 | 当前读取窗口内，找到撤回 server ID 后就地覆盖目标行的展示内容并移除 media/record/quote（`database_adapter.py:488–494`） | 持久化独立撤回事件和 target ID；更新已有任务证据、摘要和待执行动作；目标不在本页时保留待关联事件。UI 替换没有持久撤回传播语义 |
| 历史与实时 | 返回快照中的最近记录；无历史标记、采集序号或激活水位 | Bootstrap、实时新增、补收和恢复重放分别标记；历史数据可供上下文，不能默认触发新的群回复；按观察水位定义自动动作生效边界 |
| 解码与附件 | decodeStatus、typed placeholder；media 主要是展示信息；原始 XML 仅内部 `attachment_message()` 可取（`:452–474,529–541`） | 先传附件索引和状态，按任务需求解码/OCR；missing/pending/unsupported 与 READY 区分。禁止把私密 XML、密钥字段或本机路径打包进模型上下文 |

成员来源也需保留证据级别：Adapter 只解析已知 `chat_room.ext_buffer`，不以历史发言者补造成员；未知结构返回 members_unavailable 或 members_schema_unsupported（`database_adapter.py:384–412`）。这适合复用为「不能确定发言人角色／权限则等待」的语义门槛，不能把显示名当稳定身份。

## 3. 游标、快照切换与延迟任务

当前消息查询对每个分片执行 `ORDER BY create_time DESC, local_id DESC LIMIT N`，汇总后按 `(timestamp, 字符串 id)` 排序再截断（`database_adapter.py:414–440,475–494`）。这既是最近窗口，也不是可复用的全序事件迭代器。同秒 localId 的最终顺序为字符串次序，不能直接拿 UI 列表末行作为数值增量水位。

建议新增独立 `EventReader.read_page(binding, partition, cursor)` 接口，不改变现有浏览返回形态：

1. 分区包含来源命名空间、已授权会话、分片及表；页游标使用数值 `(create_time, local_id)` 或经过适配器验证的等价全序键，返回 pinned snapshot revision、next cursor、has_more、解析警告和缺口状态。游标是来源读取位置，不是 task_id 或 requirement_revision。
2. 不默认假设晚写入记录的 create_time 大于上一水位。先验证目标 schema 的 local ID 与写入规律，再选择稳定单调序列或有界回扫去重；超出可补收范围时明确 gap，不能仅按时间大于 lastTimestamp 查询。
3. 在同一账本事务中落事件及推进游标；事件唯一性同时考虑来源稳定 ID、分片回退坐标和内容变更。server ID 为 0、分片重建、迁移、撤回及更新均要有规则。已有跨分片去重只证明特定同内容 server 消息的展示去重（`:475–486`），不是完整幂等消费机制。
4. 单页读取／解析后尽快释放服务与 Adapter 锁；模型调用、OCR、业务等待均放在锁外。异步结果提交前再次检查账号绑定、订阅世代、任务需求版本和人工暂停状态。
5. 目前快照自动清理只留两代（`database_service.py:175–184,219–223`）。新增 Reader 若跨多页读取，需要世代 pin/lease 或失败后重试与去重，避免旧副本在消费完成前被删除；不要把整个长任务放在 `DatabaseService.lock` 内阻止刷新。
6. 取消订阅与账号切换应使相关输入分区和待发动作失效；已经持久化的历史保留、删除或仅禁止后续检索应成为显式数据策略。禁止从 Adapter 可列出的所有群自动扩展到模型分析范围。

另一个接入范围差异必须在报告中说清：快照构建按单账号业务数据库名单复制，未按 watched groups 筛选；watched groups 是浏览／使用范围。若未来要求「只采集指定群」，必须新增接入侧过滤或受限提取，不能用现有 UI 勾选宣称物理副本也只包含这些群（`database_snapshot.py:53–83` 与 `server.py:223–226`）。

## 4. 附件策略的具体限制

`attachment_message()` 再次调用 `_messages()`，没有传入 limit，因此固定落在默认最近 200 条内（`database_adapter.py:536`）；UI 的 `limit=2000` 不会同步扩大附件查找。长期等待任务尤其容易遇到「正文仍可回看，旧附件查找失败」。新事件存储需保留可稳定解析的附件引用，附件接口应按受限消息主键定点读取，再检查撤回与当前授权。

附件索引复制由 includeMedia 显式开启；附件字节仍按需从本机账号目录解析，独立明文副本没有这个目录绑定时返回 unavailable（`windows_media.py:154–201`）。解析检查文件是否变化、类型、大小及可用 MD5；视频封面标记 previewOnly。缓存读取复核会话订阅和消息指纹（`:209–246`），不是任意快照 revision 变化就失效：现有测试特意允许同消息内容跨 revision 复用（`test_windows_media.py:151–156`）。

因此语义阶段应使用结构化附件状态和内容摘要缓存：先判断该任务是否真的需要图片/PDF/语音，再取附件、校验和提取；取不到时 WAIT/CLARIFY，不能凭「图片」占位符判断业务信息完整。当前语音输出仍为未解码占位符（`rich_content.py:114–115`），本轮未证明语音语义理解能力。

## 5. 本轮新增的四项临时合成核验

执行环境为 `D:\python3.11\python.exe`，工作目录 `WeBridge/web_mvp`，以 `python -B -` 执行；临时目录仅写入虚构 SQLite 记录，完成后自动清理。复用 `test_database_adapter.create_metadata/create_shard` 创建数据。没有重跑上一轮五项边界测试或全量测试。

| 合成输入／操作 | 实际结果 | 证据含义 |
| --- | --- | --- |
| 引用 XML 显式包含 svrid=991、fromusr、chatusr、displayname、content，调用 parse_content(type=49) | quote 仅 `sender,text` 两个 key | 当前展示解析会丢弃这些关联身份字段 |
| atuserlist 同时含合成本人与合成同行，selfId 已设置 | mentionSelf=true、mentionStatus=structured；没有 mentionIds/mentionedIds/atuserlist | 真 @ 可判本人，但无法从当前输出恢复完整被 @ 集合 |
| 201 条合成消息按秒递增，以 limit=2000 读取，再按最旧 id 调用 attachment_message | 可见 201 条；localId=1 的定点附件消息查询抛 ValueError | 扩大正文浏览窗口未解决旧消息附件寻址 |
| 12 条同秒消息，localId=1..12 | 最终顺序 `[1,10,11,12,2,3,4,5,6,7,8,9]` | 最终按字符串 identity 重排，不是数值 local ID 次序 |

四项断言均成功，进程退出码为 0。这里的「成功」仅指按预期复现实现限制，不是待建语义契约、完整接收或真实群业务验收通过。

## 6. 已有测试定义和后续最小验收

以下仅在本轮阅读了测试定义，未宣称本轮执行通过：

- `test_database_adapter.py:155–216`：多分片 local ID、未知 self、可见 @ 不冒充真 @、坏 @ 元数据、同 server ID 内容去重和当前窗口撤回。
- `test_database_adapter.py:253–285,294–315,339–372`：只读、旧来源保留、拒绝 namespace 不匹配、分片增删与读取／重配并发隔离。
- `test_database_service.py:54–123,149–177`：同来源刷新保持 account、生成世代变化、失败保留旧副本、自动文件变更检测、UI watched 过滤且 Store 不落消息。
- `test_database_snapshot.py:57–150,162–291`：源文件保留、稳定复制重试、未提交／不完整／旧世代 WAL 尾部和校验字节序。
- `test_windows_media.py:54–156`：附件校验、封面区分、路径与账号限制、显式索引、订阅撤销和消息指纹校验。

新增事件契约后，最小测试集应至少覆盖：跨分片同秒分页及崩溃重放；页读取中切账号／改订阅；新分片和晚写入旧时间消息；快照世代被清理或轮换时恢复；引用目标不在当前页；多方真 @ 与损坏元数据；撤回历史事件已进入任务摘要后使旧结果失效；旧附件定点读取且撤回／取消订阅后拒绝访问；复制一成功但提交游标前崩溃。所有测试应先做离线合成，再以经授权的真实目标群检验字段契约；真实数据不属于本轮研究成果。
