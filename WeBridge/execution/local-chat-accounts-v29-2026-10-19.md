# 账号选择与进程归属检查：v29 / Skill 1.17.1

日期：2026-10-19。基线：ff1c8c3。检查范围为个微、企微账号目录与实际数据库持有进程的匹配，以及账号设置交互；不读取进程内存、不恢复密钥、不解析或导出真实聊天。

## 原因与修改

截图中的个微账号选择沿用已保存配置，而扫描推荐了另一个实际在用的目录。原提示“已对应唯一运行账号”没有说明当前选择与推荐不同。该现象不意味着当前进程名不受支持。

- 两端下拉框标明已保存配置；状态提示直接描述当前选择，不把其他目录的占用证据当作所选目录的证据。
- “选择已确认的运行账号”只修改待确认表单；换账号时清空旧密钥引用与本人ID，成功校验后才保存。当前选择、重新扫描与通用按钮刷新保持一致。
- 个微账号根目录与db_storage子目录均以实际数据库目录匹配，重复别名合并；企微保留Data子目录支持。
- 部分目录无法查询、发现路径失效或检查超过上限时标记未知，不声称未占用，也不推荐唯一账号。多个持有进程仍要求明确归属。
- 保留原有进程名校验及PID创建时间校验；识别仅用文件占用和进程元数据，不靠目录名称、主进程数量或固定账号猜测。

## 当前本机只读实测

| 客户端 | 实际运行版本 | 目录与持有进程结果 |
| --- | --- | --- |
| 个微 Weixin.exe | 4.1.15.13 | 发现2个目录，1个在用；已保存目录不是该在用目录，原配置保留 |
| 企微 WXWork.exe | 5.0.12.6018 | 发现4个目录，3个在用；各自匹配实际持有进程，已保存目录在其中 |

修复前后均查询当前文件占用并核对可执行文件名、PID及创建时间。两端自动配置所用的进程归属前置检查与上述扫描一致；该步骤没有调用内存扫描或密钥恢复。发现多个子进程不等于多个账号，表中在用数量来自各目录的实际文件占用。

两端已保存数据源和明确引用的密钥文件摘要与本次基线一致，各自真实导出目录新增数量为0。真实账号路径、身份及密钥不放入本记录或交付包。

## 验证

- 合成Tk界面先复现旧提示失败，再验证个微、企微的保存账号标记、显式运行账号选择、密钥引用隔离、重新识别和不保存不导出行为。
- 归属查询失败、检查截断和个微上级目录别名的三个回归先失败后通过。
- 42项相关检查通过：test_offline_accounts、test_offline_setup_integration、账号切换GUI场景、test_acquire_database_keys、test_runtime_identity、SourceBindingTests。首次组合运行遇到既有测试对Windows临时目录短路径的字符串断言差异；规范化该次测试进程的TEMP/TMP后通过，生产取钥代码未改动。
- check_runtime_identity.py通过，105个文件、0问题。
- EXE中local_chat_app、offline_desktop、offline_review、offline_profiles、offline_accounts、acquire_database_keys六模块冻结代码对象与最终源码一致；GUI版本v29。
- 桌面、个微和企微ZIP的25/30/31个清单文件摘要、ZIP CRC、解压内容、客户端绑定、版本和EXE摘要一致，不含账号配置、密钥、数据库或聊天导出。
- 两个实际Skill包在无外部Python环境的合成DataDir启动，均停在awaiting_review、ok=false、正式导出数0；直接Export均拒绝。

本次进程匹配实测不等于重新验证当前版本取钥、真实聊天解析或WorkBuddy宿主导入及人工复核链路；这些不作为本次通过结论。

## 交付物

| 文件 | SHA-256 |
| --- | --- |
| local-chat-desktop.exe（v29） | eda48f700e2eab9fdb4a0e6e4036dd153ed8866fc8d7bb1a791fd5400c50281c |
| local-chat-review-v29-20261019-windows-x64.zip | 0b3691894f154202c2ac986506a3255a204902f35128bb6b66ef7abcae422da3 |
| WeChat-Archive-Skill-1.17.1-Windows-x64.zip | ec0031161541dcb9d80c0bfdf567940826bc3c2c42d7cbba0627245bb969e6f1 |
| WeCom-Archive-Skill-1.17.1-Windows-x64.zip | b43bba41aa3ffad681c46a8ce2771a7c43b9a38720b44115e6c66e06e2725586 |

交付包留在本地build；旧包和既有配置保留。源码、指南与本记录同步远端。新版窗口标题为v29，已打开的旧窗口不会自动更新。

本地私有验证回执：.runtime/account-v29-live-check.json、.runtime/account-v29-package-check.json、.runtime/skill1171-packaged-launcher-check.json。
