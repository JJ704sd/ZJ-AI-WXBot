"""Compare explicit local metadata JSON files; no network or process access."""
from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from wechat_agent_poc.hook_compatibility import check_compatibility


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--observed", type=Path, required=True)
    parser.add_argument("--candidate", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    try:
        result = check_compatibility(
            json.loads(args.observed.read_text(encoding="utf-8-sig")),
            json.loads(args.candidate.read_text(encoding="utf-8-sig")),
        )
        # Exclusive creation protects existing evidence and input files.
        with args.output.open("x", encoding="utf-8") as stream:
            json.dump(result, stream, ensure_ascii=False, indent=2)
            stream.write("\n")
    except (ValueError, OSError) as exc:
        print(f"validation_failed: {type(exc).__name__}", file=sys.stderr)
        return 2
    print(result["compatibility_status"])
    return 0 if result["compatibility_status"] == "match" else 1


if __name__ == "__main__":
    raise SystemExit(main())
