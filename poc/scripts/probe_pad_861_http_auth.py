"""Compare missing/invalid admin keys and count local devices; no login or mutation."""
from __future__ import annotations

import argparse
import json
from pathlib import Path
from urllib.error import HTTPError
from urllib.parse import urlencode
from urllib.request import ProxyHandler, Request, build_opener

from probe_pad_861_metadata import NoRedirect


def probe(root: Path):
    env = {}
    for line in (root / "runtime" / ".env").read_text(encoding="utf-8-sig").splitlines():
        if line.startswith("ADMIN_KEY="):
            env["ADMIN_KEY"] = line.partition("=")[2].strip()
    key = env.get("ADMIN_KEY")
    if not key:
        raise ValueError("missing prepared administrator key")
    opener = build_opener(ProxyHandler({}), NoRedirect())
    result = {"schema_version": "pad-861-http-auth-probe/1", "login_executed": False, "writes": 0, "requests": []}
    for label, query_key, path in (
        ("missing", None, "/admin/GetAllDevices"),
        ("invalid", "invalid-local-probe-not-an-account", "/admin/GetAllDevices"),
        ("prepared_admin", key, "/admin/GetAllDevices"),
        ("invalid", "invalid-local-probe-not-an-account", "/login/GetLoginStatus"),
    ):
        url = "http://127.0.0.1:1238" + path
        if query_key is not None:
            url += "?" + urlencode({"key": query_key})
        try:
            response = opener.open(Request(url), timeout=3)
        except HTTPError as exc:
            response = exc
        with response:
            raw = response.read(256 * 1024 + 1)
            if len(raw) > 256 * 1024:
                raise ValueError("response too large")
            body = json.loads(raw)
            if not isinstance(body, dict):
                raise ValueError("unexpected response shape")
            data = body.get("Data", body.get("data"))
            item = {"credential_kind": label, "path": path, "http_status": response.status,
                    "top_level_fields": sorted(body), "code": body.get("Code", body.get("code")),
                    "data_type": type(data).__name__}
            if isinstance(data, list):
                item["data_item_count"] = len(data)
            elif isinstance(data, dict):
                item["data_fields"] = sorted(data)
                item["list_counts"] = {k: len(v) for k, v in data.items() if isinstance(v, list)}
            result["requests"].append(item)
    return result


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", required=True, type=Path)
    args = parser.parse_args()
    try:
        result = probe(args.output.parent)
    except Exception as exc:
        result = {"error_type": type(exc).__name__, "login_executed": False, "writes": 0}
    args.output.write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(result, ensure_ascii=False))
    raise SystemExit(2 if "error_type" in result else 0)
