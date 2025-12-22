{ config, lib, pkgs, ... }:
{
    imports = [
        ../home-base.nix 
    ];

    my.home-base.enableBrightness = true;

    my.hyprland = {
        enable = true;
        monitors = [
          "eDP-1, preferred, 0x0, 1"
          "DP-1, preffered, -2560x0, 1"
        ];

        workspaces = [
            "1, DP-1"
            "2, DP-1"
            "3, DP-1"
            "4, DP-1"
            "5, DP-1"
            "6, eDP-1"
            "7, eDP-1"
            "8, eDP-1"
            "9, eDP-1"
            "10, eDP-1"
        ];
    };

    home.packages = with pkgs; [
        brightnessctl
    ];
}
