{
  config,
  lib,
  pkgs,
  ...
}:

{
  nixpkgs.config = {
    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) ["obsidian"];
  };

  imports = [
    ./hardware-configuration.nix
    ../configuration-base.nix
  ];
}
