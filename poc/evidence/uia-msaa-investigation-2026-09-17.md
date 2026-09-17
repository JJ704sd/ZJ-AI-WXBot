# 连续排查：公开选择器源码与MSAA对照

授权：用户要求继续尝试，不逐步询问。沿用不降级、不OCR、不取钥、不发送、不改微信进程内存的边界。没有重启或重新登录微信，没有修改用户暂存内容。

## 新的一手资料

查看 [fly000001/wxauto4 的 ui/main.py](https://raw.githubusercontent.com/fly000001/wxauto4/main/wxauto4/ui/main.py)：该公开分支按Win32 Qt51514QWindowIcon定位，再检查UIA mmui::MainWindow；随后查找MainTabBar、ChatMasterView、ChatMessagePage和XSplitterView。这是公开分支，不是已证实与PyPI 41.1.7同源的代码，因此只作为机制参考，不以此替换已安装二进制。

据此修正理解：Qt Win32类名本身不一定异常；关键是同一窗口的UIA provider仍返回Qt外壳，且缺少库需要的语义控件。仅调整窗口匹配不能创建聊天控件。

查看 [Microsoft AccessibleObjectFromWindow](https://learn.microsoft.com/en-us/windows/win32/api/oleacc/nf-oleacc-accessibleobjectfromwindow)：允许对指定HWND请求IAccessible接口。这提供不同于直接UIA枚举的标准只读入口，作为本轮新实验依据。

## 本轮实际执行

新增 `poc/scripts/probe_msaa_structure.py`。独立子进程20秒上限；确认唯一可见Weixin主窗口后，仅对主窗口及至多4个子窗口请求OBJID_CLIENT，输出接口是否存在和accChildCount，不读取Name、Value或正文，不执行默认动作。

实际结果：

| 对象 | MSAA接口 | 子对象数 |
|---|---|---|
| Qt51514QWindowIcon主窗口 | 可取得 | 1 |
| MMUIRenderSubWindowHW渲染窗口 | 可取得 | 0 |

随后执行一次UIA结构对照，未调用WeChat构造器：仍为Qt51514QWindowIcon，面板子控件0，compatibility=unsupported_uia_window_class。MSAA请求未使语义UIA树出现。探针语法检查及git diff --check通过；没有把这个新脚本称为全面测试过的生产读取器。

## 连续排查结论

本机已验证失败的方法包括：正常构造、还原最小化后构造、窗口类/结构对照、直接MSAA客户端对象请求及其后UIA对照。旧证据另记录讲述人/读屏标志失败，不重复执行。

MSAA接口存在不等于可读消息，当前只有系统代理外壳也符合所见结果，但未确定provider内部实现，不能断言具体内部开关状态。没有证明纯UIA能在当前版本和状态下恢复。

网上另有重启时设置环境、客户端降级、写入进程内存、OCR等办法；当前明确边界内不执行。尤其不会把wechat-replica的数据库/OCR/内存修改回退包装成UIA成功，也不会下载执行未知OpenUIA二进制。

当前工程交付：隔离依赖、结构探针、兼容性预检、只读会话基础及证据已可复用。实际账号/群绑定、新消息读取、真实@均未完成。本轮没有有效的进一步无状态变更修复证据，结束当前实机尝试；后续有新的兼容适配器或允许改变客户端启动状态时再立对照实验。无需重复安装、取钥或再次执行相同构造器。
