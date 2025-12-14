{ lib, config, pkgs, ...}:

let
	cfg = config.services.shadowsocks-local;
in
{
	options.services.shadowsocks-local = {
		enable = lib.mkEnableOption "Shadowsocks local proxy";
	};

	config = lib.mkIf cfg.enable {
		home.packages = with pkgs; [
			shadowsocks-rust
		];

		# xdg.configFile."shadowsocks/config.json".source = ./config.json;

		systemd.user.services.shadowsocks-local = {
			Unit = {
				Description = "Shadowsocks Local Proxy";
				After = [ "network-online.target" ];
			};

			Service = {
				ExecStart = "${pkgs.shadowsocks-rust}/bin/sslocal -c /home/dsudakov/repos/dotfiles/nixosdump/nixos/modules/shadowsocks/config.json";
				Restart = "on-failure";
				RestartSec = 5;
			};
			Install = {
				WantedBy = [ "default.target" ];
			};

		};
	};
}
