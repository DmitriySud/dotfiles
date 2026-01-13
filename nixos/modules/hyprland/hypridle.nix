{ config, lib, pkgs, ... }:

let
  cfg = config.my.hyprland;
in {
  options.my.hyprland.hypridle = {
    enable = lib.mkEnableOption "Hypridle service" // {
      default = true;
    };
    can-suspend = lib.mkOption {
      type    = lib.types.bool;
      default = true;
    };
  };

  config = lib.mkIf (cfg.enable && cfg.hypridle.enable) {
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || lock";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";
        };
        listener = [
          { timeout = 300; on-timeout = "loginctl lock-session"; }
          {
            timeout = 600;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
          
        ] ++ lib.optional cfg.hypridle.can-suspend { timeout = 900; on-timeout = "systemctl suspend"; };
      };
    };
  };
}

