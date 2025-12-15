{ config, lib, pkgs, ... }:

{
  imports = [
    ./core.nix
    ./hypridle.nix
    ./hyprlock.nix
    ./hyprpaper.nix
    ./waybar.nix
    ./swaync.nix
    ./misc-packages.nix
  ];
}
