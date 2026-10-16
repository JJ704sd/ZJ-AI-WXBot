# v5：一句话解析并打开

日期：2026-10-16。Skill版本1.1.0；Windows10 x64、Windows PowerShell5.1。

## 用户操作

导入并启用最新 Skill，在 WorkBuddy 新任务中说“解析示例混合群”或其他实际群名。Skill从请求取得群名，自动定位自身启动脚本，调用默认解析模式；用户不填写路径、DataDir、长提示词或运行环境。

首次或换电脑时，窗口显示数据设置，选择本机数据和匹配密钥，点“保存并加载”，原群请求自动继续。设置保存在当前Windows用户的 `%LOCALAPPDATA%\LocalWechatArchive`，与Skill安装位置和版本分离。再次调用自动复用，不附带真实配置到分发包。更换账号仍通过窗口的数据设置完成。

本机Skill已更新至1.1.0，旧版完整备份在私有验证目录中。先前已选账号的设置仅迁移文件路径到上述默认目录，没有复制密钥正文；不存在时才创建，不覆盖既有用户选择。运行文件按版本保存，不删除或关闭旧版窗口。

## 实现

- `run.ps1 -ChatName 群名`：默认解析并打开，无需Mode、DataDir、Source或Keys参数；由runtime.json定位并校验随包EXE。
- EXE的 `--open-chat-name` / `--open-chat` 保留待处理请求。首次设置成功后继续，不要求用户重发。指定群不存在或名称重复时在窗口选择，不回退到上次群。
- 完成的导出直接用于原生阅读窗口，包含完整业务上下文、图片、附件入口和转发树；不再先生成阅读副本再重复导出。
- 每次生成独立的本机状态回执：starting、needs_source、needs_chat、parsing、failed、completed。只有completed才表示解析和阅读加载完成；started仅表示进程启动。Skill等待本次回执，不凭启动进程报告成功。
- 原有Desktop、Discover、Groups、Export、RecoverKeys入口保留。取钥仍须用户主动选择，不在普通解析失败时自动触发。

## 已执行验证

| 检查 | 实际结果 |
| --- | --- |
| 回归的red证据 | 新public parse_and_open方法缺失；新GUI参数尚不识别，测试确实失败后实现 |
| 相关源码及窗口回归 | 147项通过；账号检查81文件、0问题；Skill规范校验通过 |
| 首次设置继续 | 自有合成窗口中出现数据对话框，填写源目录并调用实际“保存并加载”按钮后，原请求完成；未重新发出解析请求 |
| 后续复用 | 新DesktopSession仅按群名完成解析；不提供数据或密钥路径；导出文件与阅读内容一致 |
| 真实群冻结EXE | 仓库外中文/空格路径、空白配置、子PATH无Python；3群可列、目标285条全部解码、264条业务记录 |
| 媒体和原生控件 | 19个图片引用显示、1个嵌套转发图片显示、7个转发结构展开、8个引用来源显示、1个图片放大窗口创建；5次附件打开回调通过 |
| 本机已安装Skill短入口 | Windows PowerShell5.1只传ChatName，省略Mode、DataDir及数据/密钥路径；回执completed，285/264条；窗口使用同一导出 |
| Python依赖 | 短入口子PATH不含Python，清除PYTHONPATH/PYTHONHOME；进程树仅随包EXE的启动器和工作进程，未调用外部python.exe |
| 数据保留 | 原数据、原密钥及历史设置摘要保持不变；迁移验证临时聊天和密钥副本已删除 |

媒体可用性保持ready10、preview_only14、pending34；pending包括21个可选表情和13个图片引用。此次只简化调用，不增加本地不存在的原件。

附件回调验证拦截了系统打开边界，不等于PDF/Office默认查看器实际渲染验收。原生控件验证是程序执行证据，不等于屏幕截图人工观察。本轮没有再次操控WorkBuddy对话界面，尚未将其对短句的真实自动识别计为已通过；最新Skill已提供自然语言触发描述与默认单次入口，需要在新任务中加载新版。此前宿主电脑控制截图/输入通道异常不能冒充本轮修复。另一台物理Windows计算机仍未实测。

## 证据与交付

私有聚合证据位于 `.runtime/offline-short-v5/relocation-validation.json`、`default-short-launch-validation.json`、`installed-validation.json`。不包含密钥正文。

EXE SHA-256：`00aafd0877b89893b03f8e44d77dc1a995adf10a5ea3c10f47d279826f0e1efd`。

WorkBuddy技能包：`build/local-wechat-archive-workbuddy-20261016-v5.zip`；版本1.1.0。包内无Python源脚本、真实聊天、数据库、密钥或settings.local.json。桌面独立包另保留；原v4包不覆盖。
