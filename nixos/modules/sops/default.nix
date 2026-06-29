{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    sops
  ];

  sops.age = {
    keyFile = "/var/lib/sops-nix/age/keys.txt";
    generateKey = true;
  };
}
