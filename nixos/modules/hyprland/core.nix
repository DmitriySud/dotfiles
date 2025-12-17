{ config, lib, pkgs, ... }:

let
  cfg = config.my.hyprland;
  hyprPlugins =
    lib.optional cfg.hypridle.enable pkgs.hypridle
    ++ lib.optional cfg.hyprpaper.enable pkgs.hyprpaper
    ++ lib.optional cfg.hyprlock.enable pkgs.hyprlock;
in {
  options.my.hyprland = {
    enable = lib.mkEnableOption "Hyprland stack";

    monitors = lib.mkOption {
      type    = lib.types.listOf lib.types.str;
      default = [ "eDP-1,preferred,0x0,1" ];
    };

    workspaces = lib.mkOption {
      type    = lib.types.listOf lib.types.str;
      default = [
        "1, monitor:eDP-1"
        "2, monitor:eDP-1"
      ];
    };

    extraBinds = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ hyprland hyprshot ];

    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = true;
      xwayland.enable = true;
      plugins = hyprPlugins;

      windowrulev2 = [
        "workspace 3, class: ^(org.telegram.desktop)$"
        "noborder, class: ^(org.telegram.desktop)$"
        "rounding 0, class: ^(org.telegram.desktop)$"
        "tile, class: ^(org.telegram.desktop)$"
        "maximize, class: ^(org.telegram.desktop)$"
      ];


      settings = {
        exec-once = [ 
            "nm-applet" 
            "telegram-desktop" 
        ];
        input = {
          kb_layout = "us,ru";
          kb_options = "grp:caps_toggle";
          follow_mouse = 1;
          touchpad.natural_scroll = false;
        };

        "$mod" = "SUPER";

        bind = [
          "$mod, RETURN, exec, alacritty"
          "$mod, SPACE, exec, wofi --show drun"
          "$mod, Q, killactive,"
          "$mod, F, fullscreen"
          "$mod SHIFT, E, exit,"
          "$mod SHIFT, L, exec, hyprlock"
          "$mod, h, movefocus, l"
          "$mod, l, movefocus, r"
          "$mod, k, movefocus, u"
          "$mod, j, movefocus, d"
          "$mod, 1, workspace, 1"
          "$mod, 2, workspace, 2"
          "$mod, 3, workspace, 3"
          "$mod, 4, workspace, 4"
          "$mod, 5, workspace, 5"
          "$mod, 6, workspace, 6"
          "$mod, 7, workspace, 7"
          "$mod, 8, workspace, 8"
          "$mod, 9, workspace, 9"
          "$mod, 0, workspace, 10"
          "$mod SHIFT, 1, movetoworkspace, 1"
          "$mod SHIFT, 2, movetoworkspace, 2"
          "$mod SHIFT, 3, movetoworkspace, 3"
          "$mod SHIFT, 4, movetoworkspace, 4"
          "$mod SHIFT, 5, movetoworkspace, 5"
          "$mod SHIFT, 6, movetoworkspace, 6"
          "$mod SHIFT, 7, movetoworkspace, 7"
          "$mod SHIFT, 8, movetoworkspace, 8"
          "$mod SHIFT, 9, movetoworkspace, 9"
          "$mod SHIFT, 0, movetoworkspace, 10"
          "$mod CTRL, h, resizeactive, -50 0"
          "$mod CTRL, l, resizeactive,  50 0"
          "$mod CTRL, k, resizeactive,   0 -50"
          "$mod CTRL, j, resizeactive,   0  50"
          "$mod, PRINT, exec, hyprshot -m output"
          "$mod SHIFT, PRINT, exec, hyprshot -m region --clipboard-only --freeze"
          ", PRINT, exec, hyprshot -m window"
          "CTRL ALT, 1, exec, hyprctl switchxkblayout all 0"
          "CTRL ALT, 2, exec, hyprctl switchxkblayout all 1"
        ] ++ cfg.extraBinds;

        monitor   = cfg.monitors;
        workspace = cfg.workspaces ++ [
            "3, name: Telegram"
            "3, on-created-empty: telegram-desktop"
        ];

        decoration = {
          rounding = 4;
          border_part_of_window = false;
          active_opacity = 1;
          inactive_opacity = 0.9;
        };

        general = {
          border_size = 3;
          gaps_in = 2;
          gaps_out = 5;
        };
      };
    };

    home.sessionVariables = {
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
      NIXOS_OZONE_WL = "1";
    };
  };
}
