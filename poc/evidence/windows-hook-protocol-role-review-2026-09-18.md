# Hook 协议候选角色核验

本轮完成固定磁盘模块的引用复扫、18 个展开表函数范围的反汇编，以及 45 处引用的指令边界核验。没有附加微信或读取运行时对象；这是候选定位进展，不是收消息成功。

## 对上轮线索的修正

| 线索 | 逐条核验结果 | 当前用途 |
| --- | --- | --- |
| new_sync 的两处引用 | 实际引用 `new_sync.cc` 文件名；其中一个函数同时出现 `CoDoSync`、`LoginFlow CoDoSync end` | 同步相关研究线索；不能视为实时消息接收函数或协议 URL |
| AddMsg 的四处引用 | 四处全部引用 `HistoryAddMsgInfo`；其中一处函数还引用 `HistorySysMsgInfo` | 降低作为实时入站断点的优先级；不能仅凭名字证明函数只处理历史消息 |
| OnPush 的六个函数范围 | 四个具有 Mars 网络/桥接/任务推送名称，另两个为 `OnPushXLabExptItems`、`OnPushExptAppItems` | 排除把实验配置推送误当聊天推送；优先研究网络到业务的桥接 |
| Buf2Resp 的六个函数范围 | 五个具有 StnManager、MMStnManager、CallbackBridge、AccountCore、ActionTaskManager 名称；一个出现 `Buf2RespTime:` 等统计标签 | 响应处理相关候选与统计代码分开；不能把所有名字命中都当解码入口 |

名称来自函数内引用的磁盘字符串，不是调试符号，也不保证整个函数与字符串名称一一对应。

## 新的可操作定位方向

`OnPush-4` 含 `virtual mars::stn::StnCallbackBridge::OnPush` 和 `stn_callback_bridge.cc`。反汇编显示它从对象成员取得另一个对象，加载虚表后执行间接调用。

`Buf2Resp-2` 含 `virtual mars::stn::StnCallbackBridge::Buf2Resp`，同样通过对象成员和虚表执行间接调用。

这提供了比单纯旧版字节迁移更明确的层次线索：**先研究网络回调桥接到具体业务实现的关系**。但两个虚调用的实际目标尚未解析，不能据此宣称已找到消息回调；不记录公开可复用偏移，也不读取运行时载荷或会话密钥。

18 个已查看函数范围中未发现直接 `call` 到原 R4 外层入口。这只能排除这些范围里的直接调用，不能排除尾调用、间接调用、多层调用或异步队列关系，不能判定旧候选无效。

## 验证方式与产物

- 重复执行上轮扫描，报告与首次逐项一致。
- 用 `PEImage.function_at` 确定展开表范围，随后对各完整范围执行 `objdump -d -M intel --insn-width=16 --start-address=... --stop-address=...`。没有从命中字节中间开始反汇编。
- 核验 new_sync / AddMsg 的 6 处、OnPush 的 12 处、Buf2Resp 的 27 处引用：45 处均出现在范围起点顺序反汇编的指令边界。
- 原始范围、反汇编及名称清单保存在忽略目录 `.local/hook-round1/protocol-*`；公开记录为 `windows-hook-protocol-reference-validation-2026-09-18.json`、`windows-hook-protocol-callback-validation-2026-09-18.json`。

顺序反汇编提高字节匹配的可信度，但不能证明对应指令运行过，也不自动证明控制流可达。

## 下一阶段完成判据

下一阶段优先静态追踪两个桥接对象的构造、注册和虚表关联，尝试辨认具体业务回调，再与同步函数和旧候选交叉验证。需要至少两类独立证据支持角色，例如注册/虚表关系加调用行为；只出现同名日志不够。

若静态关系不足，再设计一次能区分网络回调、业务分发及观测覆盖的有界动态验证；不能把桥接点的任意网络命中当成目标群消息命中，也不能将 UI 线程对照当成接收线程覆盖证明。当前不需要用户再次发送标记，未准备 DLL 注入或自动发送。
