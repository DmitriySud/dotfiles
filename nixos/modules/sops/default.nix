{ config, lib, pkgs, ...}:

{
  sops.age.keyFile = "/home/${home.username}/.config/sops/age/keys.txt";

  sops.secrets."shadowsocks-config" = {
    sopsFile = ../../secrets/config.json;
    owner = "dsudakov";
    group = "users";
    mode = "0400";
  };

}
