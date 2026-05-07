#!/usr/bin/env bash
set -euo pipefail

ws="$(hyprctl activeworkspace -j | jq -r '.id')"

is_grouped() {
local addr="$1"

hyprctl clients -j | jq -e --arg addr "$addr" '
  .[]
  | select(.address == $addr)
  | (.grouped // [])
  | length > 0
' >/dev/null
}

mapfile -t wins < <(
hyprctl clients -j |
  jq -r --argjson ws "$ws" '
    .[]
    | select(.workspace.id == $ws)
    | select(.floating == false)
    | .address
  '
)

[ "''${#wins[@]}" -lt 2 ] && exit 0

# Start the group from the currently focused window if possible.
active="$(hyprctl activewindow -j | jq -r '.address')"

group_base="''${wins[0]}"
for addr in "''${wins[@]}"; do
if [ "$addr" = "$active" ]; then
  group_base="$addr"
  break
fi
done

hyprctl dispatch focuswindow "address:$group_base"
hyprctl dispatch togglegroup

for addr in "''${wins[@]}"; do
[ "$addr" = "$group_base" ] && continue

hyprctl dispatch focuswindow "address:$addr"

# Try every direction, because the group may be left/right/up/down
# depending on the current layout tree.
for dir in l r u d; do
  hyprctl dispatch moveintogroup "$dir" || true

  if is_grouped "$addr"; then
    break
  fi
done
done

hyprctl dispatch focuswindow "address:$group_base"
