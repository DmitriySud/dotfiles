{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.my.home-base;
in
{
  imports = [
    ../modules/syncthing
    ../modules/passes
  ];

  options.my.home-base = {
    enableBrightness = mkOption {
      type = types.bool;
      default = false;
      description = "Enable brightness control and bindings";
    };

    git-email = mkOption {
      description = "Global git email";
    };
  };

  config = {
    my.syncthing.enable = true;
    my.syncthing.storage-dir = "${config.home.homeDirectory}/.local/state/sync";

    my.passes.enable = true;
    my.passes.identityFile = "${config.home.homeDirectory}/.config/age/keys.txt";
    my.passes.passwordStoreDir = "${config.home.homeDirectory}/repos/dotfiles/nixos/passes";

    home.username = "dsudakov";
    home.homeDirectory = "/home/dsudakov";
    home.stateVersion = "25.11";

    home.sessionVariables = {
      SSH_ASKPASS_REQUIRE = "prefer";
    };

    programs.git = {
      enable = true;
      settings = {
        user.name = "Dmitriy Sudakov";
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
        core.sshCommand = "ssh -o IdentitiesOnly=yes -i ~/.ssh/id_ed25519_gh";
      };
    };

    programs.home-manager.enable = true;

  };
}
