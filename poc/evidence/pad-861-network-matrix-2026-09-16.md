# 861 无凭据网络稳定性对照

执行时间：2026-09-16 16:53起（Asia/Shanghai）。固定目标 `https://adminkeyservice.knowhub.cloud/ping`，保留TLS验证，不跟随重定向，不使用凭据。

| 客户端/路径 | 成功 | 总耗时范围 |
|---|---:|---:|
| Windows curl，显式127.0.0.1:17891代理 | 5/5，HTTP200及pong | 1.215–1.473秒 |
| Windows curl，`--noproxy '*'` | 5/5，HTTP200及pong | 1.230–1.786秒 |
| 实际Python `upstream_request`，现有代理 | 5/5，HTTP200及pong | 0.891–2.719秒 |

curl的10次TLS验证结果均0。未指定代理组实际连接198.18.0.21，不能视为独立公网直连；没有修改系统DNS、TUN或代理设置。因此本轮没有证据证明关闭代理更可靠，也没有证据支持替换Python客户端。

15次样本均成功说明本轮窗口健康接口可用，不能抹去先前失败、证明长期稳定或证明生成接口可用。每组是5次短样本，不是稳定性验收。没有重试生成、启动网关、扫码或发送消息。

可复现curl对照：`.venv/Scripts/python.exe -X utf8 scripts/probe_pad_861_network_matrix.py`。每次连接上限4秒、curl总上限8秒，最多两个并发。正文只在gitignored临时文件检查pong后删除；报告不存服务器任意文本。原始结果在 `.local/pad-legacy-861/network-matrix-result.json` 和 `python-health-matrix-result.json`。

当前行动：保留显式代理路径及已完成的阶段观测修复，不根据短暂恢复反复生成。下一项仍需核对前次未知生成状态或取得有效设备key；本地GetAllDevices已证实不能完成此次上游对账。维护者核对材料已补充本轮结果，未对外发送。
