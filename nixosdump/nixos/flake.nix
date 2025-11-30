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
	pkgs = import nixpkgs {inherit system;};
  in {
    # use "nixos", or your hostname as the name of the configuration
    # it's a better practice than "default" shown in the video
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;

      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager 
	{
		home-manager.useGlobalPkgs = true;
		home-manager.useUserPackages = true;
		home-manager.users.dsudakov = import ./home.nix;

		environment.systemPackages = [
			home-manager.packages.${system}.home-manager
		];
	}
      ];
    };
    homeConfigurations.dsudakov = home-manager.lib.homeManagerConfiguration {
    	inherit pkgs;
	modules = [ ./home.nix ];
    };
  };
}
