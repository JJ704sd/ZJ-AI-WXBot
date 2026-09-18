# pyweixin 当前账号／原混合群构建

## 目标与决定

最新状态见[可见群详情采样与恢复](../poc/evidence/pyweixin-group-details-visible-2026-09-18.md)：详情面板已能打开并确认关闭，两个实测回合均恢复原字节；定位到 ListItem 标签遗漏并修正。详情词匹配 1/3、成员特征匹配 0/6，身份绑定仍不通过。54 项相关离线测试通过。

最新推进见[原群详情面板实测](../poc/evidence/pyweixin-group-details-click-2026-09-18.md)：采用上游点击方式后首次定位唯一群详情面板，结构 15 节点；配置的详情词与成员特征均未匹配。字节恢复已确认，面板关闭尚未确认。身份绑定仍不通过。

最新状态见[原群详情核验](../poc/evidence/pyweixin-group-details-2026-09-18.md)：已构建详情／成员本地比对探针，但本轮精确标题控件缺失，未打开详情面板；所有临时字节已恢复。53 项相关测试通过。此前成功标题观察是历史瞬时证据，不能代替当前门禁。

最新验证见[完整结构与目标标题实测](../poc/evidence/pyweixin-title-binding-retry-2026-09-18.md)：147 个结构节点无截断，三个语义锚点和唯一目标标题匹配通过，临时字节恢复为 0。账号／群稳定身份仍未验证；上游会话 AutomationId 使用显示名，不能当作服务器群 ID。下面为历史阶段记录。

最新验证见[深层结构实验](../poc/evidence/pyweixin-qt-deep-structure-2026-09-18.md)：会话列表、消息列表和 chat_input_field 输入框分别在 14／16／18 层实际定位，原字节已恢复。全树仍有深度截断；账号／原群绑定及真实消息读取待验收。以下保留此前阶段记录。

最新验证见[一次实机修改与恢复](../poc/evidence/pyweixin-qt-one-shot-2026-09-18.md)：候选字节 0→1→0 已执行并读回恢复；根节点随之从 Qt 外壳变为 mmui::MainWindow，再恢复外壳。临时状态遍历到 38 节点但不完整，消息列表／输入框和原群接入仍未验收。以下为各阶段历史记录。

最新实机动作见[一次性实验写入前停止记录](../poc/evidence/pyweixin-qt-trial-stop-2026-09-18.md)：用户已允许限定实验，但工具在写入前停止；后续只读检查发现可见主窗口为 0，实际内存修改 0 次。需要当前微信主窗口保持可见后继续核验。

最新进展见[主动诊断与 Qt 候选预检](../poc/evidence/pyweixin-active-diagnosis-2026-09-18.md)：已修复多进程绑定误判，直接 pywinauto 严格枚举仍为 2 节点；定位到一个静态 Qt 状态候选并只读确认值为 0。一次性临时写入实验已准备，未执行。下文保留此前阶段记录。

2026-09-18，用户选择仅推进 pywechat 仓库的 pyweixin 路线，且坚持当前账号及原混合群。复用现有 Agent；不以新账号、其他群或离线 mock 替代目标验收。首轮仍为合成消息和人工逐条确认发送。

本轮交付为入口检查与源码修补包，**不是已接通微信的机器人**。接收后端、稳定账号／群绑定、原生 @ 接收识别、真实发送和双端送达均未验收。

## 已构建

1. `poc/scripts/prepare_pyweixin_patch.py`：严格校验固定版本 WeChatAuto.py SHA-256（摘要由本地私密参数提供），生成独立源码副本，保留上游 LICENSE；拒绝覆盖已有目录。修复群发送者未匹配异常、沿用上一发送者、昵称正则误匹配，以及精确 2000 字符漏发。重复或前缀歧义昵称返回 None 并保留原文；昵称匹配不升级为成员稳定身份。
2. `poc/scripts/check_pyweixin_regressions.py`：仅提取 AST 中已审查的纯逻辑，以合成样例复验；不导入上游包、不访问 UI。只能用于可信且已审查的固定源码，AST 提取本身不是安全沙箱。
3. `poc/scripts/probe_pyweixin_structure.py`：有界 pywinauto 结构探针。唯一进程与窗口、精确版本、前后 PID／进程世代／窗口检查，最多处理 128 节点／6 层，独立采集进程 15 秒超时。只比较结构 List 标签及输入框 AutomationId，不读取消息条目正文，不截图、不改焦点、不输入、不发送。达到预算或最小化均记 incomplete；账号和群始终未验证。一次 children() 枚举本身不保证只返回 128 项，15 秒外层超时限制总采集。
4. `poc/scripts/qt_accessibility_preflight.py`：公开代码不内置本机路径、模块摘要或地址；本地诊断需通过 `PYWEIXIN_EXE`、`PYWEIXIN_DLL`、`PYWEIXIN_DLL_SHA256` 和 `PYWEIXIN_GATE_RVA` 注入私密配置，公开收据不回写这些值。
4. `poc/wechat_agent_poc/pyweixin_admission.py`：专门按上游入口要求 mmui::MainWindow；不因 Qt 外壳存在就准入。输出包含缺失控件、read_verified=false、send_enabled=false、agent_enabled=false、mention_status=unknown。

原上游源码未修改、未安装包、未升级现有环境依赖。补丁只覆盖上述明确函数，不宣称修复上游所有监听／发送入口。源码许可证文件与元数据版本不一致的问题仍保留。

## 实际验证

- 原源码 9 个离线样例：3 通过、6 失败，含 UnboundLocalError；修补副本 9 个全部通过。
- 新准入与既有 UIA 读取控制首轮 23 项通过；加入探针失败路径后，相关检查共 27 项通过。覆盖超时、退出 0 无收据、写成功收据却非零退出、已有证据拒绝覆盖；子进程边界采用替身，并未制造真实微信挂起。
- 本轮通过 Computer Use 查询到唯一微信窗口；第一次结构捕获返回 window minimized。按恢复流程刷新窗口时绑定不再匹配，停止，未执行激活操作，未取得结构树。因此本轮结果为 **observation_incomplete**，不能推断当前聊天树仍缺失，更不能推断它已恢复。
- 新 pywinauto 实机探针本轮没有运行。Computer Use 的本轮规则要求 Windows 自动化只用其 JS API；未在同一轮换到脚本绕过该边界。探针已构建供后续独立实验使用。
- 群成员、当前账号及聊天正文未被本轮采样；未调用模型、发送或登录。没有 commit/push。

## 能力与权限表

| 能力 | 当前代码或证据 | 开放条件 |
|---|---|---|
| 进程／窗口结构检查 | 已有有界实现；本轮桌面观测不完整 | 解锁桌面、目标窗口可见、唯一归属 |
| 群发送者显示名解析 | 合成缺陷已修复 | 不能替代成员 ID；歧义保留 unknown |
| 真实账号／原群绑定 | 未实现并验证 | 独立观察依据，不能只用同名标题或预填配置 |
| 连续新消息 | 既有 UiaSessionReader 离线基础 | 真实后端、同文重复、重绘、跨屏、锁屏／重建反例 |
| 接收原生 @本人 | 未验证 | 正文字符串不算证据；结构字段及正反例 |
| AI 草稿 | 既有 Agent 基础，未连接 pyweixin | 接收及绑定通过；仅已授权测试数据与模型 |
| 原群发送及原生 @成员 | 上游有 UI 实现，未启用 | 人工逐条审批、准确群和成员、固定内容、双端核验 |
| 自动回复／主动定时发言 | 未开放 | 不能由结构测试或手工单次成功自动升级 |

## 复现与下一步

以下从本地工作区执行。现有输出不覆盖，复验时改为新的目录／收据名。

```powershell
.\ZJ-AI-WXBot\poc\.venv\Scripts\python.exe -X utf8 ZJ-AI-WXBot/poc/scripts/prepare_pyweixin_patch.py --source research/pywechat-20260917/upstream --destination research/pywechat-20260917/patched-20260918 --expected-upstream-sha256 <private-upstream-sha256>
.\ZJ-AI-WXBot\poc\.venv\Scripts\python.exe -X utf8 ZJ-AI-WXBot/poc/scripts/check_pyweixin_regressions.py research/pywechat-20260917/patched-20260918/src/pyweixin/WeChatAuto.py --output research/pywechat-20260917/regressions-after.json
```

未来独立实机回合，可使用已具备 pywinauto／psutil／pywin32 的隔离解释器运行：

```powershell
python -X utf8 ZJ-AI-WXBot/poc/scripts/probe_pyweixin_structure.py --exe "C:\path\to\Weixin\Weixin.exe" --output research/pywechat-20260917/structure-new-run.json
```

退出 2 是阻塞或不完整；退出 0 也仅表示 structure_candidate_only，不代表账号、群或接入成功。不要执行上游 AutoReply 或 send_messages_to_friend 来代替准入检查。

下一次只需让当前账号的微信主窗口保持可见，再做同一窗口的只读结构复验。若有效完整观测仍无 mmui 聊天语义控件，按用户 A 决定保留阻塞；不换账号、不转路线、不绕过失败条件。获得控件证据后，才实现依赖该结构的真实只读后端与原群绑定。

## 09:56 可见窗口续验

用户要求继续，并提供聊天界面可见截图。本次重新发现唯一微信窗口，成功取得 Computer Use accessibility 结构；返回内容仅为 Window → Pane:MMUIRenderSubWindowHW，document_text 为空，未观察到会话列表、消息列表或输入框。随后重新枚举，窗口 id 和 app 与采集前一致。

这补充了可见窗口状态的当前观察，上一轮最小化／窗口变更记录保留不改。截图中的成员与消息不复制入仓库，也不作为程序已识别账号／原群或原生 @ 的证明。

**当前停点：未观察到所需语义控件，接入继续 blocked。** Computer Use 返回的是格式化树，未提供完整性预算或 pywinauto root class，故不将它伪装成新探针完整遍历或上游构造器实测失败。没有运行新 pywinauto 探针、导入上游、读取消息正文、发送或调用模型；不重复轮换已验证入口。

收据：[可见窗口续验](../poc/evidence/pyweixin-visible-followup-2026-09-18.json)。后续需要新的语义控件证据或可审查的机制变化；目前没有依据继续开放真实接收／发送。
