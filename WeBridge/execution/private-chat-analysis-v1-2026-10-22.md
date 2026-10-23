# 私聊分析助手 1.0.0 开发与验证记录

日期：2026-10-22。源码基线：`9ae4447344a07baa34d044518a15c92e35d6c303`。在当前 `main` checkout 开发，未创建提交、推送或 PR。原 v41 群聊交付文件保留。

## 需求与分工

依据 `docs/local-chat/私聊分析助手-spec-v1.0-20261022.md`。先完成三轮 grilling 的九项决策并保存 spec，再分派三个开发子 Agent：私聊选择与解析、画像持久化、两套 Skill 与分发。主 Agent 完成桌面/CLI 整合、构建和最终验证；额外只读复核发现的数据完整性问题已回到实现中修正并增加回归。

实现范围：个微联系人及企微内部/外部联系人的本地私聊解析；源记录人工复核后正式导出；宿主模型分析；对方、本人和关系观察的候选校验；用户确认后保存 JSON/Markdown 版本；当前账号本人总览；手动增量；人工跨端身份关联。身份及内外部联系人类型缺少可靠依据时保留未知。群聊保持默认模式和独立复核进度。

## 主要交付

- `scripts/private_chat.py`：画像 prepare/stage/review/show/overview/link-review。review 和 link-review 为人工窗口，无非交互确认开关。
- `web_mvp/offline_direct.py`：私聊筛选、稳定对象映射、唯一精确名称、分发包模式约束。
- `web_mvp/private_profiles.py`：正式导出与引用校验、增量来源、候选、版本、本人总览和身份关联。
- `scripts/build_private_chat.ps1`、`scripts/package_private_chat.py`：新 EXE 构建、实际能力探测、双 Skill 白名单打包和 SHA-256 清单。
- `skills/local-wechat-private-analysis/`、`skills/local-wecom-private-analysis/`：客户端绑定的宿主协议和 Windows PowerShell wrapper。

持久化文件为新功能的 v1 格式，不修改原群聊存储格式。版本文件附摘要且原子切换指针；过期基线、缺失分段、跨对象引用、非正式导出和已改写材料均停止处理。源导出与画像库需一起保留；没有新增模型 API、定时任务或外发动作。

## 源码验证

运行时将 `web_mvp` 和 `scripts` 加入 `PYTHONPATH`；原生窗口测试使用本机 Tcl/Tk。全部数据为临时合成 SQLite/JSON，测试确认记录明确标记为 synthetic，不代表真实用户确认。

| 检查 | 结果 |
| --- | --- |
| 分发、offline_analysis/review/desktop/progress/batch/profiles、runtime_identity、SourceBindingTests | 57 项通过 |
| 最终私聊画像、私聊 UI/CLI 整合、分发、batch、runtime_identity、SourceBindingTests | 39 项通过（最终冻结源码） |
| 原有 open/multiselect/batch_review 加新增窗口初始状态检查 | 26 项中首次 25 项通过，1 项失败，见下面说明 |
| 失败项单独复测 | `test_default_parse_preserves_reviews_and_reparse_is_explicit` 通过（内部覆盖双客户端） |
| 新增私聊包模式、batch 精确名称及原 batch 回归 | 7 项通过 |
| 源码账号标识扫描 | 115 个文件，0 项问题 |
| 两套 Skill 格式 | UTF-8 模式下 quick_validate 通过 |
| PowerShell 语法 | 两套 wrapper 与构建脚本通过 |

GUI 首次失败发生在企微合成用例按 Enter 切换会话后的状态断言；同一用例单独复测通过。本次未改动该测试、未证实根因，也未将其标为已修复。没有执行全仓回归，不能据此宣称全部既有 GUI 稳定性问题已解决。

合成链路覆盖双客户端：私聊筛选 → 预览与恢复 → 源记录复核 → 正式导出 → 分析请求 → 候选暂存 → 测试确认 → 正式画像 → 相同材料 unchanged。画像单测另覆盖来源批次、完整性、证据归属、基线、冲突保留、版本失败恢复、本人总览和人工关联边。

## Windows 交付验证

构建使用已有 `.runtime/offline-build-deps`，没有安装新生产依赖。最终产物位于 `build/private-analysis-1.0.0-20261022/`。打包器分别执行桌面与画像 EXE 的能力探测，校验 role、version、schemaVersion 和 direct 模式。

实际二进制验证结果与 ZIP SHA-256 见 `private-analysis-1.0.0-compiled-validation.json`。检查 ZIP CRC、27 个文件的完整清单和逐文件摘要、两端客户端绑定；包内仅含两个程序、Skill、wrapper、说明、许可和元数据，不含真实账号配置、聊天、数据库或密钥。

编译程序检查使用临时目录且子进程 PATH 不含 Python。桌面在隔离空配置下能创建原生窗口并默认进入正确客户端的 direct 模式；该窗口回执为需要配置账号，不当作真实账号解析成功。包内桌面程序完成双客户端合成私聊解析；画像程序完成 prepare/stage/show，候选未确认时没有正式画像；跨客户端调用被拒绝。Windows PowerShell wrapper 的中文 JSON 返回亦检查。

## 未验证范围

- 未读取真实私聊、运行取钥或修改真实账号配置；当前客户端数据库版本和真实数据覆盖仍需实际使用验证。
- 未在 WorkBuddy 中执行导入与模型分析；宿主可用性、结论准确性和真人确认仍需实际使用验证。
- 未将合成确认或结构校验当作业务验收；脚本校验证据存在与归属，语义判断由宿主分析和用户复核承担。
- 原有四个 v41/1.27.0 ZIP 的 SHA-256 与输入基线一致。没有替换 `build/00-最新交付.md` 的群聊交付指向。

## 最终包摘要

| 客户端 | ZIP SHA-256 |
| --- | --- |
| wechat | 1822c148d3c56a85cc7f27677720c8dbb249de93293cf1e0448519b7ebd4109e |
| wecom | 77e5b53193bc7ced879b439fb8eff97dae7192b83e5dd9d4e578410b473aff70 |
