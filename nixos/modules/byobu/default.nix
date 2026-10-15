{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.byobu;
in
{
  options.my.byobu = {
    enable = lib.mkEnableOption "Byobu configuration (links ~/.byobu/* and installs byobu)";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.byobu
      pkgs.tmux
    ];

    home.file.".byobu/color.tmux".source = ./files/color.tmux;
    home.file.".byobu/.reuse-session".source = ./files/.reuse-session;
    home.file.".byobu/.tmux.conf".text = builtins.readFile ./files/.tmux.conf + ''

      # Press prefix + F to search recent pane text; Enter copies the selection.
      # Byobu uses prefix + Tab for switching panes.
      set -g @extrakto_key F
      set -g @extrakto_grab_area recent
      set -g @extrakto_filter_order 'word path all line'
      set -g @extrakto_fzf_layout reverse
      set -g @extrakto_clip_tool_run tmux_osc52
      run-shell "${pkgs.tmuxPlugins.extrakto.rtp}"
    '';
  };
}
