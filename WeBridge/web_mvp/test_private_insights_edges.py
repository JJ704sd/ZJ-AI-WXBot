"""Synthetic edge tests for verified message references."""
import unittest

try:
    from private_insights import resolve_message_reference, search_messages
except ModuleNotFoundError:  # ``python -m unittest web_mvp.test_private_insights_edges``
    from web_mvp.private_insights import resolve_message_reference, search_messages


class PrivateInsightsReferenceTests(unittest.TestCase):
    def test_resolve_uses_verified_refs_and_none_for_raw_or_invalid_values(self):
        source = {"analysisRefs": {
            "text-id": 12,
            "numeric-id": 34,
            "101": 35,
            "raw-only": 56,
            "zero": 0,
            "negative": -1,
            "boolean": True,
            "text-ref": "78",
        }}
        self.assertEqual(resolve_message_reference(source, {
            "id": "text-id", "ref": 999,
        }), ("text-id", 12))
        self.assertEqual(resolve_message_reference(source, {
            "id": 101, "ref": 999,
        }), (101, 35))
        self.assertEqual(resolve_message_reference(source, {
            "id": None, "messageId": "numeric-id", "ref": 999,
        }), ("numeric-id", 34))
        self.assertEqual(resolve_message_reference(source, {
            "id": "raw-only", "ref": 999,
        }), ("raw-only", 56))
        for message_id in ("zero", "negative", "boolean", "text-ref"):
            with self.subTest(message_id=message_id):
                self.assertEqual(resolve_message_reference(source, {
                    "id": message_id, "ref": 999,
                }), (message_id, None))

    def test_search_keeps_message_id_when_reference_is_unmapped(self):
        source = {
            "analysisRefs": {"m-text": 7, "m-number": 8},
            "messages": [
                {"id": "m-text", "ref": 700, "text": "needle"},
                {"id": None, "messageId": "m-number", "ref": 800, "text": "needle"},
                {"id": "m-missing", "ref": 900, "text": "needle"},
            ],
        }
        result = search_messages(source, "needle")
        self.assertEqual([(item["messageId"], item["ref"]) for item in result["items"]], [
            ("m-text", 7), ("m-number", 8), ("m-missing", None),
        ])


if __name__ == "__main__":
    unittest.main()
