{ config, lib, pkgs, ... }:

let
  cfg = config.my.totp;

  otpAdd = pkgs.writeShellApplication {
    name = "otp-add";
    runtimeInputs = [ cfg.package ];
    text = builtins.readFile ./scripts/otp-add.sh;
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
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package otpAdd ];
  };
}
