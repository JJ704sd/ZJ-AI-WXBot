# 观测检查接入与故障回放

本轮把上一轮夹具验证的检查接入私有 v3 观测运行器，并用自建进程回放其事件循环及结果收口。v2 保留不变。未执行 v3 的真实进程前置检查/附加路径，未新增微信实验或更改候选地址。

## 完成的实现

- 独立文本校验模块核对断点编号、类型、启用状态、地址及集合，拒绝重复编号、坏记录和不支持的多位置记录。线程清单必须非空、唯一且数量一致。不构造通用 MI 解析器。
- v3 在继续执行前核验断点地址，并记录初始线程清单；清理阶段尝试最终线程清单，保存计数与观察到的生命周期通知数，不保存消息内容。
- 最终线程清单失败会设置 observation_evidence_error，但继续清除断点和分离。结果契约将这种失败归为 inconclusive / exit_code=2。
- 回放器新增地址错误和最终线程清单错误两种可复现故障；最终清单故障只能在 cleanup 阶段触发。检查故障确实注入、状态字段、实际退出码以及夹具分离后仍完成执行。

## 实测结果

| 场景 | 命中 | 引擎退出码 | 清理和夹具后续执行 |
|---|---:|---:|---|
| v3 正常窗口 | 3 | 0 | 通过 |
| v3 命令错误 | 0 | 2 | 通过 |
| v3 地址回读不一致 | 0 | 2 | 通过 |
| v3 最终线程清单错误 | 3 | 2 | 通过 |
| v2 正常窗口兼容回放 | 3 | 0 | 通过 |

结果契约先新增失败用例，实际出现“预期退出码 2、实际 0”的失败，再修改实现转绿。新增 MI 校验测试与结果契约测试合计 27 项通过。v3 正常回放的地址回读通过；三个故障回放都未被误当正常零命中。最终清单负例即使 stop_reason 为 marker_window_complete、已有 3 次命中，仍通过 finalize_probe_result 输出 failed / inconclusive / exit_code=2。

命令入口（输出目录每次使用新路径）：

```powershell
poc/.venv/Scripts/python.exe poc/scripts/verify_hook_runner_replay.py --runner poc/.local/hook-round1/run_inbound_three_point_probe_v3.py --gcc <gcc-path>/gcc.exe --output-dir <新的回放目录>
# 分别附加 --inject-command-error / --inject-readback-error / --inject-final-thread-error 验证故障
poc/.venv/Scripts/python.exe -m pytest poc/tests/test_hook_observer_evidence.py poc/tests/test_hook_probe_result.py -q -p no:cacheprovider
```

哈希与完整脱敏结果见同名 JSON。测试回放用自建子进程替换前置目标选择，缩短等待窗口；并不测试真实前置身份检查、完整真实窗口或微信本体。回放执行经审查的可信运行器源码，不是任意代码沙箱，禁止把该描述当作可执行不可信脚本的隔离保证。

## 仍不能关闭的事项

- v3 保持旧三点配置；业务推送/B/旧候选的新三点草案尚未替换进去。
- -thread-list-ids 只提供调试器线程清单，生命周期记录只是收到的通知，未验证每线程调试寄存器或覆盖完整性。两个覆盖标志仍为 false。
- 初始清单外的线程仅按 GDB 身份分类，不认定其是某个微信业务线程；上一轮夹具自身 OS 身份证明不能移植为真实进程身份。
- 尚无同进程独立正向对照或目标消息关联，R4 根因和真实接收能力维持 unknown。这里的“已接入”仅指代码与自建进程回放，不代表已经执行微信实验。

子 Agent 分工：轻量实现 Agent 完成纯文本校验与测试，独立只读 Agent 检查回放负例验收条件；主 Agent 接入、修正审查意见并完成全部端到端回放。
