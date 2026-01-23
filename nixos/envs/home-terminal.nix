{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./home-base.nix
    ../modules/nvim
    ../modules/byobu
    ../modules/zsh/zsh.nix
    ../modules/goto
  ];

  config = {
    my.zsh.enable = true;
    my.goto.enable = true;
    my.nvim.enable = true;

    home.packages = with pkgs; [
      jq
      git
      tree
    ];
  };
}
