# UIA＋OCR 只读观察器 v0.3

日期：2026-09-20。已完成一次真实窗口可见文字采集；完整消息接入未验收。

独立可选云 OCR：操作人后续明确允许 M3 图像测试，已完成 2 次调用、实图两条测试文字 2/2 识别；详见 [M3 对照](../poc/evidence/m3-ocr-2026-09-20.md)。该授权用于这次局部图像实验，不改变下方本地读取默认行为。`m3_ocr` 是独立显式命令，未接入自动循环；M3 也存在 `AI/Al` 歧义，不升级群身份或真实 @ 状态。

最新编号续测：操作人安排两条测试文字，在发送前真实截图的 OCR 中均不存在，发送后实时快照各出现一次且完整文字匹配，2/2 新增可见。前后尺寸不同，不能升级为持续无损监听。新增对照工具 `python -m wechat_agent_poc.numbered_read_check`；见 [编号验证证据](../poc/evidence/uia-ocr-numbered-2026-09-20.md)。本轮 41 项相关测试通过。

v0.3 采集条件更新：`screen_region` 要求实际可见、未最小化、无遮挡，不要求拥有键盘焦点；父进程和 worker 使用同一采集方式。`window` 模式仍要求前台。下文涉及前台协调的历史操作可选用，但不再作为 screen_region 的必要门槛。`--wait-for-foreground` 保留兼容参数名，screen_region 模式用于等待窗口恢复可见，真实遮挡仍拒绝。

最新真机结果：窗口 918×571、96 DPI，UIA 2 节点且无聊天语义；`screen_region`＋RapidOCR 成功输出 6 行可见文字，两条正文文字经画面对照匹配。标题 `AI/Al` 不一致，结果是 `REVIEW_REQUIRED`；没有将 OCR 字符修成预期标题。相关测试 37 passed。详见 [真机证据](../poc/evidence/uia-ocr-live-2026-09-20.md)。

## 当前可用入口

在 `poc/` 使用新隔离环境 `.research/hybrid-ocr-20260920/venv`，不要复用历史 HWND 或尺寸。最新单次真机命令为：

```powershell
..\.research\hybrid-ocr-20260920\venv\Scripts\python.exe -X utf8 -m wechat_agent_poc.hybrid_cli --hwnd <当前HWND> --layout .local/<当轮目录>/layout.json --output .local/<当轮目录>/snapshot.json --capture-method screen_region --wait-for-foreground 30 --ocr-engine rapidocr --review-unconfirmed-title
```

`--review-unconfirmed-title` 仅允许输出“标题待核对”的原始审阅快照，保留 `target_label_match=false`，不建立业务绑定。未传此参数时，标题不匹配仍拒绝。`--wait-for-foreground` 仅检查状态，最多 30 秒，不自动激活；普通窗口置前可在本轮已授权的只读真机验证中协调使用，不修改微信无障碍状态。

需要重新标定时，运行 `scripts/capture_hybrid_calibration.py <当前HWND> .local/<当轮目录>/calibration.png --capture-method screen_region --wait-for-foreground 30`，依据实际图片选定标题和消息区，排除会话列表／输入框。截图含私有内容，仅存 `.local/`。

## 目标与来源

用户本轮明确允许 OCR。采用 UIA 优先、Windows 本地 OCR 回退，把现有 UIA 无聊天语义控件时的可见文字观察补齐。本方案不自动启用发送、M3、自动回复、定时任务、数据库取钥、解密、内存修改或开机自启动；是否提交或推送由后续任务明确决定。

参考 [wechatauto-replica/guia.py](https://github.com/fanyuantaier/wechatauto-replica/blob/main/wechatauto/guia.py) 和 [uia_driver.py](https://github.com/fanyuantaier/wechatauto-replica/blob/main/wechatauto/uia_driver.py)，按 2026-09-20 所读源码分析，未把其可变 main 当作锁定依赖：

- 上游 OCR 主要辅助界面定位／发送，消息读取另有数据库解密流程；不是已经验证的纯 OCR 收消息方案。
- 借鉴 Windows 本地 OCR 与窗口内区域识别，不引入聚合入口或初始化副作用。
- 独立实现每次调用唯一临时目录、完整行坐标合并、原文空格保留、显式错误及超时；不沿用共用临时文件、删除全部空格、异常返回空列表的方式。
- 不调用上游无障碍内存激活代码，不导入 wxauto4 的聚合入口。

## 接口与边界

新增 `poc/wechat_agent_poc/hybrid_observer.py` 的 `HybridSessionObserver`，保留旧 `UiaSessionReader` 不变。业务 Agent 尚不消费这个接口。

`backend.observe()` 给出窗口实例／尺寸状态，`backend.uia(layout)` 给出有界 UIA 读取结果，`backend.capture()` 只截指定窗口，`ocr.recognize(image)` 仅识别局部图片。所有输入是观察数据，不能作为执行指令。

流程：检查窗口 → UIA → 若明确 `semantic_unavailable` 才截图 OCR → 校验标题区域 → 再检查窗口 → 输出观察快照。UIA 异常、遍历截断、超时都拒绝，不偷偷回退为成功。有效空 UIA 结果不触发 OCR。

### 输出契约

- `source=uia|ocr`；`capture_kind=live_window|offline_image`。
- `header`／`messages` 是区域内文本行，不是消息结构。每行 `box=[left,top,right,bottom]` 相对于所属 ROI；OCR 框为全部词框并集。
- Windows OCR 的 `confidence=null`；RapidOCR 保留引擎输出的 0–1 识别分数。这不是校准后的正确概率，也不能证明发送者／群身份。
- `sender=null`、`message_id=null`、`mention_status=unknown`。正文里的 `@` 只是可见字符。
- 标题匹配仅忽略汉字旁 OCR 插入的空白，保留原文、英文词间空格、标点和人数差异；`target_label_match` 仅是弱选择检查，不能证明群内部 ID。
- `snapshot_id` 每次新建，只标识观察。`visible_text_changed` 只表示文本／坐标变化；滚动、重排、OCR 抖动也会触发，不能解释为新增消息。
- 首次及 UIA/OCR 来源切换均为基线；相同正文的两行保留，不按文本强行去重。跨进程命令每次均为新基线。
- `account_verified`、`group_verified`、`new_messages_verified`、`native_mentions_verified`、`agent_enabled`、`send_enabled` 均固定 false。

### 原生后端限制

显式提供当前 HWND；校验顶层 Weixin 进程、PID／创建时间、窗口矩形、DPI、默认输入桌面、可见且非最小化并位于前台。父进程和 worker 均检查；不恢复、不聚焦窗口。账号身份仍未验证。

UIA 限制 128 节点、6 层，仅读取指定区域内可见 Text 控件名称，消息区还须实际存在 List 控件。该保守选择器可能漏掉可用的自绘／其他类型控件；不因此声称控件已经读通。

UIA 和窗口截图各在专用子进程中运行，单次上限 10 秒；超时仅清理本次子进程树，拒绝输出成功。Windows OCR 每区域上限 12 秒，RapidOCR 每区域上限 25 秒，最多两区域；这是单轮有界操作，不持续轮询。真实强制挂死路径尚未实机验证。

`window` 模式使用 `ImageGrab(window=hwnd)`，本机返回空白；不能把这个路径误称为 PrintWindow。当前通过的 `screen_region` 从桌面 DC 用 BitBlt 复制目标窗口矩形，检查可见、前台、屏幕边界和遮挡。DWM cloaked 窗口不作遮挡；对实测工具光标层 `CodexComputerUseCursorOverlay` 仅在其具备 layered／transparent／no-activate 标志时作精确例外，其他覆盖窗口仍拒绝。图像可能包含光标光晕。

完整目标窗口图像暂存本地临时目录，识别仅裁切标题区和消息区。OCR 裁图／结果在每次调用后清理；明确输出的快照包含聊天文字，应放 `.local/`，不上传、不进 Git。临时文件使用当前用户的系统临时目录权限，不承诺安全擦除。

Windows OCR 用系统 PowerShell 5.1 调用 WinRT。`-ExecutionPolicy Bypass` 仅作用于这个无配置文件的子进程，不持久修改机器策略。无网络请求；没有安装系统语言包。缺少语言包与识别失败是阻塞，不等于空聊天。

## 环境与运行

Windows OCR 初版复用 `.research/wxauto4-41.1.7-audit/venv`。后续新增独立 `.research/hybrid-ocr-20260920/venv`，安装固定 `rapidocr-onnxruntime==1.4.4` 和 ONNX Runtime CPU；完整清单在 `poc/requirements-rapidocr.lock`，模型 SHA-256 在真机 evidence。不修改业务环境／`uv.lock`。固定 1.4.4 是本次实测版本，不代表最新版本。以下 Windows OCR 命令保留用于对照；新真机流程使用上方 RapidOCR 命令。

以下命令在仓库 `poc/` 运行。

### 1. 先离线反例及本机合成 OCR

```powershell
.\.venv\Scripts\python.exe -X utf8 -m pytest tests/test_hybrid_observer.py tests/test_local_ocr.py tests/test_uia_session.py -p no:cacheprovider
..\.research\wxauto4-41.1.7-audit\venv\Scripts\python.exe -X utf8 scripts/verify_hybrid_ocr.py
```

合成验证要求英文逐字一致及中文去掉 OCR 空格后匹配。当前英文分词未达标，因此验证脚本返回 FAIL；不要为通过测试而替换实际识别结果。图片、结果及详细报告在 `.local/hybrid-ocr-synthetic/`，不访问微信。

也可对用户明确指定的离线图片运行：

```powershell
..\.research\wxauto4-41.1.7-audit\venv\Scripts\python.exe -X utf8 -m wechat_agent_poc.hybrid_cli --image .local/hybrid-ocr-synthetic/fixture.png --layout .local/hybrid-ocr-synthetic/layout.json --output .local/hybrid-ocr-synthetic/new-snapshot.json
```

输出 `OBSERVED` 只表示得到快照，不是 OCR 准确率或微信接入 PASS。已有输出文件拒绝覆盖。

### 2. 当前窗口校验与 ROI 标定

操作人将测试号的目标群保持在微信前台。通过已观察的窗口信息取得当前 HWND，勿复用历史句柄。先运行 `scripts/check_hybrid_window.py <当前十进制或十六进制HWND>`，不截屏、不读正文。

把 `samples/hybrid-layout.example.json` 复制到 `.local/`，根据当前目标窗口的实际尺寸配置 `width/height`、标题区 `header` 和消息区 `messages`。坐标相对完整窗口左上角，右／下界为裁切终点；消息区必须排除会话列表和输入框。示例仅是合成图片坐标，不是微信坐标，禁止直接当实机标定。

`expected_title` 应来自当前可见标题（含人数等后缀）。发生缩放、窗口大小或布局变化后重新标定；没有实际画面或 ROI 不明确就停止，不猜比例。

### 3. 一次真实只读观察

```powershell
..\.research\wxauto4-41.1.7-audit\venv\Scripts\python.exe -X utf8 -m wechat_agent_poc.hybrid_cli --hwnd <当前HWND> --layout .local/hybrid-layout.json --output .local/hybrid-live-run-01.json
```

命令启动后必须仍满足微信在前台。命令本身不会切换窗口；从终端启动会抢前台时，采用操作人控制的启动时机，不能把前台检查删除。每轮遇阻即结束，不自动重试 UIA 激活。

## 验收与后续门槛

1. 本轮离线契约测试及 OCR 引擎运行证据，见配套 evidence。
2. 下一步在实际目标窗口尺寸下校准 ROI，取得一次 `live_window` 快照，与可见文字逐项比较，记录漏字／多字／错字。
3. 再独立验证账号、目标群及可见发送者；当前同名群／成员、切群瞬态无法可靠排除。
4. 以操作人控制的编号消息验证新增、重复、滚动及窗口变化；快照差分不是无损监听。UIA 与 OCR 均没有服务端消息身份时，不承诺完整性／恰好一次。
5. 真实 @ 需要独立语义证据，OCR 文本 `@昵称` 永远不作为通过证据。在消息身份、@ 和发送独立验收前，不接 M3 自动回复与主动询问。

## 下一轮操作提示词

### 2026-09-20 状态更新

**最终停点：** 操作人确认收件后要求结束本次受控测试；当前已结束。下述后续步骤仅为规划，不应自动执行。

后续操作人已回复“收到”，本次单次回复取得人工收件确认；接收客户端类型未明确。下一阶段为独立实时触发验证，现有 run 禁止重发。

用户后续已明确授权单次发送。该受控试验已经提交一次 M3 回复，本机气泡可见，详情见 `poc/evidence/controlled-send-2026-09-20.md`。下方 v0.3 提示词为此前只读阶段记录，不再作为当前任务交接。

> 继续确认本次唯一回复的对端收件结果。现有 run 已有 submit.lock 和 submitted_unverified，禁止重新发送或填入。记录接收方实际确认的客户端及范围；本机绿色气泡不能代替对端送达。完成后，再独立规划真实新消息触发、重复抑制和原生 @ 验证，不把本次人工选取历史编号消息的单次试验称为自动回复。保留 API／861 和已有工作，是否提交或推送由后续任务决定。

> 按 specs/uia-ocr-hybrid-2026-09-20.md v0.3 和 poc/evidence/uia-ocr-numbered-2026-09-20.md 继续。两条编号文字已完成新增可见对照，不重复要求发送。下一步固定窗口／视口，做有限次数的重复采集，检查 OCR 抖动和候选重复，再研究账号／群确认与真实 @ 证据。screen_region 只要求实际可见且无遮挡，不强制键盘焦点。保留 AI/Al 原文差异，审阅模式不得升级身份绑定；不做无障碍激活实验、不切群、不发送、不读数据库／进程内存、不接 M3。不得把 OCR 差分或 @ 字符认作真实消息身份／提及。只跑与改动直接相关的测试，优先补实机证据；保留 API／861 和已有工作，是否提交或推送由后续任务决定。
