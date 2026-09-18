# pyweixin 深层结构实验：三个关键控件已定位

日期：2026-09-18。用户在首轮临时状态实验后要求继续。本轮针对同一客户端做一次更深层的短时结构实验，没有启动长期激活、监听或发送。

## 实机结果

修改前 Qt 外壳 2 节点；临时置 1 后 mmui::MainWindow 下遍历 142 节点；恢复原字节 0 并读回成功后，又回到 Qt 外壳 2 节点。全过程窗口绑定稳定，版本 4.1.13.65。

| 关键对象 | 实际结构 | 深度（根为 0） | 定位方式 |
|---|---|---:|---|
| 会话列表容器 | List / mmui::XTableView，位于 mmui::ChatSessionList 下 | 14 | 固定本地化会话 List 标签命中 |
| 消息列表容器 | List / mmui::RecyclerListView，位于 mmui::MessageView 下 | 16 | 固定本地化消息 List 标签命中 |
| 聊天输入框 | Edit / mmui::ChatInputField | 18 | AutomationId 精确等于 chat_input_field |

三者都超过首轮 6 层的预算。本轮证明的是这些结构和选择器条件在遍历中实际出现；未执行完整上游 Navigator、Monitor、Messages 或其键鼠动作。

## 完整性与隐私边界

预算为 24 层、512 节点，每次结构采集子进程 15 秒超时。实际 142 节点，`truncation_reasons=["depth_limit"]`，整棵结构仍为 complete=false，不能报告全树完整或不存在其他匹配对象。3 个关键对象在触及限制前已被观察到。

命中会话和消息列表后，主动跳过其中内容项，`content_containers_pruned=2`。收据仅保存固定格式的类名、角色、深度、父子序号和选择器布尔命中；不保存 Name、聊天正文、群名、成员名、原始 AutomationId、输入框 Value 或截图。`complete` 仅对这种排除内容项的结构范围有意义。

不是原群绑定证明：当前聊天标题区域的 ChatRoom 类结构只能提供群聊形态线索，不能证明原指定账号和群。节点序号只在本次遍历内有效，不能作为下一次调用的 UI 句柄、消息 ID 或稳定群 ID。

## 代码与测试

- `probe_pyweixin_structure.py`：增加可配置且受限的深度／节点预算、明确截断原因、结构父子链、敏感内容容器剪枝；保留严格 COM 错误处理和前后窗口校验。
- `qt_accessibility_preflight.py`：把预算传递给修改前、临时状态和恢复后的三个观测；默认仍为旧预算，写入仍需显式参数。
- 两项新增回归先失败后修复：缺少截断原因；深层结构无法配置且不能定位。修复后相关 **46 项测试通过**。合成样例检查原始私密标识和正文不会进入输出，消息／会话内容项不遍历。
- 收据：[深层结构原始记录](pyweixin-qt-deep-structure-2026-09-18.json)，观测日期为 2026-09-18，精确时间已脱敏。trial.write_readback=true、trial.restored=true。
- 这不是 46 项实机测试。本轮只有一次激活／恢复实验；命令总耗时约 1.72 秒，不是精确的启用状态保持时间。

实际命令（工作区根）：

```powershell
<private-python> -X utf8 ZJ-AI-WXBot/poc/scripts/qt_accessibility_preflight.py --allow-temporary-byte-write --structure-depth 24 --structure-nodes 512 --output research/pywechat-20260917/qt-deep-structure-trial-20260918.json
```

## 下一阶段的可执行契约

1. 以本次类名及固定选择器为候选，下一轮重新定位并要求候选唯一；不复用本轮序号或预填目标信息来“验证”目标。
2. 对当前账号和原群进行只读身份绑定。界面名称和旧数据库 ID 不相互替代；同名、缺少独立依据或窗口变化均停止。
3. 绑定通过后，才读取最小范围合成消息，接入现有 UiaSessionReader 的首次基线、同文去重、连续性和自发消息排除逻辑。
4. 原生 @ 判定不能从正文含昵称推断；字段缺失保持 unknown。单次人工确认发送及双端验收另按既有流程执行。

当前能力状态：临时 UIA 恢复和三个关键控件的存在已取得实机证据；稳定账号／原群身份、消息读取、原生 @、实际发送、长期保持和免风控均未验证。原字节已恢复，不留常驻进程或自动任务。
