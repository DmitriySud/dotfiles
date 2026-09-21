{
  config,
  lib,
  pkgs,
  ...
}:

let 

  swaylockRescue = ".config/hypr/scripts/swaylock-rescue.sh";
in {
  imports = [
    ./core.nix
    ./hypridle.nix
    ./hyprlock.nix
    ./hyprpaper.nix
    ./waybar.nix
    ./swaync.nix
    ./misc-packages.nix
  ];
  home.file.${swaylockRescue} = {
    executable = true;
    source = ./scripts/swaylock-rescue.sh;
  };
}
