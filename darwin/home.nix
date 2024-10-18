{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs;
    import ../config/home-packages.nix pkgs inputs
    ++ [
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

      vlc-bin-universal
    ];

  programs = {
    fish = {
      enable = true;
      shellInit = ''
        direnv hook fish | source
      '';
    };

    kitty = {
      extraConfig = ''
        text_composition_strategy 2.0 30
        macos_option_as_alt left
        font_size 12
        macos_titlebar_color background
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

    ssh.extraConfig = ''
      Host *
       IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    '';
  };
}
