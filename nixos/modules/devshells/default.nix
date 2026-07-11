{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.devshells;

  # Launch a dev environment inside a dedicated tmux server (separate `-L`
  # socket so it never collides with the byobu/default server). The tmux
  # server captures the dev shell's PATH at start, so every window and pane
  # it spawns inherits the toolchain without re-entering the shell.
  mkWrapper =
    command: shell:
    pkgs.writeShellScriptBin command ''
      exec nix develop "${cfg.flake}#${shell}" --command \
        tmux -L "${shell}dev" new-session -A -s "${shell}"
    '';
in
{
  options.my.devshells = {
    enable = lib.mkEnableOption "C++/Go dev environments launched in dedicated tmux servers";

    flake = lib.mkOption {
      type = lib.types.str;
      default = "$HOME/repos/dotfiles/nixos";
      description = "Flake reference providing the cpp/go devShells.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      (mkWrapper "cppdev" "cpp")
      (mkWrapper "godev" "go")
    ];
  };
}
