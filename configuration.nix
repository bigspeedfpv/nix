{
  config,
  pkgs,
  inputs,
  nix,
  ...
}: {
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    trusted-users = ["andy"];

    substituters = [
      "https://cache.nixos.org"
    ];
  };

  programs.fish.enable = true;

  environment.pathsToLink = ["/share/bash-completion"];

  nixpkgs.config.allowUnfree = true;
}
