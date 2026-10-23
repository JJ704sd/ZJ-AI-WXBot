# 私聊分析助手 1.5.0：持续使用优化

基于 1.4.0，按 `docs/local-chat/私聊持续使用优化-v1.5-20261022.md` 实施。保留现有 UI、功能和画像确认流程，重点修复证据定位、失败反馈与并发总览。

## 修复与因果证据

- **搜索证据引用不一致**：原消息行 `ref=1`、正式分析映射 `ref=7` 时，1.4 搜索错误返回 1；将此结果用于画像候选无法绑定正确分析证据。新增共享引用解析函数，只使用已校验 `analysisRefs` 的正整数引用。未进入分析材料的消息保留消息 ID，不再把原始行中的引用当作画像依据。
- **消息 ID 回退遗漏**：`id=None`、`messageId` 有值时，搜索与详情可能显示 ID 未提供。现在搜索、随机回顾和原文详情保持稳定消息 ID，便于定位非分析消息。
- **随机回顾失败被当成空材料**：后台准备异常原先只留下空候选，用户无法区分“无可回顾消息”和“加载失败”。现在回顾区域显示错误，点击一次“换一条”即可重新准备并显示结果。打开统计窗口本身不会自动展示随机原文。
- **取消保存仍显示已提交**：目录选择被取消或主窗口正忙时，保存回调未发起任务，统计窗口仍显示已提交。现在回调明确返回是否接受请求，并在目录对话框返回后再次核对主窗口状态。只有接受请求才显示已提交，实际保存成功仍以异步完成回执为准。
- **本人总览并发写入交错**：JSON 与 Markdown 各自原子写入不能防止两轮总览交叉发布。复用现有文件锁串行执行总览，避免最终两份文件来自不同批次；原有失败回滚测试继续通过。

未新增生产依赖，未改变画像 schemaVersion、历史 ID、人工确认或跨端关联契约。未对没有复现问题的时间统计和 stage/confirm 流程做额外改写。

## 验证

98 项不同定向用例通过：核心 66、桌面与双端适配及原群聊回归 31、总览并发恢复 1。重复复验不重复计数。运行身份检查仍覆盖 119 个生产文件，0 个问题。

测试日志：

- `.runtime/private15-core-tests.log`
- `.runtime/private15-ui-tests.log`
- `.runtime/private15-store-tests.log`

最终回放补齐重试成功后自动显示结果，5 项相关 UI 回归再次通过，记录在 `.runtime/private15-retry-display-green.log`；重复用例未加入 98 项计数。

基线 1.4 通过公开 `inspect_export → search_messages` 整合接口复现错误引用与 ID 丢失，两项断言失败；当前实现对应两项通过且搜索引用能 stage 到正确原消息，记录为 `.runtime/private15-reference-red.log` 与 `.runtime/private15-reference-green.log`。取消保存、详情 ID 丢失的独立修复前记录为 `.runtime/private15-report-red.log`、`.runtime/private15-ui-id-red.log`。

总览测试通过受控写入边界和线程同步制造交错，分别运行旧版与当前实现。早期未充分控制交错的测试没有稳定复现，已加强测试；最终旧版连续 3/3 失败，当前连续 3/3 通过。该结果证明测试所覆盖的并发写入场景，不等于所有故障或多进程压力场景均已覆盖。

重复对照记录见 `private15-store-interleave-old.json`、`private15-store-interleave-new.json`，最终旧版断言失败为 Markdown 缺少新观察，而当前两份文件均包含已确认的新观察。

## 实际 EXE 与交付检查

- 双端 1.5 EXE：合成私聊解析、候选准备与校验、中文往返、PowerShell 入口、统计及分页、账号/客户端约束、画像读取、本人总览、无变化拒重、空配置原生窗口。子进程 PATH 不含 Python。见 `private-analysis-1.5.0-compiled-validation.json`。
- 双端 1.4/1.5 EXE 对照：同一正式合成材料，旧版搜索返回行字段 1，新版返回已校验引用 7；新搜索结果能生成绑定正确原文的候选，非分析消息保留 ID 且不提供引用；未自动生成正式画像。见 `private-analysis-1.5.0-reference-validation.json`。
- 双端 1.2→1.5 实际 EXE 升级：旧请求、候选、来源 ID 和旧文件内容保持不变，旧候选可继续复核；测试 API 仅在临时合成库建立确认状态，再验证读取与 unchanged。见 `private-analysis-1.5.0-upgrade-validation.json`。
- 两个 Skill ZIP 均为 27 个文件，文件集合、CRC、SHA-256 与 runtime 绑定回读通过；此前 19 个 ZIP 保持不变。见 `private15-delivery-validation.json`。相关源码和验证脚本摘要见 `private15-source-manifest.json`。

## 使用与边界

新包解压到新目录并运行 `Start.cmd`。保留原正式聊天导出和画像库，宿主仍读取指定材料分析，候选仍需用户确认入库。

本轮全部使用隔离合成数据，未读取真实账号、聊天或密钥；未验证真实 WorkBuddy 导入、宿主分析及所有 DPI 组合。定向测试通过不表示全仓回归通过。未提交、推送或对外发布 Git。
