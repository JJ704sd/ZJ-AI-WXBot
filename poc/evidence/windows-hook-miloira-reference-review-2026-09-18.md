# miloira/wxhook 对当前 Hook 排查的参考价值

2026-09-18 核查公开 master 页面与 Python 源码；未安装、导入或执行仓库程序。GitHub API 固定提交查询受本地网络限制，网页读取成功；以下是核查日 master 快照结论，没有取得固定 commit，不应作为可复现二进制版本依据。

## 结论与适用边界

公开代码可参考消息回调和 Python 桥接结构，不能直接提供本机 4.1.13.65 的接收地址或协议解码实现。仓库介绍列出的 4.1.13.56 与本机 4.1.13.65 不同。README 将公开 wxhook 对应到 3.9.5.81，另将 3.x/4.x 的 pywechat 引导至群内获取；这两部分不能混为同一公开实现。[README](https://github.com/miloira/wxhook)

## 已核对实现

`core.py` 中 Bot 固定版本 3.9.5.81；构造时尝试启动并注入，随后调用 hookSyncMsg。控制通过本机 HTTP API，事件通过 TCP 接收 JSON 后分发。run 才建立 TCP 监听，exit 会终止所关联进程。以上有副作用，不能把构造 Bot 当成只读检查。[core.py](https://raw.githubusercontent.com/miloira/wxhook/master/wxhook/core.py)

`utils.py` 将注入交给 tools 下的启动程序和 wxhook.dll；公开 Python 包装代码本身没有展示本机版本的原生接收点。`faked_version` 调用独立程序，不能据此推导它完成了跨版本函数适配。[utils.py](https://raw.githubusercontent.com/miloira/wxhook/master/wxhook/utils.py)

`model.py` 定义 msgId、msgSequence、fromUser、toUser、type 等可选字段，可作为事件契约核查清单；它没有证明这些字段在本机目标混合群中的身份、顺序或原生提及语义。[model.py](https://raw.githubusercontent.com/miloira/wxhook/master/wxhook/model.py)

## 对当前 Spec 的具体启发

1. 保留“原生事件获取 → 本机桥接 → Agent Channel”的职责分离。hookSyncMsg 是项目自己的控制 API，不能等同微信服务器同步协议，也不能据名称连到本机 new_sync.cc。
2. 后续桥接必须先建立监听并确认就绪，再启用事件源；将启动、附加、启用接收、停止接收拆成显式步骤，避免构造对象就修改微信状态。
3. 借鉴事件字段检查清单，但每个字段必须有本机样本依据；未知值保留 unknown，不猜测群成员、收发方向或消息排序。
4. 不直接复制回调接收器。公开实现按单次 recv 尾字节判断结束，应改成明确分帧、大小上限、超时和错误状态；这些属于将来 IPC 实现验收项，不是当前零命中的已证实原因。
5. 当前主线仍追踪 OnPush / Buf2Resp 桥接对象和业务实现。此仓库没有提供已经核实的 4.1.13.65 原生实现，不能据其宣传跳过本机定位或直接运行附带 DLL。

## 若后续评估新版组件

需要精确版本支持说明、可固定来源及摘要的组件、接收事件契约，以及原群另一个成员入站的验证证据。README 的企业群和群 at 功能列表只是提供者声明，尚未完成本机混合群验收。当前不需要降级客户端或更改账号登录状态。
