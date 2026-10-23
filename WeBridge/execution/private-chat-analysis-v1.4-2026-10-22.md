# 私聊分析助手 1.4.0：可靠性优化与验证

基于 1.3.0，先定义“身份有依据、证据可重现、增量有顺序、失败可恢复、成本有边界”五项约束，再用合成数据复现问题并修复。规格见 `docs/local-chat/私聊可靠性优化-v1.4-20261022.md`。主 Agent 负责证据类型、整合与实际 EXE 交付，三个子 Agent 分别负责存储兼容、会话判定和报告故障验证。

## 实际改动

| 约束 | 已复现的问题 | 修复与验证 |
| --- | --- | --- |
| 证据唯一 | 数字 ID `7` 与文本 ID `"7"` 在检查重复时使用不同类型，保存索引时却使用相同字符串，可能覆盖原记录 | 先验证 ID 是非空字符串或非零整数，再统一为字符串查重；拒绝布尔、列表、对象 ID；不同的有效数字 ID 仍可正确定位原消息 |
| 引用准确 | Python 把 `True` 视为整数 `1`，候选中的布尔引用可能命中消息 1 | 在候选证据边界明确拒绝布尔引用；不存在、跨来源引用等原有校验继续执行 |
| 升级可继续 | 1.2 保存分析消息的时间范围，1.3 改为完整消息范围；首尾存在非分析消息时，旧来源与请求会被判为不一致 | 只接受原记录计算出的旧分析范围或完整消息范围；保留旧请求和候选 ID，继续严格校验身份、消息、分段和摘要；新统计仍覆盖完整消息 |
| 增量有顺序 | 先确认 A，再确认内容变化的 B，再重新确认 A，唯一来源列表未调整顺序，后续仍可能按 B 判断 | 将本次确认来源移到唯一列表末尾；A→B→A 后再次准备 A 为 unchanged；随后 C 与最后确认的 A 比较；历史确认仍由版本链保留 |
| 身份一致 | `conversationKind=direct` 与 `conversationType=group` 冲突时仍可进入私聊；大小写或空格变体的系统类型可能漏过筛选 | 排除明确的群聊类型冲突；系统类型先去首尾空格并忽略大小写；保留联系人/参与者映射要求 |
| 失败可恢复 | 需要证明 JSON、Markdown、HTML 写到一半失败时不会留下阻断重试的目录 | 对每种文件实际写入后注入异常，验证新报告目录被清理，同一路径重试生成完整三件产物。现有实现已满足约束，本轮只增加回归测试 |

不新增生产依赖，不修改持久化 schemaVersion，不增加自动确认或模型 API。画像分析、人工确认、跨端关联以及原群聊入口的使用方式沿用既有契约。

## 定向测试

89 项不同用例通过，不重复计算复验次数：

- 核心 62 项：画像存储 27、证据完整性 4、私聊选择 4、统计和报告 5、统计 UI 模型 9、分发 4、运行身份与源绑定 9。
- 原生 UI、画像复核、双端适配集成、布局和已确认画像查阅 20 项。
- 历史桌面设置、搜索选择与原群聊导出 7 项。

运行身份扫描覆盖 119 个文件，0 个问题；Git 已跟踪差异的空白检查通过。日志为 `.runtime/private14-core-tests.log`、`private14-ui-tests.log`、`private14-group-gui-regression.log`。证据引用和 ID 的修复前失败保存在 `private14-evidence-red.log`、`private14-id-shape-red.log`，修复后对应 4 项通过。

可复现的测试命令（项目目录下设置 `PYTHONPATH` 为 `web_mvp;scripts`）：

```powershell
python -m unittest web_mvp.test_private_profiles web_mvp.test_private_evidence_integrity web_mvp.test_offline_direct web_mvp.test_private_insights web_mvp.test_private_insights_ui web_mvp.test_private_chat_distribution web_mvp.test_runtime_identity web_mvp.test_windows_hook_smoke.SourceBindingTests
python -m unittest web_mvp.test_private_insights_native web_mvp.test_private_profile_ui web_mvp.test_private_chat_integration web_mvp.test_private_layout web_mvp.test_private_saved_view
python -m unittest web_mvp.test_offline_setup_integration web_mvp.test_offline_target_search web_mvp.test_offline_desktop.DesktopSessionTests.test_selected_group_exports_real_artifacts_and_remembers_selection
python scripts/check_runtime_identity.py
```

## 实际 Windows 包验证

重建桌面和画像 EXE，分别打包个微、企微 Skill。每端 27 个文件，运行子进程 PATH 不含 Python。用隔离的合成账号数据验证实际 EXE 解析、来源绑定、prepare/stage/show、中文候选、PowerShell wrapper、统计报告与关键词分页、源目录写入拒绝、跨客户端拒绝，以及空配置的原生窗口启动。已确认画像读取、本人总览和 unchanged 拒重在独立测试库验证。结果见 `private-analysis-1.4.0-compiled-validation.json`。

另用两个客户端的实际 1.2.0 EXE 创建含末尾表情的旧请求与候选：同一材料在 1.3.0 实际 EXE 中 stage 失败且文件未变；1.4.0 prepare、stage 和候选读取通过，来源、请求、候选 ID 保持一致，旧请求与候选文件字节不变。仅在临时合成库用测试 API 确认后，实际新 EXE 能读取正式画像，重复准备返回 unchanged，统计时间包含末尾表情。见 `private-analysis-1.4.0-upgrade-validation.json`。

分发 CLI 未增加无人值守确认命令。上面的测试 API 确认仅用于临时合成库，不代表任何真实资料已获人工确认。

合集、双端 ZIP 的文件集合、CRC 和逐文件摘要回读，以及此前 16 个 ZIP 保留检查，见 `private14-delivery-validation.json`。本轮相关源码与验证脚本摘要见 `private14-source-manifest.json`。

## 验证边界与升级

- 本轮为定向回归，不表示全仓测试通过。未读取真实账号、聊天、附件或密钥；未验证真实 WorkBuddy 导入、宿主分析或所有 DPI 组合。
- 旧时间范围兼容针对由已校验原记录准确计算出的两种范围，不放行任意修改；其他文件或身份不一致仍失败。
- 升级时把新包解压到新目录；正式聊天导出和本地画像库需一并保留。移动、删除或改写原导出仍可能阻断复核与更新。
- 仅完成本地修改和交付，未提交、推送或对外发布 Git；历史交付保持原样。
