"""Read-only PE32+ inventory for Hook porting; never derives trusted hook RVAs."""
from __future__ import annotations

from bisect import bisect_right
import hashlib
import struct


class PEImage:
    def __init__(self, data: bytes):
        self.data = data
        if self.read(0, 2) != b"MZ":
            raise ValueError("missing DOS signature")
        pe = self.unpack("<I", 0x3C)[0]
        if self.read(pe, 4) != b"PE\0\0":
            raise ValueError("missing PE signature")
        machine, count, _, _, _, optional_size, _ = self.unpack("<HHIIIHH", pe + 4)
        optional = pe + 24
        if machine != 0x8664 or optional_size < 112 or self.unpack("<H", optional)[0] != 0x20B:
            raise ValueError("only x64 PE32+ is supported")
        self.read(optional, optional_size)
        self.image_base = self.unpack("<Q", optional + 24)[0]
        self.header_size = self.unpack("<I", optional + 60)[0]
        directory_count = self.unpack("<I", optional + 108)[0]
        if directory_count > (optional_size - 112) // 8:
            raise ValueError("truncated data directories")
        self.directories = [self.unpack("<II", optional + 112 + i * 8) for i in range(directory_count)]
        self.sections = []
        for i in range(count):
            off = optional + optional_size + i * 40
            name = self.read(off, 8).split(b"\0", 1)[0].decode("ascii", errors="replace")
            virtual_size, rva, raw_size, raw_offset = self.unpack("<IIII", off + 8)
            flags = self.unpack("<I", off + 36)[0]
            self.read(raw_offset, raw_size)
            self.sections.append({"name": name, "rva": rva, "virtual_size": virtual_size,
                                  "raw_size": raw_size, "raw_offset": raw_offset,
                                  "executable": bool(flags & 0x20000000)})
        self.functions = []
        if len(self.directories) > 3:
            rva, size = self.directories[3]
            if size:
                if size % 12:
                    raise ValueError("invalid x64 exception directory length")
                off = self.rva_offset(rva, size)
                for i in range(0, size, 12):
                    begin, end, unwind = self.unpack("<III", off + i)
                    if begin == end == unwind == 0:
                        continue
                    if end <= begin:
                        raise ValueError("invalid runtime function range")
                    self.functions.append((begin, end, unwind))
        self.functions.sort()
        self.starts = [x[0] for x in self.functions]

    def read(self, offset: int, size: int) -> bytes:
        if offset < 0 or size < 0 or offset + size > len(self.data):
            raise ValueError("PE range outside file")
        return self.data[offset:offset + size]

    def unpack(self, fmt: str, offset: int):
        return struct.unpack(fmt, self.read(offset, struct.calcsize(fmt)))

    def rva_offset(self, rva: int, size: int = 1) -> int:
        if 0 <= rva and rva + size <= self.header_size:
            self.read(rva, size)
            return rva
        for section in self.sections:
            delta = rva - section["rva"]
            if 0 <= delta and delta + size <= section["raw_size"]:
                off = section["raw_offset"] + delta
                self.read(off, size)
                return off
        raise ValueError("RVA has no complete file-backed range")

    def function_at(self, rva: int):
        i = bisect_right(self.starts, rva) - 1
        if i >= 0 and self.functions[i][0] <= rva < self.functions[i][1]:
            begin, end, unwind = self.functions[i]
            return {"begin_rva": hex(begin), "end_rva": hex(end), "unwind_rva": hex(unwind),
                    "at_begin": begin == rva}
        return None

    def audit_legacy_rva(self, name: str, rva: int) -> dict:
        # A mapped/executable address is not evidence of matching function semantics.
        try:
            offset = self.rva_offset(rva, 16)
            prefix = self.read(offset, 16).hex()
        except ValueError:
            offset, prefix = None, None
        section = next((x for x in self.sections if x["rva"] <= rva < x["rva"] + max(x["raw_size"], x["virtual_size"])), None)
        return {"name": name, "legacy_rva": hex(rva), "file_offset": offset,
                "section": section["name"] if section else None,
                "executable": bool(section and section["executable"]),
                "runtime_function": self.function_at(rva), "first_16_bytes": prefix,
                "semantic_status": "unverified", "usable_for_hook": False}

    def string_anchors(self, keywords: tuple[str, ...], limit: int = 12) -> list[dict]:
        result = []
        for keyword in keywords:
            needle = keyword.encode("ascii")
            found, count = [], 0
            for section in self.sections:
                if section["executable"]:
                    continue
                block = self.read(section["raw_offset"], section["raw_size"])
                start = 0
                while (pos := block.find(needle, start)) >= 0:
                    count += 1
                    if len(found) < limit:
                        found.append({"rva": hex(section["rva"] + pos), "section": section["name"]})
                    start = pos + len(needle)
            result.append({"keyword": keyword, "count": count, "matches": found,
                           "truncated": count > len(found), "semantic_status": "unverified"})
        return result


def analyze_target(data: bytes, legacy_rvas: dict[str, int]) -> dict:
    image = PEImage(data)
    return {"schema_version": "windows-hook-static-analysis.v1", "sha256": hashlib.sha256(data).hexdigest(),
            "arch": "x64", "image_base": hex(image.image_base), "sections": image.sections,
            "runtime_function_count": len(image.functions),
            "legacy_rva_audit": [image.audit_legacy_rva(name, rva) for name, rva in legacy_rvas.items()],
            "string_anchors": image.string_anchors(("DoAddMsg", "OnAddMsg", "GetMsgSvc", "GetMsgCtx", "SendText", "MsgCtor")),
            "runtime_offsets_verified": False, "live_receive_verified": False,
            "send_delivery_verified": False}
