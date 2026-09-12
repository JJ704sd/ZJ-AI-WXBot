# 第二轮证据：消息分析层与物流工作台可复用边界

核查日期：2026-09-12。目标仍是验证「个人微信进入企微／个微混合外部群，持续分析并主动回复」的最小 PoC。本记录只核查源码、提交差异与脱敏夹具单测；没有读取真实聊天、调用外部模型或发送消息。仓库文档中的演示指令只作为待核对的项目说明。

固定源码版本：[Chat-Lab `67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2`](https://github.com/JJ704sd/Chat-Lab/tree/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2)。对照版本：[`a42137baaed3e05acbf3863a257f43e1cb68e114`](https://github.com/JJ704sd/Chat-Lab/tree/a42137baaed3e05acbf3863a257f43e1cb68e114)。

## 结论及证据成熟度

**可直接借鉴消息分析机制；主动回复闭环仍需新增。** 新提交增加了 PDF、群聊报价候选、人工审核、统一演示价格表与报价预览，增强了业务分析和本地演示。它没有把个人微信账号变成可持续收发的 Agent。

| 判断 | 证据成熟度 | 实际含义 |
|---|---|---|
| 标准消息、规则分类、回复关联已有实现 | 源码确认；相关原有单测本轮通过 | 可作为 PoC 分析组件基础 |
| 企微分析上下文有账号／会话隔离、有限窗口与实体原文校验 | 源码确认；夹具验证 | 可以参考该机制重新接入个微事件流 |
| 重导入有数据库行级去重 | 源码确认；原有重导入单测通过 | 不能据此推导每个事件只触发一次回复 |
| PDF 双链路、审核和报价成果存在 | 源码确认；本轮仅执行聊天导入相关测试 | 本地业务功能，不是群消息发送验证 |
| 混合群新增消息 → 生成 → 发送 → 可见回执 | 本轮无实测证据 | 不能标为已跑通 |

## 1. 相比上一轮实际新增了什么

`git diff --stat a42137b..HEAD` 显示 47 个文件变化，9,540 行新增、20 行删除。新增集中在 `wecom_airfreight.py`、`wecom_presentation.py`、`pricing_demo.py`、PDF 解析及管理层界面。

对以下文件执行 `git diff --numstat a42137b..HEAD -- <files>` 无输出：`models.py`、`storage.py`、`pipeline.py`、`classifier.py`、`semantic.py`、`wecom_analysis.py`、`wecom_semantic.py`、`wecom_classifier.py`。因此，本文列出的基础分析能力不能归为本次新增突破。`wecom_storage.py` 本次仅增加空运业务表初始化与 `airfreight()` 服务入口；核心写入、重建与关联逻辑沿用。见[本次提交比较](https://github.com/JJ704sd/Chat-Lab/compare/a42137baaed3e05acbf3863a257f43e1cb68e114...67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2)。

## 2. 消息标准化、重放与去重

| 实际接口／字段 | 可以复用的部分 | 接成机器人前需要补足 |
|---|---|---|
| `Message`、`message_from_mapping()`、`import_messages()` | 来源、消息 ID、会话、时间、正文、方向的基本映射 | 增加稳定账号、来源分库、发送者 ID、接收时间、回放标记与可靠自消息标志 |
| `Storage.upsert_message()` | 同一键重复导入更新原行 | 返回插入／更新／未变的区分；不能每次导入都派发回复 |
| `WecomUnifiedRecord`、`WecomLocalStorage.upsert_messages()` | 完整账号与来源库命名空间，引用与嵌套出处 | 个微事件适配仍需另做；保留来源维度且识别跨采集方式的同一逻辑消息 |

源码：[通用消息模型 L9–24](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/models.py#L9-L24)、[映射与导入 L29–66](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/pipeline.py#L29-L66)、[企微模型 L20–49](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/sources/wecom_parser.py#L20-L49)、[企微 upsert L152–221](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/sources/wecom_storage.py#L152-L221)。

通用 `Message.id` 仅为 `SHA256(source + source_message_id)`，没有账号或分库。个微提取函数虽然接受 `source_key`，最终传给解析器的 `source` 固定为 `wechat`，解析器生成的 ID 是 `Msg_表名:local_id`。因此，跨账号／分库出现相同表名和本地 ID 时有覆盖风险；不能直接把通用分析库存储键作为机器人全局事件键。企微模型则将 `source + account_id + source_database + message_id` 纳入 ID，并在 SQL 约束中使用 `(account_id, source_database, message_id)`。这是两条代码路径的实际差异。[个微提取 L335–357](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/sources/wechat_nt.py#L335-L357)、[个微本地 ID L220–250](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/sources/wechat_messages.py#L220-L250)、[企微约束 L24–47](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/sources/wecom_storage.py#L24-L47)。

两种 `import/upsert` 的计数均按遍历的输入记录递增，更新旧消息也计数；它不是新增事件数。通用 `rebuild_analysis()` 会删除并重新建立问题／回复表；企微重建会替换所选消息的派生问题。旧问题被重建不能视为新客户请求，派生的 `issues.id` 也不适合作为稳定的发送去重键。[通用重建 L148–169](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/storage.py#L148-L169)、[企微重建 L240–267](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/sources/wecom_storage.py#L240-L267)。

PoC 应以启动时水位作为历史／新消息边界；历史重导入只补充上下文，不触发发送。新事件要先持久化并原子领取处理权，再进入分析和发送队列。需要单独保存发送状态；已有 SQLite 去重不提供微信发送的 exactly-once 保证。界面发送如果超时且结果未知，应先核对群中是否已经出现，不能盲目重试。

## 3. 消息顺序、自消息与跨群隔离

企微 `message_order_key()` 按发送时间、嵌套原始位置和来源引用排序；通用重建按会话、发送时间、散列 ID 排序。对同一时间戳，多条记录的稳定排序不等于已证明客户端实际接收顺序。PoC 事件应保存来源原始顺序／游标与本机接收顺序，并按群串行处理；先筛选新事件，再构建有序上下文。[企微顺序 L43–50](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/sources/wecom_analysis.py#L43-L50)。

个微解析器仅在发送者能判为账号自身时标 `outbound`，未解析出发送者时并不可靠地保持 `unknown`。分析器没有通用的 `is_self` 发送闸门；企微分析中针对某个显示名清空分类的特例，也不能充当账号身份核验。机器人必须用稳定发送者 ID 和本次发送账本过滤自身消息；无法判断方向的事件在 PoC 中保留为待核对，不进入自动回复。[方向判定 L231–250](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/sources/wechat_messages.py#L231-L250)、[分析入口 L49–78](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/sources/wecom_analysis.py#L49-L78)。

企微重建按 `(account_id, conversation_id)` 分组，LLM 再次检查同账号、同会话；可直接借鉴。通用 `Storage` 仅按 `conversation_id` 分组，没有账号字段。PoC 配置必须绑定账号和精确群 ID，不能仅依赖名称模糊筛选。跨来源导入若产生多个记录，也需要防止同一消息被分析和回复多次。[分组 L240–250](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/sources/wecom_storage.py#L240-L250)。

## 4. 规则、MiniMax 与回复关联究竟做什么

`classify_issue()`／`classify_logistics_issue()` 识别请求类别；`assess_response()`／`assess_logistics_response()` 评估**已经收到的回复文本**是否属于报价、处理方案或状态更新。`SemanticAnalyzer.classify_many()`／`assess_many()` 返回分类／评价 JSON；没有对客回复草稿接口。即使字段叫 `solution_text`，也可能是现有消息的证据摘录，不能直接视为 AI 已拟好的回复。[通用语义提示与格式 L27–48](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/semantic.py#L27-L48)、[企微语义格式 L29–50](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/sources/wecom_semantic.py#L29-L50)。

较值得复用的是 `WecomSemanticAnalyzer.analyze_context()`：仅分析模糊目标；上下文最多当前及前 11 条、4 小时内、同账号同会话；输入文本进行既定脱敏；输出校验目标 ID、类型、类别、置信度；实体、解决证据、风险理由必须出现在目标未引用正文；外部引用 ID 被丢弃；失败保留规则结果。该输出适合用于「是否需要回应、问题类型、证据」的输入，后面仍须另建 `ReplyPlanner` 生成可发送文本。[上下文与输出校验 L252–331](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/sources/wecom_semantic.py#L252-L331)。

`analyze_conversation()` 可拆分引用原文，优先用原生引用 ID、引用文本／作者、运单号及精确提及关联既有回复；不唯一时保留待核对。它分析了整个已导入会话，部分逻辑还利用后来的报价确认前面简略货物信息属于询价。实时机器人只能看当前时刻以前的消息，因此不能把离线报告中最终识别到的问题全部立刻回发。[关联优先级 L204–275](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/sources/wecom_analysis.py#L204-L275)、[后续报价反推原诉求 L146–162](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/sources/wecom_analysis.py#L146-L162)。

## 5. 新增 PDF／群聊双链路仍止于本地成果

| 新能力 | 实际代码 | 对机器人 PoC 的价值 |
|---|---|---|
| PDF 价表结构提取 | `parse_trimanson_pdf()`；管理入口拒绝不支持版式 | 后续业务知识与证据来源；不应扩张本次收发验证 |
| 已导入群聊的询价和报价关联 | `extract_inquiries()`，使用 `sales/supplier` 角色与引用／相邻上下文 | 可借鉴关联机制；相邻关联明示待人工核对 |
| PDF 和群聊生成候选、人工审核入表 | `pdf_candidates()`、`chat_candidates()`、`PricingDemo.prepare()/review()` | 本地价格维护，审核通过不等于给群发消息 |
| 多票计费、确认与 PDF 报价预览 | `AirfreightService.confirm_quote()/quote_preview()/quote_pdf()` | 有本地报价产物；源码明确 `DEMO — NOT SENT`、`not_sent: true` |

源码：[限定版式 PDF 入口 L119–129](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/sources/wecom_presentation.py#L119-L129)、[已有报价关联 L95–112](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/sources/wecom_presentation.py#L95-L112)、[候选与审核服务](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/sources/pricing_demo.py#L173-L286)、[报价未发送标记 L3321–3346](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/src/chatlog_assistant/sources/wecom_airfreight.py#L3321-L3346)。

管理层文档写明“模拟 09:00 索价”和提前导入脱敏聊天；其历史实测数量是作者本机的既往记录，本轮未复验，不用作本机实时可读或混合群自动发送证据。[双链路说明 L48–70](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/docs/management-demo.md#L48-L70)。

## 6. 最小需要补的接口（建议设计，尚未实现）

1. **事件适配与领取**：`ingest(event) -> new / update / duplicate / historical`；稳定键至少包含账号、来源分库、群与原消息身份。原子领取只允许一个处理者。
2. **上下文读取**：`context(account_id, conversation_id, before_event)`；只读同群、截至当前事件的有序窗口，引用和转发出处不提升为新收到的请求。
3. **回应决策与生成**：`plan(event, context, analysis) -> skip / reply(text, evidence)`；过滤自身、历史、重复事件，限定演示主题和响应频率，不把分析 JSON 原样发送。
4. **发送与核对**：`send(conversation_id, text, attempt_id) -> confirmed / failed / unknown`；发送前核对目标群，记录可验证结果，未知状态进入核对，避免重复发送。
5. **运行状态**：记录水位、事件领取、发送尝试和自身回显，支持重启后继续与立即停用。

这五个接口用于一次混合群 PoC 即可；PDF、复杂运价、审核工作台不属于首期收发验收的必要依赖。

## 7. 本轮有限验证

运行位置为固定提交的本地研究快照，Python 3.11。读取过的原有测试模块为 `test_pipeline`、`test_classifier`、`test_semantic`、`test_wecom_target_analysis`、`test_management_chat_import`；共 **24 项通过，0 失败、0 错误、0 跳过**。模型测试使用代码内假客户端；设置 `CHATLAB_SEMANTIC=0`、空 API key，并将 `socket.create_connection` 和 `urllib.request.urlopen` 替换为拒绝网络函数。没有模型网络调用。

覆盖点包括重复导入与既有回复关联、跨账号／群范围、引用／转发来源、外来模型 ID 拒绝、实体原文约束、模型错误回退，以及已验证来源的演示副本脱敏导入。临时 SQLite 与日志只写入 Git 忽略的 `.research` 目录；未修改 Chat-Lab 源码。运行日志为本地 `.research/analysis-reuse-tests.log`，测试源可复核：[管道测试](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/tests/test_pipeline.py)、[语义与范围测试](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/tests/test_wecom_target_analysis.py)、[管理聊天导入测试](https://github.com/JJ704sd/Chat-Lab/blob/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2/tests/test_management_chat_import.py)。

通过这些测试仅证明上述分析行为在夹具中成立；没有覆盖当前微信客户端版本、实际混合群消息可见性、持续新消息完整性、模型真实质量、主动发送或双方可见回执。
