# 一键桌面版验证记录 — 2026-10-16

以下保留 v1 的历史构建与验证结果。最新的窗口内媒体查看及嵌套转发修复见 [v2 复测记录](offline-chat-media-v2-2026-10-16.md)，当前使用说明以 `LOCAL_CHAT_DESKTOP.md` 为准。

根据“一键启动、减少环境依赖”的补充要求，增加中文原生桌面入口，保留原 CLI。双击 EXE 直接打开窗口，自动复用已有数据配置、创建新的独立副本并列群；点击群预览最近 100 条，点击“解析并导出”导出所选日期范围内全部本地记录及可取得的附件。日期留空时无条数限制。

## 交付行为

- 运行库、解析组件、Tcl/Tk 窗口组件均内置 EXE。使用者不需要安装 Python、Tcl/Tk、Docker、WorkBuddy，也不配置环境变量、不输入命令、不启动网页服务。
- 本机已有工作台配置时自动复用，不启动或修改原工作台。成功选择过的数据源和群只保存为本应用的本地路径引用；第二次启动自动恢复。
- 新位置没有配置时显示首次选择数据界面，可通过按钮选择目录和已有密钥，或使用“发现本机账号”。不通过扫描进程取得新密钥，不把缺少密钥当作解析成功。
- 刷新和导出在工作线程执行，处理期间锁定目标；界面分别显示完整附件、仅预览和未取得原件的数量。关闭时等当前操作结束。
- 原始数据只读；程序自己的配置、副本和导出放在程序旁 `local-chat-data`，不打进通用分发包。

## 最终 EXE 实际验证

使用最终构建文件，在空工作目录中清除 `PYTHONPATH`、`PYTHONHOME`、`VIRTUAL_ENV`、`TCL_LIBRARY`、`TK_LIBRARY`，将 `PATH` 限于 Windows 系统目录。**没有传入 `--workbench` 或数据目录参数**，执行程序内置的启动检查，通过同一个真实窗口、后台任务、列群、预览及导出回调链验证：

| 检查 | 实际结果 |
| --- | --- |
| 原生窗口初始化 | 成功，窗口组件无须从外部 Python/Tcl 路径加载 |
| 自动配置发现 | 成功，复用同一项目位置中已存在的工作台配置 |
| 创建新的独立副本 | 成功，不使用伪造数据或固定账号准入条件 |
| 列群 | 3 个群 |
| 预览 | 最近 100 条 |
| 用户指定群导出 | 285 条，全部正文解码状态 `ok` |
| 附件结果 | 完整 9、仅预览 14、待缓存 32、暂不可用 3 |
| 再次启动 | 无须再次传配置，自动恢复已选群并预览 100 条 |
| 自动化相关回归 | 98 项通过；源码身份检查扫描 74 个运行文件，0 项问题；`git diff --check` 通过 |

EXE 内部归档检查确认包含 `python314.dll`、`_tkinter.pyd`、`tcl86t.dll`、`tk86t.dll`、`_tcl_data/init.tcl`、`_tk_data/tk.tcl`，没有 `settings.local.json`、真实消息 JSONL 或数据库。窗口版使用 GUI 子系统，不会弹出命令行菜单。

最终桌面 EXE SHA-256：`adb35c283a3065d6c41f0dab433f10a1fd312e273d2f22a5768f8abd060220b5`。

真实启动检查保存在被 Git 忽略的 `.runtime/offline-desktop-acceptance/final-desktop-validation.json`。本次实际导出保存在 `build/local-chat-desktop/local-chat-data/exports/`，启动配置同样位于本应用私有数据目录；不进入便携分发包。

## 测试与边界

新增 9 项桌面业务流程测试，覆盖自动启动、独立副本、第二次启动无需配置、完整导出、旧副本明确标识、源失败不切换账号、失败刷新保留上次来源、禁止写入微信目录和配置字段白名单。相关命令：

```powershell
$env:TEMP = "$PWD\.runtime\offline-test-temp"
$env:TMP = $env:TEMP
$env:PYTHONPATH = '.runtime/offline-build-deps;web_mvp'
python scripts/check_runtime_identity.py
python -m unittest web_mvp.test_runtime_identity `
  web_mvp.test_windows_hook_smoke.SourceBindingTests `
  test_offline_chat test_offline_cli test_offline_desktop `
  test_database_snapshot test_database_adapter test_windows_media test_database_service
```

窗口组件最初未被隔离构建环境收集。对比确认：普通隔离执行 `tkinter.Tcl()` 无法读取 `init.tcl`；同一安装在有访问权限的本机用户下可读且正常返回 Tcl 8.6.15。使用可读的本地构建环境打包后，最终 EXE 自带组件，通过清空环境变量的两次启动检查。构建脚本已增加资源预检，检测不到资源时提前失败，避免生成不完整窗口版。

上述为本机 EXE 及应用内回调链的执行证据，尚未在第二台完全未安装 Python 的 Windows 机器上验收，也未做人工像素级界面检查。此前媒体格式覆盖、真实语音/视频样本缺口及本地副本范围继续适用；参见 [解析验证记录](offline-chat-parser-2026-10-16.md)。

没有连接发送桥、客户端注入、进程取钥、消息发送或外部模型调用。本次没有提交、推送或公开发布。
