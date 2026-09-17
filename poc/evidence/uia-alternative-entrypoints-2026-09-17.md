# 多入口只读验证

用户要求尝试不同方案。本轮新增两个独立限时探针，没有改业务后端或已有API路线。

| 入口 | 本机结果 | 判断 |
|---|---|---|
| UIA FindAll Descendants + TrueCondition | 唯一窗口、非最小化；1个后代MMUIRenderSubWindowHW，无截断 | 不支持“只是RawViewWalker漏读”的解释 |
| LegacyIAccessible GetCurrentSelection | 接口调用完成，0个选中对象 | 当前未发现旁路对象 |
| UIA位置命中 | 中心点被非目标窗口遮挡，跳过 | 未验证，不能算失败或成功 |
| MSAA OBJID_CLIENT accFocus | 主窗口和渲染面板均none | 当前未发现焦点对象入口；未激活窗口，不能据此宣称任何前台状态都无焦点对象 |

这些是不同的可访问性查询入口，但共享客户端provider，不是四种独立的账号接入协议。没有发现可读聊天入口，不声称尝尽所有方案。

## 执行与验证

新增 `poc/scripts/probe_uia_alternatives.py` 和 `poc/scripts/probe_msaa_focus.py`。先分别执行py_compile成功，随后各一次实机运行，均退出码0；有20秒子进程超时。未新增合成测试，不沿用此前27项作为新增脚本测试成绩。

使用 `.research/wxauto4-41.1.7-audit/venv/Scripts/python.exe -X utf8` 运行两个脚本。输出只含结构类型、数量和状态，无标题、正文、账号、密钥。未调用默认动作、选择、输入、登录、窗口激活；未修改进程、降级或OCR，未commit/push。

新消息可读、账号/群绑定、真实@仍未通过。位置命中需要目标窗口未被遮挡；在该条件未满足时不读取其他应用、不循环重试。

## 用户提供已打开目标群截图后的复验

用户随后提供目标群窗口截图，本轮不使用OCR，也不把截图作为UIA绑定证据。位置探针实际观察到唯一、非最小化窗口，中心点归属检查通过：ControlFromPoint返回Qt51514QWindowIcon、1个子节点。FindAll仍只有MMUIRenderSubWindowHW，Legacy选择对象仍为空。此次位置入口已经实际执行，不再是skipped_occluded；未得到聊天语义控件。执行退出码0，约0.77秒。没有点击、输入或发送。
