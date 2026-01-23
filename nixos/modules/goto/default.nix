{
  config,
  lib,
  pkgs,
  ...
}:

let
  storageDir = "${config.my.syncthing.storage-dir}/goto";
  gotoDb = "${storageDir}/db";
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

    shellIntegration = lib.mkOption {
      type = lib.types.lines;
      readOnly = true;
      description = "Shell integration snippet for goto";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.goto ];

    my.goto.shellIntegration = builtins.readFile "${pkgs.goto}/share/goto.sh";

    home.activation.initGotoState = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p ${storageDir}
      touch ${gotoDb}
    '';

    #### Symlink ~/.config/goto → writable state file
    home.file.".config/goto".source = config.lib.file.mkOutOfStoreSymlink gotoDb;
  };
}
