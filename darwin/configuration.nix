{
  config,
  pkgs,
  inputs,
  nix,
  ...
}: {
  system.stateVersion = 5;

  services.nix-daemon.enable = true;
  nix.useDaemon = true;

  environment.shells = [pkgs.fish];
  environment.loginShell = pkgs.fish;

  environment.darwinConfig = "$HOME/.config/nix-darwin/darwin/configuration.nix";

  users.users.andy = {
    home = "/Users/andy";
    shell = pkgs.fish;
  };

  programs.fish.enable = true;

  environment.systemPackages = with pkgs;
    import ../config/global-packages.nix pkgs inputs
    ++ [
      fish
    ];
}
