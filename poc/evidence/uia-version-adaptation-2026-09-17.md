# 参考wechat-kefu的版本适配实现

本轮重新读取上游固定源码app/driver.py：其初始化WeChat→GetMyInfo；会话读取ChatWith→ChatInfo→GetAllMessage；心跳会切到文件传输助手，online异常会放行。这些业务行为不自动执行；不移植其跨会话心跳与异常放行。

本机再次确认Weixin 4.1.13.65。新增uia_profile.py，分开配置上游声称支持的4.1.8.107与本机4.1.13.65；本机允许识别Qt外壳，但要求实际navigation、sessions、chat_page、chat_splitter四种语义控件。未知版本不默认通过，扫描不完整不能写成控件不存在；structural_candidate不代表绑定或消息可读。

diagnose_wxauto_window现在读取目标进程可执行文件版本，最多128节点/6层遍历，仅采集类名及结构，不读消息内容。构造前优先使用版本能力判定；如果异类根有控件也只能标native_adapter_required，不直接交给不兼容的wxauto构造器。

本次实机结构结果：4.1.13.65、3节点、扫描完整；四类语义控件全部缺失。结果missing_semantic_controls。未调用WeChat构造器，未发送或读取消息。之后仅修正汇总判定优先级，未重复实机扫描。

22项相关测试在实机前通过；随后新增汇总判定回归，最终23项通过。测试只验证兼容判定与会话基础，不证明真实后端已完成。

结论：已实现按本机版本的结构适配入口，修复“只按根类名判断不支持”的粗糙逻辑；但实际UIA接入未打通。当前限制是客户端没有向标准UIA接口暴露上游驱动需要的控件，不能通过复制业务源码或更换选择器解决。未改微信/取钥/OCR/降级/发送，保留用户暂存区，不commit/push。
