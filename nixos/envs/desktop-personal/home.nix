{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../home-desktop.nix
  ];

  my.xkbPunct.enable = true;
  my.home-base.git-email = "dmitriy.sudakov2001@yandex.ru";

  my.hyprland = {
    enable = true;
    monitors = ''
      hl.monitor({
          output = "DP-1",
          mode = "preferred",
          position = "0x0",
          scale = "1",
      })
    '';

    workspaces = ''
      hl.workspace_rule({
          workspace = "1",
          monitor = "DP-1",
      })

      hl.workspace_rule({
          workspace = "2",
          monitor = "DP-1",
      })

      hl.workspace_rule({
          workspace = "3",
          monitor = "DP-1",
      })

      hl.workspace_rule({
          workspace = "4",
          monitor = "DP-1",
      })

      hl.workspace_rule({
          workspace = "5",
          monitor = "DP-1",
      })

      hl.workspace_rule({
          workspace = "6",
          monitor = "DP-1",
      })

      hl.workspace_rule({
          workspace = "7",
          monitor = "DP-1",
      })

      hl.workspace_rule({
          workspace = "8",
          monitor = "DP-1",
      })

      hl.workspace_rule({
          workspace = "9",
          monitor = "DP-1",
      })

      hl.workspace_rule({
          workspace = "10",
          monitor = "DP-1",
      })
    '';

    hypridle.can-suspend = true;
  };

}
