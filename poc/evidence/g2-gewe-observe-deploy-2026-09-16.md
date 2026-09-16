# G2 GeWe 只读观察器部署清单

日期：2026-09-16。G1 本地实现已完成；**本清单不是批准采购、注册、开放公网或扫码。** 没有主机或 Token 不妨碍 G1，也未启动 G3。

## 待选主机（未选定）

| 选项 | 用途 | 已知约束 | 本轮状态 |
|---|---|---|---|
| 当前开发机 `127.0.0.1` | G1 合成数据与本地 HTTP 集成 | 无公网 TLS，不能接 GeWe SaaS 回调 | 已用于 G1 |
| 用户自有 Windows 受控主机 | TLS 入口 + 观察器 + `observe.sqlite` 同机 | 需固定主机名、可安装 Python 3.11+、磁盘 ACL | **未指定主机名/IP** |
| 云主机 / 容器 | 同上拓扑 | 费用、出口 IP、是否允许入站 443 均 unknown | 未采购 |
| 临时隧道 | 把 loopback 暴露到公网 | 不是认证替代品；可能超过 3 秒应答；日志易泄漏路径 secret | **不推荐为 G3 认证** |

正式拓扑：HTTPS 入口、观察器、SQLite 放同一台受控主机。本方案未选定或采购主机。

## TLS / 域名

- HTTPS 覆盖外部客户端到入口；入口到应用是同机 loopback HTTP。不是“HTTPS 全程”。跨主机转发需要另行设计 TLS 和双方认证。
- 需要：域名或主机证书、反代（仅转发 `POST /callbacks/gewe/<secret>`）、关闭该路由的 URL/正文访问日志。
- 管理路由（status/export/stop）不得对公网开放。
- 文档示例 `http://api.geweapi.com` **不能**携带 Token。只读 API 根必须是厂商确认的 `https://`。

## 认证模式

| 模式 | G1 实现 | G3 是否可用 |
|---|---|---|
| `none` | 仅离线合成 | 否 |
| `callback_bearer` | 路径 secret + 内部 bridge | 仅有界只读采样；来源等级不得升为 vendor_verified |
| `vendor_signature` | 配置即拒绝 | 否，缺完整协议 |
| `vendor_mtls_or_private` | 配置即拒绝 | 否，缺核验 |

路径 secret 与内部 bridge token 必须是两组 ≥32 字节随机值，且与 `X-GEWE-TOKEN` 分离。路径 secret 泄露即停止并轮换。

## 费用（unknown，待询证）

- GeWe 7 天试用 Token：文档有声明，本项目未注册，价格与混合外部群是否允许 **unknown**。
- 私有化镜像/许可证：**unknown**。
- 域名证书、云主机带宽：取决于用户选定主机，本轮未报价。

## 数据路径

- 观察库：`poc/.local/gewe-observe/observe.sqlite`（`PRAGMA user_version=1`，WAL，`synchronous=FULL`）
- 禁止：`poc/.local/api-agent/state.sqlite`、旧 PoC 状态库
- 样本默认剔除电话/头像 URL；受限原始 JSON 仅本地、不进 Git、不上传模型
- 7 天到期列为清理项，不创建自动删除任务

## 供应商待答（供用户发送，本轮未联系）

1. Webhook 是否有签名字段、算法、原始字节、时间戳/重放规则及密钥交付方式？
2. 是否支持自定义回调 path secret 或自定义认证 header？验证请求的准确 JSON？
3. 是否提供固定出口 IP 或 mTLS？
4. 生产 API 根的准确 `https://` 地址？`http://api.geweapi.com` 是否禁止携带正式 Token？
5. 私有化是否可纯内网回调（不必公网 URL）？
6. 混合群 `toUser`/`fromUser` 是否出现 `@openim` 作为群键？文字回调的结构化 @ 字段名与样例？
7. 历史同步是否有独立标志？`newMsgId` 是否可能超过 2^53，JSON 是否按字符串输出？
8. 试用/报价是否允许本测试账号的企微/个微混合群？

## G3 启动前验收（尚未执行）

- [ ] TLS 证书有效，仅回调路由对公网
- [ ] 应用监听 loopback，管理命令只走本机 CLI
- [ ] 伪造内部头不能通过入口；路径 secret 不出现在日志
- [ ] 只读 API 根 HTTPS；`allow_live_send=false`；无 Agent/M3
- [ ] 账号/群键已用只读元数据映射
- [ ] 操作人完成扫码；30 分钟授权编号已写入 `authorization_ref`
