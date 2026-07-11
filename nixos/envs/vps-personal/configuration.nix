{
  modulesPath,
  config,
  lib,
  pkgs,
  user,
  ...
} @ args:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./hardware-configuration.nix
    ./disk-config.nix

    ../../modules/sops/default.nix
    ../../modules/sops/server.nix
  ];
  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  services.qemuGuest.enable = true;
  programs.zsh.enable = true;

  # --- Networking ---
  networking.hostName = "vps-personal";
  networking.useDHCP = lib.mkDefault true;
  networking.firewall.allowedTCPPorts = [ 8443 ];

  # --- SSH (key-only) ---
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "prohibit-password";
    };
  };

  # --- User ---
  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    linger = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIWey9vBfHJaC02LXMxnXqqSA8j2mXTeQlCGvYDQjiyg ya_cloud"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDqt/kmEk7YmqvWVPpxRV4unO1mCqzFzqPN+DThvzt7O laptop-personal"
    ];
    shell = pkgs.zsh;
  };
  security.sudo.wheelNeedsPassword = false;

  # Root key login (the example installed with root keys; keep for parity/recovery).
  users.users.root.openssh.authorizedKeys.keys = 
    config.users.users.${user}.openssh.authorizedKeys.keys;

  # --- Basics ---
  time.timeZone = "Europe/Moscow";
  environment.systemPackages = with pkgs; [ vim git curl ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "root" "dsudakov" ];

  system.stateVersion = "26.05";

  services.iam-alive-bot.enable = false;
}
