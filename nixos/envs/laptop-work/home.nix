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

  my.home-base.git-email = "dyusudakov@yandex-team.ru";
  my.home-base.enableBrightness = true;

  my.hyprland = {
    enable = true;
    monitors = ''
      hl.monitor({
          output = "eDP-1",
          mode = "preferred",
          position = "0x0",
          scale = "2",
      })

      hl.monitor({
          output = "DP-4",
          mode = "preferred",
          position = "auto-right",
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
          monitor = "DP-4",
      })

      hl.workspace_rule({
          workspace = "7",
          monitor = "DP-4",
      })

      hl.workspace_rule({
          workspace = "8",
          monitor = "DP-4",
      })

      hl.workspace_rule({
          workspace = "9",
          monitor = "DP-4",
      })

      hl.workspace_rule({
          workspace = "10",
          monitor = "DP-4",
      })
    '';

  };
  my.alacritty.fontSize = 15.0;
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    size = 32;
  };

}
