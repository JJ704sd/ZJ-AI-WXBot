# Windows 工作台历史查询改进（2026-10-02）

本轮补齐聊天历史与执行记录的服务端搜索、日期筛选和分页。代码与验证均在本地 Windows 完成；没有读取真实聊天、启动 Hook、发送消息或改变自动化配置。未重启原有工作台服务，使用新能力前需重启后台并刷新网页。

## 用户可见变化

- 聊天工作台新增“查询更早记录”。关键词覆盖当前会话完整已解码正文、发送者与文件名，不再只限最近 2000 条；日期按北京时间计算且包含结束当天。窗口独立于实时消息流，保留草稿和未保存规则。
- 执行记录按关键词、来源、状态与日期筛选全部本机历史；每页最多 2000 条，支持上一页、下一页。旧页不被后台轮询覆盖，刷新返回第一页。
- 自动回复与定时执行按历史 `draftId` 精确关联原正文和最终记录状态，避免关联池只含近期草稿而漏掉旧记录。不存在历史正文的旧回复不使用当前规则补造内容。
- 账号、读取范围、数据源或查询条件变化时清空旧查询并拒绝迟到响应。聊天副本 revision 变化需重新查询。读取失败保留当前页码，允许重新查询或重试翻页。

## 读取与资源边界

`GET /api/message-history` 仅支持数据库模式，校验账号、有效会话和已勾选读取范围。`GET /api/execution-history` 保留原接口，新增 `query/source/status/startDate/endDate/cursor`。两者均以 `database_service.lock → engine.sync_lock → engine.lock` 顺序取锁，订阅范围变更与查询串行化。没有取钥、刷新副本、调用 Hook、发送或回执核验副作用。

聊天查询以时间、分片和本地坐标合并分页，保留同秒消息、跨分片去重及撤回覆盖。先检查当前解析器支持的撤回通知；不恢复已撤回正文。每次最多解码处理 5000 条原始记录，未完成时即使本页没有匹配也返回后续游标。SQLite 无合适索引时可能扫描和排序原表，这个限制不等于固定 SQL 查询耗时。

聊天结果显示摘要：正文最多 8000 字符、发送者 256 字符、文件名 1000 字符。先对完整解码内容匹配，再截断显示；嵌套转发和引用只搜索、不缓存完整结构。单页响应控制在 2 MiB，缓存最多 32 页且 JSON 总量最多 16 MiB，最多 16 个查询上下文，15 分钟无访问后过期。撤回文案最多 512 字符、累计 4 MiB；同秒去重和撤回条目各最多 10 万。达到边界时返回继续游标或明确失败，不能把未查完当成无记录。

执行历史通过只读 SQLite 查询后再限制返回行数，游标绑定账号、订阅版本和筛选条件。新加入的较新记录不会挤动后续页；执行状态变动不属于跨请求冻结快照。服务重启后游标失效，需重新查询。

本轮没有增加历史附件加载能力：既有附件定位仍只查最近 200 条，新的历史窗口只展示文字摘要。没有对真实微信历史规模、持续接收或收件端送达进行新验收。

## 验证结果

1. Windows 默认 Python 3.11 全量回归：301 项，298 通过、3 跳过，开启 `ResourceWarning` 错误检查。3 项跳过均因该解释器缺少可选 `zstandard`；Anaconda 定向运行新历史查询 19 项及原 Adapter 25 项全部通过，包含实际 zstd 压缩解码。
2. 新增消息历史用例覆盖 6105 条记录中的旧关键词、空扫描页继续、同秒多分片去重、日期边界、范围外撤回、四页前后导航、失效游标、长文本尾部命中，以及大小限制下分页不漏记录。
3. 执行历史 16 项与 HTTP 集成 8 项通过。覆盖各来源超过 2000 条后的旧命中、精确草稿合并、同秒边界、并发较新插入、非法参数、越权拒绝、锁约定、只读文件字节不变及缺失文件不创建。
4. 四份 Node 合成检查通过：`check_history_query_controls.cjs`、`check_execution_controls.cjs`、`check_message_history_controls.cjs`、`check_schedule_controls.cjs`。覆盖迟到成功/失败、关闭重开窗口、筛选变更、翻页失败恢复和保留编辑内容；相关 JS 语法检查及 `git diff --check` 通过。
5. 真实 Chrome / Playwright 浏览器完成 12 项合成 API 检查：查询参数、聊天前后页、执行历史页保持、草稿与规则保留、副本更新隔离、桌面和 390px 窄屏无水平溢出、无 JavaScript 错误、无发送和配置写入。截图逐张查看；接口数据为合成，不能当作真实微信验收。

复现全量测试（工作目录为 `WeBridge`，临时目录先创建）：

```powershell
$env:TEMP = "$PWD\.runtime\test-tmp"
$env:TMP = $env:TEMP
New-Item -ItemType Directory -Force -Path $env:TEMP | Out-Null
python -W error::ResourceWarning -m unittest discover -s web_mvp -p 'test_*.py' -q
```

浏览器脚本：`web_mvp/diagnostics/check_history_query_ui.js`。本地保留结果日志 `.runtime/history-browser-20261002.log` 与 `output/playwright/history-query-{desktop,mobile}.png`、`output/playwright/execution-query-{desktop,mobile}.png`；这些目录受 Git 忽略，仅包含本轮合成数据。
