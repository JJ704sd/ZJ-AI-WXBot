# research-v2 实施：E0正对照与E1来源采集

## 结论

按用户明确请求执行research-v2新增实验。E0正对照在修正失效判断后通过；E1采集完成、窗口世代稳定、未截断，聊天能力仍blocked。E2条件未满足，not_run。没有聊天读取、真实@、账号/群机器绑定或发送通过的证据。

## 交付

- `poc/scripts/probe_uia_research_v2.py`：独立GUI合成进程、无窗口MTA采集进程，E0/E1共用属性序列化和结构扫描路径；128节点、6层、采集子进程15秒总看门狗。超时终止的仅是探针。合成窗口由本次创建进程负责，收尾仅关闭/终止该合成进程。
- `poc/tests/test_uia_research_v2.py`：5项离线反例覆盖false、不支持、错误、非法类型、来源字符串不泄露路径；已执行通过。
- 本文及三个实际JSON收据；没有找到附件所称的配套JSON模板，使用脚本定义的`uia-research-v2/1`字段，不伪称模板已存在。

## E0过程与修正

首次run_id：8500e5af-5592-4838-94d6-6a2d601601ef，见[初次结果](uia-v2-e0-2026-09-17.json)。

真实创建普通Win32输入框、列表和按钮，探针观察到父子关系以及10个节点。Value支持、不支持属性均可区分。初次验收失败原因：窗口销毁后，旧COM对象仍返回control_type=50033，而非抛异常。不能用一次COM成功证明目标仍有效。

修正方式：将“窗口已失效”与“COM是否报错”分开。显式核验HWND有效性和PID/启动世代；另在合成对象上请求非法property_id=-1，确认COM错误保留为error，HRESULT=-2147024809，不变成false。

修正后run_id：ab5ad681-cf78-4538-bc4b-1edcbf6d85c8，见[通过结果](uia-v2-e0-revised-2026-09-17.json)。

- 输入框、列表、按钮均由真实扫描取得，对应ControlType 50004、50008、50000，父节点为根。
- 支持属性、ReservedNotSupported、真实COM错误均区分。
- closed_window_invalidated=true，closed_target_status=invalidated。
- stale_property依然记录真实返回，不篡改为error；不再作为关窗有效性判据。
- positive_control_passed=true。仅验证普通Win32探针能力，不代表Qt或微信已通过。

## E1实际结果

run_id：ff96a197-9acd-4fc8-a29b-bbd47f61b8f5，采集时间2026-09-17 07:22:58 UTC。见[完整结构证据](uia-v2-e1-2026-09-17.json)。

| 维度 | 结果 |
|---|---|
| 执行/观测/能力 | completed / observed / blocked |
| 版本 | 4.1.13.65 |
| 目标实例 | 唯一窗口，PID/进程启动时间/session/HWND/窗口类在读取前后保持一致 |
| 状态 | 最小化，非前台；本次未主动改变窗口状态 |
| 文件身份 | 已记录Weixin.exe SHA256；未重算Weixin.dll或读取进程内存 |
| 树 | 3节点，未截断；Qt根、MMUIRenderSubWindowHW、标题栏 |
| 主窗口server-side查询 | observed false |
| 渲染窗口server-side查询 | observed false |
| 两窗口FrameworkId | Win32 |
| 两窗口来源标签 | msaa / proxy / hwnd / uiautomationcore；未落原始描述及路径 |
| 根/面板Text、Text2、Value、ItemContainer属性 | GetCurrentPropertyValueEx(ignoreDefaultValue=true)返回not_supported |
| Legacy属性 | observed true |
| 标题栏Value属性 | observed true；未读取值，不能作为聊天输入框或消息候选 |
| 账号、群、原生@ | 均未验证；未从配置复制 |

这是“本次两个HWND查询未检测到server-side provider，返回Win32/MSAA代理线索，范围内只有外壳”的证据。不能外推整个微信进程、所有账号或所有状态永远没有provider。

历史探针用默认属性读取返回false，新探针忽略默认值返回not_supported；保留历史事实并提高新结果粒度，不伪称已证明原实现有确定bug。Microsoft API依据：[GetCurrentPropertyValueEx](https://learn.microsoft.com/en-us/windows/win32/api/uiautomationclient/nf-uiautomationclient-iuiautomationelement-getcurrentpropertyvalueex)、[server-side查询](https://learn.microsoft.com/en-us/windows/win32/api/uiautomationcoreapi/nf-uiautomationcoreapi-uiahasserversideprovider)、[MTA线程建议](https://learn.microsoft.com/en-us/windows/win32/winauto/uiauto-threading)。

## E2与权限

未出现mmui局部/聊天语义候选；仅有标题栏属性不满足条件。E2不执行，不要求用户点击输入区来重复旧试验。后续B01—B12仍未达到准入。

只读范围来自本任务既有单号单群授权及本轮执行最新方案请求，不能被当成机器独立账号确认。未重启、扫码、换号、切群、发送、取钥、OCR、改注册表/客户端内存、安装服务或调用M3。E0只短暂显示合成窗口且不主动抢焦点。正常UIA查询可能触发客户端自身初始化，不承诺零内部副作用或零风控。

## 命令

仓库根目录，E0通过后才执行E1；不得批量无条件循环。

```powershell
.\.research\wxauto4-41.1.7-audit\venv\Scripts\python.exe -X utf8 poc\scripts\probe_uia_research_v2.py E0 --output poc\evidence\uia-v2-e0-revised-2026-09-17.json
.\.research\wxauto4-41.1.7-audit\venv\Scripts\python.exe -X utf8 poc\scripts\probe_uia_research_v2.py E1 --output poc\evidence\uia-v2-e1-2026-09-17.json
```

上列为本次命令记录；复验须换输出文件名，保留历史收据。源码哈希已保存在每次收据内，E0初版与修正版不同。没有将合成窗口节点写入微信结果。未commit/push，未覆盖其他Hook/API工作。
