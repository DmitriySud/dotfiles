{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.hyprland;
  lockscreen_img = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/DmitriySud/dotfiles/master/pictures/lockscreen.png";
    sha256 = "sha256:0nbi3yygax6ay6pgz07vxdwxw960js2b0kk9fj99vvgvksz1p2ns";
  };
in
{
  options.my.hyprland.hyprlock.enable = lib.mkEnableOption "hyprlock service" // {
    default = true;
  };

  config = lib.mkIf (cfg.enable && cfg.hyprlock.enable) {
    programs.hyprlock = {
      enable = true;
      settings = {
        general.no_fade_in = false;
        background = [
          {
            path = lockscreen_img;
            blur_size = 1;
            blur_passes = 3;
          }
        ];
        input-field = {
          size = {
            width = 200;
            height = 50;
          };
          outline_thickness = 3;
          dots_size = 0.33;
          dots_spacing = 0.15;
          dots_center = false;
          fade_on_empty = true;
          placeholder_text = "<i>Input Password...</i>";
          hide_input = false;
          halign = "center";
          valign = "center";
        };
        label = {
          text = "$TIME";
          font_size = 50;
          font_family = "Noto Sans";
          halign = "center";
          valign = "top";
        };
      };
    };

    home.packages = [
      (pkgs.writeShellScriptBin "lock" ''
        #!/bin/sh
        hyprctl switchxkblayout all 0 && hyprlock
      '')
    ];
  };
}
