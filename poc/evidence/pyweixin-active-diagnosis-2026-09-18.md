# pyweixin 主动诊断与 Qt 候选预检

日期：2026-09-18。用户要求沿既定项目框架主动破解验证。仍针对当前账号／原混合群，不转用其他通道。

## 本轮新增结论

1. **修复了自有探针的真实缺陷。** 当前有 6 个同路径 Weixin.exe 进程，旧探针要求进程唯一，误将正常多进程架构判成无法绑定。先用合成多进程测试复现失败，再按唯一原生主窗口＋所属进程＋前后世代校验修复；两个主窗口仍阻断。不能通过选择第一个进程解决。
2. **直接 pywinauto 已执行。** 独立 Python 3.12.13 环境安装固定五项依赖；没有安装上游完整包或改业务环境。修复后绑定唯一窗口，微信 4.1.13.65，完整遍历 2 节点，root_class=Qt51514QWindowIcon，sessions/messages/input 均 false，前后绑定稳定。
3. **排除了本次“COM 错误被吞成空列表”的误判。** pywinauto 0.6.9 的 `_get_elements` 捕获 COMError/ValueError 后返回空列表。本地探针改为直接调用其底层 UIA FindAll，异常向上作为 incomplete；严格版本实机结果仍为完整 2 节点。不是只靠 Computer Use 的格式化树下结论。
4. **发现可审查的 Qt 可访问性候选。** 固定参考提交 `47a660068e2a460011c58316166473fa7aab9eac`，只提取五个已阅读的静态扫描方法，不导入聚合驱动、不执行热写入口。对磁盘 Weixin.dll 扫描，启发式过滤后保留一个与固定版本表相符的候选；目标地址和模块摘要不在公开记录中。这是候选定位，不是开关语义或因果验证。
5. **只读运行时预检成功。** 主窗口唯一、进程和模块归属稳定，已加载 DLL 路径与固定磁盘 SHA-256 匹配；仅读取候选位置 1 字节，当前值为 0。没有读密钥、聊天库或任意消息对象，没有写进程内存。

## 固定证据

- [严格结构收据](pyweixin-direct-structure-2026-09-18.json)：运行编号已脱敏。
- [静态候选](pyweixin-qt-static-2026-09-18.json)：目标模块摘要、文件大小与地址已脱敏。
- [一字节只读预检](pyweixin-qt-preflight-2026-09-18.json)：mode=read_only_preflight，write_authorized_flag=false，current_byte=0。
- 参考源码：[固定提交 uia_driver.py](https://github.com/fanyuantaier/wechatauto-replica/blob/47a660068e2a460011c58316166473fa7aab9eac/wechatauto/uia_driver.py)。其中成功后保留修改、试写多个候选、恢复未充分核验的聚合流程没有执行。
- [pywechat 维护说明](https://github.com/Hello-Mr-Crab/pywechat/blob/ebe8d4be9347816d221c38843e5b9e5e480bd8fb/Weixin4.0.md)明确存在 UI 可见性前置；其账号策略解释是维护者判断，不是本机根因证明。
- [pywinauto 官方说明](https://pywinauto.readthedocs.io/en/latest/HowTo.html)：可以按进程／handle 连接；不同 backend 的控件边界不同。

早期两份 direct-structure 收据停在多进程检查，既没有执行聊天树读取，也不能算 UIA 失败；它们保留于工作区研究目录。后续修复和严格枚举分别运行，各自保留独立收据。没有盲目重复相同探针。

## 已准备、尚未执行的最小实验

工具：`poc/scripts/qt_accessibility_preflight.py`，默认只读；写入需显式 `--allow-temporary-byte-write`。固定唯一 DLL 哈希、版本目录、唯一窗口与所属进程、已加载模块，不接受任意地址或任意写值。事务逻辑见 `poc/wechat_agent_poc/qt_accessibility_trial.py`。

拟实验顺序：重新只读预检 → 原始树观测 → 确认原字节为 0 → 一次写 1 并读回 → 在独立子进程最多 15 秒观测结构 → finally 恢复 0 并读回 → 再观测。仅作用于已持有句柄的原进程和固定模块，不通过 PID 重开另一进程；模块不可用时停止并报告恢复失败。没有消息读取、AI、登录、输入或发送。

15 秒仅是每次结构采集子进程的限时，不是所有 Win32 调用或整轮实验的硬截止。强制终止执行器、进程崩溃等情况不能保证 finally 完成；即使原字节恢复，也不能保证 Qt 内部缓存、provider 状态或客户端风控状态恢复。固定磁盘哈希和已加载路径也不证明整个进程映像从未被其他组件修改。

**本轮只构建并离线验证这项写入实验，未执行。** 它跨越先前只读检查范围，须由用户明确允许一次临时进程字节修改；不能把上游说明或“候选唯一”当作写入授权。确认前没有发出带写入参数的命令。

## 测试与剩余工作

相关测试最终 **41 项通过**。涵盖多进程唯一主窗口、双主窗口歧义、COM 异常传播、元数据准入、既有读取控制，以及字节事务成功恢复、观察失败、部分写入失败、读回不符、初始值不符、窗口变化、中断和恢复失败。窗口中途变更用例先失败再修复。事务测试使用合成端口，不能当作真实 WriteProcessMemory／回滚验收。

独立环境：工作区 `research/pywechat-20260917/runtime`。锁定列表：[requirements-pyweixin-probe.lock](../requirements-pyweixin-probe.lock)。静态扫描复现脚本保留于 `research/pywechat-20260917/audit_qt_candidate.py`，依赖本地已固定的参考源码；它不是任意来源代码的安全沙箱。

实际只读命令（工作区根）：

```powershell
<private-python> -X utf8 ZJ-AI-WXBot/poc/scripts/probe_pyweixin_structure.py --exe "C:\path\to\Weixin\Weixin.exe" --output research/pywechat-20260917/direct-structure-strict-20260918.json
.\research\pywechat-20260917\runtime\Scripts\python.exe -X utf8 ZJ-AI-WXBot/poc/scripts/qt_accessibility_preflight.py --output research/pywechat-20260917/qt-byte-preflight-20260918.json
```

复验需新收据文件名，工具拒绝覆盖。真实收发和 Agent 接入仍未通过；若未来临时状态实验恢复了控件，也仅说明结构可见，仍需原账号／群绑定、接收语义与审批发送验收。不提交、不推送。
