{ config, lib, pkgs, ... }:

let 
  cfg = config.my.firefox;

in {
  options.my.firefox = {
    enable = lib.mkEnableOption "enable firefox browser " // {
      default = true;
    };

    proxy.enable = lib.mkEnableOption "enable proxy by default for firefox" // {
      default = true;
    };
  };

  config = {
    home.packages = with pkgs; [ firefox ];

    programs.firefox = lib.mkIf cfg.enable {
      enable = true;

      profiles.default.settings = lib.mkIf cfg.proxy.enable {
        "network.proxy.http" = "";
        "network.proxy.https" = "";

        "network.proxy.socks_remote_dns" = true;

        "network.proxy.socks" = "127.0.0.1";
        "network.proxy.socks_port" = 10808;
        "network.proxy.socks_version" = 5;

        "network.proxy.type" = 1;
      };

    };
  };
}
