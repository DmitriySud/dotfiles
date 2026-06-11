{
  modulesPath,
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
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIWey9vBfHJaC02LXMxnXqqSA8j2mXTeQlCGvYDQjiyg ya_cloud"
    ];
    shell = pkgs.zsh;
  };
  security.sudo.wheelNeedsPassword = false;

  # Root key login (the example installed with root keys; keep for parity/recovery).
  users.users.root.openssh.authorizedKeys.keys =[
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIWey9vBfHJaC02LXMxnXqqSA8j2mXTeQlCGvYDQjiyg ya_cloud"
  ];

  # --- Basics ---
  time.timeZone = "Europe/Moscow";
  environment.systemPackages = with pkgs; [ vim git curl ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "root" "dsudakov" ];

  system.stateVersion = "25.11";
}
