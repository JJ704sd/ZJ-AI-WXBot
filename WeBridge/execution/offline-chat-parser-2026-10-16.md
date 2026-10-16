# 本地个微解析工具验证记录 — 2026-10-16

已增加独立离线 CLI、中文菜单、Windows x64 单文件 EXE 和便携分发打包脚本。未修改工作台的启动配置、发送接口、自动回复、定时任务或正在使用的副本；未提交、推送或对外发布。

## 已执行验证

最终 EXE 在移除 Python/PYTHONPATH/PYTHONHOME、工作目录不含项目源码的条件下，独立完成：用当前配置的已有密钥创建新副本、列群、导出用户明确选择的群、复制本机附件。此项验证在本台 Windows 10 x64 主机执行，尚未拿到另一台未安装 Python 的干净机器验收结果。

| 验证项 | 实际结果 |
| --- | --- |
| 新业务/附件副本 | 6 个加密数据库、6 份 WAL，全部通过逐页 HMAC、WAL 校验与 SQLite `quick_check` |
| 当前配置账号列群 | 3 个群；没有未映射的消息表 |
| 用户指定群导出 | 285 条，未设置条数上限，无截断；285 条正文均解码成功 |
| 顶层消息种类 | 文本 199、系统 7、表情 21、引用 31、图片 17、转发记录 5、文件 5 |
| 方向 | 本人 16、对方 266、未知 3；未知没有强行认定为对方 |
| 结构化 @ | 12 条；另 273 条无结构化 @ |
| 转发记录结构 | 含嵌套共 7 份记录结构均解析成功 |
| 媒体引用解析 | 完整附件 9、仅预览 14、待缓存 32、暂不可用 3；包含转发记录内的引用，不等于顶层消息数 |
| 独立图片文件 | 17 份通过 Pillow 图片解码校验，0 份失败 |
| 导出完整性 | 26 个产物的 SHA-256 全部回核匹配 |
| 自动化检查 | 89 项相关测试通过；`check_runtime_identity.py` 扫描 72 个运行源码文件，无嵌入账号问题；`git diff --check` 通过 |

测试命令（`TEMP/TMP` 使用长路径，避免本机 `ADMINI~1` 与 `Administrator` 路径别名引起既有测试的字符串路径比较失败）：

```powershell
$env:TEMP = "$PWD\.runtime\offline-test-temp"
$env:TMP = $env:TEMP
$env:PYTHONPATH = '.runtime/offline-build-deps;web_mvp'
python scripts/check_runtime_identity.py
python -m unittest web_mvp.test_runtime_identity `
  web_mvp.test_windows_hook_smoke.SourceBindingTests `
  test_offline_chat test_offline_cli test_database_snapshot `
  test_database_adapter test_windows_media test_database_service
```

新增测试覆盖 2303 行跨分片完整流式导出、来源保持、压缩正文与备用正文、不可解码字节留存、结构化 @ 与正文 @ 的区别、未知本人身份、北京时间日期边界、显式截断、重复群名拒绝、附件摘要匹配、SILK 原始语音、XML DTD 拒绝、HTML/CSV 注入处理、失败清理和 CLI/中文菜单。

## 未覆盖或明确限制

- 真实所选群没有独立语音库；语音原件导出和 MP4 定位通过合成测试，不能称作本次真实语音/视频内容验收。图片未 OCR、语音未转写、视频未做内容理解。
- 解析类型和原始字段保留不等于所有客户端私有编码都已完整解释。未知类型、深度/数量限制、未缓存附件和 WXGF 均保留状态；本机不存在的记录无法从此工具补拉。
- 本次浏览器视觉验收未执行成功：Chrome 控制入口不可用；内置浏览器策略明确禁止 `file://`，已停止该路径，没有换协议或其他入口绕过。HTML 只完成静态转义/CSP 检查与本机文件/媒体校验，布局仍待用户用本机浏览器打开检查。
- 不提取新的进程密钥、不注入、不操作客户端、不请求 CDN、不发送消息。仅使用用户已配置且匹配当前副本的数据库/图片密钥；不能保证免于个微风控。

真实验收内容留在被 Git 忽略的 `.runtime/offline-acceptance/`：`final-validation.json`、`final-groups.json`、`exe-snapshots/`、`cosplay-final/`。运行数据和密钥不进入便携分发包。

## 交付构建

构建运行库：Python 3.14.6、cryptography 46.0.7、zstandard 0.25.0；构建工具 PyInstaller 6.22.3。使用项目既定数据库依赖版本范围；依赖安装到 `.runtime/offline-build-deps`，全局 Python 未改动。

最终 EXE SHA-256：`15aea4416703019555f12cf72d214251330a1edbd91be3d9bc9480fbf87a39ea`。

分发包仅允许加入 EXE、使用说明、此验证记录、构建版本信息和第三方许可；不打包原始 ZIP、数据库、聊天内容、密钥、`.runtime` 或测试数据。完整用法与实现参考见 [LOCAL_CHAT.md](../LOCAL_CHAT.md)。
