{
  config,
  lib,
  pkgs,
  pkgsUnstable,
  ...
}:
{
  imports = [
    ../home-terminal.nix
    ../../modules/earlyoom
    ../../modules/claude-code
    ../../modules/codex
  ];

  home.packages = [
    pkgsUnstable.herdr
    pkgs.glow
  ];

  my.home-base.git-email = "dyusudakov@yandex-team.ru";
  my.syncthing.enable = true;
  my.claude-code.enable = false;
  my.codex.enable = true;
  my.earlyoom.enable = true;
}
