{ config, lib, pkgs, ... }:
{
  imports = [
    ./home-base.nix
    ../modules/nvim          
    ../modules/zsh/zsh.nix  
  ];

  config = {
    my.zsh.enable = true;
    my.nvim.enable = true;

    home.packages = with pkgs; [
      jq
      git
      tree
    ];
  };
}
