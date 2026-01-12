{ config, lib, pkgs, ... }:
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
          "DP-1, preffered, -2560x0, 1"
        ];

        workspaces = [
            "1, monitor:DP-1"
            "2, monitor:DP-1"
            "3, monitor:DP-1"
            "4, monitor:DP-1"
            "5, monitor:DP-1"
            "6, monitor:eDP-1"
            "7, monitor:eDP-1"
            "8, monitor:eDP-1"
            "9, monitor:eDP-1"
            "10, monitor:eDP-1"
        ];
    };

    my.alacritty.fontSize = 15.0;
}
