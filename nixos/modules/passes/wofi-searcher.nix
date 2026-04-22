{ config, lib, pkgs, ... }:

let
  cfg = config.my.passWofi;

  passWofiPy = ./pass-wofi.py;

  mkPassWofiCommand = name: mode:
    pkgs.writeShellScriptBin name ''
      export PASS_WOFI_CLIPBOARD_TIMEOUT=${toString cfg.clipboardTimeout}
      exec ${config.home.homeDirectory}/.local/bin/pass-wofi.py ${mode} "$@"
    '';
in
{
  options.my.passWofi = {
    enable = lib.mkEnableOption "wofi interface for pass";

    clipboardTimeout = lib.mkOption {
      type = lib.types.int;
      default = 15;
      description = "Clipboard clear timeout in seconds for pass-wofi.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.file.".local/bin/pass-wofi.py" = {
      source = passWofiPy;
      executable = true;
    };

    home.packages =
      (with pkgs; [
        wofi
        wl-clipboard
        libnotify
        pass
        gnupg
        (python3.withPackages (_: []))
      ])
      ++ [
        (mkPassWofiCommand "pass-pass" "password-by-entry")
        (mkPassWofiCommand "pass-login" "login-by-entry")
        (mkPassWofiCommand "pass-pass-by-login" "password-by-login")
      ];
  };
}
