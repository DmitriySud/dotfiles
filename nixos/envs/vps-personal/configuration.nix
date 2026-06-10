{
  modulesPath,
  lib,
  pkgs,
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
  services.openssh.enable = true;

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
  ];

  services.qemuGuest.enable = true;

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
  };
  security.sudo.wheelNeedsPassword = false;

  # Root key login (the example installed with root keys; keep for parity/recovery).
  users.users.root.openssh.authorizedKeys.keys =
    config.users.users.${user}.openssh.authorizedKeys.keys;

  # --- Basics ---
  time.timeZone = "Europe/Moscow";
  environment.systemPackages = with pkgs; [ vim git curl ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "25.11";
}
