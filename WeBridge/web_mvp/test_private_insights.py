"""Synthetic tests for the read-only private chat statistics module."""
import json
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch

try:
    from private_insights import search_messages, summarize, write_report
except ModuleNotFoundError:  # ``python -m unittest web_mvp.test_private_insights``
    from web_mvp.private_insights import search_messages, summarize, write_report


def _source():
    return {
        "identity": {"client": "wechat", "accountKey": "acct-test", "peerId": "peer-test"},
        "chat": {"id": "peer-test", "name": "<合成联系人>"},
        "reviewId": "review-test",
        "sourceDigest": "digest-test",
        "sourceLimitations": ["仅合成数据"],
        "timeRange": {"start": "2026-10-01", "end": "2026-10-31"},
        "analysisRefs": {"m1": 101, "m2": 102, "m3": 103},
        "messages": [
            {"id": "m1", "time": "2026-10-01T00:30:00+08:00", "senderName": "甲",
             "direction": "incoming", "kind": "text", "text": "Need <报价>"},
            {"id": "m2", "time": "2026-10-01T16:00:00", "senderName": "我",
             "direction": "outgoing", "kind": "text", "text": "收到😀"},
            {"id": "m3", "time": "坏日期", "senderName": "甲",
             "direction": "mystery", "kind": "emoji", "text": "😀"},
            {"id": "m4", "time": "", "senderName": "甲", "kind": "file", "text": "附件",
             "parseStatus": "failed", "decodeStatus": "failed"},
        ],
    }


class PrivateInsightsTests(unittest.TestCase):
    def test_summarize_counts_dates_emoji_and_gaps_without_epoch(self):
        result = summarize(_source())
        self.assertEqual(result["totalMessages"], 4)
        self.assertEqual(result["counts"]["outgoing"], 1)
        self.assertEqual(result["counts"]["incoming"], 1)
        self.assertEqual(result["counts"]["unknown"], 2)
        self.assertEqual(result["counts"]["emoji"], 1)
        self.assertEqual(result["counts"]["nonEmoji"], 3)
        self.assertEqual(result["activeDays"], 1)
        self.assertEqual(result["byDay"], {"2026-10-01": 2})
        self.assertEqual(result["byMonth"], {"2026-10": 2})
        self.assertEqual(result["byHour"]["00"], 1)
        self.assertEqual(result["unknownTimeCount"], 1)
        self.assertEqual(result["invalidTimeCount"], 1)
        self.assertEqual(result["gaps"], {"parse": 1, "decode": 1})
        self.assertEqual(result["observedTimeRange"], {
            "start": "2026-10-01T00:30:00+08:00", "end": "2026-10-01T16:00:00+08:00"
        })
        self.assertEqual(result["sourceLimitations"], ["仅合成数据"])
        self.assertNotIn("1970", json.dumps(result, ensure_ascii=False))

    def test_search_is_literal_casefolded_stable_and_paged(self):
        source = _source()
        source["messages"].append({"id": "m5", "time": "2026-10-02", "senderName": "乙",
                                    "direction": "incoming", "kind": "text", "text": "NEED <报价>"})
        result = search_messages(source, "need <报价>", offset=1, limit=1)
        self.assertEqual(result["total"], 2)
        self.assertEqual(result["items"][0], {
            "messageId": "m5", "ref": None, "time": "2026-10-02",
            "senderName": "乙", "direction": "incoming", "kind": "text", "text": "NEED <报价>"
        })
        self.assertEqual(search_messages(source, "报价", offset=99, limit=50)["items"], [])
        with self.assertRaises(ValueError):
            search_messages(source, "   ")
        with self.assertRaises(ValueError):
            search_messages(source, "x" * 201)
        with self.assertRaises(ValueError):
            search_messages(source, "x", offset=-1)
        with self.assertRaises(ValueError):
            search_messages(source, "x", limit=201)

    def test_extreme_timezone_conversion_is_an_invalid_gap(self):
        source = _source()
        source["messages"].append({
            "id": "overflow", "time": "9999-12-31T23:59:59-12:00",
            "senderName": "甲", "direction": "incoming", "kind": "text",
            "text": "极端时间",
        })
        result = summarize(source)
        self.assertEqual(result["invalidTimeCount"], 2)
        self.assertNotIn("overflow", result["byDay"])

    def test_write_report_creates_three_files_escapes_and_refuses_existing(self):
        source = _source()
        summary = summarize(source)
        summary["sourceLimitations"] = ["<script>alert('x')</script>"]
        with tempfile.TemporaryDirectory(prefix="private-insights-") as root:
            target = Path(root) / "report"
            result = write_report(summary, target)
            self.assertTrue(all(Path(result[key]).is_file() for key in ("jsonFile", "markdownFile", "htmlFile")))
            html = Path(result["htmlFile"]).read_text(encoding="utf-8")
            markdown = Path(result["markdownFile"]).read_text(encoding="utf-8")
            self.assertIn("&lt;script&gt;", html)
            self.assertNotIn("<script>alert", html)
            self.assertNotIn("Need &lt;报价&gt;", html)
            for marker in ("wechat", "合成联系人", "review-test", "digest-test", "活跃日", "parse 缺口", "消息类型"):
                self.assertIn(marker, html)
                self.assertIn(marker, markdown)
            with self.assertRaises(FileExistsError):
                write_report(summary, target)

    def test_write_report_cleans_partial_files_at_each_write_boundary_and_allows_retry(self):
        summary = summarize(_source())
        original_write_text = Path.write_text
        for failure_index in range(3):
            with self.subTest(failure_index=failure_index):
                with tempfile.TemporaryDirectory(prefix="private-insights-failure-") as root:
                    target = Path(root) / "report"
                    calls = {"count": 0}

                    def fail_at_boundary(path, data, *args, **kwargs):
                        index = calls["count"]
                        calls["count"] += 1
                        if index == failure_index:
                            # Leave a real partial file behind before raising.
                            path.parent.mkdir(parents=True, exist_ok=True)
                            with path.open("w", encoding="utf-8") as handle:
                                handle.write(data[:7])
                            raise OSError("synthetic write boundary failure")
                        return original_write_text(path, data, *args, **kwargs)

                    with patch.object(Path, "write_text", fail_at_boundary):
                        with self.assertRaises(OSError):
                            write_report(summary, target)
                    self.assertFalse(target.exists())
                    retry = write_report(summary, target)
                    self.assertTrue(all(Path(retry[key]).is_file()
                                        for key in ("jsonFile", "markdownFile", "htmlFile")))


if __name__ == "__main__":
    unittest.main()
