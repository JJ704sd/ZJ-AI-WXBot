# 观测证据夹具补强

本轮修改只涉及自建进程测试夹具及其验证脚本，未修改真实目标运行器、附加微信或读取聊天数据。目标是让下一轮方案所需的观测检查具有可运行的自建进程验证，而不是宣布 R4 根因已解决。

## 实现

- 插入硬件断点后读取 breakpoint table，核对编号、启用状态、类型和地址。绝对地址模式使用夹具 ready 文件里的函数地址作为独立参照；符号模式仅与插入响应比较，证据强度不同，结果明确记录 address_reference。
- 开始与清理前分别读取线程清单，并记录窗口内观察到的 MI 线程创建/退出通知数量。线程数量变化不被解释成全量生命周期或每线程寄存器验证。
- C 夹具记录自身主线程、旧线程、新线程的 OS 身份。正常命中场景必须核对每一个断点都命中这三个身份；新线程还必须不在初始线程清单中。公开结果仅保存计数和一致性结论。
- 结果格式从 windows-hook-attach-fixture.v1 升为 v2，增加证据字段并提高通过条件。未改业务接收契约；检索未发现仓库测试或回放脚本硬编码旧 schema。

## 实际验证

| 场景 | 结果 |
|---|---|
| 三点、绝对地址、readnever | 9 次命中；每点三个指定身份各一次；地址回读和身份核对通过 |
| 同配置空闲超时 | 0 次命中；中断、清空断点、分离及分离后夹具执行通过 |
| 单点符号模式 | 3 次命中；身份核对通过；空闲超时也通过 |
| 故意将首次 break-list 响应的一个地址改为错误值 | passed=false，明确报告 breakpoint address readback mismatch；未放行测试业务窗口 |
| 既有结果契约测试 | 11 项通过，进程退出 0；pytest 缓存目录写入权限产生非阻塞警告 |

命令入口：

```powershell
poc/.venv/Scripts/python.exe poc/scripts/verify_hook_attach_fixture.py --gcc <gcc-path>/gcc.exe --gdb <gdb-path>/gdb.exe --output-dir <新的夹具输出目录> --three-points --raw-address
poc/.venv/Scripts/python.exe -m pytest poc/tests/test_hook_probe_result.py -q --basetemp=<新的测试临时目录>
```

负例只在夹具 MI.command 返回首次 break-list 结果后替换一个地址，其他命令实际执行，目标仍由 scenario 自行创建。正常与负例原始日志在忽略目录保存。结果汇总见同名 JSON。

## 保留边界

per_thread_debug_registers_verified 与 target_process_coverage_verified 均为 false。线程枚举、调试器通知、夹具命中三者不能替代目标进程的断点寄存器覆盖、同进程独立对照或消息关联。真实运行器尚未接入本轮检查，下一轮真机条件并未因此自动满足。R4 根因和真实收消息能力继续 unknown。

独立只读复审：子 Agent 核对最新差异，确认地址回读失败会阻止通过、线程身份断言覆盖各点，且没有增加任意 PID 输入；未发现阻塞问题。
