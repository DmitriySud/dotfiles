{ config, lib, ... }:
let
  cfg = config.my.xkbPunct;
  k = name: "<${name}>";
in
{
  options.my.xkbPunct = {
    enable = lib.mkEnableOption "custom XKB overlay for unified numpad punctuation";

    kbFile = lib.mkOption {
      type = lib.types.str;
      readOnly = true;
      default = "${config.xdg.configHome}/hypr/keymap.xkb";
      description = "Generated XKB keymap file path (for Hyprland input.kb_file).";
    };

    xkbExtraPath = lib.mkOption {
      type = lib.types.str;
      readOnly = true;
      default = "${config.xdg.configHome}/xkb";
      description = "Directory containing symbols/ (for XKB_CONFIG_EXTRA_PATH).";
    };

    # Key names (from xkbcli/wev). Yours matches defaults.
    numpadDecimalKey = lib.mkOption { type = lib.types.str; default = "KPDL"; };
    commaKey         = lib.mkOption { type = lib.types.str; default = "AB08"; };
    periodKey        = lib.mkOption { type = lib.types.str; default = "AB09"; };
  };

  config = lib.mkIf cfg.enable {
    xdg.enable = true;

    # Custom symbols file (goes under: ~/.config/xkb/symbols/punct)
    xdg.configFile."xkb/symbols/punct".text =
      ''
        partial alphanumeric_keys keypad_keys
        xkb_symbols "rucustom" {
          include "ru(winkeys)"

          key <KPDL> { [ period, comma ] };
        };
        
        xkb_symbols "uscustom" {
          include "us"

          key <KPDL> { [ period, comma ] };

          override key <AB08> { [ NoSymbol, less ] };

          override key <AB09> { [ NoSymbol, greater ] };
        };
      '';

    # Keymap file Hyprland will load
    xdg.configFile."hypr/keymap.xkb".text = ''
      xkb_keymap {
        xkb_keycodes  { include "evdev+aliases(qwerty)" };
        xkb_types     { include "complete" };
        xkb_compat    { include "complete" };

        xkb_symbols   { include "pc+punct(rucustom)+punct(uscustom)+inet(evdev)" };

        xkb_geometry  { include "pc(pc105)" };
      };
    '';
  };
}
