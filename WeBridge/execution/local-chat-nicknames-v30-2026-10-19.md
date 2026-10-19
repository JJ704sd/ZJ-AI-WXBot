# 本地账号昵称展示：v30 / Skill 1.18.0

日期：2026-10-19。基线：9b60a80。目标为在个微、企微账号列表和主界面展示可读取的本地昵称/名称，辅助人工区分账号。

## 实现与边界

- 新增offline_account_profiles账号资料读取接口，DesktopSession.scan_accounts组合原有进程归属与名称资料，GUI不按昵称决定账号选择。
- 每个目录只读取contact/contact.db（兼容contact.db）或user.db，稳定复制及验证已提交WAL后再查询副本；复用已有解密、WAL和SQLite完整性校验组件，不打开原始SQLite库。
- 只使用当前客户端配置明确引用的密钥和本工具keys目录的最多16个既有文件，不扫描进程内存、不恢复其他账号密钥、不读取消息库或导出聊天。
- 优先精确查询与所选数据源匹配的已配置本人ID；没有时，目录ID仅用于精确查找联系人/用户记录，不自动设置selfId，不作为进程归属或认证依据。
- 个微取nick_name，不把remark或其他联系人名称当本人昵称；企微优先name，缺省时使用real_name。名称是本地缓存资料，可能滞后于客户端。
- 列表显示名称、目录、占用状态、PID及已保存配置标记；说明匹配依据。相同昵称仍按目录区分。未取得名称保持明确状态，不改变原进程证据或保存配置。
- 加密资料无匹配既有密钥、身份不明、重复身份记录、来源变化、格式不支持或超过读取预算时不猜名称。用户完成该账号配置后可重新识别。
- 限制为最多32个发现账号、单个资料库或WAL不超过64MiB；批次10秒后不再开始新的资料读取。临时资料副本读取后清理，不新增持久化昵称配置格式。

## 当前本机验证

| 客户端 | 发现目录 | 识别在用目录 | 可读取名称 | 其余状态 |
| --- | --- | --- | --- | --- |
| 个微 | 2 | 1 | 1个已配置账号，当前未检测到占用 | 当前在用账号的资料库缺少匹配既有密钥，明确needs_key |
| 企微 | 4 | 3 | 1个已配置且在用账号 | 其他3个目录的资料库缺少匹配既有密钥，明确needs_key |

不能将“已增加昵称功能”视为“全部运行账号已取得昵称”。本次没有为补齐名称读取其他账号进程内存或触发取钥。名称及账号ID仅在本机私有验证记录和应用界面使用，不提交远端，不进入ZIP。

两端数据源配置与明确引用密钥的摘要保持不变，各自真实导出目录新增数量均为0。

## 相关验证

- 昵称模块9项通过：个微精确ID和字段选择、企微本人用户匹配、配置ID与数据源隔离、禁止用联系人备注代替昵称、未知身份降级、已提交WAL、重复身份拒绝猜名、缺少现有密钥时保留进程证据、匹配既有企微密钥解密。
- 两端合成GUI通过：名称进入正确账号选项和来源提示，显式选择在用账号，重新扫描及配置保留，不保存或导出。
- 账号选择、首次配置、启动与动态身份关联检查通过。先执行32项相关组合，再执行包含新增密文资料场景的10项针对性检查；未重复完整解析引擎回归。
- check_runtime_identity.py：106个文件，0问题。
- 七个冻结模块与最终源码代码对象一致：local_chat_app、offline_desktop、offline_review、offline_profiles、offline_accounts、acquire_database_keys、offline_account_profiles；GUI版本v30。
- 桌面/个微/企微ZIP的25/30/31个清单文件，CRC、摘要、解压内容、版本、客户端绑定均通过；没有账号配置、密钥或聊天数据。
- 两个实际Skill包在独立合成DataDir启动，均返回awaiting_review、ok=false，正式导出0；直接Export仍被拒绝。本结果不表示WorkBuddy宿主导入已实测。

## 交付物

| 文件 | SHA-256 |
| --- | --- |
| local-chat-desktop.exe（v30） | ce0526c5374835d291b5cddb250030625426b30db1d0b36e26aed988fb7918d3 |
| local-chat-review-v30-20261019-windows-x64.zip | 90158d048eb3738e089aacd6fefa59dfefbbabcddf0abb1c82101998955e743b |
| WeChat-Archive-Skill-1.18.0-Windows-x64.zip | 5310a822ec4bc923086280c5fb941e7db0043f42d119368fba0610c43afef52e |
| WeCom-Archive-Skill-1.18.0-Windows-x64.zip | b5f236e88fcb4ccfad81711fdde6de49853735febcc809c3084fe9464007fb32 |

ZIP保留于本地build，旧版本保留。新版标题为v30；已打开旧窗口需重新打开新版才更新。源码、Skill说明、指南和本记录同步远端。

私有本地回执：.runtime/nickname-v30-live-check.json、.runtime/nickname-v30-package-check.json、.runtime/skill1180-packaged-launcher-check.json。
