{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../home-terminal.nix
    ../../modules/earlyoom
    ../../modules/claude-code
    ../../modules/codex
    ../../modules/herdr
  ];

  home.packages = [
    pkgs.glow
  ];

  my.home-base.git-email = "dyusudakov@yandex-team.ru";
  my.syncthing.enable = true;
  my.claude-code.enable = false;
  my.codex.enable = true;
  my.earlyoom.enable = true;
  my.herdr.enable = true;
}
