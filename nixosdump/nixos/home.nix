{ config, lib, pkgs, ... }:

let 
	hyprctl_bin = "${pkgs.hyprland}/bin/hyprctl";
	jq_bin = "${pkgs.jq}/bin/jq";

	switcherScript = pkgs.writeShellScript "switcher.sh" ''
#!/usr/bin/env bash

# Example detection for external screens
EXTERNAL_COUNT=$(${hyprctl_bin} monitors -j | ${jq_bin} '[.[] | select(.name != env.HYPR_BUILDIN_MON)] | length')

if [ "$EXTERNAL_COUNT" -gt 0 ]; then
	echo "External monitor connected — disabling built-in"
	hyprctl keyword monitor "$HYPR_BUILDIN_MON,disable"
else
	echo "No external monitors — enabling built-in"
	hyprctl keyword monitor "$HYPR_BUILDIN_MON,highresxhighrr,0x0,1"
fi
	'';

	lockscreen_img = builtins.fetchurl {
	  url = "https://raw.githubusercontent.com/DmitriySud/dotfiles/master/stow/i3/Pictures/lockscreen.png";
	  sha256 = "sha256:0nbi3yygax6ay6pgz07vxdwxw960js2b0kk9fj99vvgvksz1p2ns";
	};

	mainscreen_img = builtins.fetchurl {
	  url = "https://raw.githubusercontent.com/DmitriySud/dotfiles/master/stow/i3/Pictures/wallpaper.png";
	  sha256 = "sha256:1yj2g2hqxkprap8g2fzp8385z8lx5pi45x1xib3g8dc3c9sy5v9b";
	};

in {

  imports = [
  	./modules/shadowsocks/shadowsocks.nix
	./modules/firefox.nix
	./modules/zsh/zsh.nix
	./modules/nvim/default.nix
  ];

  my.zsh.enable = true;
  my.nvim.enable = true;
	
	
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "dsudakov";
  home.homeDirectory = "/home/dsudakov";

  services.shadowsocks-local.enable = true;

  # systemd.user.services.hypr-display-switcher = {
  #   enable = false;
  #   Unit = {
  #     Description = "Enables/disables the built-in display on HDMI plug/unplug";
  #   };
  #   Service = {
  #     Type = "oneshot";
  #     ExecStart = "${switcherScript}";
  #   };
  #   Install = {
  #     WantedBy = [ "default.target" ];
  #   };
  # };

  wayland.windowManager.hyprland = {
  	enable = true;
	systemd.enable = true;
	xwayland.enable = true;

    plugins = [
        pkgs.hypridle
        pkgs.hyprpaper
        pkgs.hyprlock
    ];

    settings = {
        exec-once = [
            "waybar &"
            "nm-applet &"
            "blueman-applet"
        ];

        input = {
            kb_layout = "us,ru";
            kb_options = "grp:caps_toggle";
            follow_mouse = 1;
            touchpad.natural_scroll = false;
        };

        "$mod" = "SUPER";

        bind = [
            "$mod, RETURN, exec, alacritty"
            "$mod, Q, killactive,"
            "$mod SHIFT, E, exit, "
            "$mod, D, exec, wofi --show drun"
            "$mod SHIFT, L, exec, hyprlock"
            "$mod, F, fullscreen"
            "CTRL ALT, 1, exec, hyprctl switchxkblayout all 0"
            "CTRL ALT, 2, exec, hyprctl switchxkblayout all 1"
            "$mod, PRINT, exec, hyprshot -m window"
            ", PRINT, exec, hyprshot -m output"
            "$mod SHIFT, PRINT, exec, hyprshot -m region --clipboard-only --freeze"
            "$mod, h, movefocus, l"
            "$mod, l, movefocus, r"
            "$mod, k, movefocus, u"
            "$mod, j, movefocus, d"
            "$mod, 1, workspace, 1"
            "$mod, 2, workspace, 2"
            "$mod, 3, workspace, 3"
            "$mod, 4, workspace, 4"
            "$mod, 5, workspace, 5"
            "$mod, 6, workspace, 6"
            "$mod, 7, workspace, 7"
            "$mod, 8, workspace, 8"
            "$mod, 9, workspace, 9"
            "$mod, 0, workspace, 0"
            "$mod SHIFT, 1, movetoworkspace, 1"
            "$mod SHIFT, 2, movetoworkspace, 2"
            "$mod SHIFT, 3, movetoworkspace, 3"
            "$mod SHIFT, 4, movetoworkspace, 4"
            "$mod SHIFT, 5, movetoworkspace, 5"
            "$mod SHIFT, 6, movetoworkspace, 6"
            "$mod SHIFT, 7, movetoworkspace, 7"
            "$mod SHIFT, 8, movetoworkspace, 8"
            "$mod SHIFT, 9, movetoworkspace, 9"
            "$mod SHIFT, 0, movetoworkspace, 0"
        ];

        monitor = [
            "desc:Dell Inc. DELL U2724D C78GF34, 2460x1440, -2560x0, 1"
            "desc:Huawei Technologies Co. Inc. ZQE-CBA 0xC080F622, 2560x1440, 0x-1440, 1"
            "eDP-1, preferred, 0x0, 1"
        ];

        workspace = [
            "1, monitor:HDMI-A-1"
            "2, monitor:HDMI-A-1"
            "3, monitor:HDMI-A-1"
            "4, monitor:HDMI-A-1"
            "5, monitor:HDMI-A-1"
            "6, monitor:eDP-1"
            "7, monitor:eDP-1"
            "8, monitor:eDP-1"
            "9, monitor:eDP-1"
            "0, monitor:eDP-1"
        ];
        decoration = {
            rounding = 4;
            border_part_of_window = false;
            active_opacity = 1 ;
            inactive_opacity = 0.9;
        };

        general = {
            border_size = 3 ;
            gaps_in = 2;
            gaps_out = 5;
        };
    };
  };

  xdg.configFile."hypr/hyprpaper.conf".text = ''
	preload = ${mainscreen_img}
	wallpaper = , ${mainscreen_img}
  '';

  programs.waybar = {
    enable = true;
    package = pkgs.waybar;

    # Waybar configuration (JSON or JSONC)
    settings = {
      mainBar = {
	  layer = "top";
	  position = "top";

	  modules-left = [
	    "hyprland/workspaces"
	  ];

	  modules-center = [
	    "clock"
	  ];

	  modules-right = [
	    "cpu"
	    "memory"
	    "network"
	    "battery"
	    "tray"
	  ];

	  cpu = {
	    format = "   {usage}%";
	  };

	  memory = {
	    format = "   {used}GiB";
	  };

	  network = {
	    format-wifi = "   {signalStrength}%";
	    format-ethernet = "󰈁  Online";
	    format-disconnected = "󰖪    Offline";
	  };

	  battery = {
	    format = "{icon}   {capacity}%";
	    format-icons = ["" "" "" "" ""];
	  };

	  "clock"= {
        "format"= "{:%H:%M    %Y-%m-%d    }";
        "tooltip-format"= "<tt><small>{calendar}</small></tt>";
        "calendar"= {
            "mode"          = "year";
            "mode-mon-col"  = 3;
            "weeks-pos"     = "right";
            "format"= {
                "months"=     "<span color='#ffead3'><b>{}</b></span>";
                "days"=       "<span color='#ecc6d9'><b>{}</b></span>";
                "weeks"=      "<span color='#99ffdd'><b>W{}</b></span>";
                "weekdays"=   "<span color='#ffcc66'><b>{}</b></span>";
                "today"=      "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
        };
      };
      };
    };

    # Waybar styling (CSS)
    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 14px;
      }
      #clock {
        padding: 0 10px;
      }
      #cpu, #memory, #network, #clock, #battery {
    	 padding-left: 8px;
	 padding-right: 8px;
      }
    '';
  };

  services.hypridle = {
    enable = true;
    settings = {
        general = {
            lock_cmd = "pidof hyprlock || hyprlock";
            before_sleep_cmd = "loginctl lock-session";
            after_sleep_cmd = "hyprctl dispatch dpms on";
        };
 
        listener = [
            {
                timeout = 300; 
                on-timeout = "loginctl lock-session";         
            }
            {
                timeout = 600;                                
                on-timeout = "hyprctl dispatch dpms off";
                on-resume = "hyprctl dispatch dpms on";
            }
            {
                timeout = 900;
                on-timeout = "systemd suspend";
            }
        ];
    };
  };
  


  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
  	waybar
	wofi
	hyprlock
	hyprpaper
	hyprshot
	hypridle
	alacritty
	firefox
	chromium
	wl-clipboard
    swayimg
    nemo
	cliphist
	networkmanagerapplet
	blueman

	telegram-desktop

	jq
	git
	tree
  ];

  services.blueman-applet.enable = true;

  programs.alacritty = {
  	enable = true;
	settings = {
		window = {
			padding = {
				x = 8; # horizontal
				y = 8; # vertical 
			};
		};
	};
  };

  home.file.".local/bin/lock".text = ''
	#!/bin/sh
	hyprlock
	'';

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        no_fade_in = false;
      };
      background = [
        {
          path = lockscreen_img;
          blur_size = 1;
          blur_passes = 3;
        }
      ];

      input-field = {
        size = {
          width = 200;
          height = 50;
        };

        outline_thickness = 3;
        dots_size = 0.33;
        dots_spacing = 0.15;
        dots_center = false;
        #outer_color = "${base01}";
        #inner_color = "${base07}";
        #font_color = "${base00}";
        fade_on_empty = true;
        placeholder_text = "<i>Input Password...</i>";
        hide_input = false;
        halign = "center";
        valign = "center";
      };

      label = {
        text = "$TIME";
        font_size = 50;
        font_family = "Noto Sans";
        halign = "center";
        valign = "top";
      };
    };
  };


  home.sessionVariables = {
    HYPR_BUILDIN_MON = "eDP-1";
  	XDG_CURRENT_DESKTOP = "Hyprland";
	XDG_SESSION_TYPE = "wayland";
	NIXOS_OZONE_WL = "1";
  };

  home.file.".ssh/config".text = ''
  Host *
    CanonicalDomains hprtrk.com
    CanonicalizeHostname yes
    StrictHostKeyChecking no
    ForwardAgent yes
  '';

  home.activation.reloadHyprland = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  	${hyprctl_bin} reload || true
  '';

  # Let Home Manager install and manage itself.
  programs.git = {
    enable = true;
    userName = "DmitriySud";
    userEmail = "dmitriy.sudakov2001@gmail.com";
  };

  programs.home-manager.enable = true;

  services.gnome-keyring = {
    enable = true;
    components = [ "pkcs11" "secrets" "ssh" ];   
  };

}
