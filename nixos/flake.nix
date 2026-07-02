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
      home-manager,
      sops-nix,
      disko,
      userver-nix-tgbot,
      ...
    }@inputs:
    let
      system = builtins.currentSystem;
      user = "dsudakov";
      incyOverlay = final: prev: {
        incy = final.callPackage ./packages/incy/default.nix {};
      };

      pkgs = import nixpkgs {
        inherit system;
        overlays = [ incyOverlay ];
        config.allowUnfree = true;
      };

      allowed-unfree-packages = [
        "nvidia-x11"
        "nvidia-settings"
        "nvidia-persistenced"
        "obsidian"
      ];

      mkNixos =
        envPath: system:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit allowed-unfree-packages user; };
          modules = [
            (envPath + "/configuration.nix")
            { nixpkgs.overlays = [incyOverlay ]; }
            disko.nixosModules.disko
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit user sops-nix; };
              home-manager.users.${user} = import (envPath + "/home.nix");
            }

            sops-nix.nixosModules.sops
            userver-nix-tgbot.nixosModules.default
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
        desktop-personal = mkNixos ./envs/desktop-personal "x86_64-linux";
        laptop-personal = mkNixos ./envs/laptop-personal "x86_64-linux";
        laptop-work = mkNixos ./envs/laptop-work "x86_64-linux";
        vps-personal = mkNixos ./envs/vps-personal "x86_64-linux";
      };

      homeConfigurations = {
        "${user}-desktop-personal" = mkHome ./envs/desktop-personal;
        "${user}-laptop-personal" = mkHome ./envs/laptop-personal;
        "${user}-laptop-work" = mkHome ./envs/laptop-work;
        "${user}-remote-ssh-work" = mkHome ./envs/remote-ssh-work;
        "${user}-vps-personal" = mkHome ./envs/vps-personal;
      };

      apps.${system}.nixfmt = import ./apps/nixfmt.nix { inherit pkgs; };
    };
}
