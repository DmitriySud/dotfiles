{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.devshells;

  # The dev shells exposed by the flake; each becomes a `<name>dev` command.
  shells = [
    "cpp"
    "go"
  ];

  # Launch a dev environment inside its own byobu server (isolated `-L`
  # socket so it never collides with the default byobu session). The server
  # captures the dev shell's PATH at start, so every window and pane it
  # spawns inherits the toolchain without re-entering the shell. `-A` means
  # re-running the command just re-attaches to the persistent session, which
  # is exactly what you want over ssh on the vps.
  wrapper =
    shell:
    pkgs.writeShellScriptBin "${shell}dev" ''
      # When launched from a drun launcher we bypass login/interactive shells,
      # so /etc/set-environment was never sourced and the
      # __NIXOS_SET_ENVIRONMENT_DONE guard is unset. Shells spawned inside the
      # tmux server would then re-source it and clobber the dev PATH.
      if [ -z "''${__NIXOS_SET_ENVIRONMENT_DONE:-}" ] && [ -e /etc/set-environment ]; then
        . /etc/set-environment
      fi

      nix develop "${cfg.flake}#${shell}" --command byobu -L "${shell}" new-session -A -s "${shell}"
    '';

  wrapperPkgs = lib.genAttrs shells wrapper;

  # A .desktop entry per shell so they show up in `wofi --show drun`.
  # Exec references the wrapper by absolute store path so it does not depend
  # on the launcher's PATH.
  desktopEntry = shell: {
    name = "${shell}dev";
    value = {
      name = "${lib.toUpper shell} dev shell";
      genericName = "Development environment";
      exec = "alacritty -e ${shell}dev";
      terminal = false;
      categories = [ "Development" ];
    };
  };
in
{
  options.my.devshells = {
    enable = lib.mkEnableOption "C++/Go dev environments launched in dedicated byobu servers";

    flake = lib.mkOption {
      type = lib.types.str;
      default = "$HOME/repos/dotfiles/nixos";
      description = "Flake reference providing the cpp/go devShells.";
    };

    desktopEntries = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Register .desktop launchers (for `wofi --show drun`); needs alacritty.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = lib.attrValues wrapperPkgs;

    xdg.desktopEntries = lib.mkIf cfg.desktopEntries (
      lib.listToAttrs (map desktopEntry shells)
    );
  };
}
