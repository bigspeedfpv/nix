{ config, lib, pkgs, inputs, ... }:
{
    imports = [
        ../hardware/server.nix
    ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    time.timeZone = "America/New_York";

    users.users.andy = {
        isNormalUser = true;
        extraGroups = ["wheel"];
    };

    environment.systemPackages = with pkgs; import ../config/global-packages.nix pkgs inputs ++ [
        wget
    ];

    services.openssh.enable = true;

    system.stateVersion = "23.11";
}
