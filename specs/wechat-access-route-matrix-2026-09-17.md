# 微信接入机制分流与验证结果

## 目标和当前结论

原测试号、原个微/企微混合群，可靠接收真实@后回复，后续定时询问。不能以单聊、其他群或仅有HTTP接口替代验收。用户要求从不同方案尝试且尽量规避风险；继续保留不修改客户端内存、不取钥、不降级、不OCR、不自动登录或发送的边界。

当前没有同时满足原目标、现有环境和这些边界的已验证接入路径。不是宣称所有技术途径绝对不可行。

## 本轮实际执行

### 新的Windows客户端接口对照

新增 `poc/scripts/probe_uia8.py`，直接用comtypes创建CUIAutomation8，完全不导入wxauto4。微软说明该对象的部分代理行为与旧版CUIAutomation不同，因此这是有依据的兼容性对照。

先执行py_compile成功；随后在隔离环境执行一次20秒有界探针，退出码0、约0.57秒。唯一窗口、最小化，根Qt51514QWindowIcon；2个后代（MMUIRenderSubWindowHW、空类名标题节点），无截断。仍无聊天控件。本次并非与旧客户端同时采样，不能推断在所有状态下两者绝对等价。

命令：`.research\wxauto4-41.1.7-audit\venv\Scripts\python.exe -X utf8 poc\scripts\probe_uia8.py`。

### 其他路线本地前置核查

- 861：`poc/.local/pad-legacy-861/runtime`存在；默认`device-key.private.json`不存在，路径与apply_pad_861_license.py一致。没有读取凭据值，没有尝试重新签发、启动网关或扫码。历史上游失败未联网复验。
- 本机端口查询发生CimException，端口状态unknown，不能据早先静默输出写成“未监听”。
- 手机端：Get-Command adb无结果，仅证明PATH不可调用，不证明机器绝无SDK或未连接手机。未安装、启动ADB、枚举聊天或更改设备设置。
- 已检查Git状态，保留用户现有暂存改动；未commit/push。

## 按机制分流

| 机制 | 本轮/已有证据 | 接下来必须满足的条件 |
|---|---|---|
| Windows标准无障碍 | 多个入口已实测外壳；本轮CUIAutomation8同样失败 | 客户端实际暴露聊天provider，才能继续绑定和消息身份核验；不再重复无新假设的激活 |
| 腾讯官方微信插件/iLink | 本轮源码channel.ts声明chatTypes仅direct；协议中的group_id不是功能保证 | 原群支持与成员/真实@的明确证据；不能把单聊Bot当账号接管 |
| 已有非MAX 861协议网关 | 本轮默认设备key文件不存在；历史停在上游签发 | 匹配构建的有效设备授权或明确上游恢复证据；再进入单号只读采样，不能绕过授权 |
| 其他第三方协议/GeWe | 保留已有adapter；尚无本轮可调用、已授权的真实后端 | 后端、服务授权、原混合群语义和真实样本；免费/安全不可仅据宣传推断 |
| 手机端系统无障碍 | 本轮仅检查到adb不在PATH | 专用测试设备与用户明确设备访问范围；再验证原群控件、消息身份及原生@，仍不能保证无风控 |
| Hook/内存热激活 | 本地既有审查指出旧版本偏移、注入和回滚缺口；热激活涉及进程写入 | 超出现行边界，本轮不执行；即使授权仍需精确版本和可靠回滚，不能直接运行旧DLL |
| 数据库、OCR | 用户明确排除，且不自动解决发送和真实@ | 不作为本轮自动回退 |

## 后续选择

保留原群、原账号目标时，优先解决现有861的真实授权前置或准备专用手机测试环境，而不是继续扩写无控件的桌面Reader。两者目前均未具备完整条件；不安装未知工具或反复签发来制造进展。

若将来接受单聊场景，可单独评估腾讯官方插件，但这是业务范围变更，本轮未实施。不能为了演示成功悄悄替换原群目标。

## 一手来源（本轮读取，分支内容可能变化）

- [Microsoft CUIAutomation8](https://learn.microsoft.com/en-us/previous-versions/windows/desktop/legacy/hh448746%28v%3Dvs.85%29)
- [腾讯插件channel.ts](https://github.com/Tencent/openclaw-weixin/blob/main/src/channel.ts)，capabilities.chatTypes仅direct。
- [腾讯协议说明](https://github.com/Tencent/openclaw-weixin/blob/main/docs/protocol_zh_CN.md)，字段存在不保证功能支持。
- [OpenClaw官方微信接入说明](https://docs.openclaw.ai/channels/wechat)，当前只声明单聊能力；未安装其插件。

源码核查、语法检查、实机结构观察分别报告。本轮未跑业务回归，无业务实现改动，没有账号/群绑定、消息读取、发送或M3请求。
