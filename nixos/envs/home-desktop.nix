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
    ../modules/shadowsocks/shadowsocks.nix
  ];

  config = {
    my.syncthing.enable = true;

    services.shadowsocks-local.enable = true;
    my.alacritty.enable = true;

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

        sops
        age

      ]
      ++ lib.optional config.my.home-base.enableBrightness pkgs.brightnessctl;

    my.hyprland.enableBrightness = config.my.home-base.enableBrightness;

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = "org.pwmt.zathura.desktop";
      };
    };

    services.gnome-keyring = {
      enable = true;
      components = [
        "pkcs11"
        "secrets"
      ];
    };
  };
}
