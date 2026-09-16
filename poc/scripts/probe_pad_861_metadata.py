"""Bounded anonymous loopback metadata probe. Never calls an MCP tool or logs a session URL."""
from __future__ import annotations

import argparse
import json
import queue
import threading
import time
from pathlib import Path
from urllib.error import HTTPError
from urllib.parse import urljoin, urlsplit, urlunsplit
from urllib.request import HTTPRedirectHandler, ProxyHandler, Request, build_opener

BASE = "http://127.0.0.1:8098"
LIMIT = 2 * 1024 * 1024
PROGRESS = {}


class NoRedirect(HTTPRedirectHandler):
    def redirect_request(self, req, fp, code, msg, headers, newurl):
        return None


def loopback_endpoint(value):
    parsed = urlsplit(urljoin(BASE + "/", value))
    if (parsed.scheme != "http" or parsed.hostname not in {"127.0.0.1", "localhost"}
            or parsed.port != 8098 or parsed.username or parsed.password or parsed.fragment):
        raise ValueError("SSE endpoint escaped the exact loopback origin")
    return urlunsplit(("http", "127.0.0.1:8098", parsed.path, parsed.query, ""))


def probe():
    opener = build_opener(ProxyHandler({}), NoRedirect())
    events = queue.Queue()
    report = PROGRESS
    report.update({"anonymous": True, "tools_call_executed": False, "business_write_executed": False, "stage": "sse"})

    def read_sse():
        try:
            with opener.open(Request(BASE + "/sse", headers={"Accept": "text/event-stream"}), timeout=4) as response:
                events.put(("http", response.status))
                kind, data, size = "message", [], 0
                while size < LIMIT:
                    line = response.readline(LIMIT + 1)
                    size += len(line)
                    if not line:
                        break
                    line = line.decode("utf-8").rstrip("\r\n")
                    if not line:
                        events.put((kind, "\n".join(data)))
                        kind, data = "message", []
                    elif line.startswith("event:"):
                        kind = line[6:].strip()
                    elif line.startswith("data:"):
                        data.append(line[5:].lstrip())
        except Exception as exc:
            events.put(("reader_end", type(exc).__name__))

    thread = threading.Thread(target=read_sse, daemon=True)
    thread.start()
    endpoint = None
    deadline = time.monotonic() + 5
    while time.monotonic() < deadline:
        kind, value = events.get(timeout=5)
        if kind == "http":
            report["sse_http_status"] = value
        if kind == "endpoint":
            endpoint = urljoin(BASE + "/", value)
            parsed = urlsplit(endpoint)
            report["endpoint_origin"] = {"scheme": parsed.scheme, "host": parsed.hostname, "port": parsed.port}
            endpoint = loopback_endpoint(value)
            break
        if kind == "reader_end":
            raise RuntimeError("SSE ended before endpoint")
    if not endpoint:
        raise RuntimeError("no SSE endpoint within deadline")

    def rpc(method, request_id=None, params=None):
        report["stage"] = method
        if method not in {"initialize", "notifications/initialized", "tools/list"}:
            raise ValueError("metadata-only method allowlist")
        payload = {"jsonrpc": "2.0", "method": method}
        if request_id is not None:
            payload["id"] = request_id
        if params is not None:
            payload["params"] = params
        request = Request(endpoint, data=json.dumps(payload).encode(), headers={"Content-Type": "application/json"}, method="POST")
        with opener.open(request, timeout=3) as response:
            report.setdefault("post_status", {})[method] = response.status
            response.read(4096)
        if request_id is None:
            return {}
        until = time.monotonic() + 4
        while time.monotonic() < until:
            kind, value = events.get(timeout=max(0.01, until - time.monotonic()))
            if kind == "reader_end":
                raise RuntimeError("SSE response unavailable")
            if kind != "message":
                continue
            obj = json.loads(value)
            if obj.get("id") == request_id:
                return obj
        raise TimeoutError("RPC metadata response deadline")

    init = rpc("initialize", 1, {"protocolVersion": "2024-11-05", "capabilities": {}, "clientInfo": {"name": "pad861-metadata-probe", "version": "1"}})
    report["initialize"] = {"result_present": "result" in init, "error_code": init.get("error", {}).get("code"),
                            "protocol_version": init.get("result", {}).get("protocolVersion")}
    if "result" in init:
        rpc("notifications/initialized")
        listed = rpc("tools/list", 2)
        result = listed.get("result", {})
        report["tools_list"] = {"result_present": "result" in listed, "error_code": listed.get("error", {}).get("code"),
                                "has_next_cursor": bool(result.get("nextCursor")),
                                "tools": [{"name": t.get("name"),
                                           "argument_names": sorted(t.get("inputSchema", {}).get("properties", {})),
                                           "required": t.get("inputSchema", {}).get("required", [])}
                                          for t in result.get("tools", [])]}
    for path in ("/login/GetLoginStatus", "/equipment/GetOnlineInfo", "/webhook/Status"):
        report["stage"] = path
        request = Request("http://127.0.0.1:1238" + path)
        try:
            response = opener.open(request, timeout=3)
        except HTTPError as exc:
            response = exc
        with response:
            raw = response.read(8192)
            try:
                body = json.loads(raw)
                summary = {k: body[k] for k in ("Code", "code", "Success", "success", "Message", "message", "Text", "text") if k in body}
            except (ValueError, TypeError):
                summary = {"json": False}
            report.setdefault("anonymous_http", []).append({"path": path, "http_status": response.status, "response": summary})
    thread.join(timeout=5)
    report["stage"] = "complete"
    return report


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    try:
        result = probe()
    except Exception as exc:
        result = PROGRESS | {"probe_error_type": type(exc).__name__, "tools_call_executed": False}
    args.output.write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(result, ensure_ascii=False))
    raise SystemExit(2 if "probe_error_type" in result else 0)
