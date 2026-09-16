# Windows 861 授权健康检查网络诊断

> 最新请求核验纠正：见 [请求检查验证](pad-861-request-verification-2026-09-16.md)。下文4秒为配置参数而非实测总耗时；旧日志无法区分连接、响应头或响应体超时。502/409为本地转发响应，不能归因于厂商拒绝。历史记录保留，以最新核验解释为准。

日期：2026-09-16。固定 EXE SHA256：`5308323f32d4249f325a750b0c0faa91aba5b91f50593c88931d9829ffb203e9`。

## 结论

该构建的授权客户端没有使用进程的 HTTP_PROXY/HTTPS_PROXY。独立工具经代理访问正常，不能证明网关授权请求也走代理。此前一次生成失败尚不能归因于缺少付费授权或服务停止。

只转发真实上游 `/ping` 的本地通道已得到两次 HTTP200；这验证健康接口网络路径，不是设备 key 生成或登录验收。没有再次调用生成接口。

## 静态与动态证据

使用本机 objdump 只读查看固定 EXE 的函数，不修改二进制、不提取签名密钥。

- `initAdminKeyClient` 读取 `ADMIN_KEY_SERVICE_URL`，默认 `https://adminkeyservice.knowhub.cloud`，创建自有 Transport；查看的初始化代码未设置 ProxyFromEnvironment。
- `checkHealth` 请求 GET `/ping`；健康循环立即检查，再按30秒周期检查。客户端不是仅靠等待启动延迟就可恢复。
- `GenAuthKey1` 和 `StoreAuthKeyWithAdminKey` 都检查健康状态。因此此前泛化失败可能发生在提交凭据前；不能声称 ADMIN_KEY 确实已到达上游。

`scripts/probe_pad_861_proxy.py` 的负面对照均只返回503：

| 子进程配置 | 观测 |
|---|---|
| 服务地址为 loopback 监听器 | 收到两次直接 `/ping` |
| 服务地址为保留的 `.invalid` 域名，环境代理指向同一监听器 | 未收到经代理的 `/ping` |
| 两组的其它启动请求 | 监听器收到 absolute-form GET，说明其它客户端使用了环境代理 |

调用本地只读 GetAllDevices 以触发延迟初始化，返回Code200。此结果不代表上游授权成功。

## 真实健康转发复验

`python scripts/probe_pad_861_proxy.py --relay-health` 在网关双向Block均启用时运行。只有精确 GET `/ping` 转发到固定厂商 HTTPS `/ping`，经现有127.0.0.1:17891代理，保留TLS验证、拒绝重定向；其它路径和POST均503，不转发来访请求头或凭据。

复验退出0，两次上游状态均200，响应体SHA256均为 `535e0f7e4562372c2262737b55d250b8a0fc4d3ed4237fc0b23a73b062ad645c`。一次客户端在响应阶段断开，单独记录，不能据此声称完整响应体已被网关消费。探针修复了并发请求记录关联，并处理客户端断开，不伪造成功状态。

收尾：1238/8098无剩余监听，配置摘要未变化；generation_calls=0、qr_calls=0、message_calls=0、successful_authorization_responses=0。Python编译检查通过。本轮未重跑Agent全量回归。

原始结构化结果仅在gitignored `.local/pad-legacy-861/proxy-control-result.json` 与 `proxy-health-relay-result.json`。原始网关日志可能含凭据，不对外分享。

## 后续边界

### 后续已执行：固定目的地授权传输

用户继续后，新增 `scripts/pad_861_auth_relay.py` 和 `scripts/test_pad_861_auth_transport.py`，按此前对固定厂商目的地的凭据外发授权执行一次验证。固定EXE的 `StoreAuthKeyWithAdminKey` 在0xd36604引用28字节路径 `/api/v1/public/auth/generate`；程序通过JSON POST提交，本地转发不改请求体、不提取或重算签名。

转发仅接受 GET `/ping` 与 POST 上述精确路径；固定HTTPS主机、默认TLS证书验证、拒绝重定向、请求响应上限256KiB、4秒上游超时。只有一次POST可外发；重复请求409。监听loopback，日志只记录路径类别、状态与异常类型，不记录凭据/请求体。试验前后校验双向Block匹配固定EXE，完全不修改防火墙；网关有30秒终止计时器和finally清理。独立持久意图保留此前试验收据，重复启动会拒绝。

实测结果（原始脱敏报告：gitignored `auth-transport-result.json`）：

- 两次真实上游健康检查HTTP200。
- 首次生成POST在4秒上游等待内触发 `TimeoutError`，转发返回502；未收到上游HTTP状态。不能据此断言厂商未生成设备key，也不能归因于无授权或服务停用。
- 网关自身又发起一次POST，转发以409拦截，没有第二次外发。
- 本地GenAuthKey1返回HTTP200、业务Code300、Data=null，没有向调用方交付设备key。首次请求的**上游结果未知**，不得自动重试或将其当作明确未提交。
- 收尾 `gateway_stopped=true`、`remaining_listeners=[]`、`config_unchanged=true`、`both_firewall_blocks_verified=true`；二维码和消息调用均0。

新增HTTP边界测试验证401原样返回、非法路径拒绝、重复生成阻断、超时后的重试阻断与异常信息不泄露。最终相关测试33项通过，退出0；首次组合回归曾在pytest临时目录清理时遇到权限错误，改用本工作区独立临时目录后复验成功。未重跑Agent全量回归。报告脚本补充unknown分类后只做本地回归，没有再执行真实生成。

当前待解决的是首次生成的上游处理状态与响应延迟，需要可核对的服务端收据/维护者证据；没有这些证据，不能通过增加重试次数继续生成。先前健康探针结论保留，但不升级为完整授权链路通过。

健康探针本身仍只处理健康请求；后续独立传输适配及有界试验已完成，如上记录。所有历史意图保留，不能伪造健康/授权响应、拼接签名或绕过服务校验。只有取得实际设备key后才进入扫码与目标混合群只读验收。

### 后续只读对账：本地为空，上游仍未知

新增 `scripts/reconcile_pad_861_devices.py`，复用传输组件的独立 `reconcile` 模式。该模式只允许健康GET及固定上游POST `/api/v1/auth/devices`，拒绝生成路径。此查询路径来自固定EXE的 `GetDevicesWithAdminKey`（0xd3b6f8引用20字节字符串，随后调用HTTP Client.Post），不是猜测或自行拼签名。

实际运行命令：`.venv/Scripts/python.exe -X utf8 scripts/reconcile_pad_861_devices.py`，退出0。两次本地GetAllDevices都返回Code200、device_count=0；真实健康检查两次200，但传输记录没有任何设备查询POST，`upstream_inventory_observed=false`。该结果仅证明本地无可恢复设备记录，不能证明上游为空。只读反汇编也显示GetAllDevices调用上游前存在额外分支条件；未修改程序或插入虚假本地记录以强迫其调用。

收尾：无剩余监听，网关停止，.env摘要未变，双向Block均核验通过。generation_calls=0、qr_calls=0、message_calls=0。私密设备响应保存在gitignored目录，公共报告只输出数量。新增查询模式测试验证生成403、设备查询响应保持原样；最终相关34项测试通过。

当前本地可验证路径已完成，首次生成的上游结果仍未知。继续需要厂商服务端核对、厂商提供受支持的只读核对方式，或用户获得有效设备key；没有证据支持购买结论。可发送的脱敏问题已写入 `pad-861-maintainer-query-2026-09-16.md`，尚未发送给任何人。
