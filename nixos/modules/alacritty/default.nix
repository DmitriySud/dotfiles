{ config, lib, pkgs, ... }:
with  lib;

{

  options.my.alacritty = {
    enable = mkEnableOption "Alacritty";
    fontSize = mkOption {
      type = types.float;
      default = 11.5;
      description = "alacritty font size";
    };
  };

  config = mkIf config.my.alacritty.enable {
    programs.alacritty = {
      enable = true;
      settings = {
        font.size = config.my.alacritty.fontSize;
        window = {
            padding = {
                x = 8; # horizontal
                y = 8; # vertical 
            };
        };
        selection.save_to_clipboard = true;

        keyboard.bindings = [
          { key = "B"; mods = "Alt"; chars = "\\u001bb"; }  # Alt + B (Move backward one word)
          { key = "F"; mods = "Alt"; chars = "\\u001bf"; }  # Alt + F (Move forward one word)
          { key = "D"; mods = "Alt"; chars = "\\u001bd"; }  # Alt + D (Delete the word after the cursor)
          { key = "A"; mods = "Alt"; chars = "\\u0001"; }   # Alt + A (Go to begin)
          { key = "E"; mods = "Alt"; chars = "\\u0005"; }   # Alt + A (Go to end)
          { key = "Backspace"; mods = "Alt"; chars = "\\u001b\\u007F"; }  # Alt + Backspace (Delete word before cursor)
          { key = "U"; mods = "Alt"; chars = "\\u001bu"; }  # Alt + U (Uppercase from cursor to end of word)
          { key = "L"; mods = "Alt"; chars = "\\u001bl"; }  # Alt + L (Lowercase from cursor to end of word)
          { key = "C"; mods = "Alt"; chars = "\\u001bc"; }  # Alt + C (Capitalize the current word)
          { key = "."; mods = "Alt"; chars = "\\u001b."; }  # Alt + . (Insert the last argument of previous command)
          { key = "T"; mods = "Alt"; chars = "\\u001bt"; }  # Alt + T (Transpose the words around cursor)

          { key = "Y"; mods = "Alt"; action = "Copy";}  # Alt + Y (Yank selected to clipboard) 
          { key = "P"; mods = "Alt"; action = "Paste";}  # Alt + Y (Paste to clipboard) 
        ];
      };
    };
  };
}
