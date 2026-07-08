{
  config,
  pkgs,
  lib,
  ...
}:

{
  options.my.nvim = {
    enable = lib.mkEnableOption "Enable my neovim";
    light = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkIf config.my.nvim.enable {

    home.packages = with pkgs; [
      ripgrep # for telescope or grep
      fd # for fzf/telescope
      fzf
    ] ++ lib.optionals (!config.my.nvim.light) [
      nodejs # needed for coc
      clang-tools
      pyright
      typos-lsp
    ];

    programs.neovim = {
      enable = true;
      defaultEditor = true;

      # Lua support (optional)
      viAlias = true;
      vimAlias = true;

      plugins = with pkgs.vimPlugins; [
        plenary-nvim
        telescope-nvim
        vim-easymotion
        catppuccin-nvim
        lualine-nvim
        nvim-autopairs
        indent-blankline-nvim
        neo-tree-nvim
        comment-nvim
        alpha-nvim
        gitsigns-nvim
        nvim-web-devicons
      ] ++ lib.optionals (!config.my.nvim.light) [
        coc-nvim
        nvim-treesitter
      ];
      extraPackages = with pkgs.tree-sitter-grammars; [] 
      ++ lib.optionals (!config.my.nvim.light) [
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
      # ".config/nvim/init.lua".source = ./init.lua;
      ".vimrc".source = ./vimrc;
      ".config/nvim/coc-settings.json".source = ./coc-settings.json;

      # recursively copy your Lua folder
      ".config/nvim/lua/".source = ./lua;
      ".config/typos/typos.toml".source = ./typos.toml;
    };
  };
}
