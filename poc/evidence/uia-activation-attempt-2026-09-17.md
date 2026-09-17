# Qt标准无障碍对象请求：执行前阻塞

本轮用户要求尝试修复。核对Qt 5.15官方实现：
https://raw.githubusercontent.com/qt/qtbase/5.15/src/plugins/platforms/windows/uiautomation/qwindowsuiaaccessibility.cpp

handleWmGetObject中设置accessibility active并尝试返回window accessibleRoot。因此拟对已确认微信主窗口及渲染子窗口请求WM_GETOBJECT/UIA_ROOT，单窗口2秒超时，随后只读检查结构。Qt通用源码只提供实验依据，不能证明微信定制构建包含或启用了该逻辑。没有采用Linux专用无障碍环境变量。

实际命令在进程预检即失败：Get-Process Weixin提示不存在该进程。后续目标唯一性检查阻断，所以没有发出WM_GETOBJECT，没有进行UIA读取，更未重启/登录微信。

判定：本项实验未执行，当前阻塞为客户端未运行；不能据此更新此前4.1.13.65的兼容性结果或声称修复失败/成功。用户需正常打开测试号客户端并保持登录后，才能继续此项实验。保留不发送、不降级、不OCR、不取钥、不修改微信进程内存的范围；未commit/push。

## 用户打开客户端后的续验

用户明确“已打开，请继续”后完成两种状态对照，前段未执行结论保留为历史记录。

| 状态 | WM_GETOBJECT_UIA_ROOT主窗口/渲染窗口 | 随后UIA结构 |
|---|---|---|
| 原最小化 | 两请求均按时完成，provider结果均零 | 3节点，Qt外壳＋空渲染面板＋标题栏 |
| 临时还原 | 两请求均按时完成，provider结果均零 | 2节点，Qt外壳＋空渲染面板 |

当前版本4.1.13.65。两次结构扫描均在预算内完成；navigation、sessions、chat_page、chat_splitter全部缺失，compatibility=missing_semantic_controls。还原对照结束恢复原最小化，IsIconic读回True。

结论：标准对象请求没有恢复本次客户端的语义控件；零值本身不证明具体内部实现或禁用机制，但结合前后结构可判定本方法未达到修复目标。仍未构造WeChat、未调用ChatInfo、未读取消息/发送、未重登、未commit/push。不重复这一已完成对照，不将接口请求完成误记为UIA能力通过。
