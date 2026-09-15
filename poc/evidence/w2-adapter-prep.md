# W2 真实适配准备（未开真实库）

日期：2026-09-14。工作包：spec v0.2 §11.1 W2。前置：[W1](./w1-offline-gaps.md)。

未打开真实聊天库、未取钥、未真发送、未调用真实模型、未提交。第 8 节实机输入仍空，因此 **G-READ / G-SEND / G-MODEL / R0 开库仍为未执行**。

## 代码版本

| 项 | 值 |
|---|---|
| 固定提交 | `a9d7415e44b585457d5c5d0a5c47b12974cd32ac` |
| pytest | **54 passed** in 6.99s（poc/.venv，CPython 3.12.13） |

54 与 45 / 32 / 29 不是同一次执行。本包新增 `tests/test_w2_adapters.py` 9 项。

## 已完成（离线 / 守卫）

| 项 | 判定 | 说明 |
|---|---|---|
| 明文适配器误开真实库 | 通过当前限定场景 | `sqlite_plain` 拒绝 `Documents\xwechat_files`；本机存在该目录时在 **discover 之前** 拒绝，未列举 wxid |
| SQLCipher 授权密钥 | 通过当前限定场景（合成 opener） | 仅 `env:VAR`；禁止 process 取钥；缺 `sqlcipher3` 时明确失败 |
| 窗口观测契约 | 通过当前限定场景 | `manual_file` 观测可进入 `manual_send` 窗口校验；`desktop_observed` **仍不驱动 UI** |
| 非 offline 的 `run` | 通过当前限定场景 | `read_only` 无 `allow_live_read` 时在 G-READ 阻断，不开库 |

## 仍阻塞的实机项

填写 `poc/config.live.example.toml` 的本地副本（建议 `.local/poc-live/live.toml`）且单独授权之前，不得：

1. 打开真实 `message_N.db`
2. 从 Weixin 进程取钥
3. 向真群发送
4. 把 observation JSON 或 mock verify 写成双端通过

`sqlcipher3` 本机未作为默认依赖安装。即使安装，没有授权密钥引用与 `allow_live_read=true` 也不会开真实库。

## 下一步（W2 剩余 / W3）

操作人补齐 spec §8.1 后才能做 R0 开库。W3 真实模型仍独立，缺模型信息不阻止读取适配，但不能替代群闭环。
