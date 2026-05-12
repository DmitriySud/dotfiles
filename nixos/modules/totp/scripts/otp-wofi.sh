set -euo pipefail

store_dir="${PASSWORD_STORE_DIR:-$HOME/.password-store}"
otp_prefix="${OTP_PREFIX:-totp}"

if [ -n "$otp_prefix" ]; then
  search_root="$store_dir/$otp_prefix"
else
  search_root="$store_dir"
fi

if [ ! -d "$search_root" ]; then
  notify-send "2FA" "No OTP directory found: $search_root"
  exit 1
fi

entry="$(
  find "$search_root" -type f -name '*.gpg' \
    | sed "s|^$store_dir/||" \
    | sed 's|\.gpg$||' \
    | sort \
    | wofi --dmenu --prompt "2FA"
)"

[ -n "$entry" ] || exit 0

code="$(gopass otp --password "$entry")"

printf '%s' "$code" | wl-copy
notify-send "2FA" "Copied OTP for $entry"
