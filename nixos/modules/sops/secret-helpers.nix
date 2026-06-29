# sops/secret-helpers.nix
{ config }:

let
  inherit (config.users.users.dsudakov) name group;
in {
  # Whole-file secret owned by dsudakov.
  userFileSecret = sopsFile: {
    inherit sopsFile;
    format = "json";
    key = "";
    mode = "0400";
    owner = name;
    inherit group;
  };

  # Single-field secret owned by dsudakov.
  userFieldSecret = sopsFile: key: {
    inherit sopsFile key;
    format = "json";
    mode = "0400";
    owner = name;
    inherit group;
  };
}
