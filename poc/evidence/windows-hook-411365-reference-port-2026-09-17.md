# 4.1.13.65：旧样本取得与接收位置静态迁移

2026-09-17。本轮已取得签名有效的旧模块，并得到一个有具体依据的新版接收中间位置候选。**仍不是已验证的接收 Hook，不启用 runtime profile。**

## 样本来源与身份

从 [canc3s 的 Windows 4.1.11.52 发布归档](https://github.com/canc3s/wechat-versions/releases/tag/v4.1.11.52-win)下载附件，仅静态解包。发布记录的腾讯原地址当前 web 请求返回 404；GitHub API 请求返回 403，最终通过公开附件页取得安装包。没有执行微信安装器或模块，没有降级、登录、附加真实进程。

- 安装包大小和安装器资源版本已在本地核对；公开 SHA-256 已脱敏。安装器资源版本为 4.1.11.1000，不将其误认成客户端版本。
- 包内 `4.1.11.52/Weixin.dll` 的文件版本已核对为 4.1.11.52；公开文件大小与 SHA-256 已脱敏。
- 两者的本机 Authenticode 结果均为 `Valid`，签名主体 Tencent Technology (Shenzhen) Company Limited。下载源为第三方归档，签名验证并不把该归档变为腾讯官网，也不证明它就是作者当时使用的同一文件。
- 新版目标仍按本地文件指纹绑定；公开 SHA-256 已脱敏。

完整身份收据见[acquisition JSON](windows-hook-reference-acquisition-2026-09-17.json)。原安装包与 DLL 仅保存在 Git 忽略的 `.local/hook-round1/`，不提交二进制。

解包工具来自 [7-Zip 官方下载页](https://www.7-zip.org/download.html)所指向的 ip7z/7zip 26.03 发布。使用独立 7zr 提取 7z.exe/7z.dll，再提取 NSIS 内的 install.7z 和指定 DLL；没有安装系统软件。7zr 未签名，来源按官方 HTTPS 下载链记录，不伪称它通过签名验证。7zr 和 7-Zip 包的公开 SHA-256 已脱敏。

## 静态迁移证据

首先用[精确字节比对脚本](../scripts/compare_hook_reference_windows.py)比较旧源码的 7 个位置：DoAddMsg 的 16/32/64 字节窗口均无匹配；GetMsgSvc 和 MsgCtor 有唯一 32 字节线索，其余存在多处匹配或无匹配。没有把这些辅助线索写入运行配置。见[完整结果](windows-hook-reference-comparison-2026-09-17.json)。

随后从旧 DoAddMsg 所在完整函数出发，确认旧位置为**函数内部中间位置**。旧源码也明确使用 mid-hook，并从 RSI+0x18 取对象指针：[固定版本 MsgRecvHook.cs](https://github.com/navysoto/wxhook/blob/fbccd52713f8cc7cd1023f852bf625af4fe38624/WeixinHookCs/src/WeixinHook.Native/MsgRecvHook.cs)。不能把 DoAddMsg 这个名字直接等同函数入口。

|项目|旧 4.1.11.52|新 4.1.13.65|
|---|---|---|
|PE unwind 函数区间|已脱敏|已脱敏|
|候选中间位置|已脱敏|已脱敏|
|该位置指令|结构形式相近|结构形式相近|
|后续 LEA 引用位置|已脱敏|已脱敏|
|引用的常量|长度与唯一性已核对|非执行节唯一匹配|

新版常量只有一个候选 RIP-relative LEA 引用；从对应函数起始位置完整反汇编，确认该引用和中间位置都落在指令边界。两边均为 538 条指令、相同指令长度序列与相对位置。规范化 RIP 地址和外部调用目标后，8 条指令仍有差异；内部跳转目标保留函数内相对位置。

差异包括立即数、乘法常量、对象字段偏移和加法常量变化。它们是**不能直接继承旧对象布局**的反证；未解释为具体业务字段，也没有把相似比例当作成功概率。

可复现脚本：[analyze_hook_receive_candidate.py](../scripts/analyze_hook_receive_candidate.py)。输入绑定两个文件哈希，检查常量和引用唯一性、反汇编连续覆盖、指令边界，输出[候选证据 JSON](windows-hook-411365-receive-hypothesis-2026-09-17.json)。输出固定为 `static_candidate_only`、`usable_for_hook=false`，不改任何运行偏移。外部调用与 RIP 引用目标的语义等价性仍未验证。

## 自建进程验证

[独立夹具](../probes/hook_hardware_breakpoint_fixture.c)只循环调用已知函数 3 次；[验证脚本](../scripts/verify_hook_debugger_fixture.py)编译并由 GDB 启动该子进程，没有 PID 参数，无法选择微信。首次在目标创建前设置硬件断点被 GDB 拒绝；调整为先启动自建进程后设置，第二次报告硬件断点、命中恰好 3 次、夹具正常完成、调试器退出码 0。见[收据](windows-hook-debugger-fixture-2026-09-17.json)。

这个实验只证明已知位置的硬件断点能在自建单线程测试路径命中。GDB start 在夹具内使用临时断点；没有在微信设置任何断点。尚未证明附加模式下的清理、新线程断点覆盖或微信命中语义。32 项相关 Python 测试通过；这和夹具运行均不代替真机接收验收。

## 下一轮具体工作与停点

1. 先扩展自建夹具，验证“附加→硬件执行断点→清除→分离”以及新建线程、超时退出的清理。不能把本轮 launch 测试充当 attach 回滚验证。
2. 离线继续核对候选函数的下游调用与对象步长变化；字段地址未验证前不读真实消息对象、不复用旧布局。
3. 上述准备完成后，才提出一次新的真机候选命中实验：指定原账号/群，最多 90 秒，最多 3 条人工标记；硬件执行断点仅对已脱敏的候选位置，最多 10 次命中后清除并分离。先只记录命中时间和地址，不采集正文/密钥、不注入 DLL、不主动发送。硬件断点会修改线程调试寄存器并暂停线程，仍须具体授权。
4. 命中时间相关性通过也只能证明路径相关，不能证明消息 ID、群映射和正文布局。后续内容读取、DLL 安装和发送测试各自依赖相应证据与范围。

旧报告“缺少旧模块或新版候选”的状态在本轮已被更新；真正剩余的缺口是对象布局、候选运行语义和可靠退出。当前仍不启动第二次微信附加。
