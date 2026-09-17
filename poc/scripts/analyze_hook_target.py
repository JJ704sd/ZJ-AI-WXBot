"""Analyze an explicitly selected installed DLL as data; never load it."""
from __future__ import annotations

import argparse
from datetime import datetime, timezone
import json
from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from wechat_agent_poc.hook_target_analysis import analyze_target

# Reference values only, never proposed as 4.1.13.65 offsets.
LEGACY_RVAS = {"DoAddMsg": 0x179D6EF, "GetCoroCtx": 0x42010, "GetMsgSvc": 0x334780,
               "GetMsgCtx": 0x6C7A80, "DoSend": 0x1788AF0, "SendEntry": 0x17419E0,
               "MsgCtor": 0x72E830}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--dll", required=True, type=Path)
    parser.add_argument("--output", required=True, type=Path)
    args = parser.parse_args()
    try:
        result = analyze_target(args.dll.read_bytes(), LEGACY_RVAS)
        result["checked_at"] = datetime.now(timezone.utc).isoformat()
        result["legacy_source"] = "navysoto/wxhook@fbccd52713f8cc7cd1023f852bf625af4fe38624:WeixinOffsets.cs"
        with args.output.open("x", encoding="utf-8") as stream:
            json.dump(result, stream, indent=2)
            stream.write("\n")
    except (ValueError, OSError) as exc:
        print(f"analysis_failed: {type(exc).__name__}", file=sys.stderr)
        return 2
    print("static_analysis_only; runtime_offsets_verified=false")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
