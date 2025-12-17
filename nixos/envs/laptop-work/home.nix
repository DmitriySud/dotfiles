{ config, lib, pkgs, ... }:
{
    imports = [
        ../home-base.nix
    ];

    my.hyprland = {
        enable = true;
        monitors = [
          "eDP-1, preferred, 0x0, 1"
          "HDMI-A-1, preffered, -2560x0, 1"
        ];

        workspaces = [
            "1, HDMI-A-1"
            "2, HDMI-A-1"
            "3, HDMI-A-1"
            "4, HDMI-A-1"
            "5, HDMI-A-1"
            "6, eDP-1"
            "7, eDP-1"
            "8, eDP-1"
            "9, eDP-1"
            "10, eDP-1"
        ];
    };
}
