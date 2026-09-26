# Linux 原生接收对象入口静态核查

2026-09-21。此轮只读审阅 workspace 内官方 ELF 副本，没有附加进程、扫描内存、发送消息或读取账号消息。目标是为已通过的数据库副本接收方案提供低延迟优化候选，不改变当前验收结论。

文件：`build/linux/wechat-4.1.1.8-arm64`，AArch64，BuildID `9a3558be209dfcf1b85d6ec18bf029c7f97ccb61`，SHA256 `e40116597803a5e0d9fc4a2b727df4b8f7a3dd6de1c336140ea373be2b6626e9`。以下地址都是此文件的 ELF VA，运行时须加经过核对的 load bias。所有函数界限由 `.eh_frame_hdr` / FDE 与反汇编交叉核对；反汇编中的 `main+...` 是 stripped ELF 的标签，不是函数真实名称。

## 结论与证据等级

已静态确认 `micromsg.AddMsg`、`micromsg.NewSyncResponse` 的对象类型、构造/深拷贝/序列化入口，以及一个把服务器命令内容解析为 AddMsg、再放入消息批次的调用点。**本轮没有证明用户目标混合群的实际入站消息必经这些点**；还不能标成原生接收已实测。主任务报告的普通消息与真实被 @ 接收，来自另行完成的临时 DB+WAL 副本正常 SQLCipher 读取，不是本文件的静态推断。

首选验证点是通用 ParseFromString `0x6b249b8` 的一个精确调用者：`0x498c128` 内 `0x498c188` 的调用，返回地址 `0x498c18c`。仅当对象 vptr 匹配 AddMsg、返回成功、限定群身份匹配时，在原对象仍有效的回调内深拷贝并编码。它比在 MMBuf2Resp 中猜测指针层级更明确。NewSync 批量响应可做备用观测点，但会包含非消息同步命令，过滤与数据范围都更复杂。

证据等级：**A = 官方二进制指令/重定位/类型字符串直接支持；B = 静态数据流支持、业务命名仍须实包校准；C = 未动态验证的覆盖性或性能判断。**

## 首选：AddMsg 完整解析完成点

`0x498c128` 在栈 `sp+0xb0` 构造 `micromsg.AddMsg`，从输入命令的嵌套对象取得一个 C++ string，`0x498c188` 调 `0x6b249b8(AddMsg*, string*)`。返回 false 进入错误分支；返回 true 后读取 AddMsg `+0x14` 的消息类型，分流少量特殊值，其他情况复制 AddMsg 到 `context+0x200` 指向的消息批次。原栈对象在该调用者退出前析构。因此 ParseFromString 的 onLeave 是生命周期明确的候选窗口。（A）

`0x6b249b8` 的实际流程是 Clear → 虚槽 `+0x40` 的 CodedInputStream parser → 虚槽 `+0x28` 的 IsInitialized → 检查输入流 consumed-entire 标志，w0 返回 0/1。它并非输入 bytes 的 ParseFromArray：x1 必须是该版本 24-byte libc++ string 的指针。首轮观察不应对原对象再次调用它。（A）

可核对的观测条件：

1. 在 onEnter 仅保存当前 invocation 的 x0 与返回地址；x0 vptr 必须等于 `base+0x7fbf0c8`，返回地址必须为 `base+0x498c18c`。不遍历其他参数。
2. 在 onLeave 只接受 w0=true；原 AddMsg 仍属于调用者，不能保留该指针到异步任务，也不能销毁它。
3. 用下述已知字段链、presence bits、长度上限与可读映射边界，比对两个会话身份候选字段与完整目标群 ID。不要使用只允许 `@chatroom` 的后缀过滤，以免漏掉 `@im.chatroom`。
4. 只对匹配群的对象 New → CopyFrom 到自有对象 → ByteSize → 序列化；把普通 bytes 交给外部消费者，然后用配对 Delete 释放自有对象。若要把对象移交异步任务，应明确所有权，不能两边都释放。
5. 同时保留消息 ID、两个身份字段、类型、时间及原始 MsgSource。先对照已经验收的两条消息校准方向/发送者含义，再开启持续流。新旧消息重放与重复解析需要去重，不能用“本次 Hook 触发”定义新消息。

证据：[ParseFromString 全部指令](./linux-receive-parse-string.txt)、[调用者与解析后的处理](./linux-receive-context-disassembly.txt)、[函数边界](./linux-receive-context-ranges.json)。上述条件是可审查设计，不是已执行 Hook 配置。

## AddMsg 的自有对象 ABI

类型由 `GetTypeName 0x5c15dec` 引用字符串 `micromsg.AddMsg` 确认，vptr 为 `base+0x7fbf0c8`，对象 `0x60` bytes。（A）

| 操作 | 函数地址 | 机器 ABI / 限制 |
| --- | --- | --- |
| New | `0x5c14e18` | 返回 x0=新对象；本实现不读传入 this，先分配 `0x60` bytes，再调 ctor `0x5c14868`。 |
| CopyFrom | `0x5c15d70` | x0=dst、x1=src；同具体类型。先 Clear 再调 `0x5c14908` 合并；src=dst 时直接返回。 |
| IsInitialized | `0x5c15db0` | x0=obj、w0=bool；检查低 9 个 required presence bits，再验证 field 8 子对象。 |
| ByteSize | `0x5c159e4` | x0=obj、w0=int；更新 cached size `+0x58` 和子对象大小。 |
| SerializeWithCachedSizesToArray | `0x6b24ca4` | x0=obj、x1=输出；返回 end pointer。先计算大小、足额分配、期间不得修改对象。 |
| Delete | `0x5c14dc4` | x0=由客户端 New 分配的对象；先析构 `0x5c14ca4`，再客户端 delete。 |
| 内部 parser | `0x5c14f60` | x0=AddMsg、x1=CodedInputStream；w0=解析阶段 bool。不能给普通 bytes 指针；单独返回 true 不等于外层完整输入验证通过。 |

CopyFrom 的嵌套 string/buffer 会走子对象合并和独立字符串赋值，有分配新子对象的分支，不是整块 memcpy。这个类型的深拷贝/销毁仍应先做独立对象往返验证，不能把此前 SendMsgRequestNew 的通过结果直接当成 AddMsg 也已动态通过。

证据：[虚表重定位](./linux-receive-proto-vtables.json)、[New / ByteSize / 序列化](./linux-receive-initial-disassembly.txt)、[CopyFrom / Merge / parser](./linux-receive-ownership-disassembly.txt)、[Delete / IsInitialized](./linux-receive-context-disassembly.txt)、[类型字符串](./linux-receive-type-identities.json)。

## 最小字段过滤与真实 @ 元数据

下表的 wire 编号、内存类型和偏移由 parser/serializer 直接证明。两个身份与消息体的命名属于静态数据流推断，需用一次已知实包对应验证；MsgSource 与 @ 的关联有独立的写入链支持。

| wire field | AddMsg 内偏移 | 已确认类型 / 用途 |
| --- | --- | --- |
| 1 | `+0x10` | 32-bit varint，旧消息 ID 候选（A 类型 / B 含义）。 |
| 2 / 3 | `+0x08` / `+0x18` | `micromsg.SKBuiltinString_t*`；发送方/接收方身份候选，限定群时先精确比对两者（A 类型 / B 方向）。 |
| 4 | `+0x14` | 32-bit varint；解析后处理器用它分流消息类型（A）。 |
| 5 | `+0x20` | `SKBuiltinString_t*`；内容字符串。构造链可在内容前加入身份与 `:\n`，应保留原串、避免盲拆第一冒号（A 字符串与构造 / B 所有情形含义）。 |
| 9 | `+0x48` | 32-bit varint，时间值候选（A 类型 / B 含义）。 |
| 10 | `+0x38` | 指向 24-byte libc++ string；MsgSource XML（A，见下方写入链）。 |
| 11 | `+0x40` | 指向 libc++ string；另一个可选文本，不替代 MsgSource（A 类型）。 |
| 12 | `+0x50` | 64-bit varint，新消息 ID 候选；外部 JSON 用十进制字符串，避免 JS Number 精度丢失（A 类型 / B 含义）。 |
| 13 | `+0x4c` | 32-bit varint，序号候选（A 类型 / B 含义）。 |

AddMsg presence 在 `+0x5c`，field N 对应 bit N-1。SKBuiltinString 对象大小 `0x18`、vptr `base+0x7fbb4e0`，其 `+0x8` 指向 24-byte libc++ string，presence 在 `+0x14`；只读身份过滤不需要调用 GetTypeName。字符串 short/long 布局与已通过发送校准的布局相同：首字节 bit 0 为 long 标志，short 长度为首字节右移 1、数据在 `+1`；long 长度在 `+8`、数据指针在 `+16`。任何一层空指针、vptr 不符、无 presence、越界长度都应丢弃该事件，不能继续猜偏移。（A）

`0x5485bd8` 构造 AddMsg 时，`0x5486130` 调用已定位的 XML writer `0x4852f8c`，再在 `0x5486178–0x54861a8` 把结果赋值到 AddMsg `+0x38` 并设置 bit 9；serializer 把该指针作为 wire field 10 字符串写出。writer 本身明确输出 `msgsource` / `atuserlist`，所以此字段可保存真实 @ 元数据，不需从显示昵称文本猜测。外部消费者应解析 XML 的 atuserlist 并精确比对 self wxid，分别保留“没有元数据”和“明确不含 self”的状态。（A 字段链；C 入站目标群实包是否同样提供该节点）

证据：[字段上下文与 XML writer 结果写入](./linux-receive-field-context.txt)、[SKBuiltinString 类型](./linux-receive-field-types.json)、[AddMsg serializer](./linux-receive-initial-disassembly.txt)。

## 备用：NewSync 已解析响应

`/cgi-bin/micromsg-bin/newsync` builder 为 `0x4999538`；Task 分配大小 `0x140`，vptr `base+0x7f102d8`，request 嵌入 `+0xc0`，response 嵌入 `+0x100`。response getter `0x4999a98` 仅返回 Task+0x100。类型 `micromsg.NewSyncResponse` vptr `base+0x7fbef60`、New `0x5c133cc`、CopyFrom `0x5c13c70`、ByteSize `0x5c13aa4`、Delete `0x5c133a8`。（A）

Task response parser `0x4999a3c` 将 AutoBuffer 的数据和长度交给通用 ParseFromArray `0x6b24b94(Task+0x100, bytes, length)`。**包装函数丢弃该返回值并无条件返回 1**，因此不能把这个包装层 w0 当解析有效性。完成 lambda `0x4999e4c` 从 Task 虚槽+0x28拿到响应，在互斥锁内构造另一份拥有对象，再调用响应 CopyFrom。这是独立的生命周期证据；可以观察该明确类型的 CopyFrom 或通用解析完成点，而不是留存 Task+0x100 裸指针。（A）

此响应 field 2 是嵌套命令列表。没有在本轮补全其命令 ID 到 AddMsg 的全部映射，也没有证明所有长连接推送、外部群实时包或历史同步都经过这一个 newsync Task。批量响应可能含其他会话与联系人信息，首轮仍优先 AddMsg 级别精确群过滤。

证据：[Task 虚表](./linux-receive-newsync-task-vtable.json)、[Task 构造](./linux-receive-ownership-disassembly.txt)、[响应 parser/getter/完成拷贝](./linux-receive-context-disassembly.txt)。

## 与 MMBuf2Resp 的关系及未证实范围

此前已定位的 `0x6c349c4` 先尝试 `0x6c17238`，未处理时才走 `0x6b5a978` 的 MMBuf2Resp。故只 Hook MMBuf2Resp 不能自动推定覆盖全部接收消息。本轮没有从这两支到 newsync/AddMsg 做动态栈关联，也没有把某个宽泛 buffer 回调称为统一入站事件。

阶段性交付应把原生接收标为待验优化，保留已实测的 DB+WAL 副本读取。后续最小验证为：先 AddMsg 自有对象往返，再只读观察上述精确 ParseFromString 调用点，对照目标群的一条普通消息、一条带 self atuserlist 消息；比较 ID、身份、正文、source、首次出现时间，并去重。还需验证断线重连/历史补包、客户端版本变化、空/超长字符串、观察器退出后的资源释放。没有必要为验证这个候选扩大到全账号内存扫描。
