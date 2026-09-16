# 非 MAX 861：按新 README 调整实施路径

日期：2026-09-16。范围：附件阅读、固定 ZIP 内 Swagger 静态核对、计划和提示词调整。未执行网关、授权、登录、收发或外联；本文不代表上游现时可用性复测。

## 来源与适用性

用户附件：`C:\Users\Example\Downloads\pasted-text.txt`。
SHA256：`fdbefdbf6f8b349e7db40592791176d3f7d40db5bf1a1cd9ae63176d0ead434a`。

附件标题称 v875 在赞助群获取，徽标仍写 v868，下载表和“最新稳定”段落写 v860 / 20250704，另含旧启动教程。因此把它作为功能线索，不作为固定 20250822 可直接运行的操作手册。未访问其外链验证最新状态。

版本号、发行日期、MAX/非 MAX 是三个独立维度。不能凭 v875 字样认定它是 MAX，也不能认定赞助能解决 861 上游数据库故障。维持零付费、非 MAX 861 基线；v875 仅记为未取得、未核验候选，不加入当前两天交付的前置任务。

## 调整决定

| README 线索 | 本项目措施 | 证据边界 |
|---|---|---|
| ADMIN_KEY 自设；旧教程 GenAuthKey2 | 保留自设管理 key → GenAuthKey1 → 上游签发设备 key 的路径 | 管理 key 不等于设备 key；旧教程不是备用签发入口 |
| 同账号复用原 key，一 key 一账号 | G2 先核对旧绑定和匹配 key；已有 key 不再生成，不换 key 排查掉线 | 本地文件存在不等于 key 有效 |
| 登录状态、初始化状态、验证码流程 | 分别验证登录与初始化，再做本人/群绑定；需要验证时保留状态交给用户完成 | 不循环扫码，不猜验证码路由，不把二维码生成当登录成功 |
| 固定设备网络、同城 Socks5 | 首轮沿用本机稳定网络和原设备资料 | 仅在出现对应登录问题且代理来源、授权明确时另评估；不自动买代理 |
| Webhook 重试、批量、历史缓存 | HTTP 仍是第一条接收通道；Webhook 仅作后续有证据的备选 | README 的一小时缓存、批次20、15秒同步是历史描述，不是 861 实测契约 |
| Webhook 示例和配置接口 | 增加静态路由差异记录；未来先验证签名、重放和 ACK 语义再实现 | 不直接运行示例；当前 legacy Channel 仍拒绝 Webhook |
| Docker、MySQL 初始化、默认密码、owner 管理命令 | 不重装现有依赖、不初始化库、不复制演示凭据、不启用 owner 命令 | 当前历史失败是上游 27017 超时，未发现本地重建能修复它的依据 |
| 赞助群、论坛和支持渠道 | 仅作为用户自行联系的线索，继续使用已有维护方询问稿 | 本轮不代发；不以赞助宣传代替同构建恢复答复 |

## 本轮固定包 Swagger 核对

直接只读打开 `wechatpadpro_vios18.61-861_20250822_windows-amd64.zip` 内的 `swagger.json`，未解压执行。

| 用途 | 固定包中的路径 / 方法 | 与 README 的差异或限制 |
|---|---|---|
| 生成设备 key | `POST /admin/GenAuthKey1` | 未见 `/login/GenAuthKey2`；不能照旧示例调用 |
| 二维码 | `POST /login/GetLoginQrCodeNew`、`POST /login/GetLoginQrCodeNewX` 等 | 不直接用 README `/api/login/qr/newx`；具体模型、设备参数仍按固定包核对 |
| 登录核验 | `GET /login/CheckLoginStatus`、`GET /login/GetLoginStatus` | 按参数用途分别核验扫码与账号状态，不混用 uuid / device key |
| 初始化核验 | `GET /login/GetInItStatus` | 与在线状态分开判定 |
| 验证码 | 本轮路径筛选见 `POST /login/YPayVerificationcode` | 名称不能证明可替代 README 的 AutoVerificationcode / verify/auto / verify/manual，禁止猜测映射 |
| 接收 | `POST /message/HttpSyncMsg` | Count=10；真实返回、消费、排序和分页仍 unknown |
| Webhook | `/webhook/Config` POST；List / Status / Test GET | 不直接拼 `/v1`；Test 即使 GET 也可能外发回调，不当只读健康检查 |
| Webhook 更新 | `/webhook/Update` 的操作键是异常的 `t` | 与 README PUT 冲突；标 unknown，不生成调用或直接“修正”为 PUT |

表中是 Swagger 原始路径，不是已运行的完整 URL；实际前缀要结合固定构建的配置/路由证据确认。方法和路径存在也不等于真实功能已验证。

## 当前进度与恢复条件

沿用最近已记录结果：G0 锁定；离线 legacy adapter 已有；G1 未通过；G2–G5 未完成。本轮未重跑历史测试或查验私密凭据目录。此次 README 没有提供设备 key、对应 27017 故障的恢复说明或独立可用签发入口，不能据此重放生成。

已有匹配有效 key 时先做最小核验，不再生成；只有相关恢复依据时才按既有意图/收据控制生成一次 Count=1 / Days=1，未知先对账。通过后顺序为旧绑定核对 → 登录和初始化状态 → 单路 HttpSync Count=10 → 20 条标注样本 → 人工固定 ACK → 双端确认。

接收去重继续使用 `kind=id_set`、`ordering=unknown`、`monotonic_id=false`，`replay_cursor=false`。不要把消息 ID 当递增游标。离线已覆盖行为不重复开发；授权无变化且没有新的离线缺口时如实结束，不制造无效工作。
