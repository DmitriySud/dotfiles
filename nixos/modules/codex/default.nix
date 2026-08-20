{ config, lib, pkgs, pkgsUnstable ? pkgs, ... }:

let
  cfg = config.my.codex;
in
{
  options.my.codex = {
    enable = lib.mkEnableOption "codex-agent";
  };

  config = lib.mkIf cfg.enable {

    home.packages = [
      pkgsUnstable.codex
    ];
    #home.file.".codex/config.toml".source = ./config.toml;
  };
}
