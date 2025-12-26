{ config, lib, pkgs, ... }:
with lib;
let 
    cfg = config.my.home-base;
in {
  imports = [
    ../modules/firefox
    ../modules/nvim
    ../modules/alacritty
    ../modules/hyprland

    ../modules/shadowsocks/shadowsocks.nix
    ../modules/zsh/zsh.nix
  ];
  options.my.home-base = {
    enableBrightness = mkOption {
        type = types.bool;
        default = false;
        description = "Enable brightness control and bindings";
    };
  };

  config = {

    my.zsh.enable = true;
    my.nvim.enable = true;

    
    # Home Manager needs a bit of information about you and the paths it should
    # manage.
    home.username = "dsudakov";
    home.homeDirectory = "/home/dsudakov";

    services.shadowsocks-local.enable = true;

    home.sessionVariables = {
      SSH_ASKPASS_REQUIRE = "prefer";
    };

    home.stateVersion = "25.11";

    fonts.fontconfig.enable = true;

    home.packages = with pkgs; [
      chromium

      telegram-desktop

      jq
      git
      tree

      gnome-keyring

      mission-center
      pulseaudio

      zathura
    ]++ lib.optional cfg.enableBrightness brightnessctl;

    my.hyprland.enableBrightness = cfg.enableBrightness;

    xdg.mimeApps = {
        enable = true;
        defaultApplications = {
            "application/pdf" = "org.pwmt.zathura.desktop";
        };
    };

    home.file.".ssh/config".text = ''
    Host *
      CanonicalDomains hprtrk.com
      CanonicalizeHostname yes
      StrictHostKeyChecking no
      ForwardAgent yes
    '';

    # Let Home Manager install and manage itself.
    programs.git = {
      enable = true;
      settings = {
          user.name = "DmitriySud";
          user.email = "dmitriy.sudakov2001@gmail.com";
      };
    };

    programs.home-manager.enable = true;

    services.gnome-keyring = {
      enable = true;
      components = [ "pkcs11" "secrets" ];
    };
  };
}
