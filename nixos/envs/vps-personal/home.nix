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

  my.home-base.git-email = "dmitriy.sudakov2001@gmail.com";
  my.byobu.enable = true;
  my.syncthing.enable = true;
}
