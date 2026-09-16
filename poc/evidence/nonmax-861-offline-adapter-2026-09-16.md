# 非 MAX 861 本轮离线交付（G0/G1 + adapter）

日期：2026-09-16。执行范围：锁定 20250822 构建、对账已有授权收据、实现可复用 legacy adapter 与离线边界测试。未启动网关、未生成授权、未扫码、未读真实消息、未发送。

## 证据分层

| 层 | 本轮状态 |
|---|---|
| 静态推断 | 20250822 为唯一基线；20250805 附件更旧且无 Go 核心源码；HttpSync/Send 请求模型与附件一致，响应 schema 仍缺失 |
| 离线测试 | 新增 adapter 用例通过；全量 poc 回归 **244 passed / 68.23s** |
| 真实接收 | **未执行。** 无有效设备 key，未拉 HttpSync |
| 双端验收 | **未执行。** 未发送固定 ACK |

## G0 构建锁

机器可读：[G0 哈希](nonmax-861-g0-build-lock-2026-09-16.json)。Git：`main` HEAD `523a1b7d583f4dc2940d29990553f788c55d46b3`，未 commit/push。先前 UIA/交接未提交改动保留。

| 对象 | SHA256 | 判定 |
|---|---|---|
| 20250822 zip | `4500ab14ac22b71146705ed2dc0046af4ee6ed555a617ba99430e1e1546d9430` | 与既有 Windows 声明及本地安装一致 |
| 20250822 exe | `5308323f32d4249f325a750b0c0faa91aba5b91f50593c88931d9829ffb203e9` | 与 `prepare_pad_861` EXPECTED 一致 |
| 20250822 swagger.json | `b53cf8e7eae3f9240e27304d6944811a1a40792b4098b0198c757e816b04a2ed` | 与合同审计一致 |
| WeChatPadPro-2.01.zip | `e490ac6bfe944477846ad0d019bd5225214091b4fbe33987d8ca396c7eed6a6a` | 仅对照；内嵌 20250805，未解压覆盖、未试运行 |

管理 key 与设备 key 分离：本轮未读取或输出管理 key；设备 key **不存在**。未混用 MAX `/Login` `/Msg` / HMAC。`pad_cli` 仍为 P1 离线观察器。

1238/8098 当前无监听。

## G1 授权对账（未复验外发）

新附件不构成上游恢复证据：授权路由与 `GenAuthKeyModel` 与 20250822 相同；没有上游数据库已修复的说明；`/ping` 200 与更旧构建不能当作修复。

本地意图/收据仍在，禁止盲着重放：

| 收据 | 业务码 | 设备 key |
|---|---|---|
| `auth-pinned-trial-result.json` | 网关 Code=300；上游 HTTP200 且业务失败 | 无 |
| `device-pinned-trial-private.json` | Code=300，Data=null | 无 |
| 更早 creation/transport 私密收据 | Code=300，Data=null | 无 |

已知上游失败（脱敏）：自动注册管理员密钥时数据库 27017 超时。HTTP200 不是成功。未延长超时、未探测披露的数据库地址、未联系厂商。

**外部阻塞仍然成立。** 下一次有界复验需要与上次不同的依据（有效授权、明确上游修复、或匹配非 MAX 构建的相关修复说明）。没有这些依据不得再 POST `/admin/GenAuthKey1`。

离线验证覆盖：HTTP200 + `code=1` + 无 key → `business_error`；网关 Code=300 → 非签发；超时 → `timeout` 且不重试；未知信封不标成功。

## 契约表（请求已锁定，回调未观察）

| 路径 | 20250822 | 20250805 附件 | 本轮实现 | unknown |
|---|---|---|---|---|
| `POST /admin/GenAuthKey1` | Count/Days/Remark | 相同 | 只对账，不外发 | 上游库何时恢复 |
| `POST /message/HttpSyncMsg` | body `Count`；空 body 默认同步全部 | 相同 | 强制正数 Count；单路 http_sync | **响应 item schema** |
| `POST /message/SendTextMessage` | `MsgItem`: ToUserName/TextContent/MsgType/AtWxIDList | 相同 | 离线 submit；超时 unknown 不重试 | 响应是否含消息 ID；原生 @ 是否生效 |
| `GET /login/GetLoginStatus` | query `key` | 相同 | probe 调用但不把 Code=200 当 online | 在线字段 |
| `POST /group/GetChatRoomInfo` | `ChatRoomWxIdList` | 相同 | 调用但不解析 Data | 群/成员响应 |
| Webhook | 20250822 有 Config/Status/Update | 附件改为 connection/heartbeat 等 | **未启用**；示例 HMAC 未当契约 | 真机签名公式 |
| WS `/ws/GetSyncMsg` | 存在 | 存在 | 拒绝与 HTTP 同时启用 | 消费语义 |

合成样本：`poc/fixtures/pad/legacy_http_sync_synthetic.json`，`kind=synthetic` / `not_observed=true`。MAX v1 `Wxid/Data.messages` 在 legacy decoder 中隔离。不得把合成字段写成厂商回调。

## 代码

复用 `api_channel.py` / `api_runtime.py` / `api_store.py`。新增：

- `poc/wechat_agent_poc/pad_legacy_transport.py`
- `poc/wechat_agent_poc/pad_legacy_decoder.py`
- `poc/wechat_agent_poc/pad_legacy_receive.py`
- `poc/wechat_agent_poc/pad_legacy_channel.py`
- `poc/config.api.legacy861.example.toml`（默认 offline，live 关闭）

默认只选 `http_sync`。Webhook 回调直接 401 `callback_channel_not_selected`。非 loopback 拒绝。缺设备 key 拒发。错误账号/群拒发。历史/伪 @ / 缺字段 → unknown，禁止自动触发。

## 测试命令与结果

```powershell
cd D:\path\to\ZJ-AI-WXBot\poc
.\.venv\Scripts\python.exe -m pytest tests\test_pad_legacy_861.py tests\test_api_config.py tests\test_api_a1.py tests\test_gewe_channel.py tests\test_pad_p1.py tests\test_pad_check_reporting.py tests\test_pad_auth_relay.py -o addopts= -q -p no:cacheprovider
# 77 passed

.\.venv\Scripts\python.exe -m pytest -o addopts= -q -p no:cacheprovider --basetemp=runtime/pytest-legacy861
# 244 passed in 68.23s
```

未沿用历史 205/204 passed。未为使测试通过改成功标志或伪造 key。

## 关卡

| 关卡 | 状态 | 剩余阻塞 |
|---|---|---|
| G0 | **通过（静态）** | 无 |
| G1 | **外部阻塞** | 上游授权库或匹配有效设备 key |
| G2 | 未执行 | G1；登录/扫码需单独核对授权。本地 `live.toml` 存在，本轮未展开标识 |
| G3 | 离线骨架完成；真实 20 条样本 **未开始** | 有效 key、单路 HttpSync、标注样本 |
| G4 | 未执行 | 发送授权 + 双端确认；HTTP200/accepted ≠ 送达 |
| G5 | 不做 | 等 G4 |

## 下一次可执行动作（需新证据或明确授权）

1. 出现与 2026-09-16 上游库超时不同的恢复依据后，Count=1/Days=1 只生成一次；未知结果先对账。
2. 取得非空设备 key 后核验登录与原群绑定（读本地旧绑定，不重复向用户要已有信息，不输出凭据）。
3. 仅 HttpSync、显式 Count=10，收集 20 条标注样本后再谈自动触发。
4. 固定 ACK 人工触发一次，超时 unknown 不重发，必须个微/企微双端证据。

当前不能把离线 adapter 写成已运行的原群机器人。
