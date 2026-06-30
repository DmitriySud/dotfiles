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
          vps-personal.id = "EDM3QI7-B2IYWG5-QLIGVGR-H7CV5LI-IHHGVN3-AQOYNS5-H2LSYQS-QPOD3QT";

          laptop-katya.id = "HGLMOAI-66GUJJ6-45UZAVG-GH6ALTY-USTAVAR-IA3WUPZ-NELD5LM-3XOFPQ6";
          ipad-katya.id = "YIIJEIK-O5OPJCI-6K2FWPW-ESEYPN3-MWBVPAC-6VBT5M4-6PNURZB-O4XOVAJ";
        };

        folders = {
          "goto-state" = {
            path = "${cfg.storage-dir}/goto";
            devices = [
              "desktop-personal"
              "laptop-personal"
              "vps-personal"
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
              "ipad"
              "iphone"
              "vps-personal"
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
              "vps-personal"
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
