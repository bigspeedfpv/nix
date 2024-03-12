{ pkgs, ... }:
{
    home.packages = with pkgs; import ../config/home-packages.nix pkgs ++ [
        kitty
        direnv
    ];

    programs.git.signing = {
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAxWL2XZtoicDaL/UlZQGTRbs2iLN/Vpivv0nOZOMoII";
        signByDefault = true;
    };

    programs.git.extraConfig = {
        gpg.format = "ssh";
        gpg.ssh.program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
    };
}
