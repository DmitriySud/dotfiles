{ config, lib, pkgs, ... }:

let
  cfg = config.my.syncthing;
in
{
  options.my.syncthing = {
    enable = lib.mkEnableOption "Enable syncthing service";
    storage-dir = lib.mkOption {
      type = lib.types.path;
      description = "storage path of syncthing";
    };
  };

  config = lib.mkIf cfg.enable {
    services.syncthing = {
      enable = true;

      # sensible defaults
      tray.enable = false;

      # optional but nice
      settings = {
        options = {
          relaysEnabled = true;
          localDiscoveryEnabled = true;
          natEnabled = true;
        };
      };
    };
  };
}
