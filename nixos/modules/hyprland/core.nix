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

  groupWorkspaceScript = ".config/hypr/scripts/group-workspace.sh";
  groupWorkspaceScriptPath = "~/${groupWorkspaceScript}";

  # --- input section ---
  inputConfig =
    if config.my.xkbPunct.enable then ''
      input = {
        kb_file = "${config.my.xkbPunct.kbFile}",
        follow_mouse = 1,
        touchpad = { natural_scroll = false },
      },
    '' else ''
      input = {
        kb_layout = "us,ru",
        kb_options = "grp:caps_toggle",
        follow_mouse = 1,
        touchpad = { natural_scroll = false },
      },
    '';

  # --- monitors: hl.monitor per entry ---
  # Hyprlang "NAME,RES,POS,SCALE" -> hl.monitor parses the same string form.
  monitorConfig = lib.concatMapStringsSep "\n" (m: ''hl.monitor("${m}")'') cfg.monitors;

  # --- workspaces ---
  workspaceConfig = lib.concatMapStringsSep "\n" (w: ''hl.workspace("${w}")'') (
    cfg.workspaces
    ++ [
      "3, name: Telegram"
      "3, on-created-empty: telegram-desktop"
    ]
  );

  # --- brightness binds ---
  brightnessControlBinds = lib.optionalString cfg.enableBrightness ''
    hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 10%-"), { locked = true })
    hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl s +10%"), { locked = true })
  '';

  # --- extra binds: each entry is "MOD + KEY" , a lua dispatcher string ---
  # NOTE: extraBinds now expects pre-formatted hl.bind(...) lines (see options note below).
  extraBindsConfig = lib.concatStringsSep "\n" cfg.extraBinds;

  # --- env ---
  envConfig =
    lib.optionalString config.my.passes.enable
      ''hl.env("PASSWORD_STORE_DIR", "${config.my.passes.passwordStoreDir}")'';

  # --- pass-wofi submap ---
  passWofiSubmap = lib.optionalString config.my.passWofi.enable ''
    hl.bind("SUPER + P", hl.dsp.submap("pass-wofi"))

    hl.define_submap("pass-wofi", function()
      hl.bind("P", hl.dsp.exec_cmd("pass-pass"))
      hl.bind("L", hl.dsp.exec_cmd("pass-login"))
      hl.bind("O", hl.dsp.exec_cmd("pass-pass-by-login"))
      hl.bind("A", hl.dsp.exec_cmd("totp-entry"))
      hl.bind("escape", hl.dsp.submap("reset"))
    end)
  '';

  hyprlandLua = ''
    local mod = "SUPER"

    -- ===== autostart (start-only) =====
    hl.on("hyprland.start", function()
      hl.exec_cmd("nm-applet")
      hl.exec_cmd("telegram-desktop")
    end)

    -- ===== config blocks =====
    hl.config({
      ${inputConfig}
      animations = {
        enabled = true,
        -- Disable workspace animations
        animation = "workspaces, 0, 1, default",
      },
      decoration = {
        rounding = 4,
        border_part_of_window = false,
        active_opacity = 1,
        inactive_opacity = 0.9,
      },
      general = {
        border_size = 3,
        gaps_in = 2,
        gaps_out = 5,
      },
    })

    -- ===== monitors =====
    ${monitorConfig}

    -- ===== workspaces =====
    ${workspaceConfig}

    -- ===== window rules =====
    hl.window_rule({ match = { class = "^(org.telegram.desktop)$" }, workspace = "3" })
    hl.window_rule({ match = { class = "^(org.telegram.desktop)$" }, noborder = true })
    hl.window_rule({ match = { class = "^(org.telegram.desktop)$" }, rounding = 0 })
    hl.window_rule({ match = { class = "^(org.telegram.desktop)$" }, tile = true })
    hl.window_rule({ match = { class = "^(org.telegram.desktop)$" }, maximize = true })

    -- ===== core binds =====
    hl.bind(mod .. " + RETURN", hl.dsp.exec_cmd("alacritty"))
    hl.bind(mod .. " + SPACE",  hl.dsp.exec_cmd("wofi --show drun"))
    hl.bind(mod .. " + Q",      hl.dsp.window.close())
    hl.bind(mod .. " + F",      hl.dsp.window.fullscreen())
    hl.bind(mod .. " + SHIFT + E", hl.dsp.exit())
    hl.bind(mod .. " + SHIFT + I", hl.dsp.exec_cmd("lock"))

    -- ===== focus =====
    hl.bind(mod .. " + h", hl.dsp.window.movefocus("l"))
    hl.bind(mod .. " + l", hl.dsp.window.movefocus("r"))
    hl.bind(mod .. " + k", hl.dsp.window.movefocus("u"))
    hl.bind(mod .. " + j", hl.dsp.window.movefocus("d"))

    -- ===== move window =====
    hl.bind(mod .. " + SHIFT + h", hl.dsp.window.movewindow("l"))
    hl.bind(mod .. " + SHIFT + l", hl.dsp.window.movewindow("r"))
    hl.bind(mod .. " + SHIFT + k", hl.dsp.window.movewindow("u"))
    hl.bind(mod .. " + SHIFT + j", hl.dsp.window.movewindow("d"))

    -- ===== workspaces switch / move =====
    for i = 1, 10 do
      local key = (i == 10) and "0" or tostring(i)
      hl.bind(mod .. " + " .. key,           hl.dsp.workspace(tostring(i)))
      hl.bind(mod .. " + SHIFT + " .. key,   hl.dsp.movetoworkspace(tostring(i)))
    end

    -- ===== groups =====
    hl.bind(mod .. " + ALT + G", hl.dsp.exec_cmd("${groupWorkspaceScriptPath}"))
    hl.bind(mod .. " + G",       hl.dsp.togglegroup())
    hl.bind(mod .. " + TAB",       hl.dsp.changegroupactive("f"))
    hl.bind(mod .. " + ALT + TAB", hl.dsp.changegroupactive("b"))
    hl.bind(mod .. " + ALT + h", hl.dsp.movewindoworgroup("l"))
    hl.bind(mod .. " + ALT + l", hl.dsp.movewindoworgroup("r"))
    hl.bind(mod .. " + ALT + k", hl.dsp.movewindoworgroup("u"))
    hl.bind(mod .. " + ALT + j", hl.dsp.movewindoworgroup("d"))

    -- ===== resize =====
    hl.bind(mod .. " + CTRL + h", hl.dsp.window.resize({ x = -50, y = 0 }))
    hl.bind(mod .. " + CTRL + l", hl.dsp.window.resize({ x = 50,  y = 0 }))
    hl.bind(mod .. " + CTRL + k", hl.dsp.window.resize({ x = 0,   y = -50 }))
    hl.bind(mod .. " + CTRL + j", hl.dsp.window.resize({ x = 0,   y = 50 }))

    -- ===== screenshots =====
    hl.bind(mod .. " + PRINT",       hl.dsp.exec_cmd("hyprshot -m output"))
    hl.bind(mod .. " + SHIFT + PRINT", hl.dsp.exec_cmd("hyprshot -m region --clipboard-only --freeze"))
    hl.bind("PRINT",                 hl.dsp.exec_cmd("hyprshot -m window"))

    -- ===== keyboard layout =====
    hl.bind("CTRL + ALT + 1", hl.dsp.exec_cmd("hyprctl switchxkblayout all 0"))
    hl.bind("CTRL + ALT + 2", hl.dsp.exec_cmd("hyprctl switchxkblayout all 1"))

    -- ===== audio =====
    hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pactl -- set-sink-volume 0 -10%"), { locked = true })
    hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pactl -- set-sink-volume 0 +10%"), { locked = true })
    hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("pactl -- set-sink-mute 0 toggle"), { locked = true })
    hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("pactl -- set-source-mute 0 toggle"), { locked = true })

    hl.bind(mod .. " + F12", hl.dsp.exec_cmd("sh -c 'env > /tmp/hypr-env.txt'"))

    ${brightnessControlBinds}
    ${extraBindsConfig}

    -- ===== env =====
    ${envConfig}

    -- ===== pass-wofi submap =====
    ${passWofiSubmap}
  '';
in
{
  options.my.hyprland = {
    enable = lib.mkEnableOption "Hyprland stack";

    monitors = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "eDP-1,preferred,0x0,1" ];
    };

    workspaces = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "1, monitor:eDP-1"
        "2, monitor:eDP-1"
      ];
    };

    extraBinds = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Raw hl.bind(...) Lua lines appended to the config.";
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

      # All config is native Lua, passed through.
      extraConfig = hyprlandLua;
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
}:
