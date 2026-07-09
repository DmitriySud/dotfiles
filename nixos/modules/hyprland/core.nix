{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.hyprland;
  hyprPlugins =
    lib.optional cfg.hypridle.enable pkgs.hypridle
    ++ lib.optional cfg.hyprpaper.enable pkgs.hyprpaper
    ++ lib.optional cfg.hyprlock.enable pkgs.hyprlock;

  brightnessControlBinds = lib.optionalString cfg.enableBrightness ''
    hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 10%-"))
    hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s +10%"))
  '';
  passWofiSubmap = lib.optionalString config.my.passWofi.enable ''
    hl.bind(mod .. " + P", hl.dsp.submap("pass-wofi"))

    hl.define_submap("pass-wofi", "reset", function()
        hl.bind("P", hl.dsp.exec_cmd("pass-pass"))
        hl.bind("L", hl.dsp.exec_cmd("pass-login"))
        hl.bind("O", hl.dsp.exec_cmd("pass-pass-by-login"))
        hl.bind("A", hl.dsp.exec_cmd("totp-entry"))
        hl.bind("Escape", hl.dsp.submap("reset"))
        hl.bind("catchall", hl.dsp.submap("reset"))
    end)
  '';
  groupWorkspaceScript = ".config/hypr/scripts/group-workspace.sh";
  groupWorkspaceScriptPath = "~/${groupWorkspaceScript}";

  xkbConfig = if config.my.xkbPunct.enable then ''
      kb_file = "${config.my.xkbPunct.kbFile}",
  '' else ''
      kb_layout = "us,ru",
      kb_options = "grp:caps_toggle",
  '';
in
{
  options.my.hyprland = {
    enable = lib.mkEnableOption "Hyprland stack";

    monitors = lib.mkOption {
      type = lib.types.str;
      default = [ "eDP-1,preferred,0x0,1" ];
    };

    workspaces = lib.mkOption {
      type = lib.types.str;
    };

    extraBinds = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };

    enableBrightness = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable brightness control";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      jq
      hyprland
      hyprshot
    ];

    home.file.${groupWorkspaceScript} = {
      executable = true;
      source = ./scripts/group-wrokspace.sh;
    };


    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = true;
      xwayland.enable = true;
      plugins = hyprPlugins;

      extraConfig = ''
        local mod = "SUPER"
        hl.animation({
            leaf = "workspaces",
            enabled = false,
            speed = 1,
            bezier = "default",
        })
        hl.bind(mod .. " + RETURN", hl.dsp.exec_cmd("alacritty"))
        hl.bind(mod .. " + SPACE", hl.dsp.exec_cmd("wofi --show drun"))
        hl.bind(mod .. " + Q", hl.dsp.window.close())
        hl.bind(mod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
        hl.bind(mod .. " + SHIFT + E", hl.dsp.exit())
        hl.bind(mod .. " + SHIFT + I", hl.dsp.exec_cmd("lock"))
        hl.bind(mod .. " + h", hl.dsp.focus({ direction = "left" }))
        hl.bind(mod .. " + l", hl.dsp.focus({ direction = "right" }))
        hl.bind(mod .. " + k", hl.dsp.focus({ direction = "up" }))
        hl.bind(mod .. " + j", hl.dsp.focus({ direction = "down" }))
        hl.bind(mod .. " + SHIFT + h", hl.dsp.window.move({ direction = "l" }))
        hl.bind(mod .. " + SHIFT + l", hl.dsp.window.move({ direction = "r" }))
        hl.bind(mod .. " + SHIFT + k", hl.dsp.window.move({ direction = "u" }))
        hl.bind(mod .. " + SHIFT + j", hl.dsp.window.move({ direction = "d" }))
        hl.bind(mod .. " + 1", hl.dsp.focus({ workspace = 1 }))
        hl.bind(mod .. " + 2", hl.dsp.focus({ workspace = 2 }))
        hl.bind(mod .. " + 3", hl.dsp.focus({ workspace = 3 }))
        hl.bind(mod .. " + 4", hl.dsp.focus({ workspace = 4 }))
        hl.bind(mod .. " + 5", hl.dsp.focus({ workspace = 5 }))
        hl.bind(mod .. " + 6", hl.dsp.focus({ workspace = 6 }))
        hl.bind(mod .. " + 7", hl.dsp.focus({ workspace = 7 }))
        hl.bind(mod .. " + 8", hl.dsp.focus({ workspace = 8 }))
        hl.bind(mod .. " + 9", hl.dsp.focus({ workspace = 9 }))
        hl.bind(mod .. " + 0", hl.dsp.focus({ workspace = 10 }))
        hl.bind(mod .. " + SHIFT + 1", hl.dsp.window.move({ workspace = 1 }))
        hl.bind(mod .. " + SHIFT + 2", hl.dsp.window.move({ workspace = 2 }))
        hl.bind(mod .. " + SHIFT + 3", hl.dsp.window.move({ workspace = 3 }))
        hl.bind(mod .. " + SHIFT + 4", hl.dsp.window.move({ workspace = 4 }))
        hl.bind(mod .. " + SHIFT + 5", hl.dsp.window.move({ workspace = 5 }))
        hl.bind(mod .. " + SHIFT + 6", hl.dsp.window.move({ workspace = 6 }))
        hl.bind(mod .. " + SHIFT + 7", hl.dsp.window.move({ workspace = 7 }))
        hl.bind(mod .. " + SHIFT + 8", hl.dsp.window.move({ workspace = 8 }))
        hl.bind(mod .. " + SHIFT + 9", hl.dsp.window.move({ workspace = 9 }))
        hl.bind(mod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))
        hl.bind(mod .. " + ALT + G", hl.dsp.exec_cmd("~/.config/hypr/scripts/group-workspace.sh"))
        hl.bind(mod .. " + G", hl.dsp.group.toggle())
        hl.bind(mod .. " + TAB", hl.dsp.group.next())
        hl.bind(mod .. " + ALT + TAB", hl.dsp.group.prev())
        hl.bind(mod .. " + ALT + h", hl.dsp.window.move({ into_or_create_group = "l" }))
        hl.bind(mod .. " + ALT + l", hl.dsp.window.move({ into_or_create_group = "r" }))
        hl.bind(mod .. " + ALT + k", hl.dsp.window.move({ into_or_create_group = "u" }))
        hl.bind(mod .. " + ALT + j", hl.dsp.window.move({ into_or_create_group = "d" }))
        hl.bind(mod .. " + CTRL + h", hl.dsp.window.resize({ x = -50, y = 0, relative = true }))
        hl.bind(mod .. " + CTRL + l", hl.dsp.window.resize({ x = 50, y = 0, relative = true }))
        hl.bind(mod .. " + CTRL + k", hl.dsp.window.resize({ x = 0, y = -50, relative = true }))
        hl.bind(mod .. " + CTRL + j", hl.dsp.window.resize({ x = 0, y = 50, relative = true }))
        hl.bind(mod .. " + PRINT", hl.dsp.exec_cmd("hyprshot -m output"))
        hl.bind(mod .. " + SHIFT + PRINT", hl.dsp.exec_cmd("hyprshot -m region --clipboard-only --freeze"))
        hl.bind("PRINT", hl.dsp.exec_cmd("hyprshot -m window"))
        hl.bind("CTRL + ALT + 1", hl.dsp.exec_cmd("hyprctl switchxkblayout all 0"))
        hl.bind("CTRL + ALT + 2", hl.dsp.exec_cmd("hyprctl switchxkblayout all 1"))
        hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pactl -- set-sink-volume 0 -10%"))
        hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pactl -- set-sink-volume 0 +10%"))
        hl.bind("XF86AudioMute", hl.dsp.exec_cmd("pactl -- set-sink-mute 0 toggle"))
        hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("pactl -- set-source-mute 0 toggle"))
        ${brightnessControlBinds}

        hl.env("PASSWORD_STORE_DIR", "/home/dsudakov/repos/dotfiles/nixos/passes")


        hl.window_rule({
            match = {
                class = "class: ^(org.telegram.desktop)$",
            },
            workspace = "3",
            -- TODO: manual review — unmapped window rule action: "noborder"
            rounding = 0,
            float = false,
            maximize = true,
        })
        ${config.my.hyprland.monitors}
        ${config.my.hyprland.workspaces}
        ${passWofiSubmap}
        hl.config({
            animations = {
                enabled = true,
            },
            decoration = {
                active_opacity = 1,
                border_part_of_window = false,
                inactive_opacity = 0.900000,
                rounding = 4,
            },
            general = {
                border_size = 3,
                gaps_in = 2,
                gaps_out = 5,
            },
            input = {
                touchpad = {
                    natural_scroll = false,
                },
                follow_mouse = 1,
                ${xkbConfig}
            },
        })
      '';
    };

    home.sessionVariables = {
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
      NIXOS_OZONE_WL = "1";
    };

    systemd.user.sessionVariables = {
      XKB_CONFIG_EXTRA_PATH = config.my.xkbPunct.xkbExtraPath;
    };
  };
}
