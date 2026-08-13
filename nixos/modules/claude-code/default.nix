{ config, lib, pkgs, ... }:

let
  cfg = config.my.claude-code;
in
{
  options.my.claude-code = {
    enable = lib.mkEnableOption "claude-code";
  };

  config = lib.mkIf cfg.enable {
    programs.claude-code = {
      enable = true;
      package = pkgs.claude-code;

      settings = {
        theme = "dark";
        includeCoAuthoredBy = false;

        permissions = {
          allow = [
            "Bash(rg:*)"
            "Bash(fd:*)"
            "Read(**)"
          ];
          deny = [
            "Read(./.env)"
            "Read(./.env.*)"
            "Read(./secrets/**)"
            "Bash(rm -rf:*)"
          ];
        };

        env = {
          ANTHROPIC_BASE_URL= "https://api.eliza.yandex.net/raw/anthropic";
          DISABLE_TELEMETRY= "1";
          DISABLE_ERROR_REPORTING= "1";
          DISABLE_BUG_COMMAND= "1";
        };
        apiKeyHelper = "cat ~/.eliza/token";
        alwaysThinkingEnabled= true;
        hasCompletedOnboarding= true;
      };

      context = ''
        # Global instructions

        - Be concise. No preamble.
        - Prefer editing existing files over creating new ones.
        - Never commit unless explicitly asked.
        - Ask before any destructive filesystem operation.
      '';
    };

    home.packages = with pkgs; [
      ripgrep
      fd
      nodejs
    ];
  };
}
