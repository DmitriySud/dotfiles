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
  ];

  my.home-base.git-email = "dyusudakov@yandex-team.ru";
  my.syncthing.enable = lib.mkForce false;
  my.claude-code.enable = true;
}
