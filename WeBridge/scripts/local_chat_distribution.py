"""Public-facing documentation and checksums for allowlisted portable releases."""
import hashlib
import json
from pathlib import Path
import re

GUIDE = '个微聊天记录解析工具说明.md'
SUPPORT_DOCS = ('操作指南.md', '版本与验证说明.md')


def copy_public_guide(project, output, kind):
    for name in SUPPORT_DOCS:
        (output / name).write_text((project / 'docs/local-chat' / name).read_text(encoding='utf-8'), encoding='utf-8')
    source = (project / GUIDE).read_text(encoding='utf-8')
    body = source.split('## 10. 交付包与依据', 1)[0]
    example = re.search(r'说“解析([^”\n]+)群”', body)
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
    if kind != 'suite':
        body += '- [Start.cmd](Start.cmd)：解压后双击启动；也可按快速开始选择直接运行EXE。\n'
    if kind == 'skill':
        body += '- [SKILL.md](SKILL.md)：提供给支持本机执行的AI宿主读取。\n'
        body += '- [runtime.json](runtime.json)：随包程序位置与校验值。\n'
    body += '- [SHA256SUMS.txt](SHA256SUMS.txt)：包内文件的SHA-256校验清单。\n'
    body += '- [package.json](package.json)：分发文件清单。\n'
    body += ('- 两个独立ZIP均含 `licenses/` 运行库许可文件；选择一种方式使用即可。\n\n'
             if kind == 'suite' else '- `licenses/`：随包运行库的许可文件。\n\n')
    body += '本说明使用匿名样本描述验证范围。交付包不附带真实消息、数据库、媒体、密钥或本机设置；首次使用需在本机确认有权读取的账号，自动配置成功或手动提供匹配密钥后读取。\n'
    (output / GUIDE).write_text(body, encoding='utf-8')


def write_quick_start(output, kind):
    if kind == 'skill':
        entry = ('1. 在WorkBuddy中打开“专家·技能·连接器 → 技能 → 添加技能 → 上传技能”，选择本Skill ZIP并启用。其他宿主需支持Skill、本机命令执行及文件访问。\n'
                 '2. 新建任务，说“解析示例业务群”，把示例名称换成实际群名。\n'
                 '3. 首次登录本人微信，在弹窗确认发现的账号并点“一键自动配置”；成功后原请求自动继续，以后记住设置。已有离线副本和密钥可在手动页选择。\n'
                 '4. 也可解压完整文件夹，双击 `Start.cmd` 打开解析器。不要只复制SKILL.md。\n')
        location = 'Skill默认将设置和结果保存在当前用户 `%LOCALAPPDATA%\\LocalWechatArchive`，更新Skill后可继续复用。'
    else:
        entry = ('1. 将整个ZIP解压到本人可写的普通文件夹，保留文件结构。\n'
                 '2. 双击 `Start.cmd`，或直接双击 `local-chat-desktop.exe`。无需打开命令行。\n'
                 '3. 首次登录本人微信，在自动配置页确认发现的账号，点“一键自动配置”，成功后从左侧选群；已有离线副本和密钥也可手选。\n'
                 '4. 点“图片总览”集中看图、放大或定位原消息；转发点箭头展开；文件点“打开附件”；需要保存时点“解析并导出”。\n')
        location = '独立桌面版默认将设置和结果保存在程序旁的 `local-chat-data` 中。'
    text = '# 本地微信聊天解析：快速开始\n\n' + entry + '\n'
    text += '完整步骤见 [操作指南](操作指南.md)，版本与实测范围见 [版本与验证说明](版本与验证说明.md)。\n\n'
    text += '**免安装**：支持目标为Windows 10/11 x64，运行库已随EXE提供，不用安装Python、pip、Docker或数据库服务。另一台物理电脑及Windows 11尚未实测。\n\n'
    text += location + '\n\n'
    text += '数据目录一般是单个账号的 `xwechat_files\\账号目录\\db_storage`。数据库密钥选已有密钥JSON，不是微信密码、聊天导出或程序设置JSON；图片密钥是另一类解密信息。微信不会自动提供这些密钥文件。自动配置会尝试恢复并校验后保存在本机工作目录 keys 中；未登录、布局不支持或只有离线密文时可能失败。具体目录示例见完整说明。\n\n'
    text += '导出后可打开 `images.html` 查看图片卡片总览，包含普通、嵌套转发和引用图片，原图、缩略图、缺失与未加载分别标注，并能回到原消息。整份导出目录与 `assets/` 应一起保留。\n\n'
    text += '结果按 `mediaSummaryText` 分开报告原图、缩略图、缺失图片、附件和表情。按普通消息、转发及引用的出现次数统计，同一文件可能重复；单位是引用处数，不是不同图片张数。未加载媒体不当成缺失。\n\n'
    text += '程序生成 `解析结果.md` 固定汇报，附件类型数量由程序计算。Skill原样汇报，并在WorkBuddy同时提供JSONL、JSON、MD三种文件入口；宿主无法呈现时保留本地链接并说明。\n\n'
    text += '每次解析/导出同时生成 `messages.jsonl`（逐行消息）、`messages.json`（完整消息数组）、`messages.md`（可读记录及相对媒体链接），不需要格式转换环境。桌面下方选择 MD / JSON / JSONL，点“查看导出文件”；没有默认关联时会尝试系统记事本。在WorkBuddy可说“导出某群为JSONL、JSON和MD”，默认复用已保存配置。\n\n'
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
