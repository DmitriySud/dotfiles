{ config, lib, pkgs, ... }:

{

  imports = [
    ../modules/shadowsocks/shadowsocks.nix
    ../modules/firefox.nix
    ../modules/zsh/zsh.nix
    ../modules/nvim/default.nix
    ../modules/hyprland/default.nix
  ];

  my.zsh.enable = true;
  my.nvim.enable = true;
  
  
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "dsudakov";
  home.homeDirectory = "/home/dsudakov";

  services.shadowsocks-local.enable = true;

  home.sessionVariables = {
    SSH_ASKPASS_REQUIRE = "prefer";
  };

  home.stateVersion = "25.11";

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    alacritty
    firefox
    chromium

    telegram-desktop

    jq
    git
    tree

    gnome-keyring
  ];

  programs.alacritty = {
    enable = true;
    settings = {
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


  home.file.".ssh/config".text = ''
  Host *
    CanonicalDomains hprtrk.com
    CanonicalizeHostname yes
    StrictHostKeyChecking no
    ForwardAgent yes
  '';

  # Let Home Manager install and manage itself.
  programs.git = {
    enable = true;
    settings = {
        user.name = "DmitriySud";
        user.email = "dmitriy.sudakov2001@gmail.com";
    };
  };

  programs.home-manager.enable = true;

  services.gnome-keyring = {
    enable = true;
    components = [ "pkcs11" "secrets" ];
  };
}
