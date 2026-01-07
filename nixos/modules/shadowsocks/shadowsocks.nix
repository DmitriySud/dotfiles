{ lib, config, pkgs, ...}:

let
	cfg = config.services.shadowsocks-local;

  configFile = config.sops.secrets."shadowsocks-config".path;
in
{
	options.services.shadowsocks-local = {
		enable = lib.mkEnableOption "Shadowsocks local proxy";
	};

	config = lib.mkIf cfg.enable {
		home.packages = with pkgs; [
			shadowsocks-rust
		];

		systemd.user.services.shadowsocks-local = {
			Unit = {
				Description = "Shadowsocks Local Proxy";
				After = [ "network-online.target" ];
			};

			Service = {
				ExecStart = "${pkgs.shadowsocks-rust}/bin/sslocal -c ${configFile}";
				Restart = "on-failure";
				RestartSec = 5;
			};
			Install = {
				WantedBy = [ "default.target" ];
			};

		};
	};
}
