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

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    alejandra.url = "github:kamadorueda/alejandra/3.0.0";
    alejandra.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {
    nixpkgs,
    nix-darwin,
    home-manager,
    agenix,
    ...
  }:
  # Build darwin flake using:
  # $ darwin-rebuild build --flake .#macioli
  {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          ./linux/configuration.nix
          agenix.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            nixpkgs.overlays = [inputs.neovim-nightly-overlay.overlays.default];
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.andy = {
              imports = [
                ./home.nix
                ./linux/home.nix
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
            nixpkgs.overlays = [inputs.neovim-nightly-overlay.overlays.default];
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.andy = {
              imports = [
                ./home.nix
                ./darwin/home.nix
              ];
            };
          }
        ];
        specialArgs = {inherit inputs;};
      };
    };
  };
}
