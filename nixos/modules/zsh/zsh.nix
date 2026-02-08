{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.my.zsh;

  gotoIntegration = lib.optionalString (config.my.goto.enable) config.my.goto.shellIntegration;
  dumpIntegration = builtins.readFile ./dump.zsh;
in
{
  options.my.zsh.enable = lib.mkEnableOption "Enable custom Zsh";

  config = lib.mkIf config.my.zsh.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      defaultKeymap = "emacs";

      initContent =
        builtins.readFile (
          pkgs.replaceVars ./zsh-extra.zsh {
            p10kTheme = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
            zshHistoryPlugin = "${pkgs.zsh-fzf-history-search}/share/zsh-fzf-history-search/zsh-fzf-history-search.zsh";
          }
        )
        + "\n"
        + gotoIntegration
        + "\n"
        + dumpIntegration;

      envExtra = ''
        DUMP_DIR=$HOME/dump
      '';

      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "history"
        ];
      };
    };

    home.packages = with pkgs; [
      fzf
      ripgrep
      bat
      fd

      zsh-fzf-history-search
      zsh-powerlevel10k
    ];

    home.file.".p10k.zsh".source = ./p10k.zsh;
  };
}
