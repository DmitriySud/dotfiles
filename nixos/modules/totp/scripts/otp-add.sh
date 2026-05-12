set -euo pipefail

if [ "$#" -lt 1 ]; then
  echo "usage: otp-add <pass-entry>"
  echo
  echo "examples:"
  echo "  otp-add totp/github"
  echo "  otp-add totp/work/aws"
  exit 2
fi

entry="$1"

echo "Paste the TOTP secret or otpauth:// URI when prompted."
echo

gopass insert "$entry" totp
