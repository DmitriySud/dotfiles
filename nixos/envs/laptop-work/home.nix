{
  config,
  lib,
  pkgs,
  ...
}:
let 
  ssh-devmachine-wrapper =
    pkgs.writeShellScriptBin "lastochka-byobu" ''
      if [ -z "''${__NIXOS_SET_ENVIRONMENT_DONE:-}" ] && [ -e /etc/set-environment ]; then
        . /etc/set-environment
      fi

      ssh lastochka -t byobu
    '';

  switch-layout-and-lock-wrapper = 
    pkgs.writeShellScriptBin "lock" ''
      hyprctl switchxkblayout all 0 && swaylock --image "$HOME/repos/dotfiles/pictures/lockscreen.png"
    '';

  ## not working; need to rewrite to lua
  lid-open-wrapper = 
    pkgs.writeShellScriptBin "lid-open" ''
      LAPTOP_MONITOR="eDP-1"

      hyprctl keyword monitor "$LAPTOP_MONITOR, preferred, 0x0, 2"
    '';
  lid-close-wrapper = 
    pkgs.writeShellScriptBin "lid-open" ''
      LAPTOP_MONITOR="eDP-1"
      MONITOR_COUNT=$(hyprctl monitors all | grep -c "^Monitor ")

      if [ "$MONITOR_COUNT" -gt 1 ]; then
          hyprctl keyword monitor "$LAPTOP_MONITOR, disable"
      fi
    '';

in {
  imports = [
    ../home-desktop.nix
  ];

  my.home-base.git-email = "dyusudakov@yandex-team.ru";
  my.home-base.enableBrightness = true;
  my.firefox.proxy.enable = false;

  my.hyprland = {
    enable = true;
    hyprlock.enable = false;

    monitors = ''
      hl.monitor({
          output = "eDP-1",
          mode = "preferred",
          position = "0x0",
          scale = "2",
      })

      hl.monitor({
          output = "DP-1",
          mode = "preferred",
          position = "auto",
          scale = "2",
          mirror = "eDP-1"
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
  my.alacritty.fontSize = 8.0;
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    size = 32;
  };

  home.packages = [
    switch-layout-and-lock-wrapper 
    ssh-devmachine-wrapper
  ];

  xdg.desktopEntries.lastochka-byobu = {
    name = "Lastochka Byobu";
    comment = "Open SSH session to lastochka in byobu";
    exec = "alacritty -e lastochka-byobu";
    terminal = false;
    type = "Application";
    categories = [ "Network" "TerminalEmulator" ];
  };
}
