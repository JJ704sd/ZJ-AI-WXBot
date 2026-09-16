# 零付费、两天内真机演示：候选核查

已确认决策：优先原测试号和原企微/个微混合群，允许调整API实现；首关为真实@、人工触发固定回复、双端送达；之后才AI回复及定时对话。零付费，不注册、采购、上传账号数据或对外发帖。用户随后已允许本地RPA/API只读可行性预检，不包含安装、降级、部署或发消息。

核查日期2026-09-16，期望目标窗口到2026-09-18，不是交付保证。以下是公开一手资料核查，无新网关安装或真实登录。

| 候选 | 当前一手证据 | 决策 |
|---|---|---|
| 现有WeChatPadPro861 | 本地实测上游注册管理员密钥时数据库连接超时，无设备key | 保留环境，不能作为唯一两日路线；不重复无变化生成 |
| Gewechat原项目 | 当前README明确停止维护，不再提供服务、镜像、技术支持，仓库不含完整服务端 | 排除其旧免费部署教程；第三方同名商业服务另算 |
| wechat2ipad/wechat-ipad-protocol | 页面同时宣传免费接口地址及收费租用/源码交付 | 免费地址不等于免费运行资格；不能纳入已确认零付费方案 |
| WeChatFerry | 官方仓库归档；文档适配3.9.12.51 | 不直接适配现有4.1环境，不擅自降级或注入；不列为两日确定路线 |
| Tencent/openclaw-weixin | 官方插件源码capabilities.chatTypes仅direct，文档明确group_id字段不保证群功能 | 可研究私聊，但不能替代原混合群演示；未安装 |
| 本地RPA API包装 | WeChatAuto社区版依赖UI Tree/OCR，公开远程示例为WebSocket；YoBot需要激活码 | 已允许只读预检；本机4.1.13.65的窗口读取被工具应用权限阻断，尚未证明可用。详见预检记录 |

## 来源

- https://raw.githubusercontent.com/Devo919/Gewechat/main/README.md
- https://github.com/wechat2ipad/wechat-ipad-protocol
- https://github.com/lich0821/WeChatFerry
- https://raw.githubusercontent.com/Tencent/openclaw-weixin/main/src/channel.ts （capabilities约216–220行）
- https://github.com/Tencent/openclaw-weixin/blob/main/docs/protocol_zh_CN.md
- https://github.com/scottfly189/WeChatAuto.SDK
- https://github.com/LeoMusk/wechat-rpa-bot-skill

## 当前结论和下一决策

已核查候选中，尚无同时满足零费用、原混合群、当前客户端、无需等待外部开通且两天可验证的协议API方案。不是证明所有免费方案均不存在；不能为了推进而把收费、停服或仅私聊方案写成可用。

本地RPA/API只读预检已启动，公开资料和标题识别源码已核查，现场窗口读取尚受工具权限阻断。优先候选为WeChatAuto社区版，必须先证明本机能够可靠识别会话，再考虑接入。详见 [预检记录](../poc/evidence/rpa-zero-cost-preflight-2026-09-16.md)。原混合群目标不变，无法可靠承诺两日。
