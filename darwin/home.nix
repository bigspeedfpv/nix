{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs;
    import ../config/home-packages.nix pkgs inputs
    ++ [
      kitty
      direnv
      qemu
      podman
      podman-compose
      ripgrep
      fd
      helix

      p4
      platformio

      nil
    ];

  programs = {
    fish = {
      enable = true;
      shellInit = ''
        direnv hook fish | source
      '';
    };

    kitty = {
      enable = true;
      theme = "Catppuccin-Mocha";
      font = {
        name = "Comic Code Ligatures Semibold";
        size = 13.5;
      };
      extraConfig = ''
        macos_titlebar_color background
        macos_option_as_alt yes
        confirm_os_window_close 0
      '';
    };

    direnv = {
      enable = true;
      enableBashIntegration = true; # see note on other shells below
      nix-direnv.enable = true;
    };

    git.signing = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAxWL2XZtoicDaL/UlZQGTRbs2iLN/Vpivv0nOZOMoII";
      signByDefault = true;
    };

    git.extraConfig = {
      gpg.format = "ssh";
      gpg.ssh.program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
    };
  };
}
