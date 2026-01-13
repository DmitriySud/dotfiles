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
    users.mutableUsers = false;

		users.users.${cfg.userName} = {
			isNormalUser = true;
			hashedPasswordFile = config.sops.secrets.main-user-password.path;
			description = "main user";
			extraGroups = [ "wheel" "networkmanager" ];
			shell = pkgs.zsh;
		};

    users.users.root = {
      hashedPasswordFile = config.sops.secrets.root-password.path;
    };

	};
}
