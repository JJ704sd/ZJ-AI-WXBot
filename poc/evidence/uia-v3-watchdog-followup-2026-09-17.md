# v3续验：看门狗故障注入与正常路径回归

本轮只补齐上一轮明确未实测的子进程超时路径，不访问微信，不重跑E1/E2。

## 改动

`probe_uia_v3_native.py`新增run_collection，统一记录超时、缺报告、非零退出；失败结果有run_id/时间及passed=false。看门狗跟踪且仅清理本次启动的采集进程及其子进程，避免只结束Python启动器却遗漏实际采集进程。成功路径继续使用原采集结果，不重写历史收据。

新增`verify_uia_watchdog.py`，创建无GUI的自有挂起进程及子进程。它不读取其他应用，也不模拟微信数据。

## 实测

| 故障或回归 | 结果 |
|---|---|
| 自建进程及子进程挂起 | 2秒测试预算，约2.109秒返回timed_out；跟踪6个进程（含启动器层级），清理错误为空、remaining_pids为空；另核对测试子进程PID已消失 |
| 进程退出0但无报告 | error / FileNotFoundError，不算成功 |
| 报告宣称成功但进程退出3 | error / WorkerExitError、passed=false，不信任遗留成功报告 |
| WPF N1正常路径回归 | completed、passed=true；只读ValuePattern与合成值匹配，目标关窗invalidated |
| 离线分类与验收反例 | 9项通过；与上述3个真实子进程故障样本分别统计 |

故障收据：[uia-v3-watchdog-2026-09-17.json](uia-v3-watchdog-2026-09-17.json)。正常回归run_id：537afc15-38e2-43bb-81f2-2923aa34714a，见[正常路径收据](uia-v3-n1-watchdog-regression-2026-09-17.json)。

命令（仓库根）：

```powershell
.\.research\wxauto4-41.1.7-audit\venv\Scripts\python.exe -X utf8 poc\scripts\verify_uia_watchdog.py poc\evidence\uia-v3-watchdog-2026-09-17.json
.\.research\wxauto4-41.1.7-audit\venv\Scripts\python.exe -X utf8 poc\scripts\probe_uia_v3_native.py N1 --output poc\evidence\uia-v3-n1-watchdog-regression-2026-09-17.json
```

## 限制与停点

真实故障注入使用sleep挂起，不是人为制造COM系统死锁；验证的是外层进程预算和所测进程树清理，不声称任何恶意/脱离父进程的子进程都能追踪。正常采集预算仍为15秒，2秒仅供故障样本。没有在微信上触发超时。

这次改进诊断可靠性，没有产生聊天语义候选，也没有推翻旧E1外壳观察。UIA聊天读取仍blocked，E2仍不满足条件。没有继续轮换UIA接口、自动激活或扩大到内存修改。未commit/push，保留其他工作。
