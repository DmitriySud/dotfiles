{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/0ad6f47ea4fe188f4bc8f0380f93ae8523337c6c";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix/56b24064fdcaedca53553b1a6d607fd23b613a24";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    
    # This is a temporary hack because i use this repo 
    # as a deploy tool for vps
    userver-nix-tgbot = {
      url = "github:DmitriySud/userver-nix-tgbot";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      sops-nix,
      disko,
      userver-nix-tgbot,
      ...
    }@inputs:
    let
      personalUsername = "dsudakov";
      workUsername = "dysudakov";
      incyOverlay = final: prev: {
        incy = final.callPackage ./packages/incy/default.nix {};
      };

      mkPkgsUnstable = system:
        import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };

      allowed-unfree-packages = [
        "nvidia-x11"
        "nvidia-settings"
        "nvidia-persistenced"
        "obsidian"
        "claude-code"
      ];

      mkNixos =
        envPath: system: username:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit allowed-unfree-packages username; };
          modules = [
            (envPath + "/configuration.nix")
            { nixpkgs.overlays = [incyOverlay ]; }
            disko.nixosModules.disko
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit username sops-nix;
                pkgsUnstable = mkPkgsUnstable system;
              };
              home-manager.users.${username} = import (envPath + "/home.nix");
            }

            sops-nix.nixosModules.sops
            userver-nix-tgbot.nixosModules.default
          ];
        };

      mkHome =
        envPath: system: username:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ incyOverlay ];
            config.allowUnfree = true;
          };
          extraSpecialArgs = {
            inherit username sops-nix;
            pkgsUnstable = mkPkgsUnstable system;
          };
          modules = [ (envPath + "/home.nix") ];
        };

    in
    {
      nixosConfigurations = {
        desktop-personal = mkNixos ./envs/desktop-personal "x86_64-linux" personalUsername;
        laptop-personal = mkNixos ./envs/laptop-personal "x86_64-linux" personalUsername;
        laptop-work = mkNixos ./envs/laptop-work "x86_64-linux" workUsername;
        vps-personal = mkNixos ./envs/vps-personal "x86_64-linux" personalUsername;
      };

      homeConfigurations = {
        desktop-personal = mkHome ./envs/desktop-personal "x86_64-linux" personalUsername;
        laptop-personal = mkHome ./envs/laptop-personal "x86_64-linux" personalUsername;
        laptop-work = mkHome ./envs/laptop-work "x86_64-linux" workUsername;
        vps-work = mkHome ./envs/vps-work "x86_64-linux" workUsername;
        vps-personal = mkHome ./envs/vps-personal "x86_64-linux" personalUsername;
      };

      devShells."x86_64-linux" = import ./devshells {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          overlays = [ incyOverlay ];
          config.allowUnfree = true;
        };
      };

#      apps.${system}.nixfmt = import ./apps/nixfmt.nix { inherit pkgs; };
    };
}
