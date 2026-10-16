# 首次配置与选群流程 v13 验收

2026-10-16。桌面v13 / Skill1.6.0。关联任务“修复初配置窗口无法常驻”的记录已读取，并对实际源码、窗口和最终包重新核验；任务记录本身不作为通过证据。

## 交付行为

- 配置弹窗在静置、处理中和校验失败后保留。处理中显示进度、禁重复提交；失败保留输入供原窗重试，成功才关闭并继续原解析请求。
- 账号按数据库文件占用与客户端进程元数据匹配；唯一运行账号可推荐，多账号或归属不明确时保留选择。识别阶段不读进程内存或聊天正文。
- 主窗口显示当前账号目录，支持群名/ID搜索、匹配数、最近使用优先、重名区分；唯一结果可按Enter选择。真正切换账号时清理继承的密钥、本人身份和旧群选择。
- 修复同一账号的上级目录与`db_storage`/`Data`子目录被当作不同账号的问题，已有密钥、本人身份及最近群得到保留。
- 空白配置启动先确认账号；不再按当前工作目录隐式导入工作台。已有设置自动复用，手动导入和显式`--workbench`保留。
- 个微、企微保持独立配置。没有新增使用者环境安装步骤。

## 回归与故障复现

新增公开启动、原生窗口和DesktopSession集成验证，数据为合成副本，仅对操作系统文件占用接口使用替代。

修复前的失败信号：同账号目录别名重新打开后`lastChat`丢失；账号候选框无法选中已配置账号；空白配置在工作目录有工作台时直接返回ready并保存了该账号。相应修复后，原窗重试、账号推荐、配置保留、实际换号清理和显式工作台导入通过。

本轮相关检查91项通过，账号源码检查97文件、0问题。关联任务随后将集成测试的临时目录转换为绝对路径，该测试改进保留，4项集成测试再次通过；未改变最终EXE代码。

运行过的主要命令：

```powershell
python -X utf8 -m unittest web_mvp.test_offline_setup_integration web_mvp.test_offline_accounts web_mvp.test_wecom_archive web_mvp.test_offline_chat web_mvp.test_offline_batch web_mvp.test_offline_cli web_mvp.test_offline_desktop web_mvp.test_offline_open web_mvp.test_offline_images web_mvp.test_offline_view web_mvp.test_portable_key_recovery web_mvp.test_runtime_identity web_mvp.test_windows_hook_smoke.SourceBindingTests
python scripts/check_runtime_identity.py
```

原生测试需要构建机能读取既有Tcl/Tk资源。接收交付包的用户不用安装Python或Tcl/Tk。

## 最终便携版验证

| 范围 | 本次实际结果 |
| --- | --- |
| 四个启动入口 | 桌面/Skill的个微、企微入口，中文空格解压路径、隔离新配置、无Python PATH；启动器退出12秒后账号配置窗口仍可见 |
| 个微真实群 | 285条源消息、264条业务阅读；原图6、缩略图20、缺图18；附件5处可用；7个转发结构展开 |
| 个微原生查看 | 图片总览26处显示、44处原消息定位、1个嵌套图片放大、5个附件打开回调、8处已关联引用来源通过 |
| 企微真实群 | 597条源消息、564条业务阅读；原图77、缩略图0、缺图3；附件22处中14处可用；视频5处可用；23个转发结构展开 |
| 企微原生查看 | 77处图片显示、80处原消息定位、3个嵌套图片放大、14个附件打开回调通过 |
| 三格式 | 两边JSON与JSONL字段及顺序一致；MD分别保留285/597条根消息和出处；32/94项产物摘要通过 |
| 配置 | 复用既有配置引用，未重新取钥；两套原配置文件摘要未变 |
| WorkBuddy安装 | 本机Skill1.6.0的26文件校验通过，保留旧版备份；已安装脚本的企微Export入口返回ok=true、597条及三格式入口 |
| ZIP | 3个ZIP、全部清单摘要、说明链接、许可、白名单通过；未列入清单的合成私有文件被排除，篡改输入EXE被拒绝 |

补入本次实测说明后重新打包，仅文档变化；EXE、CMD及PowerShell启动脚本与已通过四入口常驻检查的版本逐文件相同，重新核验了最终ZIP和全部文件摘要。

媒体按引用出现次数统计，不按文件去重。表情缺失按用户要求不阻塞业务阅读。附件验收到打开回调边界，未逐一验收外部查看器；本轮未通过WorkBuddy模型发起自然语言任务，也未点击宿主文件卡片。企微仍有1条邮件卡片未完整适配，引用回复、语音原件等边界沿用使用说明。

私有验证JSON、安装回执和源码冻结清单位于`.runtime/setup-flow-v13-20261016/`，未纳入交付包。其他物理Windows电脑及Windows11尚未实测。

## 最终文件

- [完整交付包](../build/WeChat-Archive-Windows-Delivery-20261016-v13.zip)
- [桌面包](../build/WeChat-Archive-Desktop-v13-Windows-x64.zip)
- [Skill包](../build/WeChat-Archive-Skill-1.6.0-Windows-x64.zip)
- [操作指南](../docs/local-chat/操作指南.md)

EXE SHA-256：`bfb773702d361393dbbe0a05563fb39d1ccc1393f107198444b4d5b637cfc4f1`。

总包 SHA-256：`c9e16be73edce471f47a3cd135233214af061de835741a820b43fb4997c5c14b`。
