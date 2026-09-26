#!/usr/bin/env python3
"""Local read-only checks for the dedicated Linux WeChat test container."""
import argparse
import base64
import json
import os
from pathlib import Path
import urllib.error
import urllib.parse
import urllib.request

ROOT = Path(__file__).resolve().parents[1]
BASE = "http://127.0.0.1:16174"
TOKEN = ROOT / ".secrets/linux-token"


def request(path):
    token = TOKEN.read_text().strip()
    req = urllib.request.Request(BASE + path, headers={"Authorization": "Bearer " + token})
    # A loopback test service must not use a system HTTP proxy.
    with urllib.request.build_opener(urllib.request.ProxyHandler({})).open(req, timeout=45) as response:
        return json.load(response)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("command", choices=["health", "auth", "screenshot", "a11y", "chats", "messages"])
    parser.add_argument("--chat-id")
    args = parser.parse_args()
    paths = {"health": "/health", "auth": "/api/status/auth", "a11y": "/api/debug/a11y?format=aria", "chats": "/api/chats?limit=100"}
    if args.command == "screenshot":
        result = request("/api/debug/screenshot")
        data = base64.b64decode(result["base64"], validate=True)
        if not data.startswith(b"\x89PNG\r\n\x1a\n"):
            raise ValueError("Expected a PNG screenshot")
        folder = ROOT / ".runtime"
        folder.mkdir(mode=0o700, exist_ok=True)
        path = folder / "linux-screen.png"
        path.write_bytes(data)
        os.chmod(path, 0o600)
        print(path)
    elif args.command == "messages":
        if not args.chat_id:
            parser.error("messages requires --chat-id for the confirmed test conversation")
        print(json.dumps(request("/api/messages/" + urllib.parse.quote(args.chat_id, safe="") + "?limit=100"), ensure_ascii=False, indent=2))
    else:
        print(json.dumps(request(paths[args.command]), ensure_ascii=False, indent=2))


if __name__ == "__main__":
    try:
        main()
    except (OSError, ValueError, KeyError) as exc:
        raise SystemExit(f"Linux lab check failed: {exc}")
