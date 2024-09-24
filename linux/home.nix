{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs;
    import ../config/home-packages.nix pkgs inputs
    ++ [
    ];
}
