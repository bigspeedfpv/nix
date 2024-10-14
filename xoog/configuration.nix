{
  config,
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

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "America/New_York";

  networking.hostName = "xoog";

  users.users.andy = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOKsuRGxm3xKVrfclQDfv1Q4OvUFCBwO+Gm97qm8LKVo"];
    shell = pkgs.fish;
  };

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
    ]
    ++ (with gnomeExtensions; [
      blur-my-shell
    ]);

  services.pipewire.pulse.enable = true;

  services.tailscale.enable = true;
  services.tailscale.useRoutingFeatures = "both";

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };

  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  services.sunshine = {
    enable = true;
    autoStart = true;
    package = pkgs.sunshine.override {cudaSupport = true;};
    capSysAdmin = true;
    openFirewall = true;
  };

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
  };

  system.stateVersion = "23.11";

  boot.kernelModules = ["v4l2loopback"];
  boot.extraModulePackages = [pkgs.linuxPackages.v4l2loopback];

  programs._1password = {
    enable = true;
  };

  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = ["andy"];
  };

  programs.ssh.askPassword = "";

  programs.fish.enable = true;
}
