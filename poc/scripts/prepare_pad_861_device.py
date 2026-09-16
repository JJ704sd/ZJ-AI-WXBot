"""Attempt one one-day device via the local API, which may require upstream authorization.

No login, QR, model or message request. An intent receipt prevents automatic retries.
The gateway's outbound policy is owned by the caller; this script never changes it.
"""
from __future__ import annotations

import argparse
import json
from pathlib import Path
from urllib.parse import urlencode
from urllib.request import ProxyHandler, Request, build_opener

from probe_pad_861_metadata import NoRedirect


def prepare(root, *, network_trial=False, transport_trial=False, late_response_trial=False, tutorial_native_trial=False, pinned_trial=False):
    if sum((network_trial, transport_trial, late_response_trial, tutorial_native_trial, pinned_trial)) > 1:
        raise ValueError("choose one trial")
    prefix = "device-late-response-trial" if late_response_trial else ("device-transport-trial" if transport_trial else ("device-network-trial" if network_trial else "device-creation"))
    if tutorial_native_trial:
        prefix = "device-tutorial-native-trial"
    if pinned_trial:
        prefix = "device-pinned-trial"
    receipt = root / (prefix + "-private.json")
    intent = root / (prefix + "-intent.json")
    if receipt.exists() or intent.exists():
        raise ValueError("device preparation already attempted; inspect local receipt, never retry blindly")
    key = next(line.partition("=")[2].strip() for line in (root / "runtime" / ".env").read_text(encoding="utf-8-sig").splitlines() if line.startswith("ADMIN_KEY="))
    opener = build_opener(ProxyHandler({}), NoRedirect())
    suffix = "?" + urlencode({"key": key})
    with opener.open("http://127.0.0.1:1238/admin/GetAllDevices" + suffix, timeout=3) as response:
        inventory = json.loads(response.read(256 * 1024))
    if inventory.get("Code") != 200 or inventory.get("Data", {}).get("devices") != []:
        raise ValueError("expected verified empty device inventory")
    with intent.open("x", encoding="utf-8") as stream:
        json.dump({"endpoint": "/admin/GenAuthKey1", "count": 1, "days": 1, "status": "attempted_no_automatic_retry", "network_trial": network_trial, "transport_trial": transport_trial, "late_response_trial": late_response_trial}, stream)
    request = Request("http://127.0.0.1:1238/admin/GenAuthKey1" + suffix,
                      data=json.dumps({"Count": 1, "Days": 1, "Remark": "local-single-account-readonly-poc"}).encode(),
                      headers={"Content-Type": "application/json"}, method="POST")
    with opener.open(request, timeout=15 if tutorial_native_trial or pinned_trial else (10 if network_trial or transport_trial or late_response_trial else 5)) as response:
        raw = response.read(256 * 1024 + 1)
        if len(raw) > 256 * 1024:
            raise ValueError("oversized response")
        receipt.write_bytes(raw)
        body = json.loads(raw)
        data = body.get("Data")
        result = {"http_status": response.status, "code": body.get("Code"), "data_type": type(data).__name__,
                  "data_fields": sorted(data) if isinstance(data, dict) else [], "login_executed": False,
                  "qr_requested": False, "message_calls": 0, "credential_receipt": receipt.name}
        if isinstance(data, list):
            result["data_items"] = len(data)
        return result


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", required=True, type=Path)
    parser.add_argument("--network-trial", action="store_true", help="Separately authorized single attempt; preserves earlier offline receipts")
    parser.add_argument("--tutorial-native-trial", action="store_true")
    args = parser.parse_args()
    try:
        result = prepare(args.output.parent, network_trial=args.network_trial, tutorial_native_trial=args.tutorial_native_trial)
    except Exception as exc:
        result = {"error_type": type(exc).__name__, "login_executed": False, "qr_requested": False, "message_calls": 0}
    args.output.write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(result, ensure_ascii=False))
    raise SystemExit(2 if "error_type" in result or result.get("code") != 200 else 0)
