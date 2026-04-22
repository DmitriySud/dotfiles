#!/usr/bin/env python3

from __future__ import annotations

import os
import subprocess
import sys
import threading
import time
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable


APP_NAME = "pass-wofi"
DEFAULT_CLIPBOARD_TIMEOUT_SECONDS = 15


@dataclass(frozen=True)
class Entry:
    name: str
    password: str
    login: str | None


def run_checked(args: list[str], *, input_text: str | None = None) -> str:
    result = subprocess.run(
        args,
        input=input_text,
        text=True,
        capture_output=True,
        check=False,
    )
    if result.returncode != 0:
        stderr = result.stderr.strip()
        raise RuntimeError(f"command failed: {' '.join(args)}\n{stderr}")
    return result.stdout


def notify(summary: str, body: str = "") -> None:
    if not shutil_which("notify-send"):
        return
    subprocess.run(
        ["notify-send", summary, body],
        check=False,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )


def shutil_which(name: str) -> str | None:
    for directory in os.environ.get("PATH", "").split(":"):
        candidate = Path(directory) / name
        if candidate.is_file() and os.access(candidate, os.X_OK):
            return str(candidate)
    return None


def require_commands(names: Iterable[str]) -> None:
    missing = [name for name in names if shutil_which(name) is None]
    if missing:
        raise RuntimeError(f"missing required commands: {', '.join(missing)}")


def get_store_dir() -> Path:
    return Path(os.environ.get("PASSWORD_STORE_DIR", str(Path.home() / ".password-store")))


def get_state_dir() -> Path:
    base = Path(os.environ.get("XDG_STATE_HOME", str(Path.home() / ".local" / "state")))
    state_dir = base / APP_NAME
    state_dir.mkdir(parents=True, exist_ok=True)
    return state_dir


def get_last_entry_file() -> Path:
    return get_state_dir() / "last-entry"


def read_last_entry() -> str | None:
    path = get_last_entry_file()
    if not path.exists():
        return None
    value = path.read_text(encoding="utf-8").strip()
    return value or None


def write_last_entry(entry_name: str) -> None:
    get_last_entry_file().write_text(entry_name + "\n", encoding="utf-8")


def list_entry_names(store_dir: Path) -> list[str]:
    entries: list[str] = []
    for path in store_dir.rglob("*.gpg"):
        if ".git" in path.parts:
            continue
        rel = path.relative_to(store_dir)
        if rel.name == ".gpg-id":
            continue
        entries.append(str(rel)[:-4])  # strip ".gpg"
    entries.sort()
    return entries


def move_last_first(items: list[str], last: str | None) -> list[str]:
    if not last or last not in items:
        return items
    return [last] + [item for item in items if item != last]


def pass_show(entry_name: str) -> str:
    return run_checked(["pass", "show", entry_name])


def parse_entry(entry_name: str) -> Entry:
    raw = pass_show(entry_name)
    lines = raw.splitlines()

    if not lines:
        raise RuntimeError(f"empty pass entry: {entry_name}")

    password = lines[0]
    login = None

    if len(lines) >= 2:
        prefix = "login:"
        second = lines[1]
        if second.startswith(prefix):
            login = second[len(prefix):].strip()

    return Entry(name=entry_name, password=password, login=login)


def build_entries(store_dir: Path) -> list[Entry]:
    return [parse_entry(name) for name in list_entry_names(store_dir)]


def wofi_pick(lines: list[str], prompt: str) -> str | None:
    if not lines:
        return None

    payload = "\n".join(lines)
    result = subprocess.run(
        [
            "wofi",
            "--dmenu",
            "--insensitive",
            "--matching",
            "fuzzy",
            "--prompt",
            prompt,
            "--cache-file",
            "/dev/null",
        ],
        input=payload,
        text=True,
        capture_output=True,
        check=False,
    )

    if result.returncode != 0:
        return None

    selection = result.stdout.strip()
    return selection or None


def clear_clipboard_after(delay_seconds: int) -> None:
    def worker() -> None:
        time.sleep(delay_seconds)
        subprocess.run(
            ["wl-copy", "--clear"],
            check=False,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )

    thread = threading.Thread(target=worker, daemon=True)
    thread.start()


def copy_to_clipboard(value: str, *, timeout_seconds: int) -> None:
    subprocess.run(
        ["wl-copy", value],
        check=True,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )
    clear_clipboard_after(timeout_seconds)


def mode_password_by_entry(store_dir: Path, timeout_seconds: int) -> int:
    names = list_entry_names(store_dir)
    names = move_last_first(names, read_last_entry())

    selected = wofi_pick(names, "password")
    if not selected:
        return 0

    entry = parse_entry(selected)
    write_last_entry(entry.name)
    copy_to_clipboard(entry.password, timeout_seconds=timeout_seconds)
    notify("pass", "Password copied")
    return 0


def mode_login_by_entry(store_dir: Path, timeout_seconds: int) -> int:
    names = list_entry_names(store_dir)
    names = move_last_first(names, read_last_entry())

    selected = wofi_pick(names, "login")
    if not selected:
        return 0

    entry = parse_entry(selected)
    if not entry.login:
        raise RuntimeError(f"entry has no login on second line: {entry.name}")

    write_last_entry(entry.name)
    copy_to_clipboard(entry.login, timeout_seconds=timeout_seconds)
    notify("pass", "Login copied")
    return 0


def mode_password_by_login(store_dir: Path, timeout_seconds: int) -> int:
    entries = build_entries(store_dir)
    entries = [entry for entry in entries if entry.login]

    last = read_last_entry()
    if last:
        entries.sort(key=lambda entry: (entry.name != last, entry.login or "", entry.name))
    else:
        entries.sort(key=lambda entry: ((entry.login or ""), entry.name))

    display_lines = [f"{entry.login}\t{entry.name}" for entry in entries]
    selected = wofi_pick(display_lines, "login")
    if not selected:
        return 0

    try:
        _, entry_name = selected.split("\t", 1)
    except ValueError as exc:
        raise RuntimeError(f"unexpected selection format: {selected}") from exc

    entry = parse_entry(entry_name)
    write_last_entry(entry.name)
    copy_to_clipboard(entry.password, timeout_seconds=timeout_seconds)
    notify("pass", "Password copied")
    return 0


def main() -> int:
    if len(sys.argv) != 2:
        print(
            f"usage: {Path(sys.argv[0]).name} "
            "<password-by-entry|login-by-entry|password-by-login>",
            file=sys.stderr,
        )
        return 2

    require_commands(["pass", "gpg", "wofi", "wl-copy"])

    mode = sys.argv[1]
    store_dir = get_store_dir()
    timeout_seconds = int(
        os.environ.get("PASS_WOFI_CLIPBOARD_TIMEOUT", str(DEFAULT_CLIPBOARD_TIMEOUT_SECONDS))
    )

    if mode == "password-by-entry":
        return mode_password_by_entry(store_dir, timeout_seconds)
    if mode == "login-by-entry":
        return mode_login_by_entry(store_dir, timeout_seconds)
    if mode == "password-by-login":
        return mode_password_by_login(store_dir, timeout_seconds)

    print(f"unknown mode: {mode}", file=sys.stderr)
    return 2


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except RuntimeError as exc:
        print(str(exc), file=sys.stderr)
        raise SystemExit(1)
