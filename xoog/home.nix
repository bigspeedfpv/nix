{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs;
    import ../config/home-packages.nix pkgs inputs
    ++ [
      _1password
      _1password-gui

      gnome-tweaks

      firefox
      vesktop

      obs-studio

      easyeffects

      steam
      heroic

      spotify
      neovim
    ];

  programs.fish = {
    enable = true;
    shellInit = ''
      direnv hook fish | source
    '';
  };

  programs.kitty = {
    enable = true;
    font = {
      name = "Comic Code Ligatures Semibold";
      size = 11;
    };
  };

  programs.zellij.enableFishIntegration = true;

  catppuccin.enable = true;
  catppuccin.flavor = "mocha";

  programs.direnv = {
    enable = true;
    enableBashIntegration = true; # see note on other shells below
    nix-direnv.enable = true;
  };

  programs.git = {
    enable = true;
    userName = "Andrew Brower";
    userEmail = "bigspeedfpv@gmail.com";

    extraConfig = ''
      [user]
        signingkey = ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAxWL2XZtoicDaL/UlZQGTRbs2iLN/Vpivv0nOZOMoII

      [gpg]
        format = ssh

      [gpg "ssh"]
        program = "/etc/profiles/per-user/andy/bin/op-ssh-sign"

      [commit]
        gpgsign = true
    '';
  };

  programs.neovim.defaultEditor = true;

  dconf = {
    enable = true;
    settings = {
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = with pkgs.gnomeExtensions; [
          blur-my-shell.extensionUuid
        ];
      };
    };
  };
}
