# Windows 工作台

## 启动

需要 Windows PowerShell 5.1+ 和 Python 3.10+。默认 `Database` 模式读取本地数据库副本；本地演示使用 `-Mode Demo`。数据库解密和压缩文本组件按需安装：

```powershell
python -m pip install -r web_mvp\requirements-database.txt
```

双击仓库根目录 `start-workbench.cmd`；或在 PowerShell 执行：

```powershell
.\start-workbench.cmd
```

启动器检查 Python、端口和服务就绪状态，再打开 <http://127.0.0.1:8787>。保持控制台打开，`Ctrl+C` 停止。也可双击 `stop-workbench.cmd`。停止脚本核对本次启动的 PID、进程启动时间、Python 路径与项目归属，避免误停 PID 被复用后的其他程序。

常用参数：

```powershell
# 只检查环境和端口，不启动、不安装桥接
.\start-workbench.cmd -CheckOnly

# 使用合成数据演示
.\start-workbench.cmd -Mode Demo
.\stop-workbench.cmd -Mode Demo

# 修改端口，不自动打开浏览器
.\start-workbench.cmd -Port 8788 -NoBrowser

# 显式指定 Python；路径含空格时加引号
.\start-workbench.cmd -Python "C:\Python313\python.exe"

# 脚本可从任意目录调用；相对 RuntimeDir 始终相对仓库根目录
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\start_web_mvp.ps1 -RuntimeDir .runtime\my-database
.\stop-workbench.cmd -RuntimeDir .runtime\my-database
```

Python 查找顺序为 `-Python`、`WECHAT_MVP_PYTHON`、项目 `.venv`、`py -3`、`python.exe`。启动器显示实际选中的解释器及版本；不要求管理员权限，不修改系统执行策略。端口占用时会拒绝启动，不终止已有进程。

## 数据库副本接收

在数据源设置中填写单账号 `db_storage` 的绝对路径、本人的实际 `wxid`（可留空，但不能用自定义微信号替代）及已授权密钥 JSON 的本地文件路径。也可选择已经解密的数据库副本，无需密钥。密钥只从文件读取，不在网页中填写其内容。

先把主库与 WAL 复制到工作台私有目录，再严格校验、解密每一页、合并 WAL 的连续有效提交前缀并执行 SQLite `quick_check`。副本合格后整体切换；失败保留上次成功数据并显示原因。支持 contact、session、message_N、biz_message_N，读取所有已支持分片；不读取 FTS 和附件索引。聊天正文不重复写入工作台的消息/自动回复缓存。

自动接收开启时，每 5 秒检查源文件元数据；发生变化才更新副本。关闭后仍可手动更新。配置记录当前和上一份成功副本，跨重启继续清理更旧的已知副本；未记录归属的历史目录不自动删除。工作台不能控制客户端何时将消息写入数据库，页面时间表示成功副本时间，不是实时送达保证。数据库读取本身不改写微信数据，也不能保证免于客户端风控。

本仓库另提供可选工具 `scripts/acquire_database_keys.py`，需外层 `poc/wechat_agent_poc` 配合。它不随启动器运行，仅在明确授权后手动调用：只读访问所选数据库唯一所属的微信进程，匹配 salt/HMAC 后将密钥写入 `.secrets` 下的新 JSON；不注入进程、不输出密钥。此步骤与从文件读取副本的权限不同。实测见交付记录。

## Windows Hook 发送

当前最小闭环支持已接入账号的 Windows 微信 **4.1.15.13**：数据库副本接收，向**当前已读取并选择的好友或群会话**重复手动发送纯文本。支持中文、换行和 emoji，输入上限为 2,000 个 UTF-16 单元（emoji 可能占两个）及 8,000 个 UTF-8 字节。本轮已验收文件传输助手发送回读，以及一名用户指定好友的发送、本机回读和对端回复接收。该好友的送达由用户确认，未取得服务器投递回执；群聊尚未实际发送。附件、真实 @、定时和自动回复未接入。

在工作台勾选目标会话的读取范围并打开该会话，点击编辑器上方的**连接发送**。这一步才会启动隐藏的本机发送桥并附加当前微信；启动网页或查看状态不会自动附加。连接时核对数据库所属进程、版本和模块摘要，未知版本保持禁用。会话必须实际存在于当前数据库副本，确认时保持与草稿相同的账号和目标。可在环境页查看模块详情。

显示“发送已连接”后，在普通消息编辑器填写正文，点**核对并发送**，核对目标和正文，再点**确认发送**。完成后点**编辑下一条**即可继续，不需要重启桥或修改脚本。每条请求先持久记录再调用微信，同一请求重放不会再次发送。

发送前记录当前副本的消息基线，发送后每 3 秒查询一次，最多 10 次。找到时间窗内唯一新增的本人同文消息时显示**已发现新的本人消息**。这是数据库观察结果，不能精确区分其他设备同时发送的相同文字，也不代表手机端送达或已读；多条候选、超时或未知结果保留待核对，不自动重发。已有精确服务器回执的旧接口路径仍单独显示确认状态。

点击**断开发送**会正常停止桥，清理其本机凭证并保留发送记录。为规避当前 Frida 卸载故障，调试组件会留在微信进程内直到客户端正常退出；没有后台自动发送。`stop-workbench.cmd` 也会先请求桥正常退出。桥地址与凭证由服务端管理，仅监听本机回环地址。

本机已安装 Frida 17.19.0 到 `.runtime/hook-tools`。其他环境需要手动准备该本地依赖：`python -m pip install --only-binary=:all: --no-deps --target .runtime/hook-tools frida==17.19.0`。当前适配、文件传输助手连续发送及用户指定好友的收发闭环结果见 [交付记录](execution/windows-workbench-review-2026-09-26.md)。

旧的界面输入诊断代码保留在源码中，默认产品入口关闭，不作为 Hook 接入或真实发送证据。

## 直接查看本台 Windows 微信

先手动打开微信主窗口、取消最小化并切换到想查看的会话，再在“环境诊断 → 连接这台电脑上的微信”检测并选择窗口。两个按钮各执行一次读取，不会持续采集：

- **读取窗口文字**：通过 Windows UI Automation 读取客户端公开的文字。新版微信可能不公开聊天控件，此时会返回没有可读文字。
- **本地屏幕识别**：截取选定微信窗口的屏幕区域，调用系统 Windows.Media.Ocr 识别文字，不调用云服务。窗口须完整处于屏幕内、未被其他窗口遮挡，读取过程中不要移动或切换会话。窗口状态或身份不匹配时拒绝读取。

检测进程和窗口不读取聊天正文。两个预览入口都不操作鼠标/键盘、剪贴板或账号登录，不解密数据库，不把正文写入工作台数据库。UIA 仅返回 `Text`、`ListItem`、`Document` 控件文字，最多 400 个节点、12 层、200 条文本和 40,000 字符。OCR 截图限制为 8 MB、单边最多 5000 像素，系统 OCR 还可能有更小的尺寸限制；识别结果最多 500 行、40,000 字符。子进程均设有超时。

截图只供后台 OCR 使用，不返回浏览器。OCR 会创建短期临时 PNG 和识别结果文件，正常结束、失败和超时后清理；它不是完全不接触磁盘的过程。页面只显示文字、来源与采集时间；点击清除、切换窗口、离开诊断页或将网页切到后台都会移除已显示文字，迟到的请求结果不会重新显示。强制关机等异常可能中断临时文件清理。

这些文本可能包含导航、联系人或窗口提示；OCR 还可能误识别或遗漏，不能视为完整群消息。当前不验证群 ID、消息 ID、发送者、新消息或真实 @，也不支持真实发送、后台持续同步和基于这些文字自动回复。返回“没有可读文字”或“未识别到文字”时，不能把它当成接入成功。不要把本机预览与演示群/演示发送结果混用。屏幕遮挡检查与截图之间存在短暂竞态，截图并非原子窗口快照。

可独立执行只读状态检测（不含聊天正文）：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\windows_probe.ps1 -Mode status
```

若检测到进程但找不到窗口，请打开并恢复微信主窗口，确保工作台与微信属于同一登录用户/桌面。受隔离的自动化环境可能看不到用户桌面；直接在本台 PowerShell 启动工作台后重试。无需为此关闭系统安全设置。

## 使用已有 Linux Docker 桥接

`-Mode Live` 专指原项目的 Linux 桥接，不会转换成本机 Windows 微信接口。它要求已有运行中的 Linux Docker 引擎、`wechat-lab-linux` 容器、原桥接服务端口 `127.0.0.1:16174`、当前容器对应的 `.secrets/linux-token`，以及原适配的 **Linux 微信 4.1.1.8 ARM64** 和摘要校验。Windows x64 上的 ARM64 容器运行条件和真实收发尚需在实际机器上验收。

如果使用新 Python 环境，手动在项目内安装 Live 依赖：

```powershell
py -3 -m venv .venv
.\.venv\Scripts\python.exe -m pip install -r web_mvp\requirements.txt

# 预检已有环境；不创建/启动容器，也不安装桥接
.\start-workbench.cmd -Mode Live -CheckOnly

# 首次显式安装当前项目桥接到已有实验容器，然后启动
.\start-workbench.cmd -Mode Live -InstallBridge

# 已安装匹配的桥接时，直接启动
.\start-workbench.cmd -Mode Live
.\stop-workbench.cmd -Mode Live
```

`-InstallBridge` 沿用 `web_mvp/install_bridge.py`：复制桥接文件并编译容器内的回调库，不重启或退出微信。请保留原二进制摘要校验，勿通过修改固定版本/摘要来假装兼容。退出网页不会退出微信；停止工作台也不会停止 Docker 容器。

Live 的手动发送、定时发送、自动回复均可能产生真实消息；沿用 [原功能契约](web_mvp/README.md)。只应对已授权的账号与会话使用。已有配置恢复后的定时任务按原规则执行。

## 数据与排查

| 项目 | 默认路径 |
| --- | --- |
| 数据库模式状态与日志 | `.runtime/web_mvp-database/` |
| 校验后的明文副本 | `.runtime/web_mvp-database/database-snapshots/` |
| 数据源配置（含密钥文件路径，不含密钥） | `.runtime/web_mvp-database/database-config.json` |
| 演示状态与日志 | `.runtime/web_mvp-demo/` |
| 演示数据库 | `.runtime/web_mvp-demo/state-demo.sqlite` |
| Live 状态与日志 | `.runtime/web_mvp/` |
| Live 数据库 | `.runtime/web_mvp/state.sqlite` |
| 标准输出 / 错误日志 | 对应目录的 `server.log` / `server-error.log` |
| 启动器进程归属记录 | 对应目录的 `launcher-process.json` |

数据库、演示与 Live 默认使用不同目录。`.runtime/` 与 `.secrets/` 不应提交或分享。明文副本、本机预览、OCR 的临时文件及浏览器显示内容均按个人聊天内容保管。

若启动失败，先看终端错误及 `server-error.log`。启动器会在启动前检查目录与已有状态文件是否可写。**不同 Windows 账户应分别使用自己的运行目录**：Python 3.13 创建的私有目录可能只允许创建它的账户访问；隔离环境与桌面用户也可能是不同账户。若出现 `Runtime path is not writable`，用原账户操作该目录，或通过 `-RuntimeDir .runtime\my-windows-user` 选择新目录。启动器不会放宽原目录权限或覆盖其中的数据。

检查端口可用和 Python 版本；出现 `websockets` 缺失只影响 Live，不必为离线演示联网安装。若停止脚本报告进程归属不匹配，请回到该服务的原启动窗口停止，不要根据旧 PID 随意终止进程。

验证命令：

```powershell
python -m unittest discover -s web_mvp -p 'test_windows*.py' -v
# 实际调用系统 OCR 识别自绘文字 / 空白图片，不截取桌面或微信
python web_mvp/diagnostics/check_windows_ocr.py
# 完整回归的媒体加密测试需要 requirements-dev.txt；安装仍由用户显式执行
python -m unittest discover -s web_mvp -p 'test_*.py' -v
```

单元测试使用模拟接口与合成数据，不能替代真实 Windows 微信窗口验收。本次 Windows 启动、只读状态探测、预览能力和真实收发的证据应分别记录。

UIA / OCR 界面的合成浏览器回归脚本为 `web_mvp/diagnostics/check_windows_ui.js`，使用 Playwright CLI 的 `run-code --filename` 执行。脚本拦截全部 Windows API 请求，不读取真实微信窗口。
