"""Synthetic, data-free checks for the private-insights Tk surface."""
from __future__ import annotations

import json
import queue
import threading
import unittest

try:
    from private_insights_ui import (_SearchTask, _evidence_text, _material_view_model,
                                     _calendar_model, _random_review, _daily_values, _hour_values,
                                     _trend_values, _stats,
                                     QUICK_TERMS,
                                     show_insights, show_material_request)
except ModuleNotFoundError:  # ``python -m unittest web_mvp.test_private_insights_ui``
    from web_mvp.private_insights_ui import (_SearchTask, _evidence_text,
                                             _material_view_model, _calendar_model,
                                             _random_review, _daily_values, _hour_values,
                                             _trend_values, _stats,
                                             QUICK_TERMS, show_insights,
                                             show_material_request)


def _source():
    return {
        "identity": {"client": "wechat", "accountKey": "synthetic", "peerId": "peer-1"},
        "chat": {"id": "peer-1", "name": "<合成联系人>"},
        "timeRange": {"start": "2026-10-01", "end": "2026-10-31"},
        "sourceLimitations": ["仅合成材料"],
        "analysisRefs": {"m1": 1},
        "messages": [
            {"id": "m1", "ref": 1, "time": "2026-10-01T09:00:00+08:00",
             "senderName": "甲", "direction": "incoming", "kind": "text",
             "text": "Need <script>alert(1)</script>"},
            {"id": "m2", "time": "2026-10-01T10:00:00+08:00",
             "senderName": "我", "direction": "outgoing", "kind": "text", "text": "Need second"},
        ],
    }


class PrivateInsightsUITests(unittest.TestCase):
    def test_background_search_task_filters_and_returns_bounded_page(self):
        source = _source()
        for index in range(3, 122):
            source["messages"].append({"id": f"m{index}", "text": "Need synthetic",
                                        "direction": "incoming", "kind": "text"})
        results = queue.Queue()
        task = _SearchTask(source, "need", offset=50, limit=50, result_queue=results, generation=7)
        task.start()
        generation, result, error = results.get(timeout=2)
        self.assertIsNone(error)
        self.assertEqual(generation, 7)
        self.assertEqual(result["total"], 121)
        self.assertEqual(len(result["items"]), 50)
        self.assertEqual(result["items"][0]["messageId"], "m51")

    def test_evidence_is_json_text_and_material_view_model_is_compact(self):
        row = _source()["messages"][0]
        evidence = _evidence_text(row, ref=1)
        self.assertIn("原文：", evidence)
        self.assertIn("Need <script>alert(1)</script>", evidence)
        self.assertNotIn("\\u003c", evidence)
        long_text = _evidence_text({"id": "long", "text": "x" * 200001})
        self.assertIn("已截断；完整内容请查看原导出", long_text)
        self.assertLessEqual(len(long_text.split("原文：\n", 1)[1].split("\n\n[原文", 1)[0]), 200000)
        material = _material_view_model({
            "status": "ready", "client": "wechat", "peerId": "peer-1",
            "delta": {"status": "ready", "mode": "changed_chunks", "new": ["a"],
                      "overlap": ["b"], "changed": []},
            "sources": [{"allowedRefs": [1, 2, 3], "chunks": ["analysis/part-1.md"]}],
            "requiredChunks": ["analysis/part-1.md"],
            "materialFiles": ["C:\\synthetic\\part-1.md"],
        })
        self.assertEqual(material["status"], "ready")
        self.assertEqual(material["coverage"], 3)
        self.assertEqual(material["deltaNew"], 1)
        self.assertEqual(material["materialFiles"], ["C:\\synthetic\\part-1.md"])

    def test_material_view_model_keeps_current_profile_and_blocks_unchanged_candidate_hint(self):
        material = _material_view_model({
            "status": "unchanged", "client": "wechat", "peerId": "peer-1",
            "currentProfileFile": "C:\\synthetic\\current\\profile.json",
            "delta": {"status": "unchanged", "mode": "changed_chunks", "new": [],
                      "overlap": ["a"], "changed": []},
            "materialFiles": ["C:\\synthetic\\part-1.md"],
        })
        self.assertEqual(material["currentProfileFile"],
                         "C:\\synthetic\\current\\profile.json")
        self.assertFalse(material["canGenerateCandidate"])
        self.assertIn("无需生成画像候选", material["candidateHint"])

        ready = _material_view_model({"status": "ready", "delta": {"status": "ready"}})
        self.assertTrue(ready["canGenerateCandidate"])
        self.assertIn("可由宿主分析材料后生成候选", ready["candidateHint"])

    def test_tk_entrypoints_are_available_without_implicit_file_io(self):
        self.assertTrue(callable(show_insights))
        self.assertTrue(callable(show_material_request))

    def test_calendar_uses_only_selected_export_daily_counts(self):
        summary = {"byDay": {"2026-10-01": 3, "2026-10-31": 1, "2026-11-01": 99}}
        model = _calendar_model(summary, 2026, 10)
        self.assertEqual(model["month"], "2026-10")
        self.assertEqual(model["days"][1]["count"], 3)
        self.assertEqual(model["days"][31]["count"], 1)
        self.assertNotIn(99, [item["count"] for item in model["days"].values()])

    def test_random_review_returns_only_observable_message_evidence(self):
        class FirstChoice:
            @staticmethod
            def choice(items):
                return items[0]
        row = _random_review(_source(), rng=FirstChoice)
        self.assertEqual(set(row), {"messageId", "ref", "time", "direction", "senderName", "text"})
        self.assertEqual(row["messageId"], "m1")
        self.assertEqual(row["ref"], 1)
        self.assertEqual(row["senderName"], "甲")
        self.assertNotIn("score", row)
        self.assertEqual(tuple(QUICK_TERMS), ("方案", "下周", "发你", "确认"))

    def test_chart_values_are_derived_only_from_summary(self):
        summary = {"byDay": {"2026-10-02": 4, "2026-10-01": 2, "future": "ignored"},
                   "byHour": {"09": 3, "23": 1, "bad": 999}}
        self.assertEqual(_daily_values(summary), [("2026-10-01", 2), ("2026-10-02", 4)])
        hours = _hour_values(summary)
        self.assertEqual(len(hours), 24)
        self.assertEqual(hours[9], ("09", 3))
        self.assertEqual(hours[23], ("23", 1))

    def test_long_trend_uses_bounded_month_or_year_buckets(self):
        daily = {f"2020-01-{day:02d}": 1 for day in range(1, 64)}
        monthly = {f"{year}-{month:02d}": 3 for year in range(2020, 2026) for month in range(1, 13)}
        grain, values = _trend_values({"byDay": daily, "byMonth": monthly})
        self.assertEqual(grain, "按年（连续桶）")
        self.assertEqual(len(values), 6)

    def test_auxiliary_stats_keep_unknown_direction_visible(self):
        rows = _stats({"counts": {"total": 4, "outgoing": 1, "incoming": 1,
                                   "unknown": 2, "emoji": 0},
                       "gaps": {"parse": 0, "decode": 0}})
        self.assertEqual(next(value for label, value, _hint in rows if label == "未知方向"), "2")


if __name__ == "__main__":
    unittest.main()
