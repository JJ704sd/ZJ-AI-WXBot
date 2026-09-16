# WeChatAuto 只读前置探针

使用社区 SDK 相同的 FlaUI 5.0.0 / UIA3 依赖，核验目标标题、消息列表、输入框，以及有界 Raw View / MSAA 计数。避免 SDK 工厂初始化的托盘点击、头像读取和截图副作用。没有发送器、点击、聚焦、截图或聊天正文输出。

这不是完整 SDK 运行验证。即使返回 `ui_structure_pass=true`，真实 @、新旧消息区分、混合群送达仍未验证；`sdk_acceptance_pass` 固定为 false。

用法：`ReadOnlyProbe <exact target group title> [baseline|pulse-screen-reader|pulse-narrator]`。群名含空格时，调用方必须按单个参数传递。`pulse-screen-reader` 会短暂设置 `SPI_SETSCREENREADER` 并在 `finally` 恢复；`pulse-narrator` 会短暂启动讲述人并结束进程。父进程应再次核验标志与进程。不切换当前会话。

输出只含节点数量、类名、匹配布尔值和进程信息，不含节点名称或消息正文。由调用方设定超时，超时终止探针进程，不终止微信。

退出码：0 为前置结构满足；3 为未满足；2 为参数错误。异常或超时均不能当成通过。

依赖和编译产物保存在 `poc/.local/wechatauto-readonly`。

## 当前执行状态（以最新为准）

v6 真实桌面对照已完成：微信 4.1.13.65，主窗口 Raw View 3 节点、0 个 `mmui::`。`SPI_SETSCREENREADER` 与讲述人均未改变该树。MSAA client/window 子节点计数为 1/7，不能解释为聊天列表。`ui_structure_pass=false`。选择器查询仅对 `Qt51514QWindowIcon` 运行；对 `Qt51514QWindowToolSaveBits` 的 `FindAllDescendants` 会挂起，不要恢复那种遍历。

这是前置结构失败，不是 WeChatAuto.SDK、真实 @ 或原群双端验收通过。可逆 OS 无障碍适配路线已结束；不要只改 AutomationId 再跑同一路径。
