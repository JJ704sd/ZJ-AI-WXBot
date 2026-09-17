# Hook 第一轮候选核查

实际执行日期：2026-09-17。结论：blocked；已完成可访问源码的定点审查，未完成全仓源码/构建依赖完整性审查，未运行第三方程序。

## 固定来源与限制

- navysoto/wxhook：固定 `fbccd52713f8cc7cd1023f852bf625af4fe38624`，通过公开 commit 页面及该 commit 的 raw 源文件核对，不将 main 当不可变版本。
- aixed/WeChat-Hook：固定发布 tag `v411027_`，commit `53ba84edec4414c48abcbe86d6efa98eac1fcbfd`。[发布页](https://github.com/aixed/WeChat-Hook/releases)记录目标 4.1.10.27；二进制与完整源码的对应关系未核实，未下载执行。
- WeChatFerry：前序调查固定到发布 tag `v39.5.2`，目标 3.9.12.51；本轮不重新进行内部源码审查。[发布页](https://github.com/lich0821/WeChatFerry/releases)。
- wxhelper：前序调查为 README 的 3.8/3.9 系列；当前精确 commit 未取得，源码完整性和使用声明未解决，不列为已审查构建。[仓库](https://github.com/ttttupup/wxhelper)。

公开 GitHub API 的本地网络请求先受沙箱套接字限制；获准联网的请求随后遇到 TLS EOF。已改用 web 读取公开的固定 commit 源码，不再重复同一路径。网页缓存可能滞后，本报告仅说明所引用固定版本的内容，不声称它们必然是最新分支状态。

## navysoto 定点源码发现

以下文件均位于上述固定 commit 的 `WeixinHookCs/src/WeixinHook.Native/`：

| 文件/入口 | 实际看到的实现 | 对本项目的影响 |
|---|---|---|
| [WeixinOffsets.cs](https://github.com/navysoto/wxhook/blob/fbccd52713f8cc7cd1023f852bf625af4fe38624/WeixinHookCs/src/WeixinHook.Native/WeixinOffsets.cs) | 声明目标 Weixin.dll 4.1.11.52，固定消息/发送偏移 | 与本机 4.1.13.65 不匹配，不能直接加载 |
| [NativeEntry.cs / InitThread](https://github.com/navysoto/wxhook/blob/fbccd52713f8cc7cd1023f852bf625af4fe38624/WeixinHookCs/src/WeixinHook.Native/NativeEntry.cs) | DLL 附加即启动线程，安装接收和发送 Hook，并启动共享内存服务；此入口未看到精确版本/哈希验证或安装失败后回滚 | 不能把加载称为无采集、无修改试验；需先拆分只接收模式及失败清理 |
| [MsgRecvHook.cs / CaptureFromRsi、ProcessPending](https://github.com/navysoto/wxhook/blob/fbccd52713f8cc7cd1023f852bf625af4fe38624/WeixinHookCs/src/WeixinHook.Native/MsgRecvHook.cs) | 接收使用 INT3/VEH；字段为 MsgId、Type、Timestamp、From、Wxid、Content、Signature；正文缓冲 4096 字节，Signature 256 字节；仅记住最后 ID，零 ID 回退为正文前段指纹；128 槽环形缓冲未看到满队列缺口报告 | 存在截断、重复与零 ID 误去重的静态风险；需明确容量/缺口信号，不能声称全量可靠接收 |
| [MsgSendHook.cs / Initialize、SendText](https://github.com/navysoto/wxhook/blob/fbccd52713f8cc7cd1023f852bf625af4fe38624/WeixinHookCs/src/WeixinHook.Native/MsgSendHook.cs) | 依赖 SehBridge、内部协程线程和硬件断点；入队后等待返回 | 不是普通 HTTP 文本发送；等待结果不能等同双端送达；需要确定超时后的任务生命周期 |
| [ShmServer.cs / WorkerLoop](https://github.com/navysoto/wxhook/blob/fbccd52713f8cc7cd1023f852bf625af4fe38624/WeixinHookCs/src/WeixinHook.Native/ShmServer.cs) | 固定名称的本机共享内存/事件；CmdPop 输出上述字段，CmdSend 直接调用发送函数；此文件未看到独立凭据/请求 ID 校验 | 不是 README 所列 HTTP API；IPC 权限、实例隔离、命令关联及鉴权尚待完整审查 |
| [WeixinHook.Native.csproj](https://github.com/navysoto/wxhook/blob/fbccd52713f8cc7cd1023f852bf625af4fe38624/WeixinHookCs/src/WeixinHook.Native/WeixinHook.Native.csproj) | .NET 8 NativeAOT、win-x64、依赖 native/seh_bridge.lib | 原生桥接源码与构建完整性尚未确认；本机 PATH 未找到 dotnet/cl/msbuild/cmake，不等于机器绝对未安装 |

以上是源码静态判断，未验证实际崩溃、丢失或账号风控。README 对群 @ 等未开源接口的描述不能补足上述公开 IPC 的字段缺口。

## 事件契约缺口

| 所需字段 | 现有证据 | 结论 |
|---|---|---|
| 原生消息 ID | MsgId 为 ulong，可为零 | 大整数必须保留；零 ID 不进入可执行事件 |
| 群/发送者 | From、Wxid 原始字符串 | 混合群语义和跨身份映射 unknown |
| 本人账号、is_self | 未见独立输出 | unknown，不能默认 false |
| 真实 @ 列表 | Signature 字符串但可能截断，无已验证解析语义 | unknown，不能按正文匹配 |
| 引用关系 | 未见专用字段 | null/unknown，不猜测 |
| 历史归属、会话 epoch | 未见可靠输出 | unknown |
| 双端送达关联 | 未见对应回执契约 | unverified |

因此不实现可进入 Runtime 的 hook_decoder，不伪造 account/group/mention 等字段。已有字段布局可作为后续离线字节解析研究输入，但当前不满足业务 decoder 的必要语义。未创建 HTTP 服务、HookChannel 或后台任务。

## 自主适配工作包

1. 固定 4.1.13.65 的目标模块、接收/发送入口及版本防护；本地曾计算安装文件哈希，公开证据已脱敏，尚无定位结果。
2. 确认线程、消息对象生命周期、失败回滚；先拆分只收不发模式。
3. 补足本人/原群/两类成员、真实 @、引用与历史语义；数据库字段不能替代回调证据。
4. 修正可见的截断、队列覆盖及去重缺口，并给出可检测的数据损失信号。
5. 校验原生桥接源码、可复现构建、IPC 权限、请求关联及发送超时行为。
6. 静态证据无法确认的部分需要独立动态适配实验授权；不承诺两天或仅修改偏移即可完成。

进入真机的技术条件尚未具备；即使现在获得注入授权，也不能直接把此旧版本 DLL 用在当前微信上。
