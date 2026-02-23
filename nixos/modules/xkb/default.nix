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
        xkb_symbols "custom" {

          // Numpad decimal: tap '.' ; Shift ','
          // Applies to BOTH groups (EN/RU)
          key ${k cfg.numpadDecimalKey} {
            type[Group1] = "TWO_LEVEL",
            symbols[Group1] = [ period, comma ],
            type[Group2] = "TWO_LEVEL",
            symbols[Group2] = [ period, comma ]
          };

          key ${k cfg.commaKey}  { symbols[Group1] = [ NoSymbol, less    ] };
          key ${k cfg.periodKey} { symbols[Group1] = [ NoSymbol, greater ] };
        };
      '';

    # Keymap file Hyprland will load
    xdg.configFile."hypr/keymap.xkb".text = ''
      xkb_keymap {
        xkb_keycodes  { include "evdev+aliases(qwerty)" };
        xkb_types     { include "complete" };
        xkb_compat    { include "complete" };

        // IMPORTANT: ru(winkeys):2 (not plain ru:2)
        xkb_symbols   { include "pc+us+ru(winkeys):2+inet(evdev)+punct(custom)" };

        xkb_geometry  { include "pc(pc105)" };
      };
    '';
  };
}
