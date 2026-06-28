{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (config.users.users.dsudakov) name group;

  # User-scoped secret backed by an entire file (whole-file mode).
  userFileSecret = sopsFile: {
    inherit sopsFile;
    format = "json";
    key = "";
    mode = "0400";
    owner = name;
    inherit group;
  };

  # User-scoped secret extracted from a single field of a file.
  userFieldSecret = sopsFile: key: {
    inherit sopsFile key;
    format = "json";
    mode = "0400";
    owner = name;
    inherit group;
  };

in {
  environment.systemPackages = with pkgs; [
    sops
  ];

  sops = {
    age = {
      keyFile = "/var/lib/sops-nix/age/keys.txt";
      generateKey = true;
    };
    secrets = {
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
      
      tgbot-secdist = userFileSecret ../../secrets/tgbot-secdist.json;

      tgbot-cert-pub =
        userFieldSecret ../../secrets/tgbot-certificate.json "webhook_public_pem";

      tgbot-cert-key =
        userFieldSecret ../../secrets/tgbot-certificate.json "webhook_private_key";
    };

  };

}
