{ config, lib, pkgs, ...}:

{
  sops.age.keyFile = "/home/dsudakov/.config/sops/age/keys.txt";

  sops.secrets =  {
    shadowsocks-config = {
      sopsFile = ../../secrets/config.json;
      format = "binary";
      mode = "0400";
    };
  };
}
