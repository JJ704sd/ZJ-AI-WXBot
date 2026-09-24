# ZJ-AI-WXBot

中技 AI 群聊机器人技术方案评估：探索个人微信账号受邀进入企微与个微混合的外部群，持续分析群消息，并主动回复原群。

## 当前结论

**截至 2026-09-22（实机结论沿用 9 月 21 日），已有局部受控普通文本收发，尚未完成约 300 群定时真实 @ 索价与被 @ 后受控回复的完整业务验收。**

业务首选个微接管，允许调整业务账号，优先保留现有群；批准场景内自动回复，其余交原群业务员。数据库、独立 Qt/UIA、OCR 各有局部证据，不能合并为持续无损输入或原生 @ 通过。最新限定编号草稿来自人工恢复后的证据重放，原自动观察仍为 BLOCKED。新增 wechat2ipad 与 WeChatDataAnalysis 付费候选均未完成目标混合群及规模验收。

仓库保存研究、脱敏阶段证据、默认关闭真实动作的 PoC 与诊断基础。默认离线配置不启动实机操作；历史有界读取、模型调用或调试记录不能当作原群自动回复验收。原始聊天、凭据和运行材料不纳入公开交付。

付费筛选已加入近半年活动与维护支持要求：WeChatAuto.SDK 4.xx VIP 优先询价，WeChatDataAnalysis 有条件保留，WorkTool、聚合智能及 wechat2ipad 保留商业备选并补交付／维护证据。公开标价不等于完整采购总价，现阶段没有已验收生产方案。

## 阅读入口

- [个微收发 v1.20（2026-09-24）](./specs/个微收发_v1.20_紧凑连续版_2026-09-24.md)：供应商能力复核、交付与成本、项目实测状态及下一轮 PoC。

- [个微收发 v1.20 技术评审演讲稿](./specs/个微收发_v1.20_技术评审演讲稿_2026-09-24.md)：约 8 分钟的分享口径、关键词解释与评审结论。
- [个微收发 v1.20 技术评审问题清单](./specs/个微收发_v1.20_技术评审问题清单_2026-09-24.md)：P0 至 R4、采购与生产关口的问题和所需证据。

- [付费方案与维护结论](./specs/paid-options-decision-2026-09-22.md)：最新候选分层、价格口径、维护缺口和采购条件。

- [业务需求与采购验收](./specs/mixed-group-business-requirements-2026-09-21.md)：约 300 群两条业务流程、P0 分工和供应商问题。

- [pyweixin 完整结构与目标标题实测（2026-09-18）](./poc/evidence/pyweixin-title-binding-retry-2026-09-18.md)：147 个结构节点无截断、唯一目标标题匹配、原字节恢复；该回合仍缺账号与原群的独立身份绑定。

- [pyweixin 深层结构实验（2026-09-18）](./poc/evidence/pyweixin-qt-deep-structure-2026-09-18.md)：三个关键控件已定位，后续进入原账号／群的独立绑定验证。

- [pyweixin 一次实机结构恢复实验（2026-09-18）](./poc/evidence/pyweixin-qt-one-shot-2026-09-18.md)：临时根结构恢复与原值读回已验证，不代表消息读取或发送可用。

- [pyweixin 当前账号／原混合群构建（2026-09-18）](./specs/pyweixin-build-2026-09-18.md)：9 月 18 日的路线选择、源码修补与详情身份停点；后续独立文本验证及业务范围以 v1.13 为准。

- [综合技术可行性报告 v1.13](./specs/agent-personal-wechat-mixed-group-feasibility-report-2026-09-16.md)：跨路线结论、商业条件与验收要求；纳入业务需求、局部收发及扩展付费／维护调查。
- [方案进度与卡点台账](./specs/route-progress-blockers-2026-09-21.md)：各路线实测深度、阻塞原因与下一条有效证据。
- [9 月 18 日重大迭代](./specs/research-iteration-review-2026-09-18.md)：临时结构恢复、三个锚点和目标标题通过的证据，以及尚未通过的账号／群身份与消息关卡。
- [重大迭代与最新证据](./specs/research-iteration-review-2026-09-17.md)：Cloud 失败反馈、UIA v2/v3、Hook R1—R3 及样本方向纠正。
- [UIA 历史卡点（9 月 17 日）](./specs/uia-blockers-register-2026-09-17.md)、[861 当前构建交接](./specs/nonmax-861-build-handoff-2026-09-16.md)：各路线阶段入口。历史操作额度不自动延续。

下列 v0.1/v0.2 及第一、二轮研究为历史基线；不能用其中“当前”替代上述最新结论。

2026-09-14 已确认最小 PoC 范围。当时实施契约为 [接入验证 spec v0.2](./specs/personal-wechat-agent-poc-v0.2.md)；原始 Word 审阅稿仅保留在本地，不纳入公开版。[v0.1](./specs/personal-wechat-agent-poc-v0.1.md) 与 [实施提示词 v0.1](./specs/personal-wechat-agent-implementation-prompt-v0.1.md) 保留为固定提交对照。采用独立测试账号、单个企微外部测试群、合成消息与人工逐条确认发送；规范落地不表示实机验证已完成。W0 证据见 [poc/evidence/w0-local-baseline.md](./poc/evidence/w0-local-baseline.md)。W1 离线缺口修复见 [poc/evidence/w1-offline-gaps.md](./poc/evidence/w1-offline-gaps.md)。W2 适配准备见 [poc/evidence/w2-adapter-prep.md](./poc/evidence/w2-adapter-prep.md)。用户指定账号目录探测见 [poc/evidence/r0-authorized-paths.md](./poc/evidence/r0-authorized-paths.md)。目标群 UI 线索见 [poc/evidence/r0-group-clues.md](./poc/evidence/r0-group-clues.md)。可行性研究途径见 [poc/evidence/r0-research-path.md](./poc/evidence/r0-research-path.md)。2026-09-15 实机停点与后续探索授权交接见 [poc/evidence/handoff-2026-09-15.md](./poc/evidence/handoff-2026-09-15.md)。

公开版说明：证据文档中的账号标识、本机路径、群标识、成员姓名与企业名称均已替换为示例值；原始 UI 截图、原始 Word 文档、数据库和运行目录仅保留在本地，不纳入 Git。

| 文档 | 内容 |
|---|---|
| [第二轮：Chat-Lab 技术复用评估](./Chat-Lab技术复用评估_第二轮.md) | 第二轮历史结论、实际机制、读取边界、两种接法与最小验证 |
| [第二轮：个微读取证据](./evidence/round2-wechat-ingest.md) | 分库、WAL、游标、会话与身份映射，以及合成复现 |
| [第二轮：企微读取证据](./evidence/round2-wecom-ingest.md) | 本地快照／解析及官方存档可借鉴之处 |
| [第二轮：分析复用证据](./evidence/round2-analysis-reuse.md) | 新事件、上下文、模型分析和主动回复之间的缺口 |
| [离线边界探针](./verification/verify_wechat_read_assumptions.py) | 对指定参考源码运行合成实验，不读取实际聊天库 |
| [个微 PoC（offline）](./poc/README.md) | 本地 mock/合成实现、审批 CLI 与离线测试；R0 本机探测见 [poc/evidence/r0-machine.md](./poc/evidence/r0-machine.md)，阶段总表见 [poc/evidence/offline-verification.md](./poc/evidence/offline-verification.md) |
| [第一轮：群聊机器人可行性验证](./群聊机器人可行性验证.md) | 初始结论、候选路线、最小实验及通过标准 |
| [第一轮：Chat-Lab 源码审查](./evidence/chatlab-audit.md) | 旧版已有能力、发送缺口及固定提交源码引用 |
| [附件静态审查](./evidence/archive-audit.md) | ZIP 工具用途、互通会话过滤及复用限制 |
| [腾讯官方接口边界](./evidence/official-boundary.md) | Webhook、智能机器人、存档等能力与未核验项 |

## 早期最小验证顺序（历史计划）

1. **R0–R1：读取。** 本机 Weixin 文件版本已重测为 `4.1.13.65`；目标库可读、群定位与连续读取仍待授权账号/群绑定后验证。
2. **R2：发送。** mock 三条 ACK 适配已通过；真实原群双端确认未执行。
3. **R3：AI。** 关联测试上下文，主动输出分析结果，并排除自身消息循环。
4. **R4：持续运行。** 进行 30 分钟观察、窗口切换和断网恢复，记录缺口及异常。

该计划的读取部分后来已有有限实测，详情以 T0–T2 证据及综合报告为准；发送与连续运行仍未通过。任何单轮成功仅限指定账号、客户端与群，不能代替长期稳定性验证。

## 第二轮评估基线（历史）

- 核验日期：**2026-09-12**。客户端兼容性与平台接口后续可能变化。
- 参考项目：[JJ704sd/Chat-Lab](https://github.com/JJ704sd/Chat-Lab)，第二轮审查提交为 [`67bb1f1`](https://github.com/JJ704sd/Chat-Lab/commit/67bb1f1b6a8f5a89ce4cf18f65eaf38688639ab2)；第一轮 [`a42137b`](https://github.com/JJ704sd/Chat-Lab/commit/a42137baaed3e05acbf3863a257f43e1cb68e114) 的记录保留供对照。
- 核验机器上的 Windows 微信版本：**4.1.13.65**。
- 附件仅进行静态审查；仓库保留摘要、SHA-256 和条目定位，不发布附件内容。

平台及工具的来源链接放在对应结论旁。未能读取的官方文档已标注，未将其作为已经验证的依据。
