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

      firefox
    ];

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
}
