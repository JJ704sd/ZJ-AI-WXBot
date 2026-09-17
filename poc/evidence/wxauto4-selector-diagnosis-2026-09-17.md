# UIA选择器与实际窗口对照

本轮用户要求继续排查修复。未构造WeChat实例；使用同一隔离wxauto4的ControlFromHandle读取结构，20秒子进程上限。不输出标题或消息正文。

## 实测证据

- WeChatMainWnd._ui_cls_name实际为 `mmui::MainWindow`。
- 当前唯一可见Weixin主窗口的Win32类和UIA ClassName均为 `Qt51514QWindowIcon`；名称比较为匹配（不保存名称）。
- 最小化时根下有MMUIRenderSubWindowHW面板和标题栏，均无子控件。
- 临时还原后根下只有MMUIRenderSubWindowHW面板，child_count=0；不是可读取会话列表或编辑框的结构。
- finally恢复最小化后IsIconic读回True。

三次结构读取分别补齐Win32/类元数据、UIA类与下一层数量、还原窗口后的控制变量对照；没有再次调用构造器。未修改客户端、读屏标志、OCR、取钥、读消息、发送或登录操作。

## 修复

新增diagnose_wxauto_window.py结构诊断及compatibility_status判定，接入probe_wxauto4_capability.py构造前检查。不能确认结构、窗口不唯一、UIA类不匹配、名称不匹配、无语义子控件时均在构造前阻断。constructor_candidate仅为初筛，不表示绑定或读取通过。

18项相关离线测试通过，包括实测Qt外壳反例及“只改类名仍缺控件”反例。修复后的探针没有再次实机启动；实机证据来自前述结构实验，不能把离线集成称为已复验成功。

## 结论

已确认存在选择器不匹配及当前UIA缺少语义控件两项具体阻塞。它们解释为何不能按库预期找到可用主窗口，但未取得.pyd对应源码，不能证明它们是全部内部失败原因。没有硬改类名绕过校验，因为即使匹配外壳也没有消息控件。

实际消息读取仍未修复。在不降级、不改微信、不OCR的范围内，当前wxauto4 41.1.7与Weixin 4.1.13.65组合不具备继续读取的实测条件。需有新的客户端UIA支持或匹配适配器证据后再恢复；不继续重复当前激活实验。861/API和用户暂存内容保留，未commit/push。
