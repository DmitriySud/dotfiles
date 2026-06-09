{
  config,
  lib,
  pkgs,
  user,
  ...
}:
{
  imports = [
    ./disko.nix
  ];

  # --- Boot (UEFI, no NVRAM dependency) ---
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;   # writes to /EFI/BOOT/BOOTX64.EFI fallback path
    device = "nodev";
  };
  boot.loader.efi.canTouchEfiVariables = false;

  # Minimal kernel modules for a KVM guest (no hardware-configuration.nix needed
  # since disko defines the filesystems and this is a known virtio guest).
  boot.initrd.availableKernelModules = [ 
    "ahci" "xhci_pci" "virtio_pci" "virtio_scsi" "sr_mod" "virtio_blk" 
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
  # NOTE: your other envs likely set the user up via ../main-user.nix.
  # I can't see that file, so I'm defining the user inline here.
  # If main-user.nix is parametrized and safe for a fresh system, swap this
  # block for:  imports = [ ../main-user.nix ];  and move the key there.
  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIWey9vBfHJaC02LXMxnXqqSA8j2mXTeQlCGvYDQjiyg ya_cloud"
    ];
  };

  security.sudo.wheelNeedsPassword = false;

  # Same key for root — useful for nixos-anywhere and recovery.
  users.users.root.openssh.authorizedKeys.keys =
    config.users.users.${user}.openssh.authorizedKeys.keys;

  # --- Basics ---
  time.timeZone = "Etc/UTC";
  environment.systemPackages = with pkgs; [ vim git curl ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "25.11";
}
