{ config, lib, pkgs, ... }:

let
  cfg = config.my.hyprland;
in {
  options.my.hyprland.hypridle.enable =
    lib.mkEnableOption "Hypridle service" // {
    default = true;
  };

  config = lib.mkIf (cfg.enable && cfg.hypridle.enable) {
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock";
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
          { timeout = 900; on-timeout = "systemctl suspend"; }
        ];
      };
    };
  };
}

