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

  nixpkgs.hostPlatform = "aarch64-darwin";

  environment.systemPackages = import ../config/global-packages.nix pkgs inputs;

  users.users.andy.home = "/Users/andy";

  # since users.users.andy is bad in nix-darwin, country girls make do <3
  system.activationScripts.preUserActivation.text = ''
    sudo dscl . -create /Users/andy UserShell /etc/profiles/per-user/andy/bin/fish
  '';
}
