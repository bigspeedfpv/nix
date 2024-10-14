{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    alejandra.url = "github:kamadorueda/alejandra/3.0.0";
    alejandra.inputs.nixpkgs.follows = "nixpkgs";

    fh.url = "https://flakehub.com/f/DeterminateSystems/fh/*.tar.gz";
    fh.inputs.nixpkgs.follows = "nixpkgs";

    # pow.url = "git+ssh://git@github.com/bigspeedfpv/pow";
    # pow.inputs.nixpkgs.follows = "nixpkgs";

    catppuccin.url = "github:catppuccin/nix";
  };

  outputs = inputs @ {
    nixpkgs,
    nix-darwin,
    home-manager,
    agenix,
    catppuccin,
    ...
  }:
  # Build darwin flake using:
  # $ darwin-rebuild build --flake .#macioli
  {
    nixosConfigurations = {
      xoog = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          ./xoog/configuration.nix
          agenix.nixosModules.default
          catppuccin.nixosModules.catppuccin
          home-manager.nixosModules.home-manager
          {
            home-manager.backupFileExtension = "backup";
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              inherit inputs;
            };
            home-manager.users.andy = {
              imports = [
                ./home.nix
                ./xoog/home.nix
                catppuccin.homeManagerModules.catppuccin
              ];
            };
          }
        ];
        specialArgs = {inherit inputs;};
      };
    };

    darwinConfigurations = {
      macioli = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./configuration.nix
          ./darwin/configuration.nix
          agenix.darwinModules.default
          home-manager.darwinModules.home-manager
          {
            home-manager.backupFileExtension = "backup";
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              inherit inputs;
            };
            home-manager.users.andy = {
              imports = [
                ./home.nix
                ./darwin/home.nix
              ];
            };
          }
        ];
        specialArgs = {
          inherit inputs;
        };
      };
    };
  };

  nixConfig = {
    upgrade-nix-store-path-url = "https://install.determinate.systems/nix-upgrade/stable/universal";
    bash-prompt-prefix = "❄️  $name\040";
  };
}
