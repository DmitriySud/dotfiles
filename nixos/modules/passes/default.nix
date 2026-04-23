{ config, pkgs, lib, ... }:

let
  cfg = config.my.passes;

  reencryptPassScript = ./reencrypt-pass.sh;
in
{
  options.my.passes = {
    enable = lib.mkEnableOption "Enable passes service";
    identityFile = lib.mkOption {
      type = lib.types.path;
    };
    passwordStoreDir = lib.mkOption {
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

    # Environment variables for passes
    home.sessionVariables = {
      PASSWORD_STORE_DIR = cfg.passwordStoreDir;
    };

    # GPG agent (for "unlock once per session")
    services.gpg-agent = {
      enable = true;
      defaultCacheTtl = 28800; # 8 hours
      maxCacheTtl = 28800;
      enableSshSupport = false;
      pinentry.package = pkgs.pinentry-qt;
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
    };

    home.shellAliases = {
      pass-reencrypt = "${reencryptPassScript}";
    };
  };
}
