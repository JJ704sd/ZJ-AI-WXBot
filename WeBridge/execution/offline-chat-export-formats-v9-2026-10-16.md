# 三格式导出与免安装启动验证

日期：2026-10-16。版本：桌面 v9 / local-wechat-archive Skill 1.4.0。范围为 Windows 10 x64 本机验证，另一台物理电脑及 Windows 11 未实测。

## 交付行为

每次指定群解析或导出，同时生成 UTF-8 的 messages.jsonl、messages.json、messages.md；已有 JSONL、CSV、HTML、图片总览和业务阅读继续保留。JSON 是 JSONL 相同消息对象按相同顺序组成的数组；两者保留原始字段、消息出处和嵌套结构。Markdown 展示发送人、时间、来源、正文、@、引用和多层转发，可用图片和附件使用相对 assets 链接，缩略图和原件缺失分别标注。消息中的 Markdown/HTML 放在字面正文块内，不执行其中的图片标记。

导出沿用同一会话、日期范围与原有完整性检查，在临时目录完成全部文件和校验清单后统一发布；失败不发布半份结果，不覆盖老导出。JSON 流式写出，无需为新增格式把全部消息一次加载到内存。

桌面新增 MD / JSON / JSONL 选择及“查看导出文件”按钮；缺少默认关联时尝试系统记事本。Skill 普通短句无需增加路径、密钥或转换命令，完成回执和批处理结果通过 exportFiles 返回三种文件位置。

## 免安装依据

- 最终桌面 ZIP、Skill ZIP、完整交付 ZIP 已校验文件清单和 SHA-256，无真实消息、媒体、数据库、密钥、本机配置或真实会话分享链接。
- 两个独立包从项目外、含中文与空格的目录解压，在隔离用户配置、仅系统 PATH、无 Python/Tk 环境变量时，实际调用 Start.cmd 并观察到原生窗口。首次使用进入配置流程，不读取现成私有配置。
- 已安装的最终 EXE 在同样清除 Python 路径及环境变量的情况下，完成真实群导出和原生控件检查。加载的 python314.dll、python3.DLL、_tkinter.pyd、tcl86t.dll、tk86t.dll 均来自程序自身临时解压目录，而非系统 Python 安装目录。
- 用户无需安装 Python、pip、Node、Docker、数据库服务或转换库。EXE 内部仍包含运行库；Skill 启动使用 Windows 自带的 PowerShell。工作台宿主、本人数据和匹配配置仍按实际使用方式准备。

## 本机结果

- 285 条源记录，264 条业务阅读记录；JSON 数组与 JSONL 逐条相等，Markdown 包含全部285个根消息出处。
- Markdown 中31个相对媒体链接全部指向同份导出的已存在 assets 文件，全部31项产物校验通过。
- 原生阅读检查：19个可用图片引用（含1个嵌套转发图片）、7个转发结构展开、8条引用原消息关联、5次附件打开回调；图片总览44个引用，其中6原图、20缩略图、18缺失，26个位图及44个出处入口检查通过。
- 本轮附件检查覆盖打开回调，不等于再次逐个打开系统默认查看器。未缓存原件没有因此补回；引用中的重复图片不作为独立原图数量。
- 合成回归先确认缺少 JSON/MD 的失败，再验证三格式一致性、空日期范围、原始字段和嵌套媒体；59项相关回归通过，新增返回路径断言后的17项入口/来源检查通过。账号来源检查扫描88文件，零问题。
- WorkBuddy 已更新至 Skill 1.4.0，22个交付文件校验通过，默认设置文件摘要前后相同；没有重新选择账号、读取密钥正文或重新取钥。本轮未再次通过宿主对话发送解析请求，实际导出调用的是已安装 Skill 入口。

## 证据

私有证据保存在 .runtime/offline-export-formats-20261016/：installation.json、delivery-validation.json、installed-export.json、export-readback.json、runtime-module-check.json、native-check.json。真实输出留在当前用户 LocalWechatArchive 工作目录，不随程序包分发。

## 最新交付

- [完整交付包](../build/WeChat-Archive-Windows-Delivery-20261016-v9.zip)
- [WorkBuddy Skill](../build/WeChat-Archive-Skill-1.4.0-Windows-x64.zip)
- [独立桌面版](../build/WeChat-Archive-Desktop-v9-Windows-x64.zip)
