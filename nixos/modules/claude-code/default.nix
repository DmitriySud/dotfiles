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
            "Bash(git diff:*)"
            "Bash(git log:*)"
            "Bash(git status)"
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
          DISABLE_TELEMETRY = "1";
          BASH_DEFAULT_TIMEOUT_MS = "120000";
          HTTP_PROXY = "http://127.0.0.1:10808";
          HTTPS_PROXY = "http://127.0.0.1:10808";
        };
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
