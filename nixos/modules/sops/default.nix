{ config, lib, pkgs, ...}:

{
  sops.age.keyFile = "/home/dsudakov/.config/sops/age/keys.txt";

  sops.secrets =  {
    shadowsocks-config = {
      sopsFile = ../../secrets/vpn_config.json;
      format = "json";
      key = "";
      mode = "0400";
    };

    main-user-password = {
      sopsFile = ../../secrets/user.json;
      format = "json";
      key = "main_user_password";
      mode = "0400";
    };
  };

}
