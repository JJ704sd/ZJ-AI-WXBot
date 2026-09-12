# Chat-Lab 群聊机器人可行性：源码证据审计

核验时间：2026-09-12。范围：个人微信受邀进入企微与个微混合群，持续分析消息并主动回复的前置能力。按最新范围，仅做可行性核验。

> 本文为第一轮固定提交 `a42137b` 的审查记录。最新参考版本 `67bb1f1` 的复用判断及新增离线实验见 [第二轮评估](../Chat-Lab技术复用评估_第二轮.md)。

## 结论

Chat-Lab 可复用为聊天分析层，但当前仓库没有完成群聊机器人收发闭环。已有官方企微存档采集代码、本地加密库采集代码、物流规则分析和可选真实 LLM 调用；没有发现以个人微信身份向混合群发送消息的适配器，也没有完整的主动回复 Agent 工作流。已有“回复匹配／方案评估”是在分析群成员已经发出的回复，不能视作自动回复功能。

这份审计只能证明代码包含哪些实现，不能证明当前客户端版本、目标混合群、平台权限以及真实机器人收发已验证成功。

## 代码基线与审计方式

- 源仓库：[JJ704sd/Chat-Lab](https://github.com/JJ704sd/Chat-Lab)。
- HEAD：`a42137baaed3e05acbf3863a257f43e1cb68e114`。
- 审计前后 `git status --porcelain=v1` 均为空。
- 只读检查 README、实现代码、依赖声明及测试文件名；没有运行测试、构建、采集、解密、服务或 LLM，没有读取真实聊天数据库或密钥文件，没有发送消息。
- 仓库中的旧 Spec、计划、提示词文件作为历史材料阅读，其内容没有被当成本次任务指令。

## 关键能力及精确证据

| 能力 | 当前实现 | 证据与限制 |
| --- | --- | --- |
| 官方企微存档读取 | 有实际 SDK 调用代码 | [WxJavaAuditGateway.java:20](https://github.com/JJ704sd/Chat-Lab/blob/a42137baaed3e05acbf3863a257f43e1cb68e114/collector-wxjava/src/main/java/chatlab/collector/audit/WxJavaAuditGateway.java#L20) 调用 `getChatRecords`；第 25–26 行调用 `getChatRecordPlainText`；第 30–32 行为媒体下载。入口属于企微会话存档，未出现个微消息发送。 |
| 拉取与解密 | 已写入自动处理逻辑，无需逐条手工解密 | [ChatIngestService.java:112](https://github.com/JJ704sd/Chat-Lab/blob/a42137baaed3e05acbf3863a257f43e1cb68e114/collector-wxjava/src/main/java/chatlab/collector/audit/ChatIngestService.java#L112) 第 118–155 行读取持久化 seq、拉取、解密、映射、入库、导出；解密失败停止推进该条后的游标。真实运行仍需要企业存档权限及配置。 |
| 采集默认状态 | 默认关闭 live | [application.yml:22](https://github.com/JJ704sd/Chat-Lab/blob/a42137baaed3e05acbf3863a257f43e1cb68e114/collector-wxjava/src/main/resources/application.yml#L22) 为 `live: ${COLLECTOR_LIVE:false}`；23–24 行默认每批 10 条、45 秒轮询。 |
| 采集时序 | 定时拉取，尚非端到端实时机器人 | [CollectorApplication.java:61](https://github.com/JJ704sd/Chat-Lab/blob/a42137baaed3e05acbf3863a257f43e1cb68e114/collector-wxjava/src/main/java/chatlab/collector/CollectorApplication.java#L61) 定时任务；[pipeline.py:116](https://github.com/JJ704sd/Chat-Lab/blob/a42137baaed3e05acbf3863a257f43e1cb68e114/src/chatlog_assistant/pipeline.py#L116) 是单次 inbox 导入函数。检查中未发现 Java 新文件到 Python 分析再到群回复的完整自动调度。 |
| 采集认证要求 | 存档专属 Secret、RSA 私钥、SDK、IP 白名单 | [collector-wxjava/README.md:54](https://github.com/JJ704sd/Chat-Lab/blob/a42137baaed3e05acbf3863a257f43e1cb68e114/collector-wxjava/README.md#L54) 起“密钥与白名单”。此要求是仓库文档记录，本审计没有检验当前企业租户权限。 |
| 夹具入口 | 明确支持 mock/fixture；无配置时 idle | [ChatIngestService.java:66](https://github.com/JJ704sd/Chat-Lab/blob/a42137baaed3e05acbf3863a257f43e1cb68e114/collector-wxjava/src/main/java/chatlab/collector/audit/ChatIngestService.java#L66) 优先执行 fixture，第 69–73 行决定 idle 或 live。不能把 fixture 成功视作官方群实测。 |
| 老 C# 采集器 | 只见 fixture 主流程 | [Program.cs:11](https://github.com/JJ704sd/Chat-Lab/blob/a42137baaed3e05acbf3863a257f43e1cb68e114/collector/WeComArchive.Collector/Program.cs#L11) 无 fixture 时打印 live 所需条件并 `return 2`；第 28 行开始读取 fixture 文件。README 第 75 行明确它不再作为生产路径。 |
| 官方存档消息类型 | 文本／markdown／图片／文件／语音／视频／表情／链接／位置／撤回／混合消息的映射 | [UnifiedMessageMapper.java:85](https://github.com/JJ704sd/Chat-Lab/blob/a42137baaed3e05acbf3863a257f43e1cb68e114/collector-wxjava/src/main/java/chatlab/collector/mapping/UnifiedMessageMapper.java#L85) 第 85–115 行。图片、语音等通常产生占位文本；媒体下载不等于 OCR/ASR 或内容理解。 |
| 个人微信本地读取 | 已有本地库提取入口 | [live.py:145](https://github.com/JJ704sd/Chat-Lab/blob/a42137baaed3e05acbf3863a257f43e1cb68e114/src/chatlog_assistant/sources/live.py#L145) 使用 DPAPI 保存的密钥，调用 `extract_wechat_messages`；第 138–141 行缺密钥即拒绝。属于客户端本地数据库读取，不能推得平台授权的收发 API。 |
| 个微持续采集 | 文件变化轮询 | [monitor.py:36](https://github.com/JJ704sd/Chat-Lab/blob/a42137baaed3e05acbf3863a257f43e1cb68e114/src/chatlog_assistant/sources/monitor.py#L36) 默认 600 秒；第 49–53 行变化后导入并休眠。默认时序不适合直接声称秒级回复。 |
| 个微消息完整性 | 以正文提取为主，未保留可靠媒体类型契约 | [wechat_messages.py:220](https://github.com/JJ704sd/Chat-Lab/blob/a42137baaed3e05acbf3863a257f43e1cb68e114/src/chatlog_assistant/sources/wechat_messages.py#L220) 第 225–230 行有文本/中文过滤，第 251 行统一标为 `content_type="text"`。不能认定混合群所有消息类型完整支持。 |
| 本地企微离线/持续读取 | 两条入口俱在 | [wecom_cli.py:39](https://github.com/JJ704sd/Chat-Lab/blob/a42137baaed3e05acbf3863a257f43e1cb68e114/src/chatlog_assistant/sources/wecom_cli.py#L39) 离线入口要求已解密目录；第 58–63 行 watch 默认 60 秒。[wecom_pipeline.py:202](https://github.com/JJ704sd/Chat-Lab/blob/a42137baaed3e05acbf3863a257f43e1cb68e114/src/chatlog_assistant/sources/wecom_pipeline.py#L202) 实时本地入口自动做一致性快照、从 DPAPI 取密钥及解密校验。不能统称为只有手工解密。 |
| LLM 分析 | 存在真实 HTTP 客户端，可选启用 | [wecom_semantic.py:193](https://github.com/JJ704sd/Chat-Lab/blob/a42137baaed3e05acbf3863a257f43e1cb68e114/src/chatlog_assistant/sources/wecom_semantic.py#L193) 请求 `/chat/completions`；默认配置为 MiniMax。第 29–49、85–109 行的任务是分类、结构字段提取、回复质量评估；第 252–281 行使用最多 12 条、4 小时内、同账号同会话上下文。没有工具调用或向群发送的动作。 |
| 自动回复/主动 Agent | 未发现实现 | [wecom-pickup-acceptance.md:5](https://github.com/JJ704sd/Chat-Lab/blob/a42137baaed3e05acbf3863a257f43e1cb68e114/docs/wecom-pickup-acceptance.md#L5) 明确“不实现……消息发送”；[wecom_web.py:432](https://github.com/JJ704sd/Chat-Lab/blob/a42137baaed3e05acbf3863a257f43e1cb68e114/src/chatlog_assistant/sources/wecom_web.py#L432) 第 432–547 行 POST 路由是价格候选、审核、Excel、公司纠正，无群聊发送路由。全源码搜索未命中常见 send_message/send_text/SendMsg/SendText、wechaty/wxauto/wcferry/itchat 或 appchat/send。此为本次检查范围内未发现，非平台整体不存在的断言。 |

## 当前可以复用的部分

统一消息字段与来源标记、SQLite 存储与去重、物流类别和业务字段提取、发言主体识别、问题与已有回复关联、可选 LLM 上下文分析、只读聊天证据页面。个微通道输入后需补齐稳定群 ID／发送者 ID／自身消息识别等契约，才能安全供机器人使用。

本次最小验证仍应独立打通：目标个人微信进入实际混合测试群 → 获取一条新消息及稳定群标识 → LLM 生成一条短回复 → 通过待选通道发回同一个群 → 从另一客户端确认收到。通过后再验证主动触发、自身消息排除及重复事件去重。当前 Chat-Lab 审计没有完成这些实测。

## 证据成熟度

- Java 测试目录仅见映射、主体规则、SQLite 存储、SDK 路径测试，没有找到真实存档服务的端到端测试；本次未运行这些测试。
- [README.md:42](https://github.com/JJ704sd/Chat-Lab/blob/a42137baaed3e05acbf3863a257f43e1cb68e114/README.md#L42) 历史记录称微信 4.1.12.55、企微 5.0.10.6025 的只读内存扫描未通过验证；这是仓库已有记录，并非本次重新检测结果。
- [README.md:201](https://github.com/JJ704sd/Chat-Lab/blob/a42137baaed3e05acbf3863a257f43e1cb68e114/README.md#L201) 明确截图衍生 JSONL 是脱敏演示数据；第 217 行区分真实页面验证与尚未完成的价格业务验收。
- 无法从源代码量或 fixture 条数合理计算“真实／mock 占比”；可以明确区分代码具备 live 分支、夹具支持和缺少当前目标群实测三件事。

## 依赖与许可简记

此项仅记录复用背景，不作为当前最小群机器人测试的扩展任务。`pyproject.toml:5–7` 声明 Python >=3.11、sqlcipher3 0.6.2；`collector-wxjava/pom.xml:10、20–22、42–49` 指定 Spring Boot 3.3.5、Java 17、WxJava 4.8.5-20260818.151216、sqlite-jdbc 3.47.2.0。当前 Git 跟踪文件没有 LICENSE/COPYING/NOTICE，pyproject 未声明项目许可证。

本次在线核对到上游 [WxJava](https://github.com/binarywang/WxJava/blob/develop/LICENSE)、[Spring Boot](https://github.com/spring-projects/spring-boot/blob/main/LICENSE.txt)、[sqlite-jdbc](https://github.com/xerial/sqlite-jdbc/blob/master/LICENSE) 的当前仓库许可为 Apache 2.0；[sqlcipher3](https://github.com/coleifer/sqlcipher3/blob/master/LICENSE) 为 zlib 风格许可。尚未生成针对上述锁定构建产物的完整依赖许可清单；官方企微 SDK 的许可也不能由 WxJava 的许可替代。
