{ config, pkgs, lib, ... }:

let
  cfg = config.my.passage;

  passwordStoreDir = "${config.home.homeDirectory}/.local/share/passage";
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
      (pkgs.callPackage (pkgs.fetchFromGitHub {
        owner = "FiloSottile";
        repo = "passage";
        rev = "1.7.4a1";
        hash = "sha256-CPRM+8+iijRWUejlgfTvv60Kmcc+4M+Cwyi0uOMXHT0=";
      }) {})
      age
      ripgrep
      fzf
      tree
    ];

    # Environment variables for passage
    home.sessionVariables = {
      PASSWORD_STORE_DIR = passwordStoreDir;
      PASSAGE_IDENTITIES_FILE = cfg.identityFile;
    };

    # Ensure directories exist
    home.file.".local/share/passage/.keep".text = "";
  };
}
