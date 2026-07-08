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

  my.home-base.git-email = "dmitriy.sudakov2001@yandex.ru";
  my.home-base.enableBrightness = true;
  my.xkbPunct.enable = false;

  my.hyprland = {
    enable = true;
    monitors = ''
      hl.monitor({
          output = "eDP-1",
          mode = "preferred",
          position = "0x0",
          scale = "1",
      })

      hl.monitor({
          output = "DP-1",
          mode = "preferred",
          position = "-2560x0",
          scale = "1",
      })
    '';

    workspaces = ''
      hl.workspace_rule({
          workspace = "1",
          monitor = "eDP-1",
      })

      hl.workspace_rule({
          workspace = "2",
          monitor = "eDP-1",
      })

      hl.workspace_rule({
          workspace = "3",
          monitor = "eDP-1",
      })

      hl.workspace_rule({
          workspace = "4",
          monitor = "eDP-1",
      })

      hl.workspace_rule({
          workspace = "5",
          monitor = "eDP-1",
      })

      hl.workspace_rule({
          workspace = "6",
          monitor = "eDP-1",
      })

      hl.workspace_rule({
          workspace = "7",
          monitor = "eDP-1",
      })

      hl.workspace_rule({
          workspace = "8",
          monitor = "eDP-1",
      })

      hl.workspace_rule({
          workspace = "9",
          monitor = "eDP-1",
      })

      hl.workspace_rule({
          workspace = "10",
          monitor = "eDP-1",
      })
    '';

  };
  my.alacritty.fontSize = 15.0;
}
