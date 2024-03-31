{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../hardware/server.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "America/New_York";

  users.users.andy = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOKsuRGxm3xKVrfclQDfv1Q4OvUFCBwO+Gm97qm8LKVo"];
  };

  environment.systemPackages = with pkgs;
    import ../config/global-packages.nix pkgs inputs
    ++ [
      clangStdenv
      wget
    ];

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };

  services.postgresql = {
    enable = true;
    enableTCPIP = true;
  };

  system.stateVersion = "23.11";
}
