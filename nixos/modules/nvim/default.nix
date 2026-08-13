{
  config,
  pkgs,
  lib,
  ...
}:
let 
  treesitterMain = pkgs.fetchFromGitHub {
    owner = "nvim-treesitter";
    repo = "nvim-treesitter";
    rev = "7248feaca45e4d944591497964bc19afa89ad1c6";
    hash = "sha256-FQj0+qeaW9rLy3dUbGbUG4UYtnry7UBA1n9SM2qXLdk=";
  };

  # grammars you want, from nixpkgs
  grammars = pkgs.symlinkJoin {
    name = "nvim-treesitter-grammars";
    paths = with pkgs.vimPlugins.nvim-treesitter-parsers; [
      bash json lua markdown python yaml cpp c nix
      make cmake query go
    ];
  };

  nvim-treesitter-main = pkgs.vimUtils.buildVimPlugin {
    pname = "nvim-treesitter";
    version = "main";
    src = treesitterMain;
    doCheck = false;

    # Install grammars into the plugin's `parser/` directory so the
    # main branch finds them on the runtimepath.
    postInstall = ''
      mkdir -p $out/parser
      for so in ${grammars}/parser/*.so; do
        ln -s "$so" "$out/parser/$(basename "$so")"
      done
    '';
  };

in {
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
        nvim-treesitter-main
      ];
      extraPackages = with pkgs; [] 
      ++ lib.optionals (!config.my.nvim.light) [
        tree-sitter
        gcc
      ];

      initLua = builtins.readFile ./init.lua;
    };

    # Deploy all nvim config files
    home.file = {
      ".vimrc".source = ./vimrc;
      ".config/nvim/coc-settings.json".source = ./coc-settings.json;

      # recursively copy your Lua folder
      ".config/nvim/lua/".source = ./lua;
      ".config/typos/typos.toml".source = ./typos.toml;
    };
  };
}
