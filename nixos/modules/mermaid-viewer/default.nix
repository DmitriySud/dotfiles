{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.mermaidViewer;
  luaEscape = value: lib.replaceStrings [ "\\" "\"" ] [ "\\\\" "\\\"" ] value;
  launcher = pkgs.writeShellApplication {
    name = "mermaid-viewer";
    text = ''
      exec ${lib.getExe cfg.package} \
        --save-directory ${lib.escapeShellArg cfg.saveDirectory} \
        --width-fraction ${toString cfg.viewerWidthFraction} \
        "$@"
    '';
  };
  launcherPath = lib.getExe launcher;
in
{
  options.my.mermaidViewer = {
    enable = lib.mkEnableOption "Mermaid editor and image viewer";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.callPackage ../../packages/mermaid-viewer/default.nix { };
      description = "Mermaid viewer package to launch.";
    };

    saveDirectory = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/Pictures/mermaid";
      description = "Directory used by the Save image button.";
    };

    hotkey = lib.mkOption {
      type = lib.types.str;
      default = "SUPER + SHIFT + M";
      description = "Hyprland hotkey that opens the Mermaid editor.";
    };

    viewerWidthFraction = lib.mkOption {
      type = lib.types.addCheck lib.types.float (value: value > 0 && value < 1);
      default = 0.25;
      description = "Desired initial viewer width as a fraction of its monitor.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ launcher ];

    xdg.desktopEntries.mermaid-viewer = {
      name = "Mermaid Viewer";
      genericName = "Mermaid diagram renderer";
      exec = launcherPath;
      terminal = false;
      type = "Application";
      categories = [ "Graphics" ];
    };

    wayland.windowManager.hyprland.extraConfig = lib.mkIf config.wayland.windowManager.hyprland.enable (
      lib.mkAfter ''
        hl.bind("${luaEscape cfg.hotkey}", hl.dsp.exec_cmd("${luaEscape launcherPath}"))

        hl.window_rule({
            name = "mermaid-viewer-editor",
            match = {
                class = "^io\\.github\\.dyusudakov\\.MermaidViewer$",
                initial_title = "^Mermaid Viewer - Editor$",
            },
            float = true,
            center = true,
            size = { "(monitor_w*0.45)", "(monitor_h*0.55)" },
            suppress_event = "maximize",
        })

        hl.window_rule({
            name = "mermaid-viewer-image",
            match = {
                class = "^io\\.github\\.dyusudakov\\.MermaidViewer$",
                initial_title = "^Mermaid Viewer - Image$",
            },
            float = false,
            suppress_event = "maximize",
        })
      ''
    );
  };
}
