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
    ../modules/devshells
  ];

  config = {
    my.zsh.enable = true;
    my.goto.enable = true;
    my.nvim.enable = true;
    my.byobu.enable = true;
    my.devshells.enable = true;

    home.packages = with pkgs; [
      jq
      git
      tree
    ];
  };
}
