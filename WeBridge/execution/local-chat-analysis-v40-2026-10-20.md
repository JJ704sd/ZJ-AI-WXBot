# v40业务分析材料发版

日期：2026-10-20。基线：eda9b93。版本：桌面v40 / 个微、企微独立Skill 1.26.0。

本版在每群导出中新增 `analysis/`，批量导出新增 `batch-analysis/`，供人工或宿主整理业务时逐段阅读并以 `#序号`（跨群 `G序号#ref`）引用。回复、撤回只在本地来源或唯一serverId确认时关联；不删除、不排序、不按语义分类消息。原三格式、业务阅读、人工复核与导出门槛不变，分析材料纳入复核文件摘要。功能与边界见[版本与验证说明](../docs/local-chat/版本与验证说明.md)。

重新编译桌面EXE，按白名单生成桌面、个微Skill和企微Skill三份独立ZIP并合成完整交付总包；旧版本保留，build/00-最新交付.md已指向v40。

验证结果：

- 新增5项分析材料测试，扩展批量复核测试，个微、企微合成数据均通过。全仓787项中10项失败，逐项在v39基线复跑结果相同，非本次引入。
- check_runtime_identity.py：0问题。
- 编译EXE内47个项目模块与源码编译结果逐一一致，含offline_analysis及修改的导出、批量与汇报模块；GUI版本为v40。
- 隔离LOCALAPPDATA中原生窗口启动成功，内置Tcl/Tk可用，重置标记阻止旧配置导入，未访问真实账号配置。
- 从最终总包内取出的EXE在合成个微副本上执行导出：analysis索引、语料、发言人、分段及固定汇报入口均生成。
- 外层及三份内层ZIP的CRC、精确文件清单、SHA256SUMS一致；两端Skill为1.26.0、客户端绑定、禁用直接导出、EXE摘要正确，SKILL.md含分析材料读取规则；包内不含账号设置、密钥、数据库、聊天、预览或导出结果。

未做：真实账号解析或导出、GUI人工操作、WorkBuddy导入及异机验收。分段长度与回复关联率需在真实群上核对。

| 文件 | SHA-256 |
| --- | --- |
| WeChat-WeCom-Archive-Windows-Delivery-20261020-v40.zip | aa564d50844a823ae5f57303e3148eafeaa1988cd707337241d374324670b2bd |
| local-chat-review-v40-20261020-windows-x64.zip | f9e47d1a7befd11af40000ef74a5580df2b240442d532f5e10909d3aa8e7b5dd |
| WeChat-Archive-Skill-1.26.0-Windows-x64.zip | 6abe2a492f9a25f41d459772735ad058a974c4a81f9e37bc86cfa6f7b2a9f5e9 |
| WeCom-Archive-Skill-1.26.0-Windows-x64.zip | 0913944a83224b75bdfbbf9dcbcab07ed9a6fdf96f8e2645dea7d47ee396a704 |

完整包与最新索引仅存本地build；源码、说明和本记录同步远端。私有校验回执：.runtime/analysis-v40-delivery-check.json。
