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
          laptop-work.id = "ANRFMHV-ZV3SWB5-JFHWYCC-H23TSWO-CEEKRFC-IDCI65I-AYC2H7R-A3X23AG";

          ipad.id = "YXISP57-ZESQORK-LHB5NR5-ABUREB2-JCJYXHH-X2ACRVK-CZPZQVU-7RBLOAB";
          iphone.id = "K276L4Z-UUONVJO-6B22J2X-4ON2AIZ-KJC36FA-FVMB2LL-OM4E6AU-UBFI3QB";
          vps-work.id = "CNHLST5-OWNIWGK-2IOCFHP-JY7MLPI-NIK7XDW-MIVK7QD-27VZYG4-PZAFPQV";

          laptop-katya.id = "HGLMOAI-66GUJJ6-45UZAVG-GH6ALTY-USTAVAR-IA3WUPZ-NELD5LM-3XOFPQ6";
          ipad-katya.id = "YIIJEIK-O5OPJCI-6K2FWPW-ESEYPN3-MWBVPAC-6VBT5M4-6PNURZB-O4XOVAJ";
        };

        folders = {
          "goto-state" = {
            path = "${cfg.storage-dir}/goto";
            devices = [
              "desktop-personal"
              "laptop-personal"
              "vps-work"
              "laptop-work"
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
              "laptop-personal"
              "laptop-work"
              "ipad"
              "iphone"
              "vps-work"
            ];

            ignorePatterns = [
              "/.obsidian/workspace.json"
              "/.obsidian/workspace-mobile.json"

              "/.obsidian/*.sync-conflict-*"

              "/.obsidian/cache"
            ];

            type = "sendreceive";
            versioning = {
              type = "simple";
              params.keep = "10";
            };
          };

          "katin-obsidian" = {
            path = "${cfg.storage-dir}/katin-obsidian";
            devices = [
              "laptop-katya"
              "ipad-katya"
              "vps-work"
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
