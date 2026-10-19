# v34完整交付包重新整理

日期：2026-10-19。基线：b94c107。版本保持桌面v34 / 个微、企微Skill1.20.2。

重新按白名单生成桌面、个微Skill和企微Skill三份独立ZIP，再合成完整交付总包。复用与最终源码一致、此前已验证的v34 EXE，没有重复修改解析代码或重编运行库。旧包保留，最新交付集中到build/WeChat-WeCom-Archive-Windows-Delivery-20261019-v34，build/00-最新交付.md提供统一索引。README入口已更新到v34。

完整总包含三份独立ZIP、操作与演示说明、版本验证说明、许可及校验清单；WorkBuddy分别导入内层对应客户端Skill ZIP。桌面个微使用Start.cmd，企微使用Start-WeCom.cmd。说明明确先选群、每群完成即查看、逐群人工复核后再导出，区分分发包与本机配置目录。

验证结果：

- 外层及三份内层ZIP的CRC、精确文件清单、每个文件与SHA256SUMS摘要均一致；总包与解压目录字节一致，README本地链接均存在。
- 两端Skill版本、客户端绑定、多选、逐群复核、禁用直接导出及运行EXE摘要正确；三份包均与已验证的v34运行库一致。
- 包内不包含账号设置、keys、数据库、聊天、媒体缓存、解析预览、导出结果或运行目录。
- 两端本机演示账号设置及密钥缓存仍为空，原exports目录保留。本次打包不回填缓存、不取钥、不读真实聊天。
- check_runtime_identity.py：107文件、0问题。
- 本轮只做必要的交付完整性与演示缓存状态校验，没有重复GUI或真实账号解析；此前v34的界面、隔离启动及人工复核拦截证据见local-chat-compact-v34-2026-10-19.md。未新增WorkBuddy宿主导入或异机验收结论。

| 文件 | SHA-256 |
| --- | --- |
| WeChat-WeCom-Archive-Windows-Delivery-20261019-v34.zip | 1e0f8ba9a31b1c78cba235d0974e3b37bd283d5a210aabfac8573a3b4904135b |
| local-chat-review-v34-20261019-windows-x64.zip | ab1d86142e3fa4d90adc8eea7b879803ff65de4631ca2e420b6a1db372e3854b |
| WeChat-Archive-Skill-1.20.2-Windows-x64.zip | 30f1fbb2a7a144d5e7489979744bcb37482580563f228f992713c4aef16e148e |
| WeCom-Archive-Skill-1.20.2-Windows-x64.zip | 6d33201233646f93cadc604da0de8b2f0c6e0b7931958f07bed5dc600bb80548 |

完整包与最新索引仅存本地build；打包脚本、README和本记录同步远端。私有校验回执：.runtime/repack-v34-delivery-check.json。
