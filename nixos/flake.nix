{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      sops-nix,
      ...
    }@inputs:
    let
      system = builtins.currentSystem;
      user = "dsudakov";
      pkgs = nixpkgs.legacyPackages.${system};

      allowed-unfree-packages = [
        "nvidia-x11"
        "nvidia-settings"
        "nvidia-persistenced"
      ];

      mkNixos =
        envPath:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit allowed-unfree-packages user; };
          modules = [
            (envPath + "/configuration.nix")
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit user sops-nix; };
              home-manager.users.${user} = import (envPath + "/home.nix");
            }

            sops-nix.nixosModules.sops
          ];
        };

      mkHome =
        envPath:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit user sops-nix; };
          modules = [ (envPath + "/home.nix") ];
        };

    in
    {
      nixosConfigurations = {
        desktop-personal = mkNixos ./envs/desktop-personal;
        laptop-personal = mkNixos ./envs/laptop-personal;
        laptop-work = mkNixos ./envs/laptop-work;
      };

      homeConfigurations = {
        "${user}-desktop-personal" = mkHome ./envs/desktop-personal;
        "${user}-laptop-personal" = mkHome ./envs/laptop-personal;
        "${user}-laptop-work" = mkHome ./envs/laptop-work;
        "${user}-remote-ssh-work" = mkHome ./envs/remote-ssh-work;
      };

      apps.${system}.nixfmt = import ./apps/nixfmt.nix { inherit pkgs; };
    };
}
