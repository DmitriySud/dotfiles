#!/usr/bin/env bash
set -euo pipefail

# Generate a new GPG keypair (ed25519 sign/cert + cv25519 encrypt subkey)
# in a TEMPORARY keyring, so it works even with mutableKeys = false.
# Exports <env>.pub (for the nixos repo) and <env>.sec (to import locally).

read -rp "NixOS env name (e.g. laptop-personal): " env_name
if [ -z "${env_name}" ]; then
  echo "Env name must not be empty." >&2
  exit 1
fi

read -rsp "Passphrase for the new key: " pass1; echo
read -rsp "Repeat passphrase: " pass2; echo
if [ "${pass1}" != "${pass2}" ]; then
  echo "Passphrases do not match." >&2
  exit 1
fi

name="Sudakov Dmitriy"
email="dmitriy.sudakov2001@gmail.com"

tmp_home=$(mktemp -d)
trap 'gpgconf --homedir "${tmp_home}" --kill gpg-agent 2>/dev/null || true; rm -rf "${tmp_home}"' EXIT
chmod 700 "${tmp_home}"

echo "Generating key for: ${name} (${env_name}) <${email}>"

gpg --homedir "${tmp_home}" --batch \
    --pinentry-mode loopback --passphrase-fd 3 \
    --gen-key 3<<<"${pass1}" <<EOF
Key-Type: eddsa
Key-Curve: ed25519
Key-Usage: sign
Subkey-Type: ecdh
Subkey-Curve: cv25519
Subkey-Usage: encrypt
Name-Real: ${name}
Name-Comment: ${env_name}
Name-Email: ${email}
Expire-Date: 0
%commit
EOF

fpr=$(gpg --homedir "${tmp_home}" --with-colons --list-keys | awk -F: '$1 == "fpr" { print $10; exit }')

gpg --homedir "${tmp_home}" --armor --export "${fpr}" > "${env_name}.pub"
gpg --homedir "${tmp_home}" --batch \
    --pinentry-mode loopback --passphrase-fd 3 \
    --armor --export-secret-keys "${fpr}" 3<<<"${pass1}" > "${env_name}.sec"
chmod 600 "${env_name}.sec"

echo
echo "Fingerprint: ${fpr}"
echo "Written: ./${env_name}.pub  ./${env_name}.sec"
echo
echo "Next steps:"
echo "  1. Copy ${env_name}.pub into your nixos repo pubkeys/ and add it to publicKeys; commit, push."
echo "  2. Rebuild this machine."
echo "  3. gpg --import ${env_name}.sec   # secret part into the real keyring"
echo "  4. Securely delete ${env_name}.sec (shred -u ${env_name}.sec)."
