# legacy 861 Windows 基础配置交付

日期：2026-09-16。用户授权：基于指定安装包做基础配置。包内 README 仅作为资料，未执行其中 Docker 启动、登录或回调配置指令。

## 已完成

安装位置：`poc/.local/pad-legacy-861/`（已被 Git 忽略）。原 Downloads zip 未修改；未修改 P1 实现、MAX/legacy 公共模板或原有规格。

| 文件 | 用途 |
|---|---|
| `runtime/` | 原包程序、资源和静态接口资料；exe 未执行 |
| `runtime/.env` | 本机基础配置，已替换默认密钥和数据库密码 |
| `.env.dependencies` | Redis/MySQL 独立随机凭据，与网关连接配置一致；不要分享 |
| `compose.dependencies.yaml` | 仅 Redis 7、MySQL 8.0；本机端口16379/13306，独立卷，无自动重启；未拉取/启动 |
| `provider-profile.json` | legacy 本地文件哈希与包内文档线索；P0保持未闭合 |
| `config.pad.toml` | 独立离线观察配置，live/network/model/send均false，空账号群绑定 |
| `manifest.json` | zip、exe、Swagger、version.txt 的本地摘要 |

网关配置：HOST=127.0.0.1、PORT=1238、DEBUG=false；MCP_PORT=0、WEB_DOMAIN为空；MQ与集群连接清空/禁用；TASK_RETRY_COUNT=0。这些是**写入的配置值**，尚未证明程序确实遵守。MCP=0是否禁用、零重试是否生效、DT/同步与内置命令行为未知；未猜测 DISABLED_CMD_LIST 的命令名称，未盲改心跳/自动同步间隔为零。

没有给网关写入猜测格式的 webhook_config.json，没有设置真实回调。没有账号会话、扫码、模型和消息发送。基础配置完成不代表服务已运行或内置自动化已关闭。

## 本地文件核验

- zip：`4500ab14ac22b71146705ed2dc0046af4ee6ed555a617ba99430e1e1546d9430`，与此前保存的 Windows GitHub 声明值一致（本轮未重新查网络）。CRC检查通过。
- exe：`5308323f32d4249f325a750b0c0faa91aba5b91f50593c88931d9829ffb203e9`。
- Swagger JSON：`b53cf8e7eae3f9240e27304d6944811a1a40792b4098b0198c757e816b04a2ed`。
- 包内 version.txt：`ios18.61-861 / 20250822_153444 / windows / amd64`。

此前“缺包与接口导出”的结论对这份本地 legacy 包已有更新：现在已取得并哈希包内 JSON/YAML。但它不证明 MAX 可交付，也不证明完整契约有效。

包内 Swagger 使用 `/message/SendTextMessage`、`/login/GetLoginStatus`、`/webhook/Config` 和 query `key`，不是 MAX 的双Token接口。实际路由前缀仍需运行验证。新增线索包括 `/webhook/Status`、`/webhook/VerifyDbConfig`、`/webhook/ResetConnection`；尚未调用，不能据名字声称新消息边界已解决。

发现 `/webhook/Update` 方法名为 `t`；WebhookConfig 包含异常 `$ref` 和字段；多个响应只有描述无schema。不能直接生成可信 SDK。README 的 MIT 段落位于 webhook client 介绍中，不能据此确认网关二进制许可范围。

## 配置检查命令

在 `poc` 目录：

```powershell
.\.venv\Scripts\python.exe -m wechat_agent_poc.pad_cli --config .local\pad-legacy-861\config.pad.toml check
docker-compose --env-file .local\pad-legacy-861\.env.dependencies -f .local\pad-legacy-861\compose.dependencies.yaml config --quiet
```

`check`实际通过，保持p0_closed/live/network/model/send=false。当前P1 CLI仍会输出通用“未锁构建”提示和MAX合成HMAC报告；这不是对本地文件摘要的否定，也不是legacy验签证据。以manifest和profile逐字段记录为准，本轮不修改既有CLI。

Compose通过独立docker-compose.exe实际校验（退出0）；未输出展开后的凭据。Docker引擎管道不存在，服务不可用；本轮没有启动Docker Desktop、安装系统服务或拉镜像。依赖镜像标签仅是包内README推荐版本，尚未锁digest，不能当生产部署锁。

Pad P1相关16例执行通过（最终退出0）。首次默认临时目录清理报WinError5，改为项目内唯一basetemp后通过；pytest缓存目录仍有权限警告，不影响本轮测试退出状态。

完整回归最终 **204 passed, 1 skipped in 59.21s，退出0**，不是此前205 passed。使用 `-o addopts='' -q -p no:cacheprovider` 和 `poc/runtime/` 下唯一basetemp。前次把basetemp放在`.local`导致一项路径限制反例失效；随后runtime父目录缺失导致setup错误，创建父目录后完整复验通过。未为使测试通过修改实现或测试。跳过项仍不作通过计数。

## 复用与下一步

准备脚本 `poc/scripts/prepare_pad_legacy_local.py` 会检查zip摘要/路径/CRC，生成随机凭据，并拒绝覆盖已有安装目录。不要为了重跑删除现有配置或会话。

下一阶段先核实Docker运行条件和依赖版本，再验证网关实际监听、内置动作配置及外部依赖；之后才讨论扫码与只读采样。当前不存在可宣称可用的微信服务，P0仍有许可/数据路径/自动化关闭及真实语义缺口。

## 后续基础服务验证（用户提供 Docker 已运行截图后）

- Docker Engine 实际返回版本29.6.2；沙箱无法访问管道，经提升权限读取成功。
- 官方 `mysql:8.0` 下载两次失败：首次 registry-1.docker.io manifest请求EOF，第二次 auth.docker.io匿名Token请求EOF。MySQL未创建/启动，未改用第三方镜像或修改全局代理。
- 使用已有Redis镜像启动独立 `pad-legacy-861-redis-1`，Compose等待结果healthy，实际端口仅 `127.0.0.1:16379`。独立网络和redis_data卷已创建。
- Redis RepoDigest：`redis@sha256:e7723ff73d963f5cc6d9c4643ea3d989527a402a319239054e9472a7fb9219a2`。健康检查使用配置密码，未输出密码。
- 原有wharttest项目未启动、停止或修改。网关exe未执行，无扫码、回调或发送。
- 当前准备状态：Redis已运行；MySQL受官方镜像下载连接阻塞；基础服务整体尚未就绪。此前manifest记录的是配置生成时状态，以本节后续实测为准。

## 手动代理生效后的续验

- 用户要求继续准备后再次执行Compose up：mysql:8.0 manifest请求仍EOF。
- 只读确认Docker设置：ProxyHTTPMode=manual，HTTP/HTTPS均为http://127.0.0.1:17891；引擎报告内部代理http.docker.internal:3128。因此不是尚未保存手动配置。
- 17891监听进程为0dcloudCore。curl经该HTTP代理访问auth.docker.io收到CONNECT 200，随后TLS握手失败；对registry-1.docker.io的直连和代理各一次也均TLS握手失败。没有使用跳过证书校验或第三方镜像替代。
- 之前曾经代理收到registry 401，当前结果表明连通性有变化；不能将一次成功视为稳定修复。确切代理节点/上游原因未核实，需操作人更换可用节点后重新进行官方镜像下载验证。
- Redis继续healthy，仅127.0.0.1:16379；MySQL未创建、网关未运行。用户其它容器、全局代理与订阅未改动。

## 后续重试成功：基础依赖就绪

用户再次要求继续后，官方mysql:8.0镜像成功下载，Compose up --wait退出0。网络当前可完成此次下载，不据此承诺长期稳定。

- MySQL容器pad-legacy-861-mysql-1健康；实际版本8.0.46，使用非root应用账号查询返回数据库pad861、CURRENT_USER=pad861@%。
- Redis健康；带配置密码PING返回PONG，不带密码返回NOAUTH。
- Docker绑定为127.0.0.1:13306和127.0.0.1:16379，Windows宿主TCP连接均成功。
- MySQL摘要mysql@sha256:7dcddc01f13bab2f15cde676d44d01f61fc9f99fe7785e86196dfc07d358ae2b；Redis摘要沿用前文。已将本地Compose两个镜像固定到实测digest，配置再次校验通过。
- 本地manifest已更新dependencies_started=true；gateway_started=false、runtime_config_verified=false、p0_closed=false仍保持。
- 未运行网关exe，未扫码、设置微信回调或发送。当前通过的是依赖层验证；网关内置动作关闭、监听行为和外部数据路径仍须另行核验。

## 网关首次短时启动实测

2026-09-16，用户要求继续网关启动验证。运行Windows包约3秒后发现全地址监听，立即停止；随后确认网关进程不存在，1238/8098监听数为0。

- MySQL和Redis连接成功；网关实际执行了独立pad861数据库的自动建表。
- 尽管HOST=127.0.0.1，TCP监听实际为[::]:1238；不能把日志打印的localhost地址当作绑定证明。
- 尽管MCP_PORT=0，仍启动[::]:8098 SSE服务。0不是已验证的禁用值。
- 启动日志显示自动初始化登录状态、加载0条有效Webhook配置，并启动500毫秒消息同步任务；未调用登录、扫码、授权码生成、回调设置或发送接口。
- 观测到到198.18.0.124:80的连接；目的域名、用途与数据内容未知，不推断为已确认外传聊天数据。
- 日志声称重新生成Swagger，但找不到api/router/router.go。实测JSON/YAML文件摘要均未变化；原包副本保存到.local/pad-legacy-861/package-reference。
- 原始启动日志仅存gitignored本地目录，另生成脱敏副本；manifest更新为曾启动、当前已停、runtime_config_verified=false。不得覆盖旧包摘要为运行后推测值。

结论：依赖连接和建表通过，网关监听/MCP关闭要求未通过。当前禁止按现有.env常驻或扫码。后续需取得该构建真实可用的绑定/MCP关闭参数，或先做专用运行环境的网络隔离并验证；仅前置反向代理不能封住已经存在的全地址后端监听。未修改Windows防火墙、代理或用户其他容器。

## 官方教程复核与隔离复测（2026-09-16）

复核来源：
- https://github.com/WeChatPadPro/WeChatPadPro
- https://raw.githubusercontent.com/WeChatPadPro/WeChatPadPro/main/deploy/docker-compose.yml
- https://raw.githubusercontent.com/WeChatPadPro/WeChatPadPro/main/.env.example
- https://wx.knowhub.cloud/

GitHub当前Compose使用浮动latest，网关映射8080/1238，依赖mysql:8.0及redis:6；包内README与它不同。当前本地使用已验证的MySQL8.0.46和Redis7固定digest，不因网页示例不同而覆盖现有数据或降级。公开.env.example列出HOST与MCP_PORT=0，但没有声称0可禁用MCP；DISABLED_CMD_LIST只有逗号分隔说明，没有命令枚举。TASK_RETRY_COUNT=0也不代表禁用全部自动化。MAX教程要求Linux wechatpadpromax08、conf/app.conf与云端Token，不能直接套用Windows861。

此前首次启动章节末尾“未修改Windows防火墙”只描述当时状态。后续已新增两个精确程序规则：Codex-Pad861-Offline-Inbound、Codex-Pad861-Offline-Outbound，均Block/Any协议/全部配置文件，限定本地861 exe；既有规则未改。这两条规则目前保留。

加规则后的短时启动仍监听[::]:1238与[::]:8098。Docker Redis容器通过host.docker.internal对两个端口的TCP连接均成功，因此不能判定隔离通过；没有据此断言局域网实测可达。连接采样只见本地MySQL，不代表整个启动期间没有外连。GET /swagger/index.html返回404；未调用业务API。已在finally停止该进程，本轮再次检查没有网关进程及上述监听。

包内static/swagger/index.html存在，引用相对swagger.json；实际HTTP映射仍未确认。运行时生成的api与swagger-docs目录未检出文件，不能当作新生成的接口导出。

当前结论：基础依赖已就绪，Windows网关常驻运行条件未通过；P0仍未闭合。禁止把截图中依赖容器运行当成微信网关可用。继续使用Windows包需要可靠隔离或该构建可验证的监听/MCP控制方法；如改走官方Docker方向，应先取得并锁定对应Linux861构建，单独验证，不能把Windows exe直接放入现有Linux容器或用latest替换。

## Windows 路线复验（2026-09-16 15:19）

继续使用原Windows861 exe，未替换Linux/MAX构建。系统实测Windows10专业版19045；WindowsSandbox.exe不存在，Containers-DisposableClientVM功能Disabled。本轮未启用系统功能或重启。

ActiveStore中的Codex-Pad861-Offline-Inbound/Outbound均启用、Block且程序路径匹配。短时启动后，GET /、/static/swagger/index.html、/static/swagger/swagger.json均200；之前/swagger/index.html的404是路径不对应，不能当作整个文档服务不可用。

网关仍监听[::]:1238和[::]:8098。从专用Redis容器执行nc -z -w 2，host.docker.internal和192.168.1.69的1238/8098均可达。因此Windows程序规则未达到本次要求的隔离效果；此项是Docker来源访问实体网卡地址，不是另一台局域网设备的实测。

finally停止进程成功，剩余两个监听为零。结果保存于.local/pad-legacy-861/windows-probe-result.json；原始stdout/stderr仅留本地，不对外输出。未扫码、生成设备密钥、设置回调或发送消息。

基础依赖和Windows文档服务可运行，但常驻与账号接入仍未就绪。后续Windows隔离路线需启用Sandbox（可能重启）或提供专用Windows虚拟机，并重新验证依赖访问与出入站限制；本轮未把该未来路线标为完成。

## 防火墙访问来源纠正（2026-09-16 15:23）

本节修正前文将Sandbox/虚拟机视为后续必要条件的表述：当前证据不足以作该判断，不需要因此启用系统功能或重启。

本轮使用docker exec -d在专用Redis容器内保持短时TCP连接，并在Windows侧用Get-NetTCPConnection关联网关PID、来源地址与客户端进程。结果：
- host.docker.internal:1238在网关侧为127.0.0.1 -> 127.0.0.1。
- 192.168.1.69:1238在网关侧为192.168.1.69 -> 192.168.1.69。
- 两条客户端连接均属于宿主com.docker.backend进程。

因此之前的Docker连通性实测属于宿主本地转发，不能作为独立远程主机穿过入站防火墙的证据。也不能反向据此宣称真实远程入站一定已阻断。Docker官方网络文档说明容器流量由宿主backend代理：https://docs.docker.com/desktop/features/networking/ 。

本轮未改防火墙、代理、系统功能、网关配置或用户其它容器。网关短时运行后已自动停止。结果保存.local/pad-legacy-861/boundary-result.json。只有合成TCP连接，无登录/扫码/消息操作。

对原861 exe的静态字符串检查只确认MCP_PORT和.mcp.json等标识存在，没有取得可证明关闭MCP的参数或配置schema；不能将猜测字段写入配置。该检查不证明不存在其它开关。

剩余验证：从真正独立的局域网设备测试1238/8098入站（当前没有该设备的执行通道，未执行）；核实861的MCP关闭或鉴权行为、内置动作关闭及P0其它缺口。保留现有精确程序防火墙Block规则。不能把本轮纠正等同于常驻/登录验收完成。

## MCP端口与匿名握手对照验证（2026-09-16 15:25）

仅临时将.env的MCP_PORT由0改为18098，其余配置不变，运行原Windows861 exe约7秒。实际监听仍为[::]:8098及[::]:1238，未出现18098，故该设置未按预期控制本构建的MCP监听。没有尝试负端口、占用端口等故障方式冒充禁用。

匿名GET http://127.0.0.1:8098/sse返回200并收到event: endpoint；curl在1秒期限退出28，属于主动限制SSE等待时间，不是握手失败。GET /和/mcp均404。没有向SSE公布的消息端点提交请求，也没有initialize、tools/list或tools/call；因此仅确认匿名建立SSE通道，不能断言工具调用免鉴权。

finally已停止网关，并按原始字节恢复.env；前后SHA256一致，1238/8098/18098剩余监听为零。脱敏结构化结果位于.local/pad-legacy-861/mcp-probe-result.json；包含会话端点的临时响应文件已删除。未扫码、发送、改系统功能或安装Sandbox。

待取得的最小厂商信息：针对exe SHA256 5308323f32d4249f325a750b0c0faa91aba5b91f50593c88931d9829ffb203e9，确认MCP_PORT读取却不改变8098的原因；提供可验证的MCP关闭/绑定参数、.mcp.json准确schema及工具端点鉴权方法。上述问题尚未发送给任何外部人员。局域网独立设备入站验证仍未执行，不能用本机Docker代替。
