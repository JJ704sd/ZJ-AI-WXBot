# 方案 A：非 MAX 861 授权入口核实

对象：Windows 861 / 20250822。仅本地文档和代码读取、公开GitHub资料核查；没有启动网关、ping、生成、登录、收发、外部联系或配置变更。

## 结论

目前证据支持的正常路径是：自行设置本地 ADMIN_KEY → 调用本地 POST /admin/GenAuthKey1（query key 为管理key，Count/Days/Remark 为body）→ 网关访问其上游授权服务 → 返回设备key → 使用设备key登录。

没有找到固定构建要求用户先在某个后台购买或领取“厂商 ADMIN_KEY”的可靠依据。当前官方.env.example明确建议ADMIN_KEY使用复杂随机字符串。以前将“额外签发资格”列为核查项是未知条件，不能陈述成已确认的必备步骤，更不能导向MAX后台。

已保存的上游错误发生在自动注册管理员密钥、查询系统用户时；这支持当前失败位于服务端处理环节，但不能证明所有自设管理key最终均获准签发或保证免费额度。

| 问题 | 本轮结果 |
|---|---|
| 本地管理key哪里来 | 当前官方配置说明为自行设置复杂随机字符串；本地已有自设值 |
| 设备key哪里来 | 固定包Swagger的/admin/GenAuthKey1；当前已知唯一匹配生成入口 |
| 独立非MAX后台领取入口 | 本轮没有找到可验证入口 |
| 必须付费/购买资格 | 未证实；不能推断必须付费 |
| 当前免费额度/有效期上限 | 未证实；Count/Days参数不是服务承诺 |
| README的GenAuthKey2 | 文档存在，但不在固定Swagger中，不作为可执行备用入口 |
| 上游库恢复证据 | 没有；v2.01发行说明谈Webhook与登录，不是授权数据库恢复 |
| 已有设备key是否可配置 | 本项目apply_pad_861_license.py支持本地保存device_key，但明确vendor_authorization_verified=false；不是官方迁移承诺或有效性校验 |

## 来源与限制

- https://raw.githubusercontent.com/WeChatPadPro/WeChatPadPro/main/.env.example ：ADMIN_KEY为自设随机字符串。main可变，不等同固定二进制核心源码。
- https://github.com/WeChatPadPro/WeChatPadPro/releases/tag/v2.01 ：20250822发布说明。
- https://github.com/WeChatPadPro/WeChatPadPro ：README生成路线含旧文档，不覆盖包内契约。
- 固定包契约审计：pad-861-contract-audit-2026-09-16.json。
- 已有失败证据：pad-861-upstream-database-failure-2026-09-16.md、nonmax-861-g1-watermark-2026-09-16.md。
- 本地脚本：scripts/apply_pad_861_license.py，只静态阅读，未调用。

本轮有针对性的公开搜索没有提供不同于已有故障的新依据，不重新打开全部旧Issue。Issue中的用户报告仅是旁证，不当维护方资格说明。没有查看或输出实际秘密值。

## 下一步

不替换本地ADMIN_KEY、不购买、不登录MAX后台、不重放生成。G1仍未通过。若继续外部确认，应由用户决定是否询问维护方：该构建自设ADMIN_KEY自动注册机制是否仍在服务、授权数据库是否已修复、是否有同构建备用签发入口及免费额度。本轮不代发。

可复制询问：

> 使用非MAX Windows 861、20250822构建，按自设ADMIN_KEY调用GenAuthKey1。2026-09-16请求到达上游，但自动注册管理员密钥、查找系统用户时数据库连接超时，无设备key。请确认该构建的自动注册/签发服务是否仍受支持、本次故障是否修复，以及是否存在适用的备用签发入口和免费额度。暂不考虑MAX或付费。可提供构建哈希及脱敏错误摘要。
