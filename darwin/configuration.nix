{
  config,
  pkgs,
  inputs,
  nix,
  ...
}: {
  services.nix-daemon.enable = true;
  nix.useDaemon = true;

  environment.shells = [pkgs.fish];
  environment.loginShell = pkgs.fish;

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
