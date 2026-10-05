{
  config,
  lib,
  pkgs,
  pkgsUnstable,
  ...
}:

let
  cfg = config.my.herdr;

  herdrAttach = pkgs.writeShellApplication {
    name = "herdr-attach";
    runtimeInputs = [
      pkgsUnstable.herdr
      pkgs.fzf
      pkgs.jq
    ];
    text = builtins.readFile ./herdr-attach.sh;
  };
in
{
  options.my.herdr.enable = lib.mkEnableOption "Herdr and its agent selector";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgsUnstable.herdr
      herdrAttach
    ];
  };
}
