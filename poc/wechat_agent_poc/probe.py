"""Host facts for R0. Does not open chat databases, list wxid folders, or attach to processes."""

from __future__ import annotations

from ctypes import Structure, byref, c_uint32, c_void_p, create_string_buffer, windll
from ctypes import wintypes
from pathlib import Path
import os
import subprocess
from typing import Any


WEIXIN_EXE_CANDIDATES = (
    Path(r"C:\Program Files\Tencent\Weixin\Weixin.exe"),
    Path(os.environ.get("LOCALAPPDATA", "")) / "Tencent" / "Weixin" / "Weixin.exe",
    Path(os.environ.get("PROGRAMFILES", r"C:\Program Files")) / "Tencent" / "Weixin" / "Weixin.exe",
)

WXWORK_EXE_CANDIDATES = (
    Path(r"C:\Program Files (x86)\WXWork\WXWork.exe"),
    Path(os.environ.get("PROGRAMFILES", r"C:\Program Files")) / "WXWork" / "WXWork.exe",
)

DATA_ROOT_CANDIDATES = (
    Path.home() / "Documents" / "xwechat_files",
    Path.home() / "Documents" / "WeChat Files",
)


class VS_FIXEDFILEINFO(Structure):
    _fields_ = [
        ("dwSignature", c_uint32),
        ("dwStrucVersion", c_uint32),
        ("dwFileVersionMS", c_uint32),
        ("dwFileVersionLS", c_uint32),
        ("dwProductVersionMS", c_uint32),
        ("dwProductVersionLS", c_uint32),
        ("dwFileFlagsMask", c_uint32),
        ("dwFileFlags", c_uint32),
        ("dwFileOS", c_uint32),
        ("dwFileType", c_uint32),
        ("dwFileSubtype", c_uint32),
        ("dwFileDateMS", c_uint32),
        ("dwFileDateLS", c_uint32),
    ]


def file_version(path: Path) -> str | None:
    if os.name != "nt" or not path.is_file():
        return None
    size = windll.version.GetFileVersionInfoSizeW(str(path), None)
    if not size:
        return None
    buf = create_string_buffer(size)
    if not windll.version.GetFileVersionInfoW(str(path), 0, size, buf):
        return None
    addr = c_void_p()
    length = wintypes.UINT()
    if not windll.version.VerQueryValueW(buf, "\\", byref(addr), byref(length)):
        return None
    if not addr.value:
        return None
    info = VS_FIXEDFILEINFO.from_address(addr.value)
    ms, ls = info.dwFileVersionMS, info.dwFileVersionLS
    return f"{ms >> 16}.{ms & 0xFFFF}.{ls >> 16}.{ls & 0xFFFF}"


def first_existing(paths: tuple[Path, ...]) -> Path | None:
    for path in paths:
        if path and path.is_file():
            return path
    return None


def running_image_names(names: tuple[str, ...]) -> dict[str, bool]:
    found = {name: False for name in names}
    if os.name != "nt":
        return found
    try:
        output = subprocess.check_output(
            ["tasklist", "/FO", "CSV", "/NH"],
            text=True,
            stderr=subprocess.DEVNULL,
            timeout=10,
        )
    except (OSError, subprocess.SubprocessError):
        return found
    lowered = output.lower()
    for name in names:
        found[name] = name.lower() in lowered
    return found


def probe_machine() -> dict[str, Any]:
    weixin = first_existing(WEIXIN_EXE_CANDIDATES)
    wxwork = first_existing(WXWORK_EXE_CANDIDATES)
    data_roots = [
        {"path": str(path), "exists": path.is_dir()}
        for path in DATA_ROOT_CANDIDATES
    ]
    images = running_image_names(("Weixin.exe", "WXWork.exe"))
    return {
        "weixin_exe": str(weixin) if weixin else None,
        "weixin_file_version": file_version(weixin) if weixin else None,
        "wxwork_exe": str(wxwork) if wxwork else None,
        "wxwork_file_version": file_version(wxwork) if wxwork else None,
        "data_roots": data_roots,
        "weixin_process_running": images.get("Weixin.exe", False),
        "wxwork_process_running": images.get("WXWork.exe", False),
        "accounts_listed": False,
        "chat_databases_opened": False,
        "process_memory_read": False,
        "key_extraction": False,
        "doc_baseline_wechat": "4.1.13.65",
        "doc_baseline_date": "2026-09-12",
    }
