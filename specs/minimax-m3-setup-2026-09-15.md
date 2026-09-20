# MiniMax M3 本机配置指引

2026-09-20 补充：现有凭据已完成 M3 图像 OCR 实测，见 [图像识别对照](../poc/evidence/m3-ocr-2026-09-20.md)。图片通过 OpenAI 兼容 `image_url` 传入；独立入口为 `python -m wechat_agent_poc.m3_ocr`，超时 30 秒、无重试，输出上限 1024 tokens。本轮只上传合成图和两条测试文字裁图，没有把云 OCR 接入默认微信读取链路。

日期：2026-09-15。当前状态：操作人已提供首次 API 检查 PASS：1 次请求、1.03 秒、答案匹配，未访问微信。见 [连通证据](../poc/evidence/m3-connectivity-2026-09-15.md)。T3 独立通用问答适配和三条真实调用已完成，技术接入通过，回答质量有限制；见 [T3报告](../poc/evidence/t3-m3-2026-09-15.md)。微信runner尚未接入该路径。本指引不启动微信读取、自动回复或定时发送。

## 1. 在官方平台准备 API Key

登录 [MiniMax 中国开放平台](https://platform.minimax.cn/)，在账户管理的接口密钥页面创建或使用 API Key，并在控制台确认账号对 MiniMax-M3 有调用权限及可用额度。费用和额度由操作人自行确认，本指引不代购、不充值。

按量 API Key 与订阅 Token Plan Key 分开管理；不能把聊天产品登录凭据当作 API Key。如果只有 Token Plan Key，先核对其允许的调用用途及端点，不默认可用于本群聊程序。见 [官方接口概览](https://platform.minimax.cn/docs/api-reference/api-overview)。密钥不发到聊天、不截图、不写进 TOML/Git。

## 2. 推荐参数

| 参数 | 值 |
|---|---|
| 协议 | OpenAI 兼容 Chat Completions |
| 完整 HTTP endpoint | `https://api.minimax.cn/v1/chat/completions` |
| SDK base_url（若以后使用 SDK） | `https://api.minimax.cn/v1` |
| model_name | `MiniMax-M3` |
| credential_source | `env:MINIMAX_API_KEY` |
| 请求超时 | 12 秒；不自动重试 |
| thinking | `{"type":"disabled"}`，首轮短通用问答关闭思考 |
| reasoning_split | `true`，防止将思考内容当正文 |

依据：[官方 OpenAI 兼容说明](https://platform.minimax.cn/docs/api-reference/text-openai-api)。旧 [文本合成接口](https://platform.minimax.cn/docs/api-reference/text-post) 已标 deprecated，因此本指引替换 v0.4 初稿使用的 `chatcompletion_v2` 示例。完整 endpoint 与 SDK base_url 不能混用。

## 3. 首次验证：本地 .env 或隐藏输入

已创建 `poc/.env`，在本机编辑为 `MINIMAX_API_KEY=真实密钥` 后保存。不要加反引号，不要保存成 `.env.txt`。该文件为明文，但已被 Git 忽略；`.env.example` 仅包含空值。

独立检查脚本和现有 responder 的 `env:MINIMAX_API_KEY` 引用现在会读取固定的 `poc/.env`；已有进程环境变量优先（即使为空）。只加载这一项，不执行变量展开或读取其他路径。修改文件后启动新的 Python 进程生效。若文件未填写且无环境变量，脚本继续隐藏输入提示。独立通用问答适配已完成，微信runner尚未接入。

在你自己的 PowerShell 终端运行：

```powershell
Set-Location -LiteralPath 'D:\path\to\ZJ-AI-WXBot\poc'
.\.venv\Scripts\python.exe -X utf8 .\scripts\check_minimax_m3.py
```

出现 `MiniMax API Key (hidden, not saved):` 后粘贴 Key 并回车；正常终端不显示输入字符。仅在真实终端执行，不在会回显输入的聊天框或不支持隐藏输入的环境执行。

该脚本仅向固定官方地址请求一次合成问题“2+3”，不跟随重定向、不重试、不输出密钥、原始响应或思考内容。可能消耗一次 API 额度。密钥只在该进程使用，结束后不保存；普通进程退出不宣称法证级内存擦除。

成功输出中包含 `"status": "PASS"`、`"expected_answer_matched": true`、`"requests": 1`。只把这段状态结果告知助手，不提供 Key。PASS 仅证明一次独立连通与答案校验，不等于 T3 三条问答或微信群接入完成。

## 4. 后续程序运行：设置同一 PowerShell 的进程环境变量

后续模型适配器需要使用 env 引用时，在本机运行以下内容；命令历史中只有读取指令，不含密钥字面值：

```powershell
$m3Secret = Read-Host 'MiniMax API Key' -AsSecureString
$m3Pointer = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($m3Secret)
try {
    $env:MINIMAX_API_KEY = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($m3Pointer)
} finally {
    [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($m3Pointer)
    $m3Secret.Dispose()
    Remove-Variable m3Secret, m3Pointer
}
Write-Output ('MINIMAX_API_KEY configured: ' + [bool]$env:MINIMAX_API_KEY)
```

此变量仅在该 PowerShell 及其之后启动的子进程可见。已运行的 Codex 或其他终端不会自动获得它；不要因为另一个进程读不到就重复创建 Key。首次检查可在同一窗口执行 `python.exe ...check_minimax_m3.py --env-only`，但这会新增一次真实请求，不必在已通过后重复执行。

用完删除该会话变量：

```powershell
Remove-Item Env:MINIMAX_API_KEY -ErrorAction SilentlyContinue
```

不使用 `setx` 或将 Key 写入全局配置。隐藏输入方案不需要保存到磁盘。

## 5. 项目配置与实现限制

后续实施 T3 时，在仅本地配置的现有 `[model]` 段修改，不重复追加同名段：

```toml
[model]
provider = "http"
endpoint = "https://api.minimax.cn/v1/chat/completions"
model_name = "MiniMax-M3"
credential_source = "env:MINIMAX_API_KEY"
timeout_seconds = 12.0
```

本段是参数准备，不要为了配置模型改变任何 live 发送开关。独立检查脚本不读取 live.toml，也不需要设置该段。

当前 `responder.py` 仍使用旧的业务证据 SYSTEM，发送 event/context 并把 content 当 JSON 解析；尚不满足 v0.4 的独立通用问答。后续 T3 实施须增加独立通用问答路径、请求 thinking/reasoning_split 参数、最终文本解析及业务错误校验，保持原 JSON 路径兼容；不要直接启动一般 run 尝试通用问答。上述两个新请求参数不能仅加入 TOML 就假定旧代码会传出。

## 6. 失败处理与下一步

| 输出 | 处理 |
|---|---|
| NOT_RUN | env-only 模式没有变量；在同一终端设置或用隐藏输入模式 |
| HTTP 401/403 | 在官方控制台核对密钥、账号及模型权限，不向助手展示 Key |
| HTTP 429 / 业务错误 | 检查额度、余额和请求限制，不自动购买或重试 |
| 网络/TLS/超时 | 核对本机网络及端点；不能关闭证书校验；12秒超时是实测失败，不能写成模型不可用 |
| FAILED_RESPONSE_VALIDATION | 请求返回但未满足模型/结束状态/答案断言，保持未通过，不输出原始响应 |

完成第一步连通后，使用 [v0.4 操作提示词 B](personal-wechat-agent-implementation-prompt-v0.4.md)实施剩余 T3。先实现通用问答路径，再用三条合成问题独立验证。不启动微信自动发送。


## T3进展更新

新增 general_qa.py 与 scripts/verify_m3_t3.py，三条真实问答已验证，详见T3报告。第5节描述的旧 responder 仍保留，独立适配器不改变其行为；不要重复执行三条请求作为例行检查。
