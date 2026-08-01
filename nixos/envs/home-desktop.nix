{
  config,
  lib,
  pkgs,
  sops-nix,
  ...
}:

with lib;
{
  imports = [
    ./home-terminal.nix
    ../modules/firefox
    ../modules/alacritty
    ../modules/hyprland
    ../modules/xkb
    ../modules/incy
    ../modules/shadowsocks/shadowsocks.nix
    ../modules/passes/wofi-searcher.nix
  ];

  config = {
    services.shadowsocks-local.enable = false;
    my.incy.enable = false;
    my.alacritty.enable = true;
    my.passWofi.enable = true;

    fonts.fontconfig.enable = true;

    home.packages =
      with pkgs;
      [
        chromium
        telegram-desktop
        gnome-keyring
        mission-center
        pulseaudio
        zathura
        obsidian

      ]
      ++ lib.optional config.my.home-base.enableBrightness pkgs.brightnessctl;

    my.hyprland.enableBrightness = config.my.home-base.enableBrightness;

    my.devshells.desktopEntries = true;

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = "org.pwmt.zathura.desktop";
        "text/html" = "yandex-browser.desktop";
        "x-scheme-handler/http" = "yandex-browser.desktop";
        "x-scheme-handler/https" = "yandex-browser.desktop";
        "x-scheme-handler/about" = "yandex-browser.desktop";
        "x-scheme-handler/unknown" = "yandex-browser.desktop";
      };
    };

    services.gnome-keyring = {
      enable = true;
      components = [
        "pkcs11"
        "secrets"
      ];
    };

    programs.neovim.waylandSupport = true;
  };
}
