{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../home-terminal.nix
    ../../modules/obsidian-backup
  ];

  my.home-base.git-email = "dmitriy.sudakov2001@gmail.com";
  my.byobu.enable = true;
  my.syncthing.enable = true;
  my.nvim.light = true;

  services.obsidianBackup = {
    enable = true;
    interval = "2d";
    sourceDir = "${config.home.homeDirectory}/.local/state/sync/obsidian";
    repoDir = "${config.home.homeDirectory}/repos/obsidian-backup";
    maxBackups = 2;
    sshKeyPath = "${config.home.homeDirectory}/.ssh/id_ed25519_obsidian_backup";
  };

}
