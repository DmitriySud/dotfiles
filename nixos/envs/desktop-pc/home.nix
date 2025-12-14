{ config, lib, pkgs, ... }:
{
    imports = [
        ../home-base.nix
    ];

    my.hyprland = {
        enable = true;
        monitors = [
          "DP-1, preferred, 0x0, 1"
        ];

        workspaces = [
            "1, DP-1"
            "2, DP-1"
            "3, DP-1"
            "4, DP-1"
            "5, DP-1"
            "6, DP-1"
            "7, DP-1"
            "8, DP-1"
            "9, DP-1"
            "10, DP-1"
        ];
    };
}
