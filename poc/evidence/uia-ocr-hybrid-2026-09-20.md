# UIA＋OCR 改造验证记录

**后续已有突破：** 屏幕区域＋RapidOCR 完成一次真实窗口文字采集，见 [最新真机证据](uia-ocr-live-2026-09-20.md)。本文件以下内容是此前失败与修复过程，不再作为最新接入状态。

日期：2026-09-20。状态：只读观察器已实现；真实微信读取未验收。

## 同日续测：窗口恢复可用，窗口截图被判为空白

本节为最新结果，后文的隐藏／最小化是前一轮观察。

- 微信仍为 4.1.13.65；本轮重新枚举时窗口句柄发生变化。此前句柄传入旧查询路径得到负数 PID，触发 ValueError。不能据此断言 pywin32 ABI 故障；已改用显式 HWND／DWORD 原型，并要求 `GetWindowThreadProcessId` 返回非零且 PID 非零，失效时返回 `window_identity_unavailable`。
- 刷新窗口后，真实只读检查返回 `WINDOW_AVAILABLE`，尺寸 896×648、DPI 96；可见、非最小化及前台门槛通过。本轮未主动恢复／激活窗口。
- Computer Use 截图仍返回 `SetIsBorderRequired failed ... 0x80004002`，没有可用画面。
- 新增独立 `capture_hybrid_calibration.py`，用于实际窗口 ROI 标定前的有界截图。首次运行暴露了 worker 依赖启动目录的问题；现已固定 worker 的 cwd 为 `poc/`，不依赖父脚本的 `sys.path`。
- 修复后项目窗口截图路径返回 **`blank_capture`**：图像未通过像素标准差门槛，不保存为有效标定图片，不执行 OCR。该门槛只能证明未得到足够画面信息，不能证明具体是渲染、截屏接口还是其他原因。
- 到此停止当前实机截图路径。没有重复 UIA 激活、切群、键鼠输入、取钥、发送或 M3 调用。真实控件、消息及 @ 状态仍未通过。
- 本次相关回归 **35 passed，退出码 0**，含新增失效句柄和跨目录 worker 反例；前一轮 417 项通过的广泛回归未在本次重跑。

下一步需要能取得当前窗口有效图像的截图实现，或操作人提供当前窗口截图以继续离线标定。离线截图只能验证区域和 OCR，不能替代实时窗口采集验收。不要关闭空白检测、伪造 ROI 或用配置补出账号／群身份。

## 证据分层

| 层次 | 本轮证据 | 判定 |
| --- | --- | --- |
| 上游源码思路 | guia.py 使用 Windows OCR 辅助界面操作，消息读取另有 DB 流程 | 仅源码分析，不是上游实机成功证明 |
| 合成契约测试 | UIA 优先、受控回退、窗口变化拒绝、标题检查、空间坐标、重复文本、未知 @、临时目录及错误区分 | 27 passed |
| 本机 OCR 引擎 | 系统 Windows OCR 实际运行，合成标题与两行正文可读；未访问微信 | 引擎运行通过，逐字精度未通过 |
| CLI 离线图片模式 | `OBSERVED / source=ocr / capture_kind=offline_image / visible_lines=2`，退出码 0 | 仅快照链路通过 |
| 当前微信版本 | 只读进程文件信息：4.1.13.65 | 当前版本已核实 |
| 真实窗口前置检查 | 新后端返回 `window_hidden_or_minimized`，未尝试恢复／激活 | 阻塞，正文未读 |
| 真实控件可见 | 本轮没有读取成功证据 | 未验证 |
| 真实可见消息 OCR | 无当前微信截图 OCR 成功结果 | 未验证 |
| 新消息可读／原生 @ | 快照模型不提供对应身份／语义保证 | 未通过 |
| 发送／M3／自动回复 | 未连接、未启动 | 未执行 |

## 精度反例

合成图片期望 `Hello world 12345`，本机 zh-Hans OCR 实际返回 `Hello wo rld 12345`。

中文期望 `中文测试 请回复`，实际返回 `中 文 测 试 请 回 复`。去除空格可匹配中文测试文本，但输出仍完整保留 OCR 原文。不能把这解释为英文逐字准确，也不自动改写正文。`verify_hybrid_ocr.py` 因英文精度要求未满足，实际退出码 1、报告 FAIL。

图片和原始合成输出位于 `.local/hybrid-ocr-synthetic/`，明确 `wechat_access=false`。没有把测试夹具当成聊天实机证据。

## 失败与处置

- 首次 OCR 调用受 PowerShell 默认脚本执行策略阻止。修复为仅 OCR 子进程使用 `-ExecutionPolicy Bypass`，不修改持久策略；随后引擎成功运行。
- Computer Use 对当前微信窗口截图返回 `SetIsBorderRequired failed: 不支持此接口 (0x80004002)`，未生成成功截图；不推断项目的 Pillow 窗口截屏也一定失败或成功。
- 原生后端先返回通用不可用原因，随后增加独立错误分类，再检查确认隐藏／最小化。未反复激活 UIA。
- 初次全回归结束时 pytest 清理系统 Temp 遇到 PermissionError，退出非零，不能报告全量通过。
- 第二次把 basetemp 放 `.local/`，触发既有 `test_local_binding_write_stays_in_dot_local` 的测试环境碰撞：它的“目录外”样本仍被祖先 `.local` 包含。该轮 416 passed、1 failed、1 skipped。没有修改业务代码或放宽测试，改用 `.research/` 下新的独立 basetemp 复验。

最终回归：**417 passed，1 skipped，37.17 秒，退出码 0**。命令：

```powershell
.\.venv\Scripts\python.exe -X utf8 -m pytest tests --ignore=tests/test_g2b_https.py -p no:cacheprovider --basetemp=../.research/pytest-hybrid-20260920-c
```

排除 `test_g2b_https.py`，该项是独立 Caddy HTTPS 集成，本轮未验证网络部署。新增 Python 模块编译检查通过；最终差异检查无空白错误。静态检查未发现新增发送、网络请求、取钥或进程内存修改调用。

## 交付与下一门槛

实现、运行方式和操作提示词见 [技术方案](../../specs/uia-ocr-hybrid-2026-09-20.md)。原 UIA reader、API／861 的实现与契约未修改；原始实机材料未提交，本文件为脱敏说明。

下一门槛是当前测试群可见且位于前台，基于实际窗口标定两个 ROI，运行一次真实只读观察并逐字核对。当前没有这些证据，因此不能写“UIA＋OCR 微信接入完成”。
