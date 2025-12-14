{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager/update/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs : let
  	system = "x86_64-linux";
    user = "dsudakov";

    allowed-unfree-packages = [
        "nvidia-x11"
        "nvidia-settings"
        "nvidia-persistenced"
    ];

    mkNixos = envPath:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit allowed-unfree-packages user; };
        modules = [
          (envPath + "/configuration.nix")
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit allowed-unfree-packages user; };
            home-manager.users.${user} = import (envPath + "/home.nix");
          }
        ];
      };

    mkHome = envPath:
      home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        extraSpecialArgs = { inherit allowed-unfree-packages user; };
        modules = [ (envPath + "/home.nix") ];
      };

  in {
    nixosConfigurations = {
      desktop-pc      = mkNixos ./envs/desktop-pc;
      laptop-personal = mkNixos ./envs/laptop-personal;
      laptop-work     = mkNixos ./envs/laptop-work;
    };

    homeConfigurations = {
      "${user}-desktop-pc"      = mkHome ./envs/desktop-pc;
      "${user}-laptop-personal" = mkHome ./envs/laptop-personal;
      "${user}-laptop-work"     = mkHome ./envs/laptop-work;
    };
  };
}
