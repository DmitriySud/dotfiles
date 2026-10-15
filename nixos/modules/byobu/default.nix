{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.byobu;
  extrakto = pkgs.tmuxPlugins.extrakto.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [ ./extrakto-files.patch ];
    postPatch = (old.postPatch or "") + ''
      cp ${./extrakto_files.py} extrakto_files.py
    '';
    doCheck = true;
    nativeCheckInputs = (old.nativeCheckInputs or [ ]) ++ [ pkgs.python3 ];
    checkPhase = ''
      runHook preCheck
      PYTHONDONTWRITEBYTECODE=1 PYTHONPATH="$PWD" python3 ${./tests/test_extrakto_files.py}
      runHook postCheck
    '';
  });
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

      # Press prefix + F to select existing files from pane text; Enter copies.
      # Byobu uses prefix + Tab for switching panes.
      set -g @extrakto_key F
      set -g @extrakto_grab_area recent
      set -g @extrakto_filter_order file
      set -g @extrakto_fzf_layout default
      set -g @extrakto_clip_tool_run tmux_osc52
      run-shell "${extrakto.rtp}"
    '';
  };
}
