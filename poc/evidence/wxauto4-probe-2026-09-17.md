# wxauto4 锁定安装与单次只读能力探测

日期：2026-09-17。本轮结论：**UIA准入未通过；ChatInfo未执行成功。已停止，不重复激活。**

## 依赖与审阅

官方元数据来源：https://pypi.org/pypi/wxauto4/41.1.7/json 。下载CPython 3.12 Windows amd64 wheel，SHA-256核对一致：

`096a365ba71060c1af3c1f096342d5a16609452f51bcaf46e7359dd54235ebbf`

固定wxauto4==41.1.7。完整15包版本及允许的分发哈希见 [锁文件](../requirements-wxauto4-probe.lock)。使用uv require-hashes及only-binary安装到 `.research/wxauto4-41.1.7-audit/venv`，未修改poc/.venv、pyproject或uv.lock。没有运行wechat-kefu入口、wxauto4控制台入口或pywin32安装后辅助脚本。

已静态查看wheel目录、METADATA、entry_points、__init__.py、wx.pyi、param.py及logger.py。包自述适用4.1.8；Requires-Python为>=3.9,<3.14。包METADATA未声明许可证、wheel未附许可证文件；不能把wechat-kefu的MIT许可证推定给wxauto4。

实际核心wx、ui/main、ui/chatbox等为.pyd二进制，源码不可见；wx.pyi仅是接口声明，不证明构造器/ChatInfo内部副作用。导入初始化COM；构造声明resize默认true；外围日志默认写文件。探针显式resize=False、debug=False、ads=False，导入后关闭文件日志，子进程stdout/stderr丢弃，只回传结构化能力结果。未声称完成二进制内部或全部依赖源码审计。

## 验证顺序与结果

1. 本轮12项离线测试通过：既有9项会话读取反例＋3项探针超时/缺报告/结果测试。没有实机调用。
2. 隔离环境默认探针报告installed=true、live_requested=false、status=not_executed。
3. 文件版本读取：`C:\Program Files\Tencent\Weixin\Weixin.exe` FileVersion/ProductVersion均为4.1.13.65；未重启或降级。
4. 明确授权的桌面上下文中只启动一次30秒上限子进程；耗时约2.1秒返回如下结果：

```json
{"wxauto4_installed":true,"live_requested":true,"message_read":false,"sent":false,"binding_verified":false,"wxauto4_version":"41.1.7","status":"uia_probe_failed","constructor_entered":true,"chatinfo_called":false,"error_type":"Exception"}
```

该次结果表示已进入WeChat构造调用但未成功构造，未进入ChatInfo。只保留异常类型，原始文本被丢弃；**具体根因未定位**，不将旧Qt外壳证据写成本次观察。没有超时或自动重试，没有第二次激活。

| 证据层 | 判定 |
|---|---|
| 源码/文档自述 | wxauto4说明适用4.1.8，不证明4.1.13.65可用 |
| 合成验证 | 12项通过 |
| 真实驱动构造 | 未通过 |
| 真实ChatInfo/会话控件可见 | 未执行成功，不能确认 |
| 账号/群独立绑定 | 未执行 |
| 新消息可读 | 未执行 |
| 真实@可靠 | 未执行 |
| M3、发送、定时 | 未执行 |

## 停点

按用户要求停止此轮UIA激活，不构建伪造账号/群观察的真实后端。保留已完成的离线UiaSessionReader及探针，保留861/API和已有用户改动。未commit/push。若以后有新兼容版本或明确新诊断范围，再另立运行；本报告不授权重跑、降级、OCR、取钥、发送或自启动。
