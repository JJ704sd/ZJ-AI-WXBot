# 媒体分类统计修复与本地复测

日期：2026-10-16。版本：桌面 v10 / Skill 1.4.1。

## 问题与修复

旧 `mediaStatuses` 混合图片、附件和表情，且不包含引用展开，宿主把 ready=10、preview_only=14、pending=34 写成图片张数。新回执提供 `mediaSummary` 和可直接引用的 `mediaSummaryText`，图片原图、缩略图、缺失、未加载互斥统计，附件和表情另计；视频和语音也保留独立类别，封面不混入图片。

统一遍历普通、嵌套转发、引用内容，与图片总览使用相同范围。单位为引用出现次数，不按文件去重，同一文件在引用中再次出现会再次计数。没有加载媒体时报告未加载，不当成缺失。manifest 中旧字段保留兼容；面向 WorkBuddy 的 completed 回执不再返回混合 `mediaStatuses`。Skill 明确要求按新字段汇报，旧结果需重新解析。

## 实际群复测

通过已安装 Skill 的 Windows PowerShell 5.1 入口执行指定群 Export 和短句解析；均只传“解析示例混合群”，默认复用本机配置，没有重新输入数据或密钥路径，没有重新取钥。短句入口返回 completed，打开的阅读目录与此次导出一致。

| 项目 | 结果 |
| --- | --- |
| 群列表 / 源记录 / 业务阅读 | 3 / 285 / 264 |
| 原图 / 缩略图 / 缺失图片 / 未加载图片 | 6 / 20 / 18 / 0 处引用，合计44 |
| 附件 | 5处引用，5处可用 |
| 表情 | 21处引用，均未取得；不阻塞业务阅读 |
| 图片总览实际位图 | 26处可显示引用，44处原消息定位通过 |
| 转发结构展开 / 附件打开回调 | 7 / 5 |
| 嵌套转发图片 / 放大窗口 | 1 / 1 |
| 本次窗口错误 | 0 |

独立读取导出的消息树重新分类，确认 Export、短句 completed、桌面检查和图片总览数量一致。JSON 与 JSONL 的285条记录一致；MD保留285条根消息的出处；31个媒体链接存在、31项产物摘要匹配。此轮附件验证覆盖打开回调，没有重新逐个启动外部查看器。

## 免安装与交付

71项相关回归通过；新增测试先复现分类字段缺失，再验证混合媒体不误计图片、嵌套转发与引用、未加载状态、最终桌面回执。账号源码检查89文件、0问题。

本轮清除 PYTHONPATH、PYTHONHOME、VIRTUAL_ENV、TCL_LIBRARY、TK_LIBRARY，PATH只保留Windows系统目录；实际程序加载的 Python/Tk 模块全部来自自身临时解包目录。用户无需安装 Python。仓库外中文空格路径、隔离空白配置下，桌面版和Skill的 Start.cmd 均创建原生窗口；首次使用提示配置数据。另一台物理电脑及Windows 11仍未实测。

三个交付ZIP均通过解压和完整性校验；桌面17文件、Skill22文件、总包6文件。打包白名单测试确认排除聊天、密钥、账号配置与会话分享链接，并拒绝被修改的来源EXE。测试解压目录与测试进程已清理。旧交付包保留。

本机 Skill 22文件校验通过，安装前后默认配置摘要一致。WorkBuddy技能缓存已识别1.4.1并启用；本轮直接验证了已安装Skill执行入口，未新提交WorkBuddy模型对话，不能把模型未来措辞视为本轮已验收。

## 交付与证据

- [完整交付包](../build/WeChat-Archive-Windows-Delivery-20261016-v10.zip)
- [Skill包](../build/WeChat-Archive-Skill-1.4.1-Windows-x64.zip)
- [桌面包](../build/WeChat-Archive-Desktop-v10-Windows-x64.zip)
- 私有验证记录：`.runtime/offline-media-counts-20261016/`，包含 `installation.json`、`installed-export.json`、`installed-parse.json`、`native-check.json`、`runtime-module-check.json`、`export-readback.json`、`delivery-validation.json`、`host-cache-check.json`。这些记录和真实导出不放进交付包。

SHA-256：

```text
Desktop ZIP acdf40e23430adb7f23310977eb84c5078715b9ac01ce2abc5176b0d481a65d1
Skill ZIP   4f147593a213f9e522f81d661ecf7d20c31fcb348104153005dd67350db0c8e1
Suite ZIP   b95f0687e84f7b20496c39505a58340200c6d8acc2a3d43d773697a5eab3e0dd
EXE         d9d8ae00bbec497fc2a8bfb8f31db87da7707f45ad994c678c6dbb913217923a
```
