"""Program-authored completion wording and host file presentation arguments."""
import html
from pathlib import Path
import re
from urllib.parse import quote

from offline_media_summary import attachment_type_text

REPORT_FILE = '解析结果.md'


def completion_report(destination, report):
    destination = Path(destination)
    name = re.sub(r'([\\`*_\[\]#!|])', r'\\\1', html.escape(str(report['chat']['name']), quote=False))
    def link(label, relative):
        return '[' + label + '](<' + quote((destination / relative).as_posix(), safe='/:') + '>)'
    formats = list(report['messageExports'].items())
    markdown = ('已完成“' + name + '”的本地记录解析。\n\n'
                f'源记录 {report["exportedRows"]} 条，业务阅读 {report["businessRows"]} 条。'
                + ('已达到条数限制，结果不完整。' if report['truncatedByLimit'] else '当前筛选范围已导出完毕。')
                + '\n\n' + report['mediaSummaryText'] + '\n\n'
                + attachment_type_text(report['mediaSummary']) + '\n\n'
                + '三种导出文件：' + ' · '.join(link(kind.upper(), path) for kind, path in formats) + '\n\n'
                + link('阅读视图', 'chat.html') + ' · ' + link('图片总览', report['imageGalleryFile']) + '\n\n'
                + '缺失图片没有可显示文件；缩略图只有预览，原图未取得；未加载尚未核查，不能当成缺失。'
                  '表情缺失不阻塞业务阅读。MD须与同目录 assets/ 一起保存；完整原始字段以JSONL/JSON为准。\n')
    return {'version': 1, 'markdownFile': str(destination / REPORT_FILE), 'replyMarkdown': markdown,
            'presentation': {'cwd': str(destination),
                             'explanation': '展示程序统计及 JSONL、JSON、MD 三种导出文件与阅读入口。',
                             'files': [str(destination / relative) for relative in
                                       [path for _, path in formats] + [REPORT_FILE, 'chat.html',
                                        report['imageGalleryFile'], report['businessReadingFile']]]}}
