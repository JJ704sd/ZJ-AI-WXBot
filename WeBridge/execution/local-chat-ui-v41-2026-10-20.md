# v41界面改版发版

日期：2026-10-20。基线：e295aa2。版本：桌面v41 / 个微、企微独立Skill 1.27.0。

本版只改视觉层，不动业务语义。新增 `web_mvp/offline_theme.py` 作为统一设计系统：颜色、字号、间距令牌，`apply_theme(root)` 统一样式表，无箭头细滚动条，1px描边卡片，圆角状态胶囊与状态圆点，搜索放大镜，主操作/次级描边/文字三级按钮。主窗口重排为应用栏、侧栏卡片、阅读区、状态栏四层；群列表六列重排为 `pick|name|review|count|id|state`，使群名与复核状态在330px侧栏内直接可见；消息浏览区、日期选择器、图片总览和人工复核弹窗共用同一套配色与卡片样式。高分屏或小窗口下自动收起账号上下文行、底部文件路径行和下一步提示，完成提示条始终保留。

重新编译桌面EXE，按白名单生成桌面、个微Skill和企微Skill三份独立ZIP并合成完整交付总包；旧版本保留，build/00-最新交付.md已指向v41。

验证结果：

- UI关键测试24项（test_offline_open、test_offline_multiselect、test_offline_batch_review）全部通过，覆盖布局可见性、多选批量复核和导出选择。
- 复现并修复三处本次改版引入的真实回归：clam按钮 `width` 默认-11固定宽导致导出行溢出控件不可见（补 `width=0`，导出行由801px降到603px）；高缩放下完成提示条被误隐藏（紧凑模式改用 `tk scaling >= 1.6` 判定，完成提示条任何情况下不隐藏）；`BORDER_STRONG` 未导入导致复核弹窗半成品（已补）。
- `test_offline_target_search`、`test_offline_setup_integration` 在v40基线worktree上同样失败，依赖本机真实客户端目录扫描，非本次引入，未修。
- check_runtime_identity.py：0问题；test_runtime_identity 与 test_windows_hook_smoke.SourceBindingTests 共9项通过。
- 交付校验76项全部通过：四个包目录的SHA256SUMS逐条重算一致，package.json文件清单的字节数与摘要一致，外层总包CRC完好，三份内层ZIP与独立产物逐字节相同，包内无账号设置、密钥、数据库或聊天缓存。
- 从最终总包内取出的EXE在隔离LOCALAPPDATA下启动：窗口标题 `个微本地聊天解析 · 业务阅读 · v41`，诊断日志依次记录 process_started、window_initializing、waiting_for_account_configuration、configuration_dialog_opened，无 fatal_startup_error；窗口像素实拍确认新主题生效，近白底占比0.681、1021种颜色，非空白渲染。
- 与v40交付EXE同尺寸（1236x829）对照实拍：右侧控件右缘余量由21px收至16px（侧栏由310px增至330px所致），无控件被裁切。

未做：真实账号解析或导出、GUI人工操作、WorkBuddy导入及异机验收。视觉改版未在真实群上做人工观感复核。

| 文件 | SHA-256 |
| --- | --- |
| WeChat-WeCom-Archive-Windows-Delivery-20261020-v41.zip | d15751aa1794b2001ad21ca84f4ee3032ac88141a90df407d63f6d25d4273110 |
| local-chat-review-v41-20261020-windows-x64.zip | 6fff833f4bcb114841062c13f3a096b60fd031728eb5b3c24e86e3d7254f0695 |
| WeChat-Archive-Skill-1.27.0-Windows-x64.zip | 410372ad85875c015c66700153080c07cf4a36458058a7da25a43a44e74e8f6d |
| WeCom-Archive-Skill-1.27.0-Windows-x64.zip | a9baad07f009c7bcfbe19aa81f4a4679b463933067c1400cb06b25cfc8cdb5c4 |

完整包与最新索引仅存本地build；源码、说明和本记录同步远端。私有校验回执：.runtime/local-chat-ui-v41-delivery-check.json。
