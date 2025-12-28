{ config, pkgs, lib, ... }:

{
  options.my.nvim.enable = lib.mkEnableOption "Enable my neovim";

  config = lib.mkIf config.my.nvim.enable {

    home.packages = with pkgs; [
      ripgrep             # for telescope or grep
      fd                  # for fzf/telescope
      fzf
      nodejs              # needed for coc
      clang-tools
      pyright
    ];

    programs.neovim = {
      enable = true;
      defaultEditor = true;

      # Lua support (optional)
      viAlias = true;
      vimAlias = true;

      plugins = with pkgs.vimPlugins; [
        vim-startify
        plenary-nvim
        telescope-nvim
        nerdtree
        vim-easymotion
        nvim-autopairs
        coc-nvim
        nvim-web-devicons
        catppuccin-nvim
        lualine-nvim
        indent-blankline-nvim
        nvim-treesitter
      ];
      extraPackages = with pkgs.tree-sitter-grammars; [
        tree-sitter-bash
        tree-sitter-json
        tree-sitter-lua
        tree-sitter-markdown
        tree-sitter-python
        tree-sitter-yaml
        tree-sitter-cpp
        tree-sitter-c
        tree-sitter-nix
        tree-sitter-make
        tree-sitter-cmake
        tree-sitter-query
      ];
    };

    # Deploy all nvim config files
    home.file = {
      ".config/nvim/init.lua".source = ./init.lua;
      ".vimrc".source = ./vimrc;
      ".config/nvim/coc-settings.json".source = ./coc-settings.json;

      # recursively copy your Lua folder
      ".config/nvim/lua".source = ./lua;
    };
  };
}

