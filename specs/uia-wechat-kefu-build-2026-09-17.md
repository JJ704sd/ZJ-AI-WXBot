# UIA 重启构建：wechat-kefu 源码研究与读取基础

日期：2026-09-17。用户本轮明确要求学习 wechat-kefu 并推进 UIA，作为本轮恢复 UIA 构建的依据；覆盖旧交接中“当前不继续 UIA”的阶段安排。不自动恢复数据库取钥、OCR、降级客户端、真实发送或长期后台任务。既有 861/API 工作保留。

**最新执行状态：** 已隔离安装wxauto4==41.1.7并锁定全部依赖；12项离线测试通过。对当前Weixin 4.1.13.65的一次有界实机探测失败于构造阶段，未进入ChatInfo，已按要求停止。详见 [本轮探测证据](../poc/evidence/wxauto4-probe-2026-09-17.md)。下文“未安装”属于此前构建记录；第4节第1—2步现已有结果，禁止按第5节模板自动重复探测。

## 1. 源码依据

v3看门狗续验：3项真实自建子进程故障样本通过，超时清理无残留；N1正常路径回归和9项离线反例通过。本轮未访问微信，不改变blocked状态。见 [看门狗续验](../poc/evidence/uia-v3-watchdog-followup-2026-09-17.md)。

v3已审查并完成合成原生provider对照：N0为false，WPF N1实际为true，直接只读ValuePattern及生命周期检查通过；9项离线测试通过。未发现影响旧微信记录的依据，本轮不重跑E1/E2。见 [v3执行报告](../poc/evidence/uia-v3-review-and-native-control-2026-09-17.md)。不代表微信UIA恢复。

research-v2已执行：E0修正关窗后COM缓存判据后通过；E1两个HWND的server-side查询false、来源为Win32/MSAA代理，3节点未截断；属性区分为not_supported而非默认false。E2未满足条件，不运行。见 [E0/E1实际执行记录](../poc/evidence/uia-research-v2-execution-2026-09-17.md)。聊天读取仍blocked。

交接总入口：[UIA卡点总表](uia-blockers-register-2026-09-17.md)。集中区分直接阻塞、已测方法、未证实根因、后续业务缺口与继续条件；仅汇总既有证据，不代表新增实机成功。

最新跨机制分流：独立CUIAutomation8实测仍为外壳；腾讯官方插件仅声明单聊；861默认设备key文件缺失，手机端adb不在PATH。详见 [接入机制矩阵](wechat-access-route-matrix-2026-09-17.md)。这些分别属于实机、源码和环境前置证据，不构成聊天接入完成。

最新多入口验证：FindAll仅返回渲染面板，Legacy选择对象为空，MSAA焦点对象为空；位置命中因遮挡跳过。新增探针语法检查及实机运行完成，聊天读取未成立。见 [多入口证据](../poc/evidence/uia-alternative-entrypoints-2026-09-17.md)。

最新低侵入构建：新增只查询接口存在性的被动探针，修复login_required分类，27项相关测试通过。曾真实观察到mmui::LoginWindow，但随后窗口变成Qt外壳，Text/Text2/Value/ItemContainer均不可用。登录页可见不是聊天接入成功。详见 [被动探测](../poc/evidence/uia-passive-patterns-2026-09-17.md)。本轮未采用内存写入方案。

最新源码审查：已排除 Raw View 过滤遗漏；发现公开同版适配依赖进程内可访问性状态写入，无法作为只读选择器修复直接执行。已记录调用副作用、恢复缺陷和后续实验边界，见 [修复路线审查](../poc/evidence/uia-source-remediation-review-2026-09-17.md)。当前仍未修复，真实消息与 @ 未验证。

最新环境排除：诊断与Weixin同桌面会话、同高完整性级别、均64位；微信已加载Oleacc和UIAutomationCore。无需重复提权或重装系统组件。见 [环境检查](../poc/evidence/uia-environment-check-2026-09-17.md)。这不改变纯UIA消息读取未成立的结论。

最新续验：用户重新打开客户端后，标准WM_GETOBJECT/UIA_ROOT请求在最小化和还原状态均完成，但未产生语义控件。当前4.1.13.65仍为missing_semantic_controls。见 [标准请求对照](../poc/evidence/uia-activation-attempt-2026-09-17.md)，无需重复该实验。

连续排查补充：已验证MSAA OBJID_CLIENT也只返回无子控件的渲染面板，调用后UIA未变化；公开分支源码表明Win32 Qt类正常，真正缺失的是mmui语义UIA树。见 [MSAA与源码对照](../poc/evidence/uia-msaa-investigation-2026-09-17.md)。后续不重复这些已完成实验。

最新结构定位：wxauto4期望mmui::MainWindow，实际UIA类为Qt51514QWindowIcon；窗口还原后渲染面板仍无子控件。已增加构造前兼容性阻断，18项相关测试通过。见 [选择器与结构证据](../poc/evidence/wxauto4-selector-diagnosis-2026-09-17.md)。真实消息读取仍未修复，不以替换类名强行放行。

后续已按用户“继续”执行一次新增异常定位诊断：失败位置为wx.py:340 → ui/main.py:211，仍未进入ChatInfo，具体原因未知。见 [构造诊断记录](../poc/evidence/wxauto4-constructor-diagnosis-2026-09-17.md)。此记录不授权自动重跑。

已下载仅供审阅，未运行上游入口或安装其依赖。固定提交：`1cb3005b643376ab9520d08918bf89afe4fed1dd`，本地 `.research/wechat-kefu-20260917`。

- [driver.py](https://github.com/838997125/wechat-kefu/blob/1cb3005b643376ab9520d08918bf89afe4fed1dd/app/driver.py)：GetSession未读提示 → ChatWith → ChatInfo → GetAllMessage；首次基线；SendMsg(at=昵称列表)。
- [bot.py](https://github.com/838997125/wechat-kefu/blob/1cb3005b643376ab9520d08918bf89afe4fed1dd/app/bot.py)：单线程驱动与命令队列，有限重连。
- [README](https://github.com/838997125/wechat-kefu/blob/1cb3005b643376ab9520d08918bf89afe4fed1dd/README.md)：声明实测 PC微信4.1.8.107。本机旧证据为4.1.13.65仅Qt外壳，尚无新版本兼容实测。
- LICENSE为MIT；本轮代码独立编写，没有复制上游代码。将来移植源码应保留许可证声明。

## 2. 采用与调整

| 上游思路 | 本项目处理 |
|---|---|
| UI对象线程亲和、串行命令 | 采用单线程读取检查，未来发送同一工作线程串行执行 |
| 主窗口按未读标记轮询 | 可作提示，不能作消息完整性证明；当前打开会话可能没有未读徽标 |
| 首次全列表基线 | 只在明确目标会话做有界可见快照，首次不派发；不宣称覆盖历史或所有新增消息 |
| ChatInfo核对群名 | 上游失败时返回True，本项目禁止；还需账号/群核验证据，群名不够 |
| chat/attr/type/sender/content指纹 | 不采用为唯一消息键，避免同人同文两条误去重；缺可靠会话内UI身份就阻断 |
| SendMsg返回成功 | 仅可能表示本地提交，不代表送达；异常视实际提交阶段判断，不自动重试 |
| 昵称@ | 不能证明结构化@本人；未知保持unknown，不能触发AI或发送 |
| 失效自动重连 | 本轮暂停并重建基线，不继承旧UI句柄/审批，不反复拉起微信 |

## 3. 已实现

- `poc/wechat_agent_poc/uia_session.py`：隔离读取基础。读取前后核对会话与世代；要求账号/群已核实及未锁屏；首次仅基线，同文不同UI ID可区分；本人/非文本不输出，mention保持unknown；丢失快照交集视为连续性未知并暂停；失败后不隐式重试。
- `poc/scripts/probe_wxauto4_capability.py`：默认只检查依赖；显式`--live`才构造wxauto4并检查ChatInfo，输出脱敏布尔能力，无消息正文读取或发送。构造驱动可能激活窗口，执行前审阅安装版本；不得使用上游启动/自启动脚本。
- `poc/tests/test_uia_session.py`：9项合成测试通过。并非真实wxauto4后端、COM线程初始化或客户端兼容性证明。

当前环境检查：`wxauto4_installed=false`。本轮未安装wxauto4、未读微信UI树、未修改客户端、未取钥、未调用M3、未发送。新读取基础尚未接入既有runner/API Channel；API状态库及旧发送器均未改变。

UI ID只在已核对的generation内有效，不是微信原生消息ID；控件复用、可见区域滚动或窗口重建仍需实测。seen集合仅用于当前有界运行，不持久复用；长期稳定性未验收。账号/群已验证标志由可信后端独立观察生成，严禁从配置中的目标值直接复制为True。

## 4. 下一步推进顺序

1. 隔离核查wxauto4包实际版本、源码、许可证和构造副作用，锁定版本；不要安装上游整个应用、Web管理面板、托盘或开机自启。当前依赖清单未锁版本，不能盲目复用。
2. 精确记录当前Weixin版本，针对wxauto4路径做一次有界ChatInfo能力探测。若仍只有Qt外壳，记录该机制不成立，停止本路径，不反复做旧FlaUI/讲述人/读屏标志实验，不降级客户端。
3. 只有控件可读后才实现生产后端：在同一COM/UIA线程提供observe/read_visible，证明账号、目标群及UI ID稳定性；完成切群、锁屏、相同正文连续两条、窗口重建反例。默认只读。
4. 单群新消息可读以后，独立验证真实@字段。只见昵称文本而无可靠语义则保持未知，不自动回复。
5. 固定文字发送、M3自动回复、两人定时@依次按有效实验范围推进；实际发送仍需明确启动与接收核验。不以此源码项目自述替代本机实测。

## 5. 复用提示词

```text
按 specs/uia-wechat-kefu-build-2026-09-17.md 继续UIA只读构建。先核对wxauto4实际依赖源码与版本，隔离安装并锁定，再对当前Weixin版本做一次有界ChatInfo能力探测。不要运行wechat-kefu聚合入口或旧发送脚本，不安装自启动，不降级、不OCR、不取数据库密钥，不发送。
控件不可读时记录明确失败，停止重复UIA激活试验；控件可读时才实现UiaSessionReader真实后端，独立确认账号/目标群和UI消息身份，不从配置伪造观察。保留861/API及用户已有工作，不commit/push。
先离线反例再真实只读验证，分开报告源码自述、合成通过、真实控件可见、新消息可读和真实@可靠。没有实机证据不标UIA接入完成。
```

## 回归补充

完整回归除1项失败和1项skip外通过；失败为既有test_local_binding_write_stays_in_dot_local，原因是测试临时根设在.local内使其outside路径仍含.local。换到不含.local的独立临时根后该项通过；中间一次复验因临时根父目录不存在而setup失败，随后正确复验通过。未修改既有绑定实现或测试，没有将不同运行合并为一次全通过。临时复验文件已清理。
