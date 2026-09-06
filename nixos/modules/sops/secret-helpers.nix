# sops/secret-helpers.nix
{ config, username }:

let
  inherit (config.users.users.${username}) name group;
in {
  # Whole-file secret owned by the configured user.
  userFileSecret = sopsFile: {
    inherit sopsFile;
    format = "json";
    key = "";
    mode = "0400";
    owner = name;
    inherit group;
  };

  # Single-field secret owned by the configured user.
  userFieldSecret = sopsFile: key: {
    inherit sopsFile key;
    format = "json";
    mode = "0400";
    owner = name;
    inherit group;
  };
}
