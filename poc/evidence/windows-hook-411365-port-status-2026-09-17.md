# 微信 4.1.13.65 定向适配进度

执行日期：2026-09-17。状态：静态定位准备已实施，实际收发适配未完成；没有生成可用的注入 DLL。

后续更新：用户已批准并完成一次有界动态实验，见[实验收据与结果](windows-hook-411365-dynamic-probe-2026-09-17.md)。下文未授权表述保留为静态阶段历史，不覆盖后续明确授权；实验未得到可用接收入口。

## 本轮完成的改动

- 新增 `wechat_agent_poc/hook_target_analysis.py` 和 `scripts/analyze_hook_target.py`：按显式文件路径只读分析 x64 PE，提取节区、异常处理函数区间及旧版地址在新版中的位置，保留 `usable_for_hook=false`。
- 新增 `tests/test_hook_target_analysis.py`：覆盖 PE 截断、架构、异常目录、虚拟尾部、函数边界及静态结果不能提升为真实可用等行为。
- 建立[本机目标配置](windows-hook-411365-target-profile-2026-09-17.json)，固定 4.1.13.65/x64；公开哈希已脱敏。7 个运行时入口全部为 null/unresolved，消息结构偏移不继承旧版，收发均禁用。
- 保存[本机文件基线](windows-hook-411365-observed-2026-09-17.json)、[静态分析结果](windows-hook-411365-static-analysis-2026-09-17.json)和[适配就绪结果](windows-hook-411365-readiness-2026-09-17.json)。目标文件匹配，但就绪仍为 unknown，因为运行时适配证据尚未完成。

这轮新增代码处理的是适配分析与目标约束，并没有实现新版收发函数。旧版候选证据和配置保留，不通过篡改其版本号将其伪装成新版。

## 本机二进制实际发现

读取的是安装目录中的 DLL 文件，不是进程内存；未加载、修改或复制回原文件。PE 为 x64；异常目录已读取，但基址、文件布局和详细条目数不公开；这些是 unwind 区间记录，不等于有完整符号的业务函数数量。

| 旧版名称 | 地址 | 新 DLL 中对应的 unwind 区间 | 结论 |
|---|---|---|---|
| DoAddMsg | 已脱敏 | 未找到覆盖区间 | 不能确定该处指令或接收语义 |
| GetCoroCtx | 已脱敏 | 命中已有区间 | 在区间内部，不是原函数入口 |
| GetMsgSvc | 已脱敏 | 命中已有区间 | 在区间内部 |
| GetMsgCtx | 已脱敏 | 命中已有区间 | 在区间内部 |
| DoSend | 已脱敏 | 命中已有区间 | 在区间内部 |
| SendEntry | 已脱敏 | 命中已有区间 | 在区间内部 |
| MsgCtor | 已脱敏 | 命中已有区间 | 在区间内部 |

区间信息本身不能确认函数语义，也不能证明所有旧地址都不是合法指令边界。进一步反汇编确认：至少一个旧候选实际落在多字节指令内部。直接沿用该地址安装断点或调用，连指令边界都不满足。

只搜索 6 个已知名称的 ASCII 锚点：DoAddMsg、OnAddMsg、GetMsgSvc、GetMsgCtx、MsgCtor 未命中；SendText 命中一次，但位于串联名称数据中，不能据此确定发送函数。一次限定形式的 RIP-relative LEA 候选扫描未找到对应直接引用；这不是穷尽反汇编，也不能证明没有相关调用。没有将任何搜索结果升级为新 RVA。

本地反汇编证据在 Git 忽略目录 `.local/hook-round1/411365-legacy-coro-disassembly.txt`。没有读取用户消息或导出聊天内容。

## 修正上一轮仍未知的信息

- 本轮从 GitHub connector 成功读取了固定 commit `fbccd52713f8cc7cd1023f852bf625af4fe38624` 的 [native/seh_bridge.c](https://github.com/navysoto/wxhook/blob/fbccd52713f8cc7cd1023f852bf625af4fe38624/WeixinHookCs/src/WeixinHook.Native/native/seh_bridge.c)，原生桥接源码确实存在。上一轮的“完整性尚未核实”不应解释成“仓库一定没有源码”。
- 该桥接使用 Windows SEH、线程上下文与协程发送路径；源码返回的是内部调用执行状态，仍非双端送达证明。完整构建与所有依赖可复现性未验证。
- `dotnet --info` 当前显示 .NET 8.0.6 运行时，但无 SDK。PATH 中有 MinGW objdump；未找到 cl/msbuild。运行时存在不能满足 NativeAOT 构建要求，本轮未安装 SDK 或工具链。

## 测试及命令

工作目录：仓库 `poc`。

```powershell
.\.venv\Scripts\python.exe -X utf8 -m pytest tests/test_hook_target_analysis.py tests/test_hook_compatibility.py --basetemp=.local/hook-round1/pytest-target-1 -o cache_dir=.local/hook-round1/pytest-cache
.\.venv\Scripts\python.exe -X utf8 scripts/analyze_hook_target.py --dll 'C:\path\to\Weixin\4.1.13.65\Weixin.dll' --output evidence/windows-hook-411365-static-analysis-2026-09-17.json
.\.venv\Scripts\python.exe -X utf8 scripts/check_hook_compatibility.py --observed evidence/windows-hook-411365-observed-2026-09-17.json --candidate evidence/windows-hook-411365-target-profile-2026-09-17.json --output evidence/windows-hook-411365-readiness-2026-09-17.json
```

测试实际结果：26 passed / 0.26s，退出码 0。静态分析退出码 0；目标门禁输出 unknown、退出码 1，符合“模块匹配但适配未验证”的预期。再次生成证据需使用新的输出文件名，已有文件不会覆盖。

## 尚需完成的实际适配工作

必须重新确定接收入口、六个发送相关入口、对象字段和线程/生命周期语义。目前只有旧 RVA 的源码清单，没有旧版二进制机器码/符号或新版动态调用证据，不能可靠建立新旧函数映射。相邻函数地址、相同节区或相似开头都不足以填入可运行配置。

下一步有两个入口，不要求同时采用：

1. **离线比较**：提供来源可信的 4.1.11.52 `Weixin.dll` 本地路径，按哈希保存旧版参照；仅作为数据，不安装、不启动旧微信。比较函数和交叉引用，产出候选入口后仍需动态核实。此步骤不要求客户端降级。
2. **独立动态适配实验**：在没有旧版参照时，对本机 4.1.13.65 的指定进程进行有界调试，取得调用路径与对象结构。它是研究定位，不是“已有适配 DLL 的 V3 验收”，不以静态门禁 go 为前提，但需明确允许相应进程操作。

动态实验最小范围建议：仅定位接收路径，允许附加调试、必要暂停/单步/断点观察；只使用指定测试账号和群的标记样本；禁止注入未经适配的旧 DLL、取数据库密钥、主动调用发送函数或自动回复。调试断点/上下文操作不称为纯只读。限定一次附加、最多 10 分钟、最多 3 条人工标记消息；发生崩溃、卡死、登录异常、身份不符立即停止，不自动重试。开始前必须确定目标 PID、工具、数据范围和已授权的异常退出/恢复方式。这是待批准的具体范围，不是已经执行的动作。

用户当前要求针对本机适配已覆盖本轮本地代码调整与静态分析；前序 Spec/交接中“不执行进程内存读写、DLL 注入”等边界未被明确解除，故本轮没有擅自进入上述动态实验。SDK 缺失属于后续构建准备，安装工具链也不能替代缺失的函数定位证据。
