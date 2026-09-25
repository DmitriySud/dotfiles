{ config, lib, pkgs, pkgsUnstable, ... }:

let
  cfg = config.my.codex;
  codex = pkgs.callPackage ../../packages/codex { };
in
{
  options.my.codex = {
    enable = lib.mkEnableOption "codex-agent";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgsUnstable.codex
      pkgs.bubblewrap
    ];
    #home.file.".codex/config.toml".source = ./config.toml;
  };
}
