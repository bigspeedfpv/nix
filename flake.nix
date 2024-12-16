{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";

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

    catppuccin.url = "github:catppuccin/nix";

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";

    hyprpaper.url = "github:hyprwm/hyprpaper";
    hyprpaper.inputs.nixpkgs.follows = "nixpkgs";

    anyrun.url = "github:anyrun-org/anyrun";
    anyrun.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    lanzaboote.url = "github:nix-community/lanzaboote/v0.4.1";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";

    ghostty.url = "git+ssh://git@github.com/ghostty-org/ghostty";

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";

    weup.url = "git+ssh://git@github.com/bigspeedfpv/weup";

    nix-flatpak.url = "https://flakehub.com/f/gmodena/nix-flatpak/0.5.0.tar.gz";
  };

  outputs = inputs @ {
    nixpkgs,
    nix-darwin,
    home-manager,
    agenix,
    catppuccin,
    nix-index-database,
    lanzaboote,
    spicetify-nix,
    nix-flatpak,
    ...
  }: {
    nixosConfigurations = {
      xoog = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          ./xoog/configuration.nix
          agenix.nixosModules.default
          catppuccin.nixosModules.catppuccin
          lanzaboote.nixosModules.lanzaboote
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
                nix-index-database.hmModules.nix-index
                spicetify-nix.homeManagerModules.default
                nix-flatpak.homeManagerModules.nix-flatpak
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
                catppuccin.homeManagerModules.catppuccin
                nix-index-database.hmModules.nix-index
                spicetify-nix.homeManagerModules.default
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
