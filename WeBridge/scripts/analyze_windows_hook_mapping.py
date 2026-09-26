"""Reproduce offline reference/current send mappings; never accesses a process."""
from __future__ import annotations

import argparse
import difflib
import hashlib
import json
from pathlib import Path
import re
import shutil
import struct

from analyze_windows_hook_send import Image, disassemble


def opaque_type(image, vtable):
    col = struct.unpack_from("<Q", image.data, image.offset(vtable-8))[0]-image.base
    fields = struct.unpack_from("<6I", image.data, image.offset(col))
    if fields[0] != 1 or fields[5] != col:
        raise ValueError("invalid x64 CompleteObjectLocator")
    descriptor = fields[3]
    off = image.offset(descriptor)+16
    name = image.data[off:off+4096].split(b"\0", 1)[0]
    if not name or len(name) == 4096:
        raise ValueError("missing bounded type identity")
    return descriptor, name


def map_vtable(reference, target, old):
    descriptor, name = opaque_type(reference, old)
    candidates = []
    for occurrence in target.occurrences(name+b"\0"):
        new_descriptor = occurrence-16
        for ref in target.occurrences(struct.pack("<I", new_descriptor)):
            col = ref-12
            try:
                fields = struct.unpack_from("<6I", target.data, target.offset(col))
            except (ValueError, struct.error):
                continue
            if fields[0] == 1 and fields[3] == new_descriptor and fields[5] == col:
                for pointer in target.pointer_refs(col):
                    candidates.append(dict(vtable=hex(pointer+8), col=hex(col),
                                           type_descriptor=hex(new_descriptor)))
    return dict(reference_vtable=hex(old), reference_type_descriptor=hex(descriptor),
                opaque_type_bytes=len(name), opaque_type_sha256=hashlib.sha256(name).hexdigest(),
                candidates=candidates, unique=len(candidates) == 1)


def normalize(instruction):
    instruction = re.sub(r"#.*", "", instruction).strip()
    if "rip" in instruction or re.match(r"(?:call|j\w+)\s+0x", instruction):
        instruction = re.sub(r"0x[0-9a-f]+", "ADDR", instruction)
    return instruction


def compare_functions(reference, target, old, new, objdump):
    normalized = []
    rows = []
    for image, rva in ((reference, old), (target, new)):
        fn = image.function(rva)
        if not fn or fn[0] != rva:
            raise ValueError("candidate must be a .pdata function start")
        instructions, _ = disassemble(image, fn[0], fn[1], objdump)
        normalized.append([normalize(s) for s in instructions.values()])
        rows.append(dict(rva=hex(rva), size=fn[1]-fn[0], instructions=len(instructions),
                         prefix16=image.data[image.offset(rva):image.offset(rva)+16].hex()))
    matcher = difflib.SequenceMatcher(None, *normalized, autojunk=False)
    differences = []
    for tag, a1, a2, b1, b2 in matcher.get_opcodes():
        if tag != "equal":
            differences.append(dict(kind=tag, reference=normalized[0][a1:a2], target=normalized[1][b1:b2]))
    return dict(reference=rows[0], target=rows[1], normalized_similarity=matcher.ratio(),
                differences=differences, abi_verified=False)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--reference", required=True, type=Path)
    parser.add_argument("--module", required=True, type=Path)
    parser.add_argument("--output", required=True, type=Path)
    parser.add_argument("--objdump", default=shutil.which("objdump"))
    args = parser.parse_args()
    if not args.objdump:
        parser.error("objdump is required")
    reference, target = Image(args.reference), Image(args.module)
    # These are review candidates for the two pinned binaries; assertions here
    # deliberately do not promote them to runtime-approved invocation offsets.
    pairs = {
        "options_constructor": (0xDF40, 0xF910),
        "text_constructor": (0x6B2C30, 0x766680),
        "send_message": (0x1677A30, 0x19D0BC0),
        "protocol_element_copy": (0x2C6C060, 0x2E82C00),
        "protocol_outer_copy": (0x2C6D230, 0x2E83DD0),
        "protocol_repeated_copy": (0x2C72DE0, 0x2E89940),
    }
    vtables = {
        "text_shared_control": 0x8279358, "text_inner": 0x82793E8,
        "param1": 0x84EC9C8, "send_queued_task": 0x84ECAA8,
        "legacy_callback1": 0x8595F58, "legacy_callback2": 0x8595E98,
        "legacy_callback3": 0x8595DD8,
    }
    report = dict(
        schema="windows-hook-send-mapping.v1",
        reference_sha256=hashlib.sha256(reference.data).hexdigest(),
        target_sha256=hashlib.sha256(target.data).hexdigest(),
        live_process_accessed=False, code_invoked=False, abi_verified=False,
        functions={name: compare_functions(reference, target, *pair, args.objdump)
                   for name, pair in pairs.items()},
        vtables={name: map_vtable(reference, target, address) for name, address in vtables.items()},
    )
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(report, indent=2)+"\n", encoding="utf-8")
    print(json.dumps({"output": str(args.output), "function_pairs": len(pairs),
                      "unique_vtable_matches": sum(v["unique"] for v in report["vtables"].values()),
                      "live_process_accessed": False}))


if __name__ == "__main__":
    main()
