# 企微账号企业信息：v35 / Skill 1.21.0

企微账号下拉列表增加企业简称，所选账号详情和当前账号信息显示企业全称；长名称可在当前账号栏换行。昵称相同的多个账号仍分别保留账号目录及运行进程信息。

只从已匹配本人记录的 `user_table.corp_id` 查询同账号 `company.db` 中 `external_company_table_v2.corpany_id` 对应的企业，不使用其他联系人的企业或首条缓存记录。企业库缺失、密钥不匹配、布局不支持或同一企业ID存在多条记录时保留未知状态，昵称读取继续可用。补充企业信息不保存配置或临时资料密钥。

已知昵称但缺少企业信息的运行账号也可通过显式识别按钮补充。进程归属和启动时间检查继续生效，企业名称只是显示信息；内存中的识别结果不会跨账号、PID或进程启动时间复用。

## 本次验证

- `python -m unittest web_mvp.test_offline_account_profiles web_mvp.test_live_account_profiles web_mvp.test_offline_setup_integration.WeComSetupFlowTests.test_saved_inactive_account_is_explicit_and_running_choice_only_edits_form web_mvp.test_runtime_identity web_mvp.test_windows_hook_smoke.SourceBindingTests`：30项通过。包含个微兼容、同昵称不同企业、精确企业匹配、密文企业资料、缺库和歧义保留昵称、企业缓存隔离，以及原生界面中的简称和全称显示。
- `python scripts/check_runtime_identity.py`：107个文件，0项问题。
- 本机一个企微账号资料只读验证：通过原有本地密钥读取本人资料和企业资料，取得企业全称及简称；未读进程内存、未导出聊天，账号配置和密钥文件保持原样。真实名称与私有资料仅留在本地验证记录中。
- 新版便携EXE在独立空数据目录完成原生窗口启动检查，返回首次配置状态；未依赖外部Tcl/Tk环境变量。
- 新EXE中的12个相关模块与本次源码一致；桌面及两个客户端Skill ZIP校验运行版本、客户端绑定、清单、CRC及逐文件SHA256，不含本机账号、密钥或聊天缓存。

上述界面检查使用合成资料，不代表重新完成WorkBuddy宿主导入或真实聊天人工复核。正式导出仍需人工确认。
