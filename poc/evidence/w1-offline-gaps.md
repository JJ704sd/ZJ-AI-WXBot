# W1 实机前缺口（离线）

日期：2026-09-14。工作包：spec v0.2 §11.1 W1。在 [W0](./w0-local-baseline.md) 之后改代码；未打开真实聊天库、未真发送、未调用真实模型、未提交。

判定用语仅使用：通过当前限定场景 / 部分通过且有限制 / 未通过 / 未执行。

## 代码版本

| 项 | 值 |
|---|---|
| 固定提交 | `a9d7415e44b585457d5c5d0a5c47b12974cd32ac` |
| 本工作包 | 未提交工作区；相对 W0 又改了 reader/sender/store/CLI 与测试 |
| pytest | **45 passed** in 6.10s（`uv run pytest -o addopts= --tb=short`，poc/.venv，CPython 3.12.13） |

45 与 W0 的 32、固定提交的 29 **不是同一次执行**。新增主要来自 `tests/test_v02_gates.py` 的 N 类离线反例；同时修订了与“不读取历史正文”冲突的旧断言。

## 已落实的 P0

| ID | 离线结果 | 说明 |
|---|---|---|
| P0-READ | 通过当前限定场景 | 首次只查 `local_id`/`create_time`；正文不入库；增量带 WHERE；空表也初始化 |
| P0-WINDOW | 通过当前限定场景 | `manual_send` 缺少真实观测或 `name_search_only` 拒发；offline mock 仍可用配置窗口演练状态机 |
| P0-SEND | 通过当前限定场景 | stub `submit_stage=not_sent` → `failed`；提交后 Halt 默认 `unknown` → `uncertain` 并暂停 |
| P0-ONCE | 通过当前限定场景 | `BEGIN IMMEDIATE` 占用 `approved` 并消费审批；重复/并发第二次拒绝 |

`r0-check` 现输出 `gates.G0/G-READ/G-SEND/G-MODEL`。门槛判定仍为未执行实机，不是 R0—R4 通过。

## N01—N12

均在合成环境执行，见 `tests/test_v02_gates.py`。全部 **通过当前限定场景**。真实客户端适用项仍 **未执行**。

## 刻意修订的旧断言

| 旧意图 | v0.2 修订 |
|---|---|
| 首次读取把已有行变成 `is_historical` 事件 | 首次返回空列表，只写元数据基线 |
| 超出 120 秒回看的迟到行入库为历史正文 | 不承诺完整，不入库 |
| 历史消息正文进入模型上下文以生成 9/20 草稿 | 历史正文不再进入 context；自消息/历史仍不派发 |

## 仍未关闭（留给 W2）

| 项 | 判定 |
|---|---|
| `SqlcipherReader` 真实开库 | 未执行；见后续 [w2-adapter-prep.md](./w2-adapter-prep.md) |
| 真实窗口观测 / 桌面发送 | 未执行；观测契约已有，UI 发送仍未武装 |
| G-READ / G-SEND / G-MODEL 放行 | 未执行 |
| 真实 R0—R4 | 未执行 |
