# 固定汇报、三格式文件入口与真实 WorkBuddy 复测

日期：2026-10-16。桌面 v11 / local-wechat-archive Skill 1.4.2。

## 问题与修复

上一轮宿主拿到正确分类统计后，仍在补充说明中把18处缺失图片改写成仅缩略图，又把2个CSV写成3个；present_files只展示了MD及阅读页，没有提供JSONL、JSON入口。

- 程序新增 `mediaSummary.attachmentTypes`，按标准化扩展名统计引用次数及可用、仅预览、未取得、未加载状态；大小写合并，无法识别的扩展名归入unknown。附件各类型总数与附件引用总数一致，范围包含普通、转发及引用。
- 每次导出生成 `解析结果.md`，与回执 `reporting.replyMarkdown` 一致。程序统一生成媒体措辞、附件类型数量与三格式链接，并返回完整 `reporting.presentation` 参数。汇报文件加入产物摘要清单。
- Skill要求原样使用程序汇报，不按正文、目录或记忆另算数量、不补写图片状态解释；在WorkBuddy用present_files提供全部文件，JSONL、JSON、MD每次都包含。呈现工具不可用时如实说明并保留三格式本地链接。用户另行要求的业务归纳须与固定统计分开、保留原消息出处。
- 新字段为附加信息，原有JSONL/JSON消息字段、三格式文件名和旧媒体兼容字段保留；未引入新运行依赖，账号及路径从现有本机配置读取。

## 真实宿主任务验收

用户手动发送“解析示例混合群”后，核对本次新任务 `<RUN_ID>` 的用户可见答复和工具回执：

| 验收项 | 结果 |
| --- | --- |
| 已加载新规则 | 固定汇报、reporting.presentation规则存在 |
| 启动参数 | 仅传群名，复用现有数据和密钥配置 |
| 完成状态 | completed，285条源记录、264条业务阅读 |
| 最终答复 | 与程序生成的replyMarkdown逐字一致，忽略首尾空白 |
| 文件呈现 | present_files参数与程序提供的参数完全一致；工具确认成功提供7个文件、打开2个HTML预览 |
| 三种导出入口 | JSONL、JSON、MD均包含在成功呈现列表和最终答复中 |
| 图片 | 44处引用：原图6、缩略图20、缺失18、未加载0 |
| 附件 | 5处均可用：CSV 2、PDF 1、PPTX 1、XLSX 1 |
| 表情 | 21处均未取得，不混入图片统计 |
| 三格式与媒体 | JSONL与JSON的285条记录一致；MD含285条根消息及出处，31处媒体链接存在；32项产物摘要全部匹配 |

本次真实宿主导出目录：`%LOCALAPPDATA%\LocalWechatArchive\exports\20261016-185954-544740-2e3a23d2`。三格式、原始出处、媒体和报告均留在本机，不放入分发包。

桌面自动输入仍报 `coordinate input geometry is unavailable` / `FrameArrived timed out`，因此由用户完成发送，随后依据本机任务日志、程序回执和实际文件验收。没有声称完成截图或各文件卡片的点击验收，也没有修改宿主安全设置。

## 程序、免安装和包验证

新增公开导出与completed回执测试先复现reporting缺失，再验证固定汇报内容、三种文件参数、附件类型计数以及缩略图/缺失/未加载的区分。72项相关回归通过；账号源码检查90文件、0问题。

已安装Skill的Export、短句Parse和原生窗口检查均成功。原生图片总览实际显示26处图片，44处消息来源定位通过；7个转发结构展开、1个嵌套图片放大及5个附件打开回调通过，未重新逐个打开外部查看器。

本机安装22个包文件校验通过，安装前后默认配置摘要一致。WorkBuddy缓存已识别并启用1.4.2。PATH仅保留Windows系统目录、清除Python环境变量后仍可解析；运行时Python/Tk模块来源为程序自身临时解包目录。用户无需安装Python。

三个ZIP完整性和逐文件摘要验证通过；仓库外中文空格路径、空白配置下的两个Start.cmd实际创建原生窗口。打包白名单验证排除了聊天、媒体、密钥、账号设置和分享链接；来源EXE被篡改时拒绝打包。本次临时解压目录和临时测试进程已清理。另一台物理电脑及Windows 11仍未实测。

## 交付与证据

- [完整交付包](../build/WeChat-Archive-Windows-Delivery-20261016-v11.zip)
- [Skill包](../build/WeChat-Archive-Skill-1.4.2-Windows-x64.zip)
- [桌面包](../build/WeChat-Archive-Desktop-v11-Windows-x64.zip)
- 私有验证记录：`.runtime/offline-fixed-report-20261016/`，包含installation、installed-export、installed-parse、native-check、runtime-module-check、export-readback、delivery-validation、host-cache-check及workbuddy-verification的JSON。它们不进入交付包。

```text
Desktop ZIP b6f36896223a58d08aeb741fdcbcfa8c1c57d63cf8e501e81fb2b346e50d9932
Skill ZIP   6117af010d9e31ba62cc4c98c4985ae156a2103cb91df6ab29cac469ba74c3ad
Suite ZIP   520ffa6e7e436de52eba6ad45ffe159632e664c6f4e2b01c44d77d3e6acf0ce1
EXE         1f8883b1ea5a1ebf22f4e84227d6307e1d8c8ea48a64ef6f941824fe477533dc
```
