"""Read the pinned archive without extraction, execution, credentials or network."""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
import zipfile

ARCHIVE_SHA256 = "4500ab14ac22b71146705ed2dc0046af4ee6ed555a617ba99430e1e1546d9430"
PATHS = (
    "/login/GetLoginStatus", "/equipment/GetOnlineInfo",
    "/group/GetChatRoomInfo", "/group/GetChatroomMemberDetail",
    "/qy/QWGetChatRoomMember", "/qy/QWGetChatroomInfo",
    "/message/HttpSyncMsg", "/ws/GetSyncMsg", "/other/GetRedisSyncMsg",
    "/message/SendTextMessage", "/webhook/Config", "/webhook/Status",
    "/webhook/ResetConnection", "/webhook/Update",
)


def audit(path: Path) -> dict:
    digest = hashlib.sha256(path.read_bytes()).hexdigest()
    if digest != ARCHIVE_SHA256:
        raise ValueError("archive does not match the pinned Windows 861 build")
    with zipfile.ZipFile(path) as archive:
        names = [n for n in archive.namelist() if n.endswith("static/swagger/swagger.json")]
        if len(names) != 1:
            raise ValueError("expected exactly one bundled Swagger JSON")
        raw = archive.read(names[0])
    doc = json.loads(raw)
    definitions = doc.get("definitions", {})
    selected = {p: doc["paths"][p] for p in PATHS if p in doc["paths"]}
    resolved = {}
    missing = set()

    def visit(value):
        if isinstance(value, dict):
            ref = value.get("$ref")
            if ref:
                name = ref.removeprefix("#/definitions/")
                if not ref.startswith("#/definitions/") or name not in definitions:
                    missing.add(ref)
                elif name not in resolved:
                    resolved[name] = definitions[name]
                    visit(definitions[name])
            for item in value.values():
                visit(item)
        elif isinstance(value, list):
            for item in value:
                visit(item)

    visit(selected)
    return {
        "schema_version": "pad-861-contract-audit/1",
        "evidence_level": "bundled_document_not_live",
        "archive_sha256": digest,
        "swagger_sha256": hashlib.sha256(raw).hexdigest(),
        "base_path": doc.get("basePath"),
        "operations": selected,
        "referenced_definitions": resolved,
        "unresolved_refs": sorted(missing),
        "invalid_methods": [f"{p}: {m}" for p, ops in selected.items() for m in ops
                            if m not in {"get", "post", "put", "patch", "delete", "head", "options", "parameters"}],
        "missing_response_schema": [f"{m.upper()} {p} {code}" for p, ops in selected.items()
                                    for m, op in ops.items() for code, response in op.get("responses", {}).items()
                                    if "schema" not in response],
        "network": False, "gateway_executed": False, "live_verified": False,
    }


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("archive", type=Path)
    parser.add_argument("--output", required=True, type=Path)
    args = parser.parse_args()
    result = audit(args.archive)
    args.output.write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({"output": str(args.output), "operations": len(result["operations"]),
                      "invalid_methods": result["invalid_methods"], "unresolved_refs": result["unresolved_refs"]}))
