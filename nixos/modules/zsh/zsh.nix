{ lib, config, pkgs, ...}:

{
	options.my.zsh.enable = lib.mkEnableOption "Enable custom Zsh";

	config = lib.mkIf config.my.zsh.enable {
	  programs.zsh = {
	    enable = true;
	    enableCompletion = true;
	    enableAutosuggestions = true;
	    enableSyntaxHighlighting= true;

        defaultKeymap = "emacs";

	    initContent = builtins.readFile(pkgs.replaceVars ./zsh-extra.zsh {
		  zshHistoryPlugin = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
		  p10kTheme = "${pkgs.zsh-fzf-history-search}/share/zsh-fzf-history-search/zsh-fzf-history-search.zsh";
		  goto = "${pkgs.goto}/share/goto.sh";
	    });
	  };
      home.packages = with pkgs; [
        fzf
        ripgrep
        bat
        fd
        goto

        zsh-fzf-history-search
        zsh-autosuggestions
        zsh-powerlevel10k
      ];

	  home.file.".p10k.zsh".source = ./p10k.zsh;
	};
}
