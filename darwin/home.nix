{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./dock
  ];

  home.packages = with pkgs;
    import ../config/home-packages.nix pkgs inputs
    ++ [
      fd
      helix

      raycast

      platformio

      vlc-bin-universal
    ];

  programs = {
    kitty = {
      extraConfig = ''
        text_composition_strategy 2.0 30
        macos_option_as_alt left
        font_size 12
        macos_titlebar_color background
      '';
    };

    git = {
      signing = {
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAxWL2XZtoicDaL/UlZQGTRbs2iLN/Vpivv0nOZOMoII";
        signByDefault = true;
      };

      extraConfig = {
        gpg.format = "ssh";
        gpg.ssh.program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
      };
    };

    ssh.extraConfig = ''
      Host *
       IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    '';
  };

  local.dock = {
    enable = true;
    entries = with pkgs; [
      {path = "/Applications/Safari.app/";}
      {path = "${spotify}/Applications/Spotify.app";}
      {path = "${kitty}/Applications/Kitty.app";}
      {path = "${vesktop}/Applications/Vesktop.app";}
    ];
  };
}
