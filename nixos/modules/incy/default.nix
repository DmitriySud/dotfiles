{ config, lib, pkgs, ... }:

let
  cfg = config.my.incy;
in
{
  options.my.incy.enable = lib.mkEnableOption "incy vpn client";

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.incy ];

    xdg.desktopEntries.incy = {
      name = "INCY VPN";
      exec = "incy";
      icon = "${pkgs.incy}/opt/incy/lib/incy.png";
      categories = [ "Network" ];
    };
  };
}
