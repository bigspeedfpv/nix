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
  programs.zsh.enable = true;

  environment.pathsToLink = ["/share/bash-completion"];

  nix.channel.enable = false;
  nixpkgs.config.allowUnfree = true;

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 7d";
  };

  nix.optimise.automatic = true;
}
