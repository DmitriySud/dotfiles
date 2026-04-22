{ config, pkgs, lib, ... }:

let
  cfg = config.my.passage;

  passwordStoreDir = "${config.home.homeDirectory}/repos/dotfiles/nixos/passes";
in
{
  options.my.passage = {
    enable = lib.mkEnableOption "Enable passage service";
    identityFile = lib.mkOption {
      type = lib.types.path;
    };
  };

  config = {
    home.packages = with pkgs; [
      pass
      gnupg

      ripgrep
      fzf
      tree
    ];

    # Environment variables for passage
    home.sessionVariables = {
      PASSWORD_STORE_DIR = passwordStoreDir;
    };

    # GPG agent (for "unlock once per session")
    services.gpg-agent = {
      enable = true;
      defaultCacheTtl = 28800; # 8 hours
      maxCacheTtl = 28800;
      pinentry.package = pkgs.pinentry-curses;
      enableSshSupport = false;
    };

    programs.gpg = {
      enable = true;
      publicKeys = [
        {
          source = ./pubkeys/laptop-personal.pub;
          trust = "ultimate";
        }

        {
          source = ./pubkeys/desktop-personal.pub;
          trust = "ultimate";
        }
      ];

      mutableKeys = false;
      mutableTrust = false;
    }
  };
}
