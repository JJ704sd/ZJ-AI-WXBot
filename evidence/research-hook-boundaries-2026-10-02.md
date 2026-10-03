# 企微 Hook 与采集边界独立核验

时点说明：本记录保留旧基线 `626b123` 的审查及实验；后续 `edeb7a4` 已更新入站分页、查询与审计，当前结论以 [本地续审](research-current-state-audit.md) 为准。下文旧源码行号及测试结果不改写为新版本成绩。

日期：2026-10-02（北京时间）。固定本地仓库 HEAD：`626b123226f1c974b48a6dceaa1373fe81b724c4`。

证据级别：当前源码静态检查、公开一手文档读取、临时合成 SQLite／录制发送替身实验。`real_client_tested=false`。没有读取私有运行目录、聊天正文、凭据，没有启动／注入微信或企微进程，没有安装工具或发送消息。本文只核验采集、发送与业务消费的接口边界，不代表客户端兼容性验收。

## 1. 相比 10 月 1 日报告应补充的结论

1. 当前接收仍为个微数据库副本查询，原生 Hook 桥仅声明 `sendText`／`idempotency`。原有“Hook 接收尚无证据”结论维持；工作台发送已连接不等于企微入站可用。
2. 最近 200 条是自动回复实际消费窗口，不是分页大小。205 条同秒合成记录中默认只返回 200 条，缺失 local ID 1–5；提高展示 limit 能看到全部 205 条，但没有因此获得持续游标、掉线补收或可重放事件账本。
3. `@im.chatroom` 是数据库适配器已有合成识别范围，但自动回复启用要求字符串以 `@chatroom` 结尾。本轮合成启用 `synthetic@im.chatroom` 得到 `ValueError`。应按真实目标群 ID 验证，不能推断所有真实混合群均使用该后缀或均无法工作。
4. 当前“同秒启用不触发”“冷却期跳过不补发”“重启／异常后重新启用”是明确的保守业务策略。它们不能作为入站遗漏处理方案，也不能在全量语义研究中悄悄继承为丢弃上下文的规则。
5. 自动回复 `events` 表只在资格过滤之后领取候选触发项；非 @、旧消息和身份未知项不会进入该表。因此该表不是全量入站日志。
6. 官方 SDK 的 WebSocket 重连、消息 ID 和回复串行队列可复用为通道概念，但不证明离线期间可补收，也不证明现有外部混合群的非 @ 事件可达。应把“连上了”和“未漏收”分开验收。

## 2. 当前精确接口与证据位置

以下行号相对于上述 HEAD。

| 位置 | 已有行为 | 可复用／缺口 |
| --- | --- | --- |
| `WeBridge/web_mvp/database_adapter.py:414–440` | `_messages(..., limit=200)`，遍历各分片，按 `create_time DESC, local_id DESC LIMIT N` 查询 | 可复用多分片解析；没有 after-cursor 条件 |
| `database_adapter.py:447–472` | `serverId` 为字符串；行 ID 包含 source/file/table/local_id；输出发送人、本人、@、解码状态 | 可作为新事件转换输入；需另加 source epoch、落盘序号、观察时间、历史归属 |
| `database_adapter.py:475–494` | 基于稳定 ID、正文摘要及元数据排除确认重复；最终按 `(timestamp,id)` 排序并截最后 N | 防重仅在本次查询结果内；字符串行 ID 的同秒顺序不能当本地递增游标 |
| `database_adapter.py:543–565` | `call('messages',account,groupId,limit)`；只读操作边界 | 保留读取接口供界面；新增消费接口比把 UI limit 拉大更合适 |
| `WeBridge/web_mvp/windows_auto_reply.py:22–27` | 启动时禁用已启用规则；未完成 attempted 改 unknown | 可复用安全暂停；没有恢复消费或补发语义 |
| `windows_auto_reply.py:51–65` | 确认自动快照、本人及读取范围；群名空间硬性 `endswith('@chatroom')`；读取不传 limit | `@im.chatroom` 与已展示群能力不一致；不能直接复用作所有来源的 Agent 消费器 |
| `windows_auto_reply.py:86–98` | 启用基线；按 account/group/server ID 建事件领取键 | 可复用触发幂等思想；基线不是完整事件集 |
| `windows_auto_reply.py:123–131` | 只允许晚于启用、120 秒内、数据库来源、已知他人、结构化 @ 本人、非 @所有人等 | 这是发送资格，不是全量采集资格；同秒边界保守排除 |
| `windows_auto_reply.py:153–175` | 资格过滤之后持久领取；冷却项永久 `cooldown_skipped`；调用 `send_automatic` | 有限固定文本自动回复，不是语义 Agent；不保存所有消息 |
| `WeBridge/web_mvp/windows_hook_sender.py:276–307` | `_probe` 核验账号／源、进程绑定、适配 profile、能力和目标范围 | 版本和身份检查可复用；企微需自己的 profile 与适配 |
| `windows_hook_sender.py:410–430` | 人工 `confirm`；服务端 `send_automatic(data,expected_binding,baseline_messages)` | 保留人工与已批准规则两种入口；模型不能直接调用以扩大授权 |
| `windows_hook_sender.py:433–485` | 提交前重新校验，先持久 attempted，再 POST；超时 unknown，不重放 | 可复用发送持久防重；这是至多一次调用保护，不是保证恰好一次送达 |
| `windows_hook_sender.py:487–541` | `reconcile` 只处理已受理／已提交；同文新增记录仅 local_record_observed；unknown 不靠相似记录消除 | 可复用分级证据；需独立对端确认 |
| `WeBridge/scripts/run_windows_hook_bridge.py:44–66,87–97` | 文本构造／提交 RPC，能力仅 `sendText` 和 `idempotency`，明确 delivered=false | 不提供企微订阅、接收序列、历史分页或入站 ACK |

历史验收记录也仍需保持范围：`WeBridge/execution/windows-hook-enable-2026-09-28.md` 记录个微 4.1.15.13 文件传输助手本机观察；`windows-auto-reply-2026-09-28.md` 记录真实结构化 @ 已观察，但启用后尚未有新真实 @，不声明自动回复送达。本轮没有复测这些真实动作。

## 3. 本轮可复核的合成边界实验

复用仓库 `test_database_adapter.py` 的临时库工厂和 `test_windows_auto_reply.py` 的录制协议替身。全部标识与文本均为合成，临时库结束后由 TemporaryDirectory 清理；未改产品代码。

| 实验 | 输入 | 实际结果 |
| --- | --- | --- |
| 同秒超过默认窗口 | 单分片 205 条，local ID 1–205，不同 server ID，同一时间戳 | 默认 count=200，未返回 local ID 1–5；limit=2000 时 count=205 |
| 同秒排序 | 上述默认返回行 | 按数字 local ID 检查非递增，因为最终排序使用字符串 `id`；不能从 UI 最后一行建立消费游标 |
| 启用同秒 | activated=1000.5，message timestamp=1000，now=1001，其余资格符合 | `WindowsAutoReply.eligible(...) == False` |
| 混合群后缀 | 已在读取范围的 `synthetic@im.chatroom`，其余配置来自现有合成工厂 | configure 启用返回 ValueError“仅支持已勾选读取的群聊。” |

另运行 5 个现有针对性测试，全部通过，耗时 0.689 秒：

```powershell
# cwd: D:\ZJ-AI-WXBot\WeBridge\web_mvp
python -B -m unittest -v test_windows_auto_reply.AutoReplyTests.test_cross_shard_duplicate_server_id_and_cooldown_no_backlog test_windows_auto_reply.AutoReplyTests.test_timeout_is_durable_no_retry_even_reenable test_windows_auto_reply.AutoReplyTests.test_restart_disables_rules test_windows_auto_reply.AutoReplyTests.test_disconnect_pauses_and_no_catchup_on_recovery test_database_adapter.DatabaseAdapterTests.test_expanded_message_history_limit
```

这些 PASS 证明现有保守行为与其测试一致，不是全量接收 PASS。本次没有运行全仓回归，没有新增生产实现。

最小重现读取窗口的代码（从仓库根目录运行 Python）：

```python
import sys, tempfile
from pathlib import Path
sys.path.insert(0, str(Path('WeBridge/web_mvp').resolve()))
from test_database_adapter import create_metadata, create_shard, GROUP, SELF, STAMP
from database_adapter import DatabaseAdapter
with tempfile.TemporaryDirectory(prefix='research-hook-boundaries-') as folder:
    root = Path(folder)
    create_metadata(root)
    create_shard(root, rows=[{'local': i, 'server': 900000+i,
        'time': STAMP, 'text': f'synthetic-{i:03}'} for i in range(1,206)])
    adapter = DatabaseAdapter(root, self_id=SELF, source_id='research-synthetic')
    args = {'account':'research-synthetic', 'groupId':GROUP}
    rows = adapter.call('messages', **args)['messages']
    print(len(rows), sorted(set(range(1,206)) - {r['localId'] for r in rows}))
    print(len(adapter.call('messages', **args, limit=2000)['messages']))
# 本轮输出：200 [1, 2, 3, 4, 5]；205
```

## 4. 一手公开资料复核

2026-10-02 读取，动态文档仅代表访问时内容。没有安装或执行上游代码。

- [Frida JavaScript API](https://frida.re/docs/javascript-api/) 明确提到回调开销、减少不需要的 onEnter/onLeave、高频 send 的批量化与 CModule。它证明通用机制，不提供企微业务字段或当前版本支持。由此提出的本项目设计是：回调只拷贝有限数据并入队；模型、检索、OCR 和持久化移到外部进程；队列溢出应可见。
- [旧企微 DLL 接口文档，固定 540e0189](https://github.com/linuxxx/wxwork_pc_api/blob/540e01894941ac26b269057040e3b98ef3c0fa65/doc/dll.md) 描述注入以及 socket 连接／接收／关闭回调。回调签名证明其历史接口形态；本轮未获得当前企微版本、两类成员非 @ 或稳定性实机证据，不能升级为推荐可部署适配。
- [企业微信团队 SDK README](https://github.com/WecomTeam/aibot-node-sdk/blob/main/README.md) 区分 WebSocket 请求 `req_id` 与消息 `msgid`，提供 bot 身份、会话及发送者字段，说明重连和主动发送。接口列表没有证明员工全部聊天可读，也没有离线补收承诺。框架不应把传输请求 ID 当作业务消息永久去重键；需实际验证同一 msgid 的重投。
- [企业微信团队 OpenClaw 插件](https://github.com/WecomTeam/wecom-openclaw-plugin) 文档明确 Bot 与自建应用两种模式，主动消息存在目标范围和模式差别。其 bot→应用发送回退不构成本项目“原群原身份”的透明等价关系；应分别登记身份和目标范围后再评估。
- 官方会话内容存档 [91770](https://developer.work.weixin.qq.com/document/path/91770)、[91774](https://developer.work.weixin.qq.com/document/path/91774) 本轮 web 直接读取仍返回不可打开；定向搜索未得到可用正文。故继续列为待租户与官方材料确认的读侧候选，不新增价格、授权、拉取时限、外部群或同意条件的断言，也不把第三方转载提升为当前官方保证。

## 5. 建议新增的稳定接口（尚未实现）

保留现有 UI 查询与固定 @ 回复。另建来源接口与全量日志，避免把“是否允许发送”前置为“是否采集”。

```text
SourceDescriptor:
  source_kind, account_id, tenant_id, process_identity, client_profile,
  identity_namespace, capabilities, collector_epoch

read_batch(checkpoint, limit) -> events, proposed_checkpoint, source_health
commit_ingress(events, proposed_checkpoint) -> durable_checkpoint
claim_case(case_id, expected_version, lease) -> claim | conflict
decide(case_snapshot, evidence_refs, policy_version) -> Decision
authorize(Draft, current_case_version, current_policy, source_health) -> SendIntent | blocked
```

数据库来源的 checkpoint 至少按账号／来源命名空间／分片／表维护；不要只用秒级时间戳。使用复合游标前先验证 local_id 与 create_time 的单调性，必要时重叠扫描并去重，另验分片迁移／快照代际和迟到插入。若 sourceId 随临时快照目录变化，去重键应另用稳定来源身份，不能混淆快照 generation 与账号身份。

Hook 来源有自己的 `collector_epoch + ingress_seq`；这个序号只能发现已观察路径内部的断口，不能证明客户端外部没有遗漏消息。进程外日志在事务中写事件并推进 checkpoint，再通知上游已持久接收。探针未落盘前崩溃／客户端未运行时的消息需要独立补收来源；没有补收入口时只能显式记录 gap，不能承诺全量或 exactly-once。

采集消息可以至少一次到达并去重；发送的外部副作用不能与本地 SQLite 放入一个原子事务。不同故障边界必须区分：可重放接收、可重算决策、不可盲目重试的 unknown 发送。首次建库／历史重扫默认 `history`，有可靠边界才标 realtime；新源或重新登录需要重建身份绑定。

## 6. 采集验收表（待执行）

| 门槛 | 操作／独立分母 | 通过证据与停止条件 |
| --- | --- | --- |
| 原群与身份 | 固定实际混合群、两类成员、接管账号、客户端版本／模块摘要；记录真实 ID 命名空间 | 原目标群可识别；展示、接收、自动触发、发送四种能力分别登记 |
| 非 @ 覆盖 | 两类成员各发编号普通消息、真 @、假 @、引用、本人消息 | 接收清单逐项对照参与者发送清单；非 @ 必须进入全量日志，但不自动获得发言权 |
| 同秒／窗口 | 人工或获授权的受控发送制造同秒和超过 200／2000 条的批次 | 按独立编号分母算缺失／重复；checkpoint 不依赖 UI 排序；窗口扩大不代替分页 |
| 重投／重连 | 在回调前、入队后、日志提交前后、决策后分别断开／重启；重放相同稳定消息 ID | 日志和事项最终收敛、不重复业务效果；没有补收源就明确 gap 并阻断自动动作 |
| 多分片／WAL | 同 ID 跨分片、同文不同 ID、迟到落库、快照生成中新增 WAL | 同文不同消息不误合并；快照事务覆盖明确；丢失与重复计数可复核 |
| 队列溢出 | 压慢外部消费者至队列满；保留已生成消息总数与序号 | 溢出计数／区间可见，源健康降级，停止自动发送；恢复后核对补收 |
| 大整数与字段 | 超过 JS 安全整数的稳定 ID、未知 sender、无法解析 @、撤回／更正 | ID 字符串往返不变；未知不猜，旧草稿失效 |
| 发送竞争 | 出草稿后人工接管／取消群读取；提交后丢响应 | 提交前重新校验；unknown 不重发；本机记录、服务器受理、对端观察独立保存 |

每组报告分母、收到的唯一 ID、遗漏 ID、重复次数、unknown、时间区间、来源健康与原始证据引用。Hook 命中数和客户端进程存在都不是消息完整性分母。
