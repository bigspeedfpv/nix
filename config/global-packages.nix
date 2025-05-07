pkgs: inputs:
with pkgs; [
  btop
  cachix
  git
  neovim
  killall

  inputs.alejandra.defaultPackage.${system}
]
