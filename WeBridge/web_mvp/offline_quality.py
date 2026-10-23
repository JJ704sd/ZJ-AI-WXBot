"""Stream actionable content gaps alongside the immutable source evidence."""
from collections import Counter
import csv
import json

from offline_images import message_nodes

JSONL_FILE = 'content-gaps.jsonl'
CSV_FILE = '补齐清单.csv'
README_FILE = '补齐清单.md'


def document_action(status, extension):
    if status in ('encrypted', 'password_rejected'):
        return '在补齐设置按文件SHA256提供已知合法密码后重新解析，或提供解密副本；未知密码不作破解。'
    if status in ('ocr_extracted', 'ocr_unavailable'):
        return 'OCR结果须人工核对数字、单位和表格；本机不可用时请安装对应Windows OCR语言后重新解析。'
    if status == 'no_text':
        return ('检查原件是否为扫描件；需要时进行 OCR，并人工核对数字、单位和表格。'
                if extension == '.pdf' else '检查原件、图片及图表；未提取到文字不代表没有业务内容。')
    if status in ('partial', 'too_large', 'timeout', 'budget_exceeded'):
        return '核对已提取范围与原件；按页或拆分文件补充未提取部分，不能将当前正文当作全文。'
    return '用原始文件核对格式与内容；保留原件，当前正文不可作为已完整读取的依据。'


class ContentQuality:
    def __init__(self, destination):
        self.root = destination
        self.counts = Counter()
        self.quotes = Counter()
        from offline_recovery_queue import RecoveryQueue
        self.recovery_queue=RecoveryQueue()

    def __enter__(self):
        self.jsonl = (self.root / JSONL_FILE).open('x', encoding='utf8')
        try:
            self.csv_stream = (self.root / CSV_FILE).open('x', encoding='utf-8-sig', newline='')
        except BaseException:
            self.jsonl.close()
            raise
        self.csv = csv.writer(self.csv_stream)
        self.csv.writerow(['消息ID', '时间', '节点位置', '类型', '缺口', '文件名', '原因', '后续处理', '正文上下文', '文件SHA256'])
        return self

    def __exit__(self, *args):
        self.jsonl.close()
        self.csv_stream.close()

    def add(self, row):
        self.recovery_queue.add(row)
        for node, trail, path in message_nodes(row):
            codes, reasons, actions = [], [], []
            media, asset = node.get('media', {}), node.get('asset') or {}
            document = node.get('attachmentContent') or {}
            if node.get('kind') in ('image', 'file', 'video', 'voice'):
                if not asset or asset.get('status') != 'ready' or asset.get('previewOnly'):
                    code = 'media_not_checked' if not asset else 'original_unavailable'
                    codes.append(code)
                    reasons.append(asset.get('reason') or '未核查原件缓存。')
                    actions.append('在原客户端按消息时间打开原图或下载附件；也可另存到补充原件目录，再重新解析，按原件MD5校验补齐。')
            status = document.get('extractionStatus')
            if document.get('fileStatus') in ('ready','preview_only') and status and status != 'extracted':
                codes.append('document_' + status)
                reasons.extend(document.get('notices') or [document.get('extractionStatusText', status)])
                actions.append(document_action(status, document.get('format')))
            parse_status = node.get('parseStatus', 'ok')
            if parse_status not in ('ok', 'plain_system', 'partial_quote'):
                codes.append('message_partial')
                reasons.append(parse_status)
                actions.append('按消息 ID 与原客户端核对；未适配字段保留在 messages.jsonl，不能当成空消息。')
            quote = node.get('quote')
            if quote:
                linked = quote.get('sourceLinkStatus') == 'matched_local_source'
                self.quotes['linked' if linked else 'unlinked'] += 1
                if not linked:
                    codes.append('quote_unlinked')
                    reasons.append(quote.get('sourceLinkStatus') or 'source_id_unavailable')
                    actions.append('可阅读已保留的引用正文；来源未关联不能解释为无人回复，需核对同群原消息和历史范围。')
            if not codes:
                continue
            self.counts.update(codes)
            self.counts['occurrences'] += 1
            entry = {'schemaVersion': 1, 'messageId': row['id'], 'chatId': row['chatId'],
                     'time': row.get('time', ''), 'provenance': row.get('provenance', {}),
                     'nodePath': list(path), 'context': list(trail), 'kind': node.get('kind'),
                     'issues': codes, 'filename': asset.get('filename') or media.get('filename', ''),
                     'sha256': asset.get('digest', ''), 'md5': media.get('md5', ''), 'thumbnailMd5': media.get('thumbnailMd5', ''),
                     'assetStatus': asset.get('status', 'not_loaded'), 'reasonCode': asset.get('reasonCode', ''),
                     'extractionStatus': status, 'sourceLinkStatus': quote.get('sourceLinkStatus') if quote else None,
                     'reasons': reasons, 'actions': list(dict.fromkeys(actions)),
                     'textContext': str(row.get('text') or '')[:500]}
            self.jsonl.write(json.dumps(entry, ensure_ascii=False) + '\n')
            def safe(value):
                value = str(value)
                return "'" + value if value.lstrip().startswith(('=', '+', '-', '@')) else value
            self.csv.writerow(map(safe, [entry['messageId'], entry['time'], ' / '.join(trail) or '主消息',
                entry['kind'], '、'.join(codes), entry['filename'], '；'.join(reasons),
                '；'.join(entry['actions']), entry['textContext'], entry['sha256']]))

    def finish(self):
        queue=self.recovery_queue.write(self.root)
        summary = {'schemaVersion': 1, 'unit': 'reference_occurrence', 'counts': dict(self.counts),'recoveryQueue':queue,
                   'quoteLinks': {'linked': self.quotes['linked'], 'unlinked': self.quotes['unlinked'],
                                 'observed': sum(self.quotes.values()),
                                 'meaning': '来源关联覆盖，不是回复率；未关联不代表没有回复。'},
                   'jsonlFile': JSONL_FILE, 'csvFile': CSV_FILE, 'readmeFile': README_FILE}
        lines = ['# 内容补齐清单', '',
                 '记录已导出、原件已取得、正文已提取、引用已关联是分别核查的结果。'
                 '本清单按引用出现次数统计；一项可同时存在多个缺口，不代表去重文件数。', '',
                 '[用表格筛选补齐清单](补齐清单.csv) · [完整证据与节点位置](content-gaps.jsonl)', '',
                 f"[按原件归并的优先清单]({queue['csvFile']})：待补 {queue['uniqueItems']} 项，共 {queue['references']} 处引用；其中 {queue['withoutDigest']} 项无摘要，不按同名合并。", '',
                 '| 缺口 | 处数 |', '| --- | ---: |']
        labels = {'original_unavailable': '原件未取得（含仅有预览）', 'media_not_checked': '未核查媒体',
                  'message_partial': '消息结构未完整适配', 'quote_unlinked': '引用来源未关联'}
        lines.extend('| ' + labels.get(key, key) + ' | ' + str(count) + ' |'
                     for key, count in self.counts.items() if key != 'occurrences')
        lines += ['', f"已关联引用 {self.quotes['linked']} 处，未关联 {self.quotes['unlinked']} 处；不能据此计算业务响应率。", '',
                  '先按文件名、时间和消息 ID 在原客户端补下载关键报价表、截图、MSDS 等材料，再手动更新该群。'
                  '原件缺失、仅有预览与正文提取失败分别保留；扫描件 OCR 后须核对数字、币种、计费单位和有效期。'
                  '加密附件需合法密码或解密后的副本。未知格式与缺失字段不作推断。', '',
                  '跨群询价应按同一需求归并各群回复，保留日期、来源和缺失条件；不要把相同货量的多群询价直接算成独立订单。', '']
        (self.root / README_FILE).write_text('\n'.join(lines), encoding='utf8')
        return summary
