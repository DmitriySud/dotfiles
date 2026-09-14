#!/usr/bin/env bash
# Recover from Hyprland's crashed-locker screen using the apt-installed swaylock.
# Log into another TTY as your desktop user, then run: ~/swaylock-rescue
# Optional argument: a Hyprland instance index or ID (default: 0).
# List instances with: hyprctl instances
# Supports both the Lua and older hyprlang command interfaces.
# Lock restoration stays enabled until your Hyprland config is reloaded.

set -euo pipefail

die() { printf '%s\n' "$*" >&2; exit 1; }

(( EUID != 0 )) || die 'Log in as your desktop user and run without sudo.'
(( $# <= 1 )) || die 'Usage: swaylock-rescue [instance-index-or-id]'

# A TTY shell may not have loaded the Nix profile into PATH.
export PATH="$PATH:$HOME/.nix-profile/bin:$HOME/.local/state/nix/profile/bin"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$UID}"
command -v hyprctl >/dev/null || die 'hyprctl is missing from PATH. Load your Nix profile first.'
[[ -d $XDG_RUNTIME_DIR && -O $XDG_RUNTIME_DIR ]] || die 'Cannot find your user runtime directory.'
[[ -x /usr/bin/swaylock ]] || die 'Cannot find the apt-installed /usr/bin/swaylock.'

hc=(hyprctl -i "${1:-0}")

# Check the reply too: some hyprctl versions exit successfully on command errors.
request() {
    local reply
    if reply=$("${hc[@]}" "$@" 2>&1) && [[ $reply == ok ]]; then
        return 0
    fi
    printf 'Hyprland: %s\n' "$reply" >&2
    return 1
}

# Let Hyprland supply its own Wayland environment to the new locker.
# Keep startup errors in a predictable file for offline troubleshooting.
locker='umask 077; exec /usr/bin/swaylock >"$XDG_RUNTIME_DIR/swaylock-rescue.log" 2>&1'

if request eval 'hl.config({ misc = { allow_session_lock_restore = true } })' 2>/dev/null; then
    request eval "hl.dispatch(hl.dsp.exec_cmd([[$locker]]))" || die 'Could not request swaylock startup.'
else
    request keyword misc:allow_session_lock_restore 1 ||
        die 'Recovery failed. Check hyprctl instances, then pass the correct index to this script.'
    request dispatch exec "$locker" || die 'Could not request swaylock startup.'
fi

printf '%s\n' \
    "Requested swaylock in Hyprland instance ${1:-0}." \
    'Switch back to your graphical TTY (usually Ctrl+Alt+F1 or Ctrl+Alt+F2).' \
    'Enter your password on the new lock screen.' \
    'After recovery, log out of this rescue TTY with: exit' \
    "If startup fails, inspect: $XDG_RUNTIME_DIR/swaylock-rescue.log"

