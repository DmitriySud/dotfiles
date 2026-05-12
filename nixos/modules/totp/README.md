# TOTP / 2FA

This module adds CLI-based TOTP support using `gopass`.

It installs:

- `gopass`
- `otp-add`
- `otp-wofi`

TOTP secrets are stored in the same GPG-encrypted password store used by pass/gopass.

## Storage layout

Recommended layout:

```text
totp/github
totp/vk
totp/work/aws
```

## Add a new TOTP secret

```bash
otp-add totp/github
```

Paste the raw TOTP secret or `otpauth://` URI when prompted.

The helper stores the value in the `totp` field of the selected pass entry.

## Generate a code manually

```bash
gopass otp --password totp/github
```

## Pick a code with Wofi

```bash
otp-wofi
```

This opens a Wofi menu with entries from the configured TOTP prefix, generates the selected code, copies it to the clipboard, and sends a notification.

## Recovery codes

Store recovery codes separately:

```bash
pass insert -m totp/github-recovery-codes
```

## Security note

Keeping passwords and TOTP secrets in the same encrypted store is convenient, reproducible, and works well with Nix-managed machines.

The downside is that a fully compromised decrypted password store may expose both passwords and TOTP seeds. For stronger separation, use a hardware security key or a separate authenticator device.
