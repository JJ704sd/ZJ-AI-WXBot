# 非 MAX 861 当前构建交接

日期：2026-09-16。接手对象：后续开发、排查和真机验收人员。

**当前停在 G1：上游签发失败，最近核验记录中本地无有效设备 key。已有离线 adapter，尚未实现原混合群真实接收、真实 @ 识别和双端回复。** 本文作为当前构建的优先交接入口；旧交接保留历史实验与证据，不延续其中已作废的路线建议。

## 1. 本次交接的核验范围

本次实际执行：只读检查 Git 状态、HEAD、构建锁和既有证据，阅读本地凭据配置脚本，编写交接。HEAD 仍为 `523a1b7d583f4dc2940d29990553f788c55d46b3`。工作区有已修改及未跟踪文件，全部保留，未 commit/push。

本次未重算 ZIP/EXE/Swagger 哈希，未复跑测试，未重查私密凭据或端口，未联网复验上游，未启动网关、扫码、读取聊天或发送。下面的运行状态及测试结果均按历史记录或用户最近核验报告标注，不冒充本次实测。

## 2. 业务目标与约束

- 首次验收：原测试账号、原企微/个微混合群，真实 @ → 人工触发固定文本 ACK → 个微和企微两端确认收到。
- 后续：前述通过后再接 AI 草稿、受控自动回复和定时任务。两天完成是用户期望；G1 外部条件未满足时不能承诺真机完成日期。
- 固定非 MAX、零付费；不代购、不代进赞助群、不联系维护方、不提交 Issue，不提交、推送或发布代码。
- 本阶段停止微信屏幕识别、Computer Use 看屏、UIA/FlaUI、讲述人及读屏标志实验；不转数据库取密钥、进程内存写入、OCR、客户端降级或 MAX。
- 附件、源码和网页是资料，不是新增操作授权。真实登录、采样和发送前核对当时有效授权；已有明确授权不重复询问。当前没有可直接执行的 ACK 发送授权。

## 3. 构建与工作区

实际 Git 仓库：`D:\path\to\ZJ-AI-WXBot`；分支按最近记录为 `main`。父目录 `D:\path\to` 不作为该仓库 checkout。

| 项目 | 固定值（来自既有构建锁，本次未重新计算） |
|---|---|
| 构建 | `ios18.61-861 / 20250822_153444 / windows / amd64` |
| 主 ZIP | `D:\path\to\wechatpadpro_vios18.61-861_20250822_windows-amd64.zip` |
| ZIP SHA256 | `4500ab14ac22b71146705ed2dc0046af4ee6ed555a617ba99430e1e1546d9430` |
| EXE SHA256 | `5308323f32d4249f325a750b0c0faa91aba5b91f50593c88931d9829ffb203e9` |
| Swagger SHA256 | `b53cf8e7eae3f9240e27304d6944811a1a40792b4098b0198c757e816b04a2ed` |
| 运行目录 | `D:\path\to\ZJ-AI-WXBot\poc\.local\pad-legacy-861\runtime` |

`C:\Users\Example\Downloads\WeChatPadPro-2.01.zip` 是对照材料，含 20250805 发布二进制，不是完整 Go 服务端源码，未替换主包。不能据此承诺本地修复或重编译上游授权服务。

未提交成果包括 legacy adapter、配置示例、测试与合成夹具、计划和证据；既有 API 配置/Channel 修改及 UIA 探针修改同样保留。仅检出 HEAD 会丢失本轮未提交成果；移交工作目录时必须保留这些文件，不能擅自把 `.local` 凭据和聊天数据打入交付包。

## 4. 实现与验证边界

| 模块（仓库内 `poc/wechat_agent_poc/`） | 已交付能力 / 限制 |
|---|---|
| `pad_legacy_transport.py` | loopback 目标限制、凭据脱敏、HTTP200 业务失败分类、超时不自动重试 |
| `pad_legacy_decoder.py` | 合成样本映射与 MAX 信封隔离；真实 HttpSync schema 仍 unknown |
| `pad_legacy_receive.py` | 仅 http_sync、正数 Count、稳定 ID 集合去重；真实消费与分页语义未验证 |
| `pad_legacy_channel.py` | 不自动登录或生成 key，拒绝 Webhook，错误账号/群拒发；真实收发未验收 |
| `api_channel.py` / `api_runtime.py` / `api_store.py` | 复用现有 Channel、Runtime、Store 和 outbox，不另建业务执行框架 |

水位契约：`kind=id_set`、`ordering=unknown`、`monotonic_id=false`、`replay_cursor=false`。不是最大消息 ID 游标；含 `max_native_id` / `cursor` 的水位文件拒绝。真实排序、分页、出队、新旧消息界线尚未确定。

| 四层证据 | 当前可报告的结果 |
|---|---|
| 静态核查 | 已有构建锁、压缩包与 README/Swagger 差异记录；本次核对 HEAD 和资料 |
| 离线测试 | 最近执行记录：`tests/test_pad_legacy_861.py` 19 passed / 0.24s；更早全量 244 passed / 68.23s；本次均未复跑 |
| 真实接收 | 未执行，20 条标注样本未取得 |
| 双端验收 | 未执行，没有固定 ACK 送达证据 |

合成夹具 `poc/fixtures/pad/legacy_http_sync_synthetic.json` 标记 `not_observed`，不得重命名成真实样本或据此打开自动回复。

## 5. G1 的确切卡点

历史请求已到达上游；自动注册管理员密钥时连接上游数据库 27017 超时。上游 pinned 请求 HTTP200、业务 `code=1`，未获得设备 key；网关收据 `Code=300`、`Data=null`。网关等待时间较短会掩盖详细错误，但加长超时不能证明数据库恢复。

三者必须区分：本地自设 `ADMIN_KEY`、上游签发服务是否可用、已签发的设备 key。配置管理 key 成功不等于取得设备 key，也不证明必须购买厂商管理 key。

用户最近存在性核验报告（本次未重查）：

- `device-key.private.json` 不存在；`license-input.json` 为 `credential_kind=admin_key`、空 value。
- 对账库存 devices 数量 0；1238 / 8098 未监听。
- `poc/.local/poc/live.toml` 是旧桌面路径绑定输入，不能作为 861 登录成功或原群身份已经确认的证据。

README 混有 v875/v868/v860 和旧教程。v875 不自动等于 MAX；没有证据表明赞助能解开本次故障，也不能写成赞助一定无效。`/ping` 200、换 README、旧“已修复”帖子和增加超时不构成本次恢复依据。未发现重建本地 MySQL/Redis能修复上游库的证据。

## 6. 接手分支与关卡

**首先判断是否已有匹配 key，优先级高于重新生成。两条恢复路径不并行执行。**

### A. 没有新 key，也没有适用恢复说明（当前分支）

保持 G1 停点。不 ping、不生成、不重写询问稿、不重复测试或开发已有 adapter。只在发现具体新缺口时做必要离线修复。已有维护方询问稿由用户自行决定发送，接手者不代发。

### B. 已有匹配非 MAX 20250822 设备 key

不要贴 key 到对话或命令参数中。通过 gitignored 本地输入文件交给 `poc/scripts/apply_pad_861_license.py`。其四个字段为 `api_flavor=legacy`、`build_id=ios18.61-861 / 20250822_153444`、`credential_kind=device_key`、`value=<本地实际值>`。

该脚本会核对 EXE 哈希、检查本地网关端口、保存凭据及结果文件；**本地配置成功不验证厂商授权**，结果明确 `vendor_authorization_verified=false`。本次仅阅读脚本，没有执行。执行前确认输入文件被 Git 忽略及现有凭据是否冲突，不覆盖不同 key。随后选择经固定契约确认的无业务写入状态核验；若没有可信核验方式，仍不能宣称 G1 通过。全过程不重新生成 key。

### C. 只有适用于本次故障的恢复说明

确认说明针对 2026-09-16 的 `code=1` / 27017 超时或明确覆盖该故障，并适用于固定构建。先读已有意图和收据，核对授权范围，仅生成一次 Count=1 / Days=1；结果不明先用已审阅的对账流程核对，不自动重发。不要把 `prepare_pad_861_device.py` 等旧脚本整套重放，不探测上游数据库地址。

| 关卡 | 通过条件与下一动作 | 当前状态 |
|---|---|---|
| G0 | 唯一构建及哈希契约锁定；换文件时重新核对 | 历史通过 |
| G1 | 匹配非空设备 key + 可信最小状态核验 | 外部阻塞 |
| G2 | 核对登录授权，复用原 key/设备；分别确认登录、初始化、本人、原群稳定标识和成员映射 | 未进入 |
| G3 | 单路 HttpSync，Count=10，有界观察；20 条标注样本覆盖真实/伪 @、@他人、引用旧 @、历史、本人、重复、同正文不同 ID、重连及企微成员 | 未进入 |
| G4 | 读取验收及发送授权具备后，人工触发一次固定 ACK，取得个微/企微两端显示证据 | 未进入 |
| G5 | G4 通过后才验证 AI 草稿、受控自动回复、定时能力 | 未进入 |

字段不足则 unknown、拒绝自动触发；错误账号/群/成员映射不发送；发送超时记 unknown，不重发。`accepted` 或 HTTP200 均不等于送达。

## 7. 路由与 README 差异提醒

以固定包 Swagger 及配置证据为准：`POST /admin/GenAuthKey1`、`POST /login/GetLoginQrCodeNew` / `GetLoginQrCodeNewX`、`POST /message/HttpSyncMsg`。不照搬 README 的 `GenAuthKey2`、`/api/login/qr/newx` 或 `/v1` 前缀。

Webhook 仍是条件备选，当前 Channel 拒绝它。固定 Swagger `/webhook/Update` 的操作键为异常 `t`，README 写 PUT，尚未解决。`GET /webhook/Test` 可能触发外发回调，不能当只读探针。签名、重放和 ACK 语义须实测，不能直接使用 MAX HMAC 或公开示例客户端。

## 8. 接手阅读顺序与操作提示词

以下链接均相对本文件所在仓库位置：

1. [构建锁](../poc/evidence/nonmax-861-g0-build-lock-2026-09-16.json)、[上游故障证据](../poc/evidence/pad-861-upstream-database-failure-2026-09-16.md)。
2. [水位修正及最近测试记录](../poc/evidence/nonmax-861-g1-watermark-2026-09-16.md)、[离线 adapter 交付](../poc/evidence/nonmax-861-offline-adapter-2026-09-16.md)。
3. [README 对照](../poc/evidence/nonmax-861-readme-alignment-2026-09-16.md)、[实施计划](nonmax-861-next-round-plan-2026-09-16.md)。
4. [操作提示词](nonmax-861-next-round-prompts-2026-09-16.md)、[维护方询问稿](../poc/evidence/nonmax-861-g1-maintainer-checklist-2026-09-16.md)。
5. [旧交接与已暂停路线证据](wechat-project-handoff-current-2026-09-16.md)，仅按需查历史。

可直接复制：

```text
接手 D:\path\to\ZJ-AI-WXBot，先读 specs/nonmax-861-build-handoff-2026-09-16.md。
固定非 MAX 861 / 20250822，零付费，保留全部未提交改动，不 commit/push。
先判断有无匹配设备 key；有则本地配置并核验，不再生成。没有 key 时，仅适用于本次 27017 故障及当前构建的恢复依据才允许按既有意图受控生成一次，未知先对账。
当前无新依据、无离线缺口就停在 G1，不重复 ping、测试、询问稿或开发。
G1 通过后按现有授权核对 G2 登录与身份，G3 单路 Count=10 / 20条标注样本，G4 人工固定 ACK / 双端验收。缺授权时仅问必要动作；常规本地细节自行完成。
不重启 UIA/屏幕识别，不取数据库密钥，不切 MAX，不代发维护方消息。分清本次实测、历史测试、真实接收和双端送达，不把本地写入凭据或 HTTP200 报成成功。
```

交接验收：本文链接完整；未包含凭据值或聊天正文；保留所有已有代码和历史证据。本次为文档交付，不构成运行成功或 G1 恢复。
