from __future__ import annotations

import json
import subprocess
import time
from collections.abc import Callable
from typing import Any


APPLICATION_CLASS = "io.github.dyusudakov.MermaidViewer"
VIEWER_TITLE = "Mermaid Viewer - Image"

CommandRunner = Callable[[list[str]], subprocess.CompletedProcess[str]]


def run_command(arguments: list[str]) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        arguments,
        capture_output=True,
        text=True,
        check=False,
    )


def find_viewer_client(clients: list[dict[str, Any]], process_id: int) -> dict[str, Any] | None:
    for client in clients:
        if (
            client.get("pid") == process_id
            and client.get("mapped", True)
            and client.get("initialClass", client.get("class")) == APPLICATION_CLASS
            and client.get("initialTitle", client.get("title")) == VIEWER_TITLE
        ):
            return client
    return None


def logical_monitor_width(monitor: dict[str, Any]) -> int:
    width = int(monitor["width"])
    height = int(monitor["height"])
    transform = int(monitor.get("transform", 0))
    scale = float(monitor.get("scale", 1))
    if transform in {1, 3, 5, 7}:
        width = height
    return round(width / scale)


def split_ratio_for_viewer(
    client: dict[str, Any],
    monitor: dict[str, Any],
    width_fraction: float,
) -> float:
    position = client["at"]
    size = client["size"]
    monitor_left = float(monitor.get("x", 0))
    monitor_middle = monitor_left + logical_monitor_width(monitor) / 2
    client_middle = float(position[0]) + float(size[0]) / 2
    viewer_is_left = client_middle < monitor_middle
    ratio = 2 * width_fraction if viewer_is_left else 2 * (1 - width_fraction)
    return min(1.9, max(0.1, ratio))


def resize_viewer(
    process_id: int,
    width_fraction: float,
    *,
    hyprctl: str = "hyprctl",
    attempts: int = 20,
    retry_delay: float = 0.05,
    runner: CommandRunner = run_command,
    sleeper: Callable[[float], None] = time.sleep,
) -> bool:
    client: dict[str, Any] | None = None
    clients: list[dict[str, Any]] = []

    for attempt in range(attempts):
        clients_result = _invoke(runner, [hyprctl, "-j", "clients"])
        clients = _load_list(clients_result)
        client = find_viewer_client(clients, process_id)
        if client is not None:
            break
        if attempt + 1 < attempts:
            sleeper(retry_delay)

    if client is None:
        return False

    workspace = client.get("workspace", {})
    workspace_id = workspace.get("id")
    monitor_id = client.get("monitor")
    address = client.get("address")
    if workspace_id is None or monitor_id is None or not address:
        return False

    peers = [
        candidate
        for candidate in clients
        if candidate.get("address") != address
        and candidate.get("mapped", True)
        and not candidate.get("floating", False)
        and candidate.get("monitor") == monitor_id
        and candidate.get("workspace", {}).get("id") == workspace_id
    ]
    if not peers:
        return True

    monitors_result = _invoke(runner, [hyprctl, "-j", "monitors"])
    monitors = _load_list(monitors_result)
    monitor = next(
        (candidate for candidate in monitors if candidate.get("id") == monitor_id),
        None,
    )
    if monitor is None:
        return False

    root_result = _invoke(
        runner,
        [
            hyprctl,
            "dispatch",
            f'hl.dsp.layout("movetoroot address:{address} unstable")',
        ],
    )
    if root_result is None or root_result.returncode != 0:
        return False

    refreshed_result = _invoke(runner, [hyprctl, "-j", "clients"])
    refreshed_clients = _load_list(refreshed_result)
    refreshed_client = find_viewer_client(refreshed_clients, process_id)
    if refreshed_client is None:
        return False

    try:
        split_ratio = split_ratio_for_viewer(
            refreshed_client,
            monitor,
            width_fraction,
        )
    except (IndexError, KeyError, TypeError, ValueError, ZeroDivisionError):
        return False

    focus_result = _invoke(
        runner,
        [
            hyprctl,
            "dispatch",
            f'hl.dsp.focus({{ window = "address:{address}" }})',
        ],
    )
    if focus_result is None or focus_result.returncode != 0:
        return False

    ratio_text = format(split_ratio, ".6g")
    ratio_result = _invoke(
        runner,
        [
            hyprctl,
            "dispatch",
            f'hl.dsp.layout("splitratio {ratio_text} exact")',
        ],
    )
    return ratio_result is not None and ratio_result.returncode == 0


def _invoke(
    runner: CommandRunner,
    arguments: list[str],
) -> subprocess.CompletedProcess[str] | None:
    try:
        return runner(arguments)
    except (OSError, subprocess.SubprocessError):
        return None


def _load_list(result: subprocess.CompletedProcess[str] | None) -> list[dict[str, Any]]:
    if result is None or result.returncode != 0:
        return []
    try:
        value = json.loads(result.stdout)
    except (json.JSONDecodeError, TypeError):
        return []
    if not isinstance(value, list):
        return []
    return [item for item in value if isinstance(item, dict)]
