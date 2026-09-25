{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.earlyoom;
in
{
  options.my.earlyoom.enable = lib.mkEnableOption "early out-of-memory killing for user processes";

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.earlyoom ];

    systemd.user.services.earlyoom = {
      Unit.Description = "Early out-of-memory killer for user processes";

      Service = {
        ExecStart = "${lib.getExe pkgs.earlyoom} --ignore-root-user -r 3600";
        Restart = "on-failure";
        RestartSec = "5s";
      };

      Install.WantedBy = [ "default.target" ];
    };
  };
}
