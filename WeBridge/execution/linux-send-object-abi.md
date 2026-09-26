# Linux 原生发送对象 ABI 与独立构造路线

日期：2026-09-21。静态对象固定为 Linux ARM64 `4.1.1.8`，BuildID `9a3558be209dfcf1b85d6ec18bf029c7f97ccb61`、SHA256 `e40116597803a5e0d9fc4a2b727df4b8f7a3dd6de1c336140ea373be2b6626e9`。本子任务只读取此前复制的 ELF；没有附加/控制容器进程，也没有构造可运行的调用脚本。

**已解决核心请求的生命周期问题：可以通过客户端自身的 New、ParseFromArray、CopyFrom 和析构入口创建、填充、深复制、销毁独立的 `micromsg.SendMsgRequestNew`，不必克隆含悬空指针的消息对象。尚不能直接发送：异步完成路径要求有效回调，空回调会进入抛异常路径；服务对象生命周期、线程要求和 x2 字符串的业务语义仍待确认。**

主任务另行报告动态校准确认目标混合群真实 @ 经过 `0x4852f8c → 0x4f62668 → 0x4f65f78 → 0x6b5c7fc`。这是主任务运行证据，不是本轮静态扫描独立证明的结论。所有下列地址均为 ELF VA，需运行时 load bias，且只适用于上述精确文件。

## 请求的具体类型与操作

任务构造器 `0x4f661f8` 初始化 `0x130` bytes 的任务对象，调用 `0x5bbc884(task + 0xc0)` 构造请求，调用另一个构造器初始化 `task + 0xf0` 响应。其虚表由 `.rela.dyn` 的 `R_AARCH64_RELATIVE` 解析得到，地址点为 `0x7f3e598`；`vtable + 0x20` 精确指向 `0x4f664c4`，该函数只有 `return this + 0xc0`。

请求的虚表地址点为 `0x7fbab38`。其 `GetTypeName` 函数 `0x5bbcfc8` 返回明文 **`micromsg.SendMsgRequestNew`**（字符串 VA `0xf0c976`）。这是类型名函数与数据的直接证据，不能与混淆后的 RTTI 字符串混同。

| 操作 | 入口 | 静态确认的约束 |
| --- | --- | --- |
| 构造 | `0x5bbc884` | x0 指向至少 `0x30` bytes 的独立存储；初始化 vptr、repeated-field 容器、标量与 presence bits。 |
| `New` 语义 | `0x5bbcad0` | 内部 `operator new(0x30)` 后调用构造器并返回新对象；该具体实现没有读取原 x0。但不能据此推广其他消息类型或版本。 |
| `Clear` | `0x5bbcb10` | 清理已用子项状态、把 repeated count 和 presence bits 清零，保留可复用子对象。对应虚表 `+0x20`。 |
| `MergeFrom` | `0x5bbc984` | 合并 repeated 子消息与顶层标量；禁止 source == destination。 |
| `CopyFrom` 语义 | `0x5bbcf18` | source == destination 时直接返回；否则先对目标调用 `vtable + 0x20`，再尾调用 `MergeFrom`。x0 是目标，x1 必须是同一具体消息类型。 |
| 通用 `ParseFromArray` 语义 | `0x6b24b94` | x0 是已构造的消息对象，x1 是字节缓冲，w2 是有符号 32-bit 长度；内部建 CodedInputStream，Clear，再调用消息虚表 `+0x40` 解析，检查 `+0x28` 初始化状态及是否完整消费，w0 返回成功/失败。 |
| 消息编码 | `0x6b2528c` | 任务序列化函数 `0x4f663d4` 对 `task + 0xc0` 调用此函数，结果是经 x8 指定地址返回的 C++ 字符串。不能当成 `char*` 返回的函数；本轮尚未完整恢复其接口与失败行为。 |
| 非释放析构 | `0x5bbca30` | 销毁拥有的 repeated 子消息和容器；用于任务内嵌请求或由调用者管理的存储。 |
| 释放析构 | `0x5bbcaac` | 先调用非释放析构，再调用客户端 `operator delete`；适合与客户端 New 分配配对，不能用于 Frida/其他分配器拥有的内存。 |

深复制证据：`MergeFrom` 调用 `0x5bbefc4` 合并 repeated 容器；容量不足时分配新的 `0x38` bytes 子对象并调用 `0x5bbbc50` 构造，再调用 `0x5bbbc78` 复制子消息。子消息的类型名函数 `0x5bbc834` 返回 **`micromsg.MicroMsgRequestNew`**。子对象中的嵌套对象和字符串由复制代码单独构造/赋值，因此不是仅 memcpy 请求头或保留 source 的指针数组。

顶层 parser 的 wire layout 可直接确认：field 1 为 varint，写到对象 `+0x20`；field 2 为 length-delimited repeated 子消息，使用 `MicroMsgRequestNew` parser。子消息 parser 明确处理 field 1–7，其中 1 为嵌套消息、2 和 6 为 length-delimited 字符串、3/4/5/7 为 varint。业务字段名应由已校准的 protobuf 样本确认，不能仅照抄 Mac 构造器里对时间和消息 ID 的假设。

证据：[任务构造与 CopyFrom](./linux-send-object-initial-disassembly.txt)、[具体 protobuf 方法](./linux-send-protobuf-disassembly.txt)、[ParseFromArray 与所有权](./linux-send-ownership-disassembly.txt)、[子消息类型与深复制](./linux-send-child-copy-disassembly.txt)、[ELF 重定位后的虚表](./linux-send-vtable-evidence.json)。

## `0x4f65f78` 的最低参数约束

| 参数 | 本轮可核实的类型/使用方式 | 可否自行替代 |
| --- | --- | --- |
| x0 | 有效的服务 C++ 对象；函数在 `0x4f660dc` 调用其虚表 `+0x28`，x1 为新任务指针。 | 不能置空或复制少量字节代替；服务实例有效期与调度线程还未确认。 |
| x1 | `const micromsg.SendMsgRequestNew*` / 引用，立即被具体 CopyFrom 深复制到新任务的内嵌请求。 | 可以用上述 New + ParseFromArray 创建的自有对象。调用返回后销毁 source 的生命周期推论有深复制支持，但必须先验证本地对象往返、不发送。 |
| x2 | 24-byte libc++ `std::string` 对象指针，复制到新任务 `+0x50`。不是 UTF-8 `char*`。 | 可以创建自有字符串，但其业务含义尚未确认；不能随意假定是收件人或使用空字符串。 |
| x3 | 至少包含 `+0x8` 起始的 24-byte libc++ 字符串。该字符串非空时替换默认 CGI；空时保留 `/cgi-bin/micromsg-bin/newsendmsg`。当前函数未读取 x3 的前 8 bytes。 | 自有 `0x20` bytes 结构与空字符串满足该函数可见读取范围；是否保留其他调用者语义仍需用一次定点样本验证。 |
| x4 | 类似 libc++ `std::function` 的回调封装，`+0x20` 保存目标对象指针，本地缓冲在 `+0x0`。函数会转移或虚调用复制目标，并清空来源控制指针。 | **不能用 nullptr；不能把全部 0 的 wrapper 当成完整可发送参数。** 需要有效、具有正确复制/销毁/调用语义的自有回调。 |

这里所见 Linux 字符串：短字符串首字节 bit 0 为 0、长度为首字节右移 1、内容从 `+1` 开始；长字符串 bit 0 为 1、长度在 `+8`、数据指针在 `+16`。应使用相同 ABI 的构造/销毁或明确受限的独立短字符串存储，不要混用 Mac 的 string 布局。

实际调用者 `0x4f65c8c` 在 `0x4f65d90–0x4f65da8` 传入 x2 = 捕获对象 `+0x10`、x3 = 捕获对象 `+0x28`、x4 = 当前栈上的 `0x28` bytes 回调。这个调用点证明了参数边界，不能独立证明 x2 的业务命名。

## 空回调确实不能作为默认发送方案

任务管理路径 `0x5baa6bc` 按 taskId 在内部树中取出任务并进入完成处理：

- `0x5baa928` 从 task `+0xa0` 读取回调目标；这里与任务内 `+0x80` 的 wrapper 控制指针 `+0x20` 一致。
- `0x5baa938` 对 null 分支跳到 `0x5baa970`，调用 `0x36f8080`；后者分配 8-byte C++ 异常对象并进入抛异常路径。
- 非空时从虚表 `+0x30` 取调用函数，传 x1 = `&Task*`、x2/x3 = 两个 32-bit 状态值的地址；返回值 bit 0 为真时，管理器对 Task 调用虚表 `+0x8` 释放任务。为假时该路径不执行这一释放，需要由回调/其他逻辑管理。

异常 RTTI 名称被混淆，`what()` 返回 `std::exception`；本轮不把它未经证明地命名为 `bad_function_call`。确定的是：**null 被检查后用于抛异常，而不是被忽略。** 构造器/析构器接受空状态，不能外推异步调用允许空状态。

证据：[任务完成和抛异常分支](./linux-send-callback-disassembly.txt)、[异常 RTTI / what 证据](./linux-send-callback-exception.json)、[what 的磁盘反汇编](./linux-send-callback-exception-what.txt)。之前的宽参数扫描崩溃位于观察器，不能据此推断上述原生接口本身不可用；本轮没有重试宽扫描。

## 当前最小 PoC 应先验证对象，不发送

1. 使用客户端 New 创建独立请求，对自有、长度有界的 protobuf bytes 调用 ParseFromArray，检查 bool 结果；确认请求的类型与 repeated 数量，不遍历未经确认的任意指针。
2. 再创建第二个独立请求，用具体 CopyFrom 复制；销毁第一个，验证第二个仍能独立编码。先补全编码函数的 hidden-return/std::string 清理 ABI，再运行这一步。这能直接检验是否摆脱源请求生命周期依赖。
3. 在隔离的测试进程里先验证自有 callback wrapper 的 clone/move/invoke/destroy，然后才考虑把它交给微信任务对象；回调返回 bool 与任务释放语义必须匹配，不能只塞入一个 NativeCallback 指针。
4. 主任务若继续做定点校准，应只采集 x0 服务、x2 的已确认 string 和 x3 的 string，以及实际线程 ID。确定 x0 的存活和线程调度，再评审发送调用；本报告不是第 5 条消息调用的执行背书。

以下初轮未决项由后续补充分别收敛；服务提交的线程要求与 x2 的业务语义仍待核实。

## 追加：不发送的对象往返 ABI 已收敛

以下只描述机器调用约定，未生成调用脚本，也未替主任务执行运行审查。w0 的 bool 返回可按 32-bit 0/1 读取；所有输入指针和长度必须由本次 PoC 自己持有并满足映射边界。

| 具体操作 | 地址 | 寄存器/返回约定 |
| --- | --- | --- |
| New | `0x5bbcad0` | 返回 x0 = 新的 `0x30` bytes 对象；此精确实现进入后立即把 w0 改为分配大小，没有读取传入的 this。其他版本不能沿用这个特性。 |
| ParseFromArray | `0x6b24b94` | x0=obj，x1=bytes，w2=int length；w0=bool。 |
| IsInitialized | `0x5bbcf58` | x0=obj；w0=bool。要求顶层 field 1 presence bit 存在，并逐个验证已用子消息。 |
| ByteSize | `0x5bbce64` | x0=obj；w0=int size；同时写 obj `+0x24` 的 cached size，并计算子消息 cached size。 |
| SerializeWithCachedSizesToArray | `0x6b24ca4` | x0=obj，x1=output bytes；返回 x0=output+cached size。**必须先对同一、未再修改的对象调用 ByteSize，并按大小足额分配输出。** 内部以 cached size 建输出流，再调用具体序列化方法。 |
| CopyFrom | `0x5bbcf18` | x0=dst，x1=src；无可依赖返回值。 |
| Delete | `0x5bbcaac` | x0=客户端 New 得到的对象；无可依赖返回值。 |

特别区分：`0x5bbcdf0` 是接受 CodedOutputStream 的具体序列化函数，**不是 ByteSize，也不能把普通 bytes 指针作为其 x1**。`0x5bbefa4` 仅返回 cached size；它不能替代 ByteSize 计算。

`GetTypeName 0x5bbcfc8` 需要 hidden x8 指向 24-byte string 返回对象，会分配名称的堆存储；首轮往返不必调用它。可核对新对象 vptr 是否等于 load-bias + `0x7fbab38`，类型字符串的静态来源已确认。绕过字符串 hidden-return 能减少一层与核心验证无关的 ABI 风险。

推荐先检查 parse/initialized、ByteSize 范围、end-pointer 差值和 protobuf 字段等价，再检查字节一致。protobuf 可能规范化字段顺序或 varint 表示，原始字节不同不自动说明对象损坏；用于该测试的输入应采用规范、稳定字段顺序。第二阶段 CopyFrom 后销毁源对象，再对目标重复编码，才是独立所有权的有效验证。

证据：[往返方法完整反汇编](./linux-send-roundtrip-disassembly.txt)、[各函数 FDE 范围](./linux-send-roundtrip-ranges.json)。

## 追加：callback 的九个虚表槽

实际捕获 closure 的虚表地址点是 `0x7f3e5f0`，不是只有一个函数指针。任务 wrapper 占 `0x28` bytes，控制指针在 `+0x20`；本次原 closure 本体占 `0x30` bytes，包含两个带引用计数的捕获对象，不能直接复制本体字节。

| 虚表槽 | 原实现 | 从函数体确认的语义 |
| --- | --- | --- |
| `+0x00` | `0x4f664d4` | 完整对象析构，释放捕获状态，不释放 closure 本体。 |
| `+0x08` | `0x4f66588` | 带本体释放的析构。 |
| `+0x10` | `0x4f66630` | x0=source；分配 `0x30` bytes 并复制/retain 捕获状态，x0 返回 clone。 |
| `+0x18` | `0x4f666ac` | x0=source，x1=destination；在提供存储上复制构造并 retain，没有释放 source；它不是浅字节 move。 |
| `+0x20` | `0x4f66708` | destroy：释放捕获状态，不释放本体存储。 |
| `+0x28` | `0x4f667ac` | destroy + deallocate；原实现调用客户端 delete。 |
| `+0x30` | `0x4f66844` | x0=closure，x1=`Task**`，x2=`int32_t*`，x3=`int32_t*`；解引用后三项再交给具体 lambda，w0 返回 bool。 |
| `+0x38` | `0x4f66858` | 带 type_info 参数的 target 查询，匹配时返回捕获区，否则 null。 |
| `+0x40` | `0x4f66874` | 返回原 closure 的 type_info 地址。 |

自有回调用 C 结构体与函数指针实现这些已观察 ABI，在原理上可以由 Frida CModule 编译；这不是把 CModule 的一个函数地址直接当 std::function。优先使用独立 heap closure，使 `wrapper+0x20 != wrapper`，匹配已观察到的转移路径；控制指针转入 Task 后来源被清空。clone 必须创建独立本体并保持捕获状态存活；destroy 与 deallocate 需要区别本地存储/heap 存储，始终用与该本体匹配的分配器。不能把 Frida `Memory.alloc` 的内存交给客户端 delete。

最小 native operator 可只读取三个已确认引用、记录结果并返回 true，由任务管理器释放 Task；其余释放操作只能管理 callback 自身。CModule 必须持续存活到所有 Task、clone 和回调完成，不可在发送函数返回时卸载。type_info/target 查询虽然已定位，但本轮没证明所有后续路径都不查询它们；要宣称完整 std::function 兼容仍需测试这些槽，不能把未实现槽全部填同一个返回 stub。

证据：[callback 虚表 JSON](./linux-send-callback-vtable.json)、[九个槽完整反汇编](./linux-send-callback-vtable-disassembly.txt)。

## 追加：提交线程与默认参数的边界

最初没有取得运行时服务 vptr；主任务随后用第 4 条定点校准补齐，并报告进程与登录状态保持稳定。实际服务 vptr 为 load bias + `0x7fb98f0`，`+0x28` 槽为 `0x5ba9164`，与静态候选完全匹配。该槽只是 `this -= 0x10; b 0x5ba8b54` 的次级接口 thunk。

`0x5ba8b54` 检查 manager `+0x18` ready 标志，锁 manager `+0x70`，构造 Mars Task 并复制 CGI、请求种类等字段，调用全局函数槽 `0x81f79b8`，将取得的任务编号登记为 `taskId → 原 Task*`，最后解锁。**不能把它理解为一个没有所有权行为的发送函数。** 磁盘重定位初值为 `0x6b0cf20`；主任务另行只读确认运行时槽已改为 `0x6b4e508`。这里必须以运行时核对结果为准。

已审调用链为 `5ba9164 → 5ba8b54 → [81f79b8] = 6b4e508 → 6b5c7fc → 6b67bf4 → 6ac18cc → 69e6270`。其中 default Context 查找 `0x6a64ec0`、manager 查找 `0x6a65478` 使用 pthread mutex；MM 方法先复制 Mars Task；可选统计登记 `0x6bed084` 自带 mutex；`0x6ac18cc` 的日志明确来自 `mars/stn/src/net_core.cc` / `StartTask`，把复制的任务装入拥有自身存储的消息，最终 `0x69e6270` 在另一把 pthread mutex 下复制、插入目标消息队列。其 mutex 操作 `0x6717d18/0x6717e40` 已追到 `pthread_mutex_lock/unlock@plt`。

这些函数的已审分支没有当前线程 ID 等于某线程或必须为 UI 线程的检查，**支持从非 UI 线程提交、由 Mars 队列处理的判断**。边界是稳定登录状态下的串行单次 PoC；没有证明退出登录、服务重置、未审扩展分支与提交并发时仍安全，单次校准线程 25042 也不等于唯一允许线程。此静态结论不是发送成功证明。

主任务第 4 条校准报告 x2 string 与 x3 `+0x8` CGI override 都为空。x2 的业务命名仍未恢复，但该实际空值足以作为此次同类请求的可核验基线。x3 的空字符串保留默认 CGI 由 `0x4f65fdc–0x4f6601c` 分支证明；此 builder 没有读取 x3 前 8 bytes 的额外位标志。

证据：[服务提交反汇编](./linux-send-service-second-disassembly.txt)、[次级接口 thunk](./linux-send-service-third-disassembly.txt)、[Mars StartTask 与任务复制](./linux-send-service-sixth-disassembly.txt)、[消息队列入队](./linux-send-service-seventh-disassembly.txt)、[队列 mutex](./linux-send-service-eighth-disassembly.txt)、[MM 辅助方法](./linux-send-mm-thread-disassembly.txt)、[Context / manager 的锁](./linux-send-mm-lock-disassembly.txt)。运行时结果由主任务执行，私有采样数据不复制进本文。

## 追加：不用校准消息的服务 getter

真实发送上层 `0x4f654ec–0x4f6550c` 调 `0x482fd04`，取返回 owner 对象的虚表 `+0x18`，再将返回的 service 原样传入发送 closure。`0x482fd04` 只返回 `*(load bias + 0x82bb2a8)`；owner vptr 为 `load bias + 0x7f01f48`，`+0x18` 槽 `0x4830994` 只有 `ldr x0,[x0,#0x250]; ret`。

构造处 `0x482f468–0x482f47c` 把 manager 的次级接口指针放入 owner `+0x250`，共享控制块放入 `+0x258`。主任务只读核对该 getter 路径取得的 service 与第 4 条采样完全一致。适配器可以在每次准备提交时只读取当前 owner/service 并验证上述 vptr，不必保留旧进程指针，也不必再发校准消息。getter 不增加 shared_ptr 引用；仍要避免与登出或重建服务并发。

证据：[getter 指令与重定位](./linux-send-service-getter-evidence.json)、[getter 完整指令](./linux-send-service-eighth-disassembly.txt)、[真实上层调用](./linux-send-service-seventh-disassembly.txt)、[owner 的 service 构造存储](./linux-send-service-sixth-disassembly.txt)。

## 追加：响应对象与自有 callback 审阅

Task `+0xf0` 的构造函数 `0x5bbdba8` 设置 vptr 为 `load bias + 0x7fbac28`；静态类型字符串为 `micromsg.SendMsgResponseNew`。ByteSize 虚槽 `+0x48` 指向 `0x5bbe288`，计算后缓存于响应 `+0x2c`；`+0x58` 的数组序列化仍是 `0x6b24ca4`，`+0x60` 的 `0x5bbefb4` 仅取 cached size。可以在原 Task 被管理器销毁前，以确切 vptr、输出大小上限和 end-pointer 差值为边界，序列化响应到自己持有的存储。顶层 wire 1 为嵌套消息、2 为 varint、3 为 repeated 嵌套消息；不能把 transport 错误码或 taskId 本身作为服务器业务成功证据。

证据：[响应构造器](./linux-send-response-constructor.txt)、[响应虚表](./linux-send-response-vtable.json)、[响应具体方法](./linux-send-response-methods.txt)。

主任务编写的 `execution/linux/native_completion.c` 用独立 C 共享库持有自有 closure，并计划 `RTLD_NODELETE` 保持异步回调代码驻留；九槽、heap/inline 释放分工和成对 malloc/free 与已观察 ABI 相符。审阅发现首版 `invoke` 写普通 `last` 结构，而 `lab_snapshot` 无论发布计数是否为 0 都 memcpy，存在异步轮询时的 C11 数据竞争；反馈后再次只读核查，主任务已给 `invoke/configure/snapshot` 加 `result_mutex`。仅在发布末尾更新原子计数不能保护发布前的普通读取。原 closure 的 type_info 对象 `0x7f3e6b0` 两字为 vptr `0x7d976a0`、name `0x1b0c793`，与自有两指针类型结构的对照来源已明确。该审阅不代替真实客户端完成路径验证，也不把独立进程自测当作已发送成功。
