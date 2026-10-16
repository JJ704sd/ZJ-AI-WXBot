# 本地聊天解析 v4：迁移、账号适配和 Skill 验证

检查日期：2026-10-16。构建与隔离验证机：Windows 10 x64，10.0.19045；Windows PowerShell 5.1.19041.7725。

## 交付和使用

- 桌面版：解压 `local-chat-desktop-windows-x64-20261016-v4.zip`，双击 `本地聊天解析.exe`，选择数据和已有密钥。旧版产物保留。
- WorkBuddy Skill：`local-wechat-archive-workbuddy-20261016-v4.zip`；包含 SKILL.md、免安装 EXE、PowerShell 启动脚本和许可证。可通过宿主本地技能导入，也可解压双击 Start.cmd。
- 使用者不用安装 Python、pip、Pillow、Tk、Docker、数据库服务或工作台。Python 源码和构建依赖保留给开发者维护，不要求使用者运行 `.py`。
- 文档/视频的外部打开仍使用电脑已有的默认查看器。包内图片与转发查看不依赖 Office 或浏览器。

WorkBuddy 格式依据官方 [Skill 文档](https://open.workbuddy.cn/docs/skill)；本地上传入口依据 [Skills 市场说明](https://www.workbuddy.cn/docs/workbuddy/From-Beginner-to-Expert-Guide/Function-Description/Skills-Market)。通用 Skill 的供应商字段放在 metadata；WorkBuddy 分发版按其格式提升为顶层字段。命令执行链已实测，WorkBuddy 宿主自身的技能识别、对话触发与模型归纳未作为验收成功项。

## 图片与账号适配

图片密钥原 sourceRoot 仅作为候选排序提示，迁移不会据此拒绝密钥。原件按消息完整 MD5 校验；缩略图没有原件摘要时必须实际解码像素，继续标记 preview_only。最多128个候选、64KiB文件，不改写输入密钥文件。错误候选不能仅凭 AES 解密未报错而成为结果。

保留原有两个密钥文件格式，同时支持组合 JSON：keys 保存数据库条目，imageKeys 保存图片条目；选择组合文件后图片密钥框可留空。数据库按实际 salt、逐页 HMAC 与 SQLite 完整性验证。账号目录名、群主、第一位成员不用于推断本人；换源清除旧身份，用户可填写可靠的本人ID。

这验证了当前4.x布局下按内容和库结构适配账号，不等于覆盖所有微信版本、3.x、手机备份或任意私有格式。

## 实测证据

| 检查 | 结果 |
| --- | --- |
| 源码相关回归 | 143项通过；runtime identity检查80文件、0问题 |
| EXE仓库外运行 | 新临时路径、中文和空格目录、空白用户配置；子PATH只保留Windows，去掉Python/Tk环境变量，通过 |
| 首次无配置 | 原生窗口创建并提示选择数据；不冒充已加载 |
| 加密库没有密钥 | 明确缺少匹配密钥；不静默转用其他数据 |
| 原图片密钥迁移 | 保留旧sourceRoot，未改写图片密钥，解析与窗口图片检查通过 |
| 当前示例群 | 3群可列；285条全部解码、264条业务记录 |
| 窗口检查 | 19个图片引用显示，其中嵌套转发图片1；7个转发结构展开；8个引用来源展示；图片放大窗口创建1次 |
| 附件 | 5次文件打开回调指向校验后的本地副本；回调在检查中拦截，未据此宣称外部查看器渲染成功 |
| Skill Windows PowerShell 5.1 | 组合密钥列群、复用设置按群导出通过；原始行/内容与基线一致；错误的首个图片候选被跳过 |
| 切换账号 | 第二合成账号独立群与消息可列/导出，不沿用前账号群或本人ID；这是合成证据，不是第二真实账号验收 |
| 打包取钥组件 | 冻结EXE的独立工作进程正常执行；对未被微信持有的副本明确归属失败，不生成密钥文件 |
| 原始数据 | 原数据库、原密钥、既有设置摘要保持不变；所有隔离测试的临时聊天和密钥副本已删除 |

迁移复制仅限已选账号的6个数据库、6个WAL、589个媒体文件（52,677,543字节）。媒体统计保持 ready=10、preview_only=14、pending=34，其中pending包括21个可选表情和13个图片引用；此次修复解决路径造成的漏读，未创造本地不存在的原件。

程序包内已检查 Python314、VC运行库、UCRT、Tk/Tcl、Pillow、cryptography、zstandard，以及批处理和取钥模块。外部DLL依赖为Windows系统组件；未引入Frida、pymem、NumPy或网页工作台。Windows 11或另一台干净物理机尚未实际运行，不能用本机隔离测试代替跨机验收。

## 取钥能力及实测限制

普通加载/导出只读取文件。用户主动点击“没有密钥”或调用 Skill RecoverKeys，才使用现有只读工具：先验证所选文件的唯一微信进程归属，再限时寻找候选，数据库候选须匹配所选库salt及HMAC。图片恢复依赖至少两个独立本地V2样本；随后实际读取仍逐文件校验。默认数据库阶段30秒/512MiB、图片阶段最多20秒/256MiB；不注入、不发送、不扫描其他账号，不改变系统防护。

当前原数据的只读归属探针结果为：持有文件的进程0，对应微信持有者0。没有进行无归属的内存读取。未持有的迁移副本在冻结程序中也正确失败。因此本轮确认了组合密钥解密和取钥失败处理，未确认当前真实微信进程成功恢复密钥。仅有加密副本不能通用破解AES密钥；匹配已有密钥或受支持的本机登录态仍是必要条件。

## 复现与证据位置

开发者相关回归：

```powershell
$env:PYTHONPATH='.runtime/offline-build-deps;web_mvp;scripts'
python -X utf8 -m unittest web_mvp.test_runtime_identity web_mvp.test_windows_hook_smoke.SourceBindingTests test_offline_chat test_offline_cli test_offline_desktop test_offline_view test_offline_media_search test_offline_batch test_portable_key_recovery test_acquire_database_keys test_database_snapshot test_database_adapter test_windows_media test_database_service
python scripts/check_runtime_identity.py
```

私有本机聚合证据：`.runtime/offline-portability-v4/relocation-validation.json`、`skill-validation.json`、`binary-imports.json`。这些不包含密钥正文。隔离验证器只复用用户已选择的数据与基线，不扩大扫描范围。

v4 EXE SHA-256：`b14247e80b8d508c8d15220091447a162dfcee08ff56719ee7ec24267af036ac`；25,472,825字节。分发包不包含真实聊天、密钥、settings.local.json或账号数据库。
