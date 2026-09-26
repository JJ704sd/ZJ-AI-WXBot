# 来源与仓库归属

本目录作为普通源码目录维护在个人仓库 [JJ704sd/ZJ-AI-WXBot](https://github.com/JJ704sd/ZJ-AI-WXBot) 中，运行入口和相对路径仍以本目录为基准。

| 项目 | 记录 |
| --- | --- |
| 来源项目 | [15813489353/WeBridge](http://120.79.129.209:10093/15813489353/WeBridge) |
| 采用分支 | `main` |
| 基线提交 | `66170b1f28c3a85493c740061d5dd5c54fce8f68` |
| 核验 / 本地导入日期 | 2026-09-26 |
| 本轮改进 | Windows 启动、工作台界面与交互、本机客户端检测和只读读取入口 |
| 改进记录 | [Windows 工作台检查与交付记录](execution/windows-workbench-review-2026-09-26.md) |

本机最初使用独立检出开发。确认个人仓库后，保留 `WeBridge/` 源码路径，将嵌套 `.git` 元数据归档到外层仓库已忽略的 `.research/webridge-upstream-git-20260926/`，并保留变更补丁 `.research/webridge-workbench-before-integration.patch`。源码与新文件没有移动或删除；运行目录、凭据、浏览器记录及截图继续由忽略规则排除。

当前目录不再是 Git 子仓库或子模块。提交本目录时应提交实际源码文件，不能仅提交指向外部仓库的 gitlink。上游历史记录仅说明其原环境，不代表本台 Windows 的原生收发能力已通过验收。
