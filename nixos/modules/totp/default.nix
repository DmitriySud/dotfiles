{ config, lib, pkgs, ... }:

let
  cfg = config.my.totp;

  otpAdd = pkgs.writeShellApplication {
    name = "otp-add";
    runtimeInputs = [ cfg.package ];
    text = builtins.readFile ./scripts/otp-add.sh;
  };

  otpWofi = pkgs.writeShellApplication {
    name = "otp-wofi";
    runtimeInputs = [
      cfg.package
      pkgs.wofi
      pkgs.wl-clipboard
      pkgs.libnotify
      pkgs.coreutils
      pkgs.findutils
      pkgs.gnused
    ];
    text = ''
      export OTP_PREFIX="${cfg.prefix}"
      ${builtins.readFile ./scripts/otp-wofi.sh}
    '';
  };
in
{
  options.my.totp = {
    enable = lib.mkEnableOption "CLI 2FA/TOTP support using gopass";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.gopass;
      description = "OTP-capable pass-compatible CLI.";
    };

    prefix = lib.mkOption {
      type = lib.types.str;
      default = "totp";
      description = "Password-store prefix used by otp-wofi.";
    };

    enableWofi = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install otp-wofi launcher.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages =
      [ cfg.package otpAdd ]
      ++ lib.optionals cfg.enableWofi [ otpWofi ];
  };
}
