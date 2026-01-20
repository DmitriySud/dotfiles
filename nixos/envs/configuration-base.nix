{ config, lib,  pkgs, allowed-unfree-packages, ... }:

{
  system.stateVersion = "25.11"; # Did you read the comment?

  imports = [ 
    ./../modules/sops
    ./main-user.nix 
  ];

  main-user.enable = true;
  main-user.userName = "dsudakov";

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };


  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  i18n.defaultLocale = "en_US.UTF-8";

  programs.zsh.enable = true;
  environment.sessionVariables = {
  	NIXOS_OZONE_WL = "1";
	WLR_NO_HARDWARE_CURSORS = "1";
  };

  programs.hyprland.enable = true; 
  programs.xwayland.enable = true;

  security.pam.services.hyprlock = {};

  services.dbus.enable = true;
  security.polkit.enable = true;

  xdg.portal = {
  	enable = true;
	wlr.enable = true;
	extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  fonts.packages = with pkgs; [
  	noto-fonts
	noto-fonts-color-emoji
	nerd-fonts.fira-code
  ];

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.bluetooth = {
  	enable = true;
	powerOnBoot = true;
  };

  programs.ssh.startAgent = false;
  programs.seahorse.enable = true;
  security.pam.services = {
    greetd.enableGnomeKeyring = true;
    greetd-password.enableGnomeKeyring = true;
    login.enableGnomeKeyring = true;
    gdm-password.enableGnomeKeyring = true;
  };
  services.dbus.packages = [ pkgs.gnome-keyring ];

  services.udev.packages = with pkgs; [ 
    qmk
    qmk-udev-rules # the only relevant
    qmk_hid
    vial
  ];

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    neovim 
    wget
    gnome-keyring
  ];

  services.gnome.gcr-ssh-agent.enable = true;
  # programs.ssh.askPassword = "${pkgs.gcr_4}/libexec/gcr4-ssh-askpass";

  systemd.services."lock-on-sleep" = {
    description = "Lock screen on sleep";
    wantedBy = [ "sleep.target" ];
    before = [ "sleep.target" ];
    serviceConfig.ExecStart = "${pkgs.hyprlock}/bin/hyprlock";
  };

  services.logind = {
    settings = {
        Login.HandleLidSwitchDocked = "ignore";
        Login.HandlLidSwitch = "suspend";
        Login.HandlPowerKey = "suspend";
    };
  };

  services.xserver.enable = true;

  services.displayManager.gdm = {
    enable = true;
    wayland = true;
  };


}

