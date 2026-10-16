# 桌面与 Skill 配置统一：v20 / 1.13.0

日期：2026-10-16。本轮仅调整配置与启动兼容，不新增依赖，不修改消息、附件正文或导出字段，不重复完整媒体解析。

## 结果

- 个微默认统一为 `%LOCALAPPDATA%\LocalWechatArchive`；企微统一为 `%LOCALAPPDATA%\LocalWeComArchive`。直接运行 EXE、桌面启动脚本及各自 Skill 使用同一位置，个微企微独立。
- 无新目录配置时，在程序附近、相邻旧版本和当前工作目录/build 下有预算地查找已知旧配置。唯一账号通过数据库/结构校验后迁移，同账号多个版本优先最近修改者；不同账号不猜选。
- 相对路径按旧配置目录解析；明确引用的数据库及图片密钥复制到新 keys，更新引用；旧文件与 lastChat 保留。完整配置原子发布，已有配置不自动覆盖，失败可重试。
- 设置手动页新增“导入旧版配置”，解决旧目录不在查找范围或需要选择账号的情况；显式自定义 DataDir 仍独立。
- 默认个微入口拒绝带企微客户端的批任务，避免写入另一客户端的默认目录。
- 已更新本机两个独立 WorkBuddy Skill 1.13.0；原有两套用户配置的字节未改变。

## 必要验证

1. 先通过公开 main 的批处理入口复现旧默认目录随 EXE 位置改变。修复后6项配置用例通过：默认位置、两客户端迁移/密钥副本、账号冲突/明确导入、损坏配置/客户端隔离/自定义目录、失败重试及跨客户端批任务拒绝。
2. 5项既有批处理检查通过，9项账号绑定与源码检查通过；身份扫描103文件、0问题。仅2项配置窗口检查，覆盖处理中/失败常驻及继续原群请求，均通过。
3. 最终 EXE：使用本机两个已授权账号的配置和密钥隔离副本，通过真实数据库校验；确认密钥副本和 lastChat、旧配置不变，移除旧配置副本供发现后再移动 EXE，两客户端仍可复用固定目录。PATH不含Python；没有读取进程取钥，没有导出群消息。
4. 安装后的两个 Skill：Windows PowerShell 5.1 原生 Groups 入口在PATH不含Python时通过，默认复用真实用户配置并读取群索引，原配置字节不变。没有通过 WorkBuddy 模型发送新任务，没有重启用户现有桌面窗口。
5. 四份ZIP完整性、清单摘要、EXE一致性、客户端绑定、说明链接与许可检查通过；不含聊天、数据库、媒体、密钥或用户配置。

运行证据保存在未分发的 `.runtime/profile-unification-v20-20261016/`，包括源文件摘要、构建日志、portable-verification.json、installed-verification.json和split-package-audit.json。测试脚本首次两处环境变量/编码拼写错误已修正后重跑，不属于交付程序故障。

## 交付

- `build/WeChat-Archive-Desktop-v20-Windows-x64.zip`
- `build/WeChat-Archive-Skill-1.13.0-Windows-x64.zip`
- `build/WeCom-Archive-Skill-1.13.0-Windows-x64.zip`
- `build/WeChat-WeCom-Archive-Windows-Delivery-20261016-v20.zip`

EXE SHA-256：`ed98b1fb408c1d332d5081d698260ee5cec0805097525efc2abc86d5c453109f`。详细包内摘要见各自package.json与SHA256SUMS.txt。

## 边界

本机验证不代表已在其他物理电脑或Windows11验收。换Windows用户或换电脑仍需首次配置该电脑的数据；源数据库、密钥已经丢失时，配置迁移无法补回。旧导出不搬迁；移走唯一数据副本仍可能使源路径失效。固定用户配置已存在时优先保留，需要改用其他旧账号应明确在手动页导入。
