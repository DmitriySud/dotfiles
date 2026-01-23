{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../home-terminal.nix
  ];

  my.home-base.git-email = "dsudakov@hyperad.tech";
  my.byobu.enable = true;
  my.syncthing.enable = false;
}
