# 本地个微聊天记录解析

独立离线工具，复用 WeBridge 的数据库副本、SQLCipher 页校验、WAL 合并和本机媒体定位代码。Windows x64 便携版内置 Python 与运行库；使用者不需要安装 Python、Docker、Frida 或 WorkBuddy。双击 `local-chat.exe` 可进入中文菜单，也可由其他 Agent 通过命令行启动。

**优先使用 [一键桌面版](LOCAL_CHAT_DESKTOP.md)**：双击 `本地聊天解析.exe`，自动加载现有配置并列群，通过窗口选择群、预览和导出；无需命令行。下面的 CLI 继续供脚本或 Agent 调用。

当前桌面业务阅读版默认折叠表情，导出新增 `业务阅读.txt` 和逐项媒体核查清单 `media-recovery.jsonl`。缺少内嵌正文的引用可关联同群中唯一且发送者一致的本地来源。`manifest.json` 新增可选的业务条数、引用补齐及本地媒体匹配统计；原有源字段、文件与计数继续保留。

桌面 EXE 同时提供 `--task-json 请求文件 --result-json 新结果文件 --data-dir 本机工作目录`，Skill 通过此入口完成无窗口列群和导出，使用者无需运行 `.py`。v5 新增 `--open-chat-name 群名`（或 `--open-chat 会话ID`）直接解析并打开；首次选择数据后自动继续，可选 `--open-result-json` 在工作目录 requests 子目录返回阶段和完成状态。Skill v1.1.0 默认封装这个短入口，用户只说“解析某某群”，使用固定本机设置目录，不必提供任何路径。

图片密钥不再按旧绝对路径拒绝：按内容校验候选；支持在一个 JSON 的 `keys`、`imageKeys` 分别保存数据库和图片密钥。正常解析仍只读文件；桌面和 Skill 另有用户主动触发的本机进程只读取钥，需要本机当前微信唯一持有所选数据，不属于离线密文破解。详细说明见桌面文档及 Skill 的输入与故障说明。

当前存储适配是 Windows 微信桌面版 **4.x 的 `db_storage` 布局**。其他客户端、3.x、手机备份和企微数据库没有据此获得支持。读取只针对本人有权访问的本地数据；脚本不会连接微信服务器、操作客户端、调用发送接口、获取进程密钥或自动下载附件。离线读取减少客户端交互，不能保证免受风控。

## 本机最快用法

在本仓库目录执行以下命令。`local-chat.cmd` 优先调用 `build/local-chat/local-chat.exe`，未构建时才使用已有 Python。

```powershell
# 从已有工作台成功副本列出群；不启动工作台、不刷新、不取钥
.\local-chat.cmd groups --workbench

# 精确选择一个群；默认导出全部本地记录，不受网页最近 200/2000 条限制
.\local-chat.cmd export --workbench --chat-name "示例混合群" `
  --copy-media --output ".runtime\offline-exports\cosplay-20261016"

# 按北京时间日期导出，开始和结束当天均包含
.\local-chat.cmd export --workbench --chat-name "示例混合群" `
  --start-date 2026-10-01 --end-date 2026-10-16 `
  --output ".runtime\offline-exports\cosplay-october"
```

`--workbench` 默认查找本地项目的 `.runtime/web_mvp-database/database-config.json`。便携文件移到其他目录后，可显式传入该配置路径：`--workbench "<WORKBENCH_CONFIG>"`。已有工作台模式复用它的本人标识和附件配置，不修改原配置。群名重复时必须用 `groups` 返回的 `--chat` ID。

## 新电脑或独立数据副本

```powershell
# 只发现目录、数据库大小及加密状态，不读取聊天正文或密钥
.\local-chat.exe discover
.\local-chat.exe discover --root "<WECHAT_DATA_ROOT>"

# 创建新的独立副本，保持子目录结构；合并已提交 WAL 并逐页校验
.\local-chat.exe snapshot --source "<WECHAT_DB_STORAGE>" `
  --keys "<DATABASE_KEYS_JSON>" --media `
  --output "<SNAPSHOT_OUTPUT_DIR>"

# 将上一步返回的 snapshotRoot 填入下面路径
.\local-chat.exe groups --snapshot "<SNAPSHOT_DIR>"
.\local-chat.exe export --snapshot "<SNAPSHOT_DIR>" `
  --chat "从群列表复制ID" --self-id "本人微信ID" `
  --media-root "<WECHAT_SOURCE_ROOT>" --image-keys "<IMAGE_KEYS_JSON>" `
  --copy-media --output "<EXPORT_DIR>"
```

账号发现支持默认 `Documents/xwechat_files`、`Documents/WeChat Files` 或显式 `--root`。目录名仅作定位，不能当成本人微信 ID。`groups --include-direct` 可同时列出私聊；导出也可选择私聊 ID。未提供本人 ID 时，`isSelf` 为 `null`、方向为 `unknown`，不会把所有人误判成对方。

加密副本必须有**匹配的已有密钥文件**。只有密文无法实现通用解密；此工具不会自动运行现有项目的进程取钥脚本。数据库密钥格式为 `{"keys":[{"key_hex":"64位十六进制已派生AES密钥","salt_hex":"32位十六进制salt"}]}`。按 salt 选择密钥后，每页 HMAC 和 SQLite `quick_check` 都必须通过，损坏页不会被跳过。V2 DAT 图片另需工作台同格式的 `imageKeyFile`；DB 密钥不能代替图片密钥。密钥不写入命令行、导出内容或日志。

`snapshot --voice` 可额外纳入 `message/media_N.db`，需要这些库的匹配密钥。默认不读语音库，避免把缺少语音密钥的既有工作台配置误报为完整支持。

## 输出与覆盖范围

每次输出到一个**不存在的新目录**。源账号目录与副本目录不能作为导出目标。失败会移除本次临时输出，已有交付物不会覆盖。

| 文件 | 内容 |
| --- | --- |
| `chat.html` | 可双击查看的离线阅读页；文字、转发层级、引用、链接和已取得媒体 |
| `messages.jsonl` | 每条完整记录、原始正文和所有源列；二进制用 `encoding: base64` 保留 |
| `messages.csv` | 方便筛选的消息视图；中和以公式符号开头的单元格，不作为原始数据替代品 |
| `业务阅读.txt` | 保留非表情消息全文、引用来源、转发层级和媒体状态的阅读文件 |
| `media-recovery.jsonl` | 未取得原件的媒体逐项核查结果；表情单独标为可选 |
| `members.json` | 数据库能验证的群成员；历史发言者不会自动补造成当前成员 |
| `assets/` | 按内容摘要命名的本机附件；保留原件与缩略图的区别 |
| `manifest.json` | 行数、消息类型、解码状态、结构化 @ 状态、方向、附件状态、未映射消息表、源 schema、产物 SHA-256 |

消息识别覆盖文本、结构化 @ 列表及 @所有人、图片、表情、视频、文件、链接、引用、嵌套转发记录、语音元数据、位置、联系人名片、小程序、视频号卡片、通话及部分系统/支付卡片。未知类型保留原始字段并标注状态；这不等于对全部微信版本、支付状态和所有私有编码的完整解释。转发记录最多解析 10 层、每层 10000 项；达到限制会明确标记，原始 XML 仍保留。单条正文解码上限 4 MiB，超限或失败时保留源字节。

结构化 `mentions.ids` 来自数据库的 `source/msgsource/atuserlist` 等字段。正文中的 `@某人` 单独保存为 `displayTokens`，不会推断真实成员 ID。发送者优先用当前分片 `Name2Id` 映射；自己/对方依赖明确提供的本人 ID。所有分片来源行均保留，以 `provenance.database/table/localId` 区分，不按相同正文猜测去重。

附件仅在 `--copy-media` 时复制，优先按消息索引定位；缺少原件时，在所选账号的媒体目录内按完整内容 MD5 搜索匹配，单文件上限 100 MiB。完整附件有 MD5 时必须匹配。`ready` 表示取得本机原件，`previewOnly` 表示仅缩略图或封面，`pending/unavailable` 表示未取得原件。转发媒体沿用工作台已验证定位能力：最多 5 层、每层前 200 项，超出范围保留元数据并标记未取得；转发中的语音原件尚未适配。WXGF 和部分表情缓存尚未完整解码，不会伪装成图片成功。语音可从具有唯一映射的 `VoiceInfo` 导出原始 SILK/AMR 编码，未转码、未语音识别。

HTML 不执行消息里的 HTML/脚本，不加载远程图片或资源。链接只提取，用户点击才由浏览器打开。保留原件的文件通过下载链接提供。JSONL 可能含正文、群成员、链接参数及本机路径，应与数据库、密钥一样留在本地。未下载、已删除或本机不存在的历史不能从副本恢复。图片 OCR、视频内容理解、语音转写没有包含在解析完成范围。

## 构建与验证

开发者使用 Python 3.10+，明文/非压缩消息读取仅需标准库；加密和 Zstandard 正文复用 `web_mvp/requirements-database.txt` 的 `cryptography`、`zstandard`，迁移图片候选的实际解码校验还需 Pillow。以上依赖随 EXE 打包，用户不用安装。构建工具隔离到项目 `.runtime`：

```powershell
python -m pip install -r web_mvp/requirements-database.txt
python -m pip install --target .runtime/offline-build-deps -r scripts/requirements-offline-build.txt
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/build_local_chat.ps1
```

产物为 `build/local-chat/local-chat.exe`。`--OneDirectory` 可生成便携文件夹形式（需分发整个文件夹）。构建不会打包 `.secrets`、`.runtime` 数据副本、聊天导出或测试数据。

构建完成后，可用 `python scripts/package_local_chat.py --output build/local-chat-windows-x64-批次名` 生成带使用说明、验证记录、版本清单和第三方许可的 ZIP。输出路径必须是新的；打包仅从明确的文件白名单取材。

本次本地验证记录见 [offline-chat-parser-2026-10-16.md](execution/offline-chat-parser-2026-10-16.md)。

实现参考：提供的 `<LOCAL_SOURCE_ARCHIVE>` 仅作离线源码参考，没有运行其中的脚本或使用它携带的旧数据库；数据库布局参考现有工作台和 [GreenBubbles 源项目的存储格式记录](https://github.com/bojieli/greenbubbles/blob/main/docs/WECHAT_DATABASE_FORMAT.md)。加密机制与日志边界核对 [SQLCipher 官方设计](https://www.zetetic.net/sqlcipher/design/)、[SQLite 官方 WAL 说明](https://sqlite.org/wal.html)、[Tencent WCDB](https://github.com/Tencent/wcdb)；便携打包依据 [PyInstaller 官方文档](https://pyinstaller.org/en/stable/operating-mode.html)。外部参考用于核对设计，当前适配以本地实测为准。
