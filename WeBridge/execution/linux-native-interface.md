# Linux ARM64 内部接口：静态定位结果

后续已完成具体发送 ABI 恢复和无UI双向验收，见 [最新实测](linux-native-acceptance.md)、[发送ABI](linux-send-object-abi.md)。下文保留初轮静态定位范围，不代表当前实测仍停留在地址发现阶段。

日期：2026-09-21。对实验容器 `wechat-lab-linux` 的 `/opt/wechat/wechat` 执行一次 `docker cp` 后，全部分析发生在磁盘副本上。本子任务没有执行该文件、附加进程、改客户端、读取账号数据或发送消息。下列地址是供研究使用的 ELF 虚拟地址，不是已经验证的运行配置。

**结论：Linux 客户端存在可明确定位的原生任务发送入口、回包分发入口，以及 `newsendmsg` 请求构造和 `msgsource/atuserlist` 解析、生成路径。值得继续做原生接口 PoC，已有比单靠界面自动化更具体的突破口。但完整主动发送 ABI、消息流覆盖和外部混合群真实 @ 尚未由本轮静态分析证明。**

## 文件和定位方法

| 项目 | 结果 |
| --- | --- |
| 客户端版本 | 实验环境既有识别值 `4.1.1.8`；本轮以 ELF 指纹固定对象 |
| 文件 | [build/linux/wechat-4.1.1.8-arm64](../build/linux/wechat-4.1.1.8-arm64) |
| 架构 | ELF64 little-endian AArch64，PIE，stripped |
| GNU BuildID | `9a3558be209dfcf1b85d6ec18bf029c7f97ccb61`，与主任务给定值一致 |
| SHA256 | `e40116597803a5e0d9fc4a2b727df4b8f7a3dd6de1c336140ea373be2b6626e9` |
| `.text` | VA `0x3617000`，文件偏移 `0x3607000`，大小 `0x47673fc` |
| `.rodata` | VA/文件偏移均 `0xda5980`，大小 `0x1ad5089` |
| `.eh_frame_hdr` | VA/文件偏移 `0x28cd3c8`，索引编码 `01 1b 03 3b`，267,564 条索引 |

源容器镜像已由主任务固定摘要，见 [provenance.json](./linux/provenance.json)、[compose.yaml](./linux/compose.yaml)。版本标识和文件摘要用于精确复现，不意味着其他同为 4.1.x 的文件兼容。

本轮新增 [linux_native_probe.py](../scripts/linux_native_probe.py)：解析 ELF 节表和 unwind 索引，限定 `.rodata` 搜索字符串，再扫描 `.text` 内 ADRP + ADD。保留 42 个候选引用，逐一重点复核下表涉及的代码。9 个核心函数还解码了 FDE 的 PC-relative 起点和 range，全部与索引起点一致；相关 CIE 的地址编码为 `0x1b`。因此表中的函数范围有独立于字符串交叉引用的边界证据。

机器证据：[完整扫描 JSON](./linux-native-probe.json)、[9 个 FDE 范围核验](./linux-native-function-ranges.json)、[直接分支调用者](./linux-native-direct-callers.json)、[关键函数反汇编](./linux-native-disassembly.txt)、[调用链反汇编](./linux-native-callchain-disassembly.txt)。反汇编中 `<main+...>` 是 stripped 文件缺少函数名时显示的最近符号标签，不能据此把这些代码归为 `main`。

## 可确认的原生入口

“静态高置信”表示字符串、指令数据流与函数边界共同支持该判断；并不代表已动态验证 Hook 或调用成功。

| 对象 | ELF VA 范围 / 引用 | 已确认内容与边界 |
| --- | --- | --- |
| `MMStartTask` 方法 | `0x6b5c7fc–0x6b5c884`，136 bytes | 静态高置信。日志引用 `MMStartTask` 和 `mars/mm-ext/mmstn_manager.cc`。原 x0 保存到 x20，原 x1 保存到 x19；取 `[x20 + 0x18]` 管理器，再把原 x1 传给 `0x6b67bf4`。 |
| `MMStartTask` 外层 | `0x6b4e508–0x6b4e638`，304 bytes | 静态高置信。日志源文件 `mmstn_logic.cc`；取得默认管理器后，在 `0x6b4e5a4` 调用上述方法。原 x0 作为其 x1 传递。 |
| `MMBuf2Resp` | `0x6b5a978–0x6b5bc8c`，4884 bytes | 静态高置信的回包分发函数。入口保存 w1 到 w24；`0x6b5aa64` 调用 `[对象 + 0x10]` 所指回调对象的虚表 `+0x50`，向下传递 w1 及多组参数。它不是已确认的最终聊天消息 protobuf 缓冲读取点。 |
| `newsendmsg` 构造路径 | `0x4f65f78–0x4f66154`，476 bytes | 从 VA `0xfdeec6` 复制 `/cgi-bin/micromsg-bin/newsendmsg`；创建 `0x130` bytes 的任务对象，调用构造函数 `0x4f661f8`，填充请求/回调，随后经传入对象的虚表 `+0x28` 提交该对象，返回对象 `+0x8` 的 32-bit 字段。该返回字段可能是任务标识，尚未动态证实。 |
| 第二处 `newsendmsg` 路径 | `0x4f62668–0x4f62d44`，1756 bytes | 同样构造上述 CGI 字符串，存在请求相关对象处理。调用者共 3 处；本轮未补全语义，不能把两处构造函数当成相同签名。 |
| `atuserlist` 解析 | `0x48522b8–0x4852f8c`，3284 bytes | 先处理 `msgsource` 根节点，再以 `atuserlist` 查找子节点并读取字符串，存入目标对象 `+0x18` 字段。入口 x0 是输出/状态对象，x1 被用作输入文本对象。 |
| `atuserlist` 生成 | `0x4852f8c–0x4853964`，2520 bytes | 从输入对象 `+0x18` 读取非空字符串，生成 `msgsource` 下的 `atuserlist` 节点并写入内容。入口 x0 是输入对象，x8 作为结果对象地址保存到 x19；不能按“返回 char*”处理。 |

`newsendmsg` 精确字符串地址为 `0xfdeec6`，不是附近的 `0xfdeec3`。`atuserlist` 为 `0xe47219`；其两个 ADRP + ADD 引用是 `0x48524d4/0x48524d8` 和 `0x4853010/0x4853014`。本轮限定 `.rodata` 的完整 ASCII 扫描未找到 `@im.chatroom` 或 `@openim`；这不能用来排除外部群支持，字符串可能采用其他编码、拼接或运行时生成。

## 已追到的调用关系

### 任务发送与回包

发送链明确存在 `0x6b4e508 → 0x6b5c7fc → 0x6b67bf4`。此外 `0x6c160a0` 中有两处调用 `0x6b5c7fc`，适合下一轮检查 Task 如何构造。`0x6b67bf4` 入口立即把传入 x1 交给 `0x6a6f020` 处理，目标为栈上的对象；这支持存在对象复制/转换阶段，但本轮没有恢复该 Task 的全部成员布局。

回包外层 `0x6c349c4` 先可选择调用 `0x6c17238` 的另一 `Buf2Resp` 路径，随后才可能调用 `0x6b5a978`；因此只观察后一函数可能漏掉前一分支已处理的响应。`Req2Buf` 字符串对应 `0x6c16e20` 等多个函数，不能把任意同名日志函数当作 Mac 旧版的 req2buf 注入点。

### `newsendmsg` 请求对象

`0x4f65c8c` 在 `0x4f65da8` 调用 `0x4f65f78`：调用参数来自两个捕获对象、它们的 `+0x10 / +0x28` 字段和栈上的回调对象。这是内部 C++ 调用链，不是 `send(to, text, mentionIds)` 这类平坦接口。

`0x4f65f78` 中的提交虚调用位于 `0x4f660dc`，当时 x0 是入口传入的宿主对象，x1 是刚构造的请求任务。该点值得只读观察真实发送时的对象来源和线程；尚不能凭此组装参数主动调用。第二处构造路径的三个直接调用者为 `0x4f6177c`、`0x4fc64a4`、`0x4fcbc0c`，本轮未判定各自消息类型。

### 真实 @ 所需元数据

`atuserlist` 确实进入 `msgsource` 的结构化读写，不是仅搜索显示文本中的“@昵称”。生成函数有 4 个直接调用者；其中 `0x484d7a0` 读取宿主对象 `+0x1b0` 的元数据对象，调用生成函数，再把结果写回宿主对象 `+0xd0` 的字符串。解析函数则有两处直接调用，一处是 `0x484d6ac` 的尾调用。

这是恢复原生真实 @ 的有用链路，但仍缺三段连接：目标外部群发送时是否走这一生成路径；`atuserlist` 内究竟使用哪一种企微/微信成员标识；生成后的元数据如何进入实际 `newsendmsg` 或外部群专用请求。只有静态出现该字段，不能宣布对火运科技的陈佳豪进行真实 @ 已可用。

## 与 Mac 可复用程度

**可以复用研究方法和分层思路：**用 `MMStartTask`、CGI、unwind/函数表、虚调用和 buffer 流定位；保留版本与 SHA256 闸门；先观察真实对象，再设计发送适配。Linux `0x6b5c7fc` 与 Mac `0x5570260` 均取管理器对象 `+0x18` 再转交 Task，说明共同 Mars 层确实有静态证据。

**不能直接复用旧地址、寄存器约定或 C++ 对象字节：**Linux 当前所见字符串采用首字节 bit 0 判断长短字符串，短字符串内容从 `base + 1` 开始、长度为首字节右移 1；长字符串长度在 `base + 8`、指针在 `base + 16`。Mac 上一轮所见相应字符串代码检查末端 `+0x17` 的符号位，布局不同。Linux 的函数序言、栈帧以及 x8 隐藏结果参数也需要独立适配。Mac 的 req2buf 假树节点、fake vtable、`sp + 0x140` taskId 读取不能直接套用。[Mac ABI 证据](./mac-req2buf-abi.md)

## 下一步最小原生 PoC

1. 以本文件的 BuildID 和 SHA256 为前置检查，先做只读观察器：优先 `0x6b5c7fc` 的真实 Task 与 `0x484d7a0/0x4852f8c` 的元数据对象；补充回包的两条分支。先确认参数可读、长度边界与线程，输出经过目标会话筛选的字段。观察器成功不等于发送成功。
2. 在真实样本上把会话、成员标识、`msgsource/atuserlist` 和任务 CGI 关联起来，明确企微创建外部群是否使用另一请求路径。主任务的数据库回读结果可辅助关联，但不得把库字段名直接当作内存结构偏移。
3. 然后在 `newsendmsg` 构造链和更高层消息对象接口中选一处实现发送。只有恢复对象构造、所有权、回调与线程要求之后，才添加主动调用；本轮没有创建供运行的 Hook 配置或主动调用脚本。

可复现静态扫描：

```sh
python3 scripts/linux_native_probe.py build/linux/wechat-4.1.1.8-arm64 --output execution/linux-native-probe.json
```

本轮交付状态：复制程序与指纹核对完成、函数和字段路径定位完成、机器证据已保存；原生发送和外部群真实 @ 仍待有界动态验证。
