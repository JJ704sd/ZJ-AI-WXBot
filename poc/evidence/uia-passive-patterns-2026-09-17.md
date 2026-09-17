# 被动接口探测与登录状态区分

## 范围

本轮继续低侵入只读构建；未采用进程内存修改，未激活、还原、启动客户端或点击登录。没有读取正文、数据库、密钥，没有发送、OCR、M3调用、commit/push。低侵入不等于平台风控保证。

## 假设与新增实现

无子控件的窗口仍可能提供 TextPattern 等接口。新增 scripts/probe_uia_patterns.py 查询 Text、Text2、Value、LegacyIAccessible、ItemContainer 的可用性布尔属性；不调用文本读取或操作接口。未知返回与 COM 异常均记 null，不误作可用或不可用。独立子进程20秒限时，最多检查16个Win32窗口，多根窗口拒绝选择。

## 实际观察（按时间顺序）

1. 模式探针因窗口缺失或歧义阻断；补充数量后看到1个Weixin进程、2个匹配窗口，未查询模式。
2. 结构诊断随后看到1个窗口，UIA根为 mmui::LoginWindow，21个已观察节点；因深度上限扫描不完整。说明该时刻登录界面语义树可见，不证明账号或聊天可读。
3. 修复登录状态分类后再检查，客户端状态已变化：4.1.13.65、最小化、Qt外壳3节点、missing_semantic_controls。未由本探针执行登录，不能推断变化原因，也不能把此前登录界面状态沿用。
4. 模式探针此时成功完成：6个Weixin进程、1个匹配窗口。主窗口与MMUIRenderSubWindowHW均为 text=false、text2=false、value=false、item_container=false、legacy=true。此结论限于该次最小化状态，不宣称覆盖其他状态。

## 修复与验证

uia_profile.assess_structure 新增 login_required 分类，仍保持绑定、读取、发送能力为false。反例先失败（旧结果unknown_window_shell），修复后相关27项测试通过，退出码0。真实复验时客户端已离开登录界面，因此login_required真实返回尚未复验。

命令（poc目录）：

```powershell
 .\.venv\Scripts\python.exe -X utf8 -m pytest tests/test_uia_profile.py tests/test_uia_patterns.py tests/test_uia_compatibility.py tests/test_uia_session.py tests/test_wxauto_probe.py -q -p no:cacheprovider --basetemp=D:\path\to\ZJ-AI-WXBot\uia-pattern-tests-20260917
```

首次相关测试断言全部通过，但pytest退出清理默认临时目录时发生PermissionError，不能算完整通过；使用上面工作区独立临时目录后通过。

## 能力结论与下一次入口

### 用户再次要求“继续验证”后的结构复验

执行隔离环境 Python 的 `poc/scripts/diagnose_wxauto_window.py` 一次，进程退出码0，约0.76秒。当前唯一可见窗口为最小化的4.1.13.65客户端：UIA根Qt51514QWindowIcon，完整结构扫描3节点，渲染面板无子节点，navigation/sessions/chat_page/chat_splitter四项均缺失，判定missing_semantic_controls。未调用构造器、未读取消息、未发送。此次状态与前次外壳观察一致，因此未重复接口探测或激活试验；27项测试属于上一轮结果，本轮未修改代码也未重跑测试。

源码/合成验证、登录控件真实可见与聊天控件可见必须分开。当前仅曾观察到登录控件；聊天消息读取、新消息、真实@均未成立。没有实现伪造后端或修改live绑定。

只有用户手动改变正常客户端状态或获得新的官方可访问性依据后，才对新状态执行一次被动结构检查；不要以重复激活、循环扫描、切账号、进程修改来突破当前失败。若主窗口语义控件出现，再按原spec独立核实账号、群和消息身份。
