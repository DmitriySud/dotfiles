{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.xkbPunct;
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
  };

  config = lib.mkIf cfg.enable {
    xdg.enable = true;
    home.packages = [
      pkgs.libxkbcommon
    ];

    # Custom symbols file (goes under: ~/.config/xkb/symbols/punct)
    xdg.configFile."xkb/symbols/punct".text = ''
      partial alphanumeric_keys keypad_keys
      xkb_symbols "custom" {

        // Numpad decimal: tap '.' ; Shift ','
        // Applies to BOTH groups (EN/RU)
        replace key <KPDL> {
          type[Group1] = "TWO_LEVEL",
          symbols[Group1] = [ period, comma ],
          type[Group2] = "TWO_LEVEL",
          symbols[Group2] = [ period, comma ]
        };

        replace key <AB08> {
          symbols[Group1] = [ less, less ]
        };

        replace key <AB09> {
          symbols[Group1] = [ greater, greater ]
        };

        replace key <AB10> {
          symbols[Group2] = [ slash, question ]
        };

        replace key <BKSL> {
          symbols[Group2] = [ backslash, bar ]
        };

        replace key <AC11> {
          symbols[Group2] = [ apostrophe, quotedbl ]
        };

        replace key <AC10> {
          symbols[Group2] = [ semicolon, colon ]
        };

        replace key <KP1> {
          symbols[Group1] = [ NoSymbol, NoSymbol ],
          symbols[Group2] = [ Cyrillic_ha, Cyrillic_HA ]
        };

        replace key <KP2> {
          symbols[Group1] = [ NoSymbol, NoSymbol ],
          symbols[Group2] = [ Cyrillic_hardsign, Cyrillic_HARDSIGN ]
        };

        replace key <AD11> {
          symbols[Group2] = [ Cyrillic_zhe, Cyrillic_ZHE ]
        };

        replace key <AD12> {
          symbols[Group2] = [ Cyrillic_e, Cyrillic_E ]
        };

        replace key <AE02> {
          symbols[Group2] = [ 2, at ]
        };

        replace key <AE03> {
          symbols[Group2] = [ 3, numbersign ]
        };

        replace key <AE04> {
          symbols[Group2] = [ 4, dollar ]
        };

        replace key <AE06> {
          symbols[Group2] = [ 6, asciicircum ]
        };

        replace key <AE07> {
          symbols[Group2] = [ 7, ampersand ]
        };
      };
    '';

    # Keymap file Hyprland will load
    xdg.configFile."hypr/keymap.xkb".text = ''
      xkb_keymap {
        xkb_keycodes  { include "evdev+aliases(qwerty)" };
        xkb_types     { include "complete" };
        xkb_compat    { include "complete" };

        xkb_symbols   { include "pc+us+ru(winkeys):2+inet(evdev)+punct(custom)" };

        xkb_geometry  { include "pc(pc105)" };
      };
    '';
  };
}
