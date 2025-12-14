{ lib, config, pkgs, ...}:

let 
  cfg = config.main-user;
in
{
	options.main-user = {
		enable = lib.mkEnableOption "Enable user module";
		userName = lib.mkOption {
			description = " user name ";
		};
	};

	config = lib.mkIf cfg.enable {
		users.users.${cfg.userName} = {
			isNormalUser = true;
			initialPassword = "12345";
			description = "main user";
			extraGroups = [ "wheel" "networkmanager" ];
			shell = pkgs.zsh;
		};

	};
}
