{ pkgs }:

{
  type = "app";
  program = "${pkgs.writeShellScript "nixfmt-all" ''
    set -euo pipefail

    echo "Formatting Nix files…"

    find . \
      -type f \
      -name "*.nix" \
      -not -path "./.git/*" \
      -print \
      -exec ${pkgs.nixfmt-rfc-style}/bin/nixfmt {} +

    echo "Done ✨"
  ''}";
}

