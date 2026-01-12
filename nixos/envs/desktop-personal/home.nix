{ config, lib, pkgs, ... }:
{
    imports = [
        ../home-desktop.nix
    ];

    my.home-base.git-email = "dmitriy.sudakov2001@yandex.ru";

    my.hyprland = {
        enable = true;
        monitors = [
          "DP-1, preferred, 0x0, 1"
        ];

        workspaces = [
            "1, monitor:DP-1"
            "2, monitor:DP-1"
            "3, monitor:DP-1"
            "4, monitor:DP-1"
            "5, monitor:DP-1"
            "6, monitor:DP-1"
            "7, monitor:DP-1"
            "8, monitor:DP-1"
            "9, monitor:DP-1"
            "10, monitor:DP-1"
        ];

        hypridle.can-suspend = false;
    };
}
