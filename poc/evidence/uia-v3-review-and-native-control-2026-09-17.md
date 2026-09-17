# v3审查与E0-N合成验证

## 结论

用户授权“先审查再尝试”。完成附件/本地源码及收据复核，随后实现并执行合成原生provider对照。N0修正启动器PID识别后通过；N1/N2/N3通过。没有形成改变旧微信外壳结论的新证据，本轮不运行微信E1/E2。

此处“通过”仅指合成诊断验收，微信聊天读取仍blocked。未登录、重启或扫描微信；没有发送、OCR、取钥、读聊天库、改注册表或客户端内存，没有M3请求、commit/push。

## 一、附件与本地审查

- ZIP仅有manifest、历史JSON模板、v3审查文、交接文，无可执行脚本；逐项流式读取，没有解压执行。manifest列出的3个文件SHA256均匹配。
- 历史模板确实在本包存在；不修改此前“执行端未找到模板”的历史说明，不倒填旧收据。
- 当前v2脚本SHA256为`7b2c15ca2335f3181fbae35623772098858985cb7f5ddf086aaaaf646673f523`，与修正版E0和E1完全一致。首次E0旧哈希不同，与此前修改过程相符；本次没有以当前源码冒充旧版本。
- 三份收据的run_id、10/10/3节点、截断false、初次E0失败/修正版通过、E1仅外壳，与报告相符。
- `UiaHasServerSideProvider`原实现使用c_void_p参数、c_int返回，符合BOOL(HWND)，没有把false解释为HRESULT或GetLastError。
- `GetCurrentPropertyValueEx(..., True)`和IUnknown身份比较用于识别ReservedNotSupported；实际属性ID为30040/30119/30043/30090/30108。没有发现旧脚本执行直接GetCurrentPattern的证据，故旧结论仅限属性层。
- 来源只留白名单标签，异常不保存原文；MTA采集不拥有窗口，15秒看门狗针对自建采集子进程。

审查限制：v2外层对fixture未就绪、报告缺失等异常的收据覆盖不完善；节点属性error没有独立提升整个报告为incomplete。旧E1所测字段无这些错误，暂未发现其已影响历史结论。前后绑定不是原子生命周期锁；不把当前实现称为全面竞态安全。没有为了本轮审查修改历史v2源码或收据。

## 二、合成实现及范围

- `scripts/uia_v3_wpf_fixture.ps1`：使用系统.NET/WPF创建只读TextBox，内容固定为合成字符串，不抢焦点，不装依赖。以WPF内置provider代替手写COM server，实际结果而非框架名称决定是否通过。
- `scripts/probe_uia_v3_native.py`：N0为自建普通Win32窗口，N1为自建WPF窗口；共用v2的MTA客户端、snapshot和属性序列化。每个模式独立run_id；128节点、6层、采集15秒。GUI启动另有10秒就绪预算，不能将它说成整轮15秒。
- 目标来自本次启动进程的ready文件，验证属于该进程或其实际子进程；禁止接受任意桌面对象。对合成Edit执行GetCurrentPattern(10002)，再QueryInterface(IUIAutomationValuePattern)，与30043可用性属性对照。仅N1读取预定义合成Value并保存匹配布尔值；不读取任何微信Value或Text。
- N0/N1是两个框架样本，不是同一个自定义provider开关的严格因果对照。它们足以验证false/true观测分支，不能据此推断Qt桥接或微信内部开关。
- N2接口对应及N3生命周期附着在同一N1实例内，避免更换对象后错误比较。旧COM返回原样保存，存活另判。

## 三、实际执行

| 样本 | run_id | 结果 |
|---|---|---|
| 初次N0 | ee6d1150-2fa8-4d5d-bf8c-6c5ee657cd52 | 归属检查失败，尚未采集；Python虚拟环境启动器PID与实际窗口子进程不同 |
| 修正版N0 | 2de5b667-3372-4f9d-b4e0-a774da31370a | completed、passed=true；server-side=false，Value属性true、接口取得；普通Edit只读属性false，未读取其值；关窗invalidated |
| N1/N2/N3 | 7d3ce764-bcfa-43c5-85fd-e213c3b223f4 | completed、passed=true；11节点未截断、server-side=true、FrameworkId=WPF；Value属性true、有效接口、CurrentIsReadOnly=true、合成值匹配；关窗invalidated |

首次N0因保守PID检查阻断，不是微信失败，也不是provider失败。修复仅允许本次启动进程的实际子进程，未取消归属检查；并补充自建子进程清理。N1在该外层修正前执行，其共用采集路径未变；收据各自保留当时源码哈希，不重写历史。

收尾检查自建`CodexUiaSyntheticFixture`窗口，结果空集合；合成程序已结束。首次收尾枚举的临时检查因回调返回值问题报错，改为显式返回True后完成；未访问微信。

## 四、验证与未覆盖项

- 新增4项离线验收反例，与原5项属性分类测试合计9项通过（退出码0）。涵盖provider=true不足以通过、必须只读且值匹配、截断/目标未失效不能通过、N0/N1分支区分。
- 新脚本语法检查通过；实机合成收据如上。未故意制造COM永久挂起，不宣称超时杀进程路径已实测通过。
- 不把这9项写成微信实机测试，不沿用其他路线测试数。

命令（仓库根）：

```powershell
.\.research\wxauto4-41.1.7-audit\venv\Scripts\python.exe -X utf8 poc\scripts\probe_uia_v3_native.py N0 --output poc\evidence\uia-v3-n0-revised-2026-09-17.json
.\.research\wxauto4-41.1.7-audit\venv\Scripts\python.exe -X utf8 poc\scripts\probe_uia_v3_native.py N1 --output poc\evidence\uia-v3-n1-2026-09-17.json
```

这是执行记录；未来复验用新文件名，不覆盖收据。

## 五、判断与后续

已补齐“同一采集路径确实能够观察到server-side=true”的正对照；属性和直接ValuePattern接口在本次WPF样本中一致，没有发现所谓隐藏接口或旧探针总返回false的缺陷。

E1/E2继续not_run（本轮），旧E1结果保持其原有状态范围。原群账号、消息身份、原生@和发送能力均不因合成实验通过而放行。

参考：[Microsoft WPF provider机制](https://learn.microsoft.com/en-us/dotnet/desktop/wpf/controls/ui-automation-of-a-wpf-custom-control)、[GetCurrentPattern接口](https://learn.microsoft.com/en-us/windows/win32/api/uiautomationclient/nf-uiautomationclient-iuiautomationelement-getcurrentpattern)。上述官方机制是样例依据，不是微信兼容性承诺。

原始收据：[首次N0](uia-v3-n0-2026-09-17.json)、[修正版N0](uia-v3-n0-revised-2026-09-17.json)、[N1/N2/N3](uia-v3-n1-2026-09-17.json)。
