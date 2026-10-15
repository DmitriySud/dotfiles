"""Extract existing files without evaluating terminal text as shell commands."""

import os
from pathlib import Path
import re
import subprocess


TOKENS = re.compile(
    r'''"([^"\n]+)"|'([^'\n]+)'|`([^`\n]+)`|((?:\\[^\n]|[^\s"'`<>\[\]{}()=,;|\\])+)'''
)
LOCATION = re.compile(r":\d+(?::\d+)?$")


def get_files(text, cwd):
    """Return unique file references, preserving their displayed path spelling."""
    files = []
    checked = {}
    for match in TOKENS.finditer(text):
        token = next(value for value in match.groups() if value is not None)
        if match[4] is not None:
            token = re.sub(r"\\(.)", r"\1", token)
        trimmed = token.rstrip(".:!?")
        for candidate in dict.fromkeys((token, trimmed, LOCATION.sub("", trimmed))):
            if candidate not in checked:
                try:
                    path = Path(os.path.expanduser(candidate))
                    checked[candidate] = (Path(cwd) / path).is_file()
                except (OSError, ValueError):
                    checked[candidate] = False
            if checked[candidate]:
                files.append(candidate)
                break
    return list(dict.fromkeys(files))


def capture_files(trigger_pane, grab_area, capture_start):
    """Resolve each captured pane's file references against that pane's cwd."""
    def tmux(*args):
        return subprocess.check_output(["tmux", *args], text=True, encoding="utf-8")

    panes = []
    if grab_area.startswith("window "):
        for line in tmux("list-panes", "-t", trigger_pane, "-F", "#{pane_active} #{pane_id}").splitlines():
            active, pane = line.split()
            # In split mode the active pane is the picker itself.
            if active == "0" and pane != trigger_pane:
                panes.append(pane)
    panes.append(trigger_pane)

    files = []
    for pane in panes:
        cwd = tmux("display-message", "-p", "-t", pane, "#{pane_current_path}").rstrip("\n")
        text = tmux("capture-pane", "-pJS", capture_start, "-t", pane)
        files.extend(get_files(text, cwd))
    return "\n".join(dict.fromkeys(reversed(files)))
