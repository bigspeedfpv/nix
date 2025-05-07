{
  lib,
  pkgs,
  inputs,
  ...
}: let
  _1password-gui = pkgs._1password-gui.overrideAttrs (oldAttrs: {
    postInstall =
      (oldAttrs.postInstall or "")
      + ''
        wrapProgram $out/share/1password/1password --set NIXOS_OZONE_WL 0
      '';
  });
in {
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = lib.mkForce false;
  # boot.loader.efi.canTouchEfiVariables = true;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  time.timeZone = "America/New_York";

  networking.hostName = "pibble";

  users.users.andy = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOKsuRGxm3xKVrfclQDfv1Q4OvUFCBwO+Gm97qm8LKVo"];
    shell = pkgs.fish;
  };

  environment.sessionVariables.EDITOR = "nvim";
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  environment.systemPackages = with pkgs;
    import ../config/global-packages.nix pkgs inputs
    ++ [
      clang
      wget
      wineWowPackages.stable
      sbctl
      brightnessctl
      clipse
      wl-clipboard
      hyprpolkitagent
      inputs.hyprpaper.packages.${pkgs.system}.hyprpaper
    ];

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
    extraUpFlags = ["--advertise-exit-node"];
  };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };

  services = {
    xserver.enable = true;
    xserver.displayManager = {
      gdm.enable = true;
      defaultSession = "hyprland-uwsm";
    };
  };

  services.flatpak.enable = true;

  services.blueman.enable = true;

  programs.waybar.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
  };

  programs.gamescope.enable = true;

  programs.gamemode = {
    enable = true;
    settings.general.renice = 20;
  };

  system.stateVersion = "24.11";

  programs._1password = {
    enable = true;
  };

  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = ["andy"];
    package = _1password-gui;
  };

  programs.ssh.askPassword = "";

  programs.fish.enable = true;

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
  };

  programs.hyprlock.enable = true;

  services.hypridle.enable = true;

  xdg.portal = {
    enable = true;
  };

  nix.settings = {
    extra-substituters = ["https://hyprland.cachix.org" "https://anyrun.cachix.org"];
    extra-trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
    ];
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [25565];
    allowedUDPPorts = [4445];
  };

  networking.networkmanager.enable = true;
}
