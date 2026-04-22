#!/usr/bin/env bash
set -euo pipefail

# Re-encrypt the pass store to all PRIMARY public keys currently present in GPG.
# We intentionally ignore subkey fingerprints here.

mapfile -t recipients < <(
  gpg --with-colons --list-keys | awk -F: '
    $1 == "pub" { want = 1; next }
    $1 == "sub" { want = 0 }
    want && $1 == "fpr" { print $10 }
  '
)

if [ "${#recipients[@]}" -eq 0 ]; then
  echo "No public keys found in GPG keyring." >&2
  exit 1
fi

echo "Re-encrypting pass store for recipients:"
printf '  %s\n' "${recipients[@]}"

pass init "${recipients[@]}"
