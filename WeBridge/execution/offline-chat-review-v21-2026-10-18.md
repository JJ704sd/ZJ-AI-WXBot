# v21 群聊解析与人工复核导出验证

日期：2026-10-18。范围：本地脚本、桌面界面与便携程序；全部新增流程验证使用合成数据，未读取真实账号聊天或开展实际业务复核。

## 交付行为

默认入口展示所选账号全部本地群 ID 与名称；选择群 ID 后，仅解析该群完整日期范围。结果先存入内部 `reviews/` 阅读缓存，不设置正式导出入口。人工检查四项复核并确认后，将同一批结果发布到新的 `exports/`，包括 JSONL、JSON、Markdown、附件与 `review.json`。群 ID、数据源、刷新、重新解析或文件变化不能沿用旧复核。明确选中的群 ID 优先于搜索词。

保留原有底层导出接口兼容性；它们不生成“人工已复核”状态。桌面回执 `awaiting_review` 表示待人工，确认成功后才为 `completed`。完整格式契约见[复核导出流程](../docs/local-chat/复核导出流程.md)。

## 执行结果

- `python -m unittest discover -s web_mvp -p 'test_offline*.py'`：98 项通过。
- `python -m unittest web_mvp.test_wecom_archive web_mvp.test_runtime_identity web_mvp.test_windows_hook_smoke.SourceBindingTests`：16 项通过。
- 最终群 ID 选择调整后，`python -m unittest web_mvp.test_offline_target_search` 复验通过。该测试覆盖同名群、列群和选择不解析、默认未勾选、未复核不能导出、确认后三格式一致，以及重复确认拦截。
- `python scripts/check_runtime_identity.py`：扫描105个运行源码文件，无问题。
- v21 桌面 EXE 构建完成。移除外部 Python/Tk 环境变量并限制 PATH 后，最终 EXE 在当前 Windows 10 主机分别读取个微1条、企微2条合成消息，原生阅读控件检查通过，均返回 `awaiting_review`，正式导出数为0。
- 最终便携包的25个清单文件摘要及ZIP完整性检查通过；无聊天数据库或密钥。

桌面 EXE SHA-256：`ff724d43d14ceaf35a28aa556908c19b6e5d7979e6c29f089427e8e87225771d`。

## 证据边界

上述测试证明流程、数据绑定、复核控制及格式一致性，不代表真实账号下所有群聊或所有业务消息已完整还原。仅处理本机保存的数据；缺失媒体、未支持类型和未知身份保留状态。未执行真实业务人工复核，未验收另一台物理电脑或 Windows 11，未调用外部模型。代码同步不包括聊天、密钥、内部预览、导出或运行目录。
