#!/usr/bin/env python3
"""Read an ELF on disk; never load it, attach, or access account data.

This deliberately limited ADRP+ADD scan produces candidates, not Hook configs.
Only ELF64 little-endian AArch64 and .eh_frame_hdr table encoding 0x3b are used.
"""

import argparse
import bisect
import hashlib
import json
import mmap
from pathlib import Path
import struct


ANCHORS = ("MMStartTask", "MMReq2Buf", "MMBuf2Resp", "Req2Buf", "Buf2Resp",
           "/cgi-bin/micromsg-bin/newsendmsg", "atuserlist", "@im.chatroom", "@openim")


def elf_sections(data):
    if data[:6] != b"\x7fELF\x02\x01" or struct.unpack_from("<H", data, 18)[0] != 183:
        raise ValueError("Expected little-endian ELF64 AArch64")
    offset = struct.unpack_from("<Q", data, 40)[0]
    width, count, names_index = struct.unpack_from("<HHH", data, 58)
    rows = [struct.unpack_from("<IIQQQQIIQQ", data, offset + i * width) for i in range(count)]
    names_offset = rows[names_index][4]
    sections = {}
    for row in rows:
        name_offset = names_offset + row[0]
        name = data[name_offset:data.find(b"\0", name_offset)].decode()
        sections[name] = dict(zip(("name_offset", "type", "flags", "va", "offset", "size", "link", "info", "alignment", "entry_size"), row))
    return sections


def va_to_offset(sections, va):
    for sec in sections.values():
        if sec["type"] != 8 and sec["va"] <= va < sec["va"] + sec["size"]:
            return va - sec["va"] + sec["offset"]
    raise ValueError(f"VA has no file-backed section: {va:#x}")


def build_id(data, sections):
    for section in sections.values():
        if section["type"] != 7:
            continue
        cursor, end = section["offset"], section["offset"] + section["size"]
        while cursor + 12 <= end:
            name_size, desc_size, kind = struct.unpack_from("<III", data, cursor)
            name_offset = cursor + 12
            desc_offset = name_offset + ((name_size + 3) & ~3)
            next_offset = desc_offset + ((desc_size + 3) & ~3)
            if next_offset > end:
                break
            if kind == 3 and data[name_offset:name_offset + name_size].rstrip(b"\0") == b"GNU":
                return data[desc_offset:desc_offset + desc_size].hex()
            cursor = next_offset
    return None


def unwind_index(data, sections):
    sec = sections[".eh_frame_hdr"]
    offset, address = sec["offset"], sec["va"]
    version, frame_encoding, count_encoding, table_encoding = struct.unpack_from("4B", data, offset)
    if (version, frame_encoding, count_encoding, table_encoding) != (1, 0x1b, 3, 0x3b):
        raise ValueError("Unsupported unwind-header encoding")
    count = struct.unpack_from("<I", data, offset + 8)[0]
    if 12 + count * 8 > sec["size"]:
        raise ValueError("Invalid unwind index length")
    entries = []
    for i in range(count):
        start_delta, fde_delta = struct.unpack_from("<ii", data, offset + 12 + i * 8)
        entries.append((address + start_delta, address + fde_delta))
    if entries != sorted(entries):
        raise ValueError("Unsorted unwind index")
    return entries


def anchors(data, sections):
    sec = sections[".rodata"]
    lo, hi = sec["offset"], sec["offset"] + sec["size"]
    found, targets = {}, {}
    for name in ANCHORS:
        pos, hits = lo, []
        while len(hits) < 30:
            pos = data.find(name.encode(), pos, hi)
            if pos < 0:
                break
            lower = max(lo, pos - 320)
            left = data.rfind(b"\0", lower, pos)
            left = left + 1 if left >= lower else pos
            upper = min(hi, max(pos + len(name), left + 320))
            right = data.find(b"\0", pos, upper)
            right = right if right >= 0 else upper
            hit = {"match_offset": hex(pos), "string_offset": hex(left),
                   "string_va": hex(left - lo + sec["va"]),
                   "text": data[left:right].decode("utf-8", "replace")}
            hits.append(hit)
            for start in (left, pos):
                targets.setdefault(start - lo + sec["va"], set()).add(name)
            pos += len(name)
        found[name] = hits
    return found, targets


def xrefs(data, sections, targets, entries):
    sec = sections[".text"]
    start, end = sec["offset"], sec["offset"] + sec["size"]
    pages = {x & ~0xfff for x in targets}
    starts = [x[0] for x in entries]
    output = []
    words = memoryview(data)[start:end - (end - start) % 4].cast("I")
    try:
        for i, word in enumerate(words):
            if word & 0x9f000000 != 0x90000000:
                continue
            pc = sec["va"] + i * 4
            immediate = (((word >> 5) & 0x7ffff) << 2) | ((word >> 29) & 3)
            if immediate & (1 << 20):
                immediate -= 1 << 21
            page = (pc & ~0xfff) + (immediate << 12)
            if page not in pages:
                continue
            register = word & 31
            for j in range(i + 1, min(len(words), i + 9)):
                following = words[j]
                if following & 0xff000000 != 0x91000000 or (following >> 5) & 31 != register:
                    continue
                imm = (following >> 10) & 0xfff
                if following & (1 << 22):
                    imm <<= 12
                target = page + imm
                if target not in targets:
                    continue
                index = bisect.bisect_right(starts, pc) - 1
                entry = entries[index] if index >= 0 else (None, None)
                output.append({"adrp_va": hex(pc), "add_va": hex(sec["va"] + j * 4),
                               "target_va": hex(target), "anchors": sorted(targets[target]),
                               "unwind_start_candidate": hex(entry[0]) if entry[0] is not None else None,
                               "fde_va": hex(entry[1]) if entry[1] is not None else None,
                               "next_index_start": hex(starts[index + 1]) if index + 1 < len(starts) else None,
                               "status": "requires_disassembly_and_dataflow_review"})
    finally:
        words.release()
    return output


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("elf", type=Path)
    parser.add_argument("--output", required=True, type=Path)
    args = parser.parse_args()
    if args.elf.resolve() == args.output.resolve():
        raise ValueError("Output cannot overwrite input ELF")
    with args.elf.open("rb") as f, mmap.mmap(f.fileno(), 0, access=mmap.ACCESS_READ) as data:
        sections = elf_sections(data)
        entries = unwind_index(data, sections)
        matches, targets = anchors(data, sections)
        report = {"status": "static_candidates_not_runtime_configuration", "elf": str(args.elf.resolve()),
                  "sha256": hashlib.sha256(data).hexdigest(), "size": len(data), "gnu_build_id": build_id(data, sections),
                  "sections": sections, "unwind_entries": len(entries), "anchors": matches,
                  "xrefs": xrefs(data, sections, targets, entries)}
    args.output.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n")
    print(json.dumps({"output": str(args.output), "anchors": {k: len(v) for k, v in matches.items()},
                      "unwind_entries": len(entries), "xrefs": len(report["xrefs"])}))


if __name__ == "__main__":
    main()
