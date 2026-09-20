"""One-shot, operator-planned native send trial.

This module deliberately has no model, queue, retry, activation, clipboard, or
group-navigation logic.  It is a small boundary around the already reviewed
``WindowsBackend`` screen-region observer.  The caller must supply a fresh run
directory and a binding observation captured for that exact window.
"""

from __future__ import annotations

import argparse
import ctypes
from ctypes import wintypes
import hashlib
import json
from pathlib import Path
import sys
import time
from typing import Any

from .hybrid_observer import ObservationBlocked


MAX_TEXT_LENGTH = 120
PLAN_FIELDS = {
    "hwnd",
    "expected_window_observation",
    "text",
    "compose_point",
    "send_point",
}


def _canonical_json(value: Any) -> bytes:
    return json.dumps(value, ensure_ascii=False, sort_keys=True, separators=(",", ":")).encode("utf-8")


def plan_sha256(plan: dict[str, Any]) -> str:
    return hashlib.sha256(_canonical_json(plan)).hexdigest()


def validate_plan(plan: Any) -> dict[str, Any]:
    if not isinstance(plan, dict) or set(plan) != PLAN_FIELDS:
        raise ValueError("invalid_plan_fields")
    hwnd = plan["hwnd"]
    if type(hwnd) is not int or hwnd <= 0:
        raise ValueError("invalid_hwnd")
    if not isinstance(plan["expected_window_observation"], dict):
        raise ValueError("invalid_expected_window_observation")
    text = plan["text"]
    if not isinstance(text, str) or not text or len(text) > MAX_TEXT_LENGTH:
        raise ValueError("invalid_text_length")
    if not text.startswith("UIA-ACK-"):
        raise ValueError("invalid_text_prefix")
    if any(ord(char) < 0x20 or ord(char) == 0x7F for char in text):
        raise ValueError("text_contains_control_character")
    for name in ("compose_point", "send_point"):
        point = plan[name]
        if (not isinstance(point, list) or len(point) != 2
                or any(type(value) is not int for value in point)
                or any(value < 0 for value in point)):
            raise ValueError("invalid_" + name)
        size = plan["expected_window_observation"].get("size", [])
        if len(size) != 2 or any(point[i] >= size[i] for i in range(2)):
            raise ValueError("point_outside_window")
    return plan


def _write_json(path: Path, value: dict[str, Any]) -> None:
    temporary = path.with_suffix(path.suffix + ".tmp")
    temporary.write_text(json.dumps(value, ensure_ascii=False, indent=2), encoding="utf-8")
    with temporary.open("r+b") as stream:
        stream.flush()
        import os
        os.fsync(stream.fileno())
    temporary.replace(path)


def _redacted_failure(run_dir: Path, plan_hash: str | None, reason: str) -> int:
    # Never include the plan text, window observation, paths, or native error
    # strings in the durable failure record.
    safe_reason = reason if reason in {
        "invalid_input", "run_dir_exists", "plan_hash_mismatch",
        "attempt_already_recorded", "state_not_staged", "window_mismatch",
        "foreground_mismatch", "native_input_failed", "capture_failed",
        "unexpected_failure",
        "window_occluded", "window_closed", "window_minimized",
        "window_identity_unavailable", "capture_binding_changed",
    } else "unexpected_failure"
    run_dir.mkdir(parents=True, exist_ok=True)
    state_path = run_dir / "state.json"
    existing = None
    if state_path.exists():
        try:
            existing = json.loads(state_path.read_text(encoding="utf-8"))
        except Exception:
            existing = None
    # Once submit has crossed the attempted marker, preserve that marker even
    # when the post-click capture fails.  A later invocation must never retry.
    if not isinstance(existing, dict) or existing.get("status") not in {
        "attempted", "submitted_unverified",
    }:
        _write_json(state_path, {
            "status": "failed",
            "reason": safe_reason,
            "plan_sha256": plan_hash,
            "retry_allowed": False,
        })
    _write_json(run_dir / "failure.json", {
        "status": "failed",
        "reason": safe_reason,
        "plan_sha256": plan_hash,
        "retry_allowed": False,
    })
    return 2


def _foreground_hwnd() -> int:
    user32 = ctypes.WinDLL("user32", use_last_error=True)
    user32.GetForegroundWindow.argtypes = []
    user32.GetForegroundWindow.restype = wintypes.HWND
    return int(user32.GetForegroundWindow() or 0)


def _window_point(hwnd: int, point: list[int]) -> tuple[int, int]:
    user32 = ctypes.WinDLL("user32", use_last_error=True)
    rect = wintypes.RECT()
    user32.GetWindowRect.argtypes = [wintypes.HWND, ctypes.POINTER(wintypes.RECT)]
    user32.GetWindowRect.restype = wintypes.BOOL
    if not user32.GetWindowRect(hwnd, ctypes.byref(rect)):
        raise OSError("window_rect_unavailable")
    return rect.left + point[0], rect.top + point[1]


ULONG_PTR = ctypes.c_size_t
INPUT_MOUSE = 0
INPUT_KEYBOARD = 1
KEYEVENTF_UNICODE = 0x0004
KEYEVENTF_KEYUP = 0x0002
MOUSEEVENTF_LEFTDOWN = 0x0002
MOUSEEVENTF_LEFTUP = 0x0004


class MOUSEINPUT(ctypes.Structure):
    _fields_ = [
        ("dx", wintypes.LONG),
        ("dy", wintypes.LONG),
        ("mouseData", wintypes.DWORD),
        ("dwFlags", wintypes.DWORD),
        ("time", wintypes.DWORD),
        ("dwExtraInfo", ULONG_PTR),
    ]


class KEYBDINPUT(ctypes.Structure):
    _fields_ = [
        ("wVk", wintypes.WORD),
        ("wScan", wintypes.WORD),
        ("dwFlags", wintypes.DWORD),
        ("time", wintypes.DWORD),
        ("dwExtraInfo", ULONG_PTR),
    ]


class HARDWAREINPUT(ctypes.Structure):
    _fields_ = [("uMsg", wintypes.DWORD), ("wParamL", wintypes.WORD), ("wParamH", wintypes.WORD)]


class INPUT_UNION(ctypes.Union):
    _fields_ = [("mi", MOUSEINPUT), ("ki", KEYBDINPUT), ("hi", HARDWAREINPUT)]


class INPUT(ctypes.Structure):
    _anonymous_ = ("union",)
    _fields_ = [("type", wintypes.DWORD), ("union", INPUT_UNION)]


def _send_inputs(inputs: list[INPUT]) -> None:
    if ctypes.sizeof(ctypes.c_void_p) != 8 or ctypes.sizeof(INPUT) != 40:
        raise RuntimeError("unsupported_input_abi")
    user32 = ctypes.WinDLL("user32", use_last_error=True)
    user32.SendInput.argtypes = [wintypes.UINT, ctypes.POINTER(INPUT), ctypes.c_int]
    user32.SendInput.restype = wintypes.UINT
    array = (INPUT * len(inputs))(*inputs)
    sent = user32.SendInput(len(inputs), array, ctypes.sizeof(INPUT))
    if sent != len(inputs):
        raise OSError("send_input_failed")


def click_window_point(hwnd: int, point: list[int]) -> None:
    x, y = _window_point(hwnd, point)
    user32 = ctypes.WinDLL("user32", use_last_error=True)
    user32.SetCursorPos.argtypes = [ctypes.c_int, ctypes.c_int]
    user32.SetCursorPos.restype = wintypes.BOOL
    if not user32.SetCursorPos(x, y):
        raise OSError("cursor_position_failed")
    _send_inputs([
        INPUT(type=INPUT_MOUSE, mi=MOUSEINPUT(dwFlags=MOUSEEVENTF_LEFTDOWN)),
        INPUT(type=INPUT_MOUSE, mi=MOUSEINPUT(dwFlags=MOUSEEVENTF_LEFTUP)),
    ])


def type_unicode(text: str) -> None:
    units = [int.from_bytes(text.encode("utf-16-le")[index:index + 2], "little")
             for index in range(0, len(text.encode("utf-16-le")), 2)]
    inputs: list[INPUT] = []
    for unit in units:
        inputs.append(INPUT(type=INPUT_KEYBOARD, ki=KEYBDINPUT(wScan=unit, dwFlags=KEYEVENTF_UNICODE)))
        inputs.append(INPUT(type=INPUT_KEYBOARD,
                            ki=KEYBDINPUT(wScan=unit, dwFlags=KEYEVENTF_UNICODE | KEYEVENTF_KEYUP)))
    if inputs:
        _send_inputs(inputs)


def _capture(backend: Any, path: Path) -> None:
    image = backend.capture()
    try:
        image.save(path, format="PNG")
    finally:
        close = getattr(image, "close", None)
        if close:
            close()


def _new_run_dir(path: Path) -> None:
    if path.exists():
        raise ValueError("run_dir_exists")
    path.mkdir(parents=True)


def _load_plan(path: Path) -> tuple[dict[str, Any], str]:
    plan = validate_plan(json.loads(path.read_text(encoding="utf-8-sig")))
    return plan, plan_sha256(plan)


def _backend_for(plan: dict[str, Any]):
    from .hybrid_windows import WindowsBackend
    backend = WindowsBackend(plan["hwnd"], "screen_region")
    actual = backend.observe()
    if actual != plan["expected_window_observation"]:
        raise ObservationBlocked("window_mismatch")
    if _foreground_hwnd() != plan["hwnd"]:
        raise ObservationBlocked("foreground_mismatch")
    return backend


def run(plan_path: Path, run_dir: Path, stage: str) -> int:
    try:
        plan, digest = _load_plan(plan_path)
    except Exception:
        return _redacted_failure(run_dir, None, "invalid_input")
    if stage not in {"fill", "submit"}:
        return _redacted_failure(run_dir, digest, "invalid_input")
    if stage == "fill":
        try:
            _new_run_dir(run_dir)
            backend = _backend_for(plan)
            _capture(backend, run_dir / "before.png")
            _backend_for(plan)
            click_window_point(plan["hwnd"], plan["compose_point"])
            time.sleep(0.1)
            _backend_for(plan)
            type_unicode(plan["text"])
            time.sleep(0.3)
            _capture(backend, run_dir / "staged.png")
            _write_json(run_dir / "state.json", {
                "status": "staged", "plan_sha256": digest, "retry_allowed": False,
            })
            return 0
        except ObservationBlocked as exc:
            return _redacted_failure(run_dir, digest, str(exc))
        except Exception:
            return _redacted_failure(run_dir, digest, "capture_failed" if (run_dir / "before.png").exists() else "native_input_failed")

    try:
        state = json.loads((run_dir / "state.json").read_text(encoding="utf-8"))
        if state.get("status") == "attempted" or state.get("status") == "submitted_unverified":
            raise ValueError("attempt_already_recorded")
        if state.get("status") != "staged":
            raise ValueError("state_not_staged")
        if state.get("plan_sha256") != digest:
            raise ValueError("plan_hash_mismatch")
        backend = _backend_for(plan)
        _capture(backend, run_dir / "pre-submit.png")
        _backend_for(plan)
        with (run_dir / "submit.lock").open("x", encoding="ascii") as lock:
            lock.write(digest)
        _write_json(run_dir / "state.json", {
            "status": "attempted", "plan_sha256": digest, "retry_allowed": False,
        })
        _backend_for(plan)
        click_window_point(plan["hwnd"], plan["send_point"])
        time.sleep(0.5)
        _capture(backend, run_dir / "after.png")
        _write_json(run_dir / "state.json", {
            "status": "submitted_unverified", "plan_sha256": digest, "retry_allowed": False,
        })
        return 0
    except ValueError as exc:
        return _redacted_failure(run_dir, digest, str(exc))
    except ObservationBlocked as exc:
        return _redacted_failure(run_dir, digest, str(exc))
    except Exception:
        # The attempted marker is intentionally left in place after any failure
        # following the pre-submit state write.  A caller must inspect it.
        if (run_dir / "state.json").exists():
            try:
                current = json.loads((run_dir / "state.json").read_text(encoding="utf-8"))
            except Exception:
                current = {}
            if current.get("status") == "attempted":
                return 2
        return _redacted_failure(run_dir, digest, "unexpected_failure")


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--plan", required=True, type=Path)
    parser.add_argument("--run-dir", required=True, type=Path)
    parser.add_argument("--stage", required=True, choices=("fill", "submit"))
    args = parser.parse_args(argv)
    return run(args.plan, args.run_dir, args.stage)


if __name__ == "__main__":
    raise SystemExit(main())
