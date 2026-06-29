# sops/server.nix
{ config, ... }:

let
  inherit (import ./secret-helpers.nix { inherit config; })
    userFileSecret userFieldSecret;
in {
  sops.secrets = {
    tgbot-secdist = userFileSecret ../../secrets/tgbot-secdist.json;

    tgbot-cert-pub =
      userFieldSecret ../../secrets/tgbot-certificate.json "webhook_public_pem";

    tgbot-cert-key =
      userFieldSecret ../../secrets/tgbot-certificate.json "webhook_private_key";
  };
}
