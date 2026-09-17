# wxauto4 构造失败：首轮定位

用户在原探测失败后明确“继续”构造原因诊断。本轮新增脱敏异常信号，并只执行一次新的30秒上限诊断；不是将旧失败覆盖为新结果。

## 实际结果

4项探针离线测试通过，含异常文本中的合成账号/密钥不出现在报告的反例。

实际执行入口：隔离环境的 python.exe 执行 `poc/scripts/probe_wxauto4_capability.py --live`，工作目录为隔离审查目录。约1.64秒返回失败：

```json
{"status":"uia_probe_failed","constructor_entered":true,"chatinfo_called":false,"error_type":"Exception","categories":["unclassified"],"winerror":null,"frames":[{"file":"probe_wxauto4_capability.py","line":54,"function":"worker"},{"file":"wx.py","line":340,"function":"__init__"},{"file":"main.py","line":211,"function":"__init__"}]}
```

调用位置来自二进制模块携带的traceback文件名与行号，不代表源码文件可见。核心实现仍为.pyd。仅能确认失败在主窗口构造，尚未到ChatInfo。异常分类未命中并不证明不存在版本或权限问题。没有系统错误码；原始异常文本未保存，不能据此宣称根因已定位。

随后只做了ui/main二进制静态字符串查找，未获得足以解释该异常的字符串证据；未再次激活UIA。没有截图/OCR、取钥、读消息或发送，没有修改客户端，也未实施猜测性修复。

## 结论与下一步

诊断部分完成：失败位置由泛化的Exception缩小为主窗口初始化路径；具体触发条件仍未知。真实后端前置仍不满足，保持未实现。

下次若进一步诊断，需先获得与41.1.7匹配的ui/main构造源码，或设计能在本地安全保留异常原因的采集方式（当前关键词分类丢失了所需信息）；在此之前不通过改构造参数、降级或反复激活试错。不对外联系维护者，不擅自上传诊断信息。
