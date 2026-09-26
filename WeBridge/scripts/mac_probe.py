#!/usr/bin/env python3
"""Read-only ARM64 Mach-O probe; never attaches, loads, or changes the app.

The only write is --output. Candidate string references are not Hook addresses.
ADRP/ADD matching is deliberately limited and requires disassembler review.
"""

import argparse
import bisect
import hashlib
import json
import mmap
import pathlib
import plistlib
import re
import struct
import subprocess
import uuid
from datetime import datetime, timezone


ANCHORS = (
    "MMStartTask", "req2buf", "Req2Buf", "Buf2Resp", "buf2Resp", "buf2resp",
    "/cgi-bin/micromsg-bin/newsendmsg", "/cgi-bin/micromsg-bin/openim",
    "@im.chatroom", "@openim", "N4mars3cdn10CdnManagerE", "AutoBuffer::Write",
)


def run_readonly(args):
    result = subprocess.run(args, capture_output=True, text=True, timeout=60)
    return {"command": args, "returncode": result.returncode,
            "stdout": result.stdout[:6000], "stderr": result.stderr[:6000]}


def digest(data):
    return hashlib.sha256(data).hexdigest()


def arm_slice(data):
    magic = bytes(data[:4])
    if magic == b"\xca\xfe\xba\xbe":
        count = struct.unpack_from(">I", data, 4)[0]
        for index in range(count):
            cpu, _, offset, size, _ = struct.unpack_from(">IIIII", data, 8 + index * 20)
            if cpu == 0x0100000C:
                return offset, size
    elif magic == b"\xcf\xfa\xed\xfe" and struct.unpack_from("<I", data, 4)[0] == 0x0100000C:
        return 0, len(data)
    raise ValueError("Expected a little-endian ARM64 Mach-O or FAT32 universal file")


def parse_macho(data, base, size):
    if bytes(data[base:base + 4]) != b"\xcf\xfa\xed\xfe":
        raise ValueError("Unsupported Mach-O header")
    commands = struct.unpack_from("<I", data, base + 16)[0]
    cursor = base + 32
    sections, segments, starts = [], [], []
    function_data = None
    result = {"sections": sections, "segments": segments}
    for _ in range(commands):
        cmd, cmdsize = struct.unpack_from("<II", data, cursor)
        if cmdsize < 8 or cursor + cmdsize > base + size:
            raise ValueError("Invalid Mach-O load command")
        if cmd == 0x19:
            values = struct.unpack_from("<II16sQQQQiiII", data, cursor)
            _, _, name, va, vs, fo, fs, _, prot, count, _ = values
            segment = {"name": name.split(b"\0")[0].decode(), "vmaddr": va,
                       "vmsize": vs, "fileoff": fo, "filesize": fs, "initprot": prot}
            segments.append(segment)
            for i in range(count):
                values = struct.unpack_from("<16s16sQQIIIIIIII", data, cursor + 72 + i * 80)
                sn, sg, addr, length, off, *_ = values
                sections.append({"name": sn.split(b"\0")[0].decode(),
                                 "segment": sg.split(b"\0")[0].decode(),
                                 "addr": addr, "size": length, "offset": off})
        elif cmd == 0x1B:
            result["uuid"] = str(uuid.UUID(bytes=bytes(data[cursor + 8:cursor + 24])))
        elif cmd == 0x26:
            function_data = struct.unpack_from("<II", data, cursor + 8)
        cursor += cmdsize
    if function_data:
        off, length = function_data
        value, shift = 0, 0
        address = next(s["vmaddr"] for s in segments if s["name"] == "__TEXT")
        for byte in data[base + off:base + off + length]:
            value |= (byte & 127) << shift
            if byte & 128:
                shift += 7
            else:
                if not value:
                    break
                address += value
                starts.append(address)
                value, shift = 0, 0
    result["function_starts_count"] = len(starts)
    return result, starts


def file_to_vm(meta, offset):
    for segment in meta["segments"]:
        if segment["fileoff"] <= offset < segment["fileoff"] + segment["filesize"]:
            return segment["vmaddr"] + offset - segment["fileoff"]
    return None


def bounded_anchors(data, base, size, meta):
    result, targets = {}, {}
    for anchor in ANCHORS:
        needle = anchor.encode()
        pos, count, hits = base, 0, []
        while True:
            pos = data.find(needle, pos, base + size)
            if pos < 0:
                break
            count += 1
            if len(hits) < 16:
                lower = max(base, pos - 160)
                left = data.rfind(b"\0", lower, pos)
                left = left + 1 if left >= lower else pos
                upper = min(base + size, left + 320)
                right = data.find(b"\0", pos, upper)
                right = right if right >= 0 else upper
                va = file_to_vm(meta, left - base)
                hits.append({"match_slice_offset": hex(pos - base),
                             "string_vmaddr": hex(va) if va is not None else None,
                             "text": bytes(data[left:right]).decode("utf-8", "replace")})
                if va is not None:
                    targets.setdefault(va, set()).add(anchor)
            pos += len(needle)
        result[anchor] = {"count": count, "sample_hits": hits}
    return result, targets


def candidate_references(data, base, meta, targets, starts):
    """Match ADRP + ADD within eight instructions; not full dataflow analysis."""
    pages = {address & ~0xFFF for address in targets}
    section = next(s for s in meta["sections"] if s["name"] == "__text")
    beginning, end = base + section["offset"], base + section["offset"] + section["size"]
    hits = []
    for offset in range(beginning, end - 4, 4):
        word = struct.unpack_from("<I", data, offset)[0]
        if word & 0x9F000000 != 0x90000000:
            continue
        pc = section["addr"] + offset - beginning
        imm = (((word >> 5) & 0x7FFFF) << 2) | ((word >> 29) & 3)
        if imm & (1 << 20):
            imm -= 1 << 21
        page = (pc & ~0xFFF) + (imm << 12)
        if page not in pages:
            continue
        register = word & 31
        for next_offset in range(offset + 4, min(offset + 36, end), 4):
            next_word = struct.unpack_from("<I", data, next_offset)[0]
            if next_word & 0xFF000000 != 0x91000000 or (next_word >> 5) & 31 != register:
                continue
            immediate = (next_word >> 10) & 0xFFF
            if next_word & (1 << 22):
                immediate <<= 12
            target = page + immediate
            if target not in targets:
                continue
            index = bisect.bisect_right(starts, pc) - 1
            hits.append({"adrp_vmaddr": hex(pc),
                         "add_vmaddr": hex(pc + next_offset - offset),
                         "target_vmaddr": hex(target), "anchors": sorted(targets[target]),
                         "function_start_candidate": hex(starts[index]) if index >= 0 else None,
                         "status": "unverified_static_candidate"})
    return hits


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--app", type=pathlib.Path, default=pathlib.Path("/Applications/WeChat.app"))
    parser.add_argument("--reference-config", type=pathlib.Path)
    parser.add_argument("--output", type=pathlib.Path)
    parser.add_argument("--xrefs", action="store_true", help="Scan static ADRP/ADD candidates")
    args = parser.parse_args()
    app = args.app.resolve()
    plist = plistlib.loads((app / "Contents/Info.plist").read_bytes())
    core = app / "Contents/Resources/wechat.dylib"
    main_exe = app / "Contents/MacOS" / plist["CFBundleExecutable"]
    result = {"generated_utc": datetime.now(timezone.utc).isoformat(),
              "mode": "read_only_disk_analysis", "app": str(app), "core": str(core),
              "version": {k: plist.get(k) for k in ("CFBundleShortVersionString", "WeChatBundleVersion",
                          "CFBundleVersion", "CFBundleIdentifier", "LSMinimumSystemVersion")},
              "main_sha256": digest(main_exe.read_bytes()),
              "warning": "No addresses in this report are approved for injection or calling."}
    with core.open("rb") as handle, mmap.mmap(handle.fileno(), 0, access=mmap.ACCESS_READ) as data:
        base, size = arm_slice(data)
        meta, starts = parse_macho(data, base, size)
        result["arm64_slice"] = {"offset": base, "size": size,
                                 "sha256": digest(memoryview(data)[base:base + size]), **meta}
        result["anchors"], targets = bounded_anchors(data, base, size, meta)
        if args.xrefs:
            result["candidate_string_references"] = candidate_references(data, base, meta, targets, starts)
        if args.reference_config:
            config = json.loads(args.reference_config.read_text())
            comparisons = {}
            for key, value in config.items():
                address = int(value, 0)
                segment = next((s for s in meta["segments"] if s["vmaddr"] <= address < s["vmaddr"] + s["filesize"]), None)
                if segment:
                    off = base + segment["fileoff"] + address - segment["vmaddr"]
                    word = struct.unpack_from("<I", data, off)[0]
                    comparisons[key] = {"old_rva": value, "current_word_le": f"0x{word:08x}",
                                        "bytes_16": bytes(data[off:off + 16]).hex(),
                                        "is_blr_x8": word == 0xD63F0100,
                                        "warning": "Old address content only, not a compatibility result"}
            result["old_config_locations"] = comparisons
    symbols = subprocess.run(["xcrun", "nm", "-arch", "arm64", str(core)],
                             capture_output=True, text=True, timeout=60)
    expression = re.compile(r"req2buf|buf2resp|MMStartTask|StartTask|AutoBuffer|STNManager|NewSendMsg|OpenIM|WeChatMain|SetWeixinCallback", re.I)
    result["matching_nm_symbols"] = [line for line in symbols.stdout.splitlines() if expression.search(line)][:100]
    result["signature_verify"] = run_readonly(["codesign", "--verify", "--deep", "--strict", str(app)])
    result["signature_metadata"] = run_readonly(["codesign", "-dv", "--verbose=4", str(app)])
    result["entitlements"] = run_readonly(["codesign", "-d", "--entitlements", ":-", str(app)])
    output = json.dumps(result, ensure_ascii=False, indent=2) + "\n"
    if args.output:
        destination = args.output.resolve()
        if destination == app or app in destination.parents:
            parser.error("Output must be outside the inspected app")
        destination.parent.mkdir(parents=True, exist_ok=True)
        destination.write_text(output)
        print(f"Wrote read-only probe report: {destination}")
    else:
        print(output, end="")


if __name__ == "__main__":
    main()
