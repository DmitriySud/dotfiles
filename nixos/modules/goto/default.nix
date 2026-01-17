{ config, lib, pkgs, ... }:

let
  storageDir   = "${config.my.syncthing.storage-path}/goto";
  gotoDb   = "${storageDir}/db";
  cfg = config.my.goto;
in
{
  options.my.goto = {
    enable = lib.mkEnableOption "Enable goto tool";
    from-sync = lib.mkOption {
      type = lib.types.boolean;
      default = config.my.syncthing.enable;
      description = "use goto-db from syncthing";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.goto ];

    my.goto.shellIntegration =
      builtins.readFile "${pkgs.goto}/share/goto.sh";

    home.activation.initGotoState =
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        mkdir -p ${stateDir}
        touch ${gotoDb}
      '';

    #### Symlink ~/.config/goto → writable state file
    home.file.".config/goto".source =
      lib.file.mkOutOfStoreSymlink gotoDb;
  };
}

