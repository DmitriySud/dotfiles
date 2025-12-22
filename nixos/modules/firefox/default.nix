{ config, pkgs, ...}:

{
    home.packages = with pkgs; [ firefox ];

 	programs.firefox = {
		enable = true;

		profiles.default.settings = {
			"network.proxy.http" = "";
			"network.proxy.https" = "";

			"network.proxy.socks_remote_dns" = true;

			"network.proxy.socks" = "127.0.0.1";
			"network.proxy.socks_port" = 1080;
			"network.proxy.socks_version" = 5;
			
			"network.proxy.type" = 1;
		};

	};
}
