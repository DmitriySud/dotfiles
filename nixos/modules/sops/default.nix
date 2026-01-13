{ config, lib, pkgs, ...}:

{
  sops = {
    age = {
      keyFile = "/var/lib/sops-nix/age/keys.txt";
      generateKey = true;
    };
    secrets = {
      shadowsocks-config = {
        sopsFile = ../../secrets/vpn_config.json;
        format = "json";
        key = "";
        mode = "0400";

        owner = config.users.users.dsudakov.name;
        inherit (config.users.users.dsudakov) group;
      };

      main-user-password = {
        needForUsers = true;

        sopsFile = ../../secrets/user.json;
        format = "json";
        key = "main_user_password";
        mode = "0400";
      };

      root-password = {
        needForUsers = true;

        sopsFile = ../../secrets/user.json;
        format = "json";
        key = "root_password";
        mode = "0400";
      };

    };

  };

}
