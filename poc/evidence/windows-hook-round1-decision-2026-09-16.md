# Hook 第一轮实施决策

实际执行日期：2026-09-17。文件名沿用 2026-09-16 Spec 的约定，不代表当日执行。

结论：**blocked**。离线版本门禁和本轮可访问源码的定点审查已交付；完整源码/构建审查未完成，Hook 真机能力未通过。没有匹配当前版本的可验证构建，不启动旧版本 DLL。未获取数据库或进程内存，未注入、登录、重启、发送或提交/推送。

## 交付及实测

- [版本门禁](../wechat_agent_poc/hook_compatibility.py)：精确版本、架构、必需模块版本/架构/允许哈希、commit 和证据完整性检查。已知冲突为 mismatch，缺失信息为 unknown，不能误报 match。match 不等于源码完整、构建通过或任何真机通过；配置声明仍需人工证据审查，工具不认证来源真实性。
- [CLI](../scripts/check_hook_compatibility.py)：只读取显式输入 JSON，独占创建结果文件，防止覆盖证据；退出码 0=match、1=mismatch/unknown、2=输入/输出错误。没有网络、进程访问或 DLL 加载逻辑。
- [测试](../tests/test_hook_compatibility.py)：18 passed / 0.30s，进程退出码 0。覆盖版本/架构/模块哈希冲突、缺元数据、非法契约、重复模块、PE 格式、证据保护及静态通过不提升真机状态。
- [安装文件基线](windows-hook-round1-observed-2026-09-17.json)：Weixin.exe 和 Weixin.dll 均为 4.1.13.65 / x64；本地曾计算 SHA-256，公开值已脱敏；未检查进程加载模块。
- [候选配置](windows-hook-round1-navysoto-profile-2026-09-17.json)及[实测门禁结果](windows-hook-round1-compatibility-2026-09-16.json)：mismatch，CLI 退出码 1 为预期判定；目标模块哈希未取得，也明确报告为缺口。
- [候选审查](windows-hook-round1-candidate-review-2026-09-16.md)：固定源码路径、收发/启动/IPC/字段问题及自主适配工作包。未把数据库格式或 Signature 字符串猜成已验证的 @ 契约。

首次 pytest 的用例执行完成，但收尾清理系统临时目录遇到 WinError 5，整次退出码 1，不能计为成功。改用项目 .local 内独立 basetemp 与缓存后重跑通过，未修改系统目录权限。只新增独立模块，未更改 Channel/Runtime/Store/outbox，无需本轮扩大为全仓回归。

执行命令（工作目录为仓库 poc）：

```powershell
.\.venv\Scripts\python.exe -X utf8 -m pytest tests/test_hook_compatibility.py --basetemp=.local/hook-round1/pytest-run1 -o cache_dir=.local/hook-round1/pytest-cache
.\.venv\Scripts\python.exe -X utf8 scripts/check_hook_compatibility.py --observed evidence/windows-hook-round1-observed-2026-09-17.json --candidate evidence/windows-hook-round1-navysoto-profile-2026-09-17.json --output evidence/windows-hook-round1-compatibility-2026-09-16.json
```

重跑 CLI 必须指定新的输出文件；现有结果不会被覆盖。基线的版本由 PowerShell FileVersionInfo 读取，架构和哈希由 inspect_pe 读取固定安装文件，不访问聊天数据。

## 验证阶段及何时开启

| 阶段 | 当前状态 | 还需什么 |
|---|---|---|
| V0 静态/合成 | partial；工具测试 passed、源码定点审查完成 | 全仓及原生桥接构建依赖完整性仍未核实，不能称为完整源码审查通过 |
| V1 副本 | not_run | 用户明确指定的可读副本、分析范围以及 D0 隔离/一致性核验；可独立于 Hook 进行 |
| V2 构建 | blocked | 完整可审查原生桥接源码及构建链；当前 PATH 未发现 dotnet/cl/msbuild/cmake，仅报告 PATH 结果，未安装工具链 |
| V3 真实进程 | blocked | 4.1.13.65 精确适配、只收不发模式、版本防护、失败清理/回退、IPC 边界，以及具体进程操作授权 |
| V4 原群接收 | not_run | V3 通过、本人/原群身份和样本范围确定，按 Spec 验收 20 条标注消息 |
| V5 ACK | not_run | V4 通过，正文/群/次数获授权，人工一次触发及双端证据 |
| V6 恢复/扩展 | not_run | 前阶段通过及恢复动作、扩展发送范围确定 |

本次“继续完成”用于执行文档规定的第一轮离线工作，不解除该 Spec 和交接中的真实进程/取密钥/发送限制。没有合格副本输入，未创建虚假的副本报告。没有可验证的运行时身份与提及语义，不创建业务 decoder 或 HookChannel。

## 下一轮最小工作

优先取得完整且可审查的候选源码/原生桥接构建链；确认是否已有适配 4.1.13.65 的实现。没有则按候选报告拆分自主适配任务，动态调试另列具体动作和授权。上述技术证据缺失时，即使授权注入，也不直接加载旧版本 DLL。

如先提供已有可读副本，可立即推进 D0-D2，不需要先解决 Hook；只验证离线字段，不形成实时收发或账号安全承诺。

开始时 HEAD 为 `9b8e0ab7315243b0a6e9f7d64fda26568b6b2026`。已有 UIA 脚本、测试、证据与 spec 修改均保留。本轮没有调用这些脚本，也没有以其他任务的 UIA 结果证明 Hook 能力。
