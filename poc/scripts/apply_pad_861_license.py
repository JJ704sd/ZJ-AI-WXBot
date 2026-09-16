"""Install operator-provided 861 credentials locally, without network or secret output."""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
import re
import socket

BUILD = "ios18.61-861 / 20250822_153444"
EXE_SHA256 = "5308323f32d4249f325a750b0c0faa91aba5b91f50593c88931d9829ffb203e9"


def parse_license(raw):
    if not isinstance(raw, dict) or set(raw) != {"api_flavor", "build_id", "credential_kind", "value"}:
        raise ValueError("expected the four-field local license input")
    if raw["api_flavor"] != "legacy" or raw["build_id"] != BUILD:
        raise ValueError("license input must explicitly target this legacy 861 build")
    kind, value = raw["credential_kind"], raw["value"]
    if kind not in {"admin_key", "device_key"}:
        raise ValueError("credential_kind must be admin_key or device_key")
    if not isinstance(value, str) or not value or len(value) > 4096 or any(c.isspace() or ord(c) < 32 for c in value):
        raise ValueError("credential is empty or malformed; contents omitted")
    return kind, value


def apply(root: Path, input_path: Path):
    kind, value = parse_license(json.loads(input_path.read_text(encoding="utf-8-sig")))
    exe = root / "runtime" / "wechatpadpro-windows-amd64-vios18.61-861.exe"
    if hashlib.sha256(exe.read_bytes()).hexdigest() != EXE_SHA256:
        raise ValueError("unexpected executable build")
    for port in (1238, 8098):
        with socket.socket() as connection:
            connection.settimeout(0.2)
            if connection.connect_ex(("127.0.0.1", port)) == 0:
                raise ValueError("stop the gateway before applying credentials")
    changed = False
    if kind == "admin_key":
        path = root / "runtime" / ".env"
        original = path.read_bytes()
        pattern = rb"(?m)^ADMIN_KEY=[^\r\n]*"
        if len(re.findall(pattern, original)) != 1:
            raise ValueError("expected exactly one ADMIN_KEY setting")
        updated = re.sub(pattern, lambda _: b"ADMIN_KEY=" + value.encode("utf-8"), original)
        if updated != original:
            backup = root / "env-before-provided-license.private"
            if backup.exists():
                raise ValueError("prior license backup exists; review before replacing a different credential")
            backup.write_bytes(original)
            temporary = path.with_name(".env.license-tmp")
            temporary.write_bytes(updated)
            temporary.replace(path)
            changed = True
    else:
        path = root / "device-key.private.json"
        if path.exists():
            previous = json.loads(path.read_text(encoding="utf-8"))
            if previous.get("value") != value:
                raise ValueError("existing device credential differs; explicit review required")
        else:
            temporary = path.with_suffix(".tmp")
            temporary.write_text(json.dumps({"value": value}), encoding="utf-8")
            temporary.replace(path)
            changed = True
    result = {"credential_kind": kind, "locally_configured": True, "changed": changed,
              "vendor_authorization_verified": False, "network": False, "login": False, "send": False}
    (root / "provided-license-result.json").write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    return result


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--input", type=Path, required=True)
    args = parser.parse_args()
    root = Path(__file__).resolve().parents[1] / ".local" / "pad-legacy-861"
    try:
        result = apply(root, args.input)
    except Exception as exc:
        # Do not echo exception messages: parsers and file APIs can contain secrets or input text.
        print(json.dumps({"applied": False, "error_type": type(exc).__name__}))
        raise SystemExit(2)
    print(json.dumps(result))
