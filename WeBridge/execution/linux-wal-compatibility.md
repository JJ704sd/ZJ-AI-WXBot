# Linux 微信 WAL 校验兼容性核查

日期：2026-09-21。对象：Linux 微信 4.1.1.8 的 `message_0.db-wal` 兼容性现象。本次只读现有探测脚本、验收文档和官方公开源码；没有读取账号材料、密钥、真实数据库、WAL、SHM 或活跃进程。

**恢复后新样本已确认是 WAL 重置后的旧残尾，不是“定制 checksum”的证据。** 新样本的 WAL header 与 SHM 一致、`mxFrame=0`，物理文件中的 26 帧全部使用旧 salt，本次 WAL 没有有效帧。崩溃前旧样本是另一份数据，其首次校验失败原因仍未确定。官方源码也不支持“WCDB 对明文计算 WAL checksum”的解释：SQLCipher 上游和腾讯分支都先加密页，再对实际写盘的完整密文页计算标准 SQLite frame checksum。

## 已观察到什么，尚缺什么

[首轮验收记录](linux-acceptance.md) 表明：WAL header 校验通过，frame 校验不全通过；标准 SQLCipher 看不到第二条已送达消息；临时合并同 salt 的页面后，`integrity_check=ok` 且能读取该消息及 @ 元数据。这是有价值的页级证据，**不证明被合并的最后一个 commit 标记属于完整有效事务**。

[原诊断脚本](linux/wal_snapshot_probe.py) 按计算结果持续累加 checksum，首次失败以后仍继续到同 salt 的尾部，并以非零页数标记选择最后一个“提交”位置。因此它的 `standardFrameChecksumsMatch=false` 没有回答：第一次在哪一帧失败、后续是否只是链式传播、失败是否在有效提交之后。原脚本已经标记为诊断用途，这个限制应保留。

**恢复后新样本，必须与上段旧样本分开：** 根任务已对新捕获的稳定临时 WAL + SHM 副本运行本文工具，并回报以下无内容元数据。本分支未读取原文件：

| 新样本项 | 结果 |
|---|---|
| WAL 物理大小 / 完整帧槽位 | 107,152 字节 / 26 帧 |
| WAL header checksum | 通过 |
| 所有 frame salt | **26 / 26 均不等于当前 WAL header salt** |
| 严格有效前缀 / 首个无效位置 | 0 帧 / 第 1 帧；盐校验已经失败 |
| 从新 header 累积匹配数 / 前一帧存储值诊断匹配数 | 0 / 23；这是旧代帧的诊断，不能据此接受任何当前事务 |
| SHM 双 header / 自身 checksum / 与 WAL header salt | 均一致或通过 |
| `mxFrame` / `nBackfill` | **0 / 0** |
| 原临时合并脚本 | 报 `No commit boundary`，符合本样本没有当前有效帧的事实 |

该状态与“checkpoint/restart 已切换 header 和 SHM，物理旧页槽位尚未截断或覆盖”一致。根任务下一步核对实际活动 `message_N` 分片；不能把本文件有 26 个物理帧槽位解释为有 26 帧待同步消息，也不能拿当前样本反推崩溃前原样本的原因。[新样本元数据回报](../build/wal-source-audit/latest-offline-metadata-summary.json)

## 官方代码确定的顺序

本地固定源码清单在 [sources.json](../build/wal-source-audit/sources.json)：

| 官方来源 | 固定版本 | 可验证结论 |
|---|---|---|
| [Tencent/wcdb](https://github.com/Tencent/wcdb/tree/39dd797099d41cf1953d5668acd8cb608016c599) | `39dd797…`，2026-04-10 | `.gitmodules` 指向腾讯的 SQLCipher 分支，子模块锁定 `f049bed…`；并非直接等于 SQLCipher 上游。 |
| [Tencent/sqlcipher](https://github.com/Tencent/sqlcipher/tree/f049bed66ca26741f09a6e4f0603ed3af195ac96) | `f049bed…`，2025-11-11 | WAL 写入调用 codec 后再编码 frame；frame 算法仍为标准累加校验。 |
| [sqlcipher/sqlcipher](https://github.com/sqlcipher/sqlcipher/tree/c4b275a47932888216bade83aff2bbc73df0ff85) | `c4b275a…`，2026-09-06 | 相同的“加密 → 算 frame checksum → 写 frame header 与密文”顺序。 |

腾讯分支 `walWriteOneFrame` 先调用 `sqlite3PagerCodec(pPage)`，再把返回的 `pData` 同时交给 `walEncodeFrame` 和写盘函数；`sqlite3PagerCodec` 明确执行 codec mode 6，`crypto.c` 将 mode 6 定义为加密。也就是说，校验不是对另一个明文缓冲区进行。[WAL 写入](https://github.com/Tencent/sqlcipher/blob/f049bed66ca26741f09a6e4f0603ed3af195ac96/src/wal.c#L3452)、[Pager codec](https://github.com/Tencent/sqlcipher/blob/f049bed66ca26741f09a6e4f0603ed3af195ac96/src/pager.c#L7118)、[mode 6 加密](https://github.com/Tencent/sqlcipher/blob/f049bed66ca26741f09a6e4f0603ed3af195ac96/src/crypto.c#L712)

标准算法的起始状态来自 WAL header 前 24 字节；每帧依次累加 **frame header 前 8 字节 + 整个页大小的原始数据**。帧 salt 与 checksum 字段本身不参与该帧计算。magic `0x377f0682` 对应按小端取 32 位输入，`0x377f0683` 对应大端；结果字段按大端保存。当前探测脚本的这几步与源码一致，并没有显见的输入范围或大小端错误。[腾讯编码/验证实现](https://github.com/Tencent/sqlcipher/blob/f049bed66ca26741f09a6e4f0603ed3af195ac96/src/wal.c#L737)、[上游写入实现](https://github.com/sqlcipher/sqlcipher/blob/c4b275a47932888216bade83aff2bbc73df0ff85/src/wal.c#L3963)

WCDB 自带的离线修复器也对映射取得的 raw frame 前 8 字节及完整 raw 页计算校验；它不是先解密页面再校验。这是独立于 SQLCipher 写入路径的第二份腾讯一手证据。[Frame::calculateChecksum](https://github.com/Tencent/wcdb/blob/39dd797099d41cf1953d5668acd8cb608016c599/src/common/repair/parse/Frame.cpp#L68)

## 确实存在的腾讯差异

腾讯分支包含 `SQLITE_WCDB_IMPROVED_CHECKPOINT`：可以在满足条件的 passive checkpoint 后重置 WAL header；也有从 SHM 恢复 `nBackfill` 的实现。WCDB 修复器若确认有回填前缀，会以该前缀最后一帧的存储 checksum 为种子，从 `nBackfill+1` 开始检查。**这些是 checkpoint / 索引状态方面的差异，不是“对明文算 checksum”的依据。** [checkpoint 分支](https://github.com/Tencent/sqlcipher/blob/f049bed66ca26741f09a6e4f0603ed3af195ac96/src/wal.c#L2039)、[恢复回填位置](https://github.com/Tencent/sqlcipher/blob/f049bed66ca26741f09a6e4f0603ed3af195ac96/src/wal.c#L2254)、[WCDB 从回填位置继续校验](https://github.com/Tencent/wcdb/blob/39dd797099d41cf1953d5668acd8cb608016c599/src/common/repair/parse/Wal.cpp#L299)

标准 SQLite 在需要从 WAL 重建索引时，从头验证并停在首个无效 checksum，只接受此前最后一个有效提交。因此“客户端仍能看到消息，而另一个标准 SQLCipher 进程从副本读到旧结果”与索引/有效前缀差异相容；仅有该现象尚不能判断差异来自哪里。[SQLite recovery 规则](https://www.sqlite.org/walformat.html#recovery)

同 salt 只证明帧头盐匹配当前 WAL header，不能替代整个链的验证。`integrity_check=ok` 检查的是拼出来的数据库结构；它不验证那些 WAL 帧当时是否构成有效提交，也不证明复制过程具有事务快照的一致性。

## 下一步的最小验证

已提供无密钥工具 [wal_metadata_check.py](linux/wal_metadata_check.py)。它不导入 `db_probe.context()`，不打开数据库，不解密、不合并、不写输入文件；只接受显式给出的离线 WAL / 可选 SHM 副本，并拒绝 `xwechat_files` / `db_storage` 客户端目录。输出只有页号、计数和匹配状态，没有消息正文、salt 原值或密钥。

先执行完全合成数据的自检：

```sh
python3 execution/linux/wal_metadata_check.py --self-test
```

本次已用 Python 自带 SQLite **3.51.0** 实际生成 4 帧 WAL，header、4 帧与 SHM 检查全部通过；人为只改第 2 帧页内容的一个字节后，准确定位首个错误为第 2 帧；后续帧以其前一帧“存储 checksum”为诊断种子时恢复匹配。[合成实验结果](../build/wal-source-audit/synthetic-validation.json)。这验证了解析器和链式传播的诊断能力，**没有证明微信 WAL 符合标准格式**。

根任务可对**已经保存的临时副本**执行，不要把命令参数换成活跃客户端路径：

```sh
python3 execution/linux/wal_metadata_check.py \
  --offline-copy /tmp/离线副本/message_0.db-wal
```

如果已有同次捕获的 SHM 副本，再附加 `--shm-copy /tmp/离线副本/message_0.db-shm`；不要为了本研究读取活跃 SHM。工具会核对双 header、SHM checksum、salt、字节序、末帧 checksum、`mxFrame` 与 `nBackfill` 边界，再给出未回填后缀的独立诊断。**该后缀校验的起始存储值未被独立验证，不可当成修复授权。**

| 离线结果 | 下一步判断 |
|---|---|
| SHM 与 WAL header 一致、`mxFrame=0`，物理帧 salt 全是旧值 | 当前 WAL 无有效帧，物理内容是残尾。忽略这些旧帧；核对当前实际活动分片。本轮恢复后新样本正是这种情况。 |
| 全部帧通过，或首个错误只在最后有效提交之后 | 优先重新核对捕获文件身份、有效提交边界、页尺寸和是否仅有残尾；不能继续声称整份 WAL 算法不兼容。 |
| 早期某帧失败，随后 `from_previous_stored_matches` 大量恢复 | 支持“局部损坏/写中页/旧前缀导致链式传播”方向；结合可信同批 SHM 的 `nBackfill` 和 `mxFrame` 缩小范围，不跳过错误链直接用于生产。 |
| 从第 1 帧起，累积与前一存储值两种诊断都持续不匹配 | 优先核对实际客户端内嵌 SQLite/SQLCipher 源版本、编译配置、VFS 是否变换写盘内容；此时才值得验证私有格式假设。当前公开源码未提供这种格式证据。 |
| WAL / SHM header 不一致或 salt 不同 | 先归为捕获代际不一致；不使用该 SHM 的回填信息作解释。 |

根任务若要继续验证加密因素，可在**全新合成数据库**上用其现有 SQLCipher 执行 `journal_mode=WAL`、关闭自动 checkpoint、提交两次无敏感数据，保持创建连接未关闭时复制该合成 WAL，再运行同一检查器。官方算法预期仍全通过。无需使用真实账号 key；若这个独立实验失败，再检查该 SQLCipher 构建本身。此实验本分支尚未执行。

## 未确认事项

- 已获得恢复后新样本的无内容元数据并能解释为旧残尾；**仍未取得崩溃前原样本的首个失败帧及 SHM 位置**。本分支没有亲自读取实际微信 WAL。
- 未确认 Linux 微信 4.1.1.8 内嵌引擎与上述公开提交是否完全相同，不能排除私有改动。
- 未确认原捕获的 DB、WAL、SHM 是否来自一致事务视图。mtime 不变与重复读取相同字节能减少竞争窗口，但不等价于引擎提供的一致备份。
- 未确认页正文、frame header、旧前缀、未提交尾部、复制代际或私有 VFS 中哪一项是实际原因。

当前结论是：**新样本是正常可解释的旧代残尾；旧样本尚未定因；密文校验本身是官方正确路径，没有已证实的定制 checksum。** 暂时不应通过忽略 checksum 的页合并来承担实时消息同步。
