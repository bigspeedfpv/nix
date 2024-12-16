{
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  nixpkgs.overlays = [
    # GNOME 46: triple-buffering-v4-46
    (final: prev: {
      gnome = prev.gnome.overrideScope (gnomeFinal: gnomePrev: {
        mutter = gnomePrev.mutter.overrideAttrs (old: {
          src = pkgs.fetchFromGitLab {
            domain = "gitlab.gnome.org";
            owner = "vanvugt";
            repo = "mutter";
            rev = "triple-buffering-v4-46";
            hash = "sha256-fkPjB/5DPBX06t7yj0Rb3UEuu5b9mu3aS+jhH18+lpI=";
          };
        });
      });
    })
  ];

  boot.loader.systemd-boot.enable = lib.mkForce false;
  # boot.loader.efi.canTouchEfiVariables = true;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };

  time.timeZone = "America/New_York";

  networking.hostName = "xoog";

  users.users.andy = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOKsuRGxm3xKVrfclQDfv1Q4OvUFCBwO+Gm97qm8LKVo"];
    shell = pkgs.fish;
  };

  environment.variables.NIXOS_OZONE_WL = "1";

  environment.systemPackages = with pkgs;
    import ../config/global-packages.nix pkgs inputs
    ++ [
      clang
      wget
      pulseaudio
      corretto21
      corretto17
      lutris
      wineWowPackages.stable
      sbctl
      v4l-utils
      clipse
      wl-clipboard
      hyprpolkitagent
      inputs.hyprpaper.packages.${pkgs.system}.hyprpaper
    ]
    ++ (with gnomeExtensions; [
      blur-my-shell
    ]);

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
      defaultSession = "hyprland";
    };
  };

  services.sunshine = {
    enable = true;
    autoStart = true;
    package = pkgs.sunshine.override {cudaSupport = true;};
    capSysAdmin = true;
    openFirewall = true;
  };

  services.flatpak.enable = true;

  services.blueman.enable = true;

  environment.gnome.excludePackages = with pkgs; [
    gnome-photos
    gnome-tour
    gedit
    cheese
    gnome-music
    gnome-terminal
    epiphany
    geary
    evince
    gnome-characters
    totem
    tali
    iagno
    hitori
    atomix
  ];

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

  system.stateVersion = "23.11";

  programs._1password = {
    enable = true;
  };

  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = ["andy"];
  };

  programs.ssh.askPassword = "";

  programs.fish.enable = true;

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland];
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
