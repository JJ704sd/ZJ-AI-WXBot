"""Public-facing documentation and checksums for allowlisted portable releases."""
import hashlib
import json
from pathlib import Path
import re

GUIDE = '个微聊天记录解析工具说明.md'
SUPPORT_DOCS = ('操作指南.md', '版本与验证说明.md', '企微使用说明.md', '附件正文解析说明.md', '配置迁移说明.md', '复核导出流程.md')


def copy_public_guide(project, output, kind):
    for name in SUPPORT_DOCS:
        (output / name).write_text((project / 'docs/local-chat' / name).read_text(encoding='utf-8'), encoding='utf-8')
    source = (project / GUIDE).read_text(encoding='utf-8')
    body = source.split('## 10. 交付包与依据', 1)[0]
    for name in SUPPORT_DOCS:
        body = body.replace('(docs/local-chat/' + name + ')', '(' + name + ')')
    example = re.search(r'说“解析(?!企微|企业微信)([^”\n]+)群”', body)
    if example:
        body = body.replace(example[1], '示例业务')
    skill = (project / 'skills/local-wechat-archive/SKILL.md').read_text(encoding='utf-8')
    version = re.search(r'^  version: "([^"]+)"$', skill, re.M)[1]
    body = re.sub(r'Skill \d+\.\d+\.\d+', 'Skill ' + version, body)
    body = body.replace('本次WorkBuddy分享页已经包含群聊摘要和导出入口，对外转发前需要检查内容并按需脱敏。',
                        '在宿主中分享结果前，应检查摘要、成员资料和导出入口，并按需脱敏。')
    # Never distribute a link that exposes a real conversation or its exports.
    if re.search(r'https?://[^\s)]+(?:workbuddy\.link|/p/)', body, re.I):
        raise ValueError('A conversation share link remains in the public guide.')
    body += '## 10. 本交付包\n\n'
    body += '- [快速开始](README.md)：首次使用与一键启动说明。\n'
    body += '- [操作指南](操作指南.md)：选包、首次配置、更新迁移、结果转移和常见问题。\n'
    body += '- [版本与验证说明](版本与验证说明.md)：当前版本、实测范围与尚未验证的边界。\n'
    body += '- [企微使用说明](企微使用说明.md)：企业微信客户端、独立配置与已验证边界。\n'
    body += '- [附件正文解析说明](附件正文解析说明.md)：原件与正文状态、支持格式、出处及提取限制。\n'
    body += '- [配置迁移说明](配置迁移说明.md)：桌面与Skill共用目录、旧配置迁移及账号冲突处理。\n'
    if kind != 'suite':
        body += '- [Start.cmd](Start.cmd)：解压后双击启动；也可按快速开始选择直接运行EXE。\n'
    if kind == 'skill':
        body += '- [SKILL.md](SKILL.md)：提供给支持本机执行的AI宿主读取。\n'
        body += '- [runtime.json](runtime.json)：随包程序位置与校验值。\n'
    body += '- [SHA256SUMS.txt](SHA256SUMS.txt)：包内文件的SHA-256校验清单。\n'
    body += '- [package.json](package.json)：分发文件清单。\n'
    body += ('- 各独立ZIP均含 `licenses/` 运行库许可文件；选择所需桌面版或对应客户端Skill。\n\n'
             if kind == 'suite' else '- `licenses/`：随包运行库的许可文件。\n\n')
    body += '本说明使用匿名样本描述验证范围。交付包不附带真实消息、数据库、媒体、密钥或本机设置；首次使用需在本机确认有权读取的账号，自动配置成功或手动提供匹配密钥后读取。\n'
    (output / GUIDE).write_text(body, encoding='utf-8')


def write_quick_start(output, kind):
    if kind == 'skill':
        entry = ('1. 在WorkBuddy中打开“专家·技能·连接器 → 技能 → 添加技能 → 上传技能”，选择本Skill ZIP并启用。其他宿主需支持Skill、本机命令执行及文件访问。\n'
                 '2. 新建任务，说“打开聊天解析界面，让我选群并人工复核，确认前不要导出”；也可直接指定实际群名解析。\n'
                 '3. 勾选多个群批量解析，逐群点击“复核当前群”保存四项检查与备注；全部所选群复核后“一键导出所选群”，点击“打开批次目录”查看。保存复核不导出。\n'
                 '4. 也可解压完整文件夹，双击 `Start.cmd` 打开解析器。不要只复制SKILL.md。\n')
        location = '个微桌面版与个微Skill共用 `%LOCALAPPDATA%\\LocalWechatArchive`；企微桌面版与企微Skill共用 `%LOCALAPPDATA%\\LocalWeComArchive`。更新或换解压目录仍复用。'
    else:
        entry = ('1. 将整个ZIP解压到本人可写的普通文件夹，保留文件结构。\n'
                 '2. 双击 `Start.cmd`，或直接双击 `local-chat-desktop.exe`。无需打开命令行。\n'
                 '3. 首次确认账号并配置，左侧列出全部本地群 ID 与名称；勾选一个或多个群 ID，点“解析待处理 N 群”。\n'
                 '4. 逐群点击“复核当前群”保存检查与备注；全部所选群复核后“一键导出所选群”，各群独立三格式、复核记录及缺口说明保存在同一批次目录。\n')
        location = '个微桌面版与个微Skill共用 `%LOCALAPPDATA%\\LocalWechatArchive`；企微桌面版与企微Skill共用 `%LOCALAPPDATA%\\LocalWeComArchive`。更新或换解压目录仍复用。'
    text = '# 本地微信聊天解析：快速开始\n\n' + entry + '\n'
    text += '**解析企业微信**：完整解压后双击 `Start-WeCom.cmd`；WorkBuddy里说“解析企微示例业务群”。首次登录企微并选择账号、一键自动配置，之后复用独立设置。详见 [企微使用说明](企微使用说明.md)。\n\n'
    text += '完整步骤见 [操作指南](操作指南.md)，版本与实测范围见 [版本与验证说明](版本与验证说明.md)。\n\n'
    text += '已取得的PDF、Word、Excel、PPT和文本附件自动提取正文及出处，写入JSONL/JSON/MD与业务阅读；原文件取得状态和正文提取状态独立显示。扫描页、加密、部分提取和超限不当作完整成功。详见 [附件正文说明](附件正文解析说明.md)。\n\n'
    text += '**免安装**：支持目标为Windows 10/11 x64，运行库已随EXE提供，不用安装Python、pip、Docker或数据库服务。另一台物理电脑及Windows 11尚未实测。\n\n'
    text += location + '\n\n'
    if kind == 'skill':
        text += '独立客户端Skill的Start.cmd、脚本和直接双击bin内EXE均按runtime.json绑定个微或企微；完整文件夹可改名或移动。不能只复制bin内EXE；清单缺失、校验不一致或客户端参数冲突会停止，不自动改读另一客户端。\n\n'
    text += '没有用户配置时，程序自动查找附近旧版local-chat-data或local-chat-data-wecom，校验数据和密钥后迁移；保留旧文件，仅复制配置引用的密钥。多个账号、旧目录不在查找范围或路径失效时，在账号设置的手动页点“导入旧版配置”，选择旧settings.local.json。已有用户配置优先，不自动覆盖或切号。见 [配置迁移说明](配置迁移说明.md)。\n\n'
    text += '浅色界面中蓝色按钮对应主要操作；当前群ID直接显示并可复制，底部提示下一步和导出禁用原因。搜索框回车只定位，不解析；主按钮处理尚无预览或范围已变化的群，其余复用并保留复核，独立“重新解析”才重置目标复核。账号加载后展示全部本地群 ID 与名称，勾选支持多选、全选当前结果、搜索保留选择和批量复制ID；单击群名只查看。列表与当前群顶部显示未复核/已复核，可筛选所选群的复核状态；已导出计入已复核。批量解析可在当前群结束后停止，失败群单独标记；复核窗口可人工一键“全选复核项”或“清空勾选”，只影响当前群，仍需“确认复核完成”才保存。全部所选群复核后另行一键导出同一批文件，并保存复核检查项及备注。导出后JSON、JSONL、Markdown按钮可直接查看当前群文件，“文件所在目录”打开该群保存目录，批次总目录单独提供入口。各群分别导出，不合并记录。详见[复核导出流程](复核导出流程.md)。命名请求的awaiting_review和completed只对应原群，不代表其他群已确认导出。\n\n'
    text += '数据目录一般是单个账号的 `xwechat_files\\账号目录\\db_storage`。数据库密钥选已有密钥JSON，不是微信密码、聊天导出或程序设置JSON；图片密钥是另一类解密信息。微信不会自动提供这些密钥文件。自动配置会尝试恢复并校验后保存在本机工作目录 keys 中；未登录、布局不支持或只有离线密文时可能失败。具体目录示例见完整说明。\n\n'
    text += '导出后可打开 `images.html` 查看图片卡片总览，包含普通、嵌套转发和引用图片，原图、缩略图、本地预览、缺失与未加载分别标注，并能回到原消息。整份导出目录与 `assets/` 应一起保留。\n\n'
    text += '结果按 `mediaSummaryText` 分开报告原图、缩略图、本地预览、缺失图片、附件和表情。按普通消息、转发及引用的出现次数统计，同一文件可能重复；单位是引用处数，不是不同图片张数。未加载媒体不当成缺失。\n\n'
    text += '程序生成 `解析结果.md` 固定汇报，附件类型数量由程序计算。Skill原样汇报，并在WorkBuddy同时提供JSONL、JSON、MD三种文件入口；宿主无法呈现时保留本地链接并说明。\n\n'
    text += '点击“一键导出所选群”后，各群同时生成 `messages.jsonl`（逐行消息）、`messages.json`（完整消息数组）、`messages.md`（可读记录及相对媒体链接），不需要格式转换环境。桌面下方选择 MD / JSON / JSONL，点“查看导出文件”；没有默认关联时会尝试系统记事本。在WorkBuddy可说“导出某群为JSONL、JSON和MD”，默认复用已保存配置。\n\n'
    text += '准备本人有权读取的Windows微信4.x数据副本及匹配密钥。保留相关WAL、附件索引和媒体目录，只有数据库不能补出未缓存的图片。数据库和图片密钥可分开选，组合密钥文件也可用。只有密文无法通用推导密钥。\n\n'
    text += 'PDF、Office和视频附件通过电脑已有默认查看器打开；图片和转发的窗口查看不依赖Office。当前EXE未签名，企业电脑有执行限制时需由IT按组织规则放行。\n\n'
    text += '包内没有示例聊天、真实群记录、媒体、密钥或账号设置。不要向对话或模型粘贴密钥正文。\n\n'
    text += f'详细功能、验证范围与限制见 [{GUIDE}]({GUIDE})。\n'
    (output / 'README.md').write_text(text, encoding='utf-8')


def complete_metadata(output, metadata):
    metadata.update(distribution='portable-shareable', containsChatData=False, containsKeys=False,
                    containsLocalSettings=False, documentation=GUIDE)
    metadata['files'] = [{'path': path.relative_to(output).as_posix(), 'bytes': path.stat().st_size,
                          'sha256': hashlib.sha256(path.read_bytes()).hexdigest()}
                         for path in sorted(output.rglob('*')) if path.is_file()]
    (output / 'package.json').write_text(json.dumps(metadata, indent=2, ensure_ascii=False), encoding='utf-8')
    rows = [hashlib.sha256(path.read_bytes()).hexdigest() + '  ' + path.relative_to(output).as_posix()
            for path in sorted(output.rglob('*')) if path.is_file()]
    (output / 'SHA256SUMS.txt').write_text('\n'.join(rows) + '\n', encoding='utf-8')


def verified_desktop_inputs(desktop, binary):
    """Consume only source-manifest-listed runtime/licenses, ignoring stray data."""
    manifest = json.loads((desktop / 'package.json').read_text(encoding='utf-8'))
    selected = []
    for row in manifest['files']:
        relative = Path(row['path'])
        if relative == binary.relative_to(desktop) or relative.parts[0] == 'licenses':
            path = (desktop / relative).resolve()
            if not path.is_relative_to(desktop) or not path.is_file():
                raise ValueError('Desktop package input escapes its package directory.')
            if hashlib.sha256(path.read_bytes()).hexdigest() != row['sha256']:
                raise ValueError('Desktop package input does not match its manifest.')
            selected.append((relative, path))
    if not any(relative == binary.relative_to(desktop) for relative, _ in selected):
        raise ValueError('Desktop binary is not listed in its source manifest.')
    licenses = [(relative, path) for relative, path in selected if relative.parts[0] == 'licenses']
    if not licenses:
        raise ValueError('Desktop package contains no listed redistribution licenses.')
    return licenses
