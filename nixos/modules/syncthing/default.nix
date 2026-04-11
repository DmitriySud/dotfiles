{
  config,
  lib,
  pkgs,
  ...
}:

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

        devices = {
          desktop-personal.id = "YGZZGDV-LFSMJOD-OVR6FU6-J7BNAKD-ZGGMTOT-WDHMID6-HNO25CI-PDZGVAO";
          laptop-personal.id = "VRD6P5Y-WY4NNTO-DUEEKOG-TVMVD4R-HGOCC3S-SED45M6-QLTHDDP-2NYQ6QR";

          ipad.id = "YXISP57-ZESQORK-LHB5NR5-ABUREB2-JCJYXHH-X2ACRVK-CZPZQVU-7RBLOAB";
          iphone.id = "K276L4Z-UUONVJO-6B22J2X-4ON2AIZ-KJC36FA-FVMB2LL-OM4E6AU-UBFI3QB";
        };

        folders = {
          "goto-state" = {
            path = "${cfg.storage-dir}/goto";
            devices = [
              "desktop-personal"
              "laptop-personal"
            ];
            type = "sendreceive";
            versioning = {
              type = "simple";
              params.keep = "10";
            };
          };
          "obsidian" = {
            path = "${cfg.storage-dir}/obsidian";
            devices = [
              "desktop-personal"
              "ipad"
              "iphone"
            ];
            type = "sendreceive";
            versioning = {
              type = "simple";
              params.keep = "10";
            };
          };
        };
      };
    };
  };
}
