{ config, lib, ... }:
let
  cfg = config.my.xkbPunct;

  # Helper to render <FOO> from "FOO"
  k = name: "<${name}>";

  group1CommaPeriod =
    if (!cfg.disableMainCommaPeriod) then
      ""
    else if cfg.keepAngleBracketsInEn then ''
      // EN group: remove ',' and '.' but keep '<' and '>'
      key ${k cfg.commaKey}  { symbols[Group1] = [ NoSymbol, less    ] };
      key ${k cfg.periodKey} { symbols[Group1] = [ NoSymbol, greater ] };
    '' else ''
      // EN group: disable the keys completely (also removes '<' and '>')
      key ${k cfg.commaKey}  { symbols[Group1] = [ NoSymbol, NoSymbol ] };
      key ${k cfg.periodKey} { symbols[Group1] = [ NoSymbol, NoSymbol ] };
    '';

  group2RuKeepLetters = ''
    // RU group (winkeys): keep letters on these physical keys, remove extra levels if any
    key ${k cfg.commaKey}  { symbols[Group2] = [ Cyrillic_be, Cyrillic_BE, NoSymbol, NoSymbol ] };
    key ${k cfg.periodKey} { symbols[Group2] = [ Cyrillic_yu, Cyrillic_YU, NoSymbol, NoSymbol ] };
  '';

  symbolsText = ''
    // ~/.config/xkb/symbols/punct
    partial alphanumeric_keys keypad_keys
    xkb_symbols "custom" {

      // Unified numpad punctuation for BOTH groups (EN/RU):
      // tap => '.', Shift => ','
      key ${k cfg.numpadDecimalKey} {
        type[Group1] = "TWO_LEVEL",
        symbols[Group1] = [ period, comma ],
        type[Group2] = "TWO_LEVEL",
        symbols[Group2] = [ period, comma ]
      };

      ${group1CommaPeriod}

      ${lib.optionalString cfg.adjustRuCommaPeriodKeys group2RuKeepLetters}
    };
  '';

  keymapText = ''
    // ~/.config/hypr/keymap.xkb
    xkb_keymap {
      xkb_keycodes  { include "evdev+aliases(qwerty)" };
      xkb_types     { include "complete" };
      xkb_compat    { include "complete" };

      // us = Group1, ru(winkeys) = Group2, then apply our override last.
      xkb_symbols   { include "pc+us+ru(winkeys):2+inet(evdev)+punct(custom)" };

      xkb_geometry  { include "pc(pc105)" };
    };
  '';
in
{
  options.my.xkbPunct = {
    enable = lib.mkEnableOption "unified numpad punctuation (XKB overlay)";

    # Exported for Hyprland module to consume.
    kbFile = lib.mkOption {
      type = lib.types.str;
      readOnly = true;
      default = "${config.xdg.configHome}/hypr/keymap.xkb";
      description = "Path to generated XKB keymap file for Hyprland input.kb_file.";
    };

    # Key names (without angle brackets). Adjust if wev shows different ones.
    numpadDecimalKey = lib.mkOption { type = lib.types.str; default = "KPDL"; };
    commaKey         = lib.mkOption { type = lib.types.str; default = "AB08"; };
    periodKey        = lib.mkOption { type = lib.types.str; default = "AB09"; };

    # Duplicate removal behavior
    disableMainCommaPeriod = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Disable comma/period on the main keyboard in EN group to avoid duplicates.";
    };

    keepAngleBracketsInEn = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "If disabling EN comma/period, keep '<' and '>' on Shift for those keys.";
    };

    adjustRuCommaPeriodKeys = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "In RU group, ensure those keys are only б/ю (no extra punctuation levels).";
    };
  };

  config = lib.mkIf cfg.enable {
    xdg.enable = true;

    # Put custom symbols where xkbcommon can find them via XKB_CONFIG_EXTRA_PATH
    xdg.configFile."xkb/symbols/punct".text = symbolsText;

    # Hyprland will read this keymap via input.kb_file
    xdg.configFile."hypr/keymap.xkb".text = keymapText;
  };
}

