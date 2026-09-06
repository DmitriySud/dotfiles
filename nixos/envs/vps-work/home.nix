{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../home-terminal.nix
    ../../modules/claude-code
    ../../modules/codex
  ];

  my.home-base.git-email = "dyusudakov@yandex-team.ru";
  my.syncthing.enable = true;
  my.claude-code.enable = false;
  my.codex.enable = true;
}
