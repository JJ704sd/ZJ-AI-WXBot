# 861 教程核对与原生路径重试

用户明确要求不提交Issue、根据相关教程重新尝试。本轮没有任何对外发帖或联系维护者。

## 教程核对

- 用户固定ZIP的README：配置ADMIN_KEY、服务器、Redis及MySQL；示例值不是厂商签发凭据，未替换现有随机管理密钥。包内README偏向Docker部署，不能据此要求替换Windows EXE。
- [官方README](https://github.com/WeChatPadPro/WeChatPadPro/blob/main/README.md)：管理员密钥建议随机配置，当前页面含v875/v868信息，不覆盖固定861的契约。
- [老用户指南](https://github.com/WeChatPadPro/WeChatPadPro/blob/main/usage_guide_for_old_users.md)：重点是Webhook及历史消息缓存，未提供授权失败的额外修复步骤；未为了生成key额外启动Webhook。
- 生成仍按固定包内Swagger的POST `/admin/GenAuthKey1`、整数Count=1、Days=1和字符串Remark。没有使用在线演示密钥、他人授权码或改变签名。

## 本轮实际操作

为现有脚本增加固定 `-TutorialRetry` 轮次，保留全部旧意图与未知结果。程序原生 `ADMIN_KEY_SERVICE_URL=https://adminkeyservice.knowhub.cloud`，不通过自建授权转发层。仅短时解除固定EXE的出站Block，入站Block保持，finally停止并恢复出站。配置文件未改。现有HTTP_PROXY保留给其它客户端，但不宣称原生授权客户端会使用它。

执行：`scripts/test_pad_861_authorization_network.ps1 -TutorialRetry`。

- Docker提升后检查：MySQL、Redis均healthy；首次受限环境查询Docker被权限拒绝，不算依赖不健康。
- 前置GetAllDevices通过空设备列表检查。
- 一次本地Count1/Days1生成，返回HTTP200、Code300、Data=null，文本“生成授权码失败: 授权服务暂时不可用，请稍后再试”。没有设备key。
- 2026-09-16 17:00:46清理：elapsed_seconds=12.27，gateway_stopped=true，remaining_listeners=0，inbound_block_enabled=true，outbound_block_restored=true，config_unchanged=true。
- 没有二维码、微信登录、消息采样或发送。未重复第二次生成。

私密收据及日志为gitignored `.local/pad-legacy-861/device-tutorial-native-trial-*`、`tutorial-native-trial-*`。外发目的地沿用此前明确授权；不附原始日志。PowerShell语法解析与Python编译通过；本轮为脚本分支和外部实测，未重复全量Agent回归。

## 结论

已实际按包内契约及教程配置重试原生路径，失败仍存在，不能把它单独归因于自建转发层。健康接口200仍不能证明原生授权成功。没有从教程找到可验证的新修复配置，也未获得上游HTTP错误详情；不虚构缺少授权参数、必须付费或扫码已就绪。
