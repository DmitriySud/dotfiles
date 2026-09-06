{
  config,
  lib,
  pkgs,
  allowed-unfree-packages,
  ...
}:

{
  nixpkgs.config = {
    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) allowed-unfree-packages;
  };

  imports = [
    ./hardware-configuration.nix
    ../configuration-base.nix
  ];
}
