{ config, lib, pkgs, ... }:

let
  cfg = config.my.hyprland;
in {
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      waybar
      wofi
      hypridle
      hyprlock
      hyprpaper
      hyprshot
      wl-clipboard
      swayimg
      nemo
      cliphist
      networkmanagerapplet
      blueman
      pavucontrol
      pamixer
    ];
  };
}

