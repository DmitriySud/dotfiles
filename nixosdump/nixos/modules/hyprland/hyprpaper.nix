{ config, lib, pkgs, ... }:

let
  cfg = config.my.hyprland;
  mainscreen_img = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/DmitriySud/dotfiles/master/stow/i3/Pictures/wallpaper.png";
    sha256 = "sha256:1yj2g2hqxkprap8g2fzp8385z8lx5pi45x1xib3g8dc3c9sy5v9b";
  };
in {
  options.my.hyprland.hyprpaper.enable =
    lib.mkEnableOption "hyprpaper service" // {
    default = true;
  };


  config = lib.mkIf (cfg.enable && cfg.hyprpaper.enable) {
    services.hyprpaper.enable = true;

    xdg.configFile."hypr/hyprpaper.conf".text = ''
      preload = ${mainscreen_img}
      wallpaper = , ${mainscreen_img}
    '';
  };
}

