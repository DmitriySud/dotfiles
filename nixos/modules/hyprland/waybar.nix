{ config, lib, pkgs, ... }:

let
  cfg = config.my.hyprland;
in {
  config = lib.mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      systemd.enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          modules-left = [ "hyprland/workspaces" ];
          modules-center = [ "clock" ];
          modules-right = [ "cpu" "memory" "network" "pulseaudio" "backlight" "battery" "tray" ];
          cpu.format = "   {usage}%";
          memory.format = "   {used}GiB";
          network = {
            format-wifi = "   {signalStrength}%";
            format-ethernet = "󰈁  Online";
            format-disconnected = "󰖪    Offline";
          };
          pulseaudio = {
            format = "{icon} {volume}%";
            format-muted = "󰖁 muted";
            format-icons = {
              headphone = "󰋋";
              hands-free = "󰋎";
              headset = "󰋎";
              phone = "󰄜";
              portable = "󰄜";
              car = "󰄋";
              default = [ "󰕿" "󰖀" "󰕾" ];
            };
            scroll-step = 5;
            on-click = "pavucontrol";
          };
          backlight = {
            device = "intel_backlight";
            format = "  {icon}  {percent}%  ";
            format-icons = ["" ""];
          };
          battery = {
            format = "{icon}   {capacity}%";
            format-icons = [ "" "" "" "" "" ];
          };
          clock = {
            format = "{:%H:%M    %Y-%m-%d    }";
            tooltip-format = "<tt><small>{calendar}</small></tt>";
            calendar = {
              mode = "year";
              mode-mon-col = 3;
              weeks-pos = "right";
              format = {
                months = "<span color='#ffead3'><b>{}</b></span>";
                days = "<span color='#ecc6d9'><b>{}</b></span>";
                weeks = "<span color='#99ffdd'><b>W{}</b></span>";
                weekdays = "<span color='#ffcc66'><b>{}</b></span>";
                today = "<span color='#ff6699'><b><u>{}</u></b></span>";
              };
            };
          };
        };
      };

      style = ''
        * {
          font-family: "JetBrainsMono Nerd Font";
          font-size: 14px;
        }
        #clock {
          padding: 0 10px;
        }
        #cpu, #memory, #network, #clock, #battery {
          padding-left: 8px;
          padding-right: 8px;
        }
      '';
    };
  };
}

