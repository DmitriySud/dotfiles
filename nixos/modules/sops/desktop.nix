# sops/desktop.nix
{ config, username, ... }:

let
  inherit (import ./secret-helpers.nix { inherit config username; })
    userFileSecret;
in {
  sops.secrets = {
    main-user-password = {
      neededForUsers = true;
      sopsFile = ../../secrets/user.json;
      format = "json";
      key = "main_user_password";
      mode = "0400";
    };

    root-password = {
      neededForUsers = true;
      sopsFile = ../../secrets/user.json;
      format = "json";
      key = "root_password";
      mode = "0400";
    };

    shadowsocks-config = userFileSecret ../../secrets/vpn_config.json;
  };
}
