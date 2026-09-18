# Hook 观测异常排查与修复

日期：2026-09-18。范围：自建进程、保存的 R4 运行器回放与离线测试；本轮未附加微信、未读取消息对象、未注入 DLL。

## 结论

已复现并修复运行器“发生异常却返回退出码 0”的问题。R4 本身记录为正常完成窗口、零命中且清理成功，因此该缺陷不能解释 R4 零命中；真实接收入口仍未验证。

## 对照证据

| 假设/场景 | 实际结果 | 判断 |
| --- | --- | --- |
| 禁止符号加载、绝对地址断点导致普遍漏报 | `--readnever`、关闭自动符号加载，两轮三点自建测试均捕获 9 次，覆盖 3 个线程；空闲超时也清理成功 | 不支持普遍失效，不能外推微信线程覆盖 |
| 原 R4 事件解析器无法记录命中 | 原运行器主体回放捕获自建进程 3 次已知命中 | 未复现普遍解析丢失 |
| 原运行器吞掉执行异常 | 附加自建进程后故意提交无效命令，记录 `command_failed`，但进程退出 0 | 已确认缺陷 |
| 修复后的异常路径 | 同一受控错误返回 2；断点表为空、已分离、自建进程完成后续调用 | 修复验证通过 |
| 修复后的正常路径 | 捕获 3 次命中，退出 0，清理及后续调用通过 | 正常行为保留 |

回放仅替换真实进程预检为本脚本创建的子进程，并缩短基线和观测窗口。它验证运行器主体，不覆盖微信模块装载、线程数量、进程特性或接收语义。

## 实现

- `wechat_agent_poc/hook_probe_result.py` 统一结果判定：执行/清理异常返回 2；未打开标记窗口或窗口截断返回 3；完整且清理成功的观测返回 0。
- 正常零命中标为 `no_hits`；存在命中也仅为 `hits_observed`。`receive_entry_verified` 始终为 false，不能以命中数量代替接收语义验证。
- `scripts/verify_hook_runner_replay.py` 提供自建进程错误注入和已知命中回放；`verify_hook_attach_fixture.py` 增加无符号绝对地址配置。
- 私有 `run_inbound_three_point_probe_v2.py` 已接入结果判定和非零退出；原 R4 运行器保留为实验原件。新版本未对微信执行。

## 验证与复现

在 `poc` 目录执行，输出目录必须不存在：

```powershell
./.venv/Scripts/python.exe -X utf8 scripts/verify_hook_attach_fixture.py --gcc C:/mingw64/bin/gcc.exe --gdb C:/mingw64/bin/gdb.exe --output-dir .local/hook-round1/raw-address-diagnosis-2 --three-points --raw-address
./.venv/Scripts/python.exe -X utf8 scripts/verify_hook_runner_replay.py --runner .local/hook-round1/run_inbound_three_point_probe_v2.py --gcc C:/mingw64/bin/gcc.exe --output-dir .local/hook-round1/runner-replay-green --inject-command-error
$tests = @(Get-ChildItem tests/test_hook_*.py | ForEach-Object { $_.FullName })
./.venv/Scripts/python.exe -X utf8 -m pytest @tests -q -p no:cacheprovider --basetemp=.local/hook-round1/pytest-diagnosis-final
```

56 项 Hook 测试通过，最终命令退出 0。首次运行所有断言已完成，但 pytest 清理共享临时目录时出现 WinError 5，进程退出 1；改用项目隔离临时目录后完整通过，未修改业务逻辑规避测试。新增结果判定测试覆盖错误、清理不确定、时间上限、窗口缺失/截断及命中不等于验收。

## 剩余卡点和下一步

R4 入站样本方向与时间窗口已有用户确认。现在需要区分“选中的代码路径未处理该入站消息”与“真实进程中的观测覆盖不足”。当前自建测试不能区分二者，也不能证明地址迁移或消息对象布局正确。

下一轮真机方案应先具备同一进程内独立可证的正向对照，或取得独立的候选路径证据，并明确线程覆盖、停止条件和判定规则；在此前提不足时，不重复相同三点零命中实验。R4 单次额度已使用，本次修复没有追加真机附加，也没有开启 DLL/IPC 集成。
