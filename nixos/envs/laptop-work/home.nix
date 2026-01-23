{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../home-desktop.nix
  ];

  my.home-base.git-email = "dmitriy.sudakov2001@yandex.ru";
  my.home-base.enableBrightness = true;

  my.hyprland = {
    enable = true;
    monitors = [
      "eDP-1, preferred, 0x0, 1"
      "HDMI-A-1, preffered, -2560x0, 1"
    ];

    workspaces = [
      "1, monitor:HDMI-A-1"
      "2, monitor:HDMI-A-1"
      "3, monitor:HDMI-A-1"
      "4, monitor:HDMI-A-1"
      "5, monitor:HDMI-A-1"
      "6, monitor:eDP-1"
      "7, monitor:eDP-1"
      "8, monitor:eDP-1"
      "9, monitor:eDP-1"
      "10, monitor:eDP-1"
    ];
  };
}
