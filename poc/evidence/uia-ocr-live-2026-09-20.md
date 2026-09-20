# UIA＋OCR 真机验证：可见文字采集通过，标题待核对

后续已完成 [两条编号文字的真机前后对照](uia-ocr-numbered-2026-09-20.md)，2/2 新增可见。本文保留首轮单次采集证据。

## 最新结论

2026-09-20（Asia/Shanghai），完成一次真实微信窗口 → 有界 UIA → 屏幕区域采集 → 本地 RapidOCR → JSON 快照的完整调用，退出码 **0**，状态 **REVIEW_REQUIRED**。

这次读取来自 `live_window`，不是合成图片或离线截图模式。**当前可见文字采集已取得真机证据；完整 Agent 接入、新消息监听、真实 @ 和发送未验收。**

| 项目 | 实际结果 |
| --- | --- |
| 客户端 | Weixin 4.1.13.65；当前窗口 918×571，96 DPI |
| 窗口状态 | 真实 PID／创建时间／HWND／矩形，采集前后校验通过 |
| UIA | `semantic_unavailable`，实际遍历 2 节点；没有聊天语义控件通过证据 |
| 截图 | `screen_region`，从桌面 DC 复制目标窗口矩形；原窗口 DC 方案空白 |
| OCR | `rapidocr-onnxruntime==1.4.4`，ONNX Runtime CPU，本机处理 |
| 可见文本 | 6 行：3 行姓名／企业显示文字、2 行文字正文、1 行表情图内文字 |
| 人工核对 | 对照同轮标定图，两条正文的文字部分均匹配；未将表情符号识别算作通过 |
| 标题 | OCR 把 `AI` 读成 `Al`；`target_label_match=false`、`review_required=true` |
| 身份与权限 | `account_verified=false`、`group_verified=false`、`agent_enabled=false`、`send_enabled=false` |
| 消息事件 | 首次基线；没有服务端消息 ID、稳定发送者绑定或真实 @ 语义 |

6 行文字不等于 6 条消息。OCR 识别到表情图内的文字，不能自动将它分类为文字消息。姓名行中的 `@企业` 也不是“别人 @ 本人”的事件。

## 本轮解决的问题

1. 原窗口截图路径没有提供有效画面，增加显式 `--capture-method screen_region`。不自动隐藏回退结果。
2. 遮挡检查发现两层 `CodexComputerUseCursorOverlay`，它们是工具的透明光标层。仅对该精确类名和 layered／transparent／no-activate 标志作例外；其他应用窗口遮挡仍拒绝。标定图可见光标光晕，它不是聊天内容。
3. 本机 pywin32 未导出 `CAPTUREBLT` 名称，使用 Win32 的固定常量值。所有 DC／bitmap 资源按调用清理。
4. Windows zh-Hans OCR 对小字号错字较多；2／3／4 倍放大未解决标题误识别。改用独立环境中的 RapidOCR，未修改业务环境。
5. 标题 `AI/Al` 差异不做自动纠正。新增显式审阅模式，保存原始文本和 `review_required=true`；默认严格模式仍拒绝标题不匹配。
6. 实机窗口从旧标定的 918×564 变为 918×571。重新截图并人工标定后再运行，不套用旧坐标。

## 本地证据与复现

私有原始材料在 `poc/.local/hybrid-live-20260920-04/`（Git 忽略）：

| 文件 | SHA-256 |
| --- | --- |
| calibration.png | 公开版不记录哈希 |
| layout.json | 公开版不记录哈希 |
| live-snapshot.json | 公开版不记录哈希 |

快照记录实际 `window_observation`、`observed_at`、UIA 节点数、采集方式及 OCR 引擎；未从配置补出账号／群身份。

在 `poc/` 执行的真实命令如下，HWND 只用于记录本轮，下一轮必须重新枚举：

```powershell
..\.research\hybrid-ocr-20260920\venv\Scripts\python.exe -X utf8 -m wechat_agent_poc.hybrid_cli --hwnd <当前HWND> --layout .local/<当轮目录>/layout.json --output .local/<当轮目录>/live-snapshot.json --capture-method screen_region --wait-for-foreground 30 --ocr-engine rapidocr --review-unconfirmed-title
```

`--wait-for-foreground` 最多只检查状态 30 秒，不自动激活。实机测试使用标准 Computer Use 置前操作协调前台；未点击聊天、切群、输入或发送。

## 依赖和校验

新增独立环境 `.research/hybrid-ocr-20260920/venv`，完整版本清单在 `poc/requirements-rapidocr.lock`。本轮固定使用已实际验证的 1.4.4，不宣称它是最新 RapidOCR。包内自带三份模型，没有调用模型下载器或把图片传到外部服务。

| 本地 ONNX 模型 | SHA-256 |
| --- | --- |
| ch_PP-OCRv4_det_infer.onnx | 公开版不记录哈希 |
| ch_PP-OCRv4_rec_infer.onnx | 公开版不记录哈希 |
| ch_ppocr_mobile_v2.0_cls_infer.onnx | 公开版不记录哈希 |

本轮相关测试 **37 passed，0.20 秒，退出码 0**，不重复全量回归。原始快照未提交，本文件为脱敏说明；API／861、数据库及发送实现未修改。

## 下一验收

下一步应使用由操作人／另一测试成员发送的编号文字与真实 @，验证“新可见内容”和历史基线的区别。当前观察器只是快照，不能把文字差分升级成无损监听或服务端消息身份。必须独立解决目标账号／群绑定、真实 @ 和消息去重后，才可讨论接入自动回复。
