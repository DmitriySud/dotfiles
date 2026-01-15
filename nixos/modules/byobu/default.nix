{ config, lib, pkgs, ... }:

let
  cfg = config.my.byobu;
in
{
  options.my.byobu = {
    enable = lib.mkEnableOption "Byobu configuration (links ~/.byobu/* and installs byobu)";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.byobu
      pkgs.tmux
    ];

    home.file.".byobu/color.tmux".source = ./files/color.tmux;
    home.file.".byobu/.reuse-session".source = ./files/.reuse-session;
    home.file.".byobu/.tmux.conf".source = ./files/.tmux.conf;
  };
}

