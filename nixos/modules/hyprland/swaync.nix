{ config, lib, pkgs, ... }:

let
  cfg = config.my.hyprland;
in
{
  options.my.hyprland.swaync.enable =
    lib.mkEnableOption "swaync notification daemon" // {
      default = true;
    };

  options.my.hyprland.swaync.settings = lib.mkOption {
    type = lib.types.attrs;
    default = {
      swaync = {
        dnd = false;
        position = "top-right";
        timeout = 6000;
        layer = "overlay";
      };
      style = {
        font = "JetBrainsMono Nerd Font 11";
        margin = {
          top = 20;
          right = 20;
          bottom = 20;
          left = 20;
        };
      };
    };
    description = ''
      Settings passed to swaync (converted to JSON for the daemon).
    '';
  };

  config = lib.mkIf (cfg.enable && cfg.swaync.enable) {
    home.packages = [ pkgs.swaynotificationcenter ];

    services.swaync = {
        enable = true;
        settings = cfg.swaync.settings;
        style = ''
          * {
            font-family: ${cfg.swaync.settings.style.font};
          }

          .notification {
            margin: ${toString cfg.swaync.settings.style.margin.top}px
                     ${toString cfg.swaync.settings.style.margin.right}px
                     ${toString cfg.swaync.settings.style.margin.bottom}px
                     ${toString cfg.swaync.settings.style.margin.left}px;
          }
        '';
    };
  };
}

