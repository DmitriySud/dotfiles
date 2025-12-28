{ config, lib, pkgs, ... }:

with lib;
let 
  cfg = config.my.home-base;
in {
  options.my.home-base = {
    enableBrightness = mkOption {
      type = types.bool;
      default = false;
      description = "Enable brightness control and bindings";
    };

    git-email = mkOption {
      type = types.string;
      default = false;
      description = "Global git email";
    };
  };

  config = {
    home.username = "dsudakov";
    home.homeDirectory = "/home/dsudakov";
    home.stateVersion = "25.11";

    home.sessionVariables = {
      SSH_ASKPASS_REQUIRE = "prefer";
    };

    home.file.".ssh/config".text = ''
      Host *
        CanonicalDomains hprtrk.com
        CanonicalizeHostname yes
        StrictHostKeyChecking no
        ForwardAgent yes
    '';

    programs.git = {
      enable = true;
      settings = {
        user.name  = "Dmitriy Sudakov";
        user.email = cfg.git-email;

        pull.rebase = false;
        pull.ff = "only";
        
        core.editor = "nvim";

        #merge.tool = vimdiff;
        #merge.conflictstyle = "diff3";

        #mergetool = {
        #    keepBackup = false;
        #    prompt = false;
        #    vimdiff.cmd = "nvim  -d $MERGED $LOCAL $BASE $REMOTE -c 'wincmd J | wincmd ='";
        #};

        color.ui = "auto";
      };
    };

    programs.home-manager.enable = true;
  };
}

