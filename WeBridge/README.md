# 微桥 WeBridge

本目录维护于个人仓库 [JJ704sd/ZJ-AI-WXBot](https://github.com/JJ704sd/ZJ-AI-WXBot)，上游基线和本地导入方式见 [来源记录](UPSTREAM.md)。

本地微信工作台。Windows 从本机账号的数据库副本接收会话和消息，发送使用独立 Hook 接口；Hook 是否可用由当前模块版本、文件摘要与账号校验决定。演示与 Linux 桥接保留独立运行模式。

| 入口 | 用途 | 当前边界 |
| --- | --- | --- |
| Windows 数据库副本（默认） | 复制单账号业务库和 WAL，解密与校验后读取；按文件变化更新 | 使用已授权本地密钥；正文不重复写入工作台消息缓存，暂不解析附件 |
| Windows Hook 发送 | 检查本机模块，向当前账号已选择读取的会话手动发送文本 | 未适配或未校验时禁用；工作台不负责注入，接口返回不等于收件端送达 |
| Windows 本机只读预览 | 检测本台微信，显式通过 UIA 或本地 OCR 读取所选可见窗口文字 | 不发送；无法确认群 ID、发送者或消息完整性 |
| 本地演示 | 离线体验工作台、模拟消息/计划/回复 | 全部为合成数据；不连接微信 |
| Linux 桥接 | 复用已有 Linux ARM64 微信实验容器 | 真实收发依赖原实验环境；不是 Windows 原生收发 |

Windows 安装 Python 3.10+ 后，双击根目录 `start-workbench.cmd`。默认打开 <http://127.0.0.1:8787>，无需 Docker。加密数据库及压缩内容需要 `web_mvp/requirements-database.txt` 中的组件。也可以在仓库目录执行：

```powershell
.\start-workbench.cmd
```

首次进入数据源设置，选择单账号 `db_storage` 目录并填写本地密钥文件路径。原始库只按文件读取，SQLite 查询只作用于校验后的独立副本。Hook 发送须另行检查模块与账号；未知版本不会解锁发送。使用 `-Mode Demo` 可打开合成演示；演示回执不表示本机微信已接入。

保持启动窗口打开；按 `Ctrl+C` 或双击 `stop-workbench.cmd` 停止网页服务。查看 [Windows 启动与接入说明](WINDOWS.md)、[功能与 Linux 桥接文档](web_mvp/README.md) 和 [原项目执行记录](execution/STATUS.md)。

私有运行数据位于 `.runtime/`，桥接凭证位于 `.secrets/`，均被 Git 忽略。当前目录保留原项目的实现和历史验收材料；历史 Linux 实测结果不构成当前 Windows 原生功能验收。

本次检查、改进和测试结果见 [Windows 工作台交付记录](execution/windows-workbench-review-2026-09-26.md)。
