# v11-r1 说明整理与交付包核验

日期：2026-10-16。桌面v11 / Skill 1.4.2。r1仅整理交付说明，EXE、启动脚本与Skill执行规则沿用已验收版本。

## 本次整理

- 新增 `docs/local-chat/操作指南.md`，覆盖选包、首次配置、WorkBuddy与独立桌面操作、三格式导出、结果转移、更新和常见问题。
- 新增 `docs/local-chat/版本与验证说明.md`，注明真实验证范围、匿名汇总结果、无Python要求及未完成的跨物理机/Windows 11验证。
- 项目README新增免安装归档入口，保留网页工作台原运行流程。
- 更新功能说明的交付链接与最新宿主验收记录；打包脚本按白名单向桌面包、Skill包和总包复制必要说明。
- 旧包与用户工作目录保留。本轮未重新安装Skill或更改本机配置，已安装1.4.2的用户可继续使用。

## 交付

| 文件 | 大小（字节） |
| --- | ---: |
| WeChat-Archive-Windows-Delivery-20261016-v11-r1.zip | 50706232 |
| WeChat-Archive-Desktop-v11-r1-Windows-x64.zip | 25326529 |
| WeChat-Archive-Skill-1.4.2-r1-Windows-x64.zip | 25337535 |

总包包含两个独立ZIP、README、操作指南、功能说明、版本验证说明、package.json及SHA256SUMS.txt。Skill导入内层Skill ZIP；桌面版完整解压内层桌面ZIP后双击Start.cmd。

## 已执行核验

ZIP完整性、逐文件摘要、说明链接、支持文档内容与源文件一致性、许可及隐私排除检查通过。桌面包19个文件、Skill包24个文件、总包8个文件；不含聊天、数据库、媒体、密钥、账号设置或真实任务分享链接。

新旧独立包比较仅新增两份说明，更新README、功能说明和清单；所有程序、Skill规则、启动脚本及许可文件摘要不变。EXE SHA-256仍为 `1f8883b1ea5a1ebf22f4e84227d6307e1d8c8ea48a64ef6f941824fe477533dc`。

仓库外中文空格路径、空白配置、PATH不含Python时，两种Start.cmd均创建原生窗口，首次提示配置；本次临时程序与解压目录已清理。打包污染测试确认排除未列出的私有文件，篡改来源EXE时拒绝打包。源码账号检查90文件、0问题，git diff --check通过。

本轮没有重跑上一轮72项功能回归或真实群任务；程序与Skill执行规则未变，并通过摘要比对确认。其他物理机和Windows 11尚未实测。

首次核验因Windows换行转换而在文档字节比较处失败，改为比较UTF-8文本内容；文件摘要仍按交付包实际字节独立校验，后续检查全部通过。

私有核验证据位于 `.runtime/offline-release-r1-20261016/` 的delivery-validation.json与release-proof.json，不放入交付包。

```text
Suite ZIP   351faab13ff6210377fd8641408bdfae538c6196ec8594fba4cd0f8ed35cac05
Desktop ZIP 2ab06de568f292b3cbad07e92b5c7f03fb0b47e76e382693b81ad7b5ecfb0d2f
Skill ZIP   f1a65f0c971a0f10755895696ac3aed9f5580505053a957e24289ce6b1fb9a52
```
